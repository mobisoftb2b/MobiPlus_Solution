using MobiPlusTools;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Net.Security;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for MasterPageBaseCls
/// </summary>
public partial class MasterPageBaseCls : System.Web.UI.MasterPage
{
private static string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();
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
	public MasterPageBaseCls()
	{		
	}
    public string StrSrc(string key)
    {
        string url = Request.Url.ToString().ToLower().Replace("http://" + HttpContext.Current.Request.Url.Host + (HttpContext.Current.Request.Url.Port != 80 ? ":" + HttpContext.Current.Request.Url.Port : "") + "/mobipluslayout/", "");
        if (url.IndexOf('?') > -1)
            url = url.Substring(0, url.IndexOf('?'));
        return LayoutStrSrc(key, url, SessionLanguage, ConStrings.DicAllConStrings[SessionProjectName]);
    }

    public string LayoutStrSrc(string key, string url, string Language, string ConString)
    {
        try
        {
            DataTable dt = (DataTable)System.Web.HttpContext.Current.Cache["LayoutTextSources"];
            if (dt != null)
            {
                DataView dv = dt.DefaultView;
                url = url.Substring(0, url.IndexOf("?") > -1 ? url.IndexOf("?") : url.Length);
                dv.RowFilter = "url = '" + url + "' and KeyWord = '" + key + "'";
                if (dv.ToTable().Rows.Count > 0)
                {
                    switch (Language)
                    {
                        case "He":
                            return dv.ToTable().Rows[0]["LocalText"].ToString();

                        case "En":
                            return dv.ToTable().Rows[0]["EnglishText"].ToString();

                    }
                }
            }
            else
            {
                var result = new DataTable("LayoutTextSources");
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    try
                    {
                        connection.Open();
                        SqlCommand sqlComm = new SqlCommand("SELECT * FROM  LayoutTextSources", connection);

                        using (var reader = sqlComm.ExecuteReader())
                        {
                            result.Load(reader);
                        }
                        DataView dv = result.DefaultView;
                        url = url.Substring(0, url.IndexOf("?") > -1 ? url.IndexOf("?") : url.Length);
                        dv.RowFilter = "url = '" + url + "' and KeyWord = '" + key + "'";
                        if (dv.ToTable().Rows.Count > 0)
                        {
                            switch (Language)
                            {
                                case "He":
                                    return dv.ToTable().Rows[0]["LocalText"].ToString();

                                case "En":
                                    return dv.ToTable().Rows[0]["EnglishText"].ToString();

                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Tools.HandleError(ex, LogDir);
                    }
                    finally
                    {
                        connection.Close();
                    }

                }

                // put in the cache object
                HttpContext.Current.Cache.Insert("LayoutTextSources", result);

            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return "";
    }
}