<%@ WebHandler Language="C#" Class="MainHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Runtime.Serialization;
using System.IO;
using System.Data;

public class MainHandler : HandlerBaseCls
{
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
            //SessionLanguage = "Hebrew";
            int SessionUserIDr = Convert.ToInt32(SessionUserID);
            context.Response.ContentType = "application/json";
            string strResponse = "";
            string method = context.Request.QueryString["MethodName"].ToString();
            switch (method)
            {
                case "UserLogin":
                    UserLogin(context, context.Request["UserName"].ToString(), context.Request["Password"].ToString());

                    break;
                case "SetManagerHeadData":
                    SetManagerHeadData(context, SessionUserID);
                    break;
                case "GetManagerGridData":
                    GetManagerGridData(context, SessionUserID, context.Request["RequestStatus"].ToString(), context.Request["Period"].ToString());
                    break;
                case "SetManagerGridData":
                    SetManagerGridData(context, context.Request["RequsetID"].ToString(), context.Request["Status"].ToString(), context.Request["ManagerComment"].ToString());
                    break;
                case "CreatePassword":
                    string Hash = hashCode(context.Request["String"].ToString()).ToString()+ "2"; //2 as web
                    
                   
                    
                    ResponseJSON(context, Hash);
                    break;
                case "CheckSession":
                    string res = "";
                    if (SessionUserID == "0")
                        res = "Redirect";
                    ResponseJSON(context, res);
                    break;
            }
        }
        catch (Exception ex)
        {
            MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString());
            context.Response.Write(ex.Message);
        }
    }

    private void ResponseJSON(HttpContext Context, string strjson)
    {
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
        Context.Response.AddHeader("content-length", strjson.Length.ToString());
        Context.Response.Flush();
        Context.Response.Write(strjson);
    }

    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    private void UserLogin(HttpContext Context, string UserName, string Password)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt = wr.ManagerLogin(UserName, Password);
        if (dt != null && dt.Rows.Count > 0)
        {
            SessionUserID = UserName;
            SessionUserPromt = UserName + " - " + dt.Rows[0]["EmployeeName"].ToString();
            SetManagerHeadData(Context, SessionUserID);

            ResponseJSON(Context, "[{\"Success\":\"true\"}]");
        }
        else
        {
            SessionUserID = "0";
            SessionUserPromt = "";

            ResponseJSON(Context, "[{\"Error\":\"true\"}]");
        }
                    
    }
    private void SetManagerHeadData(HttpContext Context, string ManagerID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        System.Data.DataTable dt = wr.GetManagerHeadData(ManagerID);
        if (dt != null && dt.Rows.Count > 0)
        {
            SessionUserID = ManagerID;
            SessionUserPromt = dt.Rows[0]["EmployeeId"].ToString() + " - " + dt.Rows[0]["EmployeeName"].ToString();
            //SessionUserPromt += "<br/>";
            //SessionUserPromt += dt.Rows[0]["AgentId"].ToString() + " - " + dt.Rows[0]["ManagerName"].ToString();
        }
    }
    private void GetManagerGridData(HttpContext context, string ManagerID, string RequestStatus, string Period)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + context.Request.Url.Host + ":" + context.Request.Url.Port.ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetManagerGridData?ManagerID=" + ManagerID + "&RequestStatus=" + RequestStatus + "&Period=" + Period);
        context.Response.Write(context.Server.UrlDecode(str));
    }
    private void SetManagerGridData(HttpContext context, string RequsetID, string Status, string ManagerComment)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        wr.SetManagerGridData(RequsetID, Status, ManagerComment);
    }
    private short hashCode(string str)
    {
        short hash = 0;
        if (hash == 0)
        {
            if (str.Length == 0)
            {
                return 0;
            }

            char[] chars = str.ToCharArray();

            for (int i = 0; i < str.Length; ++i)
            {
                hash = (short)(31 * hash + chars[i]);
            }
        }
        if (hash < 0)
            hash = (short)(hash * -1);
        return hash;
    }

}

