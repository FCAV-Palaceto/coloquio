<%@ WebHandler Language="C#" Class="ver_archivo" %>

using System;
using System.Web;
using System.Text;
using System.IO;
using System.Net;

public class ver_archivo : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/html";
        string idPonencia = context.Request.Params["idPon"];
        string idUsuario = context.Request.Params["idUsu"];
        string Ronda = context.Request.Params["Ronda"];

        if (idPonencia.Equals("")){
            context.Response.Write("<script>alert('Ocurrió un error. Favor de volver a intentarlo');</script>");
            return;
        }

        StringBuilder sbArchivos = new StringBuilder();

        // Comprobar si existe la carpeta
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/ponencias/"+idUsuario+"/"+idPonencia+"/"+Ronda+"/")))
        {
            // Si existen documentos
            DirectoryInfo dir = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/ponencias/"+idUsuario+"/"+idPonencia+"/"+Ronda+"/"));

            FileInfo[] files = dir.GetFiles();

            if (files.Length > 0)
            {            
                sbArchivos.Append("<script>$");
                sbArchivos.Append("('#file-input').fileinput('destroy');");
                sbArchivos.Append("$('#file-input').fileinput({");
                sbArchivos.Append("theme: 'fa5',");
                sbArchivos.Append("language: 'es',");
                sbArchivos.Append("showClose: false,");
                sbArchivos.Append("showBrowse:false,");
                sbArchivos.Append("showCaption: false,");
                sbArchivos.Append("dropZoneTitle: false,");
                sbArchivos.Append("showUpload: false,");
                sbArchivos.Append("showRemove: false,");
                sbArchivos.Append("initialPreviewShowDelete: false,");
                sbArchivos.Append("maxFileSize: 8192,");
                sbArchivos.Append("maxFileCount: 2,");
                sbArchivos.Append("overwriteInitial: false,");
                sbArchivos.Append("initialPreviewAsData: true,");
                sbArchivos.Append("initialPreviewFileType: 'image',");                
                sbArchivos.Append("browseOnZoneClick: false,");
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
                    // Tengo que hacer lo de urlBase para que el preview funcione (Archivos de office necesitan salida a internet)
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
                        sbArchivos.Append("{ type: \""+extension+"\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", key: \""+nombreArchivo+"\" }, ");
                    } else if (extension == "jpg" || extension == "png" || extension == "jfif" || extension == "jpeg"){
                        sbArchivos.Append("{ type: \"image\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", key: \""+nombreArchivo+"\" }, ");
                    } else if (extension == "doc" || extension == "docx" || extension == "ppt" || extension == "pptx" || extension == "xls" || extension == "xlsx"){
                        sbArchivos.Append("{ type: \"office\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", key: \""+nombreArchivo+"\" }, ");
                    } else if (extension == "mp4"){
                        sbArchivos.Append("{ type: \"video\", size: \""+tamano+"\", caption: \""+nombreArchivo+"\", key: \""+nombreArchivo+"\" }, ");
                    } else {
                        sbArchivos.Append("{ size: \""+tamano+"\", caption: \""+nombreArchivo+"\", key: \""+nombreArchivo+"\" }, ");
                    }
                }
                // lo mismo que rutaCompleta arriba, para descargar archivos, esta sí es la ruta local, aunque según yo igual funcionaría con la otra
                sbArchivos.Append("], initialPreviewDownloadUrl: \"../../ponencias/"+idUsuario+"/"+idPonencia+"/{filename}\" });");
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