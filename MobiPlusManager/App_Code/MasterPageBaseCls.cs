using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for MasterPageBaseCls
/// </summary>
public partial class MasterPageBaseCls : System.Web.UI.MasterPage
{
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
	public MasterPageBaseCls()
	{		
	}
    public string StrSrc(string key)
    {
        string url = "MainMasterPage.master";
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        return wr.StrSrc(key, url, SessionLanguage);
    }
}