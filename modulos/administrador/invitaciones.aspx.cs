using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Script.Serialization;
using System.Net;
using System.Net.Mail;

public partial class modulos_administrador_invitaciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DropEdicion();
        DropEval();
    }

    // [WebMethod]
    // public static string GetEvaluadores(string term)
    // {
    //     using (SqlConnection con = conn.conecta())
    //     {
    //         using (SqlCommand command = new SqlCommand("TraeEvaluadores", con))
    //         {
    //             command.CommandType = CommandType.StoredProcedure;

    //             command.Parameters.AddWithValue("@parametro", term.Trim());

    //             con.Open();

    //             SqlDataReader reader = command.ExecuteReader();

    //             List<Evaluador> evaluadores = new List<Evaluador>();

    //             while (reader.Read())
    //             {
    //                 evaluadores.Add(new Evaluador
    //                 {
    //                     ID = reader.GetInt32(0),
    //                     Nombre = reader.GetString(1),
    //                     Correo = reader.GetString(2)
    //                 });
    //             }
    //             reader.Close();
    //             reader.Dispose();

    //             con.Close();

    //             JavaScriptSerializer serializer = new JavaScriptSerializer();
    //             string jsonString = serializer.Serialize(evaluadores);

    //             return jsonString;
    //         }
    //     }
    // }

    private void DropEval()
    {
        using (SqlConnection con = conn.conecta())
        {
            int idUsuario = Convert.ToInt32(HttpContext.Current.Session["idusuario"]);
            using (SqlCommand cmdSeluam = new SqlCommand("SelEval", con))
            {
                cmdSeluam.CommandType = CommandType.StoredProcedure;
                cmdSeluam.Parameters.Add("@idUsuario", idUsuario);
                con.Open();
                ddleval.Items.Clear();
                ddleval.AppendDataBoundItems = true;
                ddleval.Items.Add(new ListItem("- Seleccione un evaluador -", "0"));
                SqlDataReader drcar = cmdSeluam.ExecuteReader();
                while (drcar.Read())
                {
                    ddleval.Items.Add(new ListItem(drcar["evaluador"].ToString(), drcar["idEvaluador"].ToString()));
                }
                drcar.Close();
                drcar.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string TituloPonencia(int idponencia)
    {
        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("TraerTitulo", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idponencia;
                con.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var obj = new
                        {
                            titulo = dr["titulo"].ToString().Trim()
                        };

                        jsonString = serializer.Serialize(obj);
                    }
                    dr.Close();
                }
            }
            con.Close();
        }
        return jsonString;
    }

    public class Evaluador
    {
        public int ID { get; set; }
        public string Nombre { get; set; }
        public string Correo { get; set; }
    }

    private void DropEdicion()
    {
        int edicionActiva = Convert.ToInt32(Session["edicionActiva"]);
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand cmdSelEdicion = new SqlCommand("SelEdicioness", con))
            {
                cmdSelEdicion.CommandType = CommandType.StoredProcedure;
                con.Open();

                // Para agenerar el select con las ediciones
                selectEd.Items.Clear();
                selectEd.AppendDataBoundItems = true;

                SqlDataReader drEd = cmdSelEdicion.ExecuteReader();

                while (drEd.Read())
                {
                    if (int.Parse(drEd["idEdicion"].ToString()) == edicionActiva){
                         selectEd.Items.Add(new ListItem(drEd["edicion"].ToString() + "(activa)", drEd["idEdicion"].ToString()));
                    } else {
                         selectEd.Items.Add(new ListItem(drEd["edicion"].ToString(), drEd["idEdicion"].ToString()));
                    }
                }

                drEd.Close();
                drEd.Dispose();

                selectEd.SelectedValue = edicionActiva.ToString();
            }
        }
    }


    [WebMethod]
    public static string TablaListarPonencias(int idEdicion)
    {
        int tipoUser = Convert.ToInt32(HttpContext.Current.Session["tipoUsuario"]);
        int idUsuario = Convert.ToInt32(HttpContext.Current.Session["idusuario"]);

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarPonenciasInvitar", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@tipoUsuario", tipoUser);
                seldata.Parameters.AddWithValue("@edicion", idEdicion);
                seldata.Parameters.Add("@idUsuario", idUsuario);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\" width=\"50%\">Ponencia</th><th scope=\"col\">Ronda</th><th scope=\"col\">Ver ponencia</th><th scope=\"col\">Evaluadores</th><th scope=\"col\" style=\"max-width: 100px;\">Estado</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        int resultado = Convert.ToInt32(drseldatos["estado"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td width=\"\" class=\"align-middle\">" + drseldatos["titulo"].ToString() + "</td>");
                        sb.Append("<td width=\"\" class=\"align-middle\">" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-icon btn-dark text-white\" onclick=\"verPonencia(" + drseldatos["idPonencia"].ToString() + ", " + drseldatos["idUsuario"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa fa-magnifying-glass\" aria-hidden=\"true\"></i></button></td>");
                        sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"editarEvaluador(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa fa-user-gear\" aria-hidden=\"true\"></i></button></td>");
                        //sb.Append("<td width=\"\" class=\"align-middle\">" + drseldatos["tema"].ToString() + "</td>");
                        //sb.Append("<td width=\"\" class=\"align-middle\">" + drseldatos["modalidad"].ToString() + "</td>");
                        // estados
                        switch (resultado)
                        {
                            // registro no completado
                            // case 0:
                            //     sb.Append("<td align=\"center\" class=\"align-middle\"><i class=\"fa-solid fa-list-check text-secondary\" style=\"font-size:1.2em;\"></i></td>");
                            //     break;
                            // Enviada
                            // case 1:
                                // sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"1\"><i class=\"fa-sharp fa-solid fa-hourglass-half text-secondary\" style=\"font-size:1.2em;\"></i></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" onclick=\"verComentarios(" + drseldatos["idPonencia"].ToString() + ");\" class=\"badge bg-success\" style=\"font-size:14px;\">Enviada</button></td>");                                
                                // break;

                            // en revisión
                            case 2:
                                //sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"2\"><i class=\"fa-sharp fa-solid fa-clock text-secondary\" style=\"font-size:1.2em;\"></i></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning\" style=\"font-size:14px;\">En revisión</span></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionRonda();\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionResultados();\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;

                            // aceptada
                            case 3:
                                //sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"3\"><i class=\"fa-sharp fa-solid fa-check text-success\" style=\"font-size:1.2em;\"></i></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-success\" style=\"font-size:14px;\">Aprobada</span></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-warning text-white\" onclick=\"ConfirmarRonda(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-success text-white\" onclick=\"ConfirmarResultados(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;

                            // rechazada
                            case 4:
                                //sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"4\"><i class=\"fa-sharp fa-solid fa-xmark text-danger\" style=\"font-size:1.2em;\"></i></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-danger\" style=\"font-size:14px;\">Rechazada</span></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-warning text-white\" onclick=\"ConfirmarRonda(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-success text-white\" onclick=\"ConfirmarResultados(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;

                            // requiere cambios
                            case 5:
                            case 7:                            
                                //sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"4\"><i class=\"fa-sharp fa-solid fa-xmark text-danger\" style=\"font-size:1.2em;\"></i></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning\" style=\"font-size:14px;\">Requiere cambios</span></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionRonda();\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionResultados();\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;

                            // sin asignar
                            case 6:
                            case 8:
                                //sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"4\"><i class=\"fa-sharp fa-solid fa-xmark text-danger\" style=\"font-size:1.2em;\"></i></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-dark\" style=\"font-size:14px;\">Sin asignar</span></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionRonda();\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionResultados();\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;

                            // evaluada
                            case 9:
                                //sb.Append("<td align=\"center\" class=\"align-middle\" data-order=\"4\"><i class=\"fa-sharp fa-solid fa-xmark text-danger\" style=\"font-size:1.2em;\"></i></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span onclick=\"verComentarios(" + drseldatos["idPonencia"].ToString() + ")\" class=\"badge bg-success btn\" style=\"font-size:14px;\">Evaluada</span></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-warning text-white\" onclick=\"verComentariosRonda(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-success text-white\" onclick=\"verComentariosResultado(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;

                            default:
                                //sb.Append("<td data-order=\"5\">Sin estado.</td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-dark\" style=\"color:#fff;font-size:14px;\">Sin estado</span></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionRonda();\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-secondary text-white\" onclick=\"notificacionResultados();\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                                break;
                        }
                        // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-warning text-white\" onclick=\"ConfirmarRonda(" + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa fa-file-text\" aria-hidden=\"true\"></i></button></td>");
                        // sb.Append("<td align=\"center\" class=\"align-middle\"><button type=\"button\" class=\"btn btn-success text-white\" onclick=\"ConfirmarResultados(" + drseldatos["idPonencia"].ToString() + "," + drseldatos["ronda"].ToString() + ");\"><i class=\"fa fa-share\" aria-hidden=\"true\"></i></button></td>");
                        sb.Append("</tr>");
                    }
                    sb.Append("</tbody></table>");
                    // Para esconder el botón de guardaar si es una edición que no es la activa
                    sb.Append("<script>ocultaBoton("+Convert.ToInt32(HttpContext.Current.Session["edicionActiva"])+");</script>");

                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }


    [WebMethod]
    public static string ListarEvaluadores(int idPonencia, int idEdicion)
    {
        int edicionActiva = Convert.ToInt32(HttpContext.Current.Session["edicionActiva"]);
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarEvaluadores", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", idPonencia);

                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    sb.Append("<table id=\"tablaEvaluadores\" class=\"table table-striped table-bordered \">");
                    sb.Append("<thead>");
                    sb.Append("<tr>");
                    sb.Append("<th scope=\"col\">Nombre</th>");
                    sb.Append("<th scope=\"col\">Correo</th>");
                    sb.Append("<th scope=\"col\">Fecha de Invitación</th>");
                    sb.Append("<th scope=\"col\">Fecha de Respuesta</th>");
                    sb.Append("<th scope=\"col\">Fecha de Evaluación</th>");
                    sb.Append("<th scope=\"col\">Estado de invitación</th>");                    
                    sb.Append("<th scope=\"col\">Enviar Correo</th>");
                    sb.Append("<th scope=\"col\">Retirar Evaluador</th>");
                    sb.Append("</tr>");
                    sb.Append("</thead>");
                    sb.Append("<tbody>");
                    while (drseldatos.Read())
                    {
                        int estado = Convert.ToInt32(drseldatos["estado"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle style=\"width: 15%\">" + drseldatos["nombre"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle style=\"width: 10%\">" + drseldatos["email"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle style=\"width: 15%\">" + drseldatos["fechaEnv"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle style=\"width: 15%\">" + drseldatos["fechaResp"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle style=\"width: 15%\">" + drseldatos["fechaEval"].ToString() + "</td>");
                        //sb.Append("<td class=\"text-center align-middle\">");
                        // estados
                        switch (estado)
                        {
                            // pendiente
                            case 0:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-hourglass-half text-secondary\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle style=\"width: 10%\"><span class=\"badge bg-warning\" style=\"font-size:14px;\">Pendiente</span></td>");
                                break;

                            // aceptada
                            case 1:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-check text-success\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle style=\"width: 10%\"><span class=\"badge bg-success\" style=\"font-size:14px;\">Aceptada</span></td>");
                                break;
                            // rechazada
                            case 2:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-xmark text-danger\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle style=\"width: 10%\"><span class=\"badge bg-danger\" style=\"font-size:14px;\">Rechazada</span></td>");
                                break;
                            // Evaluada
                            case 3:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-check text-success\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle style=\"width: 10%\"><span class=\"badge bg-info\" style=\"font-size:14px;\">Evaluada</span></td>");
                                break;
                            case 5:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-check text-success\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle style=\"width: 10%\"><span class=\"badge bg-dark\" style=\"font-size:14px;\">No invitado</span></td>");
                                break;
                            default:
                                //Pues aquí la loógica o catcheado por el case
                                break;
                        }
                        sb.Append("</td>");
                        sb.Append("<td class=\"text-center align-middle style=\"width: 10%\">");
                        if (idEdicion != edicionActiva){
                            sb.Append("<button type=\"button\" class=\"btn btn-info text-white\" disabled><i class=\"fa-solid fa-envelope\"></i></button></td>");
                            sb.Append("<td class=\"text-center align-middle style=\"width: 10%\">");
                            sb.Append("<button type=\"button\" class=\"btn btn-danger text-white\" disabled><i class=\"fa-solid fa-trash\"></i></button>");
                        } else {
                            sb.Append("<button type=\"button\" class=\"btn btn-icon btn-info fa-solid fa-envelope text-white w50\" onclick=\"EnviarCorreo(" + idPonencia + ", " + drseldatos["idUsuario"].ToString() + ");\"></button></td>");
                            sb.Append("<td class=\"text-center align-middle style=\"width: 10%\">");
                            sb.Append("<button type=\"button\" class=\"btn btn-icon btn-danger fa-solid fa-trash text-white w50\" onclick=\"retirarEvaluador(" + idPonencia + ", " + drseldatos["idUsuario"].ToString() + ");\"></button>");
                        }
                        sb.Append("</td>");
                        sb.Append("</tr>");
                    }
                    sb.Append("</tbody>");
                    sb.Append("</table>");

                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }


    [WebMethod]
    public static string EnviaInvitacion(int idPonencia, int idEvaluador)
    {
        int Exitoso = 0;
        string Nombre = "", Apellido = "", Email = "", Titulo = "";

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EnviarInvitacion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;
                comand.Parameters.Add("@idEvaluador", SqlDbType.Int).Value = idEvaluador;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                SqlParameter pnombre = comand.Parameters.Add("@Nombre", SqlDbType.NVarChar, 150);
                SqlParameter papellido = comand.Parameters.Add("@Apellido", SqlDbType.NVarChar, 150);
                SqlParameter pemail = comand.Parameters.Add("@Email", SqlDbType.NVarChar, 150);
                SqlParameter ptitulo = comand.Parameters.Add("@Titulo", SqlDbType.NVarChar, 150);
                pexitoso.Direction = ParameterDirection.Output;
                pnombre.Direction = ParameterDirection.Output;
                papellido.Direction = ParameterDirection.Output;
                pemail.Direction = ParameterDirection.Output;
                ptitulo.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
                Nombre = pnombre.Value.ToString();
                Apellido = papellido.Value.ToString();
                Email = pemail.Value.ToString();
                Titulo = ptitulo.Value.ToString();
            }
            Conn.Close();
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }


    [WebMethod]
    public static string RetiraInvitacion(int idPonencia, int idEvaluador)
    {
        int Exitoso = 0;

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("RetirarEvaluador", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;
                comand.Parameters.Add("@idEvaluador", SqlDbType.Int).Value = idEvaluador;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                pexitoso.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
            }
            Conn.Close();
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }


    [WebMethod]
    public static string TablaListarAutores(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarAutores", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", id);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaAutores\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Nombre</th><th scope=\"col\">Correo</th><th scope=\"col\">Tipo</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<tr class=\"align-middle\">");
                        sb.Append("<td width=\"45%\">" + drseldatos["autor"].ToString() + "</td>");
                        sb.Append("<td width=\"35%\">" + drseldatos["correo"].ToString() + "</td>");
                        sb.Append("<td width=\"20%\">" + drseldatos["tipoAutor"].ToString() + "</td>");
                        sb.Append("</tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Autores</th></tr></thead><tbody>");
                        sb.Append("<tr><td style=\"text-align: center;\">No se han registrado autores.</td></tr></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }


    [WebMethod]
    public static string TraeDatos(int id)
    {
        StringBuilder sb = new StringBuilder();
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
        HttpContext.Current.Session["idponencia"] = id;

        return jsonString;
    }

    [WebMethod]
    public static string fetchComentario(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("fetchComentario", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idEvaluacion", SqlDbType.Int).Value = id;
                Conn.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        sb.Append("{\"comments\": \"" + dr["comments"].ToString().Trim().Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"}");                        
                    }
                    dr.Close();
                }
            }
            Conn.Close();
        }
        return sb.ToString();
    }

    [WebMethod]
        public static string EnviarCorreo(int ponencia, int usuario)
        {
            int Exitoso = 0;
            string Correo = "", Contra = "",Nombre = "", Apellido = "", Titulo = "", Email = "", Resumen = "", Grado = "";
            using (SqlConnection con = conn.conecta())
            {
                using (SqlCommand comand = new SqlCommand("SelDatosInvitacion", con))
                {
                    comand.CommandType = CommandType.StoredProcedure;
                    comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = ponencia;
                    comand.Parameters.Add("@idUsuario", SqlDbType.Int).Value = usuario;
                    SqlParameter Pcorreo = comand.Parameters.Add("@Correo", SqlDbType.NVarChar, 50);
                    SqlParameter Pcontra = comand.Parameters.Add("@Contra", SqlDbType.NVarChar, 50);
                    SqlParameter Pnombre = comand.Parameters.Add("@Nombre", SqlDbType.NVarChar, 50);
                    SqlParameter Papellido = comand.Parameters.Add("@Apellido", SqlDbType.NVarChar, 50);
                    SqlParameter Ptitulo = comand.Parameters.Add("@Titulo", SqlDbType.NVarChar, 1000);
                    SqlParameter Pemail = comand.Parameters.Add("@Email", SqlDbType.NVarChar, 50);
                    SqlParameter Presumen = comand.Parameters.Add("@Resumen", SqlDbType.NVarChar, 1500);
                    SqlParameter Pgrado = comand.Parameters.Add("@Grado", SqlDbType.NVarChar, 50);

                    Pcorreo.Direction = ParameterDirection.Output;
                    Pcontra.Direction = ParameterDirection.Output;
                    Pnombre.Direction = ParameterDirection.Output;
                    Papellido.Direction = ParameterDirection.Output;
                    Ptitulo.Direction = ParameterDirection.Output;
                    Pemail.Direction = ParameterDirection.Output;
                    Presumen.Direction = ParameterDirection.Output;
                    Pgrado.Direction = ParameterDirection.Output;
                    con.Open();
                    comand.ExecuteNonQuery();
                    Correo = Pcorreo.Value.ToString();
                    Contra = Pcontra.Value.ToString();
                    Nombre = Pnombre.Value.ToString();
                    Apellido = Papellido.Value.ToString();
                    Titulo = Ptitulo.Value.ToString();
                    Email = Pemail.Value.ToString();
                    Resumen = Presumen.Value.ToString();
                    Grado = Pgrado.Value.ToString();
                }
                con.Close();
            }
            using (MailMessage mm = new MailMessage(Correo.Trim(), Email.Trim()))
            {
                mm.Subject = "Invitación a evaluar ponencia";
                mm.Body = "Estimado(a): <b>" + Grado + " " + Nombre + " " + Apellido + "</b><br /><br /><p style=\"text-align: justify;\">Le informamos que ha sido cordialmente invitado a evaluar la ponencia: <b>" + Titulo + ".</b></p><br /><br />Resumen de la ponencia: <br /><p style=\"text-align: justify;\"><b>" + Resumen + "</b></p><br /><br />Para responder la invitación favor de confirmarlo en el sistema: <a href=\"https://fcav-app.uat.edu.mx/cieanfeca/login/login.aspx\">https://fcav-app.uat.edu.mx/cieanfeca/login/login.aspx</a> <br /><br />Saludos cordiales".Trim();
                mm.Attachments.Add(new Attachment(@"C:\inetpub\wwwroot\coloquio\assets\doc\Manual_Evaluador.pdf"));
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.office365.com";
                smtp.EnableSsl = true;
                NetworkCredential networkCred = new NetworkCredential(Correo.Trim(), Contra.Trim());
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = networkCred;
                smtp.Port = 587;
                smtp.Send(mm);
                Exitoso = 1;
            }
            return "{\"success\": \"" + Exitoso + "\"}";
        }

    [WebMethod]
    public static string VerComentarios(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("VerComentarios", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", id);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {                    
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaComentarios\" class=\"table table-striped table-bordered\"><thead><tr><th scope=\"col\" width=\"15%\">Fecha</th><th scope=\"col\" width=\"15%\">Evaluador</th><th scope=\"col\" width=\"45%\">Comentarios</th><th scope=\"col\" width=\"15%\">Resultado</th><th scope=\"col\" width=\"10%\">Ronda</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        var comment = Convert.ToString(drseldatos["comentarios"].ToString());
                        int resultado = Convert.ToInt32(drseldatos["resultado"].ToString());
                        sb.Append("<tr style=\"vertical-align:middle;align:center\">");
                        sb.Append("<td>" + drseldatos["fecha"].ToString() + "</td>");
                        sb.Append("<td>" + drseldatos["evaluador"].ToString() + "</td>");
                        if(comment == ""){
                            sb.Append("<td>Sin comentarios.</td>");
                        } else {
                            sb.Append("<td>" + drseldatos["comentarios"].ToString() + "</td>");
                        }
                        switch(resultado){
                            case 1:                                
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-success\" style=\"font-size:14px;\">Aprobada</span></td>");
                                break;
                            case 2:                                
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-danger\" style=\"font-size:14px;\">Rechazada</span></td>");
                                break;
                            case 3:                                
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning\" style=\"color:#000;font-size:14px;\">Aprobada con cambios</span></td>");
                                break;
                            default:
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-dark text-white\" style=\"font-size:14px;\">Sin estado</span></td>");
                                break;
                        }
                        sb.Append("<td>" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        sb.Append("</tr>");
                    }

                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        //Aquí tengo que encontrar la lógica para cuando no haya comentarios poder saberlo en js
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string VerComentariosRonda(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("VerComentarios", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", id);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {                    
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaComentarios2\" class=\"table table-striped table-bordered\"><thead><tr><th scope=\"col\"\">Evaluador</th><th scope=\"col\"\">Comentarios</th><th scope=\"col\"\">Ronda</th><th scope=\"col\"\">Editar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        var comment = Convert.ToString(drseldatos["comentarios"].ToString());                        
                        sb.Append("<tr style=\"vertical-align:middle;align:center\">");                        
                        sb.Append("<td style=\"width:20%\">" + drseldatos["evaluador"].ToString() + "</td>");
                        if(comment == ""){
                            sb.Append("<td style=\"width:60%\">Sin comentarios.</td>");
                        } else {
                            sb.Append("<td style=\"width:60%\">" + drseldatos["comments"].ToString() + "</td>");
                        }
                        
                        sb.Append("<td style=\"width:10%\">" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        sb.Append("<td style=\"width:10%;text-align:center\"><button type=\"button\" class=\"btn btn-icon btn-info\" onclick=\"fetchComentario(" + drseldatos["idEvaluacion"].ToString() + ")\"><i class=\"fa-solid fa-pen-to-square\"></i></button><t/d>");
                        sb.Append("</tr>");
                    }

                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tablaComentarios\" class=\"table table-striped table-bordered\"><thead><tr><th scope=\"col\">Comentarios</th></tr></thead><tbody><tr><td scope=\"col\">No hay comentarios</td></tr></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string VerComentariosResultados(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("VerComentarios", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", id);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {                    
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaComentarios2\" class=\"table table-striped table-bordered\"><thead><tr><th scope=\"col\"\">Evaluador</th><th scope=\"col\"\">Comentarios</th><th scope=\"col\"\">Ronda</th><th scope=\"col\"\">Editar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        var comment = Convert.ToString(drseldatos["comentarios"].ToString());                        
                        sb.Append("<tr style=\"vertical-align:middle;align:center\">");                        
                        sb.Append("<td style=\"width:20%\">" + drseldatos["evaluador"].ToString() + "</td>");
                        if(comment == ""){
                            sb.Append("<td style=\"width:60%\">Sin comentarios.</td>");
                        } else {
                            sb.Append("<td style=\"width:60%\">" + drseldatos["comments"].ToString() + "</td>");
                        }
                        
                        sb.Append("<td style=\"width:10%\">" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        sb.Append("<td style=\"width:10%;text-align:center\"><button type=\"button\" class=\"btn btn-icon btn-info\" onclick=\"fetchComentarioR(" + drseldatos["idEvaluacion"].ToString() + ")\"><i class=\"fa-solid fa-pen-to-square\"></i></button><t/d>");
                        sb.Append("</tr>");
                    }

                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tablaComentarios\" class=\"table table-striped table-bordered\"><thead><tr><th scope=\"col\">Comentarios</th></tr></thead><tbody><tr><td scope=\"col\">No hay comentarios</td></tr></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string NuevaRonda(int idPonencia, string comentario)
    {
        int Exitoso = 0;

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("nuevaRonda", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;
                comand.Parameters.Add("@comentario", SqlDbType.NVarChar, 500).Value = comentario;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                pexitoso.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
            }
            Conn.Close();
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }

    //--------------------------------------------------------------------------------
    [WebMethod]
    public static string aprobarResultado(int idPonencia)
    {
        int Exitoso = 0;
        string autor = "", institucion = "", titulo = "", dia = "", mes = "", anio = "", correo = "", pass = "", email = "", copia = "";

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("aprobarPonencia", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                SqlParameter pautor = comand.Parameters.Add("@Autores", SqlDbType.NVarChar, 500);
                SqlParameter pinstitucion = comand.Parameters.Add("@Institucion", SqlDbType.NVarChar, 500);
                SqlParameter ptitulo = comand.Parameters.Add("@Titulo", SqlDbType.NVarChar, 500);
                SqlParameter pdia = comand.Parameters.Add("@Dia", SqlDbType.NVarChar, 500);
                SqlParameter pmes = comand.Parameters.Add("@Mes", SqlDbType.NVarChar, 500);
                SqlParameter panio = comand.Parameters.Add("@Anio", SqlDbType.NVarChar, 500);
                SqlParameter pcorreo = comand.Parameters.Add("@Correo", SqlDbType.NVarChar, 500);
                SqlParameter ppass = comand.Parameters.Add("@Pass", SqlDbType.NVarChar, 500);
                SqlParameter pemail = comand.Parameters.Add("@Email", SqlDbType.NVarChar,500);
                SqlParameter pcopia = comand.Parameters.Add("@Copia", SqlDbType.NVarChar,1000);

                pexitoso.Direction = ParameterDirection.Output;
                pautor.Direction = ParameterDirection.Output;
                pinstitucion.Direction = ParameterDirection.Output;
                ptitulo.Direction = ParameterDirection.Output;
                pdia.Direction = ParameterDirection.Output;
                pmes.Direction = ParameterDirection.Output;
                panio.Direction = ParameterDirection.Output;
                pcorreo.Direction = ParameterDirection.Output;
                ppass.Direction = ParameterDirection.Output;
                pemail.Direction = ParameterDirection.Output;
                pcopia.Direction = ParameterDirection.Output;

                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());

                autor = pautor.Value.ToString();
                institucion = pinstitucion.Value.ToString();
                titulo = ptitulo.Value.ToString();
                dia = pdia.Value.ToString();
                mes = pmes.Value.ToString();
                anio = panio.Value.ToString();
                correo = pcorreo.Value.ToString();
                pass = ppass.Value.ToString();
                email = pemail.Value.ToString();
                copia = pcopia.Value.ToString();
            }
            Conn.Close();
            using (MailMessage mm = new MailMessage(correo.Trim(), email.Trim()))
            {
                mm.Subject = "Carta de aceptación";
                mm.Body = "<h4 style=\"text-align: center;\">CARTA DE ACEPTACIÓN</h4><br /><p style=\"text-align: right;\">Oaxaca, Oax. " + dia + " de " + mes + " de " + anio + "</p><br /><p>Autor(es): <b>" + autor + ".</b></p><p>Institución de procedencia: <b>" + institucion + ".</b></p><br /><p>P r e s e n t e:</p><p>Estimado(s) Investigador(es):</p><p style=\"text-align: justify;\" >Por este conducto, se les comunica que su ponencia titulada: " + titulo + ", fue <b>Aprobada</b> por los evaluadores para ser presentada oralmente por alguno de los autores en la <b>1er. Congreso Internacional de Emprendimiento Social</b>, a celebrarse en la ciudad de Oaxaca, del 29 al 29 de septiembre de 2023.</p><p style=\"text-align: justify;\">Se les agradece su interés de participar en el evento y les comunicamos que, para estar en condiciones de ser considerado su trabajo en el libro electrónico (previa evaluación del comité organizador), se requiere que envíen antes del <b>30 de julio del año en curso</b>, en formato digital (en las fechas del Congreso, se debe entregar el original), su consentimiento por escrito a través del formato <b>Cesión de Derechos</b>, el cual se adjunta a la presente, solicitándoles su llenado y debidamente firmado por todos los autores. Enviar por correo electrónico a la dirección <b>es.anfeca@uat.edu.mx</b> con el asunto de: Cesión de Derechos.</p><p style=\"text-align: justify;\">Agradeciendo profundamente su participación, que seguramente será benéfico para el desarrollo científico-académico de nuestro país, quedamos a sus apreciables órdenes.</p><br/><br/><p style=\"text-align: center;\"><b>Atentamente</b></p><br/><p style=\"text-align: center;\"><b>El comité organizador</b></p>";
                mm.Attachments.Add(new Attachment(@"C:\inetpub\wwwroot\coloquio\assets\doc\Cesión_derechos_ES.docx"));
                mm.IsBodyHtml = true;
                MailAddress copy = new MailAddress(copia);
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.office365.com";
                smtp.EnableSsl = true;
                NetworkCredential networkCred = new NetworkCredential(correo.Trim(), pass.Trim());
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = networkCred;
                smtp.Port = 587;
                smtp.Send(mm);
            }
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }

    [WebMethod]
    public static string aprobarCambiosResultado(int idPonencia)
    {
        int Exitoso = 0;
        string autor = "", institucion = "", titulo = "", dia = "", mes = "", anio = "", correo = "", pass = "", email = "", com1 = "", com2 = "", Copia = "";

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("nuevaRonda", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                SqlParameter pautor = comand.Parameters.Add("@Autores", SqlDbType.NVarChar, 500);
                SqlParameter pinstitucion = comand.Parameters.Add("@Institucion", SqlDbType.NVarChar, 500);
                SqlParameter ptitulo = comand.Parameters.Add("@Titulo", SqlDbType.NVarChar, 500);
                SqlParameter pdia = comand.Parameters.Add("@Dia", SqlDbType.NVarChar, 500);
                SqlParameter pmes = comand.Parameters.Add("@Mes", SqlDbType.NVarChar, 500);
                SqlParameter panio = comand.Parameters.Add("@Anio", SqlDbType.NVarChar, 500);
                SqlParameter pcorreo = comand.Parameters.Add("@Correo", SqlDbType.NVarChar, 500);
                SqlParameter ppass = comand.Parameters.Add("@Pass", SqlDbType.NVarChar, 500);
                SqlParameter pemail = comand.Parameters.Add("@Email", SqlDbType.NVarChar, 500);
                SqlParameter pcom1 = comand.Parameters.Add("@comentario1", SqlDbType.NVarChar, 500);
                SqlParameter pcom2 = comand.Parameters.Add("@comentario2", SqlDbType.NVarChar,500);
                SqlParameter pcopia = comand.Parameters.Add("@Copia", SqlDbType.NVarChar, 1000);

                pexitoso.Direction = ParameterDirection.Output;
                pautor.Direction = ParameterDirection.Output;
                pinstitucion.Direction = ParameterDirection.Output;
                ptitulo.Direction = ParameterDirection.Output;
                pdia.Direction = ParameterDirection.Output;
                pmes.Direction = ParameterDirection.Output;
                panio.Direction = ParameterDirection.Output;
                pcorreo.Direction = ParameterDirection.Output;
                ppass.Direction = ParameterDirection.Output;
                pemail.Direction = ParameterDirection.Output;
                pcom1.Direction = ParameterDirection.Output;
                pcom2.Direction = ParameterDirection.Output;
                pcopia.Direction = ParameterDirection.Output;

                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());

                autor = pautor.Value.ToString();
                institucion = pinstitucion.Value.ToString();
                titulo = ptitulo.Value.ToString();
                dia = pdia.Value.ToString();
                mes = pmes.Value.ToString();
                anio = panio.Value.ToString();
                correo = pcorreo.Value.ToString();
                pass = ppass.Value.ToString();
                email = pemail.Value.ToString();
                com1 = pcom1.Value.ToString();
                com2 = pcom2.Value.ToString();
                Copia = pcopia.Value.ToString();
            }
            Conn.Close();
            using (MailMessage mm = new MailMessage(correo.Trim(), email.Trim()))
            {
                mm.Subject = "Carta de aceptación condicionada";
                mm.Body = "<h4 style=\"text-align: center;\">CARTA DE ACEPTACIÓN CONDICIONADA</h4><br /><p style=\"text-align: right;\">Oaxaca, Oax. " + dia + " de " + mes + " de " + anio + "</p><br /><p>Autor(es): <b>" + autor + "</b></p><p>Institución de procedencia: <b>" + institucion + "</b></p><br /><p>P r e s e n t e:</p><p>Estimado(s) Investigador(es):</p><p style=\"text-align: justify;\">Por este conducto, se les comunica que su ponencia titulada: " + titulo + ", fue <b>Aprobada con observaciones</b> las cuales deberán ser atendidas y enviadas por en un plazo no mayor 5 dias hábiles. Lo anterior, para que la ponencia pueda ser presetada oralmente por alguno de los autores en la <b>1er. Congreso Internacional de Emprendimiento Social</b>, a celebrarse en la ciudad de Oaxaca, del 29 al 29 de septiembre de 2023.</p><p style=\"text-align: justify;\">Si deseas continuar con el proceso de participacion en el eventos adjunta nuevamente el archivo en extenso con las modificaciones solicitadas: <a href=\"https://fcav-app.uat.edu.mx/cieanfeca/login/login.aspx\">https://fcav-app.uat.edu.mx/cieanfeca/login/login.aspx</a></p><p>Observaciones Revisor 1:</p><p style=\"text-align: justify;\"><b>" + com1 + "</b></p><p>Observaciones Revisor 2:</p><p style=\"text-align: justify;\"><b>" + com2 + "</b></p><p style=\"text-align: justify;\">Agradeciendo profundamente su participación, que seguramente será benéfico para el desarrollo científico-académico de nuestro país, quedamos a sus apreciables órdenes.</p><br/><br/><p style=\"text-align: center;\"><b>Atentamente</b></p><br/><p style=\"text-align: center;\"><b>El comité organizador</b></p>";
                mm.IsBodyHtml = true;
                MailAddress copy = new MailAddress(Copia);
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.office365.com";
                smtp.EnableSsl = true;
                NetworkCredential networkCred = new NetworkCredential(correo.Trim(), pass.Trim());
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = networkCred;
                smtp.Port = 587;
                smtp.Send(mm);
            }
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }

    [WebMethod]
    public static string rechazarResultado(int idPonencia)
    {
        int Exitoso = 0;
        string autor = "", institucion = "", titulo = "", dia = "", mes = "", anio = "", correo = "", pass = "", email="", com1 = "", com2="", copia = "";

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("rechazarPonencia", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                SqlParameter pautor = comand.Parameters.Add("@Autores", SqlDbType.NVarChar, 500);
                SqlParameter pinstitucion = comand.Parameters.Add("@Institucion", SqlDbType.NVarChar, 500);
                SqlParameter ptitulo = comand.Parameters.Add("@Titulo", SqlDbType.NVarChar, 500);
                SqlParameter pdia = comand.Parameters.Add("@Dia", SqlDbType.NVarChar, 500);
                SqlParameter pmes = comand.Parameters.Add("@Mes", SqlDbType.NVarChar, 500);
                SqlParameter panio = comand.Parameters.Add("@Anio", SqlDbType.NVarChar, 500);
                SqlParameter pcorreo = comand.Parameters.Add("@Correo", SqlDbType.NVarChar, 500);
                SqlParameter ppass = comand.Parameters.Add("@Pass", SqlDbType.NVarChar, 500);
                SqlParameter pemail = comand.Parameters.Add("@Email", SqlDbType.NVarChar, 500);
                SqlParameter pcom1 = comand.Parameters.Add("@comentario1", SqlDbType.NVarChar, 500);
                SqlParameter pcom2 = comand.Parameters.Add("@comentario2", SqlDbType.NVarChar, 500);
                SqlParameter pcopia = comand.Parameters.Add("@Copia", SqlDbType.NVarChar, 1000);

                pexitoso.Direction = ParameterDirection.Output; pautor.Direction = ParameterDirection.Output;
                pinstitucion.Direction = ParameterDirection.Output;
                ptitulo.Direction = ParameterDirection.Output;
                pdia.Direction = ParameterDirection.Output;
                pmes.Direction = ParameterDirection.Output;
                panio.Direction = ParameterDirection.Output;
                pcorreo.Direction = ParameterDirection.Output;
                ppass.Direction = ParameterDirection.Output;
                pemail.Direction = ParameterDirection.Output;
                pcom1.Direction = ParameterDirection.Output;
                pcom2.Direction = ParameterDirection.Output;
                pcopia.Direction = ParameterDirection.Output;

                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());

                autor = pautor.Value.ToString();
                institucion = pinstitucion.Value.ToString();
                titulo = ptitulo.Value.ToString();
                dia = pdia.Value.ToString();
                mes = pmes.Value.ToString();
                anio = panio.Value.ToString();
                correo = pcorreo.Value.ToString();
                pass = ppass.Value.ToString();
                email = pemail.Value.ToString();
                com1 = pcom1.Value.ToString();
                com2 = pcom2.Value.ToString();
                copia = pcopia.Value.ToString();
            }
            Conn.Close();
            using (MailMessage mm = new MailMessage(correo.Trim(), email.Trim()))
            {
                mm.Subject = "Carta de no aprobado";
                mm.Body = "<p style=\"text-align: right;\">Oaxaca, Oax. " + dia + " de " + mes + " de " + anio + "</p><br /><p>Autor(es): <b>" + autor + ".</b></p><p>Institución de procedencia: <b>" + institucion + ".</b></p><br /><p>P r e s e n t e:</p><p>Estimado(s) Investigador(es):</p><p style=\"text-align: justify;\" >Por este conducto, se les comunica que su ponencia titulada: <b>" + titulo + "</b>, <b>no fue aprobada</b> ya que no cumplio con los requisitos para que pueda ser presetada oralmente por alguno de los autores.</p><p>Observaciones Revisor 1:</p><p style=\"text-align: justify;\"><b>" + com1 + "</b></p><p>Observaciones Revisor 2:</p><p style=\"text-align: justify;\"><b>" + com2 + "</b></p><p style=\"text-align: justify;\">Agradeciendo profundamente su participación, que seguramente será benéfico para el desarrollo científico-académico de nuestro país, quedamos a sus apreciables órdenes.</p><br/><br/><p style=\"text-align: center;\"><b>Atentamente</b></p><br/><p style=\"text-align: center;\"><b>El comité organizador</b></p>";
                mm.IsBodyHtml = true;
                MailAddress copy = new MailAddress(copia);
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.office365.com";
                smtp.EnableSsl = true;
                NetworkCredential networkCred = new NetworkCredential(correo.Trim(), pass.Trim());
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = networkCred;
                smtp.Port = 587;
                smtp.Send(mm);
            }
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }

    // [WebMethod]
    // public static string fetchComentario(int id)
    // {
    //     StringBuilder sb = new StringBuilder();
    //     int Exitoso = 0;
    //     using (SqlConnection con = conn.conecta())
    //     {
    //         using (SqlCommand seldata = new SqlCommand("fetchComentario", con))
    //         {
    //             seldata.CommandType = CommandType.StoredProcedure;
    //             seldata.Parameters.AddWithValue("@idEvaluacion", id);
    //             con.Open();
    //             using (SqlDataReader drseldatos = seldata.ExecuteReader())
    //             {
    //                 sb.Append("<script> $(\"#comentarios\").clear();$(\"#comentarios\").val(" + drseldatos["comments"].ToString() + ");</script>");
    //             }

    //             SqlParameter pexitoso = seldata.Parameters.Add("@Exitoso", SqlDbType.Int);
    //             pexitoso.Direction = ParameterDirection.Output;
    //             seldata.ExecuteNonQuery();
    //             Exitoso = int.Parse(pexitoso.Value.ToString());
    //         }
    //         con.Close();
    //         return sb.ToString();
    //     }
    // }

    [WebMethod]
    public static string TablaComentarios(int id){
        int Exitoso = 0;
        StringBuilder sb = new StringBuilder();
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("Comentarios", Conn))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.Add("@idPonencia", SqlDbType.Int).Value = id;
                Conn.Open();

                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Comentarios</th><th  scope=\"col\"></th><th hidden>idPonencia</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<td style=\"font-size:0px\">" + drseldatos["observaciones"].ToString() + "</td>");
                        sb.Append("<td class=\"text-center align-middle\">");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-info fa-solid fa-envelope text-white w50\" onclick=\"\"></button>");
                        sb.Append("</td>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Comentarios</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay comentarios disponibles.</td></tbody></table>");
                    }
                drseldatos.Close();
            }
            Conn.Close();
            return sb.ToString();
            }
        }
    }

    [WebMethod]
    public static string MuestraComentarios(int id, int ronda)
    {        
        StringBuilder sb = new StringBuilder();
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("SelComentarios", Conn))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.Add("@idPonencia", SqlDbType.Int).Value = id;
                seldata.Parameters.Add("@ronda", SqlDbType.Int).Value = ronda;
                Conn.Open();

                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaComentas\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Nombre</th><th  scope=\"col\"></th><th scoper=\"col\">Resultado</th><th scoper=\"col\">Comentarios</th><th scoper=\"col\">Seleccionar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<td style=\"font-size:0px\">" + drseldatos["nombre"].ToString() + "</td>");
                        sb.Append("<td style=\"font-size:0px\">" + drseldatos["resultado"].ToString() + "</td>");
                        sb.Append("<td style=\"font-size:0px\">" + drseldatos["observaciones"].ToString() + "</td>");
                        sb.Append("<td class=\"text-center align-middle\">");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-info fa-solid fa-envelope text-white w50\" onclick=\"\"></button>");
                        sb.Append("</td>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Comentarios</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay comentarios disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
                Conn.Close();
                return sb.ToString();
            }
        }
    }

///////*********** ENVIAR RESULTADOS ************////////

    [WebMethod]
    public static string enviarResultados(int idPonencia, string comentario, int resultado){
        int Exitoso=0;
         using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ActualizarEstado", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;
                comand.Parameters.Add("@comentario", SqlDbType.NVarChar, 500).Value = comentario;
                comand.Parameters.Add("@estado", SqlDbType.Int).Value = resultado;

                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                pexitoso.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
            }
            Conn.Close();
            return "{\"success\": \"" + Exitoso + "\"}";
            
        }
    }
///////*********** ************ ************////////

}
