using System.Collections.Generic;
using System.Text;

namespace Wedding.Application.Services
{
    public static class EmailTemplateEngine
    {
        public static string GenerateConfirmationEmail(string familyName, string contactEmail, int totalGuests, string detailsHtml)
        {
            var template = @"
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
        .container { background-color: #ffffff; padding: 30px; border-radius: 8px; max-width: 600px; margin: 0 auto; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #8c2239; text-align: center; }
        p { color: #333333; line-height: 1.6; }
        .details { background-color: #fdfaf4; padding: 15px; border-radius: 5px; margin-top: 20px; border-left: 4px solid #8c2239; }
        .footer { text-align: center; margin-top: 30px; font-size: 12px; color: #888888; }
    </style>
</head>
<body>
    <div class='container'>
        <h1>¡Confirmación Recibida!</h1>
        <p>Hola <strong>{{FamilyName}}</strong>,</p>
        <p>¡Muchas gracias por confirmar tu asistencia a nuestra boda! Estamos muy felices de poder compartir este día tan especial con vosotros.</p>
        
        <div class='details'>
            <p><strong>Resumen de confirmación:</strong></p>
            <p>Total de asistentes confirmados: <strong>{{TotalGuests}}</strong></p>
            <hr />
            {{DetailsHtml}}
        </div>
        
        <p>Si necesitas realizar algún cambio, no dudes en contactarnos directamente.</p>
        <p>¡Nos vemos muy pronto!</p>
        <p>Con cariño,<br>Nerea e Iván</p>
    </div>
    <div class='footer'>
        <p>Este es un correo automático, por favor no respondas a este mensaje.</p>
    </div>
</body>
</html>";

            var replacements = new Dictionary<string, string>
            {
                { "{{FamilyName}}", familyName },
                { "{{TotalGuests}}", totalGuests.ToString() },
                { "{{DetailsHtml}}", detailsHtml }
            };

            var sb = new StringBuilder(template);
            foreach (var kvp in replacements)
            {
                sb.Replace(kvp.Key, kvp.Value);
            }

            return sb.ToString();
        }
    }
}
