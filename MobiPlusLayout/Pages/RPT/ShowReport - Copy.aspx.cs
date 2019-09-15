using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;

public partial class Pages_RPT_ShowReport : PageBaseCls
{
    public string ReportID = "";
    public string ReportName = "";
    public string colNames = "";
    public string colModel = "";
    public string Width = "";
    public string Height = "";
    public string Caption = "";
    public string ControlKey = "ControlKey";
    public string WinID = "WinID";
    public string Params = "";
    public string IsCtl = "False";
    public string RowNum = "";
    public string IsZebra = "false";
    public string RowOpenReport = "0";
    public string RowOpenForm = "0";
    public string JsonString = "";
    public string GroupBy = "";
    public string isToShowGroups = "false";
    public string HasSubTotalsOnGroup = "false";
    public string IsToShowRowsNumberOnTitle = "false";
    public string url = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["ID"] != null)
                ReportID = Request.QueryString["ID"].ToString();

            if (Request.QueryString["Width"] != null)
                Width = Request.QueryString["Width"].ToString();

            if (Request.QueryString["Height"] != null)
                Height = Request.QueryString["Height"].ToString();

            if (Request.QueryString["WinID"] != null)
                WinID = Request.QueryString["WinID"].ToString();

             if (Request.QueryString["Name"] != null)
                 ReportName = Request.QueryString["Name"].ToString();

            init();
        }
    }
    private void init()
    {
        

        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
        }

        MPLayoutService WR = new MPLayoutService();
        DataTable dt=new DataTable();
        if (ReportName == "")
        {
            dt = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
            url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataJSON&ReportID=" + ReportID + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString();
        }
        else
        {
            dt = WR.MPLayout_GetReportDataByName(ReportName, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
            url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataByNameJSON&ReportName=" + ReportName + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString();
        }

        if (dt!=null && dt.Rows.Count > 0 && dt.Rows[0]["ReportTypeID"].ToString() == "5")
        {
            Response.Redirect(dt.Rows[0]["ReportQuery"].ToString() + "?" + Params.Replace(";","&")+"g=1");
        }
        //if (Convert.ToDouble(Width) > 1200)
        //Width = (Convert.ToDouble(Width) -37).ToString();
       // Height = (Convert.ToDouble(Height) - 76).ToString();
        //Height = (Convert.ToDouble(Height) - 40).ToString();

        if (Request.QueryString["Height"] != null)
        {
            //RowNum = (Convert.ToDouble(Request.QueryString["Height"].ToString()) / 32.7 - 3).ToString();
            RowNum = "30";
        }
        if (dt.Rows.Count>0 && dt.Rows[0]["RowsPerPage"].ToString() != "")
        {
            RowNum = dt.Rows[0]["RowsPerPage"].ToString();
        }
        hdnIsLastRowFooter.Value = "False";
        if (dt.Rows.Count > 0 &&  dt.Rows[0]["IsLastRowFooter"].ToString() == "1")
        {
            hdnIsLastRowFooter.Value = "True";
        }
        //DataTable dtAll = MPLayout_GetReportDataJSON(ReportID, SessionVersionID, Params);
        //sJsonString = Server.UrlDecode(GetJson(dtAll));
        //hdnJson.Value = JsonString;
        string[] asrrStyles = new string[1];// null;// GetAllStyles(dtAll);

        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsZebra"].ToString() == "1")
                IsZebra = "true";

            GroupBy = dt.Rows[0]["GroupBy"].ToString();
            if (GroupBy != "")
            {
                isToShowGroups = "true";
            }

            if (dt.Rows[0]["HasSubTotalsOnGroup"].ToString() == "1")
            {
                HasSubTotalsOnGroup="true";
            }

            if (dt.Rows[0]["HeaderZoomObjTypeID"].ToString() == "2"/*report*/ && dt.Rows[0]["HeaderZoomObjID"].ToString() != "")
                Caption = "<div id='dCaption' onclick='parent.openNewReport(" + dt.Rows[0]["HeaderZoomObjID"].ToString() + ");'  style='cursor:pointer;'>" + dt.Rows[0]["ReportCaption"].ToString() + "</div>";
            else if (dt.Rows[0]["HeaderZoomObjTypeID"].ToString() == "5"/*form*/ && dt.Rows[0]["HeaderZoomObjID"].ToString() != "")
                Caption = "<div id='dCaption' onclick='parent.openNewForm(" + dt.Rows[0]["HeaderZoomObjID"].ToString() + ");'  style='cursor:pointer;'>" + dt.Rows[0]["ReportCaption"].ToString() + "</div>";
            else if (dt.Rows[0]["HeaderZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dt.Rows[0]["HeaderZoomObjID"].ToString() != "")
                Caption = "<div id='dCaption' onclick='parent.openNewReport(" + ReportID + ");'  style='cursor:pointer;'>" + dt.Rows[0]["ReportCaption"].ToString() + "</div>";
            else
                Caption = "<div id='dCaption'>" + dt.Rows[0]["ReportCaption"].ToString() + "</div>";

            if (dt.Rows[0]["IsToShowRowsNumberOnTitle"].ToString() == "1")
            {
                IsToShowRowsNumberOnTitle = "True";
            }

            if (dt.Rows[0]["RowReportZoomObjTypeID"].ToString() == "2"/*report*/ && dt.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenReport = dt.Rows[0]["RowReportZoomObjID"].ToString();
            else if (dt.Rows[0]["RowReportZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dt.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenReport = ReportID;
            else if (dt.Rows[0]["RowReportZoomObjTypeID"].ToString() == "5"/*form*/ && dt.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenForm = dt.Rows[0]["RowReportZoomObjID"].ToString();
            else
                RowOpenReport = "0";

            switch (dt.Rows[0]["ReportTypeID"].ToString())
            {
                case "1"://Grid
                    colNames = "";
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        colNames += "'" + dt.Rows[i]["ColCaption"].ToString() + "'";
                        if (i + 1 < dt.Rows.Count)
                            colNames += ",";
                    }

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        var Key = "STYLE_" + dt.Rows[i]["ColName"].ToString();
                        if (!isThereStyle(dt, Key))
                        {
                            colNames += ",'" + Key + "'";
                        }
                    }


                    colModel = "";
                    hdnGridStyles.Value = "";
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        colModel += "{name: \"" + dt.Rows[i]["ColName"].ToString() + "\", index: \"" + dt.Rows[i]["ColName"].ToString() + "\", width: " + Convert.ToDouble(Width) * ((Convert.ToDouble(dt.Rows[i]["ColWidthWeight"].ToString()) / 100) - 0.0008) + ", align: \"" + dt.Rows[i]["Alignment"].ToString() + "\", editable: true,";

                        if (Convert.ToDouble(dt.Rows[i]["ColWidthWeight"].ToString()) == 0)
                            colModel += " hidden: true,";
                        string mysum = "mysum";
                        if (dt.Rows[i]["ColIsSummary"].ToString() != "1")
                            mysum = "summaryType";

                        if (dt.Rows[i]["ColTypeID"].ToString() == "6")//image
                            colModel += "formatter: ImageFormatter, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["ColTypeID"].ToString() == "7")//progress bar
                            colModel += "formatter: BarFormatter, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "STRING_0")
                            colModel += "stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "STRING")
                            colModel += "stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "0.00%")
                            colModel += "formatter: PercentFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "מספר שלם")
                            colModel += "formatter: NumbersFormatter, stype: \"int\",sorttype: \"int\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "1,000.00")
                            colModel += "formatter: NumbersFormatter, stype: \"int\",sorttype: \"int\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "1,000.00%")
                            colModel += "formatter: PercentFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "yyymmdd  > dd/mm/yyyy")//yyyymmdd
                            colModel += "formatter: DateFormatteryyyymmdd, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "100 שח")
                            colModel += "formatter: MoneyFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "ddmmyyy > dd/mm/yy")
                            colModel += "formatter: DateFormatterddmmyyy, stype: \"date\",sorttype: \"text\",summaryType:" + mysum + ",classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "yyyymmdd > dd/mm/yy")
                            colModel += "formatter: DateFormatteryyyymmdd, stype: \"date\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "HHmmss  > HH:mm")
                            colModel += "formatter: TimeFormatterHHmmss, stype: \"date\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "1,000")
                            colModel += "formatter: FormatterInt, stype: \"int\",sorttype: \"int\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dt.Rows[i]["FormatString"].ToString() == "1,000%")
                            colModel += "formatter: PercentFormatterInt, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,";
                       

                        colModel = colModel.Substring(0, colModel.Length - 1);

                        colModel += "}";
                        if (i + 1 < dt.Rows.Count)
                            colModel += ",";

                        hdnGridStyles.Value += dt.Rows[i]["ColName"].ToString() + ":" + dt.Rows[i]["StyleName"].ToString() + ";";

                        if (dt.Rows[i]["ColIsSummary"].ToString() == "1" && dt.Rows[0]["IsLastRowFooter"].ToString() != "1")
                        {
                            hdnIsSummery.Value = hdnIsSummery.Value + dt.Rows[i]["ColName"].ToString() + ";";
                            
                            if (Request.QueryString["Height"] != null)
                            {
                                Height = Request.QueryString["Height"].ToString();
                                //Height = (Convert.ToDouble(Height) - 97).ToString();

                                //RowNum = (Convert.ToDouble(Request.QueryString["Height"].ToString()) / 22.7 - 4).ToString();

                                if (dt.Rows[0]["RowsPerPage"].ToString() != "")
                                {
                                    RowNum = dt.Rows[0]["RowsPerPage"].ToString();
                                }
                            }
                            
                        }
                        if (dt.Rows[0]["IsLastRowFooter"].ToString() == "1")
                        {
                            if (Request.QueryString["Height"] != null && hdnFooterRow.Value=="")
                            {
                                Height = Request.QueryString["Height"].ToString();
                                //Height = (Convert.ToDouble(Height) - 97).ToString();

                                //RowNum = (Convert.ToDouble(Request.QueryString["Height"].ToString()) / 22.7 - 4).ToString();
                                if (dt.Rows[0]["RowsPerPage"].ToString() != "")
                                {
                                    RowNum = dt.Rows[0]["RowsPerPage"].ToString();
                                }

                            }
                            hdnFooterRow.Value = hdnFooterRow.Value + dt.Rows[i]["ColName"].ToString() + ";";
                        }
                    }

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        var Key = "STYLE_" + dt.Rows[i]["ColName"].ToString();
                        if (!isThereStyle(dt, Key))
                        {
                            colModel += ",{name: \"" + Key + "\", index: \"" + Key + "\", width: 0, sorttype: \"text\", align: \"right\", editable: true, hidden: true}";
                            hdnGridStyles.Value += Key + ";";
                        }
                    }
                    
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowGrid();", "setTimeout('ShowGrid();',100);", true);
                    break;

            }

        }

    }
    private bool isThereStyle(DataTable dt, string style)
    {
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ColName"].ToString() == style)
                return true;
        }
        return false;
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
            //Tools.HandleError(ex, LogDir);
        }
        return serializer.Serialize(rows);
    }
    private DataTable MPLayout_GetReportDataJSON(string ReportID, string VersionID, string Params)
    {
         MPLayoutService WR = new MPLayoutService();
         DataTable dt = WR.MPLayout_GetQueryDataDT(ReportID, VersionID, Params, ConStrings.DicAllConStrings[SessionProjectName]);
     
        return dt;
        //ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private string[] GetAllStyles(DataTable dt)
    {
        string[] arr = new string[dt.Columns.Count];
        int counter = 0;
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            if (dt.Columns[i].ColumnName.ToString().IndexOf("STYLE_") > -1)
            {
                arr[counter] = dt.Columns[i].ColumnName;
                counter++;
            }
        }
        //dt
        //Query = Query.Replace("STYLE_", "^");
        //string[] arr = new string[Query.Split('^').Length - 1];
        //int counter = 0;
        //for (int i = 0; i < Query.Length; i++)
        //{
        //    if (Query[i] == '^')
        //    {
        //        arr[counter] = Query.Substring(i, Query.Length - i);
        //        arr[counter] = arr[counter].Substring(0, arr[counter].IndexOf(" ") == -1 ? arr[counter].Length : arr[counter].IndexOf(" "));
        //        i += arr[counter].Length - 1;
        //        counter++;
        //    }
        //}

        return arr;
    }
}