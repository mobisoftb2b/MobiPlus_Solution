using MobiPlus.Models.AgentDailyTasks;
using MobiPlusTools;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for MPLayoutService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class MPLayoutService : System.Web.Services.WebService
{
    private string LogDir = "";
    private string StraussOnDB = "";
    public string SessionProjectName
    {
        get
        {
            if (System.Web.HttpContext.Current.Session["SessionProjectName"] == null)
                System.Web.HttpContext.Current.Session["SessionProjectName"] = "Dev";
            return System.Web.HttpContext.Current.Session["SessionProjectName"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionProjectName"] = value;
        }
    }
    public string GetConnectionString
    {
        get
        {
            return ConStrings.DicAllConStrings[SessionProjectName];
        }
    }

    public MPLayoutService()
    {

        try
        {
            LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();


        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }

        try
        {
            if (HttpContext.Current.Cache["LayoutTextSources"] == null)
            {
                // Create the cache dependency
                //SqlCacheDependency dep = new SqlCacheDependency("TextSources", "TextSources");
                string connectionString = GetConnectionString;
                SqlConnection myConnection = new SqlConnection(connectionString);
                SqlDataAdapter ad = new SqlDataAdapter("SELECT * FROM  LayoutTextSources", myConnection);
                DataSet ds = new DataSet();
                ad.Fill(ds);

                // put in the cache object
                HttpContext.Current.Cache.Insert("LayoutTextSources", ds.Tables[0]);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);            
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void RetJSON()
    {
        try
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("col1");
            dt.Columns.Add("col2");
            dt.Columns.Add("col3");

            DataRow dr = dt.NewRow();
            dr["col1"] = "1 String";
            dr["col2"] = "2 String";
            dr["col3"] = "3 String";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["col1"] = "4 String";
            dr["col2"] = "5 String";
            dr["col3"] = "6 String";
            dt.Rows.Add(dr);

            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    private string DataTableToJSONString(System.Data.DataTable dt)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();

        System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>> rows = new System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>>();
        System.Collections.Generic.Dictionary<string, object> row;
        foreach (System.Data.DataRow dr in dt.Rows)
        {
            row = new System.Collections.Generic.Dictionary<string, object>();
            foreach (System.Data.DataColumn col in dt.Columns)
            {
                row.Add(col.ColumnName, dr[col]);
            }
            rows.Add(row);
        }
        return serializer.Serialize(rows).ToString();
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string GetJson1(DataTable dt)
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
                        row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("\"", "''").Replace("/", "-").Replace("\\", "-").Replace("'", "")));
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

    public string GetJson(DataTable dt)
    {
        var rows = new List<Dictionary<string, object>>();
        var serializer = new JavaScriptSerializer();
        try
        {
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
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

    public string GetJsonForQueries(DataTable dt)
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
                        row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("'", "gty").Replace("\"", "''")));
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
    public string GetJson2(DataTable dt)
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
                        row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("'", "").Replace("\"", "''").Replace(",", "").Replace(".", "")));
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
    public string GetJsonForNumertors(DataTable dt)
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
    [ScriptMethod(UseHttpGet = true)]
    public void MPUserLogin(string UserName, string Password, string userIP, string ConString)
    {
        ResponseJSON(GetJson(DAL.LayoutDAL.MPUserLogin(UserName, Password, userIP, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetProfileData(string ProfileID, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetProfileData(ProfileID, VersionID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetFormTabs(string VersionID, string FormID, string ConString)
    {
        ResponseJSON(GetJson(DAL.LayoutDAL.MPLayout_GetFormTabs(VersionID, FormID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetFormTabsDT(string VersionID, string FormID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetFormTabs(VersionID, FormID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetTabUI(string TabID, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetTabUI(TabID, VersionID, ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetReportData(string ReportID, string VersionID, string ConString, string language)
    {
        return DAL.LayoutDAL.MPLayout_GetReportData(ReportID, VersionID, ConString, language);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetQueryData(string ReportID, string VersionID, string Params, string ConString)
    {
        ResponseJSON(GetJson(MPLayout_GetQueryDataDT(ReportID, VersionID, Params, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetQueryDataDT(string ReportID, string VersionID, string Params, string ConString)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetQueryData(ReportID, VersionID, ConString);
        dt.TableName = "dt";
        string spParams = string.Empty;
        DataTable dtData = new DataTable("dtData");

        if (dt != null && dt.Rows.Count > 0)
        {
            string[] arr = Params.Trim().Split(';');

            //======================================================================================================================
            var dict = Params.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries)
               .Select(part => part.Split('='))
               .ToDictionary(split => split[0], split => split[1]);

            try
            {
                foreach (var entry in dict)
                    if (entry.Key == "undefined")
                        dict.Remove("undefined");

            }
            catch (Exception)
            {
            }
            //======================================================================================================================

            if (dt.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {
                for (int i = 0; i < arr.Length; i++)
                {
                    string[] arrVals = arr[i].Split('=');
                    if (dt.Rows[0]["ReportQuery"].ToString().ToLower().IndexOf("@" + arrVals[0].ToLower()) > -1 && arrVals.Length > 1)
                        dt.Rows[0]["ReportQuery"] = dt.Rows[0]["ReportQuery"].ToString().ToLower().Replace("@" + arrVals[0].ToLower(), "'" + arrVals[1] + "'");

                }
                dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString().ToLower(), ConString);
            }
            else if (dt.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string NewParms = "";
                string[] arrParmsSP = dt.Rows[0]["Report_SP_Params"].ToString().Split(';');

                //======================================================================================================================
                var arrEx = dt.Rows[0]["Report_SP_Params"].ToString().Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries)
                                 .Select(part => part.Split('='))
                                 .ToDictionary(split => split[0].Replace("@", "").Replace(" ", ""), null);
                //======================================================================================================================

                try
                {

                    for (int y = 0; y < arrParmsSP.Length; y++)
                    {
                        for (int g = 0; g < arr.Length; g++)
                        {
                            if (arr[g].IndexOf("=") > -1 && arr[g].IndexOf("ID=") != 0 && arr[g].IndexOf("ID=") != 1 && arr[g] != "=")
                            {
                                string Key = arr[g].Split('=')[0].Replace("\"", "");
                                string Value = arr[g].Split('=')[1];
                                if ((arrParmsSP[y] == "@" + Key || arrParmsSP[y] == Key) && arrParmsSP[y] != "")
                                    NewParms += arrParmsSP[y] + ":" + Value.Split(',')[0] + ";";
                            }
                        }
                    }
                }
                catch (Exception)
                {

                }

                //======================================================================================================================
                var compared = dict.Where(x => arrEx.ContainsKey(x.Key)).ToDictionary(x => x.Key, x => x.Value);

                spParams = string.Join(";", compared.Select(x => x.Key + ":" + x.Value).ToArray());
                //======================================================================================================================

                dtData = DAL.LayoutDAL.RunSP(dt.Rows[0]["ReportQuery"].ToString(), spParams, ConString);
            }
        }
        return dtData;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetMenuItemsDT(string MenuID, string ConString)
    {
        DataTable dt = DAL.DAL.Layout_GetMenuItemsForGridWeb(MenuID, ConString);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["Img"] != DBNull.Value)
                dt.Rows[i]["ImgReal"] = Convert.ToBase64String((byte[])dt.Rows[i]["Img"]);
            dt.Rows[i]["Img"] = DBNull.Value;
        }

        return dt;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetImageByID(string ImgID, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetImageByID(ImgID, VersionID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetQueryDataForControl(string ReportID, string Params, string SessionUserID, string VersionID, string ConString)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetQueryData(ReportID, VersionID, ConString);
        DataTable dtData = new DataTable();

        if (dt != null && dt.Rows.Count > 0)
        {
            string[] arr = Params.Split(';');

            if (dt.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {
                dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString().Replace("@SessionUserID", SessionUserID).Replace("SessionUserID", SessionUserID), ConString);
            }
            else if (dt.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string[] arrParmsSP = dt.Rows[0]["Report_SP_Params"].ToString().Split(';');
                string NewParms = "";
                for (int y = 0; y < arrParmsSP.Length; y++)
                {
                    for (int g = 0; g < arr.Length; g++)
                    {
                        if (arr[g].IndexOf("=") > -1 && arr[g].IndexOf("ID=") != 0 && arr[g].IndexOf("ID=") != 1 && arr[g] != "=")
                        {
                            string Key = arr[g].Split('=')[0].Replace("\"", "");
                            string Value = arr[g].Split('=')[1];
                            if ((arrParmsSP[y] == "@" + Key || arrParmsSP[y] == Key) && arrParmsSP[y] != "")
                                NewParms += arrParmsSP[y] + ":" + Value.Split(',')[0] + ";";
                        }
                    }
                }
                dtData = DAL.LayoutDAL.RunSP(dt.Rows[0]["ReportQuery"].ToString(), NewParms.Replace("@", ""), ConString);
            }
        }

        /*if (dt.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {

                for (int i = 0; i < arr.Length; i++)
                {
                    string[] arrVals = arr[i].Split('=');
                    if (dt.Rows[0]["ReportQuery"].ToString().ToLower().IndexOf("@" + arrVals[0].ToLower()) > -1 && arrVals.Length > 1)
                        dt.Rows[0]["ReportQuery"] = dt.Rows[0]["ReportQuery"].ToString().ToLower().Replace("@" + arrVals[0].ToLower(), "'" + arrVals[1] + "'");

                }

                dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString().ToLower(), ConString);
            }
            else if (dt.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string[] arrParmsSP = dt.Rows[0]["Report_SP_Params"].ToString().Split(';');
                string NewParms = "";
                for (int y = 0; y < arrParmsSP.Length; y++)
                {
                    for (int g = 0; g < arr.Length; g++)
                    {
                        if (arr[g].IndexOf("=") > -1 && arr[g].IndexOf("ID=") != 0 && arr[g].IndexOf("ID=") != 1 && arr[g] != "=")
                        {
                            string Key = arr[g].Split('=')[0].Replace("\"", "");
                            string Value = arr[g].Split('=')[1];
                            if ((arrParmsSP[y] == "@" + Key || arrParmsSP[y] == Key) && arrParmsSP[y] != "")
                                NewParms += arrParmsSP[y] + ":" + Value.Split(',')[0] + ";";
                        }
                    }
                }
                dtData = DAL.LayoutDAL.RunSP(dt.Rows[0]["ReportQuery"].ToString(), NewParms.Replace("@", ""), ConString);
            }*/
        dtData.TableName = "dtData1";
        return dtData;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetFiltersData(string TabID, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetFiltersData(TabID, VersionID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetImageByName(string ImageName, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetImageByName(ImageName, VersionID, ConString);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetPieRep(string GraphID, string VersionID, string ConString, string arrParms)
    {
        string[] arrPasrmsAll = arrParms.Split(';');
        bool isEWcxc = false;
        try
        {
            DataTable dtG = MPLayout_GetReportData(GraphID, VersionID, ConString, null);
            if (dtG != null && dtG.Rows.Count > 0)
            {
                string Caption = dtG.Rows[0]["ReportCaption"].ToString();
                string id = "";
                string Query = "";
                if (HttpContext.Current.Request.QueryString["id"] != null)
                    id = HttpContext.Current.Request.QueryString["id"].ToString();
                int i = 0;
                DataTable dt = new DataTable("dt");
                Query = dtG.Rows[0]["ReportQuery"].ToString();//.Replace("@Date", Date).Replace("@AgentID", Agent);
                if (Query != null && Query.Length > 0)
                    Query = Query.Replace("delete ", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");



                if (dtG.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
                {
                    for (int g = 0; g < arrPasrmsAll.Length; g++)
                    {
                        if (arrPasrmsAll[g].IndexOf("=") > -1 && arrPasrmsAll[g].IndexOf("ID=") == -1)
                        {
                            string Key = "@" + arrPasrmsAll[g].Split('=')[0].Replace("\"", "");
                            string Value = arrPasrmsAll[g].Split('=')[1];

                            Query = Query.Replace(Key, Value);
                        }
                    }
                    dt = DAL.DAL.RunQuery(Query);
                }
                else if (dtG.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
                {
                    string[] arrParmsSP = dtG.Rows[0]["Report_SP_Params"].ToString().Split(';');
                    string NewParms = "";
                    for (int y = 0; y < arrParmsSP.Length; y++)
                    {
                        for (int g = 0; g < arrPasrmsAll.Length; g++)
                        {
                            if (arrPasrmsAll[g].IndexOf("=") > -1 && arrPasrmsAll[g].IndexOf("ID=") == -1)
                            {
                                string Key = arrPasrmsAll[g].Split('=')[0].Replace("\"", "");
                                string Value = arrPasrmsAll[g].Split('=')[1];
                                if (arrParmsSP[y].ToLower() == Key.ToLower())
                                    NewParms += arrParmsSP[y] + ":" + Value + ";";
                            }
                        }
                    }

                    dt = DAL.DAL.RunSP(Query, NewParms, ConString);
                }


                dt.Columns["value"].ColumnName = "value";
                dt.Columns["title"].ColumnName = "title";

                System.Web.Script.Serialization.JavaScriptSerializer serializer = new

               System.Web.Script.Serialization.JavaScriptSerializer();

                string strData = "Data = [";

                for (i = 0; i < dt.Rows.Count; i++)
                {
                    strData += dt.Rows[i]["value"].ToString() + ",";
                }

                if (strData.Length > 0 && dt.Rows.Count > 0)
                    strData = strData.Substring(0, strData.Length - 1);

                strData += "]; DataNames=[";

                for (i = 0; i < dt.Rows.Count; i++)
                {
                    strData += "\"" + dt.Rows[i]["title"].ToString() + "\",";
                }

                if (strData.Length > 0 && dt.Rows.Count > 0)
                    strData = strData.Substring(0, strData.Length - 1);

                strData += "];Caption=\"" + Caption + "\";";

                ResponseJSON(Context.Server.UrlEncode(strData));
                isEWcxc = true;
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        if (!isEWcxc)
            ResponseJSON(Context.Server.UrlEncode("[]"));
    }
    private static int ContColors = 0;
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetBarRep(string GraphID, string VersionID, string ConString, string arrParms)
    {
        string Caption = "";
        string Title = "";
        try
        {
            string[] arrPasrmsAll = arrParms.Split(';');
            DataTable dtG = MPLayout_GetReportData(GraphID, VersionID, ConString, null);
            if (dtG != null && dtG.Rows.Count > 0)
            {
                DataTable dtData = new DataTable("dtData");
                string Query = dtG.Rows[0]["ReportQuery"].ToString();
                Caption = "Caption = \"" + dtG.Rows[0]["ReportCaption"].ToString() + "\";";
                //if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                {

                    if (Query != null && Query.Length > 0 && (Query.ToLower().IndexOf("delete") > -1 || Query.ToLower().IndexOf("truncate") > -1 || Query.ToLower().IndexOf("create") > -1 || Query.ToLower().IndexOf("alter") > -1))
                        Query = Query.ToLower().Replace("delete", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                    if (dtG.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
                    {
                        for (int g = 0; g < arrPasrmsAll.Length; g++)
                        {
                            if (arrPasrmsAll[g].IndexOf("=") > -1 && arrPasrmsAll[g].IndexOf("ID=") == -1)
                            {
                                string Key = "@" + arrPasrmsAll[g].Split('=')[0].Replace("\"", "");
                                string Value = arrPasrmsAll[g].Split('=')[1];

                                Query = Query.Replace(Key, Value);
                            }
                        }
                        dtData = DAL.DAL.RunQuery(Query);
                    }
                    else if (dtG.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
                    {
                        string[] arrParmsSP = dtG.Rows[0]["Report_SP_Params"].ToString().Split(';');
                        string NewParms = "";
                        for (int y = 0; y < arrParmsSP.Length; y++)
                        {
                            for (int g = 0; g < arrPasrmsAll.Length; g++)
                            {
                                if (arrPasrmsAll[g].IndexOf("=") > -1 && arrPasrmsAll[g].IndexOf("ID=") == -1)
                                {
                                    string Key = arrPasrmsAll[g].Split('=')[0].Replace("\"", "");
                                    string Value = arrPasrmsAll[g].Split('=')[1];
                                    if (arrParmsSP[y].ToLower() == Key.ToLower())
                                        NewParms += arrParmsSP[y] + ":" + Value + ";";
                                }
                            }
                        }

                        dtData = DAL.DAL.RunSP(Query, NewParms, ConString);
                    }
                }
                bool isOne = false;
                DataTable dt = new DataTable();
                if (dtData != null)
                {
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        if (dt.Columns[dtData.Rows[j]["Title"].ToString()] == null)
                            dt.Columns.Add(dtData.Rows[j]["Title"].ToString());
                    }

                    dt.Columns.Add("title");
                    dt.Columns.Add("Value1");

                    try
                    {
                        if (dtData.Columns["Value2"].ToString() != "")
                            dt.Columns.Add("Value2");
                    }
                    catch (Exception ex)
                    {

                    }
                    DataRow dr = dt.NewRow();
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        dr[dtData.Rows[j]["Title"].ToString()] = dtData.Rows[j]["Value1"].ToString();
                    }
                    if (dtData.Rows.Count > 0)
                    {
                        dr["title"] = "\"" + dtData.Rows[0]["Value1Title"].ToString() + "\"";

                        dt.Rows.Add(dr);
                    }
                    dr = dt.NewRow();
                    try
                    {
                        for (int j = 0; j < dtData.Rows.Count; j++)
                        {
                            dr[dtData.Rows[j]["Title"].ToString()] = dtData.Rows[j]["Value2"].ToString();
                        }
                    }
                    catch (Exception ex)
                    {

                    }


                    try
                    {
                        if (dtData.Rows.Count > 0)
                        {
                            dr["title"] = "\"" + dtData.Rows[0]["Value2Title"].ToString() + "\"";


                        }
                    }
                    catch (Exception ex)
                    {
                        isOne = true;
                    }
                    dt.Rows.Add(dr);
                }


                System.Web.Script.Serialization.JavaScriptSerializer serializer = new

               System.Web.Script.Serialization.JavaScriptSerializer();

                string nData = "data = [";
                string nlabels = "labels = [";

                int i = 0;
                for (i = 0; i < dt.Columns.Count; i++)
                {
                    if (dt.Columns[i].ColumnName != "Value1" && dt.Columns[i].ColumnName != "Value2" && dt.Columns[i].ColumnName != "title" && dt.Columns[i].ColumnName != "fillColor" && dt.Columns[i].ColumnName != "strokeColor" && dt.Columns[i].ColumnName != "pointColor" && dt.Columns[i].ColumnName != "pointStrokeColor")
                    {
                        nlabels += "\"" + dt.Columns[i].ColumnName.Replace("\"", "") + "\", ";
                    }
                }
                i = 0;

                for (i = 0; i < dt.Rows.Count; i++)
                {

                    int j = 0;
                    for (j = 0; j < dt.Columns.Count; j++)
                    {
                        if (i + 1 <= dt.Rows.Count || isOne)
                        {
                            if (dt.Columns[j].ColumnName != "Value1" && dt.Columns[j].ColumnName != "Value2" && dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor")
                            {
                                try
                                {
                                    if (!isOne && dt.Rows[i][dt.Columns[j].ColumnName].ToString() != "" && dt.Rows[i + 1][dt.Columns[j].ColumnName].ToString() != "" && dtData.Rows[0]["Value2Title"].ToString() != "")
                                    {

                                        if (dtData.Rows[0]["Value2Title"].ToString() != "")
                                        {
                                            nData += "[" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                                            nData += dt.Rows[i + 1][dt.Columns[j].ColumnName].ToString() + "],";
                                        }

                                    }
                                    else if (isOne)
                                    {
                                        if (dt.Rows[i][dt.Columns[j].ColumnName].ToString() != "")
                                            nData += "[" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + "],";
                                    }
                                }
                                catch (Exception ex)
                                {
                                    if (dt.Rows[i][dt.Columns[j].ColumnName].ToString() != "")
                                        nData += "[" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + "],";
                                }
                            }
                            else if (dt.Columns[j].ColumnName == "title")
                            {
                                Title = "Title = [" + dt.Rows[i + 1][dt.Columns[j].ColumnName].ToString() + "," + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + "];";
                            }

                        }
                    }
                    i = i + 1;


                }
                if (nlabels[nlabels.Length - 2].ToString() == ",")
                    nlabels = nlabels.Substring(0, nlabels.Length - 2);
                nlabels += "];";

                if (nData[nData.Length - 1].ToString() == ",")
                    nData = nData.Substring(0, nData.Length - 1);
                nData += "];";

                double mScale = 0;
                for (int u = 0; u < dt.Rows.Count && u < 1; u++)
                {
                    for (int g = 0; g < dt.Columns.Count; g++)
                    {
                        try
                        {
                            if (dt.Rows[u][g].ToString() != "" && Convert.ToDouble(dt.Rows[u][g].ToString()) * 1.15 > mScale)
                                mScale += Convert.ToDouble(dt.Rows[u][g].ToString()) * 1.15;
                        }
                        catch (Exception ex)
                        {
                        }
                    }


                }

                string maxScale = "maxScale=10000;";
                //string Colors = " Colors = [\"Gradient(#8674BA:#4D3594:#4D3594:#4D3594:#4D3594)\", \"Gradient(#EF9643:#E76400:#E76400:#E76400:#E76400)\"];";
                string[] CuurentCVolor = new string[] { "#FF5050", "#4D3594", "#009200", "#5151FF", "#FB9EC6", "#FFFF4F", "#4C4C4C", "#F4B99C", "#ED8E5F", "#9570DE", "#D0D000", "#3939FF", "#F51D1D", "#BDBDFF", "#ED6D00" };

                string Colors = "";
                if (ContColors >= 13)
                    ContColors = 0;
                Colors = "Colors = [\"" + CuurentCVolor[ContColors++] + "\",\"" + CuurentCVolor[ContColors++] + "\"];";


                if (isOne)
                {
                    Colors = "Colors = [\"" + CuurentCVolor[ContColors++] + "\"];";
                }
                if (dt.Columns.Count > 0)
                {
                    maxScale = "maxScale=" + (mScale).ToString() + ";";
                }
                ResponseJSON(Context.Server.UrlEncode(nData + nlabels.Replace("'", "") + Caption + Title + maxScale + Colors));
            }

        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetMeterChart(string GraphID, string VersionID, string ConString, string arrParms)
    {
        string[] arrPasrmsAll = arrParms.Split(';');

        DataTable dtG = MPLayout_GetReportData(GraphID, VersionID, ConString, null);
        if (dtG != null && dtG.Rows.Count > 0)
        {
            string Caption = dtG.Rows[0]["ReportCaption"].ToString();
            string id = "";
            string Query = "";
            if (HttpContext.Current.Request.QueryString["id"] != null)
                id = HttpContext.Current.Request.QueryString["id"].ToString();
            int i = 0;
            DataTable dt = new DataTable("dt");
            Query = dtG.Rows[0]["ReportQuery"].ToString();//.Replace("@Date", Date).Replace("@AgentID", Agent);
            if (Query != null && Query.Length > 0)
                Query = Query.Replace("delete ", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");



            if (dtG.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {
                for (int g = 0; g < arrPasrmsAll.Length; g++)
                {
                    if (arrPasrmsAll[g].IndexOf("=") > -1 && arrPasrmsAll[g].IndexOf("ID=") == -1)
                    {
                        string Key = "@" + arrPasrmsAll[g].Split('=')[0].Replace("\"", "");
                        string Value = arrPasrmsAll[g].Split('=')[1];

                        Query = Query.Replace(Key, Value);
                    }
                }
                dt = DAL.DAL.RunQuery(Query);
            }
            else if (dtG.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string[] arrParmsSP = dtG.Rows[0]["Report_SP_Params"].ToString().Split(';');
                string NewParms = "";
                for (int y = 0; y < arrParmsSP.Length; y++)
                {
                    for (int g = 0; g < arrPasrmsAll.Length; g++)
                    {
                        if (arrPasrmsAll[g].IndexOf("=") > -1 && arrPasrmsAll[g].IndexOf("ID=") == -1)
                        {
                            string Key = arrPasrmsAll[g].Split('=')[0].Replace("\"", "");
                            string Value = arrPasrmsAll[g].Split('=')[1];
                            if (arrParmsSP[y].ToLower() == Key.ToLower())
                                NewParms += arrParmsSP[y] + ":" + Value + ";";
                        }
                    }
                }

                dt = DAL.DAL.RunSP(Query, NewParms, ConString);
            }
            //ResponseJSON(GetJson(dt));
            dt.TableName = "dt1";

            if (dt.Rows.Count > 0)
            {
                dt.Columns.Add("Caption");
                dt.Rows[0]["Caption"] = Caption;
            }
            return dt;
        }
        return null;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_MSG_GetAllMessages(string VersionID, string PopulationTypeID, string ConString)
    {
        ResponseJSON(GetJson(DAL.LayoutDAL.MPLayout_MSG_GetAllMessages(VersionID, PopulationTypeID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetPopulations(string PopulationTypeID, string ConString)
    {
        ResponseJSON(GetJsonForQueries(DAL.LayoutDAL.MPLayout_GetPopulations(PopulationTypeID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetPopulationsDT(string PopulationTypeID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetPopulations(PopulationTypeID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public string MPLayout_SetPopulationData(string PopulationID, string PopulationTypeID, string PopulationDescription, string PopulationQuery, string IsToDelete, string UserID, string ConString)
    {
        PopulationQuery = PopulationQuery.Replace("***", "+").Replace("&&&", "'");
        return DAL.LayoutDAL.MPLayout_SetPopulationData(PopulationID, PopulationTypeID, PopulationDescription, PopulationQuery, IsToDelete, UserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public string MPLayout_SetMSGData(string MessageID, string MessageText, string MessageFromDate, string MessageToDate, string IsToDelete, string UserID, string ConString,
       string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation)
    {
        return DAL.LayoutDAL.MPLayout_SetMSGData(MessageID, MessageText, MessageFromDate, MessageToDate, IsToDelete, UserID, ConString, ParentsPopulation, ItemsPopulation, UnCheckedPopulation);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_Tasks_GetAllTasks(string UserID, string ConString)
    {
        ResponseJSON(GetJson(DAL.LayoutDAL.MPLayout_Tasks_GetAllTasks(UserID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet MPLayout_Tasks_GetTaskDDLs(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_Tasks_GetTaskDDLs(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public string MPLayout_SetTaskData(string TaskID, string ClassificationID, string TopicID, string SubTopic, string Task, string PriorityID,
            string dtReport, string dtTaskEnd, string ConditionID, string TaskNotes, string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation, string IsToDelete, string UserID, string TaskStatusID
        , string dtStatus, string DateFrom, string DateTo, string AlarmDate, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SetTaskData(TaskID, ClassificationID, TopicID, SubTopic, Task, PriorityID,
            dtReport, dtTaskEnd, ConditionID, TaskNotes, ParentsPopulation, ItemsPopulation, UnCheckedPopulation, IsToDelete, UserID, TaskStatusID, dtStatus, DateFrom, DateTo, AlarmDate, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_Tasks_GetPopulationData(string PopulationID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_Tasks_GetPopulationData(PopulationID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet MPLayout_Tasks_GetTsakPopulation(string TaskID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_Tasks_GetTsakPopulation(TaskID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_Tasks_GetTsakPopulationJSON(string TaskID, string ConString)
    {
        DataSet ds = DAL.LayoutDAL.MPLayout_Tasks_GetTsakPopulation(TaskID, ConString);
        if (ds != null && ds.Tables.Count > 0)
            ResponseJSON(GetJson(ds.Tables[0]));
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_Tasks_GetTsakPopulationParentsJSON(string TaskID, string ConString)
    {
        DataSet ds = DAL.LayoutDAL.MPLayout_Tasks_GetTsakPopulation(TaskID, ConString);
        if (ds != null && ds.Tables.Count > 1)
            ResponseJSON(GetJson(ds.Tables[1]));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgents(string SessionUserID, string ConString)
    {
        return DAL.DAL.GetAgentsL(SessionUserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgentsL(string SessionUserID, string countryID, string distID, string ConString)
    {
        return DAL.DAL.GetAgentsL(SessionUserID, countryID, distID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgentsByCountry(string SessionUserID, string countryID, string distrID, string ConString)
    {
        return DAL.DAL.GetAgentsL(SessionUserID, countryID, distrID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void GetCustomersForAgent(string AgentID, string RouteDate, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.GetCustomersForAgent(AgentID, RouteDate, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool SetCustomersForAgent(string FromAgentID, string ToAgentID, string StrCustmers, string FromDate, string ToDate, string UserID, string RouteDate, string ConString)
    {
        return DAL.DAL.SetCustomersForAgent(FromAgentID, ToAgentID, StrCustmers, FromDate, ToDate, UserID, RouteDate, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void GetAllCustomersForDates(string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.GetAllCustomersForDates(ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool DeleteCustomersForAgent(string StrCustmers, string UserID, string ConString)
    {
        return DAL.DAL.DeleteCustomersForAgent(StrCustmers, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool DeleteTranCustomersForAgent(string FromAgentID, string StrCustmers, string ConString)
    {
        return DAL.DAL.DeleteTranCustomersForAgent(FromAgentID, StrCustmers, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetNumeratorsGroups(string ConString)
    {
        return DAL.DAL.GetNumeratorsGroups(ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void GetNumeratorsForAgent(string ConString, string AgentID)
    {
        DataTable dt = DAL.DAL.GetNumeratorsForAgent(ConString, AgentID);
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dt.Rows[i]["NumeratorValue"] = Convert.ToInt64(dt.Rows[i]["NumeratorValue"].ToString().Substring(AgentID.Length, dt.Rows[i]["NumeratorValue"].ToString().Length - AgentID.Length)).ToString();
            }
        }

        ResponseJSON(GetJson(dt));
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool SetNumeratorToAllByAgent(string AgentID, string NumeratorValue, string ConString)
    {
        return DAL.DAL.SetNumeratorToAllByAgent(AgentID, NumeratorValue, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool SetNumerator(string AgentID, string NumeratorGroup, string NumeratorValue, string UserID, string ConString)
    {
        return DAL.DAL.SetNumerator(AgentID, NumeratorGroup, NumeratorValue, UserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool SetAllNumerators(string Value, string UserID, string ConString)
    {
        return DAL.DAL.SetAllNumerators(Value, UserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgentsTreeOneLevel(string ParentID, string ConString)
    {
        return DAL.LayoutDAL.GetAgentsTreeOneLevel(ParentID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetCustomersTreeOneLevel(string ParentID, string ConString)
    {
        return DAL.LayoutDAL.GetCustomersTreeOneLevel(ParentID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetItemsTreeOneLevel(string ParentID, string ConString)
    {
        return DAL.LayoutDAL.GetItemsTreeOneLevel(ParentID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetCategoriesTreeOneLevel(string ParentID, string ConString)
    {
        return DAL.LayoutDAL.GetCategoriesTreeOneLevel(ParentID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetReportStyles(string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetReportStyles(VersionID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet GetSalesDDls(string AgentID, string Cust_Key, string FamilyId, string ItemID, string ConString)
    {
        return DAL.DAL.GetSalesDDls(AgentID, Cust_Key, FamilyId, ItemID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet GetGridDataNew(string GridName, string ConString)
    {
        return DAL.DAL.GetGridDataNew(GridName, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetRGHBarDataDT(string GraphID, string GridParameters, string ConString)
    {
        DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
        DataTable dtData = new DataTable("dtData");
        try
        {

            if (dtG != null && dtG.Rows.Count > 0)
            {

                string Query = "";
                if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                {
                    //if (AgentID != "0")
                    //   Agent = "AgentID";
                    //Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("@Date", iDate).Replace("@AgentID", Agent);
                    //if (Query != null && Query.Length > 0 && (Query.ToLower().IndexOf("delete") > -1 || Query.ToLower().IndexOf("truncate") > -1 || Query.ToLower().IndexOf("create") > -1 || Query.ToLower().IndexOf("alter") > -1))
                    //   Query = Query.ToLower().Replace("delete", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                    //dtData = DAL.DAL.RunQuery(Query);

                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "Stored procedure")
                {
                    dtData = DAL.DAL.RunSP(dtG.Rows[0]["GraphQuery"].ToString(), GridParameters, ConString);
                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "View")
                {
                    string Agent = " AgentID=AgentID";
                    //if (AgentID != "0")
                    //   Agent = " AgentID=" + AgentID;
                    Query = "Select * from " + dtG.Rows[0]["GraphQuery"].ToString();
                    //Query += " where Date=" + iDate + " and " + Agent;
                    dtData = DAL.DAL.RunQuery(Query);
                }

            }

        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dtData;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetReportDataByName(string ReportName, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetReportDataByName(ReportName, VersionID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetQueryDataByName(string ReportName, string VersionID, string Params, string ConString)
    {
        string str = GetJson(MPLayout_GetQueryDataByNameDT(ReportName, VersionID, Params, ConString));
        ResponseJSON(str);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetQueryDataByNameDT(string ReportName, string VersionID, string Params, string ConString)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetQueryDataByName(ReportName, VersionID, ConString);
        dt.TableName = "dt";
        DataTable dtData = new DataTable("dtData");

        if (dt != null && dt.Rows.Count > 0)
        {
            string[] arr = Params.Split(';');

            if (dt.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {

                for (int i = 0; i < arr.Length; i++)
                {
                    string[] arrVals = arr[i].Split('=');
                    if (dt.Rows[0]["ReportQuery"].ToString().ToLower().IndexOf("@" + arrVals[0].ToLower()) > -1 && arrVals.Length > 1)
                        dt.Rows[0]["ReportQuery"] = dt.Rows[0]["ReportQuery"].ToString().ToLower().Replace("@" + arrVals[0].ToLower(), "'" + arrVals[1] + "'");

                }

                dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString(), ConString);
            }
            else if (dt.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string[] arrParmsSP = dt.Rows[0]["Report_SP_Params"].ToString().Split(';');
                string NewParms = "";
                for (int y = 0; y < arrParmsSP.Length; y++)
                {
                    for (int g = 0; g < arr.Length; g++)
                    {
                        if (arr[g].IndexOf("=") > -1 && arr[g].IndexOf("ID=") == -1 && arr[g] != "=")
                        {
                            string Key = arr[g].Split('=')[0].Replace("\"", "");
                            string Value = arr[g].Split('=')[1];
                            if ((arrParmsSP[y] == "@" + Key || arrParmsSP[y] == Key) && arrParmsSP[y] != "")
                                NewParms += arrParmsSP[y] + ":" + Value + ";";
                        }
                    }
                }
                dtData = DAL.LayoutDAL.RunSP(dt.Rows[0]["ReportQuery"].ToString(), NewParms.Replace("@", ""), ConString);
            }
        }
        return dtData;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetQueryDataByName2(string Params, string ReportName, string VersionID, string ConString)
    {
        string str = GetJson(MPLayout_GetQueryDataByName2DT(ReportName, VersionID, Params, ConString));
        ResponseJSON(str);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetQueryDataByName2DT(string ReportName, string VersionID, string Params, string ConString)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetQueryDataByName(ReportName, VersionID, ConString);
        dt.TableName = "dt";
        DataTable dtData = new DataTable("dtData");

        if (dt != null && dt.Rows.Count > 0)
        {
            string[] arr = Params.Split(';');

            if (dt.Rows[0]["ReportDataSourceID"].ToString() == "1")//query
            {

                for (int i = 0; i < arr.Length; i++)
                {
                    string[] arrVals = arr[i].Split('=');
                    if (dt.Rows[0]["ReportQuery"].ToString().ToLower().IndexOf("@" + arrVals[0].ToLower()) > -1 && arrVals.Length > 1)
                        dt.Rows[0]["ReportQuery"] = dt.Rows[0]["ReportQuery"].ToString().ToLower().Replace("@" + arrVals[0].ToLower(), "'" + arrVals[1] + "'");

                }

                dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString(), ConString);
            }
            else if (dt.Rows[0]["ReportDataSourceID"].ToString() == "3")//sp
            {
                string[] arrParmsSP = dt.Rows[0]["Report_SP_Params"].ToString().Split(';');
                string NewParms = "";
                for (int y = 0; y < arrParmsSP.Length; y++)
                {
                    for (int g = 0; g < arr.Length; g++)
                    {
                        if (arr[g].IndexOf("=") > -1 && arr[g].IndexOf("ID=") == -1 && arr[g] != "=")
                        {
                            string Key = arr[g].Split('=')[0].Replace("\"", "");
                            string Value = arr[g].Split('=')[1];
                            if ((arrParmsSP[y] == "@" + Key || arrParmsSP[y] == Key) && arrParmsSP[y] != "")
                                NewParms += arrParmsSP[y] + ":" + Value + ";";
                        }
                    }
                }
                dtData = DAL.LayoutDAL.RunSP(dt.Rows[0]["ReportQuery"].ToString(), NewParms.Replace("@", ""), ConString);
            }
        }
        return dtData;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetAgentMap(string AgentID, string Date, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetAgentMap(AgentID, Date, VersionID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string SetGoalByDates(string ObjTypeID, string AgentId, string Cust_Key, string SubCode, string ItemId, string FromDate, string ToDate, string Goal, string GoalPercents, string isToSetChildrens, string MPUserID, string ConString)
    {
        return DAL.LayoutDAL.SetGoalByDates(ObjTypeID, AgentId, Cust_Key, SubCode, ItemId, FromDate, ToDate, Goal, GoalPercents, isToSetChildrens, MPUserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_MSG_GetMSGPopulationJSON(string MessageID, string ConString)
    {
        DataSet ds = DAL.LayoutDAL.MPLayout_MSG_GetMSGPopulation(MessageID, ConString);
        if (ds != null && ds.Tables.Count > 0)
            ResponseJSON(GetJson(ds.Tables[0]));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_MSG_GetMSGPopulationParentsJSON(string MessageID, string ConString)
    {
        DataSet ds = DAL.LayoutDAL.MPLayout_MSG_GetMSGPopulation(MessageID, ConString);
        if (ds != null && ds.Tables.Count > 1)
            ResponseJSON(GetJson(ds.Tables[1]));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void RunSP(string spName, string spParameters, string pass)
    {
        if (pass != "mtnsLayout")
        {
            return;
        }
        try
        {
            //spParameters exmpale = "UserID:1;WidgetID:1;";
            StringBuilder sb = new StringBuilder();
            DataTable dt = DAL.ClientDAL.RunSP(spName, spParameters);
            if (dt != null)
            {
                sb.Append("[");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb.Append("{");
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        sb.Append("\"" + dt.Columns[j].ColumnName + "\":\"" + HttpContext.Current.Server.UrlEncode(dt.Rows[i][dt.Columns[j].ColumnName].ToString()) + "\"");
                        if (j != dt.Columns.Count - 1)
                        {
                            sb.Append(",");
                        }
                    }
                    sb.Append("}");
                    if (i != dt.Rows.Count - 1)
                    {
                        sb.Append(",");
                    }
                }
                sb.Append("]");
            }

            ResponseJSON(sb.ToString());
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet RunSPForCtl(string spName, string spParameters, string pass)
    {
        if (pass != "mtnsLayout")
        {
            return new DataSet();
        }
        try
        {
            //spParameters exmpale = "UserID:1;WidgetID:1;";
            StringBuilder sb = new StringBuilder();
            DataSet ds = DAL.ClientDAL.RunSPForCtl(spName, spParameters);
            return ds;

        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return new DataSet();
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetParameters(string ConString)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetParameters(ConString);
        if (dt != null)
            ResponseJSON(GetJson(dt));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetParameters(string ConString, string PrmVersion, string PrmId, string Value, string RealID, string IsToDelete)
    {
        return DAL.LayoutDAL.MPLayout_SetParameters(ConString, PrmVersion, PrmId, Value, RealID, IsToDelete);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetTableData(string ConString, string TableName)
    {
        return DAL.LayoutDAL.GetTableData(ConString, TableName);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void GetJsonTableData(string ConString, string TableName)
    {
        DataTable dt = DAL.LayoutDAL.GetTableData(ConString, TableName);
        if (dt != null)
            ResponseJSON(GetJson(dt));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetJsonTableDataDT(string ConString, string TableName)
    {
        DataTable dt = DAL.LayoutDAL.GetTableData(ConString, TableName);
        return dt;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetTableDefinitions(string ConString, string TableName)
    {
        return DAL.LayoutDAL.GetTableDefinitions(ConString, TableName);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetDDLDefinitions(string ConString, string Query)
    {
        return DAL.LayoutDAL.GetDDLDefinitions(ConString, Query);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string SetTableFromDefinitions(string ConString, string Query, string Pass, string op)
    {
        try
        {
            if (Pass != "Golan20150120")
                throw new Exception("not authorized");
            return DAL.LayoutDAL.SetTableFromDefinitions(ConString, Query, op);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "שגיאה בעדכון הנתונים )502(";
        }
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_SearchBytxt(string ConString, string TableName, string ColumnName, string Value)
    {
        return DAL.LayoutDAL.MPLayout_SearchBytxt(ConString, TableName, ColumnName, Value);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetRoutes(string ConString, string Query, string CustKey, string VisitsDays, string Pass)
    {
        try
        {
            if (Pass != "Golan20150120")
                throw new Exception("not authorized");
            return DAL.LayoutDAL.MPLayout_SetRoutes(ConString, Query, CustKey, VisitsDays);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "שגיאה בעדכון הנתונים )502(";
        }
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet MPLayout_GetRoutes(string Cust_Key, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetRoutes(Cust_Key, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
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
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable LayoutStrSrcTable()
    {
        var dt = new DataTable("LayoutTextSources");
        try
        {
            dt = (DataTable)System.Web.HttpContext.Current.Cache["LayoutTextSources"];
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dt;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPUserChangeProfile(string UserID, string Language, string ConString)
    {
        ResponseJSON(GetJson(DAL.LayoutDAL.MPUserChangeProfile(UserID, Language, ConString)));
    }


    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetAgentsList(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetAgentsList(ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetAllRoutes(string ConString, string ViewStart, string ViewEnd, string AgentId)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetAllRoutes(ConString, ViewStart, ViewEnd, AgentId);

        DataTable dtToCalendar = new DataTable();
        dtToCalendar.Columns.Add("title", typeof(String));
        dtToCalendar.Columns.Add("allDay", typeof(String));
        dtToCalendar.Columns.Add("start", typeof(String));
        dtToCalendar.Columns.Add("end", typeof(String));
        if (AgentId != "0")
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {

                DataRow eventRow = dtToCalendar.NewRow();
                DateTime Date = Convert.ToDateTime(dt.Rows[i]["DayOfPeriod"].ToString());

                DateTime startHour = Convert.ToDateTime(dt.Rows[i]["FromTime"].ToString());
                DateTime endHour = Convert.ToDateTime(dt.Rows[i]["ToTime"].ToString());
                DateTime start = Convert.ToDateTime(Date.Year + "/" + Date.Month + "/" + Date.Day + " " + startHour.Hour + ":" + startHour.Minute + ":00");
                DateTime end = Convert.ToDateTime(Date.Year + "/" + Date.Month + "/" + Date.Day + " " + endHour.Hour + ":" + endHour.Minute + ":00");
                eventRow[0] = dt.Rows[i]["CustName"].ToString();
                eventRow[1] = "false";
                //eventRow[2] = start.ToString("yyyy-MM-ddTH:mm:ss");
                //eventRow[3] = end.ToString("yyyy-MM-ddTH:mm:ss");
                eventRow[2] = start.ToString("yyyy-MM-ddTH:mm:ss") + " GMT+0200 (Jerusalem Standard Time)";
                eventRow[3] = end.ToString("yyyy-MM-ddTH:mm:ss") + " GMT+0200 (Jerusalem Standard Time)";
                dtToCalendar.Rows.Add(eventRow);
            }
        }
        else
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {

                DataRow eventRow = dtToCalendar.NewRow();
                DateTime Date = Convert.ToDateTime(dt.Rows[i]["DayOfPeriod"].ToString());
                DateTime start = Convert.ToDateTime(Date.Year + "/" + Date.Month + "/" + Date.Day);
                DateTime end = Convert.ToDateTime(Date.Year + "/" + Date.Month + "/" + Date.Day);
                eventRow[0] = dt.Rows[i]["Title"].ToString();
                eventRow[1] = "false";
                eventRow[2] = start.ToString("yyyy-MM-dd") + " GMT+0200 (Jerusalem Standard Time)";
                eventRow[3] = end.ToString("yyyy-MM-dd") + " GMT+0200 (Jerusalem Standard Time)";
                dtToCalendar.Rows.Add(eventRow);
            }
        }

        ResponseJSON(GetJson(dtToCalendar));
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetInActiveDays(string AgentId, string InActiveEvents, string ViewStart, string ViewEnd, string ConString)
    {
        try
        {
            DataTable InActiveDays = new DataTable();
            InActiveDays.Columns.Add("FromDate", typeof(DateTime));
            InActiveDays.Columns.Add("ToDate", typeof(DateTime));
            InActiveDays.Columns.Add("Title", typeof(String));
            InActiveDays.Columns.Add("AgentId", typeof(String));
            DateTime DViewStart = Convert.ToDateTime(ViewStart.Substring(0, 24));
            DateTime DViewEnd = Convert.ToDateTime(ViewEnd.Substring(0, 24));
            string[] InActiveDaysStr = InActiveEvents.Split(';');
            if (InActiveEvents != "")
            {
                for (int i = 0; i < InActiveDaysStr.Length; i = i + 3)
                {
                    DataRow InActivRow = InActiveDays.NewRow();
                    DateTime start = Convert.ToDateTime(InActiveDaysStr[i].Substring(0, 24));
                    DateTime Start = Convert.ToDateTime(start.Year + "/" + start.Month + "/" + start.Day + " 00:00:00");
                    DateTime End;
                    if (InActiveDaysStr[i + 1] != "")
                    {
                        DateTime end = Convert.ToDateTime(InActiveDaysStr[i + 1].Substring(0, 24));
                        End = Convert.ToDateTime(end.Year + "/" + end.Month + "/" + end.Day + " 00:00:00");
                    }
                    else
                    {
                        End = Start.AddDays(1);
                    }
                    InActivRow[0] = Start;
                    InActivRow[1] = End;
                    InActivRow[2] = InActiveDaysStr[i + 2];
                    InActivRow[3] = AgentId;
                    InActiveDays.Rows.Add(InActivRow);
                }
            }
            DAL.LayoutDAL.MPLayout_SetInActiveDays(AgentId, InActiveDays, DViewStart.ToString("yyyy-MM-dd"), DViewEnd.ToString("yyyy-MM-dd"), ConString);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetInActiveDays(string AgentId, string ViewStart, string ViewEnd, string ConString)
    {
        try
        {
            DateTime DViewStart = Convert.ToDateTime(ViewStart.Substring(0, 24));
            DateTime DViewEnd = Convert.ToDateTime(ViewEnd.Substring(0, 24));
            DataSet ds = DAL.LayoutDAL.MPLayout_GetInActiveDays(AgentId, DViewStart.ToString("yyyy-MM-dd"), DViewEnd.ToString("yyyy-MM-dd"), ConString);
            DataTable dtInActive = new DataTable();
            dtInActive.Columns.Add("title", typeof(String));
            dtInActive.Columns.Add("allDay", typeof(String));
            dtInActive.Columns.Add("start", typeof(String));
            dtInActive.Columns.Add("end", typeof(String));
            dtInActive.Columns.Add("color", typeof(String));
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                DataRow workRow = dtInActive.NewRow();
                workRow[0] = ds.Tables[0].Rows[i]["Title"];
                workRow[1] = "true";
                DateTime start = Convert.ToDateTime(ds.Tables[0].Rows[i]["FromDate"]);
                DateTime end = Convert.ToDateTime(ds.Tables[0].Rows[i]["ToDate"]);
                workRow[2] = start.AddDays(1).ToString("MM-dd-yyyy");
                workRow[3] = end.AddDays(1).ToString("MM-dd-yyyy");
                workRow[4] = "#3A87AD";
                dtInActive.Rows.Add(workRow);
            }
            for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
            {
                DataRow workRow = dtInActive.NewRow();
                string agentName = ds.Tables[1].Rows[i]["AgentName"].ToString();
                if (agentName.Length > 8)
                {
                    agentName = agentName.Substring(0, 8) + "..";
                }
                workRow[0] = ds.Tables[1].Rows[i]["Title"] + " - " + agentName;
                workRow[1] = "true";
                DateTime start = Convert.ToDateTime(ds.Tables[1].Rows[i]["FromDate"]);
                DateTime end = Convert.ToDateTime(ds.Tables[1].Rows[i]["ToDate"]);
                workRow[2] = start.AddDays(1).ToString("MM-dd-yyyy");
                workRow[3] = end.AddDays(1).ToString("MM-dd-yyyy");
                workRow[4] = "#339966";
                dtInActive.Rows.Add(workRow);
            }

            ResponseJSON(GetJson(dtInActive));

        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_RoutesSaveSettings(string NumberOfWeeks, string WorkDays, string StartDate, string StartHour, string EndHour, string InActiveDaysTypeList, string ConString)
    {
        DateTime startDate = Convert.ToDateTime(StartDate);
        DateTime startHour = Convert.ToDateTime(startDate.Year + "/" + startDate.Month + "/" + startDate.Day + " " + StartHour + ":00");
        DateTime endHour = Convert.ToDateTime(startDate.Year + "/" + startDate.Month + "/" + startDate.Day + " " + EndHour + ":00");
        string QueryInActiveDaysType = "";
        if (InActiveDaysTypeList != "")
        {
            string[] arr = InActiveDaysTypeList.Split(';');
            QueryInActiveDaysType += " BEGIN DELETE FROM [MTN_CustRoutesInActiveDaysTypes] END ";
            for (int i = 0; i < arr.Length; i++)
            {
                QueryInActiveDaysType += " BEGIN INSERT INTO [MTN_CustRoutesInActiveDaysTypes](InActiveDaysTypeText)";
                QueryInActiveDaysType += " VALUES(N@@@" + arr[i] + "@@@) END ";
            }
        }
        return DAL.LayoutDAL.MPLayout_RoutesSaveSettings(NumberOfWeeks, WorkDays, startDate.ToString("yyyy-MM-dd"), startHour.ToString("yyyy-MM-dd H:mm:ss"), endHour.ToString("yyyy-MM-dd H:mm:ss"), QueryInActiveDaysType, ConString).ToString();
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_RoutesGetSettings(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_RoutesGetSettings(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_RoutesGetInActiveDaysType(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_RoutesGetInActiveDaysType(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_AddCustToDistribution(string Cust_Key, string lines, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_AddCustToDistribution(Cust_Key, lines, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetCustToDistribution(string Cust_Key, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetCustToDistribution(Cust_Key, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetDistributionLine(string Op, string DistributionLineID, string DistributionLineDescription, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SetDistributionLine(Op, DistributionLineID, DistributionLineDescription, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetDistributionLine(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetDistributionLine(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_AddLineToAgent(string AgentId, string DistributionLineDescription, string Date, string daysInterval, string ConString)
    {
        DateTime DDate = Convert.ToDateTime(Date.Substring(0, 24));

        string DoDel = "0";
        DateTime OldDate = Convert.ToDateTime(DDate);
        if (daysInterval != "0")
        {
            DoDel = "1";
            OldDate = OldDate.AddDays(((-1) * Convert.ToDouble(daysInterval)));
        }
        return DAL.LayoutDAL.MPLayout_AddLineToAgent(AgentId, DistributionLineDescription, DDate.ToString("yyyy-MM-dd"), DoDel, OldDate.ToString("yyyy-MM-dd"), ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_GetLineToAgentEvents(string ConString, string ViewStart, string ViewEnd, string AgentId)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetLineToAgentEvents(ConString, ViewStart, ViewEnd, AgentId);

        DataTable dtToCalendar = new DataTable();
        dtToCalendar.Columns.Add("title", typeof(String));
        dtToCalendar.Columns.Add("allDay", typeof(String));
        dtToCalendar.Columns.Add("start", typeof(String));
        dtToCalendar.Columns.Add("end", typeof(String));

        for (int i = 0; i < dt.Rows.Count; i++)
        {

            DataRow eventRow = dtToCalendar.NewRow();
            DateTime Date = Convert.ToDateTime(dt.Rows[i]["Date"].ToString());
            DateTime start = Convert.ToDateTime(Date.Year + "/" + Date.Month + "/" + Date.Day);
            DateTime end = Convert.ToDateTime(Date.Year + "/" + Date.Month + "/" + Date.Day);
            eventRow[0] = dt.Rows[i]["DistributionLineDescription"].ToString();
            eventRow[1] = "false";
            eventRow[2] = start.ToString("yyyy-MM-dd") + " GMT+0200 (Jerusalem Standard Time)";
            eventRow[3] = end.ToString("yyyy-MM-dd") + " GMT+0200 (Jerusalem Standard Time)";
            dtToCalendar.Rows.Add(eventRow);
        }

        ResponseJSON(GetJson(dtToCalendar));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_delLineToAgentEvent(string AgentId, string DistributionLineDescription, string Date, string ConString)
    {
        DateTime DDate = Convert.ToDateTime(Date.Substring(0, 24));
        return DAL.LayoutDAL.MPLayout_delLineToAgentEvent(AgentId, DistributionLineDescription, DDate.ToString("yyyy-MM-dd"), ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetOrdersMapByAgent(string AgentId, string DateInserted, string ConString)
    {
        return DAL.LayoutDAL.GetOrdersMapByAgent(AgentId, DateInserted, ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SaveRoutesSettings(string ParameterId, string ParameterValue, string IsDate, string ConString)
    {
        if (IsDate == "Date")
        {
            DateTime Date = Convert.ToDateTime(ParameterValue);
            ParameterValue = Date.ToString("yyyy-MM-dd H:mm:ss");
        }

        return DAL.LayoutDAL.MPLayout_SaveRoutesSettings(ParameterId, ParameterValue, IsDate, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SaveInActiveDaysType(string InActiveDaysTypes, string ConString)
    {

        string QueryInActiveDaysType = "";
        if (InActiveDaysTypes != "")
        {
            string[] arr = InActiveDaysTypes.Split(';');
            QueryInActiveDaysType += " BEGIN DELETE FROM [MTN_CustRoutesInActiveDaysTypes] END ";
            for (int i = 0; i < arr.Length; i++)
            {
                QueryInActiveDaysType += " BEGIN INSERT INTO [MTN_CustRoutesInActiveDaysTypes](InActiveDaysTypeId,InActiveDaysTypeText)";
                QueryInActiveDaysType += " VALUES(" + i + ",N@@@" + arr[i] + "@@@) END ";
            }
        }
        return DAL.LayoutDAL.MPLayout_SaveInActiveDaysType(QueryInActiveDaysType, ConString).ToString();
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetItemsByFamilyID(string FamilyId, string ConString)
    {
        return DAL.LayoutDAL.GetItemsByFamilyID(FamilyId, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetItemFamily(string ConString)
    {
        return DAL.LayoutDAL.GetItemFamily(ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetGalleryData(string Id, string AgentID, string Cust_Key, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetGalleryData(Id, AgentID, Cust_Key, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_GetGalleryData(string Id, string AgentID, string Cust_Key, string ConString)
    {
        return (GetJson(DAL.LayoutDAL.MPLayout_GetGalleryData(Id, AgentID, Cust_Key, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetDocManagement(string DocManagementID, string FileName, string FileDesc, string Objects,
            string ObjectsTypeID, string UserID, string IsToDelete, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SetDocManagement(DocManagementID, FileName, FileDesc, Objects,
            ObjectsTypeID, UserID, IsToDelete, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet MPLayout_GetDocsManagementData(string ObjectsTypeID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetDocsManagementData(ObjectsTypeID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetDocsManagementPopulations(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetDocsManagementPopulations(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetDocsManagementCustomers(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetDocsManagementCustomers(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetDriverGPSLocation(string AgentID, string Date, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetDriverGPSLocation(AgentID, Date, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetDriverGPSLocationByCountry(string AgentID, string Date, string countryID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetDriverGPSLocation(AgentID, Date, countryID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetCustomersCord(string AgentId, string Date, string ConString, long? countryID = null, long? distrID = null)
    {
        return DAL.LayoutDAL.MPLayout_GetCustomersCord(AgentId, Date, countryID, distrID, ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetCustomersRoadCord(Agents agents, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetCustomersRoadCord(agents, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet MPLayout_GetUserRoles(string SelectedUserID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetUserRoles(SelectedUserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SeUserData(string UserID, string UserName, string Name, string Password,
            string UserCode, string UserRoleID, string CountryID, string DistributionCenterID, string ManagerUserID, string ProfileComponentsID,
            string SessionUserID, string IsToDelete, string prStr, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SeUserData(UserID, UserName, Name, Password,
            UserCode, UserRoleID, CountryID, DistributionCenterID, ManagerUserID, ProfileComponentsID,
            SessionUserID, IsToDelete, prStr, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetUserProfile(string SelectedUserID, string LanguageID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetUserProfile(SelectedUserID, LanguageID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetUserProfileByLang(string SelectedUserID, string Language, string FormID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetUserProfileByLang(SelectedUserID, Language, FormID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetUsers(string SessionUserID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetUsers(SessionUserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetDriverToUser(string SelectedUserID, string DriverID, string DriverTypeID, string SessionUserID, string IsToDelete, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SetDriverToUser(SelectedUserID, DriverID, DriverTypeID, SessionUserID, IsToDelete, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable MPLayout_GetTaskTypes(string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetTaskTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetTask(string TaskID, string AgentId, string CustomerCode, string Address, string City, string dateFrom, string dateTo, string TaskTypeID, string Task,
            string MobiUserID, string IsToDelete, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SetTask(TaskID, AgentId, CustomerCode, Address, City, dateFrom, dateTo, TaskTypeID, Task,
            MobiUserID, IsToDelete, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string MPLayout_SetTaskCords(string TaskID, string Lat, string Lon, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_SetTaskCords(TaskID, Lat, Lon, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string GetAndSetTaskCords(string TaskID, string Address, string City, string CountryName, bool IsProxy, string ConString)
    {
        string RetVal = "ZERO_RESULTS";
        string responseFromServer = "";
        StreamReader reader = new StreamReader(new MemoryStream());
        WebResponse response = null;

        try
        {

            //WebRequest request = WebRequest.Create("http://www.waze.co.il/WAS/mozi?token=123&address=" + dt.Rows[i]["Address"].ToString() + " " + dt.Rows[i]["City"].ToString());
            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyBK8cEQfu8LDwkPihEjhQHcVlbEh_AIDqE&address=" + dt.Rows[i]["Address"].ToString() + "+" + dt.Rows[i]["City"].ToString() + "&sensor=false";
            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyBK8cEQfu8LDwkPihEjhQHcVlbEh_AIDqE&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//MobiPlusDubek@gmail.com
            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyAO6rjF3yWA4P_7ayRBz-mp6Zmvl15UwFc&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//MobiPlus77@gmail.com
            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCFPq5BTkiZkMSxTCovlrhoeoll95P8AcA&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//PlusMobi77@gmail.com
            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDXoVR4k1_tRdGM59ngY1dcMgMSbS0GbS0&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//YPlusMob55@gmail.com

            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDXoVR4k1_tRdGM59ngY1dcMgMSbS0GbS0&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//YPlusMob55@gmail.com
            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCFPq5BTkiZkMSxTCovlrhoeoll95P8AcA&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//PlusMobi77@gmail.com


            //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyAO6rjF3yWA4P_7ayRBz-mp6Zmvl15UwFc&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//MobiPlus77@gmail.com
            string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCFPq5BTkiZkMSxTCovlrhoeoll95P8AcA&address=" + Address + "," + City + "," + CountryName + "&sensor=false";//PlusMobi77@gmail.com


            WebRequest request = WebRequest.Create(url);

            if (Address != "")
            {
                //AddRowToLog("Connect to google...; " + url);
                if (IsProxy)
                {
                    WebProxy myProxy = new WebProxy();
                    // Obtain the Proxy Prperty of the  Default browser.  
                    myProxy = (WebProxy)request.Proxy;

                    request.Proxy = myProxy;
                }
                // If required by the server, set the credentials.
                request.Credentials = CredentialCache.DefaultCredentials;
                // Get the response.
                response = request.GetResponse();
                // Display the status.
                //Console.WriteLine(((HttpWebResponse)response).StatusDescription);
                //AddRowToLog("google resonse status: " + ((HttpWebResponse)response).StatusDescription);
                // Get the stream containing content returned by the server.
                Stream dataStream = response.GetResponseStream();
                // Open the stream using a StreamReader for easy access.
                reader = new StreamReader(dataStream);
                // Read the content.
                responseFromServer = reader.ReadToEnd();
                // Display the content.
            }
            else
            {
                responseFromServer = " ZERO_RESULTS";
                //AddRowToLog("Address is Empty!!!");
            }
            if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
            {

                RetVal = "ZERO_RESULTS";

                //AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");

            }
            else
            {

                JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                reader.Close();
                response.Close();

                if (responseFromServer.IndexOf("ZERO_RESULTS") == -1 && data["status"].ToString() == "\"OVER_QUERY_LIMIT\"")
                {
                    //AddRowToLog("google answer: OVER_QUERY_LIMIT; " + data["error_message"].ToString());
                    //AddRowToLog("Stoping the program...");
                    //break;
                    RetVal = "ZERO_RESULTS";
                }

                if (data["status"].ToString().IndexOf("ZERO_RESULTS") == -1 && responseFromServer.IndexOf("ZERO_RESULTS") == -1)
                {
                    RetVal = MPLayout_SetTaskCords(TaskID, data["results"].Last["geometry"]["location"]["lat"].ToString(), data["results"].Last["geometry"]["location"]["lng"].ToString(), ConString);
                }
                else
                {
                    RetVal = "ZERO_RESULTS";

                    //AddRowToLog("ZERO_RESULTS  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                }
            }


        }
        catch (Exception ex)
        {
            //AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
        }



        return RetVal;
    }

    [WebMethod]
    public DataTable Device4Driver_Select(string driverID, string deviceID, string ConString)
    {
        return DAL.LayoutDAL.Device4Driver_Select(driverID, deviceID, ConString);
    }

    [WebMethod]
    public DataTable DeviceType_Select(string ConString)
    {
        return DAL.LayoutDAL.DeviceType_Select(ConString);
    }

    [WebMethod]
    public DataTable DeviceList_SelectAll(string countryID, string driverID, string ConString)
    {
        return DAL.LayoutDAL.DeviceList_SelectAll(countryID, driverID, ConString);
    }

    [WebMethod]
    public DataTable SaveDevices4Drivers(int? id, string driverID, string deviceID, bool isActive, string comment, int userID, string conString)
    {
        return DAL.LayoutDAL.SaveDevices4Drivers(id, driverID, deviceID, isActive, comment, userID, conString);
    }

    [WebMethod]
    public DataTable Devices_Save(int? id, int? deviceTypeID, string deviceID, int? status, int countryID, string comment, string userID, string conString)
    {
        return DAL.LayoutDAL.Devices_Save(id, deviceTypeID, deviceID, status, countryID, comment, userID, conString);
    }
    [WebMethod]
    public DataTable DeviceInfo_Select(int? id, string conString)
    {
        return DAL.LayoutDAL.DeviceInfo_Select(id, conString);
    }

    [WebMethod]
    public DataTable Status_SelectAll(string conString)
    {
        return DAL.LayoutDAL.Status_SelectAll(conString);
    }

    [WebMethod]
    public DataTable DeleteDevice4Driver(int? id, string conString)
    {
        return DAL.LayoutDAL.DeleteDevice4Driver(id, conString);
    }

    [WebMethod]
    public DataTable CheckDeviceOwner(string deviceID, string conString)
    {
        return DAL.LayoutDAL.CheckDeviceOwner(deviceID, conString);
    }

    [WebMethod]
    public DataTable ChangeDeviceOwner(string deviceID, string driverID, int userID, string conString)
    {
        return DAL.LayoutDAL.CheckDeviceOwner(deviceID, driverID, userID, conString);
    }

    [WebMethod]
    public DataTable DeleteDevice(int? id, string conString)
    {
        return DAL.LayoutDAL.DeleteDevice(id, conString);
    }

    [WebMethod]
    public DataTable GetAgents_SelectAll(string sessionUserID, string countryID, string distID, string conString)
    {
        return DAL.LayoutDAL.GetAgents_SelectAll(sessionUserID, countryID, distID, conString);
    }

    [WebMethod]
    public DataTable GetDriversByDate(string distID, string countryID, DateTime date, string conString)
    {
        return DAL.LayoutDAL.GetDriversByDate(distID, countryID, date, conString);
    }

    [WebMethod]
    public DataTable SalesOrganizations_SelectAll(string conString)
    {
        return DAL.LayoutDAL.SalesOrganizations_SelectAll(conString);
    }

    [WebMethod]
    public DataTable Layout_POD_WEB_ConcentrationActivity(int? reportID, string cid, string did, string driverID, string date, string toDate, string language, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_ConcentrationActivity(reportID, cid, did, driverID, date, toDate, language, conString);
    }
    [WebMethod]
    public DataTable Layout_POD_WEB_ConcentrationActivityPopup(string cid, string did, string driverID, string date, string shipment, string cycle, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_ConcentrationActivityPopup(cid, did, driverID, date, shipment, cycle, conString);
    }

    [WebMethod]
    public DataTable Layout_POD_WEB_DriverStatus_DSA(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_DriverStatus_DSA(cid, did, driverID, date, toDate, conString);
    }
    [WebMethod]
    public DataTable Layout_POD_WEB_DriverStatus_PopUp(string cid, string did, string driverID, string date, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_DriverStatus_PopUp(cid, did, driverID, date, conString);
    }
    [WebMethod]
    public DataTable Layout_POD_WEB_EndDay(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_EndDay(cid, did, driverID, date, toDate, conString);
    }

   [WebMethod]
    public DataTable Layout_POD_WEB_EndDay_PopUp(string cid, string did, string driverID, string date, string cycle, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_EndDay_PopUp(cid, did, driverID, date, cycle, conString);
    }

    [WebMethod]
    public DataTable Layout_POD_WEB_AgentDailyActivity(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_AgentDailyActivity(cid, did, driverID, date, toDate, conString);
    }

    [WebMethod]
    public DataTable Layout_POD_WEB_AgentDailyActivityPopup(string cid, string did, string driverID, string date, string custID, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_AgentDailyActivityPopup(cid, did, driverID, date, custID, conString);
    }

    [WebMethod]
    public DataTable Layout_POD_WEB_AgentsReport(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_AgentsReport(cid, did, driverID, date, toDate, conString);
    }

    [WebMethod]
    public DataTable Layout_POD_WEB_AgentsReport1(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_AgentsReport1(cid, did, driverID, date, toDate, conString);
    }
    [WebMethod]
    public DataTable POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR_HEADERS(string conString)
    {
        return DAL.LayoutDAL.POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR_HEADERS(conString);
    }

    [WebMethod]
    public DataTable POD_WEB_REPORT_TRUCK_AND_TRAILOR_DATA(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.POD_WEB_REPORT_TRUCK_AND_TRAILOR_DATA(cid, did, driverID, date, toDate, conString);
    }
    [WebMethod]
    public DataTable Layout_POD_WEB_TrucksAndTrailorData(string cid, string did, string driverID, string date, string toDate, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_TrucksAndTrailorData(cid, did, driverID, date, toDate, conString);
    }
    [WebMethod]
    public DataTable Layout_POD_WEB_TrucksAndTrailorUpData(string docNum, string conString)
    {
        return DAL.LayoutDAL.Layout_POD_WEB_TrucksAndTrailorUpData(docNum, conString);
    }
    [WebMethod]
    public DataTable MPLayout_GetInfoWindow(string countryID, string conString)
    {
        return DAL.LayoutDAL.MPLayout_GetInfoWindow(countryID, conString);
    }

}
