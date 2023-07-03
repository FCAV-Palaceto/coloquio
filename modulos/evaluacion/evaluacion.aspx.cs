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

public partial class modulos_evaluacion_evaluacion : System.Web.UI.Page
{
    // public string titulo = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        // titulo = Convert.ToString(HttpContext.Current.Session["titulo"]);

    }

    [WebMethod]
    public static string TablaListarPonencias()
    {
        int eval = Convert.ToInt32(HttpContext.Current.Session["idEvaluacion"]);

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("Evaluacion", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;                
                seldata.Parameters.AddWithValue("@idEvaluacion", eval);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    string x = "";
                    int ptsTotales = 0;
                    int regNum = 0;

                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Sección</th><th  scope=\"col\">Parámetro</th><th hidden>idParametro</th><th scope=\"col\" style=\"text-align:center !important; max-width: 120px !important;\">Puntaje Máximo</th><th scope=\"col\" style=\"text-align:center !important; max-width: 160px !important;\">Puntaje Otorgado</th></tr></thead><tbody>");
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
                        sb.Append("<td hidden data-order=\"\" id=\"idPar" + regNum + "\">" + drseldatos["idParametro"].ToString() + "</td>");
                        sb.Append("<td style=\"vertical-align:middle;text-align:center;\" data-order=\"\">" + puntajeMax + "</td>");
                        sb.Append("<td style=\"vertical-align:middle;text-align:center;\" data-order=\"\"><select id=\"sel" + regNum + "\" class=\"form-select w-auto\" oninput=sumatoria(); id=\"txtPuntaje" + puntajeMax + "\">");
                        sb.Append("<option value=\"0\">Seleccionar</option>");
                        for (int i = 1; i <= puntajeMax; i++)
                        {
                            if(i == 1)
                            sb.Append("<option value=" + i + ">" + i + " pt.</option>");
                            else 
                            sb.Append("<option value=" + i + ">" + i + " pts.</option>");
                        }                        
                        sb.Append("</select></td>");                        
                        regNum++;
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody>");
                        sb.Append("<tfoot><tr>");
                        sb.Append("<td><b>Puntajes</b></td>");
                        sb.Append("<td style=\"text-align:right !important\"><b>Total:</b></td>");
                        sb.Append("<td id=\"tdPuntos\" style=\"text-align:center !important\"><b>" + ptsTotales + " Puntos</b></td>");
                        sb.Append("<td style=\"text-align:center !important\" id=\"pts\"><b>0 Puntos</b></td>");
                        sb.Append("</tr></tfoot>");
                        sb.Append("</table>");
                        sb.Append("<input type=\"hidden\" value=\"" + regNum + "\" id= \"regTot\"></input>");
                        sb.Append("<script>setTimeout(function myfunction() {sumatoria();}, 200);</script>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Evaluación</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay parámetros disponibles.</td></tbody></table>");
                    }                                                                             
                    drseldatos.Close();
                    editarEvaluacion();
                }
            }
            con.Close();
            sb.Append(editarEvaluacion());//sirve para traer el resultado del string builder de "editarEvaluacion()" para pegarlo al string builder de este método de forma que los scripts de editarEvaluacion se peguen en el front que manda a llamar este método.
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string editarEvaluacion()
    {
        int eval = Convert.ToInt32(HttpContext.Current.Session["idEvaluacion"]);

        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("Evaluacion2", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;                
                seldata.Parameters.AddWithValue("@idEvaluacion", eval);
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {                                        
                    int regNum = 0;
                    int estado = 0;
                    if(drseldatos.HasRows){
                        while (drseldatos.Read()){
                            sb.Append("<script>$('#sel" + regNum + " option[value=" + drseldatos["calificacion"].ToString() + "]').attr('selected', 'selected');</script>");
                            regNum++;
                        }
                    
                        drseldatos.NextResult();
                        while (drseldatos.Read()){
                            sb.Append("<script>$('#spnTitulo').html('" + HttpUtility.JavaScriptStringEncode(drseldatos["titulo"].ToString().Replace("\r\n", "\\n")) + "');</script>");
                            sb.Append("<script>$('#txtObservaciones').val('" + HttpUtility.JavaScriptStringEncode(drseldatos["observaciones"].ToString().Replace("\r\n", "\\n")) + "');</script>");
                            sb.Append("<script>$('#txtRecomendaciones').val('" + HttpUtility.JavaScriptStringEncode(drseldatos["recomendaciones"].ToString().Replace("\r\n", "\\n")) + "');</script>");                            
                            
                            estado = Convert.ToInt32(drseldatos["aptoPublicacion"].ToString());
                            switch(estado){
                                case 1:
                                    sb.Append("<script>$('#btnAprobar').click();</script>");
                                    break;
                                case 3:
                                    sb.Append("<script>$('#btnAprobarCambios').click();</script>");
                                    break;
                                case 2:
                                    sb.Append("<script>$('#btnRechazar').click();</script>");
                                    break;
                                default:
                                    sb.Append("<script>$('input:radio[name=\"flexRadioDefault\"]').each(function(i) {this.checked = false;});</script>");
                                    break;
                            }
                        }
                    }                                                                                                
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string Guardar(string calif, string observaciones, string recomendaciones, string idParametro, int estado, int completo)
    {
        int Exitoso = 0;        

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarEvaluacion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;

                comand.Parameters.Add("@califs", SqlDbType.NVarChar, -1).Value = calif;
                comand.Parameters.Add("@idParametro", SqlDbType.NVarChar, -1).Value = idParametro;
                comand.Parameters.Add("@observaciones", SqlDbType.NVarChar, -1).Value = observaciones;
                comand.Parameters.Add("@recomendaciones", SqlDbType.NVarChar, -1).Value = recomendaciones;                
                comand.Parameters.Add("@idEvaluacion", SqlDbType.Int).Value = Convert.ToString(HttpContext.Current.Session["idEvaluacion"]);
                comand.Parameters.Add("@estado", SqlDbType.Int).Value = estado;
                comand.Parameters.Add("@completo", SqlDbType.Int).Value = completo;

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
}
