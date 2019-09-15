<%@ WebHandler Language="C#" Class="MainHandler" %>

using System;
using System.Web;
public class MainHandler : PageBaseCls
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
            context.Response.ContentType = "application/json";

            string method = context.Request.QueryString["MethodName"].ToString();
            switch (method)
            {
                case "sendDetails":
                    sendDetails(context, context.Request.QueryString["Name"].ToString(), context.Request.QueryString["Mail"].ToString(), context.Request.QueryString["Pone"].ToString()
                       , context.Request.QueryString["Comp"].ToString());
                    break;
            }
        }
        catch (Exception ex)
        {
            //MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString(), SessionUserID, SessionUserPromt);
            //context.Response.Write(ex.Message);
        }
    }
    private void ResponseJSON(HttpContext Context, string strjson)
    {
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strjson);
    }
    private void sendDetails(HttpContext context, string Name, string Mail, string Pone, string Comp)
    {
        string To="golannn@gmail.com";
        string MSG=" "+Name+" מעוניין לקבל הדגמת מערכת <br/>שם: "+Name+"<br/>מייל: "+Mail+"<br/>טלפון: "+Pone+"<br/>חברה: "+Comp;

        //Tools.SendMail(To,MSG,null,null);

    }
}