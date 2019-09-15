using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CacheHandler;

/// <summary>
/// Summary description for ServiceBaseCls
/// </summary>
public class ServiceBaseCls : System.Web.Services.WebService
{
    #region properties
    //private static CacheObj cacheObj;
    //public static CacheObj CacheObj
    //{
    //    get
    //    {
    //        if (cacheObj == null)
    //            cacheObj = new CacheObj();
    //        return cacheObj;
    //    }
    //    set
    //    {
    //        cacheObj = value;
    //    }
    //}
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