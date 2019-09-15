using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data;
using System.Web.Script.Serialization;
using System.Text;


using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.Caching;
using System.IO;
using System.IO.Compression;
using Ionic.Zip;
using System.Diagnostics;
using CacheHandler;
using System.Drawing;
using MobiPlusTools;
using Newtonsoft.Json;
using System.Runtime.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class GeneralService : System.Web.Services.WebService {
    private string LogDir = "";

    public GeneralService () {
        LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();
    }
    public string GetJson(DataTable dt)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows =
          new List<Dictionary<string, object>>();
        Dictionary<string, object> row = null;

        try
        {
            serializer.MaxJsonLength = Int32.MaxValue;

            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    if (col.DataType == typeof(String))
                        row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("'", "").Replace("\"", "''")));
                    else
                        row.Add(Server.UrlEncode(col.ColumnName.Trim()), dr[col]);
                }
                rows.Add(row);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return serializer.Serialize(rows);
    }
    private void ResponseJSON(string strjson)
    {
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
        Context.Response.AddHeader("content-length", strjson.Length.ToString());
        Context.Response.Flush();
        Context.Response.Write(strjson);
    }

    [WebMethod]
    public DataTable GetUserMap(string User, string Date, string Ezor, string Maslol, string ConString)
    {
        return DAL.GeneralDAL.GetUserMap(User, Date, Ezor, Maslol, ConString);
    }
    [WebMethod]
    public DataTable GetUserMapAllPoints(string User, string Date, string Ezor, string Maslol, string ConString)
    {
        return DAL.GeneralDAL.GetUserMapAllPoints(User, Date, Ezor, Maslol, ConString);
    }
    [WebMethod]
    public void GetUserSumVisit(string User, string Date, string Filter, string ConString)
    {
        ResponseJSON(GetJson(DAL.GeneralDAL.GetUserSumVisit(User, Date, Filter, ConString))); 
    }
}
