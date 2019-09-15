<%@ WebHandler Language="C#" Class="MainHandler" %>

using System;
using System.Web;
using MobiPlusTools;
using System.Data;
using System.Net;
//using System.Windows.Forms;
using System.Runtime.Serialization.Json;
using System.Runtime.Serialization;
using System.IO;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using MobiPlus.BusinessLogic.Auth;

public class MainHandler : HandlerBaseCls
{
    private string Conn = "";
    private string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();
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
            string[] arr = new string[ConStrings.DicAllConStrings.Keys.Count];
            ConStrings.DicAllConStrings.Keys.CopyTo(arr, 0);
            if (ConStrings.DicAllConStrings != null)
            {
                if (ConStrings.DicAllConStrings.Keys.Count == 1)//only one
                {
                    SessionProjectName = arr[0];
                }

            }
            // Set the culture to "Hebrew in Israel"
            System.Globalization.CultureInfo cultureInfo = new System.Globalization.CultureInfo("he-IL");
            System.Threading.Thread.CurrentThread.CurrentCulture = cultureInfo;


            int SessionUserIDr = Convert.ToInt32(SessionUserID);
            context.Response.ContentType = "application/json";

            string method = context.Request.QueryString["MethodName"].ToString();
            switch (method)
            {
                case "UserLogin":
                    UserLogin(context, context.Request["UserName"].ToString(), context.Request["Password"].ToString(), context.Request["userIP"].ToString());
                    break;
                case "MPLayout_GetTabUI":
                    MPLayout_GetTabUI(context, context.Request.QueryString["TabID"].ToString(), context.Request.QueryString["VersionID"].ToString());
                    break;
                case "MPLayout_GetFormTabs":
                    MPLayout_GetFormTabs(context, context.Request.QueryString["FormID"].ToString());
                    break;
                case "MPLayout_GetReportDataJSON":
                    MPLayout_GetReportDataJSON(context, context.Request.QueryString["ReportID"].ToString(), context.Request.QueryString["VersionID"].ToString(), context.Request.QueryString["Params"].ToString(), context.Request.QueryString["ColumnName"].ToString(), context.Request.QueryString["Value"].ToString());
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
                    MPLayout_SetTaskData(context,
                        context.Request.QueryString["TaskID"].ToString(),
                        context.Request.QueryString["ClassificationID"].ToString(),
                        context.Request.QueryString["TopicID"].ToString(),
                        context.Request.QueryString["SubTopic"].ToString(),
                        context.Request["Task"].ToString(),
                        context.Request.QueryString["PriorityID"].ToString(),
                        context.Request.QueryString["dtReport"].ToString(),
                        context.Request.QueryString["dtTaskEnd"].ToString(),
                        context.Request.QueryString["ConditionID"].ToString(),
                        context.Request.QueryString["TaskNotes"].ToString(),
                        context.Request["ParentsPopulation"].ToString(),
                        context.Request["ItemsPopulation"].ToString(),
                        context.Request["UnCheckedPopulation"].ToString(),
                        context.Request.QueryString["IsToDelete"].ToString(),
                        SessionUserID,
                        context.Request.QueryString["TaskStatusID"].ToString(),
                        context.Request.QueryString["dtStatus"].ToString(),
                        Convert.ToDateTime(context.Request.QueryString["DateFrom"].ToString()).ToString("yyyyMMdd"),
                        Convert.ToDateTime(context.Request.QueryString["DateTo"].ToString()).ToString("yyyyMMdd"),
                        Convert.ToDateTime(context.Request.QueryString["AlarmDate"].ToString()).ToString("yyyyMMddHHmmss"));
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
                        context.Request.QueryString["ItemId"].ToString(), Convert.ToDateTime(context.Request.QueryString["FromDate"].ToString()).ToString("yyyyMMdd"),
                        Convert.ToDateTime(context.Request.QueryString["ToDate"].ToString()).ToString("yyyyMMdd"), context.Request.QueryString["Goal"].ToString().Replace("%", ""), context.Request.QueryString["GoalPercents"].ToString().Replace("%", ""),
                        context.Request.QueryString["isToSetChildrens"].ToString(), SessionUserID);
                    break;
                case "MPLayout_MSG_GetMSGPopulationJSON":
                    MPLayout_MSG_GetMSGPopulationJSON(context, context.Request.QueryString["MessageID"].ToString());
                    break;
                case "MPLayout_MSG_GetMSGPopulationParentsJSON":
                    MPLayout_MSG_GetMSGPopulationParentsJSON(context, context.Request.QueryString["MessageID"].ToString());
                    break;
                case "MPLayout_GetParametersData":
                    MPLayout_GetParametersData(context);//, context.Request.QueryString["[PrmVersion]"].ToString(), context.Request.QueryString["[PrmId]"].ToString(), context.Request.QueryString["[Value]"].ToString()
                    break;
                case "MPLayout_SetParametersData":
                    MPLayout_SetParametersData(context, context.Request.QueryString["PrmVersion"].ToString(), context.Request.QueryString["PrmId"].ToString(), context.Request.QueryString["Value"].ToString(),
                        context.Request.QueryString["RealID"].ToString(), context.Request.QueryString["IsToDelete"].ToString());
                    break;
                case "GetJsonTableData":
                    GetJsonTableData(context, context.Request.QueryString["TableName"].ToString());
                    break;
                case "MPLayout_AddParametersTableDefinitions":
                    MPLayout_AddParametersTableDefinitions(context, context.Request["TableName"].ToString(), context.Request["Prams"].ToString(), context.Request["Type"].ToString());
                    break;
                case "MPLayout_EditParametersTableDefinitions":
                    MPLayout_EditParametersTableDefinitions(context, context.Request["TableName"].ToString(), context.Request["Prams"].ToString(), context.Request["OldPrams"].ToString(), context.Request["Type"].ToString(), context.Request["IsPrimary"].ToString());
                    break;
                case "MPLayout_DelParametersTableDefinitions":
                    MPLayout_DelParametersTableDefinitions(context, context.Request["TableName"].ToString(), context.Request["Prams"].ToString(), context.Request["Type"].ToString(), context.Request["IsPrimary"].ToString());
                    break;
                case "MPLayout_SearchBytxt":
                    MPLayout_SearchBytxt(context, context.Request.QueryString["TableName"].ToString(), context.Request.QueryString["ColumnName"].ToString(), context.Request.QueryString["Value"].ToString());
                    break;
                case "MPLayout_SetRoutes":
                    MPLayout_SetRoutes(context, context.Request.QueryString["CustKey"].ToString(), context.Request.QueryString["Interval"].ToString(), context.Request.QueryString["TimeFromD"].ToString(),
                        context.Request.QueryString["TimeToD"].ToString(), context.Request.QueryString["WDays"].ToString(), context.Request.QueryString["CDays"].ToString(), context.Request.QueryString["RouteDates"].ToString());

                    break;
                case "MPLayout_GetSelectedParameter":
                    MPLayout_GetSelectedParameter(context, context.Request.QueryString["Unique"].ToString(), context.Request.QueryString["ReportID"].ToString(), context.Request.QueryString["Params"].ToString());
                    break;
                case "SetEn":
                    SetEn(context, context.Request.QueryString["Lan"].ToString());
                    break;
                case "MPLayout_GetAllRoutes":
                    MPLayout_GetAllRoutes(context, context.Request.QueryString["ViewStart"].ToString(), context.Request.QueryString["ViewEnd"].ToString(), context.Request.QueryString["AgentId"].ToString());
                    break;
                case "MPLayout_SetInActiveDays":
                    MPLayout_SetInActiveDays(context, context.Request["AgentId"].ToString(), context.Request["InActiveEvents"].ToString(), context.Request["ViewStart"].ToString(), context.Request["ViewEnd"].ToString());
                    break;
                case "MPLayout_GetInActiveDays":
                    MPLayout_GetInActiveDays(context, context.Request.QueryString["AgentId"].ToString(), context.Request.QueryString["ViewStart"].ToString(), context.Request.QueryString["ViewEnd"].ToString());
                    break;
                case "MPLayout_RoutesSaveSettings":
                    MPLayout_RoutesSaveSettings(context, context.Request.QueryString["NumberOfWeeks"].ToString(), context.Request.QueryString["WorkDays"].ToString(), context.Request.QueryString["StartDate"].ToString()
                        , context.Request.QueryString["StartHour"].ToString(), context.Request.QueryString["EndHour"].ToString(), context.Request.QueryString["InActiveDaysTypeList"].ToString());
                    break;
                case "MPLayout_RoutesGetSettings":
                    MPLayout_RoutesGetSettings(context);
                    break;
                case "MPLayout_RoutesGetInActiveDaysType":
                    MPLayout_RoutesGetInActiveDaysType(context);
                    break;
                case "MPLayout_AddCustToDistribution":
                    MPLayout_AddCustToDistribution(context, context.Request.QueryString["Cust_Key"].ToString(), context.Request.QueryString["lines"].ToString());
                    break;
                case "MPLayout_GetCustToDistribution":
                    MPLayout_GetCustToDistribution(context, context.Request.QueryString["Cust_Key"].ToString());
                    break;
                case "MPLayout_GetDistributionLine":
                    MPLayout_GetDistributionLine(context);
                    break;
                case "MPLayout_AddLineToAgent":
                    MPLayout_AddLineToAgent(context, context.Request.QueryString["AgentId"].ToString(), context.Request.QueryString["DistributionLineDescription"].ToString(), context.Request.QueryString["Date"].ToString()
                        , context.Request.QueryString["daysInterval"].ToString());
                    break;
                case "MPLayout_GetLineToAgentEvents":
                    MPLayout_GetLineToAgentEvents(context, context.Request.QueryString["ViewStart"].ToString(), context.Request.QueryString["ViewEnd"].ToString(), context.Request.QueryString["AgentId"].ToString());
                    break;
                case "MPLayout_delLineToAgentEvent":
                    MPLayout_delLineToAgentEvent(context, context.Request.QueryString["AgentId"].ToString(), context.Request.QueryString["DistributionLineDescription"].ToString(), context.Request.QueryString["Date"].ToString());
                    break;
                case "GetDataForMap":
                    GetDataForMap(context, context.Request.QueryString["Points"].ToString(), context.Request.QueryString["orgAddress"].ToString());
                    break;
                case "MPLayout_SaveRoutesSettings":
                    MPLayout_SaveRoutesSettings(context, context.Request.QueryString["ParameterId"].ToString(), context.Request.QueryString["ParameterValue"].ToString(), context.Request.QueryString["IsDate"].ToString());
                    break;
                case "MPLayout_SaveInActiveDaysType":
                    MPLayout_SaveInActiveDaysType(context, context.Request.QueryString["InActiveDaysTypes"].ToString());
                    break;
                case "GetGalleryData":
                    GetGalleryData(context, context.Request.QueryString["id"].ToString(), context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["Cust_Key"].ToString());
                    break;
                case "MPLayout_SetDocManagement":
                    MPLayout_SetDocManagement(context, context.Request.QueryString["DocManagementID"].ToString(), context.Request.QueryString["FileName"].ToString(), context.Request.QueryString["FileDesc"].ToString(),
                        context.Request["Objects"].ToString(), context.Request.QueryString["ObjectsTypeID"].ToString(), SessionUserID, context.Request.QueryString["IsToDelete"].ToString());
                    break;
                case "GetDoc":
                    GetDoc(context, context.Request["FileSrc"].ToString());
                    break;
                case "DriversGPS_GetData":
                    DriversGPS_GetData(context, context.Request["strDate"].ToString(), context.Request["AgentID"].ToString(), context.Request["isFirst"].ToString());
                    break;
                case "OpenDoc":
                    OpenDoc(context, context.Request["Doc"].ToString());
                    break;
                case "MPLayout_SeUserData":
                    MPLayout_SeUserData(context, context.Request["UserID"].ToString(), context.Request["UserName"].ToString(), context.Request["Name"].ToString(), context.Request["Password"].ToString(),
                        context.Request["UserCode"].ToString(), context.Request["UserRoleID"].ToString(), context.Request["CountryID"].ToString(), context.Request["DistributionCenterID"].ToString(), context.Request["ManagerUserID"].ToString(),
                        "", context.Request["IsToDelete"].ToString(), context.Request["prStr"].ToString());
                    break;
                case "SetDriverToUser":
                    MPLayout_SetDriverToUser(context, context.Request["SelectedUserID"].ToString(), context.Request["DriverID"].ToString(), context.Request["DriverTypeID"].ToString(), SessionUserID, context.Request["IsToDelete"].ToString());
                    break;
                case "MPLayout_SetTask":
                    MPLayout_SetTask(context,
                        context.Request["TaskID"],
                        context.Request["AgentId"],
                        context.Request["CustomerCode"],
                        context.Request["Address"].ToString(),
                        context.Request["City"].ToString(),
                        context.Request["DateFrom"].ToString(),
                        context.Request["DateTo"].ToString(),
                        context.Request["TaskTypeID"].ToString(),
                        context.Request["Task"].ToString(),
                        context.Request["IsToDelete"].ToString());

                    GetAndSetTaskCords(context, context.Request["TaskID"].ToString(), context.Request["Address"].ToString(), context.Request["City"].ToString(), CountryName, false);
                    break;
                case "GetAndSetTaskCords":
                    GetAndSetTaskCords(context, context.Request["TaskID"].ToString(), context.Request["Address"].ToString(), context.Request["City"].ToString(), CountryName, false);
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
    private void ResponsBytes(HttpContext Context, byte[] file, string Pre)
    {
        try
        {
            Context.Response.Clear();
            switch (Pre.ToLower())
            {
                case "pdf":
                    Context.Response.ContentType = "application/pdf";
                    break;
                case "txt":
                    Context.Response.ContentType = "text/plain";
                    break;
                case "xls":
                    Context.Response.ContentType = "application/vnd.ms-excel";
                    break;
                case "xlsx":
                    Context.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    break;
                case "doc":
                    Context.Response.ContentType = "application/msword";
                    break;
                case "docx":
                    Context.Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                    break;
                case "ppt":
                    Context.Response.ContentType = "application/vnd.ms-powerpoint";
                    break;
                case "pptx":
                    Context.Response.ContentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                    break;
                case "png":
                    Context.Response.ContentType = "image/png";
                    break;
                case "jpg":
                    Context.Response.ContentType = "image/jpeg";
                    break;
            }

            Context.Response.AddHeader("content-disposition", "attachment;    filename=file." + Pre);
            Context.Response.AddHeader("File-Name", "file." + Pre);
            Context.Response.AddHeader("content-length", file.Length.ToString());
            Context.Response.BinaryWrite(file);
            Context.Response.Flush();
            Context.Response.End();

            ////using (Bitmap image = new Bitmap(Context.Server.MapPath("images/stars_5.png")))
            ////{
            ////    using(MemoryStream ms = new MemoryStream())
            ////    {
            ////        image.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
            ////        ms.WriteTo(Context.Response.OutputStream);
            ////    }
            ////}

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    private void UserLogin(HttpContext Context, string UserName, string Password, string userIP = null)
    {
        WebClient client = new WebClient();

        string str = new UserService().MPUserLogin(UserName, Password, userIP, ConStrings.DicAllConStrings[SessionProjectName]);///client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPUserLogin?UserName=" + UserName + "&Password=" + Password + "&userIP=" + userIP + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

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
                if (app.Key == "Language")
                {
                    SessionLanguage = ((string)app.Value).ToString();
                }
                if (app.Key == "ProfileID")
                {
                    SessionVersionID = ((int)app.Value).ToString();

                    if (System.Configuration.ConfigurationManager.AppSettings["IsDevelop"] != null && System.Configuration.ConfigurationManager.AppSettings["IsDevelop"].ToString().ToLower() == "true")
                    {
                        SessionVersionID = "0";
                    }

                }
                if (app.Key == "ProfileID")
                {
                    ProfileID = app.Value.ToString();
                }
                if (app.Key == "CountryName")
                {
                    CountryName = app.Value.ToString();
                }
            }
        }

        ResponseJSON(Context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void MPLayout_GetFormTabs(HttpContext context, string FormID)
    {
        ResponseJSON(context, GetJson(DAL.LayoutDAL.MPLayout_GetFormTabs(SessionVersionID, FormID, ConStrings.DicAllConStrings[SessionProjectName])));
    }
    private void MPLayout_GetTabUI(HttpContext context, string TabID, string VersionID)
    {
        MPLayoutService wr = new MPLayoutService();
        System.Data.DataTable dt = wr.MPLayout_GetTabUI(TabID, VersionID, ConStrings.DicAllConStrings[SessionProjectName]);

        string htm = "<div class='dAllTab'>";

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            htm += "<div class='ddivFragment'>gggg</div>";
        }

        htm += "</div>";
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(htm));
    }
    private void MPLayout_GetReportDataJSON(HttpContext context, string ReportID, string VersionID, string Params, string ColumnName, string Value)
    {
        Params += "@SessionUserID=" + SessionUserID + ";";

        if (ColumnName.Length == 0)
        {
            MPLayoutService wr = new MPLayoutService();
            DataTable dt = wr.MPLayout_GetQueryDataDT(ReportID, VersionID, Params, ConStrings.DicAllConStrings[SessionProjectName]);
            DataTable dtTemp = new DataTable();
            Dictionary<string, DataTable> dic = (Dictionary<string, DataTable>)SessionGridDictionary;

            if (dic == null)
                dic = new Dictionary<string, DataTable>();

            if (dic.TryGetValue(ReportID, out dtTemp))
                dic.Remove(ReportID);

            dic.Add(ReportID, dt);

            SessionGridDictionary = dic;

            ResponseJSON(context, HttpContext.Current.Server.UrlDecode(GetJson(dt)).Replace("&nbsp;", " "));
        }
        else//filter
        {
            MPLayoutService WR = new MPLayoutService();
            DataTable dtRep = new DataTable();
            if (ReportID != "")
                dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
            bool first = true;
            string[] ColumnNameArr = ColumnName.Split(';');
            string[] ValueArr = Value.Split(';');
            Dictionary<string, DataTable> dic = (Dictionary<string, DataTable>)SessionGridDictionary;
            DataTable dt = dic[ReportID];
            dt.DefaultView.RowFilter = null;
            DataView dv = dt.DefaultView;
            for (int i = 0; i < ColumnNameArr.Length; i++)
            {
                if (ValueArr[i] != "")
                {
                    if (first)
                    {
                        dv.RowFilter = "CONVERT(" + ColumnNameArr[i] + ", System.String) like '%" + ValueArr[i] + "%' ";
                        first = false;
                    }
                    else
                        dv.RowFilter += " AND CONVERT(" + ColumnNameArr[i] + ", System.String) like '%" + ValueArr[i] + "%' ";
                }
            }
            DataTable dtDdl = dv.ToTable();
            string strB = "[";
            if (HandlerBaseCls.SessionGridDictionary != null)
            {
                try
                {
                    if (dtDdl.Rows.Count != 0)
                    {
                        for (int u = 0; u < dtRep.Rows.Count; u++)
                        {
                            for (int c = 0; c < dtDdl.Columns.Count; c++)
                            {
                                if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dt.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "3")//ddl
                                {
                                    StringBuilder sb = new StringBuilder();
                                    sb.Append("<select id='DDLSel" + dtDdl.Columns[c].ToString().ToLower() + "' onchange='SearchBytxt(this);' style='display:;' class='selectSearch SearchOnTop'>");
                                    sb.Append(" <option value='' ></option>");
                                    List<string> RowsList = new List<string>();
                                    for (int r = 0; r < dtDdl.Rows.Count; r++)
                                    {
                                        bool Exist = true;
                                        foreach (string Rowitem in RowsList)
                                            if (Rowitem == dtDdl.Rows[r][c].ToString())
                                                Exist = false;
                                        if (Exist && dtDdl.Rows[r][c].ToString() != "")
                                            RowsList.Add(dtDdl.Rows[r][c].ToString());
                                    }
                                    foreach (string Rowitem in RowsList)
                                    {
                                        sb.Append("<option value='" + Rowitem + "'");
                                        if (ValueArr[u] == Rowitem && ValueArr[u] != "")
                                            sb.Append(" selected ");
                                        sb.Append(">" + Rowitem + "</option>");
                                    }

                                    sb.Append("</select>");
                                    strB += "{\"id\":\"" + HttpUtility.UrlEncode("DDLSel" + dtDdl.Columns[c].ToString().ToLower()) + "\",\"ColName\":\"" + HttpUtility.UrlEncode(dtDdl.Columns[c].ToString()) + "\",\"htmSelect\":\"" + HttpUtility.UrlEncode(sb.ToString()) + "\"},";

                                }
                                else if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dt.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "2")//ddl
                                {
                                    string val = "";
                                    StringBuilder sb = new StringBuilder();
                                    for (int i = 0; i < ColumnNameArr.Length; i++)
                                    {
                                        if (dtRep.Rows[u]["ColName"].ToString().ToLower() == ColumnNameArr[i].ToLower())
                                            val = ValueArr[i];
                                    }
                                    sb.Append(" <input type='text' id='txtSel" + dtDdl.Columns[c].ToString().ToLower() + "' style='display:;' class='txtSearch SearchOnTop' onkeyup='SearchBytxt(this);' value='" + val + "' >");
                                    strB += "{\"id\":\"" + HttpUtility.UrlEncode("txtSel" + dtDdl.Columns[c].ToString().ToLower()) + "\",\"ColName\":\"" + HttpUtility.UrlEncode(dtDdl.Columns[c].ToString()) + "\",\"htmSelect\":\"" + HttpUtility.UrlEncode(sb.ToString()) + "\"},";
                                }
                                else if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dt.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "1")//ddl
                                {
                                    StringBuilder sb = new StringBuilder();
                                    sb.Append(" <input type='text' id='txtSel" + dtDdl.Columns[c].ToString().ToLower() + "' style='display:;' class='notSearch SearchOnTop' onkeyup='SearchBytxt(this);' >");
                                    strB += "{\"id\":\"" + HttpUtility.UrlEncode("txtSel" + dtDdl.Columns[c].ToString().ToLower()) + "\",\"ColName\":\"" + HttpUtility.UrlEncode(dtDdl.Columns[c].ToString()) + "\",\"htmSelect\":\"" + HttpUtility.UrlEncode(sb.ToString()) + "\"},";
                                }
                            }
                        }
                    }
                    else
                    {
                        for (int u = 0; u < dtRep.Rows.Count; u++)
                        {
                            for (int c = 0; c < dtDdl.Columns.Count; c++)
                            {
                                if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dt.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "3")//ddl
                                {
                                    StringBuilder sb = new StringBuilder();
                                    sb.Append("<select id='DDLSel" + dtDdl.Columns[c].ToString().ToLower() + "' onchange='SearchBytxt(this);' class='selectSearch SearchOnTop'>");
                                    string val = "";
                                    for (int i = 0; i < ColumnNameArr.Length; i++)
                                    {
                                        if (dtRep.Rows[u]["ColName"].ToString().ToLower() == ColumnNameArr[i].ToLower())
                                            val = ValueArr[i];
                                    }
                                    sb.Append("<option value='" + val + "'");
                                    sb.Append(" selected ");
                                    sb.Append(">" + val + "</option>");
                                    sb.Append(" <option value='' ></option>");
                                    sb.Append("</select>");
                                    strB += "{\"id\":\"" + HttpUtility.UrlEncode("DDLSel" + dtDdl.Columns[c].ToString().ToLower()) + "\",\"ColName\":\"" + HttpUtility.UrlEncode(dtDdl.Columns[c].ToString()) + "\",\"htmSelect\":\"" + HttpUtility.UrlEncode(sb.ToString()) + "\"},";

                                }
                                else if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dt.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "2")//ddl
                                {
                                    string val = "";
                                    StringBuilder sb = new StringBuilder();
                                    for (int i = 0; i < ColumnNameArr.Length; i++)
                                    {
                                        if (dtRep.Rows[u]["ColName"].ToString().ToLower() == ColumnNameArr[i].ToLower())
                                            val = ValueArr[i];
                                    }
                                    sb.Append(" <input type='text' id='txtSel" + dtDdl.Columns[c].ToString().ToLower() + "' class='txtSearch SearchOnTop' onkeyup='SearchBytxt(this);' value='" + val + "' >");
                                    strB += "{\"id\":\"" + HttpUtility.UrlEncode("txtSel" + dtDdl.Columns[c].ToString().ToLower()) + "\",\"ColName\":\"" + HttpUtility.UrlEncode(dtDdl.Columns[c].ToString()) + "\",\"htmSelect\":\"" + HttpUtility.UrlEncode(sb.ToString()) + "\"},";
                                }
                                else if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dt.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "1")//ddl
                                {
                                    StringBuilder sb = new StringBuilder();
                                    sb.Append(" <input type='text' id='txtSel" + dtDdl.Columns[c].ToString().ToLower() + "' class='notSearch SearchOnTop' onkeyup='SearchBytxt(this);' >");
                                    strB += "{\"id\":\"" + HttpUtility.UrlEncode("txtSel" + dtDdl.Columns[c].ToString().ToLower()) + "\",\"ColName\":\"" + HttpUtility.UrlEncode(dtDdl.Columns[c].ToString()) + "\",\"htmSelect\":\"" + HttpUtility.UrlEncode(sb.ToString()) + "\"},";
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {

                }
                strB += "{\"ColName\":\"SelectDDL\",\"htmSelect\":\"" + HttpUtility.UrlEncode(GetJson(dtDdl)) + "\"}";
                strB += "]";
                ResponseJSON(context, (strB));

            }

        }
    }

    private void SetProjectName(string Name)
    {
        SessionProjectName = Name;
    }
    private void MPLayout_MSG_GetAllMessages(HttpContext context, string VersionID, string PopulationTypeID)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_MSG_GetAllMessages?VersionID=" + VersionID + "&PopulationTypeID=" + PopulationTypeID +
        //    "&ConString=" + ConStrings.DicAllConStrings["Sides"]);//"&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        ResponseJSON(context, GetJson(DAL.LayoutDAL.MPLayout_MSG_GetAllMessages(VersionID, PopulationTypeID, ConStrings.DicAllConStrings[SessionProjectName])).Replace("&nbsp;", " "));
    }
    private void MPLayout_GetPopulations(HttpContext context, string PopulationTypeID)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetPopulations?PopulationTypeID=" + PopulationTypeID +
        //    "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, GetJson(DAL.LayoutDAL.MPLayout_GetPopulations(PopulationTypeID, ConStrings.DicAllConStrings[SessionProjectName])).Replace("&nbsp;", " "));
    }
    private void MPLayout_SetPopulationData(HttpContext context, string PopulationID, string PopulationTypeID, string PopulationDescription, string PopulationQuery, string IsToDelete, string UserID)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetPopulationData(PopulationID, PopulationTypeID, PopulationDescription, PopulationQuery, IsToDelete, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void MPLayout_SetMSGData(HttpContext context, string MessageID, string MessageText, string MessageFromDate, string MessageToDate, string IsToDelete, string UserID, string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetMSGData(MessageID, MessageText, Convert.ToDateTime(MessageFromDate).ToString("yyyyMMdd"), Convert.ToDateTime(MessageToDate).ToString("yyyyMMdd"), IsToDelete, UserID, ConStrings.DicAllConStrings[SessionProjectName]
            , ParentsPopulation, ItemsPopulation, UnCheckedPopulation).ToString());
    }
    private void MPLayout_Tasks_GetAllTasks(HttpContext context, string TaskUserID)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_Tasks_GetAllTasks?UserID=" + TaskUserID +
        //    "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, GetJson(DAL.LayoutDAL.MPLayout_Tasks_GetAllTasks(TaskUserID, ConStrings.DicAllConStrings[SessionProjectName])).Replace("&nbsp;", " "));
    }
    private void MPLayout_SetTaskData(HttpContext context, string TaskID, string ClassificationID, string TopicID, string SubTopic, string Task, string PriorityID,
            string dtReport, string dtTaskEnd, string ConditionID, string TaskNotes, string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation, string IsToDelete, string UserID, string TaskStatusID, string dtStatus, string DateFrom, string DateTo, string AlarmDate)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetTaskData(TaskID, ClassificationID, TopicID, SubTopic, Task, PriorityID,
            dtReport, dtTaskEnd, ConditionID, TaskNotes, ParentsPopulation, ItemsPopulation, UnCheckedPopulation, IsToDelete, UserID, TaskStatusID, dtStatus, DateFrom, DateTo, AlarmDate, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void MPLayout_Tasks_GetTsakPopulationJSON(HttpContext context, string TaskID)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_Tasks_GetTsakPopulationJSON?TaskID=" + TaskID +
        //    "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        DataSet ds = DAL.LayoutDAL.MPLayout_Tasks_GetTsakPopulation(TaskID, ConStrings.DicAllConStrings[SessionProjectName]);
        if (ds != null && ds.Tables.Count > 0)
            ResponseJSON(context, GetJson(ds.Tables[0]).Replace("&nbsp;", " "));
    }

    private void MPLayout_Tasks_GetTsakPopulationParentsJSON(HttpContext context, string TaskID)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_Tasks_GetTsakPopulationParentsJSON?TaskID=" + TaskID +
        //    "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        DataSet ds = DAL.LayoutDAL.MPLayout_Tasks_GetTsakPopulation(TaskID, ConStrings.DicAllConStrings[SessionProjectName]);
        if (ds != null && ds.Tables.Count > 1)
            ResponseJSON(context, GetJson(ds.Tables[1]).Replace("&nbsp;", " "));
    }
    public void GridDataNew(HttpContext context)
    {
        WebClient client = new WebClient();
        string id = "";
        if (context.Request.QueryString["id"] != null)
            id = "&id=" + context.Request.QueryString["id"].ToString();

        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString()
        //    + "/MobiWebServices/MobiPlusWS.asmx/GridDataNew?GridName=" + context.Request.QueryString["GridName"].ToString() + "&GridParameters=" + context.Request.QueryString["GridParameters"].ToString() + id +
        //"&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        try
        {
            if (context.Request.QueryString["GridParameters"] == null)
                return;

            if (context.Request.QueryString["id"] != null)
                id = context.Request.QueryString["id"].ToString();

            DataSet ds = DAL.DAL.GetGridDataNew(context.Request.QueryString["GridName"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
            if (ds != null && ds.Tables.Count > 1 && ds.Tables[0].Rows.Count > 0)
            {
                string GridQuery = ds.Tables[0].Rows[0]["GridQuery"].ToString();

                //replace delete strings
                if (GridQuery != null && GridQuery.Length > 0 && (GridQuery.ToLower().IndexOf("delete") > -1 || GridQuery.ToLower().IndexOf("truncate") > -1 || GridQuery.ToLower().IndexOf("create") > -1 || GridQuery.ToLower().IndexOf("alter") > -1))
                    GridQuery = GridQuery.ToLower().Replace("delete", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                DataTable dtRes = new DataTable();
                string QueryType = ds.Tables[0].Rows[0]["QueryType"].ToString();
                if (QueryType.IndexOf(",") > -1)
                    QueryType = ds.Tables[0].Rows[0]["QueryType"].ToString().Split(',')[0];
                switch (QueryType)
                {
                    case "Query":
                        string[] arrParams = context.Request.QueryString["GridParameters"].ToString().Split(';');
                        bool isFirst = true;
                        for (int i = 0; i < arrParams.Length; i++)
                        {
                            string[] arrParamValue = arrParams[i].Split(':');

                            if (arrParamValue.Length > 1 && GridQuery.IndexOf("@" + arrParamValue[0]) > -1)
                            {
                                GridQuery = GridQuery.Replace("@" + arrParamValue[0], arrParamValue[1]);
                            }
                        }
                        if (id != "")
                            GridQuery = GridQuery.Replace("where", "where " + ds.Tables[0].Rows[0]["ChildFilterCol"].ToString() + id + " and ");
                        dtRes = DAL.DAL.RunQuery(GridQuery, ConStrings.DicAllConStrings[SessionProjectName]);
                        break;
                    case "View":

                        arrParams = context.Request.QueryString["GridParameters"].ToString().Split(';');
                        isFirst = true;
                        for (int i = 0; i < arrParams.Length; i++)
                        {
                            string[] arrParamValue = arrParams[i].Split(':');

                            if (arrParamValue.Length > 1)
                            {
                                if (isFirst)
                                {
                                    GridQuery += " Where ";
                                    isFirst = false;
                                }
                                GridQuery = GridQuery.Replace("@" + arrParamValue[0], arrParamValue[1]);
                            }
                        }
                        if (id != "")
                            GridQuery = GridQuery.Replace("where", "where " + ds.Tables[0].Rows[0]["ChildFilterCol"].ToString() + id);
                        dtRes = DAL.DAL.RunQuery("Select * from " + GridQuery, ConStrings.DicAllConStrings[SessionProjectName]);
                        break;
                    case "Stored procedure":
                        if (id != "")
                            id = ";" + ds.Tables[0].Rows[0]["ChildFilterCol"].ToString().Replace("=", "") + ":" + id + ";";
                        dtRes = DAL.DAL.RunSP(ds.Tables[0].Rows[0]["GridQuery"].ToString(), context.Request.QueryString["GridParameters"].ToString() + id, ConStrings.DicAllConStrings[SessionProjectName]);
                        break;
                }

                ResponseJSON(context, GetJson(dtRes));
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

    }
    private void MPLayout_GetReportDataByNameJSON(HttpContext context, string ReportName, string VersionID, string Params)
    {
        if (Params.IndexOf("UserID") > -1)
            Params = Params.Replace("UserID=;", "UserID=" + SessionUserID + ";");
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString()
        //    + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetQueryDataByName2?Params=" + Params + "&ReportName=" + ReportName +
        //    "&VersionID=" + VersionID +
        //    "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        DataTable dt = DAL.LayoutDAL.MPLayout_GetQueryDataByName(ReportName, VersionID, ConStrings.DicAllConStrings[SessionProjectName]);
        dt.TableName = "dt";
        DataTable dtData = new DataTable("dtData");

        if (dt != null && dt.Rows.Count > 0)
        {
            string[] arr = Params.Split(';');

            if (dt.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {

                for (int i = 0; i < arr.Length; i++)
                {
                    string[] arrVals = arr[i].Split('=');
                    if (dt.Rows[0]["ReportQuery"].ToString().ToLower().IndexOf("@" + arrVals[0].ToLower()) > -1 && arrVals.Length > 1)
                        dt.Rows[0]["ReportQuery"] = dt.Rows[0]["ReportQuery"].ToString().ToLower().Replace("@" + arrVals[0].ToLower(), "'" + arrVals[1] + "'");

                }

                dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
            }
            else if (dt.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string[] arrParmsSP = dt.Rows[0]["Report_SP_Params"].ToString().Split(';');
                string NewParms = "";
                for (int y = 0; y < arrParmsSP.Length; y++)
                {
                    for (int g = 0; g < arr.Length; g++)
                    {
                        if (arr[g].IndexOf("=") > -1 && arr[g].IndexOf("ID=") == -1 && arr[g] != "=")
                        {
                            string Key = arr[g].Split('=')[0].Replace("\"", "");
                            string Value = arr[g].Split('=')[1];
                            if ((arrParmsSP[y] == "@" + Key || arrParmsSP[y] == Key) && arrParmsSP[y] != "")
                                NewParms += arrParmsSP[y] + ":" + Value + ";";
                        }
                    }
                }
                dtData = DAL.LayoutDAL.RunSP(dt.Rows[0]["ReportQuery"].ToString(), NewParms.Replace("@", ""), ConStrings.DicAllConStrings[SessionProjectName]);
            }
        }


        ResponseJSON(context, GetJson(dtData).Replace("&nbsp;", " ").Replace("'", ""));
    }
    private void SetGoalByDates(HttpContext context, string ObjTypeID, string AgentId, string Cust_Key, string SubCode, string ItemId, string FromDate, string ToDate, string Goal, string GoalPercents, string isToSetChildrens, string MPUserID)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.SetGoalByDates(ObjTypeID, AgentId, Cust_Key, SubCode, ItemId, FromDate, ToDate, Goal, GoalPercents, isToSetChildrens, MPUserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void MPLayout_MSG_GetMSGPopulationJSON(HttpContext context, string MessageID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString()
            + "/MobiWebServices/MPLayoutService.asmx/MPLayout_MSG_GetMSGPopulationJSON?MessageID=" + MessageID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_MSG_GetMSGPopulationParentsJSON(HttpContext context, string MessageID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString()
            + "/MobiWebServices/MPLayoutService.asmx/MPLayout_MSG_GetMSGPopulationParentsJSON?MessageID=" + MessageID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_GetParametersData(HttpContext context)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString()
        //    + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetParameters?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        //ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
        DataTable dt = DAL.LayoutDAL.MPLayout_GetParameters(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null)
            ResponseJSON(context, GetJson(dt).Replace("&nbsp;", " "));


    }
    private void MPLayout_SetParametersData(HttpContext context, string PrmVersion, string PrmId, string Value, string RealID, string IsToDelete)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_SetParameters?PrmVersion=" + PrmVersion + "&PrmId=" + PrmId + "&Value=" + Value +
        //  "&RealID=" + RealID + "&IsToDelete=" + IsToDelete +  "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        //ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));

        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetParameters(ConStrings.DicAllConStrings[SessionProjectName], PrmVersion, PrmId, Value, RealID, IsToDelete).ToString());
    }
    private void GetJsonTableData(HttpContext context, string TableName)
    {

        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() 
        //    + "/MobiWebServices/MPLayoutService.asmx/GetJsonTableData?TableName=" + TableName +
        //"&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        //ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
        DataTable dt = DAL.LayoutDAL.GetTableData(ConStrings.DicAllConStrings[SessionProjectName], TableName);
        if (dt != null)
            ResponseJSON(context, GetJson(dt));
    }
    private void MPLayout_AddParametersTableDefinitions(HttpContext context, string TableName, string Prams, string Type)
    {
        MPLayoutService wr = new MPLayoutService();
        DataTable dt = new DataTable();
        dt = wr.GetTableData(ConStrings.DicAllConStrings[SessionProjectName], TableName);
        string Query = "INSERT INTO [" + TableName + "](";
        string intoCol = "";
        string intoVal = "";
        string preIntoVal = "";
        string[] split = Prams.Split(';');
        string[] type = Type.Split(':');
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            preIntoVal = intoVal;
            if (i == 0)
            {
                intoCol += "[" + dt.Columns[i].ToString() + "]";
                for (int j = 0; j < split.Length; j++)
                    if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                    {
                        if (type[i] == "DateTime")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime;
                            try
                            {
                                dtime = Convert.ToDateTime(strDate.Split(' ')[1] + " " + strDate.Split(' ')[0]);
                            }
                            catch (Exception)
                            {
                                dtime = Convert.ToDateTime(strDate);
                            }
                            string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                            intoVal += "@@@" + date + "@@@";
                        }
                        else if (type[i] == "Dateyyyymmdd")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime = Convert.ToDateTime(strDate);
                            string date = dtime.ToString("yyyyMMdd");
                            intoVal += "@@@" + date + "@@@";
                        }
                        else
                        {
                            intoVal += "N@@@" + split[j + 1] + "@@@";
                        }
                        break;
                    }

            }
            else
            {
                intoCol += ",[" + dt.Columns[i].ToString() + "]";
                for (int j = 0; j < split.Length; j++)
                    if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                    {
                        if (type[i] == "DateTime")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime;
                            try
                            {
                                dtime = Convert.ToDateTime(strDate.Split(' ')[1] + " " + strDate.Split(' ')[0]);
                            }
                            catch (Exception)
                            {
                                dtime = Convert.ToDateTime(strDate);
                            }

                            string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                            intoVal += ",N@@@" + date + "@@@";
                        }
                        else if (type[i] == "Dateyyyymmdd")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime = Convert.ToDateTime(strDate);
                            string date = dtime.ToString("yyyyMMdd");
                            intoVal += ",@@@" + date + "@@@";
                        }
                        else
                        {
                            intoVal += ",N@@@" + split[j + 1] + "@@@";
                        }

                        break;
                    }

            }
            if (preIntoVal == intoVal)
            {
                intoVal += ",NULL";
            }
        }

        Query += intoCol + ") VALUES(" + intoVal + ")";

        string Pass = "Golan20150120";

        ResponseJSON(context, wr.SetTableFromDefinitions(ConStrings.DicAllConStrings[SessionProjectName], Query, Pass, "0").ToString());
    }

    private void MPLayout_EditParametersTableDefinitions(HttpContext context, string TableName, string Prams, string OldPrams, string Type, string IsPrimary)
    {

        string[] split = Prams.Split(';');
        string[] splitoLD = OldPrams.Split(';');
        string[] type = Type.Split(':');
        string[] Primary = IsPrimary.Split(';');
        string intoCol = "";
        string intoVal = "";
        string preIntoVal = "";
        bool firstU = true;
        bool firstW = true;
        string Query = "";
        MPLayoutService wr = new MPLayoutService();
        DataTable dt = new DataTable();
        dt = wr.GetTableData(ConStrings.DicAllConStrings[SessionProjectName], TableName);
        if (Primary.Length > 0)
        {
            Query += "IF EXISTS (SELECT TOP 1 1 FROM [" + TableName + "] WHERE";


            for (int i = 0; i < Primary.Length; i++)
            {
                if (i == 0)
                {
                    for (int j = 0; j < splitoLD.Length; j++)
                    {
                        if (splitoLD[j].ToLower() == Primary[i].ToLower())
                            Query += " " + Primary[i] + " = N@@@" + splitoLD[j + 1] + "@@@";
                    }
                }
                else
                {
                    for (int j = 0; j < splitoLD.Length; j++)
                    {
                        if (splitoLD[j].ToLower() == Primary[i].ToLower())
                            Query += " AND " + Primary[i] + " = N@@@" + splitoLD[j + 1] + "@@@";
                    }
                }
            }
            Query += ")";
        }

        Query += " BEGIN  UPDATE [" + TableName + "] SET";


        for (int i = 0; i < dt.Columns.Count; i++)
        {
            for (int p = 0; p < Primary.Length; p++)
            {
                if (dt.Columns[i].ToString().ToLower() != Primary[p].ToLower())
                {
                    for (int j = 0; j < split.Length; j++)
                    {
                        if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                        {
                            if (firstU)
                            {
                                Query += " [" + dt.Columns[i].ToString() + "] = ";
                                firstU = false;
                            }
                            else
                                Query += ",[" + dt.Columns[i].ToString() + "] = ";
                        }
                    }
                    for (int j = 0; j < split.Length; j++)
                    {
                        if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                        {
                            if (type[i] == "DateTime")
                            {
                                string strDate = split[j + 1];
                                DateTime dtime;
                                try
                                {
                                    dtime = Convert.ToDateTime(strDate.Split(' ')[2] + " " + strDate.Split(' ')[0]);
                                }
                                catch (Exception)
                                {
                                    dtime = Convert.ToDateTime(strDate);
                                }
                                string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                                Query += "@@@" + date + "@@@";
                            }
                            else if (type[i] == "Dateyyyymmdd")
                            {
                                string strDate = split[j + 1];
                                DateTime dtime = Convert.ToDateTime(strDate);
                                string date = dtime.ToString("yyyyMMdd");
                                Query += "@@@" + date + "@@@";
                            }
                            else
                            {
                                Query += "N@@@" + split[j + 1] + "@@@";
                            }
                            break;
                        }
                    }
                }
            }
        }


        Query += " WHERE ";

        for (int i = 0; i < dt.Columns.Count; i++)
        {
            for (int p = 0; p < Primary.Length; p++)
            {
                if (dt.Columns[i].ToString().ToLower() == Primary[p].ToLower())
                {
                    if (firstW)
                    {
                        Query += " [" + dt.Columns[i].ToString() + "] = ";
                        firstW = false;
                    }
                    else
                        Query += " AND [" + dt.Columns[i].ToString() + "] = ";

                    for (int j = 0; j < splitoLD.Length; j++)
                        if (splitoLD[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                        {
                            if (type[i] == "DateTime")
                            {
                                string strDate = splitoLD[j + 1];
                                DateTime dtime;
                                try
                                {
                                    dtime = Convert.ToDateTime(strDate.Split(' ')[2] + " " + strDate.Split(' ')[0]);
                                }
                                catch (Exception)
                                {
                                    dtime = Convert.ToDateTime(strDate);
                                }
                                string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                                Query += "@@@" + date + "@@@";
                            }
                            else if (type[i] == "Dateyyyymmdd")
                            {
                                string strDate = splitoLD[j + 1];
                                DateTime dtime = Convert.ToDateTime(strDate);
                                string date = dtime.ToString("yyyyMMdd");
                                Query += "@@@" + date + "@@@";
                            }
                            else
                            {
                                Query += "N@@@" + splitoLD[j + 1] + "@@@";
                            }
                            break;
                        }
                }
            }
        }

        Query += " END  ELSE BEGIN INSERT INTO [" + TableName + "](";
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            preIntoVal = intoVal;
            if (i == 0)
            {

                intoCol += "[" + dt.Columns[i].ToString() + "]";
                for (int j = 0; j < split.Length; j++)
                    if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                    {
                        if (type[i] == "DateTime")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime;
                            try
                            {
                                dtime = Convert.ToDateTime(strDate.Split(' ')[1] + " " + strDate.Split(' ')[0]);
                            }
                            catch (Exception)
                            {
                                dtime = Convert.ToDateTime(strDate);
                            }
                            string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                            intoVal += "@@@" + date + "@@@";
                        }
                        else if (type[i] == "Dateyyyymmdd")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime = Convert.ToDateTime(strDate);
                            string date = dtime.ToString("yyyyMMdd");
                            intoVal += "@@@" + date + "@@@";
                        }
                        else
                        {
                            intoVal += "N@@@" + split[j + 1] + "@@@";
                        }
                        break;
                    }

            }
            else
            {
                intoCol += ",[" + dt.Columns[i].ToString() + "]";
                for (int j = 0; j < split.Length; j++)
                    if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                    {
                        if (type[i] == "DateTime")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime;
                            try
                            {
                                dtime = Convert.ToDateTime(strDate.Split(' ')[1] + " " + strDate.Split(' ')[0]);
                            }
                            catch (Exception)
                            {
                                dtime = Convert.ToDateTime(strDate);
                            }

                            string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                            intoVal += ",@@@" + date + "@@@";
                        }
                        else if (type[i] == "Dateyyyymmdd")
                        {
                            string strDate = split[j + 1];
                            DateTime dtime = Convert.ToDateTime(strDate);
                            string date = dtime.ToString("yyyyMMdd");
                            intoVal += ",@@@" + date + "@@@";
                        }
                        else
                        {
                            intoVal += ",N@@@" + split[j + 1] + "@@@";
                        }

                        break;
                    }

            }
            if (preIntoVal == intoVal)
            {
                intoVal += ",NULL";
            }
        }
        Query += intoCol + ") VALUES(" + intoVal + ") END ";
        string Pass = "Golan20150120";
        ResponseJSON(context, wr.SetTableFromDefinitions(ConStrings.DicAllConStrings[SessionProjectName], Query, Pass, "1").ToString());
    }

    private void MPLayout_DelParametersTableDefinitions(HttpContext context, string TableName, string OldPrams, string Type, string IsPrimary)
    {

        MPLayoutService wr = new MPLayoutService();
        DataTable dt = new DataTable();
        dt = wr.GetTableData(ConStrings.DicAllConStrings[SessionProjectName], TableName);
        string Query = "delete [" + TableName + "] WHERE ";
        string[] split = OldPrams.Split(';');
        string[] type = Type.Split(':');
        string[] Primary = IsPrimary.Split(';');
        bool firstU = true;
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            for (int p = 0; p < Primary.Length; p++)
            {
                if (dt.Columns[i].ToString().ToLower() == Primary[p].ToLower())
                {
                    if (firstU)
                    {
                        firstU = false;
                        Query += "[" + dt.Columns[i].ToString() + "] =";
                        for (int j = 0; j < split.Length; j++)
                            if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                            {
                                if (type[i] == "DateTime")
                                {
                                    string strDate = split[j + 1];
                                    DateTime dtime;
                                    try
                                    {
                                        dtime = Convert.ToDateTime(strDate.Split(' ')[1] + " " + strDate.Split(' ')[0]);
                                    }
                                    catch (Exception)
                                    {
                                        dtime = Convert.ToDateTime(strDate);
                                    }
                                    string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                                    Query += "\'" + date + "\'";
                                }
                                else if (type[i] == "Dateyyyymmdd")
                                {
                                    string strDate = split[j + 1];
                                    DateTime dtime = Convert.ToDateTime(strDate);
                                    string date = dtime.ToString("yyyyMMdd");
                                    Query += "\'" + date + "\'";
                                }
                                else
                                {
                                    Query += "N\'" + split[j + 1] + "\'";
                                }

                                break;
                            }

                    }
                    else
                    {
                        Query += " AND [" + dt.Columns[i].ToString() + "] =";
                        for (int j = 0; j < split.Length; j++)
                            if (split[j].ToString().ToLower() == dt.Columns[i].ToString().ToLower())
                            {
                                if (type[i] == "DateTime")
                                {
                                    string strDate = split[j + 1];
                                    DateTime dtime;
                                    try
                                    {
                                        dtime = Convert.ToDateTime(strDate.Split(' ')[2] + " " + strDate.Split(' ')[0]);
                                    }
                                    catch (Exception)
                                    {
                                        dtime = Convert.ToDateTime(strDate);
                                    }
                                    string date = dtime.ToString("yyyy-MM-dd HH:mm:ss");
                                    Query += "\'" + date + "\'";
                                }
                                else if (type[i] == "Dateyyyymmdd")
                                {
                                    string strDate = split[j + 1];
                                    DateTime dtime = Convert.ToDateTime(strDate);
                                    string date = dtime.ToString("yyyyMMdd");
                                    Query += "\'" + date + "\'";
                                }
                                else
                                {
                                    Query += "N\'" + split[j + 1] + "\'";
                                }
                                break;
                            }

                    }
                }
            }
        }
        string Pass = "Golan20150120";
        ResponseJSON(context, wr.SetTableFromDefinitions(ConStrings.DicAllConStrings[SessionProjectName], Query, Pass, "2").ToString());
    }

    private void MPLayout_SearchBytxt(HttpContext context, string TableName, string ColumnName, string Value)
    {
        //WebClient client = new WebClient();
        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_SearchBytxt?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]+"&TableName="+TableName+"&ColumnName="+ColumnName+"&Value="+Value);
        DataTable dt = (DataTable)SessionGridDT;
        DataView dv = dt.DefaultView;
        dv.RowFilter = ColumnName + " like '%" + Value + "'";
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(GetJson(dv.ToTable())).Replace("&nbsp;", " "));
    }

    public string GetJson(DataTable dt)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows =
          new List<Dictionary<string, object>>();
        Dictionary<string, object> row = null;


        serializer.MaxJsonLength = Int32.MaxValue;

        foreach (DataRow dr in dt.Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                if (col.DataType == typeof(String))
                    row.Add(col.ColumnName.Trim(), (dr[col].ToString().Replace("'", "").Replace("\"", "''").Replace("\"", "").Replace(@"'\", "").Replace("\\", "").Replace("      ", "")));
                else
                    row.Add(HttpUtility.UrlEncode(col.ColumnName.Trim()), dr[col]);
            }
            rows.Add(row);
        }

        return serializer.Serialize(rows);
    }

    private void MPLayout_SetRoutes(HttpContext context, string CustKey, string Interval, string TimeFromD, string TimeToD, string WDays, string CDays, string RouteDates)
    {

        string Pass = "Golan20150120";
        MPLayoutService wr = new MPLayoutService();
        string Query = "";
        string VisitsDays = "";
        //RoutesDaily
        if (Interval != "" && Interval != "0")
        {
            Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesDaily] WHERE Cust_Key=N@@@" + CustKey + "@@@) BEGIN UPDATE [MTN_CustRoutesDaily] SET ";
            Query += "Interval=N@@@" + Interval + "@@@ ,FromTime=N@@@" + TimeFromD + "@@@ ,ToTime=N@@@" + TimeToD + "@@@";
            Query += " WHERE Cust_Key=N@@@" + CustKey + "@@@";
            Query += " END  ELSE BEGIN INSERT INTO [MTN_CustRoutesDaily](Cust_Key,Interval,FromTime,ToTime)";
            Query += " VALUES(N@@@" + CustKey + "@@@,N@@@" + Interval + "@@@,N@@@" + TimeFromD + "@@@,N@@@" + TimeToD + "@@@) END ";
        }
        else
        {
            Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesDaily] WHERE Cust_Key=N@@@" + CustKey + "@@@ ) BEGIN DELETE FROM [MTN_CustRoutesDaily] WHERE  Cust_Key=N@@@" + CustKey + "@@@  END ";
        }




        //RoutesByDate

        Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesByDate] WHERE Cust_Key=N@@@" + CustKey + "@@@ ) BEGIN DELETE FROM [MTN_CustRoutesByDate] WHERE  Cust_Key=N@@@" + CustKey + "@@@  END ";

        if (RouteDates != "")
        {
            string[] arrRouteDates = RouteDates.Split(';');
            for (int i = 0; i < arrRouteDates.Length; i++)
            {
                string[] arrSingleRouteDates = arrRouteDates[i].Split(' ');
                string TimeToRDate = arrSingleRouteDates[0];
                string TimeFromRDate = arrSingleRouteDates[1];
                string RouteDate = arrSingleRouteDates[2];

                DateTime routeDate = Convert.ToDateTime(RouteDate);
                string sRouteDate = routeDate.ToString("yyyyMMdd");
                Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesByDate] WHERE Cust_Key=N@@@" + CustKey + "@@@ AND Date=N@@@" + sRouteDate + "@@@ ) BEGIN UPDATE [MTN_CustRoutesByDate] SET ";
                Query += "FromTime=N@@@" + TimeFromRDate + "@@@ ,ToTime=N@@@" + TimeToRDate + "@@@";
                Query += " WHERE Cust_Key=N@@@" + CustKey + "@@@ AND Date=N@@@" + sRouteDate + "@@@";
                Query += " END  ELSE BEGIN INSERT INTO [MTN_CustRoutesByDate](Cust_Key,Date,FromTime,ToTime)";
                Query += " VALUES(N@@@" + CustKey + "@@@,N@@@" + sRouteDate + "@@@,N@@@" + TimeFromRDate + "@@@,N@@@" + TimeToRDate + "@@@) END ";
            }
        }

        //RoutesWeekly
        string[] arrWDays = WDays.Split(';');

        Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesWeekly] WHERE Cust_Key=N@@@" + CustKey + "@@@) BEGIN DELETE FROM [MTN_CustRoutesWeekly] WHERE  Cust_Key=N@@@" + CustKey + "@@@  END ";

        if (arrWDays.Length >= 3)
        {
            for (int i = 0; i < arrWDays.Length; i = i + 3)
            {
                // arrWDays[i], arrWDays[i+1], arrWDays[i+2], DateFromW, DateToW);
                Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesWeekly] WHERE Cust_Key=N@@@" + CustKey + "@@@ AND DayOfWeek=N@@@" + arrWDays[i] + "@@@) BEGIN UPDATE [MTN_CustRoutesWeekly] SET ";
                Query += "DayOfWeek=N@@@" + arrWDays[i] + "@@@ ,FromTime=N@@@" + arrWDays[i + 1] + "@@@ ,ToTime=N@@@" + arrWDays[i + 2] + "@@@";
                Query += " WHERE Cust_Key=N@@@" + CustKey + "@@@ AND DayOfWeek=N@@@" + arrWDays[i] + "@@@";
                Query += " END  ELSE BEGIN INSERT INTO [MTN_CustRoutesWeekly](Cust_Key,DayOfWeek,FromTime,ToTime)";
                Query += " VALUES(N@@@" + CustKey + "@@@,N@@@" + arrWDays[i] + "@@@,N@@@" + arrWDays[i + 1] + "@@@,N@@@" + arrWDays[i + 2] + "@@@) END ";

            }
        }


        //RoutesCyclic
        string[] arrCDays = CDays.Split(';');


        Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesCyclic] WHERE Cust_Key=N@@@" + CustKey + "@@@ ) BEGIN DELETE FROM [MTN_CustRoutesCyclic] WHERE  Cust_Key=N@@@" + CustKey + "@@@  END ";


        if (arrCDays.Length >= 3)
        {
            for (int i = 0; i < arrCDays.Length; i = i + 3)
            {
                string day;
                if ((Convert.ToInt32(arrCDays[i]) % 7) != 0)
                    day = (Convert.ToInt32(arrCDays[i]) % 7).ToString();
                else
                    day = "7";
                string week = (Convert.ToInt32(arrCDays[i]) / 7 + 1).ToString();
                Query += "IF EXISTS (SELECT TOP 1 1 FROM [MTN_CustRoutesCyclic] WHERE Cust_Key=N@@@" + CustKey + "@@@ AND WeekNumber=N@@@" + week + "@@@ AND DayOfWeek=N@@@" + day + "@@@) BEGIN UPDATE [MTN_CustRoutesCyclic] SET ";
                Query += "WeekNumber=N@@@" + week + "@@@ ,DayOfWeek=N@@@" + day + "@@@ ,FromTime=N@@@" + arrCDays[i + 1] + "@@@ ,ToTime=N@@@" + arrCDays[i + 2] + "@@@";
                Query += " WHERE Cust_Key=N@@@" + CustKey + "@@@ AND WeekNumber=N@@@" + week + "@@@ AND DayOfWeek=N@@@" + day + "@@@";
                Query += " END  ELSE BEGIN INSERT INTO [MTN_CustRoutesCyclic](Cust_Key,WeekNumber,DayOfWeek,FromTime,ToTime)";
                Query += " VALUES(N@@@" + CustKey + "@@@,N@@@" + week + "@@@,N@@@" + day + "@@@,N@@@" + arrCDays[i + 1] + "@@@,N@@@" + arrCDays[i + 2] + "@@@) END ";
                switch (day)
                {
                    case "1":
                        VisitsDays += "א-" + week + " ";
                        break;
                    case "2":
                        VisitsDays += "ב-" + week + " ";
                        break;
                    case "3":
                        VisitsDays += "ג-" + week + " ";
                        break;
                    case "4":
                        VisitsDays += "ד-" + week + " ";
                        break;
                    case "5":
                        VisitsDays += "ה-" + week + " ";
                        break;
                    case "6":
                        VisitsDays += "ו-" + week + " ";
                        break;
                    case "7":
                        VisitsDays += "ש-" + week + " ";
                        break;

                }
            }
        }

        ResponseJSON(context, wr.MPLayout_SetRoutes(ConStrings.DicAllConStrings[SessionProjectName], Query, CustKey, VisitsDays, Pass).ToString());
    }
    private void MPLayout_GetSelectedParameter(HttpContext context, string Unique, string ReportID, string Params)
    {
        string[] Uniques = Unique.Split(';');
        string[] arrParams = Params.Split(';');
        string arrParamsToSend = "";
        MPLayoutService WR = new MPLayoutService();
        DataTable dtRep = new DataTable();
        if (ReportID != "")
            dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
        bool first = true;

        string[] ValueArr = Unique.Split(';');
        Dictionary<string, DataTable> dic = (Dictionary<string, DataTable>)SessionGridDictionary;
        DataTable dt = dic[ReportID];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            bool Uniq = true;
            for (int j = 0; j < Uniques.Length; j = j + 2)
            {
                if (Uniques[j].ToString() != "" && Uniques[j + 1].ToString() != "" && dt.Rows[i][Uniques[j]].ToString() != Uniques[j + 1].ToString())
                {
                    Uniq = false;
                    break;
                }

            }
            if (Uniq)
            {
                for (int p = 0; p < arrParams.Length; p++)
                {
                    if (first)
                    {
                        arrParamsToSend += dt.Rows[i][arrParams[p]].ToString();
                        first = false;
                    }
                    else
                    {
                        arrParamsToSend += ";" + dt.Rows[i][arrParams[p]].ToString();
                    }
                }
                break;
            }
        }

        ResponseJSON(context, arrParamsToSend);
    }




    private void MPUserChangeProfile(HttpContext Context, string UserID, string Language)
    {
        WebClient client = new WebClient();

        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPUserChangeProfile?UserID=" + UserID + "&Language=" + Language +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        string FormiD = "";

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
                if (app.Key == "Language")
                {
                    SessionLanguage = ((string)app.Value).ToString();
                }
                if (app.Key == "ProfileID")
                {
                    SessionVersionID = ((int)app.Value).ToString();

                    if (System.Configuration.ConfigurationManager.AppSettings["IsDevelop"] != null && System.Configuration.ConfigurationManager.AppSettings["IsDevelop"].ToString().ToLower() == "true")
                    {
                        SessionVersionID = "0";
                    }

                }
                if (app.Key == "ProfileID")
                {
                    ProfileID = app.Value.ToString();

                    MPLayoutService wr = new MPLayoutService();
                    DataTable dt = wr.MPLayout_GetProfileData(ProfileID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);


                    if (dt != null)
                    {
                        FormiD = "0";
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (FormiD != dt.Rows[i]["FormID"].ToString())
                            {
                                FormiD = dt.Rows[i]["FormID"].ToString();
                            }
                        }
                    }
                }
            }
        }

        ResponseJSON(Context, HttpContext.Current.Server.UrlDecode(FormiD));
    }

    private void SetEn(HttpContext Context, string Lan)
    {
        MPUserChangeProfile(Context, SessionUserID, Lan);
    }

    private void MPLayout_GetAllRoutes(HttpContext context, string ViewStart, string ViewEnd, string AgentId)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetAllRoutes?ViewStart=" + ViewStart + "&ViewEnd=" + ViewEnd + "&AgentId=" + AgentId + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_SetInActiveDays(HttpContext context, string AgentId, string InActiveEvents, string ViewStart, string ViewEnd)
    {
        MPLayoutService wr = new MPLayoutService();
        wr.MPLayout_SetInActiveDays(AgentId, InActiveEvents, ViewStart, ViewEnd, ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void MPLayout_GetInActiveDays(HttpContext context, string AgentId, string ViewStart, string ViewEnd)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetInActiveDays?AgentId=" + AgentId + "&ViewStart=" + ViewStart + "&ViewEnd=" + ViewEnd + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_RoutesSaveSettings(HttpContext context, string NumberOfWeeks, string WorkDays, string StartDate, string StartHour, string EndHour, string InActiveDaysTypeList)
    {

        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_RoutesSaveSettings(NumberOfWeeks, WorkDays, StartDate, StartHour, EndHour, InActiveDaysTypeList, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    private void MPLayout_RoutesGetSettings(HttpContext context)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(GetJson(wr.MPLayout_RoutesGetSettings(ConStrings.DicAllConStrings[SessionProjectName]))));
    }
    private void MPLayout_RoutesGetInActiveDaysType(HttpContext context)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(GetJson(wr.MPLayout_RoutesGetInActiveDaysType(ConStrings.DicAllConStrings[SessionProjectName]))));
    }
    private void MPLayout_AddCustToDistribution(HttpContext context, string Cust_Key, string lines)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_AddCustToDistribution(Cust_Key, lines, ConStrings.DicAllConStrings[SessionProjectName]));

    }
    private void MPLayout_GetCustToDistribution(HttpContext context, string Cust_Key)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(GetJson(wr.MPLayout_GetCustToDistribution(Cust_Key, ConStrings.DicAllConStrings[SessionProjectName]))));
    }
    private void MPLayout_SetDistributionLine(HttpContext context, string Op, string DistributionLineID, string DistributionLineDescription)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetDistributionLine(Op, DistributionLineID, DistributionLineDescription, ConStrings.DicAllConStrings[SessionProjectName]));

    }
    private void MPLayout_GetDistributionLine(HttpContext context)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(GetJson(wr.MPLayout_GetDistributionLine(ConStrings.DicAllConStrings[SessionProjectName]))));
    }
    private void MPLayout_AddLineToAgent(HttpContext context, string AgentId, string DistributionLineDescription, string Date, string daysInterval)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_AddLineToAgent(AgentId, DistributionLineDescription, Date, daysInterval, ConStrings.DicAllConStrings[SessionProjectName]));

    }
    private void MPLayout_GetLineToAgentEvents(HttpContext context, string ViewStart, string ViewEnd, string AgentId)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPLayout_GetLineToAgentEvents?ViewStart=" + ViewStart + "&ViewEnd=" + ViewEnd + "&AgentId=" + AgentId + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("&nbsp;", " "));
    }
    private void MPLayout_delLineToAgentEvent(HttpContext context, string AgentId, string DistributionLineDescription, string Date)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_delLineToAgentEvent(AgentId, DistributionLineDescription, Date, ConStrings.DicAllConStrings[SessionProjectName]));

    }
    private void GetDataForMap(HttpContext context, string Points, string orgAddress, string Lang = "")
    {
        string Address = "";
        string DistanceMsgs = "";
        string responseFromServer = "";
        if (Lang == "")
            Lang = HttpContext.Current.Session["SessionLanguage"].ToString();
        if (Points != null)
        {
            try
            {
                string url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + Points + "&key=AIzaSyDIF59HFtAqfruZHi-VAmlGBn1Ga3vWndM&language=" + Lang;
                WebRequest request = WebRequest.Create(url);

                request.Credentials = CredentialCache.DefaultCredentials;
                // Get the response.
                WebResponse response = request.GetResponse();
                // Get the stream containing content returned by the server.
                Stream dataStream = response.GetResponseStream();
                // Open the stream using a StreamReader for easy access.
                StreamReader reader = new StreamReader(dataStream);
                // Read the content.
                responseFromServer = reader.ReadToEnd();
                // Display the content.

                if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
                {
                    //AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                }
                else
                {
                    JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                    reader.Close();
                    response.Close();

                    if (responseFromServer.IndexOf("ZERO_RESULTS") == -1 && data["status"].ToString() == "\"OVER_QUERY_LIMIT\"")
                    {
                        //AddRowToLog("google answer: OVER_QUERY_LIMIT; " + data["error_message"].ToString());
                        //AddRowToLog("Stoping the program...");
                        //break;
                        return;
                    }

                    if (data["status"].ToString().IndexOf("ZERO_RESULTS") == -1 && responseFromServer.IndexOf("ZERO_RESULTS") == -1)
                    {
                        Address = data["results"].First["address_components"][1]["long_name"].ToString().Replace('"', ' ') + " " + data["results"].First["address_components"][0]["long_name"].ToString().Replace('"', ' ') + ", " + data["results"].First["address_components"][2]["long_name"].ToString().Replace('"', ' ');
                        DistanceMsgs += Points + ",";
                    }
                    else
                    {

                    }
                }


            }
            catch (Exception ex)
            {
                //AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
            }
        }

        if (orgAddress != null)
        {
            try
            {
                string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDIF59HFtAqfruZHi-VAmlGBn1Ga3vWndM&address=" + orgAddress + "&sensor=false";
                WebRequest request = WebRequest.Create(url);

                request.Credentials = CredentialCache.DefaultCredentials;
                // Get the response.
                WebResponse response = request.GetResponse();
                // Get the stream containing content returned by the server.
                Stream dataStream = response.GetResponseStream();
                // Open the stream using a StreamReader for easy access.
                StreamReader reader = new StreamReader(dataStream);
                // Read the content.
                responseFromServer = reader.ReadToEnd();
                // Display the content.

                if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
                {
                    //AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                }
                else
                {
                    JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                    reader.Close();
                    response.Close();

                    if (responseFromServer.IndexOf("ZERO_RESULTS") == -1 && data["status"].ToString() == "\"OVER_QUERY_LIMIT\"")
                    {
                        //AddRowToLog("google answer: OVER_QUERY_LIMIT; " + data["error_message"].ToString());
                        //AddRowToLog("Stoping the program...");
                        //break;
                        return;
                    }

                    if (data["status"].ToString().IndexOf("ZERO_RESULTS") == -1 && responseFromServer.IndexOf("ZERO_RESULTS") == -1)
                    {
                        DistanceMsgs += data["results"].Last["geometry"]["location"]["lat"].ToString() + "," + data["results"].Last["geometry"]["location"]["lng"].ToString();
                    }
                    else
                    {

                    }
                }


            }
            catch (Exception ex)
            {
                //AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
            }
        }

        ResponseJSON(context, HttpContext.Current.Server.UrlDecode((Address).Replace("  ", " ") + "^" + DistanceMsgs));
    }
    private void MPLayout_SaveRoutesSettings(HttpContext context, string ParameterId, string ParameterValue, string IsDate)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SaveRoutesSettings(ParameterId, ParameterValue, IsDate, ConStrings.DicAllConStrings[SessionProjectName]));

    }
    private void MPLayout_SaveInActiveDaysType(HttpContext context, string InActiveDaysTypes)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SaveInActiveDaysType(InActiveDaysTypes, ConStrings.DicAllConStrings[SessionProjectName]));

    }
    private void GetGalleryData(HttpContext context, string id, string AgentID, string Cust_Key)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_GetGalleryData(id, AgentID, Cust_Key, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    public void MPLayout_SetDocManagement(HttpContext context, string DocManagementID, string FileName, string FileDesc, string Objects,
       string ObjectsTypeID, string UserID, string IsToDelete)
    {
        MPLayoutService wr = new MPLayoutService();

        ResponseJSON(context, wr.MPLayout_SetDocManagement(DocManagementID, FileName, FileDesc, Objects, ObjectsTypeID, UserID, IsToDelete, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    private void GetDoc(HttpContext context, string FileSrc)
    {
        FileSrc = FileSrc.Replace("~", "\\");
        //ResponsBytes(context, File.ReadAllBytes(FileSrc), FileSrc.Substring(FileSrc.ToString().IndexOf(".") + 1, FileSrc.Length - (FileSrc.ToString().IndexOf(".") + 1)));

        try
        {
            string Pre = FileSrc.Substring(FileSrc.ToString().IndexOf(".") + 1, FileSrc.Length - (FileSrc.ToString().IndexOf(".") + 1));

            byte[] file = File.ReadAllBytes(FileSrc);
            //return new MemoryStream((byte[])File.ReadAllBytes(FileSrc));
            context.Response.Clear();
            context.Response.ContentType = "application/pdf";
            context.Response.AddHeader("content-disposition", "attachment;    filename=file." + Pre);
            context.Response.AddHeader("File-Name", "file." + Pre);
            context.Response.AddHeader("content-length", file.Length.ToString());
            context.Response.BinaryWrite(File.ReadAllBytes(FileSrc));
            //context.Response.Flush();
            //context.Response.End();

        }
        catch
        {
            //return null;
        }
    }

    private void DriversGPS_GetData(HttpContext contex, string strDate, string AgentID, string isFirst)
    {
        string ScriptScr = "";
        string ScriptScr2 = "";
        MPLayoutService WR = new MPLayoutService();
        string Road1 = "";

        string Titles = "";
        string WinMsgs = "";
        string DistanceMsgs = "";
        string latlon1 = "";
        latlon1 = "32.2777255,34.8614782";

        ScriptScr2 = " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";

        ScriptScr = ScriptScr2 + "mapOptions = {zoom: 10,center: myLatlng0};map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";

        string[] arrDate = strDate.Split('/');
        DataTable dtPoints = WR.MPLayout_GetDriverGPSLocation(AgentID, DateTime.Now.Date.ToString("yyyy/MM/dd"), ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtPoints != null && dtPoints.Rows.Count > 0)
        {
            ScriptScr = "";
            string ScriptScrDT = "var strDT = '";
            string ScriptScrPoints = "var pointsStr = '";
            for (int i = 0; i < dtPoints.Rows.Count; i++)
            {
                ScriptScrDT += dtPoints.Rows[i]["UpdateDate"].ToString() + ";";
                ScriptScrPoints += dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + "," + dtPoints.Rows[i]["AgentCode"].ToString() + ";";
                if (isFirst == "true")
                {
                    ScriptScr += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + ");";
                    Titles += "לקוח: " + dtPoints.Rows[i]["AgentCode"].ToString() + "\n" + "שם: " + dtPoints.Rows[i]["Name"].ToString() + "\n" + ";";

                    DistanceMsgs += dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + "^" + "g;";

                    WinMsgs += "לקוח: " + dtPoints.Rows[i]["AgentCode"].ToString() + "<br/>" + "שם: " + dtPoints.Rows[i]["Name"].ToString() + "g;";
                }
            }
            ScriptScrPoints += "';";
            ScriptScrDT += "';";

            ScriptScr += ScriptScrPoints;
            ScriptScr += ScriptScrDT;
            if (dtPoints.Rows.Count > 0)
                Road1 = dtPoints.Rows[0]["Lat"].ToString() + "," + dtPoints.Rows[0]["Lon"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lat"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lon"].ToString();

            if (isFirst == "true")
            {
                if (dtPoints.Rows.Count == 0)
                {
                    latlon1 = "32.2777255,34.8614782";
                    ScriptScr += " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
                }
            }
            if (isFirst == "true")
            {
                ScriptScr += "var image = '../../img/Map-Pointer3.png';";
                ScriptScr += "var mapOptions = {zoom: 8,center: myLatlng0};map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";
            }

            if (isFirst == "true")
            {
                for (int i = 0; i < dtPoints.Rows.Count; i++)
                {

                    ScriptScr += " var marker" + dtPoints.Rows[i]["AgentCode"].ToString() + " = new google.maps.Marker( " +
                               "{ " +
                                "   position: myLatlng" + i.ToString() + ", " +
                                "   map: map, " +
                                "   icon: image, " +
                                "   title: 'gg' " +
                               "}); ";

                    ScriptScr += "gMarkers.push(marker" + dtPoints.Rows[i]["AgentCode"].ToString() + ");";
                }
            }
        }
        //ScriptScr += "setTimeout(\"google.maps.event.trigger(map, 'resize');\",100);";
        ResponseJSON(contex, ScriptScr);
    }
    private void OpenDoc(HttpContext contex, string Doc)
    {
        ResponsBytes(contex, File.ReadAllBytes(Doc.Replace("~", "\\")), Doc.Split('.')[1]);
    }
    private void MPLayout_SeUserData(HttpContext context, string UserID, string UserName, string Name, string Password, string UserCode, string UserRoleID, string CountryID, string DistributionCenterID, string ManagerUserID,
        string ProfileComponentsID, string IsToDelete, string prStr)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SeUserData(UserID, UserName, Name, Password,
            UserCode, UserRoleID, CountryID, DistributionCenterID, ManagerUserID, ProfileComponentsID,
            SessionUserID, IsToDelete, prStr, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    private void MPLayout_SetDriverToUser(HttpContext context, string SelectedUserID, string DriverID, string DriverTypeID, string SessionUserID, string IsToDelete)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetDriverToUser(SelectedUserID, DriverID, DriverTypeID, SessionUserID, IsToDelete, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    private void MPLayout_SetTask(HttpContext context, string TaskID, string AgentId, string CustomerCode, string Address, string City, string dateFrom, string dateTo, string TaskTypeID, string Task, string IsToDelete)
    {
        MPLayoutService wr = new MPLayoutService();
        ResponseJSON(context, wr.MPLayout_SetTask(TaskID, AgentId, CustomerCode, Address, City, dateFrom, dateTo, TaskTypeID, Task,
        SessionUserID, IsToDelete, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    private void GetAndSetTaskCords(HttpContext context, string TaskID, string Address, string City, string CountryName, bool IsProxy)
    {
        MPLayoutService wr = new MPLayoutService();
        //ResponseJSON(context, wr.GetAndSetTaskCords(TaskID,  Address, City, CountryName, IsProxy, ConStrings.DicAllConStrings[SessionProjectName]));
        wr.GetAndSetTaskCords(TaskID, Address, City, CountryName, IsProxy, ConStrings.DicAllConStrings[SessionProjectName]);
    }


}

