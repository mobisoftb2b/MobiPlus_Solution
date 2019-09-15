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
    protected void btnAploadAndroidVersion_Click(object sender, EventArgs e)
    {
        if (upAndroidVersion.HasFile)
        {
            string[] arr = upAndroidVersion.FileName.Split('\\');
            if(arr!=null && arr.Length>0)
            {
                if (wr.CheckIfAPKExists(arr[arr.Length - 1]))
                {
                    string scr = "confirm('קובץ בשם זהה קיים בשרת, האם לדרוס אותו?');";
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "scr222", scr, true);
                    return;
                }
                else
                {
                    wr.UploadAPK(upAndroidVersion.FileName, upAndroidVersion.FileBytes);
                }
            }
        }
    }
    protected void RefreshAgents_Click(object sender, EventArgs e)
    {
        setVersions(ddlFromVersion, "1", false, true);
    }
    protected void RefreshAgentsLayout_Click(object sender, EventArgs e)
    {
        setVersionsLayout(ddlFromVersionLayout, "1", false, true);
    }
    protected void RefreshManagers_Click(object sender, EventArgs e)
    {
        setVersions(ddlToVersion, "1", true, true);
    }
    protected void RefreshManagersLayout_Click(object sender, EventArgs e)
    {
        setVersionsLayout(ddlToVersionLayout, "1", true, true);
    }
   
    private void init()
    {
        

        ddlProjectTypes.DataSource = wr.GetProjectTypesDT();
        ddlProjectTypes.DataTextField = "ProjectTypeName";
        ddlProjectTypes.DataValueField = "ProjectType";
        ddlProjectTypes.DataBind();

        ddlProjectTypesLayout.DataSource = wr.GetProjectTypesDT();
        ddlProjectTypesLayout.DataTextField = "ProjectTypeName";
        ddlProjectTypesLayout.DataValueField = "ProjectType";
        ddlProjectTypesLayout.DataBind();

        DataTable dt = wr.GetAgents(ConStrings.DicAllConStrings[SessionProjectName]);
        if(dt!=null && dt.Rows.Count > 0)
        {
            dt.Rows[0]["AgentName"] = " ";
        }
        ddlAgents.DataSource = dt;
        ddlAgents.DataTextField = "AgentName";
        ddlAgents.DataValueField = "AgentID";
        ddlAgents.DataBind();

        ddlAgentsLayout.DataSource = dt;
        ddlAgentsLayout.DataTextField = "AgentName";
        ddlAgentsLayout.DataValueField = "AgentID";
        ddlAgentsLayout.DataBind();

        DataTable dtg = wr.GetServerGroupsDT(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtg != null && dtg.Rows.Count > 0)
        {
            dtg.Rows[0]["GroupName"] = " ";
        }
        ddlGroups.DataSource = dtg;
        ddlGroups.DataTextField = "GroupName";
        ddlGroups.DataValueField = "id";
        ddlGroups.DataBind();

        ddlGroupsLayout.DataSource = dtg;
        ddlGroupsLayout.DataTextField = "GroupName";
        ddlGroupsLayout.DataValueField = "id";
        ddlGroupsLayout.DataBind();

        setVersions(ddlFromVersion, "1",false,false);
        setVersions(ddlToVersion, "1", true, false);

        setVersionsLayout(ddlFromVersionLayout, "1", false, true);
        setVersionsLayout(ddlToVersionLayout, "1", true, true);
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
    private void setVersionsLayout(DropDownList ddl, string ProjectType, bool isToVersion, bool isToRefresh)
    {
        DataTable dt = new DataTable();
        if (ProjectType == "1")//agents
        {
            dt = wr.GetAgentVersionsLayout(isToRefresh);
        }
        else//managers
        {
            dt = wr.GetManagerVersionsLayout(isToRefresh);
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