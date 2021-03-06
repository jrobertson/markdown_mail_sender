#!/usr/bin/env ruby

# file: markdown_mail_sender.rb


require 'martile'
require 'net/smtp'
require 'kramdown'
require 'fileutils'


class MarkdownMailSender

  def initialize(accounts={}, compose_dir: '~/email/compose',
       sent_dir: '~/email/sent', smtp_host: nil, from_domain: smtp_host)

    @accounts = accounts

    @smtp_host, @mail_from_domain = smtp_host, from_domain

    compose_dirpath = File.expand_path(compose_dir)
    @sent_dir = File.expand_path(sent_dir)
    FileUtils.mkdir_p @sent_dir

    # scan the compose directory for email files to deliver

    @messages = Dir.glob(File.join(compose_dirpath, '*.md')).map do |msg_filepath|

      s = File.read msg_filepath

      regex = %r{

        (?<email>(?:.*<)?[^@]+@\S+>?){0}
        (?<filepath>\s*[\w\/\.\-]+\s+){0}

        from:\s(?<from>\g<email>)\s+
        to:\s(?<to>\g<email>)\s+
        (?:attachments?:\s+(?<attachments>\g<filepath>*))?
        subject:\s+(?<subject> [^\n]+)\n
        (?<body> .*)

      }xm 
      
      r = regex.match(s)
      
      files = r[:attachments].nil? ? [] : r[:attachments].split.map(&:strip)

      {
        filepath: msg_filepath, from: r[:from], to: r[:to], 
        attachments: files, subject: r[:subject], body_txt: r[:body], 
        body_html: Kramdown::Document.new(Martile.new(r[:body], 
                                ignore_domainlabel: true).to_html).to_html
      }      

    end

  end

  def deliver_all()

    @messages.each.with_index do |x, i|
      
      raw_marker = "AUNIQUEMARKER"
      marker = "\n--#{raw_marker}"

      from, to, subject = %i(from to subject).map {|name| x[name]}
      
header =<<EOF
From: #{from}
To: #{to}
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{raw_marker}
EOF

# Define the message action
txt_part =<<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit

#{x[:body_txt]}
EOF

html_part =<<EOF
Content-Type: text/html

#{x[:body_html]}
EOF
      
      a = [header, txt_part, html_part]

      if x[:attachments].any? then
        
        attachments = x[:attachments].map {|x| file_part x}
        a.concat attachments

      end

      mailtext = a.join(marker + "\n") + marker + "--"

      from = x[:from][/(?:.*<)?(\w+(?:\.\w+)?@\S+[^>])/,1]

      user, password = from[/[^@]+/], @accounts[from]      

      Net::SMTP.start(@smtp_host, 25, @mail_from_domain, user, 
                      password, :login) do |smtp|

        smtp.send_message mailtext, from, to 

      end
      

      target = Time.now.strftime("m%d%m%yT%H%Ma")
      target.succ! while File.exists? target
      
      FileUtils.mv x[:filepath], File.join(@sent_dir, target + '.md')      
      
    end

  end

  alias deliver deliver_all
  
  def file_part(filepath)
    
    # Read a file and encode it into base64 format

    filecontent = File.read filepath
    encodedcontent = [filecontent].pack("m")   # base64
    
    filename = File.basename filepath

<<EOF
Content-Type: multipart/mixed; name="#{filename}"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{filename}"

#{encodedcontent} 
EOF

  end
  
end