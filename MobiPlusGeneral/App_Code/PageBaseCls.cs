using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PageBaseCls : System.Web.UI.Page
{
    public string ProfileID
    {
        get
        {
            if (HttpContext.Current.Session["ProfileID"] == null)
                HttpContext.Current.Session["ProfileID"] = "2";
            return (string)HttpContext.Current.Session["ProfileID"];
        }
        set
        {
            HttpContext.Current.Session["ProfileID"] = value;
        }
    }

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
            if (Session["UserID"] == null)
                Session["UserID"] = "0";
            return Session["UserID"].ToString();
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
            if (Session["SessionUserPromt"] == null)
                Session["SessionUserPromt"] = "";
            return Session["SessionUserPromt"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionUserPromt"] = value;
        }
    }
    public string SessionGroupID
    {
        get
        {
            if (HttpContext.Current.Session["SessionGroupID"] == null)
                HttpContext.Current.Session["SessionGroupID"] = "0";
            return HttpContext.Current.Session["SessionGroupID"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionGroupID"] = value;
        }
    }
    public string SessionProjectName
    {
        get
        {
            if (HttpContext.Current.Session["SessionProjectName"] == null)
                HttpContext.Current.Session["SessionProjectName"] = "Dubek";
            return HttpContext.Current.Session["SessionProjectName"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionProjectName"] = value;
        }
    }
    public string SessionVersionID
    {
        get
        {
            if (HttpContext.Current.Session["SessionVersionID"] == null)
                HttpContext.Current.Session["SessionVersionID"] = "0";
            return HttpContext.Current.Session["SessionVersionID"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionVersionID"] = value;
        }
    }
    //public string StrSrc(string key)
    //{
    //    string url = Request.Url.ToString().ToLower().Replace("http://" + HttpContext.Current.Request.Url.Host + (HttpContext.Current.Request.Url.Port != 80 ? ":" + HttpContext.Current.Request.Url.Port : "") + "/mobiplusweb/", "");
    //    MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
    //    return wr.StrSrc(key, url, SessionLanguage);
    //}
}