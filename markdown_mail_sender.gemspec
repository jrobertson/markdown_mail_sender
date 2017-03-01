Gem::Specification.new do |s|
  s.name = 'markdown_mail_sender'
  s.version = '0.1.4'
  s.summary = 'Sends an email from a file directory containing a Markdown file representing the email message.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/markdown_mail_sender.rb']
  s.add_runtime_dependency('rdiscount', '~> 2.2', '>=2.2.0.1')
  s.signing_key = '../privatekeys/markdown_mail_sender.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/markdown_mail_sender'
end
