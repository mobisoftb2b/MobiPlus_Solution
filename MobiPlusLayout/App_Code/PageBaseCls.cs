using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class PageBaseCls : System.Web.UI.Page
{
    public static string ClientVersion = "0";
    public PageBaseCls()
    {
        if (ClientVersion == "0" && System.Configuration.ConfigurationManager.AppSettings["ClientVersion"] != null)
            ClientVersion = System.Configuration.ConfigurationManager.AppSettings["ClientVersion"].ToString();
    }
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
 public string LogDirectory {
        get
        {
            return System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();
}
    }

    public string SessionLanguage
    {
        get
        {
            if (HttpContext.Current.Session["SessionLanguage"] == null)
                HttpContext.Current.Session["SessionLanguage"] = "He";
            return (string)HttpContext.Current.Session["SessionLanguage"];
        }
        set
        {
            HttpContext.Current.Session["SessionLanguage"] = value;
        }
    }
    public string Lang
    {
        get
        {
            if (HttpContext.Current.Session["SessionLanguage"] == null)
                HttpContext.Current.Session["SessionLanguage"] = "He";
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
                HttpContext.Current.Session["SessionProjectName"] = "Dev";
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

    public string StrSrc(string key)
    {
        string url = Request.Url.ToString().Replace("http://" + HttpContext.Current.Request.Url.Host + (HttpContext.Current.Request.Url.Port != 80 ? ":" + HttpContext.Current.Request.Url.Port : "") + "/mobipluslayout/", "");
        url = Request.Url.ToString().Replace("http://" + HttpContext.Current.Request.Url.Host + (HttpContext.Current.Request.Url.Port != 80 ? ":" + HttpContext.Current.Request.Url.Port : "") + "/MobiPlusLayout/", "");
        if (url.IndexOf('?') > -1)
            url = url.Substring(0, url.IndexOf('?'));
        var wr = new MPLayoutService();
        return wr.LayoutStrSrc(key, url, SessionLanguage, ConStrings.DicAllConStrings[SessionProjectName]);
    }


    public string GetLocalString(string key)
    {
        string result = string.Empty;
        DataTable dt = (DataTable)System.Web.HttpContext.Current.Cache["LayoutTextSources"];
        if (dt == null)
        {
            using (var wr = new MPLayoutService())
            {
                 dt = wr.LayoutStrSrcTable();
                HttpContext.Current.Cache.Insert("LayoutTextSources", dt);
            }
        }

        var lang = SessionLanguage.Substring(0, 2).ToLower();
        try
        {
            switch (lang)
            {
                case "he":
                    result = dt.Rows.OfType<DataRow>().Where(a => a["KeyWord"].ToString() == key).Select(a => (string)a["LocalText"]).First();
                    break;
                case "en":
                    result = dt.Rows.OfType<DataRow>().Where(a => a["KeyWord"].ToString() == key).Select(a => (string)a["EnglishText"]).First();
                    break;
                case "gr":
                    result = dt.Rows.OfType<DataRow>().Where(a => a["KeyWord"].ToString() == key).Select(a => (string)a["GeorgianText"]).First();
                    break;
            }
        }
        catch (Exception)
        {
        }

        return result;
    }
    public string GetCustomCoord()
    {
        string result = string.Empty;
        switch (SessionLanguage.ToLower())
        {
            case "he":
                result = "32.2777255,34.8614782";
                break;
            case "en":
                result = "-29.287987, 23.504526";
                break;
            case "ge":
                result = "42.291823, 42.810279";
                break;
        }
        return result;
    }
    public string GetCustomCoord(int countryID)
    {
        string result = string.Empty;
        switch (countryID)
        {
            case 1000:
                result = "32.2777255,34.8614782";
                break;
            case 8000:
                result = "-29.287987, 23.504526";
                break;
            case 5000:
                result = "42.291823, 42.810279";
                break;
        }
        return result;
    }

    public string GetCountryIDByLanguage()
    {
        string result = string.Empty;
        switch (SessionLanguage.ToLower())
        {
            case "he":
                result = "1000";
                break;
            case "en":
                result = "8000";
                break;
            case "ge":
                result = "5000";
                break;
        }
        return result;
    }

    protected void SetCurrentCulutre(HtmlGenericControl link, string linkCodeName)
    {
        System.Globalization.CultureInfo _lang = new CultureInfo(linkCodeName);
        System.Threading.Thread.CurrentThread.CurrentCulture = _lang;
        System.Threading.Thread.CurrentThread.CurrentUICulture = _lang;
        if (linkCodeName == "he" || linkCodeName == "hebrew")
            link.Attributes.Add("href", "../../css/redmond/jquery-ui.css");
        else
            link.Attributes.Add("href", "../../css/redmond/jquery-ui.ltr.css");
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
}

