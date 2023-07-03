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

public partial class usuarios : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CargarTipos();
        CargarMesas();
    }

    [WebMethod]
    public static string TablaListarUsuarios()
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand seldata = new SqlCommand("selusuarios", con))
            {
                seldata.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader drseldatos = seldata.ExecuteReader())
                {
                    if (drseldatos.HasRows)
                    sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Nombre</th><th scope=\"col\" style=\"max-width: 150px;\">Email</th><th scope=\"col\">Tipo</th><th scope=\"col\">Estado</th><th scope=\"col\">Acciones</th><tbody>");
                    while (drseldatos.Read())
                    {
                        int activo = Convert.ToInt32(drseldatos["activo"].ToString());

                        sb.Append("<tr>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["nombre"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["email"].ToString() + "</td>");
                        sb.Append("<td class=\"align-middle\">" + drseldatos["tipo"].ToString() + "</td>");

                        //  if(activo == 1){
                        //     sb.Append("<td data-order=\"1\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success fa fa-check text-white\" style=\"width: 1.2em; height: 1.5em; onclick=\"alternarActivo(" + drseldatos["idUsuario"].ToString() + ");\"></button>");
                        // } else {
                        //     sb.Append("<td data-order=\"0\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary fa fa-ban text-white\" style=\"width: 1.2em; height: 1.5em; onclick=\"alternarActivo(" + drseldatos["idUsuario"].ToString() + ");\"></button>");
                        // }

                        if (activo == 1)
                        {
                            sb.Append("<td data-order=\"1\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-success text-white\" onclick=\"alternarActivo(" + drseldatos["idUsuario"].ToString() + ");\"><i class=\"fa fa-check\" aria-hidden=\"true\"></i></button>");
                        }
                        else
                        {
                            sb.Append("<td data-order=\"0\" align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-secondary text-white\" onclick=\"alternarActivo(" + drseldatos["idUsuario"].ToString() + ");\"><i class=\"fa fa-ban\" aria-hidden=\"true\"></i></button>");
                        }


                        sb.Append("<td align=\"center\"><button type=\"button\" class=\"btn btn-icon btn-info text-white\" onclick=\"ModificarUsuario(" + drseldatos["idUsuario"].ToString() + ")\" ><i class=\"fa fa-pencil\" aria-hidden=\"true\"></i></button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-icon btn-danger text-white m-1\" onclick=\"ConfirmarEliminar(" + drseldatos["idUsuario"].ToString() + ");\"><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></button></td></tr>");


                    }
                    if (drseldatos.HasRows)
                    {
                        sb.Append("</tbody></table>");
                    }
                    else
                    {
                        sb.Append("<table id=\"tabla\" class=\"table table-striped table-bordered \"><thead><tr><th scope=\"col\">Usuarios</th></tr></thead><tbody>");
                        sb.Append("<td colspan=\"5\" style=\"text-align: center;\">No hay usuarios disponibles.</td></tbody></table>");
                    }
                    drseldatos.Close();
                }
            }
            con.Close();
            return sb.ToString();
        }
    }
    private void CargarTipos()
    {

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand cmdSeltipo = new SqlCommand("SelTipo", Conn))
            {
                cmdSeltipo.CommandType = CommandType.StoredProcedure;
                Conn.Open();
                txtTipo.Items.Clear();
                txtTipo.AppendDataBoundItems = true;
                txtTipo.Items.Add(new ListItem("Seleccionar...", "0"));
                SqlDataReader drtipo = cmdSeltipo.ExecuteReader();
                while (drtipo.Read())
                {
                    txtTipo.Items.Add(new ListItem(drtipo["tipo"].ToString(), drtipo["idTipo"].ToString()));
                }
                drtipo.Close();
                drtipo.Dispose();
                Conn.Close();
                Conn.Dispose();
            }
        }
    }

    private void CargarMesas()
    {

        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand cmdSeltipo = new SqlCommand("SelMesasT", Conn))
            {
                cmdSeltipo.CommandType = CommandType.StoredProcedure;
                Conn.Open();
                inputMesa.Items.Clear();
                inputMesa.AppendDataBoundItems = true;
                inputMesa.Items.Add(new ListItem("Sin especificar", "0"));
                SqlDataReader drtipo = cmdSeltipo.ExecuteReader();
                while (drtipo.Read())
                {
                    inputMesa.Items.Add(new ListItem(drtipo["tema"].ToString(), drtipo["idTema"].ToString()));
                }
                drtipo.Close();
                drtipo.Dispose();
                Conn.Close();
                Conn.Dispose();
            }
        }
    }

[WebMethod]
    public static string GuardarUsuario(string nombre,string apellidos, string telefono, int tipo, string email, string contrasena, string curp, int mesa, int resp)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("GuardarUsuario", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@nombre", SqlDbType.NVarChar, 120).Value = nombre;
                comand.Parameters.Add("@apellidos", SqlDbType.NVarChar, 120).Value = apellidos;
                comand.Parameters.Add("@telefono", SqlDbType.NVarChar, 120).Value = telefono;
                comand.Parameters.Add("@tipo", SqlDbType.Int).Value = tipo;
                comand.Parameters.Add("@email", SqlDbType.NVarChar, 120).Value = email;
                comand.Parameters.Add("@contrasena", SqlDbType.NVarChar, 120).Value = contrasena;
                comand.Parameters.Add("@curp", SqlDbType.NVarChar, 120).Value = curp;
                comand.Parameters.Add("@mesa", SqlDbType.Int).Value = mesa;
                comand.Parameters.Add("@responsable", SqlDbType.Int).Value = resp;
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
    public static string ActualizarUsuario(string nombre,string apellidos, string telefono, int tipo, string email, string contrasena, int id, string curp, int mesa, int resp)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ActualizarUsuario", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@nombre", SqlDbType.NVarChar, 120).Value = nombre;
                comand.Parameters.Add("@apellidos", SqlDbType.NVarChar, 120).Value = apellidos;
                comand.Parameters.Add("@telefono", SqlDbType.NVarChar, 120).Value = telefono;
                comand.Parameters.Add("@tipo", SqlDbType.Int).Value = tipo;
                comand.Parameters.Add("@email", SqlDbType.NVarChar, 120).Value = email;
                comand.Parameters.Add("@contrasena", SqlDbType.NVarChar, 120).Value = contrasena;
                comand.Parameters.Add("@idUsu", SqlDbType.Int).Value = id;
                comand.Parameters.Add("@curp", SqlDbType.NVarChar, 120).Value = curp;
                comand.Parameters.Add("@mesa", SqlDbType.Int).Value = mesa;
                comand.Parameters.Add("@responsable", SqlDbType.Int).Value = resp;
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
    public static string alternarActivo(int id)
    {
        int Exitoso = 1;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("activarUsuario", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.AddWithValue("@idUsuario", id);
                SqlParameter pexitoso = comand.Parameters.Add("@Exitoso", SqlDbType.Int);
                pexitoso.Direction = ParameterDirection.Output;
                Conn.Open();
                comand.ExecuteNonQuery();
                Exitoso = int.Parse(pexitoso.Value.ToString());
            }
            Conn.Close();
            return "{\"success\": \"" + Exitoso + "\"}";
        }
        //HttpContext.Current.Session["idEdicion"] = id;
        //return "{\"Success\": \"" + Exitoso + "\"}";
    }

    [WebMethod]
    public static string modusuario(int id)
    {
        // StringBuilder sb = new StringBuilder();
        var serializer = new JavaScriptSerializer();
        string jsonString = string.Empty;

        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("selidusuario", con))
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
                            nom = dr["nombre"].ToString().Trim(),
                            apell = dr["apellidos"].ToString().Trim(),
                            inst = dr["institucion"].ToString().Trim(),
                            depen = dr["dependencia"].ToString().Trim(),
                            estado = dr["estado"].ToString().Trim(),
                            ciud = dr["ciudad"].ToString().Trim(),
                            tel = dr["telefono"].ToString().Trim(),
                            idT = dr["idTipo"].ToString().Trim(),
                            eml = dr["email"].ToString().Trim(),
                            contra = dr["contrasena"].ToString().Trim(),
                            cp = dr["curp"].ToString().Trim(),
                            mesa = dr["mesa"].ToString().Trim(),
                            resp = dr["responsable_mesa"].ToString().Trim()
                        };

                        jsonString = serializer.Serialize(obj);
                        // sb.Append("{\"nom\": \"" + dr["nombre"].ToString().Trim() + "\",\"apell\": \"" + dr["apellidos"].ToString().Trim() + "\",\"inst\": \"" + dr["institucion"].ToString().Trim() + "\",\"depen\": \"" + dr["dependencia"].ToString().Trim() + "\",\"estado\": \"" + dr["estado"].ToString().Trim() + "\",\"ciud\": \"" + dr["ciudad"].ToString().Trim() + "\",\"tel\": \"" + dr["telefono"].ToString().Trim() + "\",\"idT\": \"" + dr["idTipo"].ToString().Trim() + "\",\"eml\": \"" + dr["email"].ToString().Trim() + "\",\"contra\": \"" + dr["contrasena"].ToString().Trim() + "\",\"cp\": \"" + dr["curp"].ToString().Trim() + "\"}");
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
    public static string borrarUsuario(int id)
    {
        int Eliminado = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EliminarUsuario", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idUsuario", SqlDbType.Int).Value = id;

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
}