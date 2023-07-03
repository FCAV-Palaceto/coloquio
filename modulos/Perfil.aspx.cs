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

public partial class modulos_Perfil : System.Web.UI.Page
{
    public int user,tipo;
    protected void Page_Load(object sender, EventArgs e)
    {
        user = Convert.ToInt32(HttpContext.Current.Session["idusuario"]);
        tipo = Convert.ToInt32(HttpContext.Current.Session["tipoUsuario"]);

    }

    [WebMethod]
    public static string modusuario(int id)
    {
        StringBuilder sb = new StringBuilder();
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
                        sb.Append("{\"nom\": \"" + dr["nombre"].ToString().Trim() + "\",\"apell\": \"" + dr["apellidos"].ToString().Trim() + "\",\"inst\": \"" + dr["institucion"].ToString().Trim() + "\",\"depen\": \"" + dr["dependencia"].ToString().Trim() + "\",\"estado\": \"" + dr["estado"].ToString().Trim() + "\",\"ciud\": \"" + dr["ciudad"].ToString().Trim() + "\",\"tel\": \"" + dr["telefono"].ToString().Trim() + "\",\"idT\": \"" + dr["idTipo"].ToString().Trim() + "\",\"eml\": \"" + dr["email"].ToString().Trim() + "\",\"contra\": \"" + dr["contrasena"].ToString().Trim() + "\",\"cp\": \"" + dr["curp"].ToString().Trim() + "\"}");
                    }
                    dr.Close();
                }
            }
            con.Close();
        }
        return sb.ToString();
    }

    [WebMethod]
    public static string ActualizarUsuario(string nombre,string apellidos, string telefono, string contrasena, int id, string curp)
    {
        int Exitoso = 0;
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ActualizarPerfil", con))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@nombre", SqlDbType.NVarChar, 120).Value = nombre;
                comand.Parameters.Add("@apellidos", SqlDbType.NVarChar, 120).Value = apellidos;
                comand.Parameters.Add("@telefono", SqlDbType.NVarChar, 120).Value = telefono;
                comand.Parameters.Add("@contrasena", SqlDbType.NVarChar, 120).Value = contrasena;
                comand.Parameters.Add("@idUsu", SqlDbType.Int).Value = id;
                comand.Parameters.Add("@curp", SqlDbType.NVarChar, 120).Value = curp;
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