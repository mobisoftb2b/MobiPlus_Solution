using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;

/// <summary>
/// Summary description for HandlerBaseCls
/// </summary>
public class HandlerBaseCls : IHttpHandler, IRequiresSessionState
{
    #region properties
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
                HttpContext.Current.Session["SessionProjectName"] = "Strauss";
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
    public DataTable SessionGridDT
    {
        get
        {
            if (HttpContext.Current.Session["SessionGridDT"] == null)
                HttpContext.Current.Session["SessionGridDT"] = new DataTable();
            return ((DataTable)HttpContext.Current.Session["SessionGridDT"]);
        }
        set
        {
            HttpContext.Current.Session["SessionGridDT"] = value;
        }
    }
    public string CountryName
    {
        get
        {
            if (HttpContext.Current.Session["CountryName"] == null)
                HttpContext.Current.Session["CountryName"] = "Israel";
            return HttpContext.Current.Session["CountryName"].ToString();
        }
        set
        {
            HttpContext.Current.Session["CountryName"] = value;
        }
    }
    private static Dictionary<string, DataTable> sessionGridDictionary;
    public static Dictionary<string,DataTable> SessionGridDictionary
    {
        get
        {
            if (HttpContext.Current.Session["SessionGridDictionary"] == null)
                HttpContext.Current.Session["SessionGridDictionary"] = new Dictionary<string,DataTable>();
            return ((Dictionary<string,DataTable>)HttpContext.Current.Session["SessionGridDictionary"]);
        }
        set
        {
            HttpContext.Current.Session["SessionGridDictionary"] = value;
        }
    }
    #endregion

    #region methods
    //public string StrSrc(string key)
    //{
    //    string url = HttpContext.Current.Request.Url.ToString().ToLower().Replace("http://" + HttpContext.Current.Request.Url.Host + (HttpContext.Current.Request.Url.Port !=80 ? ":" + HttpContext.Current.Request.Url.Port.ToString() : "") + "/mobiplusweb/", "");
    //    MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
    //    return wr.StrSrc(key, url, SessionLanguage);
    //}
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