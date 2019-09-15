using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for ServiceBaseCls
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class ServiceBaseCls : System.Web.Services.WebService
{

    #region properties
    
    public static CacheHandler.CacheObj cacheObj;// = new CacheObj();
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
    #endregion

    public ServiceBaseCls()
    {
        if (cacheObj == null)
            cacheObj = new CacheHandler.CacheObj();
    }
}
