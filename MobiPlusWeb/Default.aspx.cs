using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default2 : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (SessionUserID != "0")
            {
                Response.Redirect("Pages/Usr/Home.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
}