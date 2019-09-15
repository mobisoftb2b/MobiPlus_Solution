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
                case "GetUserSumVisit":
                    GetUserSumVisit(context, context.Request["User"].ToString(), context.Request["Date"].ToString(), context.Request["Filter"].ToString());
                    break;
                
            }
        }
        catch (Exception ex)
        {
            //MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString(), SessionUserID, SessionUserPromt);
            context.Response.Write(ex.Message);  
        }
    }
    private void ResponseJSON(HttpContext Context, string strjson)
    {
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strjson);
    }

    private void GetUserSumVisit(HttpContext context, string User, string Date, string Filter)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiPlusServices/GeneralService.asmx/GetUserSumVisit?User=" + User + "&Date=" + Date + "&Filter=" + Filter +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
   
}


