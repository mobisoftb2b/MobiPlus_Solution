using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DriversToUser : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.MPLayout_GetUsers(SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);

        ddlUsers.DataSource = dt;
        ddlUsers.DataValueField = "UserID";
        ddlUsers.DataTextField = "Name";
        ddlUsers.DataBind();
    }
}