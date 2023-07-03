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
using System.Web.Script.Serialization;

public partial class ediciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string TablaListarEdiciones()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarEdiciones", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\" style=\"width:50%;\">Edición</th><th scope=\"col\" style=\"width:30%;\">Estado</th><th scope=\"col\" style=\"width:10%;\">Editar</th><th scope=\"col\" style=\"width:10%;\">Eliminar</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        int activo = Convert.ToInt32(drseldatos["activo"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["edicion"].ToString() + "</td>");

                        if(activo == 1){
                            sb.Append("<td data-order=\"1\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"alternarActivo(" + drseldatos["idEdicion"].ToString() + ");\"><i class=\"fa fa-check\" aria-hidden=\"true\"></i></button>");
                        } else {
                            sb.Append("<td data-order=\"0\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"alternarActivo(" + drseldatos["idEdicion"].ToString() + ");\"><i class=\"fa fa-ban\" aria-hidden=\"true\"></i></button>");
                        }

                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"ModalEditar(" + drseldatos["idEdicion"].ToString() + ");\"><i class=\"fa fa-pencil\" aria-hidden=\"true\"></i></button></td>");
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-danger text-white m-1\" onclick=\"ConfirmarEliminar(" + drseldatos["idEdicion"].ToString() + ");\"><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></button></td></tr>");

                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Ediciones</th></tr></thead><tbody>");
                        sb.Append("<td colspan=\"5\" style=\"text-align: center;\">No hay ediciones disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string editarEdicion(int id){
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("editarEdicion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idEdicion", SqlDbType.Int).Value = id;

                SqlParameter pedicion = comand.Parameters.Add("@edicion", SqlDbType.NVarChar, 20);
                pedicion.Direction = ParameterDirection.Output;

                Conn.Open();
                comand.ExecuteNonQuery();

                HttpContext.Current.Session["idEdicion"] = id;
                HttpContext.Current.Session["edicion"] = pedicion.Value.ToString();
            }
            Conn.Close();
            return "";
        }
    }


    [WebMethod]
    public static string traeEdicion(int id){
        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("TraeEdicion ", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@id", SqlDbType.Int).Value = id;
                con.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var obj = new
                        {
                            id = dr["idEdicion"].ToString().Trim(),
                            edicion = dr["edicion"].ToString().Trim()
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


    [WebMethod]
    public static string borrarEdicion(int id){
        int Eliminado = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EliminarEdicionCompleta", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idEdicion", SqlDbType.Int).Value = id;

                SqlParameter peliminado = comand.Parameters.Add("@Eliminado", SqlDbType.Int);
                peliminado.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Eliminado = int.Parse(peliminado.Value.ToString());
            }
            Conn.Close();
            return "{\"success\": \"" + Eliminado + "\"}";
        }
    }

    [WebMethod]
    public static string alternarActivo(int id){
        int Exitoso = 1;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("activarEdicion", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.AddWithValue("@idEdicion", id);
                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                pexitoso.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
            }
            Conn.Close();

            // Actualiza la variable de sesión de la edición Activa
            HttpContext.Current.Session["edicionActiva"] = id;

            return "{\"success\": \"" + Exitoso + "\"}";
        }
        //HttpContext.Current.Session["idEdicion"] = id;
        //return "{\"Success\": \"" + Exitoso + "\"}";
    }

    [WebMethod]
    public static string ModificarEdicion(int id, string newEdicion){
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand command = new SqlCommand("updateEdicion", Conn))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@idEdicion", SqlDbType.Int).Value = id;
                command.Parameters.Add("@edicion", SqlDbType.NVarChar, 20).Value = newEdicion;

                Conn.Open();
                command.ExecuteNonQuery();
            }
            Conn.Close();
            return "";
        }
    }

    [WebMethod]
    public static string EdicionPredeterminada()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("EdicionPredeterminada", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    string x = "";
                    int ptsTotales = 0;
                    int regNum = 0;
                    

                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"EdicionPre\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Sección</th><th  scope=\"col\">Parámetros</th><th scope=\"col\">Putntaje Maximo</th><th hidden>idParametro</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        int puntajeMax= Convert.ToInt32(drseldatos["puntajeMax"]);
                        ptsTotales+=puntajeMax;
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
                        sb.Append("<td hidden data-order=\"\" id=\"idPar" + regNum + "\">" + drseldatos["idParametro"].ToString() + "</td>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("<tfoot><tr>");
                        sb.Append("<td><b>Puntajes</b></td>");
                        sb.Append("<td style=\"text-align:right !important\"><b>Total:</b></td>");
                        sb.Append("<td id=\"tdPuntos\" style=\"text-align:center !important\"><b>" + ptsTotales + " Puntos</b></td>");
                        //sb.Append("<td style=\"text-align:center !important\" id=\"pts\"><b>0 Puntos</b></td>");
                        sb.Append("</tr></tfoot>");
                        sb.Append("</tbody></table>");
                        sb.Append("<input type=\"hidden\" value=\"" + regNum + "\" id= \"regTot\"></input>");
                    }
                    else
                    {
                        sb.Append("<table id=\"EdicionPre\" width=\"100%\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Edición</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay parámetros disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string GuardarEdicion(string nombre, int opcion){
        var Exitoso = 2;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarEdicion", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@Nombre", SqlDbType.NVarChar, 120).Value = nombre;
                comand.Parameters.Add("@Opcion", SqlDbType.Int).Value = opcion;
                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                pexitoso.Direction = ParameterDirection.Output;
                con.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
            }
            con.Close();
            return "{\"success\": \"" + Exitoso + "\"}";
        }
    }
}