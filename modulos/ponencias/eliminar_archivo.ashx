<%@ WebHandler Language="C#" Class="eliminar_archivo" %>

using System;
using System.IO;
using System.Web;
using System.Web.SessionState;
using System.Text;
using System.Net;
using System.Data;
using System.Data.SqlClient;

public class eliminar_archivo : IHttpHandler, IReadOnlySessionState {

    public void ProcessRequest (HttpContext context) {
        string idponencia = Convert.ToString(HttpContext.Current.Session["idponencia"]);
        string idusuario = Convert.ToString(HttpContext.Current.Session["idusuario"]);
        string ronda = Convert.ToString(HttpContext.Current.Session["ronda"]);

        // Obtener la lista de archivos en la carpeta
        DirectoryInfo dir = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/ponencias/"+idusuario+"/"+idponencia+"/"+ronda+"/"));

        // Guarda los archivos en un array
        FileInfo[] files = dir.GetFiles();

        // Recupera el key del archivo
        HttpRequest request = context.Request;
        string archivo = request["key"];

        foreach (FileInfo item in files){
            if (item.Name == archivo){
                // Obtener la ruta del archivo
                string ruta = item.FullName;
                string rutaBD = ruta;
                //Borra el archivo
                // string ruta = @"C:\inetpub\wwwroot\Coloquio\ponencias\" + idusuario + "\\" + idponencia+ "\\" + ronda;
                // Directory.Delete(ruta,true);
                File.Delete(ruta);

                // Eliminar la ruta en la BD
                using (SqlConnection Conn = conn.conecta())
                {
                    using (SqlCommand comand = new SqlCommand("EliminarRuta", Conn))
                    {
                        comand.CommandType = CommandType.StoredProcedure;
                        comand.Parameters.Add("@id", SqlDbType.Int).Value = idponencia;
                        comand.Parameters.Add("@ruta", SqlDbType.NVarChar, 100).Value = rutaBD;
                        comand.Parameters.Add("@ronda", SqlDbType.Int).Value = ronda;

                        Conn.Open();
                        comand.ExecuteNonQuery();
                    }
                    Conn.Close();
                }
            }
        }

        context.Response.ContentType = "application/json";
        context.Response.Write("{}");

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}
