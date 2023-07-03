using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login_logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Session.Remove("idusuario");
        Session.Remove("edicionActiva");
        Session.Contents.RemoveAll();

        if (HttpContext.Current.Session["idusuario"] == null || HttpContext.Current.Session["edicionActiva"] == null)
        {
            HttpContext.Current.Response.Redirect("~/login/login.aspx");
        }
    }
}