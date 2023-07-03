using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void login_Click(object sender, EventArgs e)
    {
        string email = inputEmail.Text;
        string pass = inputPassword.Text;

        int idUsuario;
        int activo;
        int tipo;
        int edicion;
        int resp;
        string nombre = "";
        if (email == "")
        {
            lblTxt.Text = "¡Porfavor ingrese un correo electrónico!";
        }
        else if (pass == "")
        {
            lblTxt.Text = "¡Porfavor ingrese una contraseña!";
        }
        else
        {
            using (SqlConnection Conn = conn.conecta())
            {
                using (SqlCommand comand = new SqlCommand("loginn", Conn))
                {
                    comand.CommandType = CommandType.StoredProcedure;
                    comand.Parameters.AddWithValue("@email", email);
                    comand.Parameters.AddWithValue("@pass", pass);

                    SqlParameter prmIdUsuario = new SqlParameter("@id", SqlDbType.Int);
                    prmIdUsuario.Direction = ParameterDirection.Output;
                    comand.Parameters.Add(prmIdUsuario);

                    SqlParameter prmNombre = new SqlParameter("@nombre", SqlDbType.NVarChar, 50);
                    prmNombre.Direction = ParameterDirection.Output;
                    comand.Parameters.Add(prmNombre);

                    SqlParameter prmTipo = new SqlParameter("@tipo", SqlDbType.Int);
                    prmTipo.Direction = ParameterDirection.Output;
                    comand.Parameters.Add(prmTipo);

                    SqlParameter prmActivo = new SqlParameter("@activo", SqlDbType.Int);
                    prmActivo.Direction = ParameterDirection.Output;
                    comand.Parameters.Add(prmActivo);

                    SqlParameter prmEdicion = new SqlParameter("@edicion", SqlDbType.Int);
                    prmEdicion.Direction = ParameterDirection.Output;
                    comand.Parameters.Add(prmEdicion);

                    SqlParameter prmResp = new SqlParameter("@resp", SqlDbType.Int);
                    prmResp.Direction = ParameterDirection.Output;
                    comand.Parameters.Add(prmResp);

                    Conn.Open();
                    comand.ExecuteNonQuery();

                    idUsuario = Convert.ToInt32(prmIdUsuario.Value);
                    activo = Convert.ToInt32(prmActivo.Value);
                    nombre = Convert.ToString(prmNombre.Value);
                    tipo = Convert.ToInt32(prmTipo.Value);
                    edicion = Convert.ToInt32(prmEdicion.Value);
                    resp = Convert.ToInt32(prmResp.Value);
                    Console.WriteLine(tipo);

                    Session["tipoUsuario"] = tipo;
                    Session["idusuario"] = idUsuario;
                    Session["nombreUsu"] = nombre;
                    Session["edicionActiva"] = edicion;
                    Session["RespMesa"] = resp;

                    switch (activo)
                    {
                        case 1:
                            switch (tipo)
                            {
                                case 1:
                                    Response.Redirect("../modulos/ponencias/ponencias_listar.aspx");
                                    break;
                                case 2:
                                    Response.Redirect("../modulos/evaluacion/ponencias_invitacion.aspx");
                                    break;
                                case 3:
                                    Response.Redirect("../modulos/administrador/invitaciones.aspx");
                                    break;
                                case 4:
                                    Response.Redirect("../modulos/administrador/invitaciones.aspx");
                                    break;
                                case 5:
                                    Response.Redirect("../modulos/ponencias/ponencias_listar.aspx");
                                    break;
                            }
                            break;
                        case 2:
                            lblTxt.Text = "¡Contraseña inválida!";
                            break;
                        case 3:
                            lblTxt.Text = "¡El correo electrónico no ha sido registrado!";
                            break;
                        default:
                            lblTxt.Text = "¡Cuenta inactiva!";
                            break;
                    }

                    // if (activo == 0){
                    //     lblTxt.Text = "¡Cuenta inactiva!";
                    // }
                    // else if (activo == 1)
                    // {
                    //     switch(tipo){
                    //         case 1:
                    //             Response.Redirect("../modulos/ponencias/ponencias_listar.aspx");
                    //             break;
                    //         case 2:
                    //             Response.Redirect("../modulos/evaluacion/ponencias_evaluar.aspx");
                    //             break;
                    //         case 3:
                    //             Response.Redirect("../modulos/administrador/panel.aspx");
                    //             break;
                    //     }
                    // }
                    // else if (activo == 2)
                    // {
                    //     lblTxt.Text = "¡Contraseña inválida!";
                    // }
                    // else
                    // {
                    //     lblTxt.Text = "¡El correo electrónico no ha sido registrado!";
                    // }
                }
                Conn.Close();
            }
        }
    }
}
