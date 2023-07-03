using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

public partial class modulos_administrador_parametros : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DropSecciones();
        //DropEdiciones();
        //ddledicion.Enabled = false;
    }

    //private void DropEdiciones()
    //{
    //    using (SqlConnection con = conn.conecta())
    //    {
    //        using (SqlCommand cmdSeluam = new SqlCommand("SelEdiciones", con))
    //        {
    //            cmdSeluam.CommandType = CommandType.StoredProcedure;
    //            con.Open();
    //            ddledicion.Items.Clear();
    //            ddledicion.AppendDataBoundItems = true;
    //            //ddledicion.Items.Add(new ListItem("- Seleccione una edición -", "0"));
    //            SqlDataReader drcar = cmdSeluam.ExecuteReader();
    //            while (drcar.Read())
    //            {
    //                ddledicion.Items.Add(new ListItem(drcar["edicion"].ToString(), drcar["idEdicion"].ToString()));
    //            }
    //            drcar.Close();
    //            drcar.Dispose();
    //            con.Close();
    //            con.Dispose();
    //        }
    //    }
    //}


    private void DropSecciones()
    {
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand cmdSeluam = new SqlCommand("SelSecciones", con))
            {
                cmdSeluam.CommandType = CommandType.StoredProcedure;
                con.Open();
                ddlseccion.Items.Clear();
                ddlseccion.AppendDataBoundItems = true;
                ddlseccion.Items.Add(new ListItem("- Seleccione una sección -", "0"));
                SqlDataReader drcar = cmdSeluam.ExecuteReader();
                while (drcar.Read())
                {
                    ddlseccion.Items.Add(new ListItem(drcar["seccion"].ToString(), drcar["idSeccion"].ToString()));
                }
                drcar.Close();
                drcar.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string TablaListarParametros()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("ListarParametros", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Sección</th><th scope=\"col\">Parámetro</th><th scope=\"col\">Puntaje Máximo</th><th scope=\"col\">Estado</th><th scope=\"col\" style=\"max-width: 150px;\">Acciones</th></tr></thead><tbody>");
                    while (drseldatos.Read())
                    {
                        int activo = Convert.ToInt32(drseldatos["activo"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["seccion"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["parametro"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["puntajeMax"].ToString() + "</td>");
                        if(activo == 1){
                            sb.Append("<td data-order=\"1\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"alternarActivo(" + drseldatos["idParametro"].ToString() + ");\"><i class=\"fa fa-check\" aria-hidden=\"true\"></i></button>");
                        } else {
                            sb.Append("<td data-order=\"0\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"alternarActivo(" + drseldatos["idParametro"].ToString() + ");\"><i class=\"fa fa-ban\" aria-hidden=\"true\"></i></button>");
                        }

                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"ModificarParametro(" + drseldatos["idParametro"].ToString() + ");\"><i class=\"fa fa-pencil\" aria-hidden=\"true\"></i></button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-danger text-white m-1\" onclick=\"ConfirmarEliminar(" + drseldatos["idParametro"].ToString() + ");\"><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></button></td></tr>");

                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Parametros</th></tr></thead><tbody>");
                        sb.Append("<td colspan=\"6\" style=\"text-align: center;\">No hay parametros disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }

    [WebMethod]
    public static string GuardarParametro(string parametro, int seccion, int puntaje)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarParametro", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@parametro", SqlDbType.NVarChar, 120).Value = parametro;
                comand.Parameters.Add("@seccion", SqlDbType.Int).Value = seccion;
                comand.Parameters.Add("@puntaje", SqlDbType.Int).Value = puntaje;
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
    public static string ActualizarParametro(string parametro, int seccion, int puntaje ,int id)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ActualizarParametro", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@parametro", SqlDbType.NVarChar, 120).Value = parametro;
                comand.Parameters.Add("@seccion", SqlDbType.Int).Value = seccion;
                comand.Parameters.Add("@puntaje", SqlDbType.Int).Value = puntaje;
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
    public static string ModParametro(int id)
    {
        // StringBuilder sb = new StringBuilder();
        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ModParametro ", con))
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
                            seccion = dr["idSeccion"].ToString().Trim(),
                            parametro = dr["parametro"].ToString().Trim(),
                            puntaje = dr["puntajeMax"].ToString().Trim()
                        };

                        jsonString = serializer.Serialize(obj);
                        // sb.Append("{\"seccion\": \"" + dr["idSeccion"].ToString().Trim() + "\",\"parametro\": \"" + dr["parametro"].ToString().Trim() + "\",\"puntaje\": \"" + dr["puntajeMax"].ToString().Trim() + "\"}");
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
    public static string EliminarParametro(int id)
    {
        int Eliminado = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EliminarParametro", con))
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

    [WebMethod]
    public static string alternarActivo(int id)
    {
        int Exitoso = 1;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("activarParametro", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.AddWithValue("@idParametro", id);
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