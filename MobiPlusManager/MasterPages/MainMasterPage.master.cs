using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPages_MainMasterPage : MasterPageBaseCls
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (SessionUserID == "0")
        {
            Response.Redirect("~/Login.aspx");
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        lblUser.Text = SessionUserPromt;
    }
    protected void RedirectHome(object sender, EventArgs e)
    {
        Response.Redirect("../../pages/Home/GridRequests.aspx");
    }
}
