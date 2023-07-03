using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Web.Services;
using System.Net;
using System.Net.Mail;

public partial class register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string Guardar(string nombre, string apellido, string email, string psw, string grado, string institucion, string dependencia, string ciudad, string estado, string telefono, string curp)
    {
        int Exitoso = 0;
        string Correo = "", Contra="";
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarDatos", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@nombre", SqlDbType.NVarChar, 50).Value = nombre;
                comand.Parameters.Add("@apellido", SqlDbType.NVarChar, 50).Value = apellido;
                comand.Parameters.Add("@email", SqlDbType.NVarChar, 50).Value = email;
                comand.Parameters.Add("@pass", SqlDbType.NVarChar, 50).Value = psw;
                comand.Parameters.Add("@grado", SqlDbType.NVarChar, 50).Value = grado;
                comand.Parameters.Add("@institucion", SqlDbType.NVarChar, 200).Value = institucion;
                comand.Parameters.Add("@dependencia", SqlDbType.NVarChar, 50).Value = dependencia;
                comand.Parameters.Add("@ciudad", SqlDbType.NVarChar, 50).Value = ciudad;
                comand.Parameters.Add("@estado", SqlDbType.NVarChar, 50).Value = estado;
                comand.Parameters.Add("@telefono", SqlDbType.NChar, 10).Value = telefono;
                comand.Parameters.Add("@curp", SqlDbType.NVarChar, 20).Value = curp;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                SqlParameter pcorreo = comand.Parameters.Add("@Correo", SqlDbType.NVarChar, 50);
                SqlParameter ppass = comand.Parameters.Add("@Contra", SqlDbType.NVarChar, 50);
                pexitoso.Direction = ParameterDirection.Output;
                pcorreo.Direction = ParameterDirection.Output;
                ppass.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
                Correo = pcorreo.Value.ToString();
                Contra = ppass.Value.ToString();
            }
            Conn.Close();

            if(Exitoso == 1){
                using (MailMessage mm = new MailMessage(Correo.Trim(), email.Trim()))
            {
                mm.Subject = "Registro exitoso";
                mm.Body = "Estimado(a): " + nombre + " " + apellido + "<br /><br />Le informamos que su registro se ha realizado correctamente.<br /><br />Para ingresar al sistema utilice las siguientes credenciales: <br /><br /><b>Usuario:</b> " + email.Trim() + "<br /><b>Contraseña:</b> " + psw.Trim() + "<br /><br />Para subir una ponencia ingrese a o pegue en el navegador el siguiente enlace: <a href=\"https://fcav-app.uat.edu.mx/cieanfeca/login/login.aspx\">https://fcav-app.uat.edu.mx/cieanfeca/login/login.aspx</a><br /><br />Si necesita asistencia, envíe un correo a una de las siguientes cuentas: " + Correo.Trim() + ", jmedinaq@uat.edu.mx<br /><br />Saludos cordiales".Trim();
                mm.Attachments.Add(new Attachment(@"C:\inetpub\wwwroot\coloquio\assets\doc\Manual_Ponencia.pdf"));
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.office365.com";
                smtp.EnableSsl = true;
                NetworkCredential networkCred = new NetworkCredential(Correo.Trim(), Contra.Trim());
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = networkCred;
                smtp.Port = 587;
                smtp.Send(mm);
            }
            }
            
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }
}