nodemailer = require "nodemailer"

smtpTransport = nodemailer.createTransport
    service: "Mailgun"
    auth:
        user: "darren@app29370737.mailgun.org"
        pass: "asdf"
    
    
send_email = (to, from, subject, text, attach) ->
    options =
        from: from
        to: to
        subject: subject
        text: text
        attachments: attach

    smtpTransport.sendMail options, (error, resp) ->
      console.log error or "Email sent successfully (#{subject})"
    
    smtpTransport.close()

exports.send_email = send_email

