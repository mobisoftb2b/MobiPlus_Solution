using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_RoutesPlanning : PageBaseCls
{
 
    public string Lang = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        Lang = SessionLanguage;
        init();
    }
    private void init()
    {

        MPLayoutService WR = new MPLayoutService();
        AgentsList.DataSource = WR.GetAgents(SessionUserID,ConStrings.DicAllConStrings[SessionProjectName]);
        AgentsList.DataValueField = "AgentID";
        AgentsList.DataTextField = "AgentName";
        AgentsList.DataBind();
        AgentsList.SelectedValue = "0";
        AgentsList.Focus();
    }
}