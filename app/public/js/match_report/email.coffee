nodemailer = require "nodemailer"

MG_USER = process.env.MAILGUN_SMTP_LOGIN
MG_PASS = process.env.MAILGUN_SMTP_PASSWORD

smtpTransport = nodemailer.createTransport
    service: "Mailgun"
    auth:
        user: MG_USER
        pass: MG_PASS
    
    
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

