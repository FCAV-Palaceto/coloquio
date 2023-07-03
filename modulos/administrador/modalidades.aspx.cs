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

public partial class modalidades : System.Web.UI.Page
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
    public static string TablaListarModalidades()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarModalidades", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                    sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Modalidad</th><th scope=\"col\">Edición</th><th scope=\"col\">Estado</th><th scope=\"col\">Acciones</th><tbody>");
                    while (drseldatos.Read())
                    {
                        int activo = Convert.ToInt32(drseldatos["activo"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["modalidad"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["edicion"].ToString() + "</td>");


                        if(activo == 1){
                            sb.Append("<td data-order=\"1\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"alternarActivo(" + drseldatos["idModalidad"].ToString() + ");\"><i class=\"fa fa-check\" aria-hidden=\"true\"></i></button>");
                        } else {
                            sb.Append("<td data-order=\"0\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"alternarActivo(" + drseldatos["idModalidad"].ToString() + ");\"><i class=\"fa fa-ban\" aria-hidden=\"true\"></i></button>");
                        }

                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"ModificarModalidad(" + drseldatos["idModalidad"].ToString() + ");\"><i class=\"fa fa-pencil\" aria-hidden=\"true\"></i></button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-danger text-white m-1\" onclick=\"ConfirmarEliminar(" + drseldatos["idModalidad"].ToString() + ");\"><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></button></td></tr>");



                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Modalidades</th></tr></thead><tbody>");
                        sb.Append("<td style=\"text-align: center;\">No hay modalidades disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string alternarActivo(int id)
    {
        int Exitoso = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("activarModalidad", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.AddWithValue("@idModalidad", id);
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
    public static string borrarModalidad(int id){
        int Eliminado = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("eliminarModalidad", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idModalidad", SqlDbType.Int).Value = id;

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
    public static string GuardarModalidad(string Modalidad ,int Edicion)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarModalidad", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@Modalidad", SqlDbType.NVarChar, 30).Value = Modalidad;
                comand.Parameters.Add("@Edicion", SqlDbType.Int).Value = Edicion;
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
    public static string ActualizarModalidad(string Modalidad, int Edicion ,int id)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ActualizarModalidad", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@modalidad", SqlDbType.NVarChar, 30).Value = Modalidad;
                comand.Parameters.Add("@edicion", SqlDbType.Int).Value = Edicion;
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
    public static string ModModalidad(int idModalidad)
    {
        // StringBuilder sb = new StringBuilder();
        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ModModalidad", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idModalidad", SqlDbType.Int).Value = idModalidad;
                con.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var obj = new
                        {
                            modalidad = dr["modalidad"].ToString().Trim()
                        };

                        jsonString = serializer.Serialize(obj);

                        // sb.Append("{\"modalidad\": \"" + dr["modalidad"].ToString().Trim() + "\"}");
                    }
                    dr.Close();
                }
            }
            con.Close();
        }
        // return sb.ToString();
        return jsonString;
    }

}
