# Sending an email using the markdown_mail_sender gem

    require 'markdown_mail_sender'

    user, password = 'alice', 'password'

    mgs = MarkdownMailSender.new(user, password, 
            compose_dir: '/tmp/email/compose', sent_dir: '/tmp/email/sent', 
            smtp_host: 'mail.jamesrobertson.eu')

    mgs.deliver_all

## Examples

Save your Markdown file (with a .md file extension) in the compose directory (e.g. /tmp/email/compose). Here's a few examples:

### Sending a message

<pre>
from: james@jamesrobertson.eu
to: jr001@jamesrobertson.eu

subject: Test message 3

Hi, this is just a test message to see if it will actually send a message in **H
TML format** as well as plain text.

Hope it works!

James
</pre>

### Sending a message with an attachment

<pre>
from: james@jamesrobertson.eu
to: jr001@jamesrobertson.eu
attachment:  /tmp/test1.txt

subject: Test message 4

Hi, this is just a test message to see if it will actually send a message in **H
TML format** as well as plain text.

Hope it works!

James
</pre>

### Sending a message with multiple attachments

<pre>
from: james@jamesrobertson.eu
to: jr001@jamesrobertson.eu
attachments: 
  /tmp/test1.txt
  /tmp/test2.txt

subject: Test message 4

Hi, this is just a test message to see if it will actually send a message in **H
TML format** as well as plain text.

Hope it works!

James
</pre>

## Resources

* markdown_mail_sender https://rubygems.org/gems/markdown_mail_sender

## See also

* Introducing the markdown_gmail_sender gem http://www.jamesrobertson.eu/snippets/2016/may/31/introducing-the-markdown_gmail_sender-gem.html

smtp mail email gem markdown_mail_sender
