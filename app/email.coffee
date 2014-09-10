nodemailer = require "nodemailer"

smtpTransport = nodemailer.createTransport
    service: "smtp.mailgun.org"
    auth:
        user: "postmaster@sandbox32938.mailgun.org"
        pass: "asdf"
###
    auth: 
        user:"rednosedingergmail.com"
        pass:"darwinding1"
###
    
    
send_email = (to, from, subject, text) ->
    options =
        to: to
        from: from
        subject: subject
        text: text

    smtpTransport.sendMail options, (error, resp) ->
        console.log "Failed to send email\n" + error or "Sent: " + resp

exports.send_email = send_email

