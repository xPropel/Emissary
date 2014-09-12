nodemailer = require "nodemailer"

smtpTransport = nodemailer.createTransport
    service: "Mailgun"
    auth:
        user: "darren@sandbox32938.mailgun.org"
        pass: "asdf"
    
    
send_email = (to, from, subject, text, attach) ->
    options =
        from: from
        to: to
        subject: subject
        text: text
        attachments: attach

    smtpTransport.sendMail options, (error, resp) ->
      console.log error or resp

exports.send_email = send_email

