using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Text;

public partial class reporte_ponencias : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string reportePonencias(){

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarReporteEvaluacion", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Titulo</th><th scope=\"col\">Autor(es)</th><th scope=\"col\">Calificación</th><th scope=\"col\">Evaluador(es)</th><th scope=\"col\">Comentarios</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<tr>");                        
                        sb.Append("<td class=\"align-middle\" width=\"60%\">" + drseldatos["titulo"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\" width=\"60%\">" + drseldatos["autor"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\" width=\"20%\">" + drseldatos["calif"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\" width=\"20%\">" + drseldatos["Evaluadores"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\" width=\"60%\">" + drseldatos["Comentarios"].ToString() + "</td>");
                        sb.Append("</tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tablaC\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Ponencias</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay ponencias disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }
}