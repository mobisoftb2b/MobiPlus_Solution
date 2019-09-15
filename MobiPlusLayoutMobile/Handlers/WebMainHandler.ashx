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
            SessionLanguage = "Hebrew";
            int SessionUserIDr = Convert.ToInt32(SessionUserID);
            context.Response.ContentType = "application/json";
            string strResponse = "";
            string method = context.Request.QueryString["MethodName"].ToString();
            switch (method)
            {
                case "GetCustomersForAgent":
                    GetCustomersForAgent(context, context.Request.QueryString["FromAgentID"].ToString(), context.Request.QueryString["RouteDate"].ToString());
                    break;
                case "DeleteTranCustomersForAgent":
                    DeleteTranCustomersForAgent(context, context.Request.QueryString["FromAgentID"].ToString(), context.Request.QueryString["StrCustmers"].ToString());
                    break;
                case "GetAllCustomersForDates":
                    GetAllCustomersForDates(context);
                    break;
                case "SetCustomersForAgent":
                    SetCustomersForAgent(context, context.Request.QueryString["FromAgentID"].ToString(), context.Request.QueryString["ToAgentID"].ToString(), context.Request.QueryString["StrCustmers"].ToString(), context.Request.QueryString["FromDate"].ToString(), context.Request.QueryString["ToDate"].ToString(), SessionUserID, context.Request.QueryString["RouteDate"].ToString());
                    break;
                case "SetNumerator":
                    SetNumerator(context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["NumeratorGroup"].ToString(), context.Request.QueryString["NumeratorValue"].ToString());
                    break;
                case "SetAllNumerators":
                    SetAllNumerators(context.Request.QueryString["Value"].ToString());
                    break;
                case "GetNumeratorsForAgent":
                    GetNumeratorsForAgent(context, context.Request.QueryString["AgentID"].ToString());
                    break;
                case "SetNumeratorToAllByAgent":
                    SetNumeratorToAllByAgent(context, context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["NumeratorValue"].ToString());
                    break;
                case "GridDataNew":
                    GridDataNew(context);
                    break;
                case "GetRGHBarData":
                    GetRGHBarData(context, context.Request.QueryString["GridParameters"].ToString(), context.Request.QueryString["GraphID"].ToString());
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
        Context.Response.Write(strjson);
    }

    public void GetJsonExm()
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        wr.RetJSON();
    }
    private void GetCustomersForAgent(HttpContext context, string FromAgentID, string RouteDate)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/MPLayoutService.asmx/GetCustomersForAgent?AgentID=" + FromAgentID +"&RouteDate=" + RouteDate + 
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void DeleteTranCustomersForAgent(HttpContext context, string FromAgentID, string StrCustmers)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, "res: " + wr.DeleteTranCustomersForAgent(FromAgentID, StrCustmers,
            ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void GetAllCustomersForDates(HttpContext context)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/MPLayoutService.asmx/GetAllCustomersForDates?" +
            "ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void SetCustomersForAgent(HttpContext context, string FromAgentID, string ToAgentID, string StrCustmers, string FromDate, string ToDate, string UserID, string RouteDate)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, "res: " + wr.SetCustomersForAgent(FromAgentID, ToAgentID, StrCustmers, FromDate, ToDate, UserID, RouteDate,
            ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    public void GetNumerators(HttpContext context)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/MPLayoutService.asmx/GetNumerators" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str).Replace("'", "\"").Replace("\"/", "\""));
    }
    public void SetNumerator(string AgentID, string NumeratorGroup, string NumeratorValue)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        wr.SetNumerator(AgentID, NumeratorGroup, NumeratorValue, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void SetAllNumerators(string Value)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        wr.SetAllNumerators(Value, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void GetNumeratorsForAgent(HttpContext context, string AgentID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/MPLayoutService.asmx/GetNumeratorsForAgent?AgentID=" + AgentID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void SetNumeratorToAllByAgent(HttpContext context, string AgentID, string NumeratorValue)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        ResponseJSON(context, "ret: " + wr.SetNumeratorToAllByAgent(AgentID, NumeratorValue, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    public void GridDataNew(HttpContext context)
    {
     //   WebClient client = new WebClient();
     //   string id = "";
     //   if (context.Request.QueryString["id"] != null)
     //       id = "&id=" + context.Request.QueryString["id"].ToString();
     ////mobiplus ws
     //   string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/MobiPlusWS.asmx/GridDataNew?GridName=" + context.Request.QueryString["GridName"].ToString() + "&GridParameters=" + context.Request.QueryString["GridParameters"].ToString() + id +
     //   "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
     //   ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void GetRGHBarData(HttpContext context, string GridParameters, string GraphID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/MobiPlusWS.asmx/GetRGHBarData?GridParameters=" + GridParameters + "&GraphID=" + GraphID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    
}


