using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
public partial class temas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DropEdiciones();
        edicion.Enabled = false;
    }
    private void DropEdiciones()
        {
            using (SqlConnection con = conn.conecta())
            {
                using (SqlCommand cmdSeluam = new SqlCommand("SelEdiciones", con))
                {
                    cmdSeluam.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    edicion.Items.Clear();
                    edicion.AppendDataBoundItems = true;
                    //edicion.Items.Add(new ListItem("- Seleccione una edición -", "0"));
                    SqlDataReader drcar = cmdSeluam.ExecuteReader();
                    while (drcar.Read())
                    {
                        edicion.Items.Add(new ListItem(drcar["edicion"].ToString(), drcar["idEdicion"].ToString()));
                    }
                    drcar.Close();
                    drcar.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
        }

    [WebMethod]
    public static string TablaListarTemas()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarTemas", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                    sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Temas</th><th scope=\"col\">Edición</th><th scope=\"col\">Estado</th><th scope=\"col\">Acciones</th><tbody>");
                    while (drseldatos.Read())
                    {
                        int activo = Convert.ToInt32(drseldatos["activo"].ToString());
                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["tema"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["edicion"].ToString() + "</td>");
                        if (activo == 1)
                        {
                            sb.Append("<td data-order=\"1\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"alternarActivo(" + drseldatos["idTema"].ToString() + ");\"><i class=\"fa fa-check\" aria-hidden=\"true\"></i></button></td>");
                        }
                        else
                        {
                            sb.Append("<td data-order=\"0\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"alternarActivo(" + drseldatos["idTema"].ToString() + ");\"><i class=\"fa fa-ban\" aria-hidden=\"true\"></i></button></td>");
                        }
                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"ModificarTema(" + drseldatos["idTema"].ToString() + ");\"><i class=\"fa fa-pencil\" aria-hidden=\"true\"></i></button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-danger text-white m-1\" onclick=\"ConfirmarEliminar(" + drseldatos["idTema"].ToString() + ");\"><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></button></td></tr>");
                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Temas</th></tr></thead><tbody>");
                        sb.Append("<td colspan=\"3\" style=\"text-align: center;\">No hay temas disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string GuardarTema(string tema, int edicion)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarTema", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@tema", SqlDbType.NVarChar, 120).Value = tema;
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
    public static string updateTema(string tema, int edicion, int id)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("updateTema", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@tema", SqlDbType.NVarChar, 120).Value = tema;
                comand.Parameters.Add("@edicion", SqlDbType.Int).Value = edicion;
                comand.Parameters.Add("@idTema", SqlDbType.Int).Value = id;
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
    public static string editarTema(int id)
    {
        // StringBuilder sb = new StringBuilder();
        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("editarTema", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idTema", SqlDbType.Int).Value = id;
                con.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var obj = new
                        {
                            tema = dr["tema"].ToString().Trim(),
                            edicion = dr["idEdicion"].ToString().Trim()
                        };

                        jsonString = serializer.Serialize(obj);
                        // sb.Append("{\"tema\": \"" + dr["tema"].ToString().Trim() + "\",\"edicion\": \"" + dr["idEdicion"].ToString().Trim() + "\"}");
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
        public static string borrarTema(int id)
        {
            int Eliminado = 0;
            using (SqlConnection con = conn.conecta())
            {
                using (SqlCommand comand = new SqlCommand("EliminarTema", con))
                {
                    comand.CommandType = CommandType.StoredProcedure;
                    comand.Parameters.Add("@idTema", SqlDbType.Int).Value = id;
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

    [WebMethod]
    public static string alternarActivo(int id)
    {
        int Exitoso = 1;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("activarTema", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.AddWithValue("@idTema", id);
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
