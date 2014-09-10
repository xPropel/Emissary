nodemailer = require "nodemailer"

smtpTransport = nodemailer.createTransport("SMTP", 
    service: "Mailgun"
    auth: 
        user:"darren@sandbox32938.mailgun.org"
        pass:"asdf"
    )
    
send_email = (to, from, subject, text) ->
    options =
        to: to
        from: from
        subject: subject
        text: text

    smtpTransport.sendMail options, (error, resp) ->
        console.log error or resp

exports.send_email = send_email

