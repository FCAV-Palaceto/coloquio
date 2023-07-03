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

public partial class modulos_evaluacion_ponencias_evaluadas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string TablaListarPonencias()
    {
        string user = Convert.ToString(HttpContext.Current.Session["idusuario"]);
        int estado;

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarEvaluadas", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idUsuario", user);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\" width=\"35%\">Título</th><th scope=\"col\" width=\"20%\">Fecha de Evaluación</th><th scope=\"col\" width=\"10%\">Ronda</th><th scope=\"col\" width=\"15%\">Resultado</th><th scope=\"col\" width=\"10%\">Evaluación</th><th scope=\"col\" width=\"10%\">Ver Ponencia</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        estado = Convert.ToInt32(drseldatos["aptoPublicacion"].ToString());
                        sb.Append("<tr style=\"vertical-align:middle;\">");
                        sb.Append("<td>" + drseldatos["titulo"].ToString() + "</td>");
                        // sb.Append("<td>" + drseldatos["modalidad"].ToString() + "</td>");
                        // sb.Append("<td>" + drseldatos["edicion"].ToString() + "</td>");
                        sb.Append("<td>" + drseldatos["fechaEvaluacion"].ToString() + "</td>");
                        sb.Append("<td>" + drseldatos["ronda"].ToString() + "° Ronda</td>");
                        //sb.Append("<td class=\"align-middle text-center\">");
                        switch (estado)
                        {
                            case 1:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-check text-success\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-success\" style=\"font-size:14px;\">Aprobada</span></td>");
                                break;
                            case 2:
                                //sb.Append("<i class=\"fa-sharp fa-solid fa-xmark text-danger\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-danger\" style=\"font-size:14px;\">Rechazada</span></td>");
                                break;
                            case 3:
                                //sb.Append("<i class=\"fa-solid fa-triangle-exclamation text-warning\" style=\"font-size:1.2em;\"></i>");
                                sb.Append("<td align=\"center\" class=\"align-middle\"><span class=\"badge bg-warning\" style=\"color:#000;font-size:14px;\">Aprobada con cambios</span></td>");
                                break;
                        }
                        //sb.Append("</td>");                        
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"verEvaluacion(" + drseldatos["idPonencia"].ToString() + ",'" + drseldatos["titulo"].ToString() + "'," + drseldatos["idEvaluacion"].ToString() + ");\"><i class=\"fa-regular fa-clipboard\" aria-hidden=\"true\"></i></td></button>");
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-dark text-white\" onclick=\"verPonencia(" + drseldatos["idPonencia"].ToString() + ", " + drseldatos["idUsuario"].ToString() + ", " + drseldatos["ronda"].ToString() + ");\"><i class=\"fa fa-magnifying-glass\" aria-hidden=\"true\"></i></button></td></tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Evaluaciones</th></tr></thead><tbody>");
                        sb.Append("<td colspan=\"3\" style=\"text-align: center;\">No se han evaluado ponencias.</td></tbody></table>");
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
                        sb.Append("{\"titulo\": \"" + dr["titulo"].ToString().Trim().Replace("\\", "\\\\").Replace("\"", "\\\"") + "\", \"modalidad\": \"" + dr["modalidad"].ToString().Trim().Replace("\\", "\\\\").Replace("\"", "\\\"") + "\", \"tema\": \"" + dr["tema"].ToString().Trim().Replace("\\", "\\\\").Replace("\"", "\\\"") + "\", \"resumen\": \"" + dr["resumen"].ToString().Trim().Replace("\\", "\\\\").Replace("\"", "\\\"") + "\", \"palabrasClave\": \"" + dr["palabrasClave"].ToString().Trim().Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"}");
                    }
                    dr.Close();
                }
            }
            Conn.Close();
        }
        HttpContext.Current.Session["idponencia"] = id;

        return sb.ToString();
    }


    [WebMethod]
    public static string VerEval(int idEvaluacion)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("VerEvaluacion", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idEvaluacion", idEvaluacion);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    string x = "";
                    int ptsTotales = 0;
                    int suma = 0;

                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tablaEv\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Sección</th><th  scope=\"col\">Parámetro</th><th scope=\"col\" style=\"text-align:center !important; max-width: 100px !important;\">Puntaje Máximo</th><th scope=\"col\" style=\"text-align:center !important; max-width: 80px !important\">Puntaje Otorgado</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        int puntajeMax = Convert.ToInt32(drseldatos["puntajeMax"]);
                        ptsTotales += puntajeMax;
                        string y = Convert.ToString(drseldatos["seccion"]);

                        sb.Append("<tr>");
                        if (x == y)
                        {
                            sb.Append("<td style=\"font-size:0px\">" + drseldatos["seccion"].ToString() + "</td>");
                        }
                        else
                        {
                            sb.Append("<td data-order=\"\">" + drseldatos["seccion"].ToString() + "</td>");
                            x = Convert.ToString(drseldatos["seccion"]);
                        }
                        sb.Append("<td data-order=\"\">" + drseldatos["parametro"].ToString() + "</td>");
                        sb.Append("<td align=\"center\" data-order=\"\">" + puntajeMax + "</td>");
                        sb.Append("<td align=\"center\" data-order=\"\"><select class=\"form-select w-auto\" disabled>");
                        suma += Convert.ToInt32(drseldatos["calificacion"].ToString());
                        sb.Append("<option value=" + drseldatos["calificacion"].ToString() + ">" + drseldatos["calificacion"].ToString() + "</option>");
                        sb.Append("</select></td></tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody>");
                        sb.Append("<tfoot><tr>");
                        sb.Append("<td><b>Puntajes</b></td>");
                        sb.Append("<td style=\"text-align:right !important\"><b>Total:</b></td>");
                        sb.Append("<td style=\"text-align:center !important\"><b>" + ptsTotales + " Puntos</b></td>");
                        sb.Append("<td style=\"text-align:center !important\"><b>" + suma + " Puntos</b></td>");
                        sb.Append("</tr></tfoot>");
                        sb.Append("</table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Evaluación</th></tr></thead><tbody>");
                        sb.Append("<tr><td style=\"text-align: center;\">No hay parámetros disponibles.</td></tr></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }


    [WebMethod]
    public static string TablaListarComentarios(int idPonencia, int idUsuario, int ronda)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarComentariosEvaluadas", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                seldata.Parameters.AddWithValue("@idPonencia", idPonencia);
                //seldata.Parameters.AddWithValue("@idUsuario", idUsuario);
                seldata.Parameters.AddWithValue("@idUsuario", Convert.ToInt32(HttpContext.Current.Session["idusuario"]));
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
