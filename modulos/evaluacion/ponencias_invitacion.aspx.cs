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

public partial class modulos_evaluacion_ponencias_invitacion : System.Web.UI.Page
{
    protected string idusuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        idusuario = Convert.ToString(HttpContext.Current.Session["idusuario"]);
    }

    [WebMethod]
    public static string TablaListarInvitacion()
    {
        string user = Convert.ToString(HttpContext.Current.Session["idusuario"]);

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarInvitacion", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idUsuario", user);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\" width=\"15%\">Título</th><th scope=\"col\" width=\"35%\">Resumen</th><th scope=\"col\" width=\"10%\">Modalidad</th><th scope=\"col\" width=\"10%\">Ronda</th><th scope=\"col\" width=\"10%\">Ver Ponencia</th><th scope=\"col\" width=\"10%\">Aceptar</th><th scope=\"col\" width=\"10%\">Rechazar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<tr style=\"vertical-align:middle;\">");
                        sb.Append("<td>" + drseldatos["titulo"].ToString() + "</td>");
                        sb.Append("<td>" + drseldatos["resumen"].ToString() + "</td>");
                        sb.Append("<td>" + drseldatos["modalidad"].ToString() + "</td>");
                        sb.Append("<td>" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-dark text-white\" onclick=\"verPonencia(" + drseldatos["idPonencia"].ToString() + "," + HttpContext.Current.Session["idusuario"].ToString() + "," + drseldatos["ronda"].ToString() + "," + drseldatos["idUsuario"].ToString() + ");\"><i class=\"fa-sharp fa-solid fa fa-magnifying-glass\"></i></button></td>");
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"modalAceptar(" + drseldatos["idInvitacion"].ToString() + "," + drseldatos["idPonencia"].ToString() + ");\"><i class=\"fa fa-check\"></i></button></td>");
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-danger text-white\" onclick=\"modalRechazar(" + drseldatos["idInvitacion"].ToString() + ");\"><i class=\"fa fa-times\"></i></button></td></tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Invitaciones</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay invitaciones pendientes.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string AceptarInvitacion(int idInvitacion, int idPonencia, int idUsuario)
    {
        int Exitoso = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("AceptarInvitacion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idInvitacion", SqlDbType.Int).Value = idInvitacion;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;
                comand.Parameters.Add("@idUsuario", SqlDbType.Int).Value = idUsuario;

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
    public static string RechazarInvitacion(int id)
    {
        int Exitoso = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("RechazarInvitacion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idInvitacion", SqlDbType.Int).Value = id;

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
    public static string TablaListarComentarios(int idPonencia, int idUsuario, int ronda)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarComentarios", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", idPonencia);
                seldata.Parameters.AddWithValue("@idUsuario", idUsuario);
                seldata.Parameters.AddWithValue("@ronda", ronda);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    sb.Append("<table id=\"tablaComentarios\" class=\"table table-striped table-bordered \">");
                    sb.Append("<thead>");
                    sb.Append("<tr>");
                    sb.Append("<th scope=\"col\">Fecha</th>");
                    sb.Append("<th scope=\"col\">Comentarios</th>");
                    sb.Append("<th scope=\"col\">Ronda</th>");
                    sb.Append("</tr>");
                    sb.Append("</thead>");
                    sb.Append("<tbody>");

                    while (drseldatos.Read())
                    {
                        sb.Append("<tr class=\"align-middle\">");
                        sb.Append("<td width=\"25%\">" + drseldatos["fechaEvaluacion"].ToString() + "</td>");
                        sb.Append("<td width=\"60%\">" + drseldatos["observaciones"].ToString() + "</td>");
                        sb.Append("<td width=\"15%\" class=\"text-center\">" + drseldatos["ronda"].ToString() + "</td>");
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
}

