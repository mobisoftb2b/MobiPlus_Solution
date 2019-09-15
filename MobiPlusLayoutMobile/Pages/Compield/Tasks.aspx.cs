using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Compield_Tasks : PageBaseCls
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
        MPLayoutService.MPLayoutService WR = new MPLayoutService.MPLayoutService();
        DataSet ds = WR.MPLayout_Tasks_GetTaskDDLs(ConStrings.DicAllConStrings[SessionProjectName]);

        if (ds != null && ds.Tables.Count > 4)
        {           
            ddlClassifications.DataSource = ds.Tables[0];
            ddlClassifications.DataTextField = "ClassificationName";
            ddlClassifications.DataValueField = "ClassificationID";
            ddlClassifications.DataBind();


            ddlPriority.DataSource = ds.Tables[1];
            ddlPriority.DataTextField = "PriorityName";
            ddlPriority.DataValueField = "PriorityID";
            ddlPriority.DataBind();


            ddlStatuses.DataSource = ds.Tables[2];
            ddlStatuses.DataTextField = "TaskStatusName";
            ddlStatuses.DataValueField = "TaskStatusID";
            ddlStatuses.DataBind();


            ddlTopics.DataSource = ds.Tables[3];
            ddlTopics.DataTextField = "TopicName";
            ddlTopics.DataValueField = "TopicID";
            ddlTopics.DataBind();


            ddlReportUser.DataSource = ds.Tables[4];
            ddlReportUser.DataTextField = "Name";
            ddlReportUser.DataValueField = "UserID";
            ddlReportUser.DataBind();
        }

        
    }
}