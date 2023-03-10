defmodule Thamani.Mailer do
  @config domain: Application.get_env(:thamani, :mailgun_domain),
          key: Application.get_env(:thamani, :mailgun_key)
  use Mailgun.Client, @config

  def welcome_email(email, code) do
    send_email(
      to: email,
      from: "Thamani Online <support@thmanionline.com>",
      subject: "Confirmation Email!",
      html:
        "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml'>
 <head>
  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
  <title> Email </title>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'/>
</head>
<body>
<div style='background:#eee;width:100%;height:500px;padding-top:50px;border: 2px dotted #e5e5e5;'>
<table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border-collapse: collapse;border: 2px dotted #e5e5e5;'>
<tr>
<td align='center' bgcolor='gold' style='padding: 10px 0 10px 0;'>
<img src='https://www.thamanionline.com/images/thamani_logo.png' alt='Creating Email' width='400' height='55' style='display: block;' />
</td>
 </tr>

 <tr>
<td bgcolor='ghostwhite' style='padding: 40px 30px 40px 30px;'>
        <table border='0' cellpadding='0' cellspacing='0' width='100%'>
        <tr>
        <td style='padding: 20px 0 30px 0;'>
           <strong><p>Thanks for joining Thamani Online </p><p> Find below the confirmation code</p><p style='font-size: 20px;color: black;background: gainsboro;text-align: center;'> " <>
          code <> "</p></strong>
        </td>
        </tr>
        <tr>

        </tr>
        </table>
  </td>
 </tr>

 <tr>
 <td bgcolor='#ef001d' style='padding: 30px 30px 30px 30px;color: #f5f5f5;'>
         <table border='0' cellpadding='0' cellspacing='0' width='100%'>
        <tr>
        <td width='75%'>
          &copy;
          <script>
              document.write(new Date().getFullYear())
          </script> Thamani Online. All Rights Reserved<br/>

            </td>
          <td width='25%'>
          Thamani Online
         </td>
        </tr>
        </table>
  </td>
 </tr>
</table>
</div>
</body>
</html>",
      text: "Thanks for joining!"
    )
  end

  def reset_email(email, code) do
    send_email(
      to: email,
      from: "Thamani Online <support@thmanionline.com>",
      subject: "Reset Email!",
      html:
        "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
 <html xmlns='http://www.w3.org/1999/xhtml'>
  <head>
   <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
   <title> Email </title>
   <meta name='viewport' content='width=device-width, initial-scale=1.0'/>
 </head>
 <body>
 <div style='background:#eee;width:100%;height:500px;padding-top:50px;border: 2px dotted #e5e5e5;'>
 <table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border-collapse: collapse;border: 2px dotted #e5e5e5;'>
 <tr>
 <td align='center' bgcolor='gold' style='padding: 10px 0 10px 0;'>
 <img src='https://www.thamanionline.com/images/thamani_logo.png' alt='Creating Email' width='400' height='55' style='display: block;' />
 </td>
  </tr>

  <tr>
 <td bgcolor='ghostwhite' style='padding: 40px 30px 40px 30px;'>
         <table border='0' cellpadding='0' cellspacing='0' width='100%'>
         <tr>
         <td style='padding: 20px 0 30px 0;'>
           <strong><p>You are about to reset your Thamani online password.If this is not you kindly call us immediately</p><p> Find below the reset code</p><p style='font-size: 20px;color: black;background: gainsboro;text-align: center;'> " <>
          code <> "</p></strong>
         </td>
         </tr>
         <tr>

         </tr>
         </table>
   </td>
  </tr>

  <tr>
  <td bgcolor='#ef001d' style='padding: 30px 30px 30px 30px;color: #f5f5f5;'>
          <table border='0' cellpadding='0' cellspacing='0' width='100%'>
         <tr>
         <td width='75%'>
           &copy;
           <script>
               document.write(new Date().getFullYear())
           </script> Thamani Online. All Rights Reserved<br/>

             </td>
           <td width='25%'>
           Thamani Online
          </td>
         </tr>
         </table>
   </td>
  </tr>
 </table>
 </div>
 </body>
 </html>",
      text: "Thanks for joining!"
    )
  end

  def verify_email(email) do
    send_email(
      to: email,
      from: "support@thmanionline.com",
      subject: "Welcome to thamani online!",
      html: "
                     <strong><p>Thanks for joining Thamani Online </p></strong>",
      text: "Thanks for joining!"
    )
  end
end
