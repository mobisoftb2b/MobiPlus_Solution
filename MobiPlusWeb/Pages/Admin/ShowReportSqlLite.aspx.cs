using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SQLite;
using System.Configuration;
using System.Data;
using System.Web.UI.HtmlControls;
using MobiPlusTools;

public partial class Pages_Admin_ShowReportSqlLite : PageBaseCls
{
    private SQLiteConnection sqlite;
    private double PageWidth = 470;
    private static string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

    public string RowOpenReport = "0";
    public string RowOpenForm = "0";
    public string Params = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    protected void btnSetParamsServer_Click(object sender, EventArgs e)
    {
        SetReport();
        dParams.Visible = false;
    }
    private void init()
    {
        string[] arr = new string[0];
        try
        {
            if (Request.QueryString["ReportID"] != null)
            {
                MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
                DataTable dtRerportOrg = wr.Layout_GetReportDataDT(Request.QueryString["ReportID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);

                sqlite = new SQLiteConnection("Data Source=" + ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteMtnDBPath"].ToString());

                if (dtRerportOrg != null && dtRerportOrg.Rows.Count > 0)
                {
                    if (dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "1" || dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "2" || dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "11")//Grid Report || name value || widjet
                    {
                        //DataTable dt = selectQuery(dtRerportOrg.Rows[0]["ReportQuery"].ToString());\
                        arr = GetAllVariables(dtRerportOrg.Rows[0]["ReportQuery"].ToString());

                        HtmlGenericControl dynTBL = new HtmlGenericControl("table");
                        for (int i = 0; i < arr.Length; i++)
                        {
                            HtmlGenericControl dynTR = new HtmlGenericControl("tr");

                            HtmlGenericControl dynTD1 = new HtmlGenericControl("td");
                            HtmlGenericControl dynTD2 = new HtmlGenericControl("td");
                            HtmlGenericControl dynTXT = new HtmlGenericControl("input");

                            dynTXT.ID = "Param" + i.ToString();
                            dynTD1.InnerText = arr[i];

                            dynTXT.Attributes["type"] = "text";
                            dynTD2.Controls.Add(dynTXT);

                            dynTR.Controls.Add(dynTD1);
                            dynTR.Controls.Add(dynTD2);

                            dynTBL.Controls.Add(dynTR);
                        }
                        dParams.Controls.Add(dynTBL);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "alertErr" + DateTime.Now.Ticks.ToString(), "alert('שגיאה: " + ex.Message + "');", true);
        }
        if (arr.Length == 0)
        {
            dParams.Visible = false;
            SetReport();
        }
        sqlite.Close();
        GC.Collect();
    }
    private void SetReport()
    {
        try
        {
            if (Request.QueryString["ReportID"] != null)
            {
                MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
                
                DataTable dtRerportOrg = wr.Layout_GetReportDataDT(Request.QueryString["ReportID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                string clientParams = hdnParams.Value;

                sqlite = new SQLiteConnection("Data Source=" + ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteMtnDBPath"].ToString());
                if (dtRerportOrg != null && dtRerportOrg.Rows.Count > 0)
                {
                    if (dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "1")//Grid Report
                    {
                        string Query = dtRerportOrg.Rows[0]["ReportQuery"].ToString();
                        string[] arr = GetAllVariables(dtRerportOrg.Rows[0]["ReportQuery"].ToString());
                        for (int t = 0; t < arr.Length; t++)
                        {
                            Query = Query.Replace(arr[t] + " ", clientParams.Split(',')[t + 1] + " ");
                            Query = Query.Replace(arr[t] + ",", clientParams.Split(',')[t + 1] + ",");
                        }
                        DataTable dt = selectQuery(Query);

                        DataTable dtCols = wr.Layout_GetReportColsDT(Request.QueryString["ReportID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);

                        DataView dv = dtCols.DefaultView;
                        dv.Sort = "ColOrder";
                        dtCols = dv.ToTable();

                        if (dt != null && dtCols != null && dt.Rows.Count > 0 && dtCols.Rows.Count > 0)
                        {
                            HtmlGenericControl dynTBL = new HtmlGenericControl("table");
                            dynTBL.Attributes["cellpadding"] = "0";
                            dynTBL.Attributes["cellspacing"] = "0";
                            dynTBL.Attributes["border"] = "1";
                            dynTBL.Style["background-color"] = "#FFFFFF";
                            dynTBL.Style["color"] = "black";
                            dynTBL.Style["max-width"] = PageWidth.ToString() + "px";


                            //dynTBL.Attributes["border"] = "2";

                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                HtmlGenericControl dynTR = new HtmlGenericControl("tr");

                                if (i == 0)
                                {
                                    for (int t = 0; t < dtCols.Rows.Count; t++)//header
                                    {
                                        HtmlGenericControl dynTD = new HtmlGenericControl("td");

                                        dynTD.Style["background-color"] = "gray";
                                        dynTD.Style["color"] = "white";
                                        int tmp=0;
                                        if (int.TryParse(dtCols.Rows[t]["ColCaption"].ToString(), out tmp))
                                            dynTD.InnerText = dt.Columns[Convert.ToInt32(dtCols.Rows[t]["ColCaption"].ToString())].ToString();
                                        else
                                            dynTD.InnerText = dtCols.Rows[t]["ColCaption"].ToString();
                                        dynTD.Style["width"] = (Convert.ToDouble(dtCols.Rows[t]["ColWidthWeight"].ToString()) / 100 * PageWidth).ToString() + "px";
                                        dynTD.Style["text-align"] = "right";
                                        dynTD.Style["padding"] = "2px";
                                        dynTD.Style["font-weight"] = "700";
                                        dynTD.Style["white-space"] = "nowrap";
                                        dynTD.Style["direction"] = "rtl";
                                        dynTR.Controls.Add(dynTD);
                                    }
                                    dynTBL.Controls.Add(dynTR);
                                }

                                HtmlGenericControl dynTRData = new HtmlGenericControl("tr");
                                for (int t = 0; t < dtCols.Rows.Count; t++)//rows items
                                {
                                    bool isOK = false;
                                    for (int r = 0; r < dt.Columns.Count; r++)//check cols names
                                    {
                                        int tmp = 0;
                                        if (dtCols.Rows[t]["ColName"].ToString() == dt.Columns[r].ColumnName.ToString() || int.TryParse(dtCols.Rows[t]["ColCaption"].ToString(), out tmp))
                                        {
                                            isOK = true;
                                            break;
                                        }
                                    }
                                    if (!isOK)
                                    {
                                        ThrowError("Column: " + dtCols.Rows[t]["ColName"].ToString() + "\\n אינה זהה בשאילתה על מול העמודות השמורות");
                                        return;
                                    }



                                    HtmlGenericControl dynTD = new HtmlGenericControl("td");

                                    SetAlignment(dtCols.Rows[t]["Alignment"].ToString(), ref dynTD);

                                    if (dtCols.Rows[t]["ColTypeID"].ToString() != "6")// not image
                                    {
                                        int tmp = 0;
                                        if (int.TryParse(dtCols.Rows[t]["ColName"].ToString(), out tmp))
                                            dynTD.InnerText = GetFormatStr(dt.Rows[i][Convert.ToInt32(dtCols.Rows[t]["ColName"].ToString())].ToString(), dtCols.Rows[t]["FormatID"].ToString(), ref dynTD);
                                        else
                                            dynTD.InnerText = GetFormatStr(dt.Rows[i][dtCols.Rows[t]["ColName"].ToString()].ToString(), dtCols.Rows[t]["FormatID"].ToString(), ref dynTD);
                                    }
                                    else//image
                                        dynTD.InnerHtml = GetImageStr(dt.Rows[i][dtCols.Rows[t]["ColName"].ToString()].ToString(), ref dynTD);


                                    SetStyles(dtCols.Rows[t]["StyleID"].ToString(), ref dynTD);

                                    SetMaxLength(dtCols.Rows[t]["ColMaxLength"].ToString(), ref dynTD);

                                    try
                                    {
                                        if (dt.Rows[i]["STYLE_" + dtCols.Rows[t]["ColName"].ToString()].ToString() != null)
                                        {
                                            dynTD.Style["color"] = dt.Rows[i]["STYLE_" + dtCols.Rows[t]["ColName"].ToString()].ToString();
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                    }

                                    dynTD.Style["padding"] = "4px";
                                    dynTD.Style["border-bottom"] = "2px solid black";
                                    dynTRData.Controls.Add(dynTD);
                                }

                                dynTBL.Controls.Add(dynTRData);
                            }
                            dReport.Controls.Add(dynTBL);
                        }
                        else
                        {
                            HtmlGenericControl divv = new HtmlGenericControl("div");
                            divv.Style["text-align"] = "center";
                            divv.Style["font-size"] = "24px";
                            if (dt == null || dt.Rows.Count == 0)
                                divv.InnerHtml = "<br/><br/>לא נמצאו רשומות";
                            else
                                divv.InnerHtml = "<br/><br/>לא נמצאו עמודות";

                            dReport.Controls.Add(divv);
                        }
                    }
                    else if (dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "2")//Name Value Report
                    {
                        DataTable dt;
                        DataTable dtCols;
                        string Query = dtRerportOrg.Rows[0]["ReportQuery"].ToString();
                        string[] arr = GetAllVariables(dtRerportOrg.Rows[0]["ReportQuery"].ToString());
                        for (int t = 0; t < arr.Length; t++)
                        {
                            Query = Query.Replace(arr[t] + " ", clientParams.Split(',')[t + 1] + " ");
                            Query = Query.Replace(arr[t] + ",", clientParams.Split(',')[t + 1] + ",");
                        }

                        dt = selectQuery(Query);
                        dtCols = wr.Layout_GetReportColsDT(Request.QueryString["ReportID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                        if (dt != null && dtCols != null && dt.Rows.Count > 0 && dtCols.Rows.Count > 0)
                        {
                            DataView dv = dtCols.DefaultView;
                            dv.Sort = "ColOrder";
                            dtCols = dv.ToTable();

                            HtmlGenericControl dynTBL = new HtmlGenericControl("table");
                            dynTBL.Attributes["cellpadding"] = "0";
                            dynTBL.Attributes["cellspacing"] = "0";
                            dynTBL.Style["background-color"] = "#FFFFFF";
                            dynTBL.Style["color"] = "black";
                            dynTBL.Style["max-width"] = PageWidth.ToString() + "px";

                            for (int i = 0; i < dtCols.Rows.Count && dt.Rows.Count > 0; i++)
                            {
                                if (dtCols.Rows[i]["ColName"].ToString() != "0")
                                {
                                    bool isOK = false;
                                    for (int r = 0; r < dt.Columns.Count; r++)//check cols names
                                    {
                                        int tmp = 0;
                                        if (dtCols.Rows[i]["ColName"].ToString() == dt.Columns[r].ColumnName.ToString() || int.TryParse(dtCols.Rows[i]["ColCaption"].ToString(), out tmp))
                                        {
                                            isOK = true;
                                            break;
                                        }
                                    }
                                    if (!isOK)
                                    {
                                        ThrowError("Column: " + dtCols.Rows[i]["ColName"].ToString() + "\\n אינה זהה בשאילתה על מול העמודות השמורות");
                                        return;
                                    }


                                    HtmlGenericControl dynTR = new HtmlGenericControl("tr");
                                    HtmlGenericControl dynKey = new HtmlGenericControl("td");
                                    HtmlGenericControl dynVal = new HtmlGenericControl("td");

                                    dynKey.InnerHtml = dtCols.Rows[i]["ColCaption"].ToString() + ":&nbsp;";

                                    SetAlignment(dtCols.Rows[i]["Alignment"].ToString(), ref dynVal);

                                    dynVal.InnerText = GetFormatStr(dt.Rows[0][dtCols.Rows[i]["ColName"].ToString()].ToString(), dtCols.Rows[i]["FormatID"].ToString(), ref dynVal);

                                    SetStyles(dtCols.Rows[i]["StyleID"].ToString(), ref dynVal);

                                    SetMaxLength(dtCols.Rows[i]["ColMaxLength"].ToString(), ref dynVal);

                                    dynKey.Style["font-weight"] = "700";

                                    dynTR.Style["height"] = "30px";
                                    dynKey.Style["border-bottom"] = "2px solid black";
                                    dynVal.Style["border-bottom"] = "2px solid black";

                                    dynTR.Controls.Add(dynKey);
                                    dynTR.Controls.Add(dynVal);
                                    dynTBL.Controls.Add(dynTR);
                                }
                            }
                            dReport.Controls.Add(dynTBL);
                        }
                        else
                        {
                            HtmlGenericControl divv = new HtmlGenericControl("div");
                            divv.Style["text-align"] = "center";
                            divv.Style["font-size"] = "24px";
                            if (dt == null || dt.Rows.Count == 0)
                                divv.InnerHtml = "<br/><br/>לא נמצאו רשומות";
                            else
                                divv.InnerHtml = "<br/><br/>לא נמצאו עמודות";

                            dReport.Controls.Add(divv);
                        }
                    }
                    else if (dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "11")//DashBoard Widjet
                    {

                        string Query = dtRerportOrg.Rows[0]["ReportQuery"].ToString();
                        string[] arr = GetAllVariables(dtRerportOrg.Rows[0]["ReportQuery"].ToString());
                        for (int t = 0; t < arr.Length; t++)
                        {
                            Query = Query.Replace(arr[t] + " ", clientParams.Split(',')[t + 1] + " ");
                            Query = Query.Replace(arr[t] + ",", clientParams.Split(',')[t + 1] + ",");
                        }
                        DataTable dt = selectQuery(Query);

                        if (dt != null)
                        {

                            DataTable dtCols = wr.Layout_GetReportColsDT(Request.QueryString["ReportID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);

                            HtmlGenericControl dynTBL = new HtmlGenericControl("table");
                            //dynTBL.Attributes["border"] = "1";
                            HtmlGenericControl trMain = new HtmlGenericControl("tr");
                            dReport.Attributes["class"] = "AllSectionWidjet";

                            string Height = "800";
                            dReport.Style["height"] = Height + "px";

                            dynTBL.Attributes["cellpadding"] = "0";
                            dynTBL.Attributes["cellspacing"] = "0";
                            int Counter = 0;
                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                Counter++;
                                HtmlGenericControl tdMain = new HtmlGenericControl("td");
                                //tdMain.Style["border"] = "1px solid black";
                                HtmlGenericControl TblSection = new HtmlGenericControl("table");
                                //TblSection.Style["border"] = "1px solid black";
                                TblSection.Style["background-color"] = "white";
                                if (dt.Columns["BGColor"] != null && dt.Rows[i]["BGColor"].ToString() != "")
                                    TblSection.Style["background-color"] = dt.Rows[i]["BGColor"].ToString();

                                TblSection.Attributes["class"] = "SectionWidjet";
                                TblSection.Style["width"] = "200px";
                                //TblSection.Style["overflow"] = "hidden";
                                //tdMain.Style["overflow"] = "hidden";

                                string Width = "480";

                                if (dtRerportOrg.Rows[0]["SectionsPerRow"].ToString() != "")
                                    TblSection.Style["width"] = ((Convert.ToDouble(Width) + 33 - (Convert.ToInt32(dtRerportOrg.Rows[0]["SectionsPerRow"].ToString()) * 8)) / Convert.ToInt32(dtRerportOrg.Rows[0]["SectionsPerRow"].ToString())).ToString() + "px";

                                //if (i == 0)
                                    //TblSection.Style["margin-right"] = "1px";

                                TblSection.Style["height"] = "60px";
                                if (dtRerportOrg.Rows[0]["SectionsPerRow"].ToString() != "")
                                    TblSection.Style["height"] = (Convert.ToDouble(dtRerportOrg.Rows[0]["SectionsRowHeight"].ToString())/2).ToString() + "px";

                                HtmlGenericControl tr1 = new HtmlGenericControl("tr");
                                HtmlGenericControl td1 = new HtmlGenericControl("td");
                                //td1.Style["vertical-align"] = "top";
                                td1.Style["text-align"] = "center";

                                HtmlGenericControl tblRow = new HtmlGenericControl("table");

                                HtmlGenericControl trRow = new HtmlGenericControl("tr");
                                HtmlGenericControl trRowTd1 = new HtmlGenericControl("td");
                                HtmlGenericControl trRowTd2 = new HtmlGenericControl("td");
                                HtmlGenericControl trRowTd3 = new HtmlGenericControl("td");


                                HtmlGenericControl tblRowTow = new HtmlGenericControl("table");
                                HtmlGenericControl trRowTow = new HtmlGenericControl("tr");
                                HtmlGenericControl trRowTd1Tow = new HtmlGenericControl("td");
                                HtmlGenericControl trRowTd2Tow = new HtmlGenericControl("td");
                                HtmlGenericControl trRowTd3Tow = new HtmlGenericControl("td");

                                HtmlGenericControl txt1 = new HtmlGenericControl("div");
                                txt1.Style["direction"] = "rtl";


                                for (int y = 0; y < dtCols.Rows.Count; y++)
                                {
                                    if (dtCols.Rows[y]["ColName"].ToString() == "Text1")
                                    {
                                        if (dt.Columns["STYLE_Text1"] == null)
                                            SetStylesNew(ref txt1, dtCols.Rows[y]["StyleID"].ToString());
                                        SetFormat(ref txt1, dtCols.Rows[y]["FormatID"].ToString(), dt.Rows[i]["Text1"].ToString());
                                        SetAlignments(ref trRowTd2, dtCols.Rows[y]["AlignmentID"].ToString());
                                        trRowTd2.Style["width"] = "100%";

                                        td1.Style["vertical-align"] = "bottom";
                                        break;
                                    }
                                }
                                if (dt.Columns["STYLE_Text1"] != null)
                                {
                                    SetStylesByName(ref txt1, dt.Rows[i]["STYLE_Text1"].ToString());
                                }

                                HtmlGenericControl tr2 = new HtmlGenericControl("tr");
                                HtmlGenericControl td2 = new HtmlGenericControl("td");
                                HtmlGenericControl txt2 = new HtmlGenericControl("span");
                                td2.Style["text-align"] = "center";

                                for (int y = 0; y < dtCols.Rows.Count; y++)
                                {
                                    if (dtCols.Rows[y]["ColName"].ToString() == "Text2")
                                    {
                                        if (dt.Columns["STYLE_Text2"] == null)
                                            SetStylesNew(ref txt2, dtCols.Rows[y]["StyleID"].ToString());
                                        SetFormat(ref txt2, dtCols.Rows[y]["FormatID"].ToString(), dt.Rows[i]["Text2"].ToString());
                                        SetAlignments(ref trRowTd2Tow, dtCols.Rows[y]["AlignmentID"].ToString());
                                        trRowTd2Tow.Style["width"] = "100%";

                                        td2.Style["vertical-align"] = "top";
                                        break;
                                    }
                                }
                                if (dt.Columns["STYLE_Text2"] != null)
                                {
                                    SetStylesByName(ref txt2, dt.Rows[i]["STYLE_Text2"].ToString());
                                }

                                if (dt.Columns["ZoomObjTypeID"] != null && dt.Columns["ZoomObjID"] != null)
                                {
                                    if (dt.Rows[0]["ZoomObjTypeID"].ToString() == "2"/*report*/ && dt.Rows[i]["ZoomObjID"].ToString() != "")
                                    {
                                        RowOpenReport = dt.Rows[i]["ZoomObjID"].ToString();
                                        TblSection.Attributes["onclick"] = "parent.openNewReport2(\"" + RowOpenReport + "\",\"" + Params + "\");";
                                    }
                                    else if (dt.Rows[i]["ZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dt.Rows[i]["ZoomObjID"].ToString() != "")
                                    {
                                        RowOpenReport = Request.QueryString["ReportID"].ToString();
                                        TblSection.Attributes["onclick"] = "parent.openNewReport2(\"" + RowOpenReport + "\",\"" + Params + "\");";
                                    }
                                    else if (dt.Rows[i]["ZoomObjTypeID"].ToString() == "5"/*form*/ && dt.Rows[i]["ZoomObjID"].ToString() != "")
                                    {
                                        RowOpenForm = dt.Rows[i]["ZoomObjID"].ToString();
                                        TblSection.Attributes["onclick"] = "parent.openNewForm2(\"" + RowOpenForm + "\",\"" + Params + "\");";
                                    }
                                    else
                                        RowOpenReport = "0";
                                }


                                HtmlGenericControl br = new HtmlGenericControl("span");

                                HtmlGenericControl img1 = new HtmlGenericControl("image");
                                img1.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                                img1.Style["Height"] = (Convert.ToDouble(dtRerportOrg.Rows[0]["SectionImageHeightWeight"].ToString()) / 100 * 32).ToString() + "px";

                                HtmlGenericControl img2 = new HtmlGenericControl("image");
                                img2.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                                img2.Style["Height"] = (Convert.ToDouble(dtRerportOrg.Rows[0]["SectionImageHeightWeight"].ToString())/100 * 32).ToString() + "px";

                                HtmlGenericControl img3 = new HtmlGenericControl("image");
                                img3.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                                img3.Style["Height"] = (Convert.ToDouble(dtRerportOrg.Rows[0]["SectionImageHeightWeight"].ToString()) / 100 * 32).ToString() + "px";

                                HtmlGenericControl img4 = new HtmlGenericControl("image");
                                img4.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                                img4.Style["Height"] = (Convert.ToDouble(dtRerportOrg.Rows[0]["SectionImageHeightWeight"].ToString()) / 100 * 32).ToString() + "px";
                               

                                switch (dt.Rows[i]["ImagePosition"].ToString())
                                {
                                    case "1":
                                        img2.Style["display"] = "none";
                                        img3.Style["display"] = "none";
                                        img4.Style["display"] = "none";
                                       
                                        break;
                                    case "2":
                                        img1.Style["display"] = "none";
                                        img3.Style["display"] = "none";
                                        img4.Style["display"] = "none";                                       

                                        break;
                                    case "3":
                                        img1.Style["display"] = "none";
                                        img2.Style["display"] = "none";
                                        img4.Style["display"] = "none";
                                        
                                        break;
                                    case "4":
                                        img1.Style["display"] = "none";
                                        img2.Style["display"] = "none";
                                        img3.Style["display"] = "none";
                                        
                                        break;
                                    
                                }


                                trRowTd1.Controls.Add(img2);
                                br.InnerHtml = "<BR/>";
                                trRowTd1.Controls.Add(br);

                                trRowTd1.Controls.Add(img1);
                                trRowTd2.Controls.Add(txt1);

                                trRowTd3.Controls.Add(img2);

                                trRow.Controls.Add(trRowTd1);
                                trRow.Controls.Add(trRowTd2);
                                trRow.Controls.Add(trRowTd3);

                                tblRow.Controls.Add(trRow);

                                td1.Controls.Add(tblRow);

                                tr1.Controls.Add(td1);
                                TblSection.Controls.Add(tr1);

                                br.InnerHtml = "<BR/>";
                                trRowTd1Tow.Controls.Add(br);

                                trRowTd1Tow.Controls.Add(br);

                                trRowTd1Tow.Controls.Add(img3);

                                trRowTd2Tow.Controls.Add(txt2);
                                trRowTd3Tow.Controls.Add(img4);

                                trRowTow.Controls.Add(trRowTd1Tow);
                                trRowTow.Controls.Add(trRowTd2Tow);
                                trRowTow.Controls.Add(trRowTd3Tow);

                                tblRowTow.Controls.Add(trRowTow);

                                td2.Controls.Add(tblRowTow);
                                tr2.Controls.Add(td2);
                                TblSection.Controls.Add(tr2);

                                tdMain.Controls.Add(TblSection);

                                trMain.Controls.Add(tdMain);

                                if ((i + 1) % Convert.ToInt32(dtRerportOrg.Rows[0]["SectionsPerRow"].ToString()) == 0)
                                {
                                    Counter = 0;
                                    br.InnerHtml = "<BR/>";
                                    dReport.Controls.Add(br);


                                    dynTBL.Controls.Add(trMain);
                                    trMain = new HtmlGenericControl("tr");
                                }
                            }
                            if (Counter > 0)
                            {
                                dynTBL.Controls.Add(trMain);
                            }
                            dReport.Controls.Clear();

                            dReport.Controls.Add(dynTBL);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "alertErr" + DateTime.Now.Ticks.ToString(), "alert('שגיאה: " + ex.Message + "');", true);
        }
        sqlite.Close();
        GC.Collect();
    }
    private string GetImageStr(string ImageName, ref HtmlGenericControl dynTD)
    {
        string htm = "<img src='../../Handlers/ShowImage.ashx?ImageName=" + ImageName + "'></img>";//"../../Handlers/ShowImage.ashx?ImageName=" + ImageName;
        return htm;
    }
    private void ThrowError(string msg)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "ThrowError" + DateTime.Now.Ticks.ToString(), "alert('ERROR: " + msg + "');", true);
    }
    private void SetAlignment(string Alignment, ref HtmlGenericControl dynVal)
    {
        switch (Alignment)
        {
            case "Right":
                dynVal.Style["text-align"] = "right";
                break;
            case "Center":
                dynVal.Style["text-align"] = "center";
                break;
            case "Left":
                dynVal.Style["text-align"] = "left";
                break;
        }
    }
    private void SetMaxLength(string ColMaxLength, ref HtmlGenericControl dynVal)
    {
        if (ColMaxLength != "0")
        {
            if (dynVal.InnerText.Length > Convert.ToInt32(ColMaxLength))
            {
                dynVal.InnerText = dynVal.InnerText.Substring(0, Convert.ToInt32(ColMaxLength));
            }
        }
    }
    private void SetStyles(string StyleID, ref HtmlGenericControl dynTD)
    {
        switch (StyleID)
        {
            case "1"://Default
                dynTD.Style["font-size"] = "14px";
                dynTD.Style["font-family"] = "Arial";
                dynTD.Style["color"] = "#000000";
                //dynTD.Style["background-color"] = "#000000";
                dynTD.Style["font-weight"] = "500";
                //dynTD.Style["text-decoration"] = "'undeline'";
                //blink
                break;
            case "4"://BoldBlack
                dynTD.Style["font-size"] = "14px";
                dynTD.Style["font-family"] = "Arial";
                dynTD.Style["color"] = "#000000";
                //dynTD.Style["background-color"] = "#000000";
                dynTD.Style["font-weight"] = "500";
                //dynTD.Style["text-decoration"] = "'undeline'";
                //blink
                break;
            case "5"://BoldTitle
                dynTD.Style["font-size"] = "14px";
                dynTD.Style["font-family"] = "Arial";
                dynTD.Style["color"] = "#FFFFFF";
                dynTD.Style["background-color"] = "#301EFA";
                dynTD.Style["font-weight"] = "700";
                //dynTD.Style["text-decoration"] = "'undeline'";
                //blink
                break;
            case "7"://Blue
                dynTD.Style["font-size"] = "14px";
                dynTD.Style["font-family"] = "Arial";
                dynTD.Style["color"] = "#301EFA";
                //dynTD.Style["background-color"] = "#301EFA";
                dynTD.Style["font-weight"] = "500";
                //dynTD.Style["text-decoration"] = "'undeline'";
                //blink
                break;
            case "12"://Green
                dynTD.Style["font-size"] = "14px";
                dynTD.Style["font-family"] = "Arial";
                dynTD.Style["color"] = "#0BDB40";
                //dynTD.Style["background-color"] = "#301EFA";
                dynTD.Style["font-weight"] = "500";
                //dynTD.Style["text-decoration"] = "'undeline'";
                //blink
                break;
            case "13"://Red
                dynTD.Style["font-size"] = "14px";
                dynTD.Style["font-family"] = "Arial";
                dynTD.Style["color"] = "#F7022F";
                //dynTD.Style["background-color"] = "#301EFA";
                dynTD.Style["font-weight"] = "500";
                //dynTD.Style["text-decoration"] = "'undeline'";
                //blink
                break;
        }
    }
    private string GetFormatStr(string str, string FormatID, ref HtmlGenericControl dynTD)
    {
        dynTD.Style["direction"] = "rtl";

        switch (FormatID)
        {
            case "0"://STRING_0
                str = str.Split('.')[0];
                break;
            case "1"://STRING
                //str = str;
                break;
            case "2"://0.00%
                if (str != String.Empty)
                {
                    str = Convert.ToDouble(str).ToString("N2") + "%";
                    dynTD.Style["direction"] = "ltr";
                }
                break;
            case "3"://מספר שלם
                //str = str;
                dynTD.Style["direction"] = "ltr";
                break;
            case "8"://1,000.00
                if (str != String.Empty)
                {
                    str = Convert.ToDouble(str).ToString("N2");
                    dynTD.Style["direction"] = "ltr";
                }
                break;
            case "9"://1,000.00%
                if (str != String.Empty)
                {
                    str = Convert.ToDouble(str).ToString("N2") + "%";
                    dynTD.Style["direction"] = "ltr";
                }
                break;
            case "11"://yyymmdd  > dd/mm/yyyy
                str = str.Substring(6, 2) + "/" +
                                  str.Substring(4, 2) + "/" +
                                  str.Substring(0, 4);
                break;
            case "12"://שח
                str = "₪ " + Convert.ToDouble(str).ToString("N2");
                dynTD.Style["direction"] = "ltr";
                break;
            case "13"://ddmmyyy > dd/mm/yy
                str = str.Substring(0, 2) + "/" +
                                  str.Substring(2, 2) + "/" +
                                  str.Substring(4, 4);
                break;
            case "14"://yyyymmdd > dd/mm/yy
                str = str.Substring(6, 2) + "/" +
                                 str.Substring(4, 2) + "/" +
                                 str.Substring(2, 2);
                break;
            case "25":// HHmmss  > HH:mm
                str = str.Substring(0, 2) + ":" +
                                    str.Substring(2, 2);
                break;
            default:
                // str = str;
                break;
        }

        return str;
    }
    int counter = 0;
    private string[] GetAllVariables(string Query)
    {
        string[] arr = new string[Query.Split('@').Length - 1];
        counter = 0;
        for (int i = 0; i < Query.Length; i++)
        {
            if (Query[i] == '@')
            {
                string var = Query.Substring(i, Query.Length - i);
                var = var.Substring(0, var.IndexOf(" ") == -1 ? var.Length : var.IndexOf(" "));
                if (!hasTheSameVar(arr, var))
                {
                    arr[counter] = var;
                    i += arr[counter].Length - 1;
                    counter++;
                }
            }
        }
        string[] arr2 = new string[counter];
        for (int i = 0; i < arr.Length; i++)
        {
            if (arr[i] != null)
            {
                arr2[i] = arr[i];
            }
        }
        return arr2;
    }
    private bool hasTheSameVar(string[] arr,string Var)
    {
        for (int i = 0;  i < arr.Length; i++)
        {
            if (arr[i]!=null && arr[i].ToLower() == Var.ToLower())
                return true;
        }
        return false;
    }
    public DataTable selectQuery(string query)
    {
        SQLiteDataAdapter ad;
        DataTable dt = new DataTable();

        try
        {
            string path = ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteBIDBPath"].ToString();
            string path2 = ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteDBDBPath"].ToString();
            string path3 = ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteDeltaDBPath"].ToString();
            string path4 = ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteDeltaLayoutPath"].ToString();
            SQLiteCommand cmd;
            sqlite.Open();  //Initiate connection to the db
            cmd = sqlite.CreateCommand();
            cmd.CommandText = "ATTACH '" + path + "' AS BI; " + "ATTACH '" + path2 + "' AS DB1; " + "ATTACH '" + path3 + "' AS Delta; ATTACH '" + path4 + "' as LayoutDB; " + query;  //set the passed query
            ad = new SQLiteDataAdapter(cmd);
            ad.Fill(dt); //fill the datasource
        }
        catch (SQLiteException ex)
        {
            Response.Write("Error: " + ex.Message);
            //Response.Write("ReportID: " + Request.QueryString["ReportID"].ToString());
            //Response.Write(ConStrings.DicAllConStrings[SessionProjectName]);
        }
        sqlite.Close();
        GC.Collect();
        return dt;
    }
    DataTable dtStyles;
    private void SetStylesNew(ref HtmlGenericControl txt, string StyleID, string StyleName = "")
    {
        if (dtStyles == null)
        {
            dtStyles = selectQuery("SELECT     StyleID, StyleName, FontSize, FontFamily, ForeColor, BackColor, isBold, isUnderline, isBlink, IsActive FROM         Layout_Styles where IsActive=1;");
            //MPLayoutService.MPLayoutService WR = new MPLayoutService.MPLayoutService();
            //dtStyles = WR.MPLayout_GetReportStyles(SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
        }
        if (dtStyles != null)
        {
            DataTable dtFilterStyles;
            if (StyleName == "")
            {
                DataView dv = dtStyles.DefaultView;
                dv.RowFilter = "StyleID = " + StyleID;
                dtFilterStyles = dv.ToTable();
            }
            else
            {
                DataView dv = dtStyles.DefaultView;
                dv.RowFilter = "StyleName = '" + StyleName + "'";
                dtFilterStyles = dv.ToTable();
            }
            if (dtFilterStyles != null && dtFilterStyles.Rows.Count > 0)
            {
                txt.Style["font-size"] = dtFilterStyles.Rows[0]["FontSize"].ToString() + "px";
                txt.Style["color"] = dtFilterStyles.Rows[0]["ForeColor"].ToString();
                txt.Style["font-family"] = dtFilterStyles.Rows[0]["FontFamily"].ToString();

                if (dtFilterStyles.Rows[0]["isBold"].ToString() == "1")
                    txt.Style["font-weight"] = "700";

                if (dtFilterStyles.Rows[0]["BackColor"].ToString() != "")
                    txt.Style["background-color"] = dtFilterStyles.Rows[0]["BackColor"].ToString();

                if (dtFilterStyles.Rows[0]["isUnderline"].ToString() == "1")
                    txt.Style["text-decoration"] = "underline";
            }
        }
    }
    private void SetStylesByName(ref HtmlGenericControl txt, string StyleName)
    {
        SetStylesNew(ref txt, "0", StyleName);
    }
    private void SetFormat(ref HtmlGenericControl txt, string FormatID, string Value)
    {
        switch (FormatID)
        {
            case "0"://STRING_0
            case "1"://STRING
                txt.InnerText = Value;
                break;
            case "2"://0.00%
                txt.InnerText = Convert.ToDouble(Value).ToString("N2") + "%";
                break;
            case "3"://מספר שלם
                txt.InnerText = Convert.ToDouble(Value).ToString("N0");
                break;
            case "8"://1,000.00
                txt.InnerText = Convert.ToDouble(Value).ToString("N2");
                break;
            case "9"://1,000.00%
                txt.InnerText = Convert.ToDouble(Value).ToString("N2") + "%";
                break;
            case "11"://yyymmdd  > dd/mm/yyyy
                txt.InnerText = Value.Substring(6, 2) + "/" + Value.Substring(4, 2) + "/" + Value.Substring(0, 4);
                break;
            case "12"://100 שח
                txt.InnerText = Convert.ToDouble(Value.Replace("-", "")).ToString("N0") + " ש''ח";
                if (Value.IndexOf('-') > -1)
                    txt.InnerText = Convert.ToDouble(Value.Replace("-", "")).ToString("N0") + " -" + " ש''ח";
                break;
            case "13"://ddmmyyy > dd/mm/yy
                txt.InnerText = Value.Substring(0, 2) + "/" + Value.Substring(2, 2) + "/" + Value.Substring(4, 2);
                break;
            case "14"://yyyymmdd > dd/mm/yy
                txt.InnerText = Value.Substring(6, 2) + "/" + Value.Substring(4, 2) + "/" + Value.Substring(2, 2);
                break;
            case "25"://HHmmss  > HH:mm
                txt.InnerText = Value.Substring(0, 2) + ":" + Value.Substring(2, 2);
                break;
            case "27"://1,000
                txt.InnerText = Convert.ToDouble(Value).ToString("N0");
                break;
            case "28"://1,000%
                txt.InnerText = Convert.ToDouble(Value).ToString("N0") + "%";
                break;
        }
    }
    private void SetAlignments(ref HtmlGenericControl td, string AlignmentID)
    {
        switch (AlignmentID)
        {
            case "1"://Right
                td.Style["text-align"] = "right";
                break;
            case "2"://Center
                td.Style["text-align"] = "center";
                break;
            case "3"://left
                td.Style["text-align"] = "left";
                break;
        }
    }
}