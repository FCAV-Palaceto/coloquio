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

public partial class ponencias_editar : System.Web.UI.Page
{    
    protected string idponencia;

    protected void Page_Load(object sender, EventArgs e)
    {        
        idponencia = Convert.ToString(HttpContext.Current.Session["idponencia"]);
           CargarModalidad();   
           CargarTema();  
    }

    private void CargarModalidad()
    {
        
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand cmdSeltipo = new SqlCommand("SelModalidades", Conn))
            {
                cmdSeltipo.CommandType = CommandType.StoredProcedure;
                Conn.Open();
                txtmodalidad.Items.Clear();
                txtmodalidad.AppendDataBoundItems = true;
                txtmodalidad.Items.Add(new ListItem("Seleccionar...", "0"));
                SqlDataReader drtipo = cmdSeltipo.ExecuteReader();
                while (drtipo.Read())
                {
                    txtmodalidad.Items.Add(new ListItem(drtipo["modalidad"].ToString(), drtipo["idModalidad"].ToString()));
                }
                drtipo.Close();
                drtipo.Dispose();
                Conn.Close();
                Conn.Dispose();
            }
        }
    }

    private void CargarTema()
    {
        
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand cmdSeltipo = new SqlCommand("SelTema", Conn))
            {
                cmdSeltipo.CommandType = CommandType.StoredProcedure;
                Conn.Open();
                txttema.Items.Clear();
                txttema.AppendDataBoundItems = true;
                txttema.Items.Add(new ListItem("Seleccionar...", "0"));
                SqlDataReader drtipo = cmdSeltipo.ExecuteReader();
                while (drtipo.Read())
                {
                    txttema.Items.Add(new ListItem(drtipo["tema"].ToString(), drtipo["idTema"].ToString()));
                }
                drtipo.Close();
                drtipo.Dispose();
                Conn.Close();
                Conn.Dispose();
            }
        }
    }

    [WebMethod]
    public static string ModificarPonencia(int id)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection con = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ModPonencia", con))
            {                
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = id;
                con.Open();
                using (SqlDataReader dr = comand.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        sb.Append("{\"titulo\": \"" + dr["titulo"].ToString().Trim() + "\", \"modalidad\": \"" + dr["idModalidad"].ToString().Trim() + "\", \"tema\": \"" + dr["idTema"].ToString().Trim() + "\", \"resumen\": \"" + dr["resumen"].ToString().Trim() + "\",\"palabrasClave\": \"" + dr["palabrasClave"].ToString().Trim() + "\"}");
                    }
                    dr.Close();
                }
            }
            con.Close();
        }
        return sb.ToString();
    }   

    [WebMethod]
    public static string ModificarDatos(int idPonencia, string titulo, int modalidad, int tema, string resumen, string palabClave)
    {
        int Exitoso = 0;
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("ModificarDatos", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.Add("@idPonencia", SqlDbType.Int).Value = idPonencia;
                comand.Parameters.Add("@titulo", SqlDbType.NVarChar, 50).Value = titulo;
                comand.Parameters.Add("@modalidad", SqlDbType.Int).Value = modalidad;
                comand.Parameters.Add("@tema", SqlDbType.Int).Value = tema;
                comand.Parameters.Add("@resumen", SqlDbType.NVarChar, 50).Value = resumen;
                comand.Parameters.Add("@palabClave", SqlDbType.NVarChar, 50).Value = palabClave;                

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