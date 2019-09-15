using MobiPlus.Models.LanguageTools;
using MobiPlusTools;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

[WebService(Namespace = "http://microsoft.com/webservices/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class MobiPlusWS : ServiceBaseCls
{
    private string LogDir = "";
    //public static DataTable AgentVersions = null;
    //public static DataTable ManagerVersions = null;
    public MobiPlusWS()
    {
        try
        {
            LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

            if (System.Web.HttpContext.Current.Cache["TextSources"] == null)
            {
                // Create the cache dependency
                //SqlCacheDependency dep = new SqlCacheDependency("TextSources", "TextSources");
                string connectionString = ConfigurationManager.ConnectionStrings[
                                                "WebConnectionString"].ConnectionString;
                SqlConnection myConnection = new SqlConnection(connectionString);
                SqlDataAdapter ad = new SqlDataAdapter("SELECT * FROM  TextSources", myConnection);
                DataSet ds = new DataSet();
                ad.Fill(ds);

                // put in the cache object
                System.Web.HttpContext.Current.Cache.Insert("TextSources", ds.Tables[0]);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
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
                        row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("'", "").Replace("\"", "''").Replace(",", "").Replace(".", "").Replace("\"", "").Replace(@"'\", "")));
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

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetUsers(string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.GetUsers(ConString);
            dt.Columns.Add("UserID", typeof(int));
            if (dt != null)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["UserID"] = 1;
                }
            }

            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void AddEditUser(int id, string name, string Description, DateTime dtCreate, int UserID, string ConString)
    {
        try
        {
            DAL.DAL.AddEditUser(id, name, Description, dtCreate, UserID, ConString);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void SetUserWidgetPosition(string UserID, string WidgetsUserID, string Width, string Height, string TabID, string ConString)
    {
        try
        {
            DAL.DAL.SetUserWidgetPosition(UserID, WidgetsUserID, Width, Height, TabID, ConString);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void SetUserWidgetOrder(string UserID, string JsonObj, string TabID, string ConString)
    {
        try
        {
            DAL.DAL.SetUserWidgetOrder(UserID, JsonObj, TabID, ConString);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void SetUserWidgetCol(string UserID, string WidgetsUserID, string ColNum, string TabID, string ConString)
    {
        try
        {
            DAL.DAL.SetUserWidgetCol(UserID, WidgetsUserID, ColNum, TabID, ConString);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void UserLogin(string UserName, string Password, string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.UserLogin(UserName, Password, ConString);
            //dt.Columns.Add("UserID", typeof(int));
            if (dt != null && dt.Rows.Count > 0)
            {
                //SessionUserID = dt.Rows[0]["id"].ToString();
                ResponseJSON(GetJson(dt)); //ResponseJSON("[{id:" + SessionUserID + "}]");
                return;
            }
            ResponseJSON(GetJson(dt)); //ResponseJSON("[{id:0}]");
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetUserWidgets(string UserID, string ConString)
    {
        return DAL.DAL.GetUserWidgets2(UserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetUserTabsJSON(string UserID, string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.GetUserTabs(UserID, ConString);
            if (dt != null && dt.Rows.Count > 0)
            {
                ResponseJSON(GetJson(dt));
                return;
            }
            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetUserTabs(string UserID, string ConString)
    {
        return DAL.DAL.GetUserTabs(UserID, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetUserWidgetsByTabIDJSON(string UserID, string TabID, string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.GetUserWidgetsByTabID(UserID, TabID, ConString);
            if (dt != null && dt.Rows.Count > 0)
            {
                ResponseJSON(GetJson(dt));
                return;
            }
            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetUserWidgetsByTabID(string UserID, string TabID, string ConString)
    {
        return DAL.DAL.GetUserWidgetsByTabID(UserID, TabID, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void AddUserTab(string UserID, string TabName, string ConString)
    {
        DAL.DAL.AddUserTab(UserID, TabName, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetAllWidgetsByPermissions(string UserID, string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.GetAllWidgetsByPermissions(UserID, ConString);
            if (dt != null && dt.Rows.Count > 0)
            {
                ResponseJSON(GetJson(dt));
                return;
            }
            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void AddWidgetToUserTab(string UserID, string WidgetID, string TabID, string ConString)
    {
        DAL.DAL.AddWidgetToUserTab(UserID, WidgetID, TabID, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void DeleteUserWidget(string UserID, string WidgetsUserID, string TabID, string ConString)
    {
        DAL.DAL.DeleteUserWidget(UserID, WidgetsUserID, TabID, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void DeleteTag(string UserID, string TabID, string ConString)
    {
        DAL.DAL.DeleteTag(UserID, TabID, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string StrSrc(string key, string url, string Language)
    {
        try
        {
            DataTable dt = (DataTable)System.Web.HttpContext.Current.Cache["TextSources"];
            if (dt != null)
            {
                DataView dv = dt.DefaultView;
                url = url.Substring(0, url.IndexOf("?") > -1 ? url.IndexOf("?") : url.Length);
                dv.RowFilter = "url = '" + url + "' and KeyWord = '" + key + "'";
                if (dv.ToTable().Rows.Count > 0)
                {
                    switch (Language)
                    {
                        case "Hebrew":
                            return dv.ToTable().Rows[0]["LocalText"].ToString();

                        case "English":
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
    public DataSet GetGridData(string GridName, string ConString)
    {
        return DAL.DAL.GetGridData(GridName, ConString);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GridData(string GridName, string ConString)
    {
        try
        {
            DataSet ds = DAL.DAL.GetGridData(GridName, ConString);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                DataTable dt = DAL.DAL.RunQuery(ds.Tables[0].Rows[0]["Query"].ToString());
                ResponseJSON(GetJson(dt));
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet GetGridDataNew(string GridName, string ConString)
    {
        return DAL.DAL.GetGridDataNew(GridName, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GridDataNew(string GridName, string ConString)
    {
        try
        {
            if (HttpContext.Current.Request.QueryString["GridParameters"] == null)
                return;

            string id = "";
            if (HttpContext.Current.Request.QueryString["id"] != null)
                id = HttpContext.Current.Request.QueryString["id"].ToString();

            DataSet ds = DAL.DAL.GetGridDataNew(GridName, ConString);
            if (ds != null && ds.Tables.Count > 1 && ds.Tables[0].Rows.Count > 0)
            {
                string GridQuery = ds.Tables[0].Rows[0]["GridQuery"].ToString();

                //replace delete strings
                if (GridQuery != null && GridQuery.Length > 0 && (GridQuery.ToLower().IndexOf("delete") > -1 || GridQuery.ToLower().IndexOf("truncate") > -1 || GridQuery.ToLower().IndexOf("create") > -1 || GridQuery.ToLower().IndexOf("alter") > -1))
                    GridQuery = GridQuery.ToLower().Replace("delete", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                DataTable dtRes = new DataTable();
                string QueryType = ds.Tables[0].Rows[0]["QueryType"].ToString();
                if (QueryType.IndexOf(",") > -1)
                    QueryType = ds.Tables[0].Rows[0]["QueryType"].ToString().Split(',')[0];
                switch (QueryType)
                {
                    case "Query":
                        string[] arrParams = HttpContext.Current.Request.QueryString["GridParameters"].ToString().Split(';');
                        bool isFirst = true;
                        for (int i = 0; i < arrParams.Length; i++)
                        {
                            string[] arrParamValue = arrParams[i].Split(':');

                            if (arrParamValue.Length > 1 && GridQuery.IndexOf("@" + arrParamValue[0]) > -1)
                            {
                                GridQuery = GridQuery.Replace("@" + arrParamValue[0], arrParamValue[1]);
                            }
                        }
                        if (id != "")
                            GridQuery = GridQuery.Replace("where", "where " + ds.Tables[0].Rows[0]["ChildFilterCol"].ToString() + id + " and ");
                        dtRes = DAL.DAL.RunQuery(GridQuery, ConString);
                        break;
                    case "View":

                        arrParams = HttpContext.Current.Request.QueryString["GridParameters"].ToString().Split(';');
                        isFirst = true;
                        for (int i = 0; i < arrParams.Length; i++)
                        {
                            string[] arrParamValue = arrParams[i].Split(':');

                            if (arrParamValue.Length > 1)
                            {
                                if (isFirst)
                                {
                                    GridQuery += " Where ";
                                    isFirst = false;
                                }
                                GridQuery = GridQuery.Replace("@" + arrParamValue[0], arrParamValue[1]);
                            }
                        }
                        if (id != "")
                            GridQuery = GridQuery.Replace("where", "where " + ds.Tables[0].Rows[0]["ChildFilterCol"].ToString() + id);
                        dtRes = DAL.DAL.RunQuery("Select * from " + GridQuery, ConString);
                        break;
                    case "Stored procedure":
                        if (id != "")
                            id = ";" + ds.Tables[0].Rows[0]["ChildFilterCol"].ToString().Replace("=", "") + ":" + id + ";";
                        dtRes = DAL.DAL.RunSP(ds.Tables[0].Rows[0]["GridQuery"].ToString(), HttpContext.Current.Request.QueryString["GridParameters"].ToString() + id, ConString);
                        break;
                }

                ResponseJSON(GetJson(dtRes));
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetServerVersionForUI(string ConString)
    {
        ResponseJSON(GetJson(GetServerVersionForUIDT(ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetServerVersionForUIDT(string ConString)
    {
        return DAL.DAL.GetServerVersionForUI(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetServerGroups(string ConString)
    {
        ResponseJSON(GetJson(GetServerGroupsDT(ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetServerGroupsDT(string ConString)
    {
        return DAL.DAL.GetServerGroups(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddEditServerVersion(string VerID, string AgentID, string GroupID, string FromVersion, string ToVersion, string UserID, string Command, string ProjectType, string ConString, out string Msg)
    {
        return DAL.DAL.AddEditServerVersion(VerID, AgentID, GroupID, FromVersion, ToVersion, UserID, Command, ProjectType, ConString, out Msg);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddEditServerLayoutVersion(string VerID, string AgentID, string GroupID, string FromVersion, string ToVersion, string UserID, string Command, string ProjectType, string ConString, out string Msg)
    {
        return DAL.DAL.AddEditServerLayoutVersion(VerID, AgentID, GroupID, FromVersion, ToVersion, UserID, Command, ProjectType, ConString, out Msg);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddEditGrid(string id, string gridname, string gridquery, string querytype, string gridparameters, string gridcaption, string childfiltercol, string masterdetailsgridid, string rows, string UserID, string JumpGridID, string ConString)
    {
        return DAL.DAL.AddEditGrid(id, gridname, gridquery, querytype, gridparameters, gridcaption, childfiltercol, masterdetailsgridid, rows, UserID, JumpGridID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddEditGridCols(string id, string gridid, string colname, string colpromt, string colorder, string colwidth, string coltype, string colalignment, string colopenwindowbygridid, string UserID, string ConString)
    {
        return DAL.DAL.AddEditGridCols(id, gridid, colname, colpromt, colorder, colwidth, coltype, colalignment, colopenwindowbygridid, UserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void QueryTypes()
    {
        try
        {
            DataTable dt = GetQueryTypes();

            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetQueryTypes()
    {
        DataTable dt = new DataTable("dt");
        try
        {
            dt.Columns.Add("id");
            dt.Columns.Add("QueryType");

            DataRow dr = dt.NewRow();
            dr["id"] = "Query";
            dr["QueryType"] = "Query";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "Stored procedure";
            dr["QueryType"] = "Stored procedure";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "View";
            dr["QueryType"] = "View";
            dt.Rows.Add(dr);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetGraphTypes()
    {
        DataTable dt = new DataTable("dt");
        try
        {
            dt.Columns.Add("id");
            dt.Columns.Add("GraphType");

            DataRow dr = dt.NewRow();
            dr["id"] = "Pie";
            dr["GraphType"] = "Pie";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "Bar";
            dr["GraphType"] = "Bar";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "Line";
            dr["GraphType"] = "Line";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "HBar";
            dr["GraphType"] = "HBar";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "Meter";
            dr["GraphType"] = "Meter";
            dt.Rows.Add(dr);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetGrids(string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.GetGrids(ConString);
            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetGridsDT(string ConString)
    {
        DataTable dt = new DataTable("dt");
        try
        {
            dt = DAL.DAL.GetGrids(ConString);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetAlignment()
    {
        try
        {
            DataTable dt = GetAlignmentDT();

            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public DataTable GetAlignmentDT()
    {
        DataTable dt = new DataTable("AlignmentDT");
        try
        {
            dt.Columns.Add("id");
            dt.Columns.Add("Alignment");

            DataRow dr = dt.NewRow();
            dr["id"] = "right";
            dr["Alignment"] = "right";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "center";
            dr["Alignment"] = "center";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "left";
            dr["Alignment"] = "left";
            dt.Rows.Add(dr);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetTypes()
    {
        try
        {
            DataTable dt = GetTypesDT();

            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetTypesDT()
    {
        DataTable dt = new DataTable("TypesDT");
        try
        {
            dt.Columns.Add("id");
            dt.Columns.Add("Type");

            DataRow dr = dt.NewRow();
            dr["id"] = "text";
            dr["Type"] = "text";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "int";
            dr["Type"] = "int";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "float";
            dr["Type"] = "float";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "date";
            dr["Type"] = "date";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "percent";
            dr["Type"] = "percent";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = "TextDesigned";
            dr["Type"] = "TextDesigned";
            dt.Rows.Add(dr);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool IsGridNameExsits(string GridName)
    {
        return DAL.DAL.IsGridNameExsits(GridName);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void RetJSONBar()
    {
        DataTable dt = new DataTable();
        try
        {
            dt.Columns.Add("ינואר");
            dt.Columns.Add("פברואר");
            dt.Columns.Add("מרץ");
            dt.Columns.Add("אפריל");
            dt.Columns.Add("מאי");
            dt.Columns.Add("יוני");
            dt.Columns.Add("יולי");

            dt.Columns.Add("fillColor");
            dt.Columns.Add("strokeColor");

            DataRow dr = dt.NewRow();
            dr["ינואר"] = "77";
            dr["פברואר"] = "33";
            dr["מרץ"] = "54";
            dr["אפריל"] = "23";
            dr["מאי"] = "98";
            dr["יוני"] = "22";
            dr["יולי"] = "77";

            dr["fillColor"] = "\"#497D97\"";
            dr["strokeColor"] = "\"#3072BC\"";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["ינואר"] = "84";
            dr["פברואר"] = "65";
            dr["מרץ"] = "67";
            dr["אפריל"] = "83";
            dr["מאי"] = "36";
            dr["יוני"] = "34";
            dr["יולי"] = "88";

            dr["fillColor"] = "\"#C5D0E3\"";
            dr["strokeColor"] = "\"#293955\"";
            dt.Rows.Add(dr);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new

           System.Web.Script.Serialization.JavaScriptSerializer();

            string strData = "";

            strData = "var dd = {labels: [";
            int i = 0;
            for (i = 0; i < dt.Columns.Count; i++)
            {
                if (dt.Columns[i].ColumnName != "fillColor" && dt.Columns[i].ColumnName != "strokeColor" && dt.Columns[i].ColumnName != "pointColor" && dt.Columns[i].ColumnName != "pointStrokeColor")
                    strData += "\"" + dt.Columns[i].ColumnName + "\", ";
            }

            i = 0;
            strData += "],datasets:[";

            for (i = 0; i < dt.Rows.Count; i++)
            {
                strData += "{";
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!(dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor"))
                        strData += dt.Columns[j].ColumnName.ToString() + ":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                }
                strData += "data: [";
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor")
                        strData += dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                }
                strData += "]},";
            }
            strData += " ] }";

            ResponseJSON(Context.Server.UrlEncode(strData));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void RetJSONPie()
    {
        try
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("value");
            dt.Columns.Add("color");
            dt.Columns.Add("title");

            DataRow dr = dt.NewRow();
            dr["value"] = "7";
            dr["color"] = "\"#584A5E\"";
            dr["title"] = "\"ינואר\"";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["value"] = "84";
            dr["color"] = "\"#7D4F6D\"";
            dr["title"] = "\"פברואר\"";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["value"] = "33";
            dr["color"] = "\"#21323D\"";
            dr["title"] = "\"מרץ\"";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["value"] = "44";
            dr["color"] = "\"#C7604C\"";
            dr["title"] = "\"אפריל\"";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["value"] = "67";
            dr["color"] = "\"#D97041\"";
            dr["title"] = "\"מאי\"";
            dt.Rows.Add(dr);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new

           System.Web.Script.Serialization.JavaScriptSerializer();

            string strData = "";

            strData = "mydata2 = [";
            int i = 0;

            for (i = 0; i < dt.Rows.Count; i++)
            {
                strData += "{";

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    strData += dt.Columns[j].ColumnName.ToString() + ":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                }
                strData += "},";
            }
            strData += "]";

            ResponseJSON(Context.Server.UrlEncode(strData));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void RetJSONLine()
    {
        try
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ינואר");
            dt.Columns.Add("פברואר");
            dt.Columns.Add("מרץ");
            dt.Columns.Add("אפריל");
            dt.Columns.Add("מאי");
            dt.Columns.Add("יוני");
            dt.Columns.Add("יולי");

            dt.Columns.Add("fillColor");
            dt.Columns.Add("strokeColor");
            dt.Columns.Add("pointColor");
            dt.Columns.Add("pointStrokeColor");

            DataRow dr = dt.NewRow();
            dr["ינואר"] = "77";
            dr["פברואר"] = "33";
            dr["מרץ"] = "54";
            dr["אפריל"] = "23";
            dr["מאי"] = "98";
            dr["יוני"] = "22";
            dr["יולי"] = "77";

            dr["fillColor"] = "\"#497D97\"";
            dr["strokeColor"] = "\"#3072BC\"";
            dr["pointColor"] = "\"black\"";
            dr["pointStrokeColor"] = "\"#fff\"";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["ינואר"] = "84";
            dr["פברואר"] = "65";
            dr["מרץ"] = "67";
            dr["אפריל"] = "83";
            dr["מאי"] = "36";
            dr["יוני"] = "34";
            dr["יולי"] = "88";

            dr["fillColor"] = "\"#C5D0E3\"";
            dr["strokeColor"] = "\"#293955\"";
            dr["pointColor"] = "\"rgba(151,187,205,1)\"";
            dr["pointStrokeColor"] = "\"#fff\"";
            dt.Rows.Add(dr);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new

           System.Web.Script.Serialization.JavaScriptSerializer();

            string strData = "";

            strData = "var dd = {labels: [";
            int i = 0;
            for (i = 0; i < dt.Columns.Count; i++)
            {
                if (dt.Columns[i].ColumnName != "fillColor" && dt.Columns[i].ColumnName != "strokeColor" && dt.Columns[i].ColumnName != "pointColor" && dt.Columns[i].ColumnName != "pointStrokeColor")
                    strData += "\"" + dt.Columns[i].ColumnName + "\", ";
            }

            i = 0;
            strData += "],datasets:[";

            for (i = 0; i < dt.Rows.Count; i++)
            {
                strData += "{";
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!(dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor"))
                        strData += "\"" + dt.Columns[j].ColumnName.ToString() + "\":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                }
                strData += "data: [";
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor")
                        strData += dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                }
                strData += "]},";
            }
            strData += " ] }";

            ResponseJSON(Context.Server.UrlEncode(strData));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetAgentSalesGraph(string iDate, string AgentID, string ConString)
    {
        try
        {
            //if (AgentID != "")
            {
                DataTable dtData = DAL.DAL.GetAgentSalesGraph(iDate, AgentID, ConString);
                DataTable dt = new DataTable();
                if (dtData != null)
                {
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        dt.Columns.Add(dtData.Rows[j]["AgentName"].ToString());
                    }
                    dt.Columns.Add("fillColor");
                    dt.Columns.Add("strokeColor");
                    dt.Columns.Add("title");
                    //title: "First data"

                    DataRow dr = dt.NewRow();
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        dr[dtData.Rows[j]["AgentName"].ToString()] = dtData.Rows[j]["total1"].ToString();
                    }
                    dr["fillColor"] = "\"#497D97\"";
                    dr["strokeColor"] = "\"#3072BC\"";
                    dr["title"] = "\"ביצוע\"";

                    dt.Rows.Add(dr);

                    dr = dt.NewRow();
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        dr[dtData.Rows[j]["AgentName"].ToString()] = dtData.Rows[j]["Goal"].ToString();
                    }
                    dr["fillColor"] = "\"#C5D0E3\"";
                    dr["strokeColor"] = "\"#293955\"";
                    dr["title"] = "\"יעד\"";

                    dt.Rows.Add(dr);
                }
                //dt.Columns.Add("ינואר");
                //dt.Columns.Add("פברואר");
                //dt.Columns.Add("מרץ");
                //dt.Columns.Add("אפריל");
                //dt.Columns.Add("מאי");
                //dt.Columns.Add("יוני");
                //dt.Columns.Add("יולי");

                //dt.Columns.Add("fillColor");
                //dt.Columns.Add("strokeColor");

                //DataRow dr = dt.NewRow();
                //dr["ינואר"] = "77";
                //dr["פברואר"] = "33";
                //dr["מרץ"] = "54";
                //dr["אפריל"] = "23";
                //dr["מאי"] = "98";
                //dr["יוני"] = "22";
                //dr["יולי"] = "77";

                //dr["fillColor"] = "\"#497D97\"";
                //dr["strokeColor"] = "\"#3072BC\"";
                //dt.Rows.Add(dr);

                //dr = dt.NewRow();
                //dr["ינואר"] = "84";
                //dr["פברואר"] = "65";
                //dr["מרץ"] = "67";
                //dr["אפריל"] = "83";
                //dr["מאי"] = "36";
                //dr["יוני"] = "34";
                //dr["יולי"] = "88";

                //dr["fillColor"] = "\"#C5D0E3\"";
                //dr["strokeColor"] = "\"#293955\"";
                //dt.Rows.Add(dr);

                System.Web.Script.Serialization.JavaScriptSerializer serializer = new

               System.Web.Script.Serialization.JavaScriptSerializer();

                string strData = "";

                strData = "var dd = {labels: [";
                int i = 0;
                for (i = 0; i < dt.Columns.Count; i++)
                {
                    if (dt.Columns[i].ColumnName != "title" && dt.Columns[i].ColumnName != "fillColor" && dt.Columns[i].ColumnName != "strokeColor" && dt.Columns[i].ColumnName != "pointColor" && dt.Columns[i].ColumnName != "pointStrokeColor")
                        strData += "'" + dt.Columns[i].ColumnName + "', ";
                }
                i = 0;
                if (strData[strData.Length - 2].ToString() == ",")
                    strData = strData.Substring(0, strData.Length - 2);
                strData += "],datasets:[";

                for (i = 0; i < dt.Rows.Count; i++)
                {
                    strData += "{";
                    int j = 0;
                    for (j = 0; j < dt.Columns.Count; j++)
                    {
                        if (!(dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor"))
                            strData += dt.Columns[j].ColumnName.ToString() + ":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                    }
                    if (j > 0 && strData.Length > 2)
                        strData = strData.Substring(0, strData.Length - 1);
                    strData += "data: [";
                    for (j = 0; j < dt.Columns.Count; j++)
                    {
                        if (dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor")
                            strData += dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                    }
                    if (strData[strData.Length - 2].ToString() == ",")
                        strData = strData.Substring(0, strData.Length - 2);
                    strData += "]},";
                }
                if (i > 0 && strData.Length > 2)
                    strData = strData.Substring(0, strData.Length - 1);
                strData += " ] };";

                strData = strData.Replace("\"", "'");
                ResponseJSON(Context.Server.UrlEncode(strData));
            }
            //else
            //{
            //    ResponseJSON(Context.Server.UrlEncode(""));
            //}
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetBarData(string iDate, string AgentID, string GraphID, string ConString)
    {
        try
        {
            DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
            if (dtG != null && dtG.Rows.Count > 0)
            {
                DataTable dtData = new DataTable("dtData");
                string Query = "";
                if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                {
                    string Agent = "AgentID";
                    if (AgentID != "0")
                        Agent = "AgentID";
                    //Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("where", "where Date=" + Date + " and " + Agent + id).Replace("WHERE", "where Date=" + Date + " and " + Agent + id).Replace("Where", "where Date=" + Date + " and " + Agent + id);
                    Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("@Date", iDate).Replace("@AgentID", Agent);
                    if (Query != null && Query.Length > 0 && (Query.ToLower().IndexOf("delete") > -1 || Query.ToLower().IndexOf("truncate") > -1 || Query.ToLower().IndexOf("create") > -1 || Query.ToLower().IndexOf("alter") > -1))
                        Query = Query.ToLower().Replace("delete", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                    dtData = DAL.DAL.RunQuery(Query);

                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "Stored procedure")
                {
                    dtData = DAL.DAL.RunSP(dtG.Rows[0]["GraphQuery"].ToString(), "Date:" + iDate + ";AgentID:" + AgentID, ConString);
                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "View")
                {
                    string Agent = " AgentID=AgentID";
                    if (AgentID != "0")
                        Agent = " AgentID=" + AgentID;
                    //if (id != "")
                    Query = "Select * from " + dtG.Rows[0]["GraphQuery"].ToString();
                    Query += " where Date=" + iDate + " and " + Agent;
                    dtData = DAL.DAL.RunQuery(Query);
                }

                DataTable dt = new DataTable();
                if (dtData != null)
                {
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        if (dt.Columns[dtData.Rows[j]["Name"].ToString()] == null)
                            dt.Columns.Add(dtData.Rows[j]["Name"].ToString());
                    }

                    dt.Columns.Add("fillColor");
                    dt.Columns.Add("strokeColor");
                    dt.Columns.Add("title");
                    dt.Columns.Add("total");
                    dt.Columns.Add("total2");

                    DataRow dr = dt.NewRow();
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        dr[dtData.Rows[j]["Name"].ToString()] = dtData.Rows[j]["Total"].ToString();
                    }
                    if (dtData.Rows.Count > 0)
                    {
                        dr["fillColor"] = "\"" + dtData.Rows[0]["fillColor1"].ToString() + "\"";
                        dr["strokeColor"] = "\"" + dtData.Rows[0]["strokeColor1"].ToString() + "\"";
                        dr["title"] = "\"" + dtData.Rows[0]["Title1"].ToString() + "\"";

                        dt.Rows.Add(dr);
                    }
                    dr = dt.NewRow();
                    for (int j = 0; j < dtData.Rows.Count; j++)
                    {
                        dr[dtData.Rows[j]["Name"].ToString()] = dtData.Rows[j]["Total2"].ToString();
                    }
                    if (dtData.Rows.Count > 0)
                    {
                        dr["fillColor"] = "\"" + dtData.Rows[0]["fillColor2"].ToString() + "\"";
                        dr["strokeColor"] = "\"" + dtData.Rows[0]["strokeColor2"].ToString() + "\"";
                        dr["title"] = "\"" + dtData.Rows[0]["Title2"].ToString() + "\"";

                        dt.Rows.Add(dr);
                    }
                }


                System.Web.Script.Serialization.JavaScriptSerializer serializer = new

               System.Web.Script.Serialization.JavaScriptSerializer();

                string strData = "";

                strData = "var dd = {labels: [";
                int i = 0;
                for (i = 0; i < dt.Columns.Count; i++)
                {
                    if (dt.Columns[i].ColumnName != "title" && dt.Columns[i].ColumnName != "fillColor" && dt.Columns[i].ColumnName != "strokeColor" && dt.Columns[i].ColumnName != "pointColor" && dt.Columns[i].ColumnName != "pointStrokeColor")
                        strData += "'" + dt.Columns[i].ColumnName + "', ";
                }
                i = 0;
                if (strData[strData.Length - 2].ToString() == ",")
                    strData = strData.Substring(0, strData.Length - 2);
                strData += "],datasets:[";

                for (i = 0; i < dt.Rows.Count; i++)
                {
                    strData += "{";
                    int j = 0;
                    for (j = 0; j < dt.Columns.Count; j++)
                    {
                        if (!(dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor"))
                            strData += dt.Columns[j].ColumnName.ToString() + ":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                    }
                    if (j > 0 && strData.Length > 2)
                        strData = strData.Substring(0, strData.Length - 1);
                    strData += "data: [";
                    for (j = 0; j < dt.Columns.Count; j++)
                    {
                        if (dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor")
                            strData += dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                    }
                    if (strData[strData.Length - 2].ToString() == ",")
                        strData = strData.Substring(0, strData.Length - 2);
                    strData += "]},";
                }
                if (i > 0 && strData.Length > 2)
                    strData = strData.Substring(0, strData.Length - 1);
                strData += " ] };";

                strData = strData.Replace("\"", "'");
                ResponseJSON(Context.Server.UrlEncode(strData));
            }
            //else
            //{
            //    ResponseJSON(Context.Server.UrlEncode(""));
            //}
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetRGBarData(string iDate, string AgentID, string GraphID, string ConString)
    {
        try
        {
            DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
            if (dtG != null && dtG.Rows.Count > 0)
            {
                DataTable dtData = new DataTable("dtData");
                string Query = "";
                if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                {
                    string Agent = "AgentID";
                    if (AgentID != "0")
                        Agent = "AgentID";
                    Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("@Date", iDate).Replace("@AgentID", Agent);
                    if (Query != null && Query.Length > 0 && (Query.ToLower().IndexOf("delete") > -1 || Query.ToLower().IndexOf("truncate") > -1 || Query.ToLower().IndexOf("create") > -1 || Query.ToLower().IndexOf("alter") > -1))
                        Query = Query.ToLower().Replace("delete", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                    dtData = DAL.DAL.RunQuery(Query);

                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "Stored procedure")
                {
                    dtData = DAL.DAL.RunSP(dtG.Rows[0]["GraphQuery"].ToString(), "Date:" + iDate + ";AgentID:" + AgentID, ConString);
                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "View")
                {
                    string Agent = " AgentID=AgentID";
                    if (AgentID != "0")
                        Agent = " AgentID=" + AgentID;
                    Query = "Select * from " + dtG.Rows[0]["GraphQuery"].ToString();
                    Query += " where Date=" + iDate + " and " + Agent;
                    dtData = DAL.DAL.RunQuery(Query);
                }

                DataTable dt = new DataTable();

                System.Web.Script.Serialization.JavaScriptSerializer serializer = new

               System.Web.Script.Serialization.JavaScriptSerializer();

                string strData = "";
                strData = " labels = [";
                for (int i = 0; i < dtData.Rows.Count; i++)
                {
                    strData += "\"" + dtData.Rows[i]["Name"].ToString() + "\",";
                }
                if (dtData.Rows.Count > 0 && strData.Length > 1)
                    strData = strData.Substring(0, strData.Length - 1);
                strData += "];";

                strData += " data = [";
                for (int i = 0; i < dtData.Rows.Count; i++)
                {
                    strData += "[" + dtData.Rows[i]["Total"].ToString() + ",";
                    strData += dtData.Rows[i]["Total2"].ToString() + "],";
                }
                if (dtData.Rows.Count > 0 && strData.Length > 1)
                    strData = strData.Substring(0, strData.Length - 1);
                strData += "];";



                strData = strData.Replace("\"", "'");
                ResponseJSON(Context.Server.UrlEncode(strData));
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetLineData(string iDate, string AgentID, string GraphID, string ConString)
    {
        try
        {
            //if (AgentID != "")
            {
                DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
                if (dtG != null && dtG.Rows.Count > 0)
                {
                    DataTable dtData = new DataTable("dtData");
                    string Query = "";
                    if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                    {
                        string Agent = "AgentID";
                        if (AgentID != "0")
                            Agent = "AgentID";
                        //Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("where", "where Date=" + Date + " and " + Agent + id).Replace("WHERE", "where Date=" + Date + " and " + Agent + id).Replace("Where", "where Date=" + Date + " and " + Agent + id);
                        Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("@Date", iDate).Replace("@AgentID", Agent);
                        if (Query != null && Query.Length > 0)
                            Query = Query.Replace("delete ", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                        dtData = DAL.DAL.RunQuery(Query);

                    }
                    else if (dtG.Rows[0]["QueryType"].ToString() == "Stored procedure")
                    {
                        dtData = DAL.DAL.RunSP(dtG.Rows[0]["GraphQuery"].ToString(), "Date:" + iDate + ";AgentID:" + AgentID, ConString);
                    }
                    else if (dtG.Rows[0]["QueryType"].ToString() == "View")
                    {
                        string Agent = " AgentID=AgentID";
                        if (AgentID != "0")
                            Agent = " AgentID=" + AgentID;
                        //if (id != "")
                        Query = "Select * from " + dtG.Rows[0]["GraphQuery"].ToString();
                        Query += " where Date=" + iDate + " and " + Agent;
                        dtData = DAL.DAL.RunQuery(Query);
                    }
                    DataTable dt = new DataTable();
                    if (dtData != null)
                    {
                        for (int j = 0; j < dtData.Rows.Count; j++)
                        {
                            if (dt.Columns[dtData.Rows[j]["Name"].ToString()] == null)
                                dt.Columns.Add(dtData.Rows[j]["Name"].ToString());
                        }

                        dt.Columns.Add("fillColor");
                        dt.Columns.Add("strokeColor");
                        dt.Columns.Add("title");

                        DataRow dr = dt.NewRow();
                        for (int j = 0; j < dtData.Rows.Count; j++)
                        {
                            dr[dtData.Rows[j]["Name"].ToString()] = dtData.Rows[j]["Total"].ToString();
                        }
                        dr["fillColor"] = "\"" + dtData.Rows[0]["fillColor1"].ToString() + "\"";
                        dr["strokeColor"] = "\"" + dtData.Rows[0]["strokeColor1"].ToString() + "\"";
                        dr["title"] = "\"" + dtData.Rows[0]["Title1"].ToString() + "\"";

                        dt.Rows.Add(dr);

                        dr = dt.NewRow();
                        for (int j = 0; j < dtData.Rows.Count; j++)
                        {
                            dr[dtData.Rows[j]["Name"].ToString()] = dtData.Rows[j]["Total2"].ToString();
                        }
                        dr["fillColor"] = "\"" + dtData.Rows[0]["fillColor2"].ToString() + "\"";
                        dr["strokeColor"] = "\"" + dtData.Rows[0]["strokeColor2"].ToString() + "\"";
                        dr["title"] = "\"" + dtData.Rows[0]["Title2"].ToString() + "\"";

                        dt.Rows.Add(dr);
                    }


                    System.Web.Script.Serialization.JavaScriptSerializer serializer = new

                   System.Web.Script.Serialization.JavaScriptSerializer();

                    string strData = "";

                    strData = "var dd = {labels: [";
                    int i = 0;
                    for (i = 0; i < dt.Columns.Count; i++)
                    {
                        if (dt.Columns[i].ColumnName != "title" && dt.Columns[i].ColumnName != "fillColor" && dt.Columns[i].ColumnName != "strokeColor" && dt.Columns[i].ColumnName != "pointColor" && dt.Columns[i].ColumnName != "pointStrokeColor")
                            strData += "'" + dt.Columns[i].ColumnName + "', ";
                    }
                    i = 0;
                    if (strData[strData.Length - 2].ToString() == ",")
                        strData = strData.Substring(0, strData.Length - 2);
                    strData += "],datasets:[";

                    for (i = 0; i < dt.Rows.Count; i++)
                    {
                        strData += "{";
                        int j = 0;
                        for (j = 0; j < dt.Columns.Count; j++)
                        {
                            if (!(dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor"))
                                strData += dt.Columns[j].ColumnName.ToString() + ":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                        }
                        if (j > 0 && strData.Length > 2)
                            strData = strData.Substring(0, strData.Length - 1);
                        strData += "data: [";
                        for (j = 0; j < dt.Columns.Count; j++)
                        {
                            if (dt.Columns[j].ColumnName != "title" && dt.Columns[j].ColumnName != "fillColor" && dt.Columns[j].ColumnName != "strokeColor" && dt.Columns[j].ColumnName != "pointColor" && dt.Columns[j].ColumnName != "pointStrokeColor")
                                strData += dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                        }
                        if (strData[strData.Length - 2].ToString() == ",")
                            strData = strData.Substring(0, strData.Length - 2);
                        strData += "]},";
                    }
                    if (i > 0 && strData.Length > 2)
                        strData = strData.Substring(0, strData.Length - 1);
                    strData += " ] };";

                    strData = strData.Replace("\"", "'");
                    ResponseJSON(Context.Server.UrlEncode(strData));
                }
            }
            //else
            //{
            //    ResponseJSON(Context.Server.UrlEncode(""));
            //}
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public DataTable GetAgentSalesGraphDT(string iDate, string AgentID, string ConString)
    {
        return DAL.DAL.GetAgentSalesGraph(iDate, AgentID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgentsForYafora(string ConString)
    {
        DataTable dt = DAL.DAL.GetAgentsForYafora(ConString);
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GroupNames(string ConString)
    {
        try
        {
            DataTable dt = DAL.DAL.GetGroups(ConString);

            ResponseJSON((GetJson(dt)));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddEditGridWidgets(string id, string WidgetID, string WidgetName, string Path, string GroupID, string UserID, string ConString)
    {
        return DAL.DAL.AddEditGridWidgets(id, WidgetID, WidgetName, Path, GroupID, UserID, ConString);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetYaforaYazranPieRep(string Date, string AgentID, string ConString)
    {
        try
        {
            DataTable dtR = DAL.DAL.GetYaforaYazranPieRep(Date, AgentID, ConString);
            DataTable dt = new DataTable();
            if (dtR.Rows.Count > 0)
            {
                dt.Columns.Add("value");
                dt.Columns.Add("color");
                dt.Columns.Add("title");

                DataRow dr;
                dr = dt.NewRow();
                dr["value"] = dtR.Rows[0]["SumH_TotYofora"].ToString();
                dr["color"] = "\"#584A5E\"";
                dr["title"] = "\"יפאורה\"";
                dt.Rows.Add(dr);

                dr = dt.NewRow();
                dr["value"] = dtR.Rows[0]["SumH_TotEnGedy"].ToString();
                dr["color"] = "\"#7D4F6D\"";
                dr["title"] = "\"עין גדי\"";
                dt.Rows.Add(dr);

                dr = dt.NewRow();
                dr["value"] = dtR.Rows[0]["SumH_TotMeyEden"].ToString();
                dr["color"] = "\"#21323D\"";
                dr["title"] = "\"מי עדן\"";
                dt.Rows.Add(dr);
            }
            //DataRow dr = dt.NewRow();
            //dr["value"] = "7";
            //dr["color"] = "\"#584A5E\"";
            //dr["title"] = "\"ינואר\"";
            //dt.Rows.Add(dr);

            //dr = dt.NewRow();
            //dr["value"] = "84";
            //dr["color"] = "\"#7D4F6D\"";
            //dr["title"] = "\"פברואר\"";
            //dt.Rows.Add(dr);

            //dr = dt.NewRow();
            //dr["value"] = "33";
            //dr["color"] = "\"#21323D\"";
            //dr["title"] = "\"מרץ\"";
            //dt.Rows.Add(dr);

            //dr = dt.NewRow();
            //dr["value"] = "44";
            //dr["color"] = "\"#C7604C\"";
            //dr["title"] = "\"אפריל\"";
            //dt.Rows.Add(dr);

            //dr = dt.NewRow();
            //dr["value"] = "67";
            //dr["color"] = "\"#D97041\"";
            //dr["title"] = "\"מאי\"";
            //dt.Rows.Add(dr);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new

           System.Web.Script.Serialization.JavaScriptSerializer();

            string strData = "";

            strData = "mydata2 = [";
            int i = 0;

            for (i = 0; i < dt.Rows.Count; i++)
            {
                strData += "{";

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    strData += dt.Columns[j].ColumnName.ToString() + ":" + dt.Rows[i][dt.Columns[j].ColumnName].ToString() + ", ";
                }
                strData += "},";
            }
            strData += "]";

            ResponseJSON(Context.Server.UrlEncode(strData));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetPieRep(string Date, string AgentID, string GraphID, string ConString)
    {
        bool isEWcxc = false;
        try
        {
            DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
            if (dtG != null && dtG.Rows.Count > 0)
            {
                string id = "";
                string Query = "";
                if (HttpContext.Current.Request.QueryString["id"] != null)
                    id = HttpContext.Current.Request.QueryString["id"].ToString();

                DataTable dt = new DataTable("dt");
                if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                {
                    string Agent = "AgentID";
                    if (AgentID != "0")
                        Agent = "AgentID";
                    //Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("where", "where Date=" + Date + " and " + Agent + id).Replace("WHERE", "where Date=" + Date + " and " + Agent + id).Replace("Where", "where Date=" + Date + " and " + Agent + id);
                    Query = dtG.Rows[0]["GraphQuery"].ToString().Replace("@Date", Date).Replace("@AgentID", Agent);
                    if (Query != null && Query.Length > 0)
                        Query = Query.Replace("delete ", "").Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");

                    dt = DAL.DAL.RunQuery(Query);

                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "Stored procedure")
                {
                    dt = DAL.DAL.RunSP(dtG.Rows[0]["GraphQuery"].ToString(), "Date:" + Date + ";AgentID:" + AgentID, ConString);
                }
                else if (dtG.Rows[0]["QueryType"].ToString() == "View")
                {
                    string Agent = " AgentID=AgentID";
                    if (AgentID != "0")
                        Agent = " AgentID=" + AgentID;
                    //if (id != "")
                    Query = dtG.Rows[0]["GraphQuery"].ToString();
                    Query += " where Date=" + Date + " and " + Agent + id;
                    dt = DAL.DAL.RunQuery("Select * from " + Query);
                }
                dt.Columns["value"].ColumnName = "value";
                dt.Columns["title"].ColumnName = "title";
                int i = 0;

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

                strData += "];SetPie(Data, DataNames);";

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
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetManagerHeadData(string ManagerID)
    {
        return DAL.DAL.GetManagerHeadData(ManagerID);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetManagerGridData(string ManagerID, string RequestStatus, string Period)
    {
        try
        {
            DataTable dt = DAL.DAL.GetManagerGridData(ManagerID, RequestStatus, Period);
            ResponseJSON(GetJson(dt));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool SetManagerGridData(string RequestID, string RequestStatus, string ManagerComment)
    {
        return DAL.DAL.SetManagerGridData(RequestID, RequestStatus, ManagerComment);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetProjectTypes()
    {
        ResponseJSON(GetJson(GetProjectTypesDT()));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetProjectTypesDT()
    {
        return DAL.DAL.GetProjectTypes();
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetUserGroups()
    {
        return DAL.DAL.GetUserGroups();
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgentVersions(bool isToRefresh)
    {
        try
        {
            DataTable AgentVersions = (DataTable)cacheObj.Get("AgentVersions");
            if (AgentVersions == null || isToRefresh)
            {
                AgentVersions = GetAPKVergions(System.Configuration.ConfigurationManager.AppSettings["AgentsAPKs"].ToString());
                cacheObj.Add("AgentVersions", AgentVersions);
                return AgentVersions;
            }
            else
            {
                return AgentVersions;
            }
        }
        catch (Exception ex)
        {
        }
        return new DataTable("dt");
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgentVersionsLayout(bool isToRefresh)
    {
        try
        {
            DataTable AgentVersions = (DataTable)cacheObj.Get("AgentVersionsLayout");
            if (AgentVersions == null || isToRefresh)
            {
                AgentVersions = GetLasyoutFilesVergions(System.Configuration.ConfigurationManager.AppSettings["AgentsAPKsLayout"].ToString());
                cacheObj.Add("AgentVersionsLayout", AgentVersions);
                return AgentVersions;
            }
            else
            {
                return AgentVersions;
            }
        }
        catch (Exception ex)
        {
        }
        return new DataTable("dt");
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetManagerVersions(bool isToRefresh)
    {
        DataTable ManagerVersions = (DataTable)cacheObj.Get("ManagerVersions");
        if (ManagerVersions == null || isToRefresh)
        {
            ManagerVersions = GetAPKVergions(System.Configuration.ConfigurationManager.AppSettings["ManagersAPKs"].ToString());
            cacheObj.Add("ManagerVersions", ManagerVersions);
            return ManagerVersions;
        }
        else
        {
            return ManagerVersions;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetManagerVersionsLayout(bool isToRefresh)
    {
        DataTable ManagerVersions = (DataTable)cacheObj.Get("ManagerVersionsLayout");
        if (ManagerVersions == null || isToRefresh)
        {
            ManagerVersions = GetLasyoutFilesVergions(System.Configuration.ConfigurationManager.AppSettings["ManagersAPKsLayout"].ToString());
            cacheObj.Add("ManagerVersionsLayout", ManagerVersions);
            return ManagerVersions;
        }
        else
        {
            return ManagerVersions;
        }
    }

    private DataTable GetAPKVergions(string APKDirectory)
    {
        DataTable dt = new DataTable("GetAPKVergions");
        dt.Columns.Add("Version");
        dt.Columns.Add("VersionID");

        DirectoryInfo di = new DirectoryInfo(APKDirectory);
        FileInfo[] filesList = null;
        try
        {
            filesList = di.GetFiles("*", SearchOption.AllDirectories);

            DataRow dr = dt.NewRow();
            dr["Version"] = " ";
            dr["VersionID"] = "NULL";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["Version"] = "*";
            dr["VersionID"] = "*";
            dt.Rows.Add(dr);

            for (int i = 0; i < filesList.Length; i++)
            {
                dr = dt.NewRow();
                dr["Version"] = filesList[i].Name.ToLower().Replace("mtn_", "").Replace(".apk", "");
                dr["VersionID"] = dr["Version"].ToString();
                dt.Rows.Add(dr);
            }
            DataView dv = dt.DefaultView;
            dv.Sort = "Version Asc";
            dt = dv.ToTable();
        }
        catch (UnauthorizedAccessException e)
        {
            Tools.HandleError(e, LogDir);
            throw e;
        }
        return dt;
    }
    private DataTable GetLasyoutFilesVergions(string APKDirectory)
    {
        DataTable dt = new DataTable("GetLasyoutFilesVergions");
        dt.Columns.Add("Version");
        dt.Columns.Add("VersionID");

        DirectoryInfo di = new DirectoryInfo(APKDirectory);
        FileInfo[] filesList = null;
        try
        {
            filesList = di.GetFiles("*", SearchOption.AllDirectories);

            DataRow dr = dt.NewRow();
            dr["Version"] = " ";
            dr["VersionID"] = "NULL";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["Version"] = "*";
            dr["VersionID"] = "*";
            dt.Rows.Add(dr);

            for (int i = 0; i < filesList.Length; i++)
            {
                dr = dt.NewRow();
                dr["Version"] = filesList[i].Name.ToLower().Replace("mtn_", "").Replace(".zip", "");
                dr["VersionID"] = dr["Version"].ToString();
                dt.Rows.Add(dr);
            }
            DataView dv = dt.DefaultView;
            dv.Sort = "Version Asc";
            dt = dv.ToTable();
        }
        catch (UnauthorizedAccessException e)
        {
            Tools.HandleError(e, LogDir);
            throw e;
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetAgents(string ConString)
    {
        return DAL.DAL.GetAgents(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetGroups(string ConString)
    {
        return DAL.DAL.GetGroups(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetGraphsForGrid(string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.GetGraphsForGrid(ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool IsGraphNameExsits(string GraphName, string ConString)
    {
        return DAL.DAL.IsGraphNameExsits(GraphName, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddEditGraph(string id, string Name, string Query, string QueryType, string Params, string Promt, string GraphType, string UserID, string ConString)
    {
        return DAL.DAL.AddEditGraph(id, Name, Query, QueryType, Params, Promt, GraphType, UserID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetGridJump(string GridName, string id, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.GetGridJump(GridName, id, ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetNumerators(string ConString)
    {
        ResponseJSON(GetJsonForNumertors(DAL.DAL.GetNumerators(ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetNumeratorsDT(string ConString)
    {
        return DAL.DAL.GetNumerators(ConString);
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
    public DataTable GetNumeratorsCols(string ConString)
    {
        return DAL.DAL.GetNumeratorsCols(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet GetSalesDDls(string AgentID, string Cust_Key, string FamilyId, string ItemID, string ConString)
    {
        return DAL.DAL.GetSalesDDls(AgentID, Cust_Key, FamilyId, ItemID, ConString);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetRGHBarData(string GraphID, string GridParameters, string ConString)
    {
        try
        {
            DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
            if (dtG != null && dtG.Rows.Count > 0)
            {
                DataTable dtData = new DataTable("dtData");
                string Query = "";
                if (dtG.Rows[0]["QueryType"].ToString() == "Query")
                {
                    string Agent = "AgentID";
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

                DataTable dt = new DataTable();

                System.Web.Script.Serialization.JavaScriptSerializer serializer = new

               System.Web.Script.Serialization.JavaScriptSerializer();

                string strData = "";
                strData = " labels = [";
                for (int i = 0; i < dtData.Rows.Count; i++)
                {
                    strData += "\"" + dtData.Rows[i]["Name"].ToString().Replace("\"", "").Replace("'", "") + "\",";
                }
                if (dtData.Rows.Count > 0 && strData.Length > 1)
                    strData = strData.Substring(0, strData.Length - 1);
                strData += "];";

                strData += " data = [";
                for (int i = 0; i < dtData.Rows.Count; i++)
                {
                    strData += "[" + dtData.Rows[i]["Total"].ToString() + ",";
                    strData += dtData.Rows[i]["Total2"].ToString() + "],";
                }
                if (dtData.Rows.Count > 0 && strData.Length > 1)
                    strData = strData.Substring(0, strData.Length - 1);
                strData += "];";



                strData = strData.Replace("\"", "'");
                ResponseJSON(Context.Server.UrlEncode(strData));
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
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
    public DataTable GetSPData(string GraphID, string Date, string AgentID, string ConString)
    {
        DataTable dtG = DAL.DAL.GetGraph(GraphID, ConString);
        if (dtG != null && dtG.Rows.Count > 0)
        {
            return DAL.DAL.RunSP(dtG.Rows[0]["GraphQuery"].ToString(), "Date:" + Date + ";AgentID:" + AgentID, ConString);
        }
        return new DataTable();
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
    public void GetSalesMeterChart(string Date, string AgentID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.GetSalesMeterChart(Date, AgentID, ConString)));
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
    public DataTable Layout_GetForms(string LayoutTypeID, string ConString)
    {
        return DAL.DAL.Layout_GetForms(LayoutTypeID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetDocTypes(string LayoutTypeID, string ConString)
    {
        return DAL.DAL.Layout_GetDocTypes(LayoutTypeID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetFormsByProjectID(string LayoutTypeID, string ProjectID, string ConString)
    {
        return DAL.DAL.Layout_GetFormsByProjectID(LayoutTypeID, ProjectID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetTypes(string ConString)
    {
        return DAL.DAL.Layout_GetTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetForm(string FormID, string LayoutTypeID, string FormName, string FormDescription, string IsShowUpdateTime, string IsTabAlwaysOnTop, string IsActive, string TabAlignmentID, string UserID,
        string ProjectID, string IsScroll, string ConString)
    {
        return DAL.DAL.Layout_SetForm(FormID, LayoutTypeID, FormName, FormDescription, IsShowUpdateTime, IsTabAlwaysOnTop, IsActive, TabAlignmentID, UserID, ProjectID, IsScroll, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetFormData(string FormID, string ConString, string LayoutTypeID)
    {
        ResponseJSON(GetJson(DAL.DAL.Layout_GetFormData(FormID, ConString, LayoutTypeID)));
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetFormTabs(string LayoutTypeID, string FormID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Layout_GetFormTabs(LayoutTypeID, FormID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetTabAlignments(string ConString)
    {
        return DAL.DAL.Layout_GetTabAlignments(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetTabsByForm(string FormID, string ConString)
    {
        return DAL.DAL.Layout_GetTabsByForm(FormID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetFormTab(string FormID, string TabID, string TabName, string TabDescription, string TabOrder, string IsActive, string UserID, string ConString, string LayoutTypeID, string FiltersJson)
    {
        return DAL.DAL.Layout_SetFormTab(FormID, TabID, TabName, TabDescription, TabOrder, IsActive, UserID, ConString, LayoutTypeID, FiltersJson);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetTabData(string TabID, string ConString)
    {
        return DAL.DAL.Layout_GetTabData(TabID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetFormReport(string ReportID, string ReportName, string ReportQuery, string Report_SP_Params, string ReportCaption, string ReportDataSourceID,
           string ReportTypeID, string IsActive, string UserID, out string NewReportID,
           string FragmentName, string FragmentDescription, string FragmentTypeID, string FragmentHasCloseButton, string HeaderZoomObjTypeID, string HeaderZoomObjID,
           string RowReportZoomObjTypeID, string RowReportZoomObjID, string ConString, string LayoutTypeID, string IsZebra, string IsLastRowFooter, string HasSubTotals,
           string IsToShowRowsNumberOnTitle, string RowsPerPage, string GroupBy, string HasSubTotalsOnGroup, string ShowActionBattonOnTitle, string ActionBattonOnTitleText,
           string ActionBattonOnTitleReportZoomObjTypeID, string ActionBattonOnTitleReportZoomObjID, string SectionsPerRow, string SectionsRowHeight, string IsToShowSectionFrame, string SectionImageHeightWeight, string IsWebInternal,
           string tableToEdit, string AllowAdd, string AllowEdit, string AllowDelete, string ChosenTemplet, string FragmentID, string Extra1, string Extra2, string Extra3, string Extra4, string Extra5)
    {
        return DAL.DAL.Layout_SetFormReport(ReportID, ReportName, ReportQuery, Report_SP_Params, ReportCaption, ReportDataSourceID,
           ReportTypeID, IsActive, UserID, out NewReportID, FragmentName, FragmentDescription, FragmentTypeID, FragmentHasCloseButton, HeaderZoomObjTypeID, HeaderZoomObjID
           , RowReportZoomObjTypeID, RowReportZoomObjID, ConString, LayoutTypeID, IsZebra, IsLastRowFooter, HasSubTotals, IsToShowRowsNumberOnTitle, RowsPerPage, GroupBy, HasSubTotalsOnGroup
           , ShowActionBattonOnTitle, ActionBattonOnTitleText, ActionBattonOnTitleReportZoomObjTypeID, ActionBattonOnTitleReportZoomObjID, SectionsPerRow, SectionsRowHeight, IsToShowSectionFrame
           , SectionImageHeightWeight, IsWebInternal, tableToEdit, AllowAdd, AllowEdit, AllowDelete, ChosenTemplet, FragmentID, Extra1, Extra2, Extra3, Extra4, Extra5);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetReportTypes(string ConString)
    {
        return DAL.DAL.Layout_GetReportTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetReportsDataSources(string ConString)
    {
        return DAL.DAL.Layout_GetReportsDataSources(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetZoomObjTypes(string ConString)
    {
        return DAL.DAL.Layout_GetZoomObjTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetCompileActivities(string ConString)
    {
        return DAL.DAL.Layout_GetCompileActivities(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetReports(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetReports(ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetReportCols(string ReportID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Layout_GetReportCols(ReportID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetReportColsDT(string ReportID, string ConString)
    {
        return DAL.DAL.Layout_GetReportCols(ReportID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet Layout_GetDDLs(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetDDLs(ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetReportCol(string ColID, string ReportID, string ColName, string ColCaption, string ColOrder, string ColWidthWeight, string ColTypeID
            , string FormatID, string AlignmentID, string ColMaxLength, string StyleID, string FilterID, string ColIsSummary, string IsActive, string UserID, string ConString, string langID, string colCaptionTrans)
    {
        return DAL.DAL.Layout_SetReportCol(ColID, ReportID, ColName, ColCaption, ColOrder, ColWidthWeight, ColTypeID
            , FormatID, AlignmentID, ColMaxLength, StyleID, FilterID, ColIsSummary, IsActive, UserID, ConString, langID, colCaptionTrans);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetAllReports(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetAllReports(ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetFragmentsToTabsByJson(string FormID, string JsonObj, string UserID, string ConString)
    {
        var temp = DAL.DAL.Layout_SetFragmentsToTabsByJson(FormID, JsonObj, UserID, ConString);
        return temp;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool LayoutManager_CreateXML(string TabID, string UserID, string connectionString)
    {
        bool IsCreateLayoutXML = false;
        IsCreateLayoutXML = LayoutManager.XMLLayoutHandler.CreateLayoutXML(connectionString, TabID, UserID);
        return LayoutManager.AndroidLayoutCreator.CreateLayoutXML(connectionString, TabID, UserID) && IsCreateLayoutXML;
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable LayoutXML_GetDataForXML(string TabID, string connectionString)
    {
        //string connectionString = ConfigurationManager.ConnectionStrings[
        //                                        "WebConnectionString"].ConnectionString;
        return DAL.DAL.LayoutXML_GetDataForXML(TabID, connectionString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool LayoutXML_SaveHTMLToTab(string TabID, string LayoutHTML, string UserID, string ConString)
    {
        return DAL.DAL.LayoutXML_SaveHTMLToTab(TabID, LayoutHTML, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetReportData(string ReportID, string ConString)
    {
        ResponseJSON(GetJsonForQueries(DAL.DAL.Layout_GetReportData(ReportID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetReportDataDT(string ReportID, string ConString)
    {
        return DAL.DAL.Layout_GetReportData(ReportID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetProjects(string ConString)
    {
        return DAL.DAL.Layout_GetProjects(ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable ManagerLogin(string ManagerID, string Password)
    {
        return DAL.DAL.ManagerLogin(ManagerID, Password);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetManagerAuthorizationGroupActivitiesForWeb(string EmployeeId)
    {
        return DAL.DAL.GetManagerAuthorizationGroupActivitiesForWeb(EmployeeId);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetMenusForWeb(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetMenusForWeb(ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetMenusForWeb(string MenuID, string MenuName, string MenuDescription, string isActive, string UserID, string ConString, string LayoutTypeID, string ViewType)
    {
        return DAL.DAL.Layout_SetMenusForWeb(MenuID, MenuName, MenuDescription, isActive, UserID, ConString, LayoutTypeID, ViewType);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetMenuDataForWeb(string LayoutTypeID, string MenuID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Layout_GetMenuDataForWeb(LayoutTypeID, MenuID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetMenuItemsForGridWeb(string MenuID, string ConString)
    {
        DataTable dt = DAL.DAL.Layout_GetMenuItemsForGridWeb(MenuID, ConString);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["Img"] != DBNull.Value)
                dt.Rows[i]["ImgReal"] = Convert.ToBase64String((byte[])dt.Rows[i]["Img"]);
            dt.Rows[i]["Img"] = DBNull.Value;
        }

        ResponseJSON(GetJson(dt));
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetMenuItem(string MenuItemID, string MenuID, string Description, string ZoomObjTypeID, string ZoomObjectID, string ImgID, string SortOrder, string IsActive, string UserID, string ConString)
    {
        return DAL.DAL.Layout_SetMenuItem(MenuItemID, MenuID, Description, ZoomObjTypeID, ZoomObjectID, ImgID, SortOrder, IsActive, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetMenuItemData(string MenuItemID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Layout_GetMenuItemData(MenuItemID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetAllImages(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetAllImages(ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetImageByID(string ImgID, string ConString)
    {
        return DAL.DAL.Layout_GetImageByID(ImgID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetImagesForGrid(string LayoutTypeID, string ConString)
    {
        DataTable dt = DAL.DAL.Layout_GetImagesForGrid(LayoutTypeID, ConString);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ImgBlob"] != DBNull.Value)
                dt.Rows[i]["ImgReal"] = Convert.ToBase64String((byte[])dt.Rows[i]["ImgBlob"]);
            dt.Rows[i]["ImgBlob"] = DBNull.Value;
        }

        ResponseJSON(GetJson(dt));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Layout_SetImage(string ImgID, string ImgName, byte[] ImgBlob, string ImgExtension, string ImgHeight, string ImgWidth, string IsActive, string UserID, string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_SetImage(ImgID, ImgName, ImgBlob, ImgExtension, ImgHeight, ImgWidth, IsActive, UserID, ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetImageData(string ImgID, string ConString)
    {
        DataTable dt = DAL.DAL.Layout_GetImageData(ImgID, ConString);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ImgBlob"] != DBNull.Value)
                dt.Rows[i]["ImgReal"] = Convert.ToBase64String((byte[])dt.Rows[i]["ImgBlob"]);
            dt.Rows[i]["ImgBlob"] = DBNull.Value;
        }

        ResponseJSON(GetJson(dt));
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
                if (dt.Rows[i]["NumeratorValue"].ToString().Length > AgentID.Length)
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

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetImageByName(string ConString, string ImgName)
    {
        return DAL.DAL.Layout_GetImageByName(ConString, ImgName);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetQuestionnaires(string ConString)
    {
        return DAL.DAL.Layout_GetQuestionnaires(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetPartsForDDL(string ConString)
    {
        return DAL.DAL.Prn_GetPartsForDDL(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetPartTypes(string ConString)
    {
        return DAL.DAL.Prn_GetPartTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetQueries(string ConString)
    {
        return DAL.DAL.Prn_GetQueries(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Prn_GetQuery(string ConString, string idQuery)
    {
        ResponseJSON(GetJsonForQueries(DAL.DAL.Prn_GetQuery(ConString, idQuery)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Prn_GetPartData(string ConString, string idPart)
    {
        ResponseJSON(GetJsonForQueries(DAL.DAL.Prn_GetPartData(ConString, idPart)));
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Prn_SetQueryData(string idQuery, string QueryName, string Query, string UserID, string isToDelete, string ConString)
    {
        return DAL.DAL.Prn_SetQueryData(idQuery, QueryName, Query, UserID, isToDelete, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Prn_SetPartData(string idPart, string PartName, string idPartType, string idQuery, string UserID, string isToDelete, string TopicID, string hasHeaderSeparator, string hasFooterSeparator, string SelectedImg, string ConString)
    {
        return DAL.DAL.Prn_SetPartData(idPart, PartName, idPartType, idQuery, UserID, isToDelete, TopicID, hasHeaderSeparator, hasFooterSeparator, SelectedImg, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Prn_GetPartCols(string idPart, string ConString)
    {
        if (idPart == "null")
            idPart = "0";
        ResponseJSON(GetJsonForQueries(DAL.DAL.Prn_GetPartCols(idPart, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet Prn_GetPartColsDDLs(string ConString)
    {
        return DAL.DAL.Prn_GetPartColsDDLs(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Prn_GetPartColData(string PartColID, string ConString)
    {
        ResponseJSON(GetJsonForQueries(DAL.DAL.Prn_GetPartColData(PartColID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Prn_SetColData(string PartColID, string idPart, string ColName, string ColCaption, string ColOrder, string ColWidth, string ColTypeID, string FormatID, string AlignmentID,
            string ColMaxLength, string StyleID, string ColIsSummary, string UserID, string isToDelete, string NewRow, string ConString)
    {
        return DAL.DAL.Prn_SetColData(PartColID, idPart, ColName, ColCaption, ColOrder, ColWidth, ColTypeID, FormatID, AlignmentID,
            ColMaxLength, StyleID, ColIsSummary, UserID, isToDelete, NewRow, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetPartAndColsData(string idPart, string ConString)
    {
        return DAL.DAL.Prn_GetPartAndColsData(idPart, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetColTypes(string ConString)
    {
        return DAL.DAL.Prn_GetColTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetPartColStyle(string StyleID, string ConString)
    {
        return DAL.DAL.Prn_GetPartColStyle(StyleID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetReports(string ConString)
    {
        return DAL.DAL.Prn_GetReports(ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Prn_SetReport(string id, string reportName, string reportDesc, string rowLen, string IsToDelete, string UserID, string ConString)
    {
        return DAL.DAL.Prn_SetReport(id, reportName, reportDesc, rowLen, IsToDelete, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Prn_GetReportData(string id, string ConString)
    {
        ResponseJSON(GetJsonForQueries(DAL.DAL.Prn_GetReportData(id, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public bool Prn_SetPartsToReport(string strJson, string strHTM, string UserID, string ConString)
    {
        return DAL.DAL.Prn_SetPartsToReport(strJson, strHTM, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string prn_GetReportAllData(string ReportID, string ConString)
    {
        DataTable dt = DAL.DAL.prn_GetReportAllData(ReportID, ConString);
        if (dt != null && dt.Rows.Count > 0)
        {
            return dt.Rows[0]["HTMLLayout"].ToString();
        }
        return "";
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetTopics(string ConString)
    {
        return DAL.DAL.Prn_GetTopics(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetPartsByTopicID(string TopicID, string ConString)
    {
        return DAL.DAL.Prn_GetPartsByTopicID(TopicID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string prn_GetReportRowLen(string ReportID, string ConString)
    {
        DataTable dt = DAL.DAL.prn_GetReportRowLen(ReportID, ConString);
        if (dt != null && dt.Rows.Count > 0)
        {
            return dt.Rows[0]["rowLen"].ToString();
        }
        return "";
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Prn_SetDuplicateReport(string DuplicateFromReportCode, string DuplicateToReportName, string UserID, string ConString)
    {
        return DAL.DAL.Prn_SetDuplicateReport(DuplicateFromReportCode, DuplicateToReportName, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Prn_SetDuplicatePart(string DuplicateFromPartID, string DuplicateToPartName, string UserID, string ConString)
    {
        return DAL.DAL.Prn_SetDuplicatePart(DuplicateFromPartID, DuplicateToPartName, UserID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Layout_GetProfileComponents(string ConString, string LayoutTypeID)
    {
        ResponseJSON(GetJson(DAL.DAL.Layout_GetProfileComponents(ConString, LayoutTypeID)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet Layout_GetProfileDDLs(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetProfileDDLs(ConString, LayoutTypeID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Layout_SetProfileData(string ProfileComponentsID, string ProfileTypeID, string ProfileName, string FormLayoutID, string MenuID,
        string IsToDelete, string UserID, string ConString, string LayoutTypeID, string OrderMenuID, string ReceiptMenuID, string ProfileID)
    {
        return DAL.DAL.Layout_SetProfileData(ProfileComponentsID, ProfileTypeID, ProfileName, FormLayoutID, MenuID, IsToDelete, UserID, ConString, LayoutTypeID, OrderMenuID, ReceiptMenuID, ProfileID);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void VerLayout_GetAllChanges(string ConString, string LayoutTypeID)
    {
        ResponseJSON(GetJson(DAL.DAL.VerLayout_GetAllChanges(ConString, LayoutTypeID)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string VerLayout_SetNewVersion(string VersionID, string VersionName, string VersionDescription, string UserID, string LayoutTypeID, string ConString)
    {
        return DAL.DAL.VerLayout_SetNewVersion(VersionID, VersionName, VersionDescription, UserID, LayoutTypeID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string VerLayout_SuggestNewVersionID(string ConString)
    {
        return DAL.DAL.VerLayout_SuggestNewVersionID(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void VerLayout_GetAllVersions(string LayoutTypeID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.VerLayout_GetAllVersions(LayoutTypeID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string VerLayout_CheckForNewVersion(string ConString)
    {
        return DAL.DAL.VerLayout_CheckForNewVersion(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string VerLayout_SetReplaceWorkingLayout(string ToVersionID, string UserID, string Pass, string ConString)
    {
        return DAL.DAL.VerLayout_SetReplaceWorkingLayout(ToVersionID, UserID, Pass, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetFilterControls(string TabID, string ConString)
    {
        return DAL.DAL.Layout_GetFilterControls(TabID, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void GetServerLayoutVersionForUI(string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.GetServerLayoutVersionForUI(ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public DataTable GetDemoPritim(string ConString)
    {
        return DAL.DAL.GetDemoPritim(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public DataTable GetDemoCustomers(string ConString)
    {
        return DAL.DAL.GetDemoCustomers(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public DataTable GetDemoItems(string ConString)
    {
        return DAL.DAL.GetDemoItems(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public DataTable getDataTable(string Q, string pass, bool isSp, string Params, string ConString)
    {
        DataTable dt = new DataTable();

        if (pass != "mtns2015")
            return new DataTable();
        if (!isSp)
        {
            dt = DAL.DAL.RunQuery(Q, ConString);
            dt.TableName = "dt7";
            return dt;
        }
        else
        {
            dt = DAL.DAL.RunSP(Q, Params, ConString);
            dt.TableName = "dt7";
            return dt;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void Layout_GetUsersProfileComponents(string LayoutTypeID, string ConString)
    {
        DataTable dt = DAL.DAL.Layout_GetUsersProfileComponents(LayoutTypeID, ConString);
        dt.Columns.Add("strDefult");

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["Defult"] != DBNull.Value)
            {
                if (dt.Rows[i]["Defult"].ToString() == "1")
                    dt.Rows[i]["strDefult"] = "עיקרי";
                else
                    dt.Rows[i]["strDefult"] = "משני";
            }

        }
        ResponseJSON(GetJson(dt));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public string Layout_SetUserData(string Name, string Description, string UserName, string Password, string Profileid, string Defult, string IsToDelete, string MPUserID, string UserID,
           string LayoutTypeID, string UserProfileID, string MobileProfileid, string ConString)
    {
        return DAL.DAL.Layout_SetUserData(Name, Description, UserName, Password, Profileid, Defult, IsToDelete, MPUserID, UserID,
           LayoutTypeID, UserProfileID, MobileProfileid, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet Layout_GetProfilesDDL(string LayoutTypeID, string IsAgent, string ConString)
    {
        return DAL.DAL.Layout_GetProfilesDDL(LayoutTypeID, IsAgent, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetViewTypes(string ConString)
    {
        return DAL.DAL.Layout_GetViewTypes(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool CheckIfAPKExists(string FileName)
    {
        bool retVal = false;
        try
        {
            string Dir = System.Configuration.ConfigurationManager.AppSettings["AgentsAPKs"].ToString();

            DirectoryInfo di = new DirectoryInfo(Dir);
            FileInfo[] filesList = null;
            filesList = di.GetFiles("*", SearchOption.AllDirectories);
            for (int i = 0; i < filesList.Length; i++)
            {
                if (filesList[i].Name.ToLower() == FileName)
                    return true;
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return retVal;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool UploadAPK(string FileName, byte[] FileBytes)
    {
        bool retVal = true;
        try
        {
            string Dir = System.Configuration.ConfigurationManager.AppSettings["AgentsAPKs"].ToString();

            DirectoryInfo di = new DirectoryInfo(Dir);
            FileInfo[] filesList = null;

            File.WriteAllBytes(Dir + "\\" + FileName, FileBytes);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return retVal;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void Test_GetItems(string ConString)
    {
        ResponseJSON(GetJson2(DAL.DAL.Test_GetItems(ConString)));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public void Prn_GetReportParams(string reportCode, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Prn_GetReportParams(reportCode, ConString)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Prn_GetParameterTypes(string ConString)
    {
        return DAL.DAL.Prn_GetParameterTypes(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string Prn_Set_ReportParameter(string ReportParameterID, string reportCode, string ParameterName, string ParameterDescription, string ParameterDefaultValue, string ParameterOrder, string ParamterTypeID, string ParamQuery,
            string UserID, string IsToDelete, string ConString)
    {
        return DAL.DAL.Prn_Set_ReportParameter(ReportParameterID, reportCode, ParameterName, ParameterDescription, ParameterDefaultValue, ParameterOrder, ParamterTypeID, ParamQuery,
            UserID, IsToDelete, ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable B2B_GetSubGroups(string ConString)
    {
        return DAL.DAL.B2B_GetSubGroups(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable B2B_GetOrderItems(string ConString)
    {
        return DAL.DAL.B2B_GetOrderItems(ConString);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable B2B_GetOrderItems2(string AnafsAndGroups, string ConString)
    {
        return DAL.DAL.B2B_GetOrderItems2(AnafsAndGroups, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet GetTableDefinitionsTableName(string ConString)
    {
        return DAL.DAL.GetTableDefinitionsTableName(ConString);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataSet GetFilterdTypes(string ConString)
    {
        return DAL.DAL.GetFilterdTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLSections(string ConString)
    {
        return DAL.DAL.Frg_GetDDLSections(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLSectionTypes(string ConString)
    {
        return DAL.DAL.Frg_GetDDLSectionTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLSectionAligns(string ConString)
    {
        return DAL.DAL.Frg_GetDDLSectionAligns(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLSectionStyles(string ConString)
    {
        return DAL.DAL.Frg_GetDDLSectionStyles(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLSectionFormats(string ConString)
    {
        return DAL.DAL.Frg_GetDDLSectionFormats(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Frg_SetSectionData(string SectionID, string SectionName, string SectionDescription, string SectionValue, string LayoutTypeID, string SectionTypeID
           , string SectionAlignID, string SectionMaxLength, string StyleID, string FormatID, string UserID, string IsToDelete, string ConString)
    {
        ResponseJSON(DAL.DAL.Frg_SetSectionData(SectionID, SectionName, SectionDescription, SectionValue, LayoutTypeID, SectionTypeID
           , SectionAlignID, SectionMaxLength, StyleID, FormatID, UserID, IsToDelete, ConString));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Frg_GetSectionData(string SectionID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Frg_GetSectionData(SectionID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLFrgments(string ConString)
    {
        return DAL.DAL.Frg_GetDDLFrgments(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Frg_SetFragmentData(string FragmentID, string FragmentName, string FragmentDescription, string FragmentHTMLLayout, string FragmentSectionsJson, string LayoutTypeID, string FragmentWidth
            , string FragmentHeight, string FragmentBackColor, string OrderReportID, string FragmentProfiles, string IsShadow, string IsRounded, string UserID, string IsToDelete, string ConString)
    {
        return (DAL.DAL.Frg_SetFragmentData(FragmentID, FragmentName, FragmentDescription, FragmentHTMLLayout, FragmentSectionsJson, LayoutTypeID, FragmentWidth
            , FragmentHeight, FragmentBackColor, OrderReportID, FragmentProfiles, IsShadow, IsRounded, UserID, IsToDelete, ConString));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Frg_GetFragmentData(string FragmentID, string ConString)
    {
        ResponseJSON(GetJson(DAL.DAL.Frg_GetFragmentData(FragmentID, ConString)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLProfiles(string LayoutTypeID, string ConString)
    {
        return DAL.DAL.Frg_GetDDLProfiles(LayoutTypeID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_Layout_GetLayoutTypes(string ConString)
    {
        return DAL.DAL.Frg_Layout_GetLayoutTypes(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Frg_SetSettingsData(string SettingID, string LayoutTypeID, string ItemFragment, string CategoryReportID, string ItemReportID, string FragmentMarginsPX
            , string DefaultCategory, string UserID, string CategoryLevels, string CategoryFragment1, string CategoryFragment2, string CategoryFragment3, string CategoryFragment4,
        string EditWinFormID, string EditWinFieldID, string EditWinFieldPriceID, string EditWinFieldName, string EditWinFieldProdHierarchy1, string EditWinFieldProdHierarchy2, string EditWinFieldProdHierarchy3,
        string EditWinFieldProdHierarchy4, string UserProfileID, string ConString)
    {
        return DAL.DAL.Frg_SetSettingsData(SettingID, LayoutTypeID, ItemFragment, CategoryReportID, ItemReportID, FragmentMarginsPX
            , DefaultCategory, UserID, CategoryLevels, CategoryFragment1, CategoryFragment2, CategoryFragment3, CategoryFragment4, EditWinFormID, EditWinFieldID, EditWinFieldPriceID, EditWinFieldName
            , EditWinFieldProdHierarchy1, EditWinFieldProdHierarchy2, EditWinFieldProdHierarchy3, EditWinFieldProdHierarchy4, UserProfileID, ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void Frg_GetSettingsData(string ConString, string LayoutTypeID)
    {
        ResponseJSON(GetJson(DAL.DAL.Frg_GetSettingsData(ConString, LayoutTypeID)));
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Layout_SetDuplicateReport(string DuplicateFromReportCode, string DuplicateToReportName, string UserID, string ConString, string NewDB)
    {
        return DAL.DAL.Layout_SetDuplicateReport(DuplicateFromReportCode, DuplicateToReportName, UserID, ConString, NewDB);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public string Layout_SetDuplicateForm(string DuplicateFromFormCode, string DuplicateToFormName, string UserID, string ConString, string NewDB)
    {
        return DAL.DAL.Layout_SetDuplicateForm(DuplicateFromFormCode, DuplicateToFormName, UserID, ConString, NewDB);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Frg_GetDDLRelationships(string ConString)
    {
        return DAL.DAL.Frg_GetDDLRelationships(ConString);
    }
    [WebMethod(MessageName = "FrgLayout_GetDDLFrgments")]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable FrgLayout_GetDDLFrgments(string ConString)
    {
        return DAL.DAL.FrgLayout_GetDDLFrgments(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable Layout_GetPDFForms(string ConString, string LayoutTypeID)
    {
        return DAL.DAL.Layout_GetPDFForms(ConString, LayoutTypeID);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public List<Language> MP_GetLanguageChoose(string ConString)
    {
        return DAL.DAL.MP_GetLanguageChoose(ConString);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public List<ReportsTextSource> GetTranslatedData(int? langID, long? rowID, string conString)
    {
        return DAL.DAL.MP_GetReportsTextSource(langID, rowID, conString);
    }


    
}


