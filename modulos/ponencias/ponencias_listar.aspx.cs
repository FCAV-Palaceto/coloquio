using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.IO;

public partial class ponencias_listar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string TablaListarPonencias()
    {
        int user = Convert.ToInt32(HttpContext.Current.Session["idusuario"]);

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarPonencias", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idUsuario", user);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\" width=\"45%\">Título</th><th scope=\"col\" width=\"10%\">Ronda</th><th scope=\"col\" width=\"15%\">Estado</th><th scope=\"col\" width=\"10%\">Editar</th><th scope=\"col\" width=\"10%\">Eliminar</th><th scope=\"col\" width=\"10%\">Comentarios</th><th scope=\"col\" width=\"10%\">Enviar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        int resultado = Convert.ToInt32(drseldatos["estado"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td style=\"vertical-align:middle;align:center\">" + drseldatos["titulo"].ToString() + "</td>");
                        sb.Append("<td style=\"vertical-align:middle;align:center\">" + drseldatos["ronda"].ToString() + "° Ronda</td>");

                        // estados
                        switch (resultado)
                        {
                            // registro no completado
                            case 0:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-dark\" style=\"font-size:14px;\">Registro Incompleto</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"editarPonencia(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-danger text-white\" onclick=\"ConfirmarEliminar(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionComentarios();\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar();\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;
                            // pendiente de envío
                            case 1:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning text-dark\" style=\"font-size:14px;\">Envío Pendiente</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"editarPonencia(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-danger text-white\" onclick=\"ConfirmarEliminar(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionComentarios();\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white btn-pulse pulsing\" onclick=\"confirmarEnvio(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;

                            // asignada
                            case 2: 
                            case 9:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-info\" style=\"font-size:14px;\">En Revisión</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEditar();\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionComentarios();\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar2();\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;

                            // aprobada
                            case 3:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-success\" style=\"font-size:14px;\">Aprobada</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEditar();\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"VerComentarios(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar2();\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;

                            // rechazada
                            case 4:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-danger\" style=\"font-size:14px;\">Rechazada</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEditar();\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"VerComentarios(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar2();\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;

                            // aprobada con cambios
                            case 5:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning\" style=\"color:#000;font-size:14px;\">Requiere Cambios</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"subirArchivo(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() +");\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"VerComentarios(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar();\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;
                            
                            //enviada
                            case 6:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-success\" style=\"font-size:14px\";\">Enviada</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEditar();\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionComentarios();\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar2();\"><i class=\"fa-solid fa-share\"></i></i></button>");
                                break;

                            // archivo con cambios cargado
                            case 7:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning text-dark\" style=\"font-size:14px;\">Envío Pendiente</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"subirArchivo(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() +");\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"VerComentarios(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info btn-pulse text-white pulsing\" onclick=\"confirmarEnvio(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-share\"></i></button>");
                                break;

                            //reenviada
                            case 8:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-success\" style=\"font-size:14px\";\">Enviada</span></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEditar();\"><i class=\"fa-solid fa-pencil\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionBorrar();\"><i class=\"fa-solid fa-trash\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"VerComentarios(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa-solid fa-comment\"></i></button></td>");
                                sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"notificacionEnviar2();\"><i class=\"fa-solid fa-share\"></i></i></button>");
                                break;

                            default:
                                sb.Append("<td>Sin estado.</td>");
                                break;
                        }
                        sb.Append("</td></tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Ponencias</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No se han registrado ponencias.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string borrarPonencia(int id)
    {
        int Eliminado = 0;
        int user = Convert.ToInt32(HttpContext.Current.Session["idusuario"]);
        string ruta = @"C:\inetpub\wwwroot\Coloquio\ponencias\" + user + "\\" + id;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EliminarPonencia", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = id;

                SqlParameter peliminado = comand.Parameters.Add("@Eliminado", SqlDbType.Int);
                peliminado.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Eliminado = int.Parse(peliminado.Value.ToString());
            }
            Conn.Close();
            if (Eliminado == 1)
            {
                if (Directory.Exists(ruta))
                {
                    Directory.Delete(ruta, true);
                }
            }
            return "{\"success\": \"" + Eliminado + "\"}";
        }
    }

    [WebMethod]
    public static string enviarPonencia(int id)
    {
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EnviarPonencia", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = id;

                Conn.Open();
                comand.ExecuteNonQuery();                
            }
            Conn.Close();
            return "{\"success\": \"" + 1 + "\"}";
        }
    }

    [WebMethod]
    public static string actualizarVar(int idPonencia, int ronda)
    {        
        HttpContext.Current.Session["idponencia"] = idPonencia;
        HttpContext.Current.Session["ronda"] = ronda;
        return "{\"Success\": \"" + 1 + "\"}";
    }

    [WebMethod]
    public static string TablaListarComentarios(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarComentariosP", con))
            {
                int i = 1;
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.Add("@idPonencia", SqlDbType.Int).Value = id;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaC\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Ronda</th><th scope=\"col\">Comentario</th><th scope=\"col\">Fecha</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<tr>");
                        // sb.Append("<td class=\"align-middle\" width=\"15%\">Evaluador " + i + "</td>");
                        sb.Append("<td class=\"align-middle text-center\" width=\"12.5%\">" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        sb.Append("<td class=\"align-middle\" width=\"62.5%\">" + drseldatos["comentario"].ToString() + "</td>");                        
                        sb.Append("<td class=\"align-middle\" width=\"25%\">" + drseldatos["dia"].ToString() + " de " + drseldatos["mes"].ToString() + " del " + drseldatos["ano"].ToString() + "<br>" + drseldatos["hora"].ToString() + "</td>");
                        sb.Append("</tr>");
                        i++;
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tablaC\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Comentarios</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay comentarios disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }
}