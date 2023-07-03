using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

public partial class modulos_administrador_secciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DropEdiciones();
        ddledicion.Enabled = false;

    }

    private void DropEdiciones()
        {
            using (SqlConnection con = conn.conecta())
            {
                using (SqlCommand cmdSeluam = new SqlCommand("SelEdiciones", con))
                {
                    cmdSeluam.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    ddledicion.Items.Clear();
                    ddledicion.AppendDataBoundItems = true;
                    //ddledicion.Items.Add(new ListItem("- Seleccione una edición -", "0"));
                    SqlDataReader drcar = cmdSeluam.ExecuteReader();
                    while (drcar.Read())
                    {
                        ddledicion.Items.Add(new ListItem(drcar["edicion"].ToString(), drcar["idEdicion"].ToString()));
                    }
                    drcar.Close();
                    drcar.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
        }

    [WebMethod]
    public static string TablaListarSecciones()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarSecciones", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                    sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Sección</th><th scope=\"col\">Edición</th><th scope=\"col\" style=\"max-width: 150px;\">Acciones</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["seccion"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["edicion"].ToString() + "</td>");
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info fa fa-pencil text-white\" onclick=\"ModificarSeccion(" + drseldatos["idSeccion"].ToString() + ");\"></button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-danger fa fa-trash text-white m-1\" onclick=\"ConfirmarEliminar(" + drseldatos["idSeccion"].ToString() + ");\"></button></td></tr>");

                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Secciones</th></tr></thead><tbody>");
                        sb.Append("<td colspan=\"3\" style=\"text-align: center;\">No hay secciones disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string GuardarSeccion(string seccion, int edicion)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarSeccion", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@seccion", SqlDbType.NVarChar, 120).Value = seccion;
                comand.Parameters.Add("@edicion", SqlDbType.Int).Value = edicion;
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

    [WebMethod]
    public static string ActualizarSeccion(string seccion, int edicion, int id)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ActualizarSeccion", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@seccion", SqlDbType.NVarChar, 120).Value = seccion;
                comand.Parameters.Add("@edicion", SqlDbType.Int).Value = edicion;
                comand.Parameters.Add("@id", SqlDbType.Int).Value = id;
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

    [WebMethod]
    public static string ModSeccion(int id)
    {
        // StringBuilder sb = new StringBuilder();

        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ModSeccion", con))
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
                            seccion = dr["seccion"].ToString().Trim(),
                            edicion = dr["idEdicion"].ToString().Trim()
                        };

                        jsonString = serializer.Serialize(obj);
                        // sb.Append("{\"seccion\": \"" + dr["seccion"].ToString().Trim() + "\",\"edicion\": \"" + dr["idEdicion"].ToString().Trim() + "\"}");
                    }
                    dr.Close();
                }
            }
            con.Close();
        }
        // return sb.ToString();
        return jsonString;
    }

    [WebMethod]
        public static string EliminarSeccion(int id)
        {
            int Eliminado = 0;
            using (SqlConnection con = conn.conecta())
            {
                using (SqlCommand comand = new SqlCommand("EliminarSeccion", con))
                {
                    comand.CommandType = CommandType.StoredProcedure;
                    comand.Parameters.Add("@id", SqlDbType.Int).Value = id;
                    SqlParameter peliminado = comand.Parameters.Add("@Eliminado", SqlDbType.Int);
                    peliminado.Direction = ParameterDirection.Output;
                    con.Open();
                    comand.ExecuteNonQuery();
                    Eliminado = int.Parse(peliminado.Value.ToString());
                }
                con.Close();
                return "{\"success\": \"" + Eliminado + "\"}";
            }
        }
}