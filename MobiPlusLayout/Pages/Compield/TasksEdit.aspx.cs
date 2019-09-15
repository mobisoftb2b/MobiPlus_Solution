
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_TasksEdit : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // byte[] data = File.ReadAllBytes(@"C:\Users\gil.MOBISOFT\Desktop\IMG_20161109_163925.jpg");
            //tImg.Src = "data:image/png;base64," + Convert.ToBase64String(data);
            initAgents(sender,e);
        }
    }
    protected void initAgents(object sender, EventArgs e)
    {
        var cid = string.IsNullOrEmpty(Request["CountryID"]) ? "1000" : Request["CountryID"];
        var did = string.IsNullOrEmpty(Request["DistrID"]) ? "1000" : Request["DistrID"];
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.GetAgentsL(SessionUserID,cid, did, ConStrings.DicAllConStrings[SessionProjectName]);
        AgentsList.DataSource = dt;
        AgentsList.DataValueField = "DriverID";
        AgentsList.DataTextField = "DriverName";
        AgentsList.DataBind();
        AgentsList.SelectedValue = "0";
        AgentsList.Focus();


        ddlDrivers.DataSource = dt;
        ddlDrivers.DataValueField = "DriverID";
        ddlDrivers.DataTextField = "DriverName";
        ddlDrivers.DataBind();

        try
        {
            ddlDrivers.Items[0].Text = "בחר";
        }
        catch (Exception ex)
        {
        }

        DataTable dt1 = WR.MPLayout_GetTaskTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlTaskTypes.DataSource = dt1;
        ddlTaskTypes.DataValueField = "TaskTypeID";
        ddlTaskTypes.DataTextField = "TaskType";
        ddlTaskTypes.DataBind();
        ddlTaskTypes.SelectedValue = dt1.Rows.Count>0?"5":"0";
    }
}