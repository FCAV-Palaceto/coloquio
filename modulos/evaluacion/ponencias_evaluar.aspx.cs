using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Runtime.Remoting.Messaging;
using System.Web.Script.Serialization;

public partial class ponencias_evaluar : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string TablaListarPonencias()
    {
        string user = Convert.ToString(HttpContext.Current.Session["idusuario"]);
        string clases = string.Empty, ronda = string.Empty;
        int numRonda;
        int comentarios;
        int estado;

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarEvaluacion", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idUsuario", user);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\" width=\"15%\">Título</th><th scope=\"col\" width=\"30%\">Resumen</th><th scope=\"col\" width=\"12.5%\">Modalidad</th><th scope=\"col\" width=\"7.5%\">Ronda</th><th scope=\"col\" width=\"10%\">Estado</th><th scope=\"col\" width=\"5%\">Evaluar</th><th scope=\"col\" width=\"5%\">Ver Ponencia</th><th scope=\"col\" width=\"5%\">Enviar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        estado = Convert.ToInt32(drseldatos["estadoEvaluacion"].ToString());
                        if(estado != 3){
                            sb.Append("<tr>");
                            sb.Append("<td style=\"vertical-align:middle;\">" + drseldatos["titulo"].ToString() + "</td>");
                            sb.Append("<td style=\"vertical-align:middle;\">" + drseldatos["resumen"].ToString() + "</td>");
                            sb.Append("<td style=\"vertical-align:middle;\">" + drseldatos["modalidad"].ToString() + "</td>");
                            sb.Append("<td style=\"vertical-align:middle;text-align:center;\">" + drseldatos["ronda"].ToString() + "° Ronda</td>");                                                
                            switch(estado){                            
                                case 1:
                                    sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning\" style=\"font-size:14px;color:#000\">No Terminada</span></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success\" onclick=\"evaluar(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["idEvaluacion"].ToString() + ");\"><i class=\"fa-regular fa-clipboard\"></i></button></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-dark\" onclick=\"verPonencia(" + drseldatos["idPonencia"].ToString() + ", "+ HttpContext.Current.Session["idusuario"].ToString() + ", "+ drseldatos["ronda"].ToString() + ", "+ drseldatos["idUsuario"].ToString() +");\"><i class=\"fa-solid fa-magnifying-glass\"></i></button></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary\" onclick=\"notificacionEnviar();\"><i class=\"fa-solid fa-share text-white\"></i></i></button></td>");
                                    break;
                                case 2:
                                    sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning text-dark\" style=\"font-size:14px;\">Envío Pendiente</span></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success\" onclick=\"evaluar(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["idEvaluacion"].ToString() + ");\"><i class=\"fa-regular fa-clipboard\"></i></button></td>");
                                   sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-dark\" onclick=\"verPonencia(" + drseldatos["idPonencia"].ToString() + ", "+ HttpContext.Current.Session["idusuario"].ToString() + ", "+ drseldatos["ronda"].ToString() + ", "+ drseldatos["idUsuario"].ToString() +");\"><i class=\"fa-solid fa-magnifying-glass\"></i></button></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info btn-pulse pulsing\" onclick=\"showModal(" + drseldatos["idEvaluacion"].ToString() + ",'" + drseldatos["titulo"].ToString() + "'," + drseldatos["aptoPublicacion"].ToString() + "," + drseldatos["total"].ToString() + "," + drseldatos["puntos"].ToString() + ");\"><i class=\"fa-solid fa-share text-white\"></i></i></button></td>");
                                    // Para resaltar el botón
                                    //sb.Append("<script>");
                                    //sb.Append("const btn = document.querySelector('.btn-pulse');");
                                    //sb.Append("setTimeout(() => {");
                                    //sb.Append("  btn.classList.add('pulsing');");
                                    //sb.Append("  setTimeout(() => {");
                                    //sb.Append("    btn.classList.remove('pulsing');");
                                    //sb.Append("  }, 1500);");
                                    //sb.Append("  setInterval(() => {");
                                    //sb.Append("    btn.classList.add('pulsing');");
                                    //sb.Append("    setTimeout(() => {");
                                    //sb.Append("      btn.classList.remove('pulsing');");
                                    //sb.Append("    }, 1500);");
                                    //sb.Append("  }, 7000);");
                                    //sb.Append("}, 1500);");
                                    //sb.Append("</script>");
                                    break;
                                default:
                                    sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-dark\" style=\"font-size:14px;\">No evaluada</span></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success\" onclick=\"evaluar(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["idEvaluacion"].ToString() + ");\"><i class=\"fa-regular fa-clipboard\"></i></button></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-dark\" onclick=\"verPonencia(" + drseldatos["idPonencia"].ToString() + ", "+ HttpContext.Current.Session["idusuario"].ToString() + ", "+ drseldatos["ronda"].ToString() + ", "+ drseldatos["idUsuario"].ToString() +");\"><i class=\"fa-solid fa-magnifying-glass\"></i></button></td>");
                                    sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary\" onclick=\"notificacionEnviar();\"><i class=\"fa-solid fa-share text-white\"></i></i></button></td>");
                                    break;
                            }                                               
                            sb.Append("</tr>");
                        }
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Ponencias</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay evaluaciones pendientes.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }


    [WebMethod]
    public static string evaluar(int id, int idEvaluacion)
    {
        int Exitoso = 1;
        HttpContext.Current.Session["idponencia"] = id;
        // HttpContext.Current.Session["titulo"] = titulo;
        HttpContext.Current.Session["idEvaluacion"] = idEvaluacion;
        return "{\"Success\": \"" + Exitoso + "\"}";
    }

    [WebMethod]
    public static string enviar(int id)
    {
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EnviarEvaluacion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idEvaluacion", SqlDbType.Int).Value = id;

                Conn.Open();
                comand.ExecuteNonQuery();                
            }
            Conn.Close();
            return "{\"success\": \"" + 1 + "\"}";
        }
    }


    [WebMethod]
    public static string TraeDatos(int id)
    {
        string jsonString = String.Empty;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("TraeDatos", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@id", SqlDbType.Int).Value = id;
                Conn.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var obj = new
                        {                            
                            tema = dr["tema"].ToString(),
                            modalidad = dr["modalidad"].ToString(),
                            titulo = dr["titulo"].ToString(),
                            resumen = dr["resumen"].ToString(),
                            palabrasClave = dr["palabrasClave"].ToString()
                        };

                        var serializer = new JavaScriptSerializer();
                        jsonString = serializer.Serialize(obj);
                    }
                    dr.Close();
                }
            }
            Conn.Close();
        }
        // HttpContext.Current.Session["idponencia"] = id;

        return jsonString;
    }


    //[WebMethod]
    //public static string VerComentarios(int id)
    //{        
    //    StringBuilder sb = new StringBuilder();
    //    using (SqlConnection con = conn.conecta())
    //    {
    //        using (SqlCommand seldata = new SqlCommand("VerComentarios", con))
    //        {
    //            seldata.CommandType = CommandType.StoredProcedure;
    //            seldata.Parameters.AddWithValue("@idPonencia", id);
    //            con.Open();
    //            using (SqlDataReader drseldatos = seldata.ExecuteReader())
    //            {
    //                if (drseldatos.HasRows)
    //                    sb.Append("<table id=\"tablaComentarios\" class=\"table table-striped table-bordered w-100\"><thead><tr><th scope=\"col\">Fecha</th><th scope=\"col\">Evaluador</th><th scope=\"col\">Comentarios</th><th scope=\"col\">Ronda</th></tr></thead><tbody>");
    //                while (drseldatos.Read())
    //                {
    //                    sb.Append("<tr>");
    //                    sb.Append("<td>" + drseldatos["fecha"].ToString() + "</td>");
    //                    sb.Append("<td>" + drseldatos["evaluador"].ToString() + "</td>");
    //                    sb.Append("<td>" + drseldatos["comentarios"].ToString() + "</td>");
    //                    sb.Append("<td>" + drseldatos["ronda"].ToString() + "</td>");
    //                    sb.Append("</tr>");                        
    //                }

    //                if (drseldatos.HasRows)
    //                {
    //                    sb.Append("</tbody></table>");
    //                }
    //                else
    //                {
    //                    //Aquí tengo que encontrar la lógica para cuando no haya comentarios poder saberlo en js
    //                }
    //                drseldatos.Close();
    //            }
    //        }
    //        con.Close();
    //        return sb.ToString();
    //    }
    //}
}
