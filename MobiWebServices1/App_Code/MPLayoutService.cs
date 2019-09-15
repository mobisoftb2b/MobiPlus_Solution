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
using MobiPlusTools;
using System.IO;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class MPLayoutService : System.Web.Services.WebService
{
    private string LogDir = "";

    public MPLayoutService()
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
    public void MPUserLogin(string UserName, string Password, string ConString)
    {
        ResponseJSON(GetJson(DAL.LayoutDAL.MPUserLogin(UserName, Password, ConString)));
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
    public DataTable MPLayout_GetReportData(string ReportID, string VersionID, string ConString)
    {
        return DAL.LayoutDAL.MPLayout_GetReportData(ReportID, VersionID, ConString);
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
    public DataTable MPLayout_GetQueryDataForControl(string ReportID, string VersionID, string ConString)
    {
        DataTable dt = DAL.LayoutDAL.MPLayout_GetQueryData(ReportID, VersionID, ConString);
        DataTable dtData = new DataTable();

        if (dt != null && dt.Rows.Count > 0)
        {
            dtData = DAL.LayoutDAL.RunQuery(dt.Rows[0]["ReportQuery"].ToString(), ConString);
        }
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
            DataTable dtG = MPLayout_GetReportData(GraphID, VersionID, ConString);
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
            DataTable dtG = MPLayout_GetReportData(GraphID, VersionID, ConString);
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
                            if (dt.Rows[u][g].ToString() != "" && Convert.ToDouble(dt.Rows[u][g].ToString()) + 100 > mScale)
                                mScale += Convert.ToDouble(dt.Rows[u][g].ToString()) + 100;
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
                    maxScale = "maxScale=" + (mScale * dt.Columns.Count / 5).ToString() + ";";

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

        DataTable dtG = MPLayout_GetReportData(GraphID, VersionID, ConString);
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
            dtReport, dtTaskEnd, ConditionID, TaskNotes, ParentsPopulation, ItemsPopulation, UnCheckedPopulation, IsToDelete, UserID, TaskStatusID, dtStatus,DateFrom, DateTo, AlarmDate, ConString);
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
    public DataTable GetAgents(string ConString)
    {
        return DAL.DAL.GetAgents(ConString);
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
    public void MPLayout_GetQueryDataByName2(string Params,string ReportName, string VersionID, string ConString)
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
        return DAL.LayoutDAL.MPLayout_GetAgentMap(AgentID,Date, VersionID, ConString);
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
}
