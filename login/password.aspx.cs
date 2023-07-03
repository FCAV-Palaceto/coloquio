using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Net.Mail;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Net;


public partial class password : System.Web.UI.Page
{
    string tipoUsu;
    protected void Page_Load(object sender, EventArgs e)
    {
        tipoUsu = Convert.ToString(HttpContext.Current.Session["tipoUsu"]);
        // Si existe sesión regresa al la página anterior
        if (!(tipoUsu.Equals("")) && HttpContext.Current.Session["returnPath"] != null)
        {
           HttpContext.Current.Response.Redirect(Session["returnPath"].ToString());
        }    
    }

    [WebMethod]
    public static string Recuperar(string correo)
    {
        int Exitoso = 0;
        string Contra = "", Email = "", Pass = "";
        using (SqlConnection Conn= conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("Restablecer",Conn))
            {
                comand.CommandType= CommandType.StoredProcedure;
                comand.Parameters.Add("@Correo", SqlDbType.NVarChar, 50).Value = correo;
                SqlParameter contra = comand.Parameters.Add("@Contra", SqlDbType.NVarChar, 50);
                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                SqlParameter pemail = comand.Parameters.Add("@Email", SqlDbType.NVarChar, 50);
                SqlParameter ppass = comand.Parameters.Add("@Pass", SqlDbType.NVarChar, 50);
                contra.Direction = ParameterDirection.Output;
                pexitoso.Direction = ParameterDirection.Output;
                pemail.Direction = ParameterDirection.Output;
                ppass.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Contra = contra.Value.ToString();
                Exitoso = int.Parse(pexitoso.Value.ToString());
                Email = pemail.Value.ToString();
                Pass = ppass.Value.ToString();
                if (Exitoso == 1){
                    using (MailMessage mm = new MailMessage(Email.Trim(), correo.Trim()))
                    {
                        mm.Subject = "Recuperar contraseña";
                        mm.Body = "Estimado(a) <br/><br/>le enviamos su contraseña la cual esta ligada a la siguiente cuenta de correo: <b>" + correo + "</b><br/><br/>Contraseña: <b>" + Contra + "</b><br/><br/>Si necesita asistencia, envíe un correo a una de las siguientes cuentas: " + Email.Trim() + ", jmedinaq@uat.edu.mx<br /><br />Saludos cordiales".Trim();
                        mm.IsBodyHtml = true;
                        SmtpClient smtp = new SmtpClient();
                        smtp.Host = "smtp.office365.com";
                        smtp.EnableSsl = true;
                        NetworkCredential networkCred = new NetworkCredential (Email.Trim(), Pass.Trim());
                        smtp.UseDefaultCredentials = true;
                        smtp.Credentials = networkCred;
                        smtp.Port = 587;
                        smtp.Send(mm);
                    }
                }
            }
            Conn.Close();
        }
        return "{\"success\":\"" + Exitoso + "\"}";
    }
}