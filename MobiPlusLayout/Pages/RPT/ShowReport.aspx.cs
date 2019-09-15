using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Web.UI.HtmlControls;
using ClosedXML.Excel;
using System.IO;
using System.Configuration;
using MobiPlusTools;
using System.Linq;

public partial class Pages_RPT_ShowReport : PageBaseCls
{
    public string ReportID = "";
    public string withSearch = "true";
    public string ReportName = "";
    public string AllowAdd = "false";
    public string AllowEdit = "false";
    public string AllowDelete = "false";
    public string ReportEditByTbl = "";
    public string TableName = "";
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
    public string RowOpenRoutes = "0";
    public string JsonString = "";
    public string GroupBy = "";
    public string isToShowGroups = "false";
    public string HasSubTotalsOnGroup = "false";
    public string IsToShowRowsNumberOnTitle = "false";
    public string url = "";
    public string Lang = "";
    public string ColDelimiter = "^";
    public static DataTable dtStyles;
	private ClientScriptManager csm;


    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (Request.QueryString["ID"] != null)
            ReportID = Request.QueryString["ID"].ToString();

        if (Request.QueryString["Name"] != null)
            ReportName = Request.QueryString["Name"].ToString();

        if (!IsPostBack)
        {
		csm = this.ClientScript;
            if (Request.QueryString["Width"] != null)
                Width = Request.QueryString["Width"].ToString();

            if (Request.QueryString["Height"] != null)
                Height = Request.QueryString["Height"].ToString();

            if (Request.QueryString["WinID"] != null)
                WinID = Request.QueryString["WinID"].ToString();

            if(ConfigurationManager.AppSettings["GridColDelimiter"]!=null)
                ColDelimiter = ConfigurationManager.AppSettings["GridColDelimiter"].ToString();

            init();
        }
    }
    protected void btnDownloadXlsx_Click(object sender, EventArgs e1)
    {
        MPLayoutService WR = new MPLayoutService();
        Dictionary<string, DataTable> dic = HandlerBaseCls.SessionGridDictionary;//(Dictionary<string, DataTable>)SessionGridDictionary;

        if (dic == null)
            dic = new Dictionary<string, DataTable>();


        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
        }
        DataTable dtRep = new DataTable();
        if (ReportName == "")
        {
            try
            {
                dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDirectory);
            }
        }
        else
        {
            dtRep = WR.MPLayout_GetReportDataByName(ReportName, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtRep != null && dtRep.Rows.Count > 0)
            {
                ReportID = dtRep.Rows[0]["ReportID"].ToString();
                Params = "";
                arKeys = Request.QueryString.AllKeys;
                for (int i = 0; i < Request.QueryString.Count; i++)
                {
                    if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "Name")
                        Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
                }
            }
        }






        DataTable dtRepNew = new DataTable();
        DataTable dtExcel = new DataTable();
		
	    //this section adds 2 colums ServiceHoursTime,ServiceHoursTime by spliting original colums values
        string dictionaryKey = "220";
        if (dic.ContainsKey(dictionaryKey))
        {

            if (dic[dictionaryKey].Columns.Contains("ServiceHoursTime") == false)
                dic[dictionaryKey].Columns.Add("ServiceHoursTime", typeof(String)).SetOrdinal(11);
            if (dic[dictionaryKey].Columns.Contains("TravelHoursTime") == false)
                dic[dictionaryKey].Columns.Add("TravelHoursTime", typeof(String)).SetOrdinal(10);

            foreach (DataRow row in dic[dictionaryKey].Rows)
            {
                string[] TravelHoursArr = row[9].ToString().Split('^');
                string TravelHours = TravelHoursArr[0];
                string TravelHoursTime = TravelHoursArr.Length > 1 ? TravelHoursArr[1] : "";

                string[] ServiceHoursArr = row[11].ToString().Split('^');
                string ServiceHours = ServiceHoursArr[0];
                string ServiceHoursTime = ServiceHoursArr.Length > 1 ? ServiceHoursArr[1] : "";

                row["TravelHoursTime"] = TravelHoursTime;
                row["TravelHours"] = TravelHours;
                row["ServiceHoursTime"] = ServiceHoursTime;
                row["ServiceHours"] = ServiceHours;
            }
            //end of section
        }
        		
        if (dic.TryGetValue(ReportID, out dtRepNew))
        {
            int colCounter = 0;
            int colCounter2 = 1;
            DataView dv = dtRep.DefaultView;
            dv.Sort = "ColOrder";
            dtRep = dv.ToTable();
            for (int e = 0; e < dtRep.Rows.Count; e++)
            {
                try
                {
                    colCounter = GetColCounterByCols(dtRep.Rows[e]["ColName"].ToString(), dtRepNew, dtRep.Rows[e]["ColWidthWeight"].ToString());

                    if (colCounter > -1)
                    {
                        dtExcel.Columns.Add(dtRep.Rows[e]["ColCaption"].ToString(), typeof(string));
                        colCounter++;
                    }
                    else
                    {
                    }
                }
                catch (Exception ex)
                {
                    if(dtRep.Rows[e]["ColWidthWeight"].ToString()!="0")
                        dtExcel.Columns.Add(dtRep.Rows[e]["ColCaption"].ToString() + colCounter2.ToString(), typeof(string));
                    colCounter++;
                    colCounter2++;
                    Tools.HandleError(ex, LogDirectory);
                }
            }
            //for (int e = 0; e < dtRepNew.Columns.Count; e++)
            //{
            //    try
            //    {
            //        colCounter = GetColCounter(dtRepNew.Columns[e].ColumnName, dtRep);

            //        if (colCounter>-1)
            //        {
            //            dtExcel.Columns.Add(dtRep.Rows[colCounter]["ColCaption"].ToString(), typeof(string));
            //            colCounter++;
            //        }
            //        else
            //        {
            //        }
            //    }
            //    catch(Exception ex)
            //    {
            //        dtExcel.Columns.Add(dtRep.Rows[colCounter]["ColCaption"].ToString()+ colCounter2.ToString(), typeof(string));
            //        colCounter++;
            //        colCounter2++;
            //    }
            //}
            for (int t = 0; t < dtRepNew.Rows.Count; t++)
            {
                DataRow dr = dtExcel.NewRow();

                //for (int e = 0; e < dtRepNew.Columns.Count; e++)
                {
                    colCounter = 0;
                    for (int e = 0; e < dtRepNew.Columns.Count; e++)
                    {
                        //if (Convert.ToDouble(dtRep.Rows[colCounter]["ColWidthWeight"].ToString()) != 0 )
                        {
                            try
                            {
                                int colCounter3 = GetColCounterByCols(dtRep.Rows[e]["ColName"].ToString(), dtRepNew, dtRep.Rows[e]["ColWidthWeight"].ToString());
                                colCounter = GetColCounter(dtRep.Rows[e]["ColName"].ToString(), dtRep);
                                if (colCounter3 > -1 )
                                {
                                    if (dtRep.Rows[colCounter]["ColTypeID"].ToString() == "7")//progress bar
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString() + "%"; //colModel += "formatter: BarFormatter, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                                    else if (dtRep.Rows[colCounter]["ColTypeID"].ToString() == "8")//checkbox  
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString();
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "STRING_0")
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString();
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "STRING")
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString();
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "0.00%")
                                        dr[colCounter] = Convert.ToDouble(dtRepNew.Rows[t][colCounter3].ToString()).ToString("N2") + "%";
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "מספר שלם")
                                        dr[colCounter] = Convert.ToDouble(dtRepNew.Rows[t][colCounter3].ToString()).ToString("N0");
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "1,000.00")
                                        dr[colCounter] = Convert.ToDouble(dtRepNew.Rows[t][colCounter3].ToString()).ToString("N2");
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "1,000.00%")
                                        dr[colCounter] = Convert.ToDouble(dtRepNew.Rows[t][colCounter3].ToString()).ToString("N2") + "%";
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "yyymmdd  > dd/mm/yyyy")//yyyymmdd
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString().Substring(6, 2) + "/" + dtRepNew.Rows[t][colCounter3].ToString().Substring(4, 2) + "/" + dtRepNew.Rows[t][colCounter3].ToString().Substring(0, 4);
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "100 שח")
                                        dr[colCounter] = "₪ " + Convert.ToDouble(dtRepNew.Rows[t][colCounter3].ToString()).ToString("N2");
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "1,000.00 שח")
                                        dr[colCounter] = Convert.ToDouble(dtRepNew.Rows[t][colCounter3].ToString()).ToString("N0");

                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "ddmmyyy > dd/mm/yy")
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString().Substring(0, 2) + "/" + dtRepNew.Rows[t][colCounter3].ToString().Substring(2, 2) + "/" + dtRepNew.Rows[t][colCounter3].ToString().Substring(6, 2);
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "yyyymmdd > dd/mm/yy")
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString().Substring(6, 2) + "/" + dtRepNew.Rows[t][colCounter3].ToString().Substring(4, 2) + "/" + dtRepNew.Rows[t][colCounter3].ToString().Substring(0, 4);
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "HHmmss  > HH:mm")
                                    {
                                        if (Convert.ToInt32(dtRepNew.Rows[t][e].ToString().Substring(0, 2)) <= 23)
                                            dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString().Substring(0, 2) + ":" + dtRepNew.Rows[t][colCounter3].ToString().Substring(2, 2);
                                    }
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "1,000")
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString();
                                    else if (dtRep.Rows[colCounter]["FormatString"].ToString() == "1,000%")
                                        dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString() + "%";
                                    //colCounter++;
                                }
                                //else
                                //{
                                //    dr[colCounter] = dtRepNew.Rows[t][colCounter3].ToString();
                                //}
                            }
                            catch (Exception ex)
                            {
                                Tools.HandleError(ex, LogDirectory);
                            }

                        }
                    }
                }
                dtExcel.Rows.Add(dr);
            }

            if (dic.ContainsKey(dictionaryKey))
            {
                dtExcel.Columns.Add(new DataColumn("שעות נסיעה - זמן", typeof(string)));
                dtExcel.Columns.Add(new DataColumn("שעות שירות - זמן", typeof(string)));
                for (int i = 0; i < dtExcel.Rows.Count; i++)
                {
                    dtExcel.Rows[i]["שעות שירות - זמן"] = dic[dictionaryKey].Rows[i]["ServiceHoursTime"].ToString();
                    dtExcel.Rows[i]["שעות נסיעה - זמן"] = dic[dictionaryKey].Rows[i]["TravelHoursTime"].ToString();
                }
            }

            using (XLWorkbook wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dtExcel, "GridData");

                HttpResponse httpResponse = Response;
                httpResponse.Clear();
                httpResponse.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                httpResponse.AddHeader("content-disposition", "attachment;filename=\"GridData.xlsx\"");

                // Flush the workbook to the Response.OutputStream
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    wb.SaveAs(memoryStream);
                    memoryStream.WriteTo(httpResponse.OutputStream);
                    memoryStream.Close();
                }

                httpResponse.End();
            }
        }
        //wb.SaveAs("c:\\gg.xlsx");
    }
    private int GetColCounter(string ColName,DataTable dtRep)
    {
        int colCounter = 0;
        for (int i = 0; i < dtRep.Rows.Count; i++)
        {
            if (dtRep.Rows[i]["ColName"].ToString() == ColName && dtRep.Rows[i]["ColWidthWeight"].ToString()!="0")
                return colCounter;

            if (dtRep.Rows[i]["ColWidthWeight"].ToString() != "0")
                colCounter++;
        }
        return -1;
    }
    private int GetColCounterByCols(string ColName, DataTable dtRep,string width)
    {
        if (width != "0")
        {
            for (int i = 0; i < dtRep.Columns.Count; i++)
            {
                if (dtRep.Columns[i].ColumnName.ToString() == ColName)
                    return i;
            }
        }
        return -1;
    }
    protected void btnSetFilters_Click(object sender, EventArgs e)
    {
        MPLayoutService WR = new MPLayoutService();
        DataTable dtRep = new DataTable();
        if (ReportName == "")
        {
            dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
            //ColumnName, string Value
            url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataJSON&ReportID=" + ReportID + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString() + "&ColumnName=cnn&Value=vall";
        }
        else
        {
            dtRep = WR.MPLayout_GetReportDataByName(ReportName, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
            url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataByNameJSON&ReportName=" + ReportName + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString() + "&ColumnName=cnn&Value=vall";
        }
        SetFilters(dtRep);
    }
    private void init()
    {
        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "UserID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
            else if(arKeys[i] == "UserID")
                Params += arKeys[i] + "=" + SessionUserID + ";";
        }



        MPLayoutService WR = new MPLayoutService();
        DataTable dtRep = new DataTable();


        if (ReportName == "")
        {
            try
            {
                dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDirectory);
            }

            //ColumnName, string Value
            url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataJSON&ReportID=" + ReportID + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString() + "&ColumnName=cnn&Value=vall";
        }
        else
        {
            dtRep = WR.MPLayout_GetReportDataByName(ReportName, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
            //url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataByNameJSON&ReportName=" + ReportName + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString();
            if (dtRep != null && dtRep.Rows.Count > 0)
            {
                Params = "";
                arKeys = Request.QueryString.AllKeys;
                for (int i = 0; i < Request.QueryString.Count; i++)
                {
                    if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "Name")
                        Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
                }
                url = "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetReportDataJSON&ReportID=" + dtRep.Rows[0]["ReportID"].ToString() + "&VersionID=" + SessionVersionID + "&Params=" + Params + "&Tiks=" + DateTime.Now.Ticks.ToString() + "&ColumnName=cnn&Value=vall";
            }
        }

        DataTable dt = new DataTable();
        if (TableName == "")
        {
            if (dt != null && dtRep.Rows.Count > 0)
                TableName = dtRep.Rows[0]["ReportEditByTbl"].ToString();//"tmpDevGolan";
            dt = WR.GetTableDefinitions(ConStrings.DicAllConStrings[SessionProjectName], TableName);
            dt.DefaultView.Sort = string.Format("{0} {1}", dt.Columns["SortOrder"], "ASC");
            dt = dt.DefaultView.ToTable();
            //url = "../../Handlers/MainHandler.ashx?MethodName=GetJsonTableData&TableName=" + TableName + "&Tiks=" + DateTime.Now.Ticks.ToString();
        }

        if (dtRep != null && dtRep.Rows.Count > 0)
        {

            if ((dtRep.Rows[0]["AllowAdd"].ToString() != null && dtRep.Rows[0]["AllowAdd"].ToString() == "1") || (dtRep.Rows[0]["Extra5"].ToString().IndexOf("Add;")>-1) || (dtRep.Rows[0]["Extra5"].ToString().IndexOf("AddTask;") > -1))
                AllowAdd = "true";
            else
                AllowAdd = "false";
            if (dtRep.Rows[0]["Extra5"].ToString().Length > 0)
            {
                if (dtRep.Rows[0]["Extra5"].ToString().IndexOf("Add;") > -1)
                {
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ggss33();", "setTimeout('setAddUser();',1000);", true);

                }
                else if (dtRep.Rows[0]["Extra5"].ToString().IndexOf("AddTask;") > -1)
                {
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ggss331();", "setTimeout('setAddTask();',500);", true);

                }
            }

            if (dtRep.Rows[0]["AllowEdit"].ToString() != null && dtRep.Rows[0]["AllowEdit"].ToString() == "1")
                AllowEdit = "true";
            else
                AllowEdit = "false";

            if (dtRep.Rows[0]["AllowDelete"].ToString() != null && dtRep.Rows[0]["AllowDelete"].ToString() == "1")
                AllowDelete = "true";
            else
                AllowDelete = "false";
        }
        else
        {
            AllowAdd = "false";
            AllowEdit = "false";
            AllowDelete = "false";
        }

        if (dtRep != null && dtRep.Rows.Count > 0 && dtRep.Rows[0]["ReportTypeID"].ToString() == "5")
        {
            Response.Redirect(dtRep.Rows[0]["ReportQuery"].ToString() + "?" + Params.Replace(";", "&") + "g=1" + "&" + dtRep.Rows[0]["Extra1"].ToString());
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
        if (dtRep.Rows.Count > 0 && dtRep.Rows[0]["RowsPerPage"].ToString() != "")
        {
            RowNum = dtRep.Rows[0]["RowsPerPage"].ToString();
        }
        hdnIsLastRowFooter.Value = "False";
        if (dtRep.Rows.Count > 0 && dtRep.Rows[0]["IsLastRowFooter"].ToString() == "1")
        {
            hdnIsLastRowFooter.Value = "True";
        }
        //DataTable dtAll = MPLayout_GetReportDataJSON(ReportID, SessionVersionID, Params);
        //sJsonString = Server.UrlDecode(GetJson(dtAll));
        //hdnJson.Value = JsonString;
        string[] asrrStyles = new string[1];// null;// GetAllStyles(dtAll);
        #region from TableEdit

        myModalLabel.Attributes["title"] = TableName;
        hdnTableName.Value = TableName;
        // בניית התאים לפי משתנים 
        if (dt != null && dtRep != null && dtRep.Rows.Count > 0)
        {
            colNames = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (i == 0)
                    hdnParams.Value += dt.Rows[i]["ColumName"].ToString();
                else
                    hdnParams.Value += ";" + dt.Rows[i]["ColumName"].ToString();
            }
        }
        if (dtRep != null && dtRep.Rows.Count > 0)
        {
            if (dt != null)
            {
                HtmlGenericControl Tbl = new HtmlGenericControl("table");
                Tbl.Attributes["cellpadding"] = "0";
                Tbl.Attributes["cellspacing"] = "0";
                Tbl.Attributes["class"] = "SectionWidjet";

                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    HtmlGenericControl tr = new HtmlGenericControl("tr");

                    HtmlGenericControl tdColumName = new HtmlGenericControl("td");
                    HtmlGenericControl tdType = new HtmlGenericControl("td");
                    HtmlGenericControl tdValidation = new HtmlGenericControl("td");
                    tdColumName.Attributes["class"] = "tdPopup";
                    tdType.Attributes["class"] = "tdPopup";
                    tdValidation.Attributes["class"] = "tdPopup";
                    HtmlGenericControl txt = new HtmlGenericControl("span");
                    txt.InnerHtml = dt.Rows[i]["Description"].ToString() + ": &nbsp;";
                    tdColumName.Controls.Add(txt);
                    HtmlGenericControl input = new HtmlGenericControl("input");
                    HtmlGenericControl DDL = new HtmlGenericControl("select");

                    HtmlGenericControl prmToVld = new HtmlGenericControl("input");


                    prmToVld.Attributes["Type"] = "hidden";
                    prmToVld.Style["display"] = "none";
                    prmToVld.ID = ("prm" + dt.Rows[i]["ColumName"].ToString() + i).ToLower();
                    prmToVld.Attributes["value"] = "Type:" + dt.Rows[i]["Type"].ToString() + ";FromValue:" + dt.Rows[i]["FromValue"].ToString() + ";ToValue:" + dt.Rows[i]["ToValue"].ToString() + ";DecimalPoint:" + dt.Rows[i]["DecimalPoint"].ToString()
                        + ";MaxLength:" + dt.Rows[i]["MaxLength"].ToString() + ";IsMust:" + dt.Rows[i]["IsMust"].ToString();
                    tdColumName.Controls.Add(prmToVld);
                    input.Attributes["onkeyup"] = "openPop(this);";
                    DDL.Attributes["onchange"] = "openPop(this);";
                    DDL.Attributes["class"] = "select1";



                    if (i == 0)
                    {
                        if (dt.Rows[i]["IsReadOnly"].ToString() == "1")
                            hdnParamsType.Value += dt.Rows[i]["Type"].ToString() + "IsReadOnly";
                        else
                            hdnParamsType.Value += dt.Rows[i]["Type"].ToString();

                        if (dt.Rows[i]["IsPrimary"].ToString() == "1")
                            hdnPrimary.Value += dt.Rows[i]["ColumName"].ToString();

                    }
                    else
                    {
                        if (dt.Rows[i]["IsReadOnly"].ToString() == "1")
                            hdnParamsType.Value += ":" + dt.Rows[i]["Type"].ToString() + "IsReadOnly";
                        else
                            hdnParamsType.Value += ":" + dt.Rows[i]["Type"].ToString();

                        if (dt.Rows[i]["IsPrimary"].ToString() == "1")
                            hdnPrimary.Value += ";" + dt.Rows[i]["ColumName"].ToString();
                    }




                    input.Attributes["data-index"] = i.ToString();
                    switch (dt.Rows[i]["Type"].ToString())
                    {
                        case "text":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString().ToLower() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["class"] = "txtPopup check";
                            tdType.Controls.Add(input);
                            break;
                        case "int":
                        case "float":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString().ToLower() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["class"] = "txtPopup check numbers";
                            tdType.Controls.Add(input);
                            //
                            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "SetFieldOnlyNumbers();" + DateTime.Now.Ticks.ToString(), "setTimeout(\"SetFieldOnlyNumbers('numbers',true);\",1000);", true);
                            break;
                        case "Dateyyyymmdd":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString().ToLower() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["name"] = "Date";
                            input.Attributes["class"] = "yyyymmddPopup check";
                            tdType.Controls.Add(input);
                            break;
                        case "DateTime":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString().ToLower() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["class"] = "DateTimePopup check";
                            input.Attributes["name"] = "Date";
                            tdType.Controls.Add(input);
                            break;

                        case "boolean":
                            input.ID = "cxx" + dt.Rows[i]["ColumName"].ToString().ToLower() + i;
                            input.Attributes["type"] = "checkbox";
                            input.Attributes["class"] = "cxxPopup check";
                            tdType.Controls.Add(input);
                            break;
                        case "LOV":
                            DataTable dtQuery = new DataTable();

                            DDL.ID = "DDL" + dt.Rows[i]["ColumName"].ToString().ToLower() + i;
                            HtmlGenericControl Choose = new HtmlGenericControl("option");
                            if (i == 0)
                            {
                                Choose.Attributes["value"] = "-1";
                                Choose.InnerHtml = "בחר";
                                DDL.Controls.Add(Choose);
                            }

                            dtQuery = WR.GetDDLDefinitions(ConStrings.DicAllConStrings[SessionProjectName], dt.Rows[i]["Query"].ToString());
                            for (int j = 0; j < dtQuery.Rows.Count; j++)
                            {
                                HtmlGenericControl op = new HtmlGenericControl("option");
                                op.Attributes["value"] = dtQuery.Rows[j]["ID"].ToString();
                                op.InnerHtml = dtQuery.Rows[j]["Value"].ToString();
                                DDL.Controls.Add(op);
                            }

                            tdType.Controls.Add(DDL);
                            break;
                    }

                    HtmlGenericControl divPop = new HtmlGenericControl("div");
                    divPop.ID = "divPop_" + (dt.Rows[i]["ColumName"].ToString() + i.ToString()).ToLower();
                    HtmlGenericControl divArrow = new HtmlGenericControl("div");
                    //HtmlGenericControl h3Pop = new HtmlGenericControl("h3");
                    HtmlGenericControl divContent = new HtmlGenericControl("div");
                    divContent.ID = "divContent" + (dt.Rows[i]["ColumName"].ToString() + i).ToLower();
                    divPop.Attributes["style"] = " ";//top: 10px; left: 20%;//
                    divPop.Attributes["class"] = "popover fade top in";
                    divArrow.Attributes["class"] = "arrow";
                    //h3Pop.Attributes["class"] = "popover-title";
                    divContent.Attributes["class"] = "popover-content";
                    divContent.InnerHtml = "";
                    divPop.Controls.Add(divArrow);
                    //divPop.Controls.Add(h3Pop);
                    divPop.Controls.Add(divContent);
                    tdValidation.Controls.Add(divPop);

                    tr.Controls.Add(tdColumName);
                    tr.Controls.Add(tdType);
                    tr.Controls.Add(tdValidation);

                    Tbl.Controls.Add(tr);




                }
                EditBox.Controls.Add(Tbl);


                HtmlGenericControl divFooter = new HtmlGenericControl("div");
                divFooter.Attributes["class"] = "btnFooter";
                HtmlGenericControl btnSave = new HtmlGenericControl("input");
                btnSave.Attributes["Type"] = "button";
                btnSave.ID = "btn-success";
                btnSave.Attributes["value"] = "שמור / ערוך";
                btnSave.Disabled = true;
                btnSave.Attributes["class"] = "btn-success-disabled";
                btnSave.Attributes["onclick"] = "SetPopData('3');";
                divFooter.Controls.Add(btnSave);
                EditBox.Controls.Add(divFooter);





            }
        }

      SetFilters(dtRep);

        //SetSearchContralByCol


        #endregion
        if (dtRep != null && dtRep.Rows.Count > 0)
        {
            if(dtStyles == null)
                dtStyles = WR.MPLayout_GetReportStyles(SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
            hdnGridStylesByDB.Value = WR.GetJson(dtStyles);

            if (dtRep.Rows[0]["IsZebra"].ToString() == "1")
                IsZebra = "true";

            GroupBy = dtRep.Rows[0]["GroupBy"].ToString();
            if (GroupBy != "")
            {
                isToShowGroups = "true";
            }

            if (dtRep.Rows[0]["HasSubTotalsOnGroup"].ToString() == "1")
            {
                HasSubTotalsOnGroup = "true";
            }

            if (dtRep.Rows[0]["HeaderZoomObjTypeID"].ToString() == "2"/*report*/ && dtRep.Rows[0]["HeaderZoomObjID"].ToString() != "")
                Caption = "<div id='dCaption' onclick='parent.openNewReport(" + dtRep.Rows[0]["HeaderZoomObjID"].ToString() + ");'  style='cursor:pointer;'>" + dtRep.Rows[0]["ReportCaption"].ToString() + "</div>";
            else if (dtRep.Rows[0]["HeaderZoomObjTypeID"].ToString() == "5"/*form*/ && dtRep.Rows[0]["HeaderZoomObjID"].ToString() != "")
                Caption = "<div id='dCaption' onclick='parent.openNewForm(" + dtRep.Rows[0]["HeaderZoomObjID"].ToString() + ");'  style='cursor:pointer;'>" + dtRep.Rows[0]["ReportCaption"].ToString() + "</div>";
            else if (dtRep.Rows[0]["HeaderZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dtRep.Rows[0]["HeaderZoomObjID"].ToString() != "")
                Caption = "<div id='dCaption' onclick='parent.openNewReport(" + ReportID + ");'  style='cursor:pointer;'>" + dtRep.Rows[0]["ReportCaption"].ToString() + "</div>";
            else
                Caption = "<div id='dCaption'>" + dtRep.Rows[0]["ReportCaption"].ToString() + "</div>";

            if (dtRep.Rows[0]["IsToShowRowsNumberOnTitle"].ToString() == "1")
            {
                IsToShowRowsNumberOnTitle = "True";
            }

            if (dtRep.Rows[0]["RowReportZoomObjTypeID"].ToString() == "2"/*report*/ && dtRep.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenReport = dtRep.Rows[0]["RowReportZoomObjID"].ToString();
            else if (dtRep.Rows[0]["RowReportZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dtRep.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenReport = ReportID;
            else if (dtRep.Rows[0]["RowReportZoomObjTypeID"].ToString() == "5"/*form*/ && dtRep.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenForm = dtRep.Rows[0]["RowReportZoomObjID"].ToString();
            else if (dtRep.Rows[0]["RowReportZoomObjTypeID"].ToString() == "8"/*Cust Routes*/ && dtRep.Rows[0]["RowReportZoomObjID"].ToString() != "")
                RowOpenRoutes = dtRep.Rows[0]["RowReportZoomObjID"].ToString();
            else
                RowOpenReport = "0";

            switch (dtRep.Rows[0]["ReportTypeID"].ToString())
            {
                case "1"://Grid
                    colNames = "";
                    for (int i = 0; i < dtRep.Rows.Count; i++)
                    {
                        colNames += "'" + dtRep.Rows[i]["ColCaption"].ToString() + "'";
                        if (i + 1 < dtRep.Rows.Count)
                            colNames += ",";

                    }

                    for (int i = 0; i < dtRep.Rows.Count; i++)
                    {
                        var Key = "STYLE_" + dtRep.Rows[i]["ColName"].ToString();
                        if (!isThereStyle(dtRep, Key))
                        {
                            colNames += ",'" + Key + "'";
                        }
                    }


                    colModel = "";
                    hdnGridStyles.Value = "";
                    for (int i = 0; i < dtRep.Rows.Count; i++)
                    {
                        colModel += "{name: \"" + dtRep.Rows[i]["ColName"].ToString() + "\", index: \"" + dtRep.Rows[i]["ColName"].ToString() + "\", width: " + Convert.ToDouble(Width) * ((Convert.ToDouble(dtRep.Rows[i]["ColWidthWeight"].ToString()) / 100) - 0.0008) + ", align: \"" + dtRep.Rows[i]["Alignment"].ToString() + "\", editable: true,";

                        if (Convert.ToDouble(dtRep.Rows[i]["ColWidthWeight"].ToString()) == 0)
                            colModel += " hidden: true,";
                        string mysum = "mysum";
                        if (dtRep.Rows[i]["ColIsSummary"].ToString() != "1")
                            mysum = "summaryType";

                        if (dtRep.Rows[i]["ColTypeID"].ToString() == "6")//image
                            colModel += "formatter: ImageFormatter, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["ColTypeID"].ToString() == "7")//progress bar
                            colModel += "formatter: BarFormatter, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["ColTypeID"].ToString() == "8")//checkbox  
                            colModel += "formatter: CheckboxFormatter, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "STRING_0")
                            colModel += "stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "STRING")
                            colModel += "stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "0.00%")
                            colModel += "formatter: PercentFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "מספר שלם")
                            colModel += "formatter: NumbersFormatter, stype: \"int\",sorttype: \"int\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "1,000.00")
                            colModel += "formatter: FloatFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "1,000.00%")
                            colModel += "formatter: PercentFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "yyymmdd  > dd/mm/yyyy")//yyyymmdd
                            colModel += "formatter: DateFormatteryyyymmdd, stype: \"text\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "100 שח")
                            colModel += "formatter: MoneyFormatter, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "ddmmyyy > dd/mm/yy")
                            colModel += "formatter: DateFormatterddmmyyy, stype: \"date\",sorttype: \"text\",summaryType:" + mysum + ",classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "yyyymmdd > dd/mm/yy")
                            colModel += "formatter: DateFormatteryymmdd, stype: \"date\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "HHmmss  > HH:mm")
                            colModel += "formatter: TimeFormatterHHmmss, stype: \"date\",sorttype: \"text\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "1,000")
                            colModel += "formatter: FormatterInt, stype: \"int\",sorttype: \"int\",summaryType:" + mysum + ",cellattr: arrtSetting,classes:'grid-col',";
                        else if (dtRep.Rows[i]["FormatString"].ToString() == "1,000%")
                            colModel += "formatter: PercentFormatterInt, stype: \"float\",sorttype: \"float\",summaryType:" + mysum + ",cellattr: arrtSetting,";


                        colModel = colModel.Substring(0, colModel.Length - 1);

                        colModel += "}";
                        if (i + 1 < dtRep.Rows.Count)
                            colModel += ",";

                        hdnGridStyles.Value += dtRep.Rows[i]["ColName"].ToString() + ":" + dtRep.Rows[i]["StyleName"].ToString() + ";";

                        if (dtRep.Rows[i]["ColIsSummary"].ToString() == "1" && dtRep.Rows[0]["IsLastRowFooter"].ToString() != "1")
                        {
                            hdnIsSummery.Value = hdnIsSummery.Value + dtRep.Rows[i]["ColName"].ToString() + ";";

                            if (Request.QueryString["Height"] != null)
                            {
                                Height = Request.QueryString["Height"].ToString();
                                //Height = (Convert.ToDouble(Height) - 97).ToString();

                                //RowNum = (Convert.ToDouble(Request.QueryString["Height"].ToString()) / 22.7 - 4).ToString();

                                if (dtRep.Rows[0]["RowsPerPage"].ToString() != "")
                                {
                                    RowNum = dtRep.Rows[0]["RowsPerPage"].ToString();
                                }
                            }

                        }
                        if (dtRep.Rows[0]["IsLastRowFooter"].ToString() == "1")
                        {
                            if (Request.QueryString["Height"] != null && hdnFooterRow.Value == "")
                            {
                                Height = Request.QueryString["Height"].ToString();
                                //Height = (Convert.ToDouble(Height) - 97).ToString();

                                //RowNum = (Convert.ToDouble(Request.QueryString["Height"].ToString()) / 22.7 - 4).ToString();
                                if (dtRep.Rows[0]["RowsPerPage"].ToString() != "")
                                {
                                    RowNum = dtRep.Rows[0]["RowsPerPage"].ToString();
                                }

                            }
                            hdnFooterRow.Value = hdnFooterRow.Value + dtRep.Rows[i]["ColName"].ToString() + ";";
                        }
                    }

                    for (int i = 0; i < dtRep.Rows.Count; i++)
                    {
                        var Key = "STYLE_" + dtRep.Rows[i]["ColName"].ToString();
                        if (!isThereStyle(dtRep, Key))
                        {
                            colModel += ",{name: \"" + Key + "\", index: \"" + Key + "\", width: 0, sorttype: \"text\", align: \"right\", editable: true, hidden: true}";
                            hdnGridStyles.Value += Key + ";";
                        }
                    }
		  if (!csm.IsClientScriptBlockRegistered("ShowGrid"))
                    {
                        csm.RegisterClientScriptBlock(GetType(), "ShowGrid", "setTimeout('ShowGrid();refreshHight();', 100); ", true);
                    }
		    ClientScript.RegisterStartupScript(GetType(), "ShowGrid", "setTimeout('ShowGrid();refreshHight();', 100); ", true);	
                    //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "window.ShowGrid();", "setTimeout('window.ShowGrid();refreshHight();',200);", true);
                    break;

            }

        }

    }
    private void SetFilters(DataTable dtRep)
    {
        if (HandlerBaseCls.SessionGridDictionary != null)
        {
            Dictionary<string, DataTable> dic = (Dictionary<string, DataTable>)HandlerBaseCls.SessionGridDictionary;
            try
            {
                if (string.IsNullOrEmpty(ReportID))
                {
                      ReportID  = dtRep.Rows.OfType<DataRow>().Select(a => (string)a["ReportID"]).First();
                }

                DataTable dtDDL = dic[ReportID];
                for (int u = 0; u < dtRep.Rows.Count; u++)
                {
                    for (int c = 0; c < dtDDL.Columns.Count; c++)
                    {
                        HtmlGenericControl divParent = new HtmlGenericControl("div");
                        if (dtRep.Rows[u]["ColName"].ToString().ToLower() == dtDDL.Columns[c].ToString().ToLower() &&
                            dtRep.Rows[u]["FilterID"].ToString() == "3") //ddl
                        {

                            List<string> RowsList = new List<string>();
                            HtmlGenericControl DDLSelect = new HtmlGenericControl("Select");
                            DDLSelect.Attributes["onchange"] = "SearchBytxt(this);";
                            DDLSelect.Attributes["class"] = "selectSearch SearchOnTop";
                            DDLSelect.ID = "DDLSel" + dtDDL.Columns[c].ToString().ToLower();
                            HtmlGenericControl opFirst = new HtmlGenericControl("option");
                            opFirst.Attributes["value"] = "";
                            opFirst.InnerHtml = "";
                            DDLSelect.Controls.Add(opFirst);
                            for (int r = 0; r < dtDDL.Rows.Count; r++)
                            {
                                bool Exist = true;
                                foreach (string Rowitem in RowsList)
                                    if (Rowitem == dtDDL.Rows[r][c].ToString())
                                        Exist = false;
                                if (Exist && dtDDL.Rows[r][c].ToString() != "")
                                    RowsList.Add(dtDDL.Rows[r][c].ToString());
                            }
                            RowsList.Sort();
                            foreach (string Rowitem in RowsList)
                            {
                                HtmlGenericControl op = new HtmlGenericControl("option");
                                op.Attributes["value"] = Rowitem;
                                op.InnerHtml = Rowitem;
                                DDLSelect.Controls.Add(op);
                            }
                            divParent.Controls.Add(DDLSelect);
                            divSelect.Controls.Add(divParent);
                        }
                        else if (dtRep.Rows[u]["ColName"].ToString().ToLower() ==
                                 dtDDL.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "2")
                        {
                            HtmlGenericControl txtSelect = new HtmlGenericControl("input");
                            txtSelect.Attributes["Type"] = "text";
                            txtSelect.Attributes["onkeyup"] = "SearchBytxt(this);";
                            txtSelect.Attributes["class"] = "txtSearch SearchOnTop";
                            txtSelect.ID = "txtSel" + dtDDL.Columns[c].ToString().ToLower();
                            divParent.Controls.Add(txtSelect);
                            divSelect.Controls.Add(divParent);

                        }
                        else if (dtRep.Rows[u]["ColName"].ToString().ToLower() ==
                                 dtDDL.Columns[c].ToString().ToLower() && dtRep.Rows[u]["FilterID"].ToString() == "1")
                        {
                            HtmlGenericControl txtSelect = new HtmlGenericControl("input");
                            txtSelect.Attributes["Type"] = "text";
                            txtSelect.Attributes["class"] = "notSearch SearchOnTop";
                            txtSelect.Attributes["readonly"] = "true";
                            txtSelect.ID = "txtSel" + dtDDL.Columns[c].ToString().ToLower();
                            divParent.Controls.Add(txtSelect);
                            divSelect.Controls.Add(divParent);
                        }

                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page),
                            "setSetSearchContralByCol()" + c.ToString() + DateTime.Now.Ticks.ToString(),
                            "setTimeout('SetSearchContralByCol(\"" + dtDDL.Columns[c].ToString().ToLower() + "\",\"" +
                            dtRep.Rows[u]["FilterID"].ToString() + "\");',900);", true);

                    }
                }
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page),
                    "ReplaceCloseButton()" + DateTime.Now.Ticks.ToString(), "setTimeout('ReplaceCloseButton();',200);",
                    true);
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDirectory);
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
            Tools.HandleError(ex, LogDirectory);
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
        //dtRep
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