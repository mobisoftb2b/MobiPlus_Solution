using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_Gallery : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MPLayoutService WR = new MPLayoutService();
        ddlAgents.DataSource = WR.GetAgents(SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
        ddlAgents.DataValueField = "AgentID";
        ddlAgents.DataTextField = "AgentName";
        ddlAgents.DataBind();
        ddlAgents.SelectedValue = "0";

    }
}