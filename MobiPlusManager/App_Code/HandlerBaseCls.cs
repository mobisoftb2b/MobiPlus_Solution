using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

/// <summary>
/// Summary description for HandlerBaseCls
/// </summary>
public class HandlerBaseCls : IHttpHandler, IRequiresSessionState
{
    #region properties

    public string SessionLanguage
    {
        get
        {
            if (HttpContext.Current.Session["SessionLanguage"] == null)
                HttpContext.Current.Session["SessionLanguage"] = "Hebrew";
            return (string)HttpContext.Current.Session["SessionLanguage"];
        }
        set
        {
            HttpContext.Current.Session["SessionLanguage"] = value;
        }
    }
    public string SessionUserID
    {
        get
        {
            if (HttpContext.Current.Session["UserID"] == null)
                HttpContext.Current.Session["UserID"] = "0";
            return HttpContext.Current.Session["UserID"].ToString();
        }
        set
        {
            HttpContext.Current.Session["UserID"] = value;
        }
    }
    public string SessionUserPromt
    {
        get
        {
            if (HttpContext.Current.Session["SessionUserPromt"] == null)
                HttpContext.Current.Session["SessionUserPromt"] = "";
            return HttpContext.Current.Session["SessionUserPromt"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionUserPromt"] = value;
        }
    }
    #endregion

    #region methods
    public string StrSrc(string key)
    {
        string url = HttpContext.Current.Request.Url.ToString().ToLower().Replace("http://" + HttpContext.Current.Request.Url.Host + (HttpContext.Current.Request.Url.Port !=80 ? ":" + HttpContext.Current.Request.Url.Port.ToString() : "") + "/mobiplusweb/", "");
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        return wr.StrSrc(key, url, SessionLanguage);
    }
    public HandlerBaseCls()
	{
	}

    public virtual void ProcessRequest(HttpContext context)
    {
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    #endregion
}