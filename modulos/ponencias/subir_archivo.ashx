<%@ WebHandler Language="C#" Class="subir_archivo" %>

using System;
using System.Web;
using System.IO;
using System.Net;
using System.Text;
using System.Data;
using System.Data.SqlClient;

public class subir_archivo : IHttpHandler, System.Web.SessionState.IRequiresSessionState {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json";

        if (context.Request.Files.Count > 0)
            {
                string idponencia = Convert.ToString(HttpContext.Current.Session["idponencia"]);
                string idusuario = Convert.ToString(HttpContext.Current.Session["idusuario"]);
                string ronda = Convert.ToString(HttpContext.Current.Session["ronda"]);
                
                string folderPath = HttpContext.Current.Server.MapPath("~/ponencias/"+ idusuario + "/" + idponencia + "/" + ronda + "/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

        
                // Si existen documentos
                DirectoryInfo dir = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/ponencias/"+idusuario+"/"+idponencia+"/"));
                FileInfo[] filesCount = dir.GetFiles();
                

                HttpFileCollection files = context.Request.Files;
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    //string fname = context.Server.MapPath("~/ponencias/" + idusuario + "/" + idponencia + "/" + ronda + "/ponencia_" + idponencia + "_ronda_" + ronda + ".pdf");
                    string fname = context.Server.MapPath("~/ponencias/" + idusuario + "/" + idponencia + "/" + ronda + "/" + file.FileName);
                    string rutaBD = fname;

                    // if (File.Exists(fname))
                    // {
                    //     fname = context.Server.MapPath("~/ponencias/" + idusuario + "/" + idponencia + "/" + ronda + "/ponencia_" + idponencia + "_ronda_" + ronda + "_" + i+1 + ".pdf");
                    // }

                    file.SaveAs(fname);

                    string nombreArchivo = file.FileName;
                    string extension = Path.GetExtension(nombreArchivo);
                    string tamano = file.ContentLength.ToString();

                    fname = fname.Replace(@"C:\inetpub\wwwroot\Coloquio\", "");
                    fname = fname.Replace(@"\", "/");

                    if (extension == ".pdf"){
                        extension = "pdf";
                    } else if (extension == ".jpg" || extension == ".png" || extension == ".jfif" || extension == ".jpeg"){
                        extension = "image";
                    } else if (extension == ".doc" || extension == ".docx" || extension == ".ppt" || extension == ".pptx" || extension == ".xls" || extension == ".xlsx"){
                        extension = "office";
                    } else if (extension == ".mp4"){
                        extension = "video";
                    } else {
                        extension = "otros";
                    }

                    // Crea el objeto Request para obtener la url
					HttpRequest req = HttpContext.Current.Request;
					
					// // Obtiene el url de la página actual
					string urlActual = req.Url.ToString();
					
					// Convierte el URL usando la clase Uri
					Uri uri = new Uri(urlActual);
					
					// Obtiene lo que necesito (el protocolo "https" y el dominio "fcav-app.uat.edu.mx" + el primer segmento /coloquio/ o /cieanfeca/)
					string urlBase = uri.Scheme + "://" + uri.Host + "/" + uri.Segments[1];

                    // En buscar_archivo.ashx explico el ruteo y los puntos para preview y download
                    context.Response.Write("{\"initialPreview\": [\"" + urlBase + fname + "\"], \"initialPreviewConfig\": [{ \"type\": \""+extension+"\", \"size\": \""+tamano+"\", \"caption\": \""+nombreArchivo+"\", \"url\": \"eliminar_archivo.ashx\", \"key\": \"" + nombreArchivo +"\"}], \"initialPreviewDownloadUrl\": \"../../ponencias/"+idusuario+"/"+idponencia+"/"+ronda+"/{filename}\",  \"append\": true }");


                    // Guardar la ruta en la BD
                    using (SqlConnection Conn = conn.conecta())
                    {
                        using (SqlCommand comand = new SqlCommand("GuardarRuta", Conn))
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

                //context.Response.Write("{}");

            }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}
