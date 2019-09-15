using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;
using DAL;
using MobiPlusTools;

[WebService(Namespace = "http://microsoft.com/webservices/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class GeneralService : WebService
{
    private readonly string LogDir = "";

    public GeneralService()
    {
        LogDir = ConfigurationManager.AppSettings["LogDirectory"];
    }

    public string GetJson(DataTable dt)
    {
        var serializer = new JavaScriptSerializer();
        var rows =
            new List<Dictionary<string, object>>();
        Dictionary<string, object> row = null;

        try
        {
            serializer.MaxJsonLength = int.MaxValue;

            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                    if (col.DataType == typeof(string))
                        row.Add(col.ColumnName.Trim(),
                            Server.UrlEncode(dr[col].ToString().Replace("'", "").Replace("\"", "''")));
                    else
                        row.Add(Server.UrlEncode(col.ColumnName.Trim()), dr[col]);
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
        return GeneralDAL.GetUserMap(User, Date, Ezor, Maslol, ConString);
    }

    [WebMethod]
    public DataTable GetUserMapAllPoints(string User, string Date, string Ezor, string Maslol, string ConString)
    {
        return GeneralDAL.GetUserMapAllPoints(User, Date, Ezor, Maslol, ConString);
    }

    [WebMethod]
    public void GetUserSumVisit(string User, string Date, string Filter, string ConString)
    {
        ResponseJSON(GetJson(GeneralDAL.GetUserSumVisit(User, Date, Filter, ConString)));
    }

    [WebMethod]
    public DataTable ETA_GetETAQData(string AgentID, string CustKey1, string CustKey2, string ConString)
    {
        return GeneralDAL.ETA_GetETAQData(AgentID, CustKey1, CustKey2, ConString);
    }

    [WebMethod]
    public DataTable GetLocationToSMS(string SMSID, string ConString)
    {
        return GeneralDAL.GetLocationToSMS(SMSID, ConString);
    }
}