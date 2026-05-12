using System;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace Wedding.Application.Services
{
    public class EmailService : IEmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendEmailAsync(string toEmail, string subject, string htmlBody)
        {
            // Configuration for Brevo (Sendinblue) or standard SMTP
            var host = _configuration["SmtpSettings:Host"] ?? "smtp-relay.brevo.com";
            var port = int.Parse(_configuration["SmtpSettings:Port"] ?? "587");
            var username = _configuration["SmtpSettings:Username"] ?? "YOUR_BREVO_EMAIL@example.com";
            var password = _configuration["SmtpSettings:Password"] ?? "YOUR_BREVO_SMTP_KEY";
            var fromEmail = _configuration["SmtpSettings:FromEmail"] ?? "no-reply@wedding.com";
            var fromName = _configuration["SmtpSettings:FromName"] ?? "Nerea & Ivan";

            using var client = new SmtpClient(host, port)
            {
                Credentials = new NetworkCredential(username, password),
                EnableSsl = true
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress(fromEmail, fromName),
                Subject = subject,
                Body = htmlBody,
                IsBodyHtml = true
            };

            mailMessage.To.Add(toEmail);

            try
            {
                Console.WriteLine($"[EmailService] Intentando enviar correo a: {toEmail}...");
                await client.SendMailAsync(mailMessage);
                Console.WriteLine($"[EmailService] ✅ Correo enviado con éxito a: {toEmail}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[EmailService] ❌ Error enviando correo a {toEmail}: {ex.Message}");
                if (ex.InnerException != null)
                {
                    Console.WriteLine($"[EmailService] Detalle interno: {ex.InnerException.Message}");
                }
            }
        }
    }
}
