using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Server_SeverVersions : PageBaseCls
{
    MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            init();
        }  
    }
    protected void RefreshAgents_Click(object sender, EventArgs e)
    {
        setVersions(ddlFromVersion, "1", false, true);
    }
    protected void RefreshManagers_Click(object sender, EventArgs e)
    {
        setVersions(ddlToVersion, "1", true, true);
    }
    private void init()
    {
        
        ddlProjectTypes.DataSource = wr.GetProjectTypesDT();
        ddlProjectTypes.DataTextField = "ProjectTypeName";
        ddlProjectTypes.DataValueField = "ProjectType";
        ddlProjectTypes.DataBind();

        DataTable dt = wr.GetAgents(ConStrings.DicAllConStrings[SessionProjectName]);
        if(dt!=null && dt.Rows.Count > 0)
        {
            dt.Rows[0]["AgentName"] = " ";
        }
        ddlAgents.DataSource = dt;
        ddlAgents.DataTextField = "AgentName";
        ddlAgents.DataValueField = "AgentID";
        ddlAgents.DataBind();

        DataTable dtg = wr.GetServerGroupsDT(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtg != null && dtg.Rows.Count > 0)
        {
            dtg.Rows[0]["GroupName"] = " ";
        }
        ddlGroups.DataSource = dtg;
        ddlGroups.DataTextField = "GroupName";
        ddlGroups.DataValueField = "id";
        ddlGroups.DataBind();

        setVersions(ddlFromVersion, "1",false,false);
        setVersions(ddlToVersion, "1", true, false);
    }
    private void setVersions(DropDownList ddl,string ProjectType,bool isToVersion,bool isToRefresh)
    {
        DataTable dt = new DataTable();
        if (ProjectType == "1")//agents
        {
            dt = wr.GetAgentVersions(isToRefresh);
        }
        else//managers
        {
            dt = wr.GetManagerVersions(isToRefresh);
        }

        if (isToVersion && dt.Rows.Count > 1)
        {
            dt.Rows[1].Delete();
        }

        ddl.DataSource = dt;
        ddl.DataTextField = "Version";
        ddl.DataValueField = "VersionID";
        ddl.DataBind();
    }
}