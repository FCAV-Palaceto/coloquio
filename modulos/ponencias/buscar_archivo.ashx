<%@ WebHandler Language="C#" Class="buscar_archivo" %>

using System;
using System.Web;
using System.Text;
using System.IO;
using System.Net;
using System.Web.SessionState;

public class buscar_archivo : IHttpHandler, IReadOnlySessionState {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/html";

        StringBuilder sbArchivos = new StringBuilder();
        string idponencia = Convert.ToString(HttpContext.Current.Session["idponencia"]);
        string idusuario = Convert.ToString(HttpContext.Current.Session["idusuario"]);
        string ronda = Convert.ToString(HttpContext.Current.Session["ronda"]);

        // Comprobar si existe la carpeta
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/ponencias/"+idusuario+"/"+idponencia+"/"+ronda+"/")) && idponencia != "0")
        {
            // Si existen documentos
            DirectoryInfo dir = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/ponencias/"+idusuario+"/"+idponencia+"/"+ronda+"/"));

            FileInfo[] files = dir.GetFiles();

            if (files.Length > 0)
            {
                sbArchivos.Append("<script>$");
                sbArchivos.Append("('#file-input').fileinput('destroy');");
                sbArchivos.Append("$('#file-input').fileinput({");
                sbArchivos.Append("theme: 'fa5',");
                sbArchivos.Append("language: 'es',");
                sbArchivos.Append("uploadUrl: 'subir_archivo.ashx',");
                sbArchivos.Append("maxFileSize: 8192,");
                sbArchivos.Append("maxFileCount: 2,");
                sbArchivos.Append("overwriteInitial: false,");
                sbArchivos.Append("initialPreviewAsData: true,");
                sbArchivos.Append("initialPreviewFileType: 'image',");                
                sbArchivos.Append("browseOnZoneClick: true,");
                sbArchivos.Append("validateInitialCount: true,");
                sbArchivos.Append("allowedFileExtensions: ['doc', 'docx'],");
                //sbArchivos.Append("preferIconicPreview: true,");
                sbArchivos.Append("previewFileIconSettings: {'doc': '<i class = \"fas fa-file-word text-primary\"></i>'},");
                sbArchivos.Append("previewFileExtSettings: {'doc': function(ext) { return ext.match(/(doc|docx)$/i); } },");
                sbArchivos.Append("initialPreview: [");

                foreach (FileInfo item in files)
                {
					// Crea el objeto Request para obtener la url
					HttpRequest req = HttpContext.Current.Request;
					
					// // Obtiene el url de la página actual
					string urlActual = req.Url.ToString();
					
					// Convierte el URL usando la clase Uri
					Uri uri = new Uri(urlActual);
					
					// Obtiene lo que necesito (el protocolo "https" y el dominio "fcav-app.uat.edu.mx" + el primer segmento /coloquio/ o /cieanfeca/)
					string urlBase = uri.Scheme + "://" + uri.Host + "/" + uri.Segments[1];
					
                    string rutaCompleta = item.FullName;
                    //Cuidado con esta ruta
                    rutaCompleta = rutaCompleta.Replace(@"C:\inetpub\wwwroot\Coloquio\", "");
                    rutaCompleta = rutaCompleta.Replace(@"\", "/");
                    // Los puntitos son para retroceder carpetas ya que ponencias_registrar está 2 carpetas arriba de la carpeta donde se guardan las ponencias
                    // Tengo que retroceder en las opciones del plugin o estas carpetas se sumaran a la ruta final(?)
                    sbArchivos.Append("'" + urlBase + rutaCompleta + "',");
                }
                sbArchivos.Append("], initialPreviewConfig: [");
                foreach (FileInfo item in files)
                {
                    string nombreArchivo = item.Name;
                    string extension = Path.GetExtension(nombreArchivo);
                    string tamano = (item.Length).ToString();
                    extension = extension.Replace(".", "");
                    if (extension == "pdf"){
                        sbArchivos.Append("{ type: \""+extension+"\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", url: \"eliminar_archivo.ashx\", key: \""+nombreArchivo+"\" }, ");
                    } else if (extension == "jpg" || extension == "png" || extension == "jfif" || extension == "jpeg"){
                        sbArchivos.Append("{ type: \"image\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", url: \"eliminar_archivo.ashx\", key: \""+nombreArchivo+"\" }, ");
                    } else if (extension == "doc" || extension == "docx" || extension == "ppt" || extension == "pptx" || extension == "xls" || extension == "xlsx"){
                        sbArchivos.Append("{ type: \"office\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", url: \"eliminar_archivo.ashx\", key: \""+nombreArchivo+"\" }, ");
                    } else if (extension == "mp4"){
                        sbArchivos.Append("{ type: \"video\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", url: \"eliminar_archivo.ashx\", key: \""+nombreArchivo+"\" }, ");
                    } else {
                        sbArchivos.Append("{ size: \""+tamano+"\", caption: \""+nombreArchivo+"\", url: \"eliminar_archivo.ashx\", key: \""+nombreArchivo+"\" }, ");
                    }
                }
                // lo mismo que rutaCompleta arriba, para descargar archivos
                sbArchivos.Append("],  initialPreviewDownloadUrl: \"../../ponencias/"+idusuario+"/"+idponencia+"/"+ronda+"/{filename}\" });");
                sbArchivos.Append("$('#btnGuardar').removeClass('btn-secondary');");
                sbArchivos.Append("$('#btnGuardar').addClass('btn-primary');");
                sbArchivos.Append("</script>");
            }
            else
            {
                sbArchivos.Append("");
            }
        }
        else
        {
            sbArchivos.Append("");
        }

        context.Response.Write(sbArchivos.ToString());
        context.Response.End();
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}