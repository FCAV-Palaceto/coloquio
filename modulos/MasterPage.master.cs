using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    string idusu;
    int tipoUsuario;
    int RespMesa;
    public string nombreUsu, pagInicio, menuDisponible, cambiaRol = string.Empty, RolResp = string.Empty, cambiaRolMovil = string.Empty, tipoRol = string.Empty, modulo, edicionActiva = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (HttpContext.Current.Session["edicionActiva"] == null || HttpContext.Current.Session["idusuario"] == null)
        {
            Response.Redirect("../../login/login.aspx");
        }
        TraeEdicion();
        edicionActiva = "1ER. CONGRESO INTERNACIONAL DE EMPRENDIMIENTO SOCIAL";

        idusu = Convert.ToString(HttpContext.Current.Session["idusuario"]);
        nombreUsu = Convert.ToString(HttpContext.Current.Session["nombreUsu"]);

        tipoUsuario = Convert.ToInt32(HttpContext.Current.Session["tipoUsuario"]);

        RespMesa = Convert.ToInt32(HttpContext.Current.Session["RespMesa"]);

        // Para el menú disponible, quizá haya que cambiar /coloquio/ por /coloquio/
        switch (tipoUsuario)
        {
            // Ponente
            case 1:
                pagInicio = "/cieanfeca/modulos/ponencias/ponencias_listar.aspx";
                modulo = "Ponencias";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/ponencias/ponencias_listar.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-lines""></i></div>Mis Ponencias</a>
									<a class=""nav-link"" href=""/cieanfeca/modulos/ponencias/ponencias_registrar.aspx"" onclick=""nuevaPonencia();""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-circle-plus""></i></div>Registrar Ponencia</a>";
                break;
            // Evaluador
            case 2:
                pagInicio = "/cieanfeca/modulos/evaluacion/ponencias_invitacion.aspx";
                modulo = "Evaluación";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_invitacion.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-clipboard-question""></i></div>Invitaciones</a>
                                    <a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_evaluar.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-clipboard-list""></i></div>Ponencias Asignadas</a>
									<a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_evaluadas.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-clipboard-check""></i></div>Ponencias Evaluadas</a>";
                                    if (RespMesa == 1){
                                    RolResp = @"<li><a id=""btnCambiarRolResp2"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRolResp2""><i class=""fa fa-cog"" aria-hidden=""true""></i> Responsable Mesa</a></li>";
                                    }
                //cambiaRol = @"<li><a id=""btnCambiarRol"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Cambiar de Rol</a></li>";
                //cambiaRolMovil = @"<a class=""nav-link"" href=""#"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Cambiar de Rol</a>";
                //tipoRol = "Ponente";
                break;
            // Administrador
            case 3:
                pagInicio = "/cieanfeca/modulos/administrador/invitaciones.aspx";
                modulo = "Administrador";
                menuDisponible = @"<a class=""nav-link collapsed"" href=""#"" data-bs-toggle=""collapse"" data-bs-target=""#pagesCollapsePonencias"" aria-expanded=""false"" aria-controls=""pagesCollapsePonencias"">
									<div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-lines""></i></div>
										Ponencias
										<div class=""sb-sidenav-collapse-arrow""><i class=""fas fa-angle-down""></i></div>
									</a>
                                    <div class=""collapse"" id=""pagesCollapsePonencias"" aria-labelledby=""headingSix"" data-bs-parent=""#sidenavAccordionPages"">
										<nav class=""sb-sidenav-menu-nested nav"">
                                            <a class=""nav-link"" href=""/cieanfeca/modulos/administrador/invitaciones.aspx"">Administrar</a>
											<a class=""nav-link"" href=""/cieanfeca/modulos/ponencias/ponencias_listar.aspx"">Subidas</a>
									        <a class=""nav-link"" href=""/cieanfeca/modulos/ponencias/ponencias_registrar.aspx"" onclick=""nuevaPonencia();"">Registrar</a>
                                            <a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_evaluar.aspx"">Evaluar</a>									        
										</nav>
									</div>
                                    <a class=""nav-link collapsed"" href=""#"" data-bs-toggle=""collapse"" data-bs-target=""#pagesCollapseCatalogos"" aria-expanded=""false"" aria-controls=""pagesCollapseCatalogos"">
									<div class=""sb-nav-link-icon""><i class=""fa-regular fa-folder-open""></i></div>
										Catálogos
										<div class=""sb-sidenav-collapse-arrow""><i class=""fas fa-angle-down""></i></div>
									</a>
                                    <div class=""collapse"" id=""pagesCollapseCatalogos"" aria-labelledby=""headingSix"" data-bs-parent=""#sidenavAccordionPages"">
										<nav class=""sb-sidenav-menu-nested nav"">
                                            <a class=""nav-link"" href=""/cieanfeca/modulos/administrador/ediciones.aspx"">Ediciones</a>
											<a class=""nav-link"" href=""/cieanfeca/modulos/administrador/modalidades.aspx"">Modalidades</a>
									        <a class=""nav-link"" href=""/cieanfeca/modulos/administrador/temas.aspx"">Temas</a>
									        <a class=""nav-link"" href=""/cieanfeca/modulos/administrador/usuarios.aspx"">Usuarios</a>
                                            <a class=""nav-link collapsed no-toggle"" href=""#"" data-bs-toggle=""collapse"" data-bs-target=""#pagesCollapseEvaluacion"" aria-expanded=""false"" aria-controls=""pagesCollapseEvaluacion"">									           
										        Evaluación
										        <div class=""sb-sidenav-collapse-arrow""><i class=""fas fa-angle-down""></i></div>
									        </a>
                                            <div class=""collapse"" id=""pagesCollapseEvaluacion"" aria-labelledby=""headingSix"" data-bs-parent=""#sidenavAccordionPages"">
										        <nav class=""sb-sidenav-menu-nested nav"">
                                                    <a class=""nav-link"" href=""/cieanfeca/modulos/administrador/secciones.aspx"">Secciones</a>
									                <a class=""nav-link"" href=""/cieanfeca/modulos/administrador/parametros.aspx"">Parametros</a>
                                                </nav>
                                            </div>
										</nav>
									</div>

                                    <a class=""nav-link collapsed"" href=""#"" data-bs-toggle=""collapse"" data-bs-target=""#collapseReportes"" aria-expanded=""false"" aria-controls=""collapseReportes"">
									<div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-export""></i></div>
                                        Reportes
                                        <div class=""sb-sidenav-collapse-arrow""><i class=""fas fa-angle-down""></i></div>
                                    </a>
                                    <div class=""collapse"" id=""collapseReportes"" aria-labelledby=""headingThree"" data-bs-parent=""#sidenavAccordionPages"">
                                        <nav class=""sb-sidenav-menu-nested nav"">
                                            <a class=""nav-link"" href=""/cieanfeca/modulos/reportes/reporte_ponencias.aspx"">Reporte de ponencias registradas</a>
                                        </nav>
                                    </div>";
                break;
            // Temporal para cambiar de ponente a Evaluador
            case 99:
                pagInicio = "/cieanfeca/modulos/evaluacion/ponencias_invitacion.aspx";
                modulo = "Evaluador";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_invitacion.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-clipboard-question""></i></div>Invitaciones</a>
                                    <a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_evaluar.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-clipboard-list""></i></div>Ponencias Asignadas</a>
									<a class=""nav-link"" href=""/cieanfeca/modulos/evaluacion/ponencias_evaluadas.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-clipboard-check""></i></div>Ponencias Evaluadas</a>";
                                    if (RespMesa == 1){
                                    RolResp = @"<li><a id=""btnCambiarRolResp"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRolResp""><i class=""fa fa-cog"" aria-hidden=""true""></i> Responsable Mesa</a></li>";
                                    }
                cambiaRol = @"<li><a id=""btnCambiarRol"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Ponente</a></li>";
                cambiaRolMovil = @"<a class=""nav-link"" href=""#"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Ponente</a>";
                tipoRol = "Ponente";
                break;
            // Auxiliar
            case 4:
                pagInicio = "/cieanfeca/modulos/administrador/invitaciones.aspx";
                modulo = "Auxiliar";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/administrador/invitaciones.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-pen""></i></div>Administrar ponencias</a>";
                break;
            case 55:
                pagInicio = "/cieanfeca/modulos/administrador/invitaciones.aspx";
                modulo = "Responsable";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/administrador/invitaciones.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-pen""></i></div>Administrar ponencias</a>";
                cambiaRol = @"<li><a id=""btnCambiarRol"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Evaluador</a></li>";
                tipoRol = "Evaluador";
                break;
                case 77:
                pagInicio = "/cieanfeca/modulos/administrador/invitaciones.aspx";
                modulo = "Responsable";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/administrador/invitaciones.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-pen""></i></div>Administrar ponencias</a>";
                cambiaRol = @"<li><a id=""btnCambiarRol"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Evaluador</a></li>";
                tipoRol = "Evaluador";
                break;
                // Evaluador/Ponente
            default:
                pagInicio = "/cieanfeca/modulos/ponencias/ponencias_listar.aspx";
                modulo = "Ponente";
                menuDisponible = @"<a class=""nav-link"" href=""/cieanfeca/modulos/ponencias/ponencias_listar.aspx""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-lines""></i></div>Mis Ponencias</a>
									<a class=""nav-link"" href=""/cieanfeca/modulos/ponencias/ponencias_registrar.aspx"" onclick=""nuevaPonencia();""><div class=""sb-nav-link-icon""><i class=""fa-solid fa-file-circle-plus""></i></div>Registrar Ponencia</a>";
                                    if (RespMesa == 1){
                                    RolResp = @"<li><a id=""btnCambiarRolResp"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRolResp""><i class=""fa fa-cog"" aria-hidden=""true""></i> Responsable Mesa</a></li>";
                                    }
                cambiaRol = @"<li><a id=""btnCambiarRol"" class=""dropdown-item"" href=""#!"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Evaluador</a></li>";
                cambiaRolMovil = @"<a class=""nav-link"" href=""#"" data-bs-toggle=""modal"" data-bs-target=""#modalRol""><i class=""fa fa-refresh"" aria-hidden=""true""></i> Evaluador</a>";
                tipoRol = "Evaluador";
                break;
        }

        if (idusu == null || idusu == "")
        {
            Response.Redirect("~/login/login.aspx");
        }

    }

    protected void CambiarRol_Click(object sender, EventArgs e)
    {
        // Si es evaluador, cambialo a ponente(temporal), de lo contrario debe ser ponente(temporal), por lo tanto se regresa a evaluador
        if (Convert.ToInt32(Session["tipoUsuario"]) == 5 || Convert.ToInt32(Session["tipoUsuario"]) == 55)
        {
            Session["tipoUsuario"] = 99;
            Response.Redirect("/cieanfeca/modulos/evaluacion/ponencias_invitacion.aspx");
        }
        else if (Convert.ToInt32(Session["tipoUsuario"]) == 77)
        {
            Session["tipoUsuario"] = 2;
            Response.Redirect("/cieanfeca/modulos/ponencias/ponencias_listar.aspx");            
        }
        else
        {
            Session["tipoUsuario"] = 5;
            Response.Redirect("/cieanfeca/modulos/ponencias/ponencias_listar.aspx");            
        }
    }

    protected void CambiarRolResp_Click(object sender, EventArgs e)
    {
        Session["tipoUsuario"] = 55;
        Response.Redirect("/cieanfeca/modulos/administrador/invitaciones.aspx");

    }


    protected void CambiarRolResp2_Click(object sender, EventArgs e)
    {
        Session["tipoUsuario"] = 77;
        Response.Redirect("/cieanfeca/modulos/administrador/invitaciones.aspx");

    }


    protected void TraeEdicion()
    {
        int edicion = Convert.ToInt32(HttpContext.Current.Session["edicionActiva"].ToString());
        using (SqlConnection Conn = conn.conecta())
        {
            using (SqlCommand comand = new SqlCommand("EdicionActiva", Conn))
            {
                comand.CommandType = CommandType.StoredProcedure;
                comand.Parameters.AddWithValue("@edicionActiva", edicion);
                
                SqlParameter prmEdicion = new SqlParameter("@edicion", SqlDbType.NVarChar, 120);
                prmEdicion.Direction = ParameterDirection.Output;
                comand.Parameters.Add(prmEdicion);

                Conn.Open();
                comand.ExecuteNonQuery();
               
                edicionActiva = prmEdicion.Value.ToString();

                Conn.Close();
            }
        }
    }

}
