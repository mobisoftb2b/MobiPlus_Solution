<%@ WebHandler Language="C#" Class="MainHandler" %>

using System;
using System.Web;
using System.Web.SessionState;

using System.Net;
//using System.Windows.Forms;
using System.Runtime.Serialization.Json;
using System.Runtime.Serialization;
using System.IO;

public class MainHandler : HandlerBaseCls
{
    private string Conn = "";
    private string[] arrTabs
    {
        get
        {
            if (HttpContext.Current.Session["arrTabs"] == null)
                HttpContext.Current.Session["arrTabs"] = new string[10];
            return (string[])HttpContext.Current.Session["arrTabs"];
        }
        set
        {
            HttpContext.Current.Session["arrTabs"] = value;
        }
    }
    public override void ProcessRequest(HttpContext context)
    {
        try
        {
            // Set the culture to "Hebrew in Israel"
            System.Globalization.CultureInfo cultureInfo = new System.Globalization.CultureInfo("he-IL");
            System.Threading.Thread.CurrentThread.CurrentCulture = cultureInfo;
            
            SessionLanguage = "Hebrew";
            int SessionUserIDr = Convert.ToInt32(SessionUserID);
            context.Response.ContentType = "application/json";
            
            string method = context.Request.QueryString["MethodName"].ToString();
            switch (method)
            {
                case "UserLogin":
                    UserLogin(context, context.Request["UserName"].ToString(), context.Request["Password"].ToString());
                    break;
                case "MPLayout_GetTabUI":
                    MPLayout_GetTabUI(context, context.Request.QueryString["TabID"].ToString(), context.Request.QueryString["VersionID"].ToString());
                    break;
                case "MPLayout_GetFormTabs":
                    MPLayout_GetFormTabs(context, context.Request.QueryString["FormID"].ToString());
                    break;
                case "MPLayout_GetReportDataJSON":
                    MPLayout_GetReportDataJSON(context, context.Request.QueryString["ReportID"].ToString(), context.Request.QueryString["VersionID"].ToString(), context.Request.QueryString["Params"].ToString());
                    break;
                case "SetProjectName":
                    SetProjectName(context.Request.QueryString["ProjectName"].ToString());
                    break;
                case "MPLayout_MSG_GetAllMessages":
                    MPLayout_MSG_GetAllMessages(context, context.Request.QueryString["VersionID"].ToString(), context.Request.QueryString["PopulationTypeID"].ToString());
                    break;
                case "MPLayout_GetPopulations":
                    MPLayout_GetPopulations(context, context.Request.QueryString["PopulationTypeID"].ToString());
                    break;
                case "MPLayout_SetPopulationData":
                    MPLayout_SetPopulationData(context, context.Request.QueryString["PopulationID"].ToString(), context.Request.QueryString["PopulationTypeID"].ToString(), context.Request.QueryString["PopulationDescription"].ToString(),
                        context.Request["PopulationQuery"].ToString(), context.Request.QueryString["IsToDelete"].ToString(), SessionUserID);
                    break;
                case "MPLayout_SetMSGData":
                    MPLayout_SetMSGData(context, context.Request.QueryString["MessageID"].ToString(), context.Request.QueryString["MessageText"].ToString(), context.Request.QueryString["MessageFromDate"].ToString(),
                        context.Request.QueryString["MessageToDate"].ToString(), context.Request.QueryString["IsToDelete"].ToString(), SessionUserID,
                        context.Request["ParentsPopulation"].ToString(), context.Request["ItemsPopulation"].ToString()
                        , context.Request["UnCheckedPopulation"].ToString());
                    break;
                case "MPLayout_Tasks_GetAllTasks":
                    MPLayout_Tasks_GetAllTasks(context, context.Request.QueryString["TaskUserID"].ToString());
                    break;
                case "MPLayout_SetTaskData":
                    MPLayout_SetTaskData(context, context.Request.QueryString["TaskID"].ToString(), context.Request.QueryString["ClassificationID"].ToString(), context.Request.QueryString["TopicID"].ToString(), context.Request.QueryString["SubTopic"].ToString()
                        , context.Request["Task"].ToString(), context.Request.QueryString["PriorityID"].ToString(), context.Request.QueryString["dtReport"].ToString(), context.Request.QueryString["dtTaskEnd"].ToString()
                        , context.Request.QueryString["ConditionID"].ToString(), context.Request.QueryString["TaskNotes"].ToString(), context.Request["ParentsPopulation"].ToString(), context.Request["ItemsPopulation"].ToString()
                        , context.Request["UnCheckedPopulation"].ToString(),  context.Request.QueryString["IsToDelete"].ToString()
                        , SessionUserID, context.Request.QueryString["TaskStatusID"].ToString(), context.Request.QueryString["dtStatus"].ToString(), Convert.ToDateTime(context.Request.QueryString["DateFrom"].ToString()).ToString("yyyyMMdd"),
                        Convert.ToDateTime(context.Request.QueryString["DateTo"].ToString()).ToString("yyyyMMdd"),  Convert.ToDateTime(context.Request.QueryString["AlarmDate"].ToString()).ToString("yyyyMMddHHmmss"));
                    break;
                case "MPLayout_Tasks_GetTsakPopulationJSON":
                    MPLayout_Tasks_GetTsakPopulationJSON(context, context.Request.QueryString["TaskID"].ToString());
                    break;
                case "MPLayout_Tasks_GetTsakPopulationParentsJSON":
                    MPLayout_Tasks_GetTsakPopulationParentsJSON(context, context.Request.QueryString["TaskID"].ToString());
                    break;
                case "GridDataNew":
                    GridDataNew(context);
                    break;
                case "MPLayout_GetReportDataByNameJSON":
                    
                    MPLayout_GetReportDataByNameJSON(context, context.Request.QueryString["ReportName"].ToString(), context.Request.QueryString["VersionID"].ToString(), context.Request.QueryString["Params"].ToString());
                    break;
                case "SetGoalByDates":
                    SetGoalByDates(context, context.Request.QueryString["ObjTypeID"].ToString(), context.Request.QueryString["AgentId"].ToString(), context.Request.QueryString["Cust_Key"].ToString(), context.Request.QueryString["SubCode"].ToString(), 
                        context.Request.QueryString["ItemId"].ToString(), Convert.ToDateTime(context.Request.QueryString["FromDate"].ToString()).ToString("yyyyMMdd") ,
                        Convert.ToDateTime(context.Request.QueryString["ToDate"].ToString()).ToString("yyyyMMdd"), context.Request.QueryString["Goal"].ToString().Replace("%", ""), context.Request.QueryString["GoalPercents"].ToString().Replace("%", ""),
                        context.Request.QueryString["isToSetChildrens"].ToString(), SessionUserID);
                    break;
                case "MPLayout_MSG_GetMSGPopulationJSON":
                    MPLayout_MSG_GetMSGPopulationJSON(context, context.Request.QueryString["MessageID"].ToString());
                    break;
                case "MPLayout_MSG_GetMSGPopulationParentsJSON":
                    MPLayout_MSG_GetMSGPopulationParentsJSON(context, context.Request.QueryString["MessageID"].ToString());
                    break;
            }
        }
        catch (Exception ex)
        {
            MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString(), SessionUserID, SessionUserPromt);
            context.Response.Write(ex.Message);  
        }
    }
    private void ResponseJSON(HttpContext Context, string strjson)
    {
        /*Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
        Context.Response.AddHeader("content-length", strjson.Length.ToString());
        Context.Response.Flush();*/
        
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strjson);
    }
    private void UserLogin(HttpContext Context, string UserName, string Password)
    {
        WebClient client = new WebClient();

        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPUserLogin?UserName=" + UserName + "&Password=" + Password +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        var objects = Newtonsoft.Json.Linq.JArray.Parse(HttpContext.Current.Server.UrlDecode(str));
        foreach (Newtonsoft.Json.Linq.JObject root in objects)
        {
            foreach (System.Collections.Generic.KeyValuePair<String, Newtonsoft.Json.Linq.JToken> app in root)
            {
                if (app.Key == "UserID")
                {
                    SessionUserID = ((Int32)app.Value).ToString();
                }
                if (app.Key == "Name")
                {
                    SessionUserPromt = ((string)app.Value).ToString();
                }
                if (app.Key == "GroupID")
                {
                    SessionGroupID = ((int)app.Value).ToString();
                }               
                if (app.Key == "ProfileID")
                {
                    SessionVersionID = ((int)app.Value).ToString();

                    if (System.Configuration.ConfigurationManager.AppSettings["IsDevelop"] !=null && System.Configuration.ConfigurationManager.AppSettings["IsDevelop"].ToString().ToLower() == "true")
                    {
                        SessionVersionID = "0";
                    }
                    
                }
                if (app.Key == "ProfileID")
                {
                    ProfileID = app.Value.ToString();
                }
            }
        }

        ResponseJSON(Context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void MPLayout_GetFormTabs(HttpContext context, string FormID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetFormTabs?VersionID="+SessionVersionID+"&FormID=" + FormID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void MPLayout_GetTabUI(HttpContext context, string TabID, string VersionID)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        System.Data.DataTable dt = wr.MPLayout_GetTabUI(TabID, VersionID, ConStrings.DicAllConStrings[SessionProjectName]);
        
        string htm = "<div class='dAllTab'>";

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            htm += "<div class='ddivFragment'>gggg</div>";
        }

        htm += "</div>";
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(htm));
    }
    private void MPLayout_GetReportDataJSON(HttpContext context, string ReportID, string VersionID,string Params)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetQueryData?ReportID=" + ReportID +
            "&VersionID=" + VersionID + "&Params=" + Params +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;"," "));
    }
    private void SetProjectName(string Name)
    {
        SessionProjectName = Name;
    }
    private void MPLayout_MSG_GetAllMessages(HttpContext context, string VersionID, string PopulationTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_MSG_GetAllMessages?VersionID=" + VersionID + "&PopulationTypeID=" + PopulationTypeID +        
            "&ConString=" + ConStrings.DicAllConStrings["Sides"]);//"&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;"," "));
    }
    private void MPLayout_GetPopulations(HttpContext context, string PopulationTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetPopulations?PopulationTypeID=" + PopulationTypeID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_SetPopulationData(HttpContext context, string PopulationID, string PopulationTypeID, string PopulationDescription, string PopulationQuery, string IsToDelete, string UserID)
    {        
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetPopulationData(PopulationID, PopulationTypeID, PopulationDescription, PopulationQuery, IsToDelete, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void MPLayout_SetMSGData(HttpContext context, string MessageID, string MessageText, string MessageFromDate, string MessageToDate, string IsToDelete, string UserID, string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetMSGData(MessageID, MessageText, Convert.ToDateTime(MessageFromDate).ToString("yyyyMMdd"), Convert.ToDateTime(MessageToDate).ToString("yyyyMMdd"), IsToDelete, UserID, ConStrings.DicAllConStrings[SessionProjectName]
            , ParentsPopulation, ItemsPopulation, UnCheckedPopulation).ToString());
    }
    private void MPLayout_Tasks_GetAllTasks(HttpContext context, string TaskUserID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_Tasks_GetAllTasks?UserID=" + TaskUserID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_SetTaskData(HttpContext context, string TaskID, string ClassificationID, string TopicID, string SubTopic, string Task, string PriorityID,
            string dtReport, string dtTaskEnd, string ConditionID, string TaskNotes, string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation,  string IsToDelete, string UserID, string TaskStatusID, string dtStatus,string DateFrom, string DateTo, string AlarmDate)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetTaskData(TaskID, ClassificationID, TopicID, SubTopic, Task, PriorityID,
            dtReport, dtTaskEnd, ConditionID, TaskNotes, ParentsPopulation, ItemsPopulation, UnCheckedPopulation,  IsToDelete, UserID, TaskStatusID, dtStatus,DateFrom, DateTo, AlarmDate, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void MPLayout_Tasks_GetTsakPopulationJSON(HttpContext context, string TaskID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_Tasks_GetTsakPopulationJSON?TaskID=" + TaskID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    
    private void MPLayout_Tasks_GetTsakPopulationParentsJSON(HttpContext context, string TaskID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_Tasks_GetTsakPopulationParentsJSON?TaskID=" + TaskID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    public void GridDataNew(HttpContext context)
    {
        WebClient client = new WebClient();
        string id = "";
        if (context.Request.QueryString["id"] != null)
            id = "&id=" + context.Request.QueryString["id"].ToString();

        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GridDataNew?GridName=" + context.Request.QueryString["GridName"].ToString() + "&GridParameters=" + context.Request.QueryString["GridParameters"].ToString() + id +
        "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void MPLayout_GetReportDataByNameJSON(HttpContext context, string ReportName, string VersionID, string Params)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetQueryDataByName2?Params=" + Params + "&ReportName=" + ReportName +
            "&VersionID=" + VersionID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void SetGoalByDates(HttpContext context, string ObjTypeID, string AgentId, string Cust_Key, string SubCode, string ItemId, string FromDate, string ToDate, string Goal, string GoalPercents, string isToSetChildrens, string MPUserID)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, wr.SetGoalByDates(ObjTypeID, AgentId, Cust_Key, SubCode, ItemId, FromDate, ToDate, Goal, GoalPercents, isToSetChildrens, MPUserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void MPLayout_MSG_GetMSGPopulationJSON(HttpContext context, string MessageID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_MSG_GetMSGPopulationJSON?MessageID=" + MessageID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_MSG_GetMSGPopulationParentsJSON(HttpContext context, string MessageID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_MSG_GetMSGPopulationParentsJSON?MessageID=" + MessageID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
}


