using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;
using System.Web.UI.HtmlControls;

public partial class Pages_RPT_ShowSections : PageBaseCls
{
    public string ReportID = "";
    public string Width = "";
    public string Height = "";
    public string WinID = "WinID";
    public string RowOpenReport = "0";
    public string RowOpenForm = "0";
    public string Params = "";
    public string Lang = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;

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

            init();
        }
    }
    private void init()
    {
        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "ID") 
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
        }

        MPLayoutService WR = new MPLayoutService();
        DataTable dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
        int Counter = 0;
        if (dtRep != null && dtRep.Rows.Count > 0)
        {
            try
            {
                DataTable dt = WR.MPLayout_GetQueryDataDT(ReportID, SessionVersionID, Params, ConStrings.DicAllConStrings[SessionProjectName]);
                if (dt != null)
                {
                    HtmlGenericControl TblAll = new HtmlGenericControl("table");
                    //TblAll.Attributes["border"] = "1";
                    HtmlGenericControl trMain = new HtmlGenericControl("tr");
                    SectionsDiv.Attributes["class"] = "AllSectionWidjet";
                    SectionsDiv.Style["height"] = Height + "px";

                    TblAll.Attributes["cellpadding"] = "0";
                    TblAll.Attributes["cellspacing"] = "0";

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
                        if (dtRep.Rows[0]["SectionsPerRow"].ToString() != "")
                            TblSection.Style["width"] = ((Convert.ToDouble(Width) + 33 - (Convert.ToInt32(dtRep.Rows[0]["SectionsPerRow"].ToString()) * 8)) / Convert.ToInt32(dtRep.Rows[0]["SectionsPerRow"].ToString())).ToString() + "px";

                        if (i == 0)
                            TblSection.Style["margin-right"] = "1px";

                        TblSection.Style["overflow"] = "hidden";

                        TblSection.Style["height"] = "60px";
                        if (dtRep.Rows[0]["SectionsPerRow"].ToString() != "")
                            TblSection.Style["height"] = dtRep.Rows[0]["SectionsRowHeight"].ToString() + "px";

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


                        for (int y = 0; y < dtRep.Rows.Count; y++)
                        {
                            if (dtRep.Rows[y]["ColName"].ToString() == "Text1")
                            {
                                if (dt.Columns["STYLE_Text1"] == null)
                                    SetStyles(ref txt1, dtRep.Rows[y]["StyleID"].ToString());
                                SetFormat(ref txt1, dtRep.Rows[y]["FormatID"].ToString(), dt.Rows[i]["Text1"].ToString());
                                SetAlignments(ref trRowTd2, dtRep.Rows[y]["AlignmentID"].ToString());
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

                        for (int y = 0; y < dtRep.Rows.Count; y++)
                        {
                            if (dtRep.Rows[y]["ColName"].ToString() == "Text2")
                            {
                                if (dt.Columns["STYLE_Text2"] == null)
                                    SetStyles(ref txt2, dtRep.Rows[y]["StyleID"].ToString());
                                SetFormat(ref txt2, dtRep.Rows[y]["FormatID"].ToString(), dt.Rows[i]["Text2"].ToString());
                                SetAlignments(ref trRowTd2Tow, dtRep.Rows[y]["AlignmentID"].ToString());
                                trRowTd2Tow.Style["width"] = "100%";

                                td2.Style["vertical-align"] = "top";
                                break;
                            }
                        }
                        if (dt.Columns["STYLE_Text2"] != null)
                        {
                            SetStylesByName(ref txt2, dt.Rows[i]["STYLE_Text2"].ToString());
                        }

                        if (dt.Rows[0]["ZoomObjTypeID"].ToString() == "2"/*report*/ && dt.Rows[i]["ZoomObjID"].ToString() != "")
                        {
                            RowOpenReport = dt.Rows[i]["ZoomObjID"].ToString();
                            TblSection.Attributes["onclick"] = "parent.openNewReport2(\"" + RowOpenReport + "\",\"" + Params + "\");";
                        }
                        else if (dt.Rows[i]["ZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dt.Rows[i]["ZoomObjID"].ToString() != "")
                        {
                            RowOpenReport = ReportID;
                            TblSection.Attributes["onclick"] = "parent.openNewReport2(\"" + RowOpenReport + "\",\"" + Params + "\");";
                        }
                        else if (dt.Rows[i]["ZoomObjTypeID"].ToString() == "5"/*form*/ && dt.Rows[i]["ZoomObjID"].ToString() != "")
                        {
                            RowOpenForm = dt.Rows[i]["ZoomObjID"].ToString();
                            TblSection.Attributes["onclick"] = "parent.openNewForm2(\"" + RowOpenForm + "\",\"" + Params + "\");";
                        }
                        else
                            RowOpenReport = "0";


                        HtmlGenericControl br = new HtmlGenericControl("span");

                        HtmlGenericControl img1 = new HtmlGenericControl("image");
                        img1.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img1.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img1.Style["position"] = "fixed";
                        img1.Style["top"] = "10px";

                        HtmlGenericControl img2 = new HtmlGenericControl("image");
                        img2.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img2.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img2.Style["position"] = "fixed";
                        img2.Style["top"] = "10px";

                        HtmlGenericControl img3 = new HtmlGenericControl("image");
                        img3.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img3.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img3.Style["position"] = "fixed";
                        img3.Style["top"] = "10px";

                        HtmlGenericControl img4 = new HtmlGenericControl("image");
                        img4.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img4.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img4.Style["position"] = "fixed";
                        img4.Style["top"] = "30px";

                        HtmlGenericControl img5 = new HtmlGenericControl("image");
                        img5.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img5.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img5.Style["position"] = "fixed";
                        img5.Style["top"] = "30px";

                        HtmlGenericControl img6 = new HtmlGenericControl("image");
                        img6.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img6.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img6.Style["position"] = "fixed";
                        img6.Style["top"] = "30px";

                        HtmlGenericControl img7 = new HtmlGenericControl("image");
                        img7.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img7.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img7.Style["position"] = "fixed";
                        img7.Style["top"] = "60px";

                        HtmlGenericControl img8 = new HtmlGenericControl("image");
                        img8.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img8.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img8.Style["position"] = "fixed";
                        img8.Style["top"] = "60px";

                        HtmlGenericControl img9 = new HtmlGenericControl("image");
                        img9.Attributes["src"] = "../../Handlers/ShowImage.ashx?ImageName=" + dt.Rows[i]["Image1"].ToString();
                        img9.Style["Height"] = dt.Rows[i]["ImageHeight"].ToString() + "px";
                        img9.Style["position"] = "fixed";
                        img9.Style["top"] = "60px";

                        switch (dt.Rows[i]["ImagePosition"].ToString())
                        {
                            case "1":
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img8.Style["display"] = "none";
                                img9.Style["display"] = "none";

                                break;
                            case "2":
                                img1.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img8.Style["display"] = "none";
                                img9.Style["display"] = "none";

                                break;
                            case "3":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img8.Style["display"] = "none";
                                img9.Style["display"] = "none";
                                break;
                            case "4":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img8.Style["display"] = "none";
                                img9.Style["display"] = "none";
                                break;
                            case "5":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img9.Style["display"] = "none";
                                break;
                            case "6":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img9.Style["display"] = "none";
                                break;
                            case "7":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img8.Style["display"] = "none";
                                img9.Style["display"] = "none";
                                break;
                            case "8":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img9.Style["display"] = "none";
                                break;
                            case "9":
                                img1.Style["display"] = "none";
                                img2.Style["display"] = "none";
                                img3.Style["display"] = "none";
                                img4.Style["display"] = "none";
                                img5.Style["display"] = "none";
                                img6.Style["display"] = "none";
                                img7.Style["display"] = "none";
                                img8.Style["display"] = "none";
                                break;
                        }


                        trRowTd1.Controls.Add(img2);
                        br.InnerHtml = "<BR/>";
                        trRowTd1.Controls.Add(br);

                        trRowTd1.Controls.Add(img1);
                        trRowTd2.Controls.Add(txt1);

                        trRowTd3.Controls.Add(img3);

                        trRow.Controls.Add(trRowTd1);
                        trRow.Controls.Add(trRowTd2);
                        trRow.Controls.Add(trRowTd3);

                        tblRow.Controls.Add(trRow);

                        td1.Controls.Add(tblRow);

                        tr1.Controls.Add(td1);
                        TblSection.Controls.Add(tr1);

                        trRowTd1Tow.Controls.Add(img5);
                        br.InnerHtml = "<BR/>";
                        trRowTd1Tow.Controls.Add(br);

                        trRowTd1Tow.Controls.Add(img4);
                        trRowTd1Tow.Controls.Add(br);

                        trRowTd1Tow.Controls.Add(img7);
                        trRowTd1Tow.Controls.Add(img8);
                        trRowTd1Tow.Controls.Add(img9);

                        trRowTd2Tow.Controls.Add(txt2);
                        trRowTd3Tow.Controls.Add(img6);

                        trRowTow.Controls.Add(trRowTd1Tow);
                        trRowTow.Controls.Add(trRowTd2Tow);
                        trRowTow.Controls.Add(trRowTd3Tow);

                        tblRowTow.Controls.Add(trRowTow);

                        td2.Controls.Add(tblRowTow);
                        tr2.Controls.Add(td2);
                        TblSection.Controls.Add(tr2);

                        tdMain.Controls.Add(TblSection);

                        trMain.Controls.Add(tdMain);

                        if ((i + 1) % Convert.ToInt32(dtRep.Rows[0]["SectionsPerRow"].ToString()) == 0)
                        {
                            Counter = 0;
                            br.InnerHtml = "<BR/>";
                            SectionsDiv.Controls.Add(br);


                            TblAll.Controls.Add(trMain);
                            trMain = new HtmlGenericControl("tr");
                        }
                    }
                    if (Counter > 0)
                    {
                        TblAll.Controls.Add(trMain);
                    }
                    SectionsDiv.Controls.Clear();
                    SectionsDiv.Controls.Add(TblAll);
                }
            }
            catch (Exception) { }
            
          
        }
    }
    DataTable dtStyles;
    private void SetStyles(ref HtmlGenericControl txt, string StyleID,string StyleName="")
    {
        if (dtStyles == null)
        {
            MPLayoutService WR = new MPLayoutService();
            dtStyles = WR.MPLayout_GetReportStyles(SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
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
                dv.RowFilter = "StyleName = '" + StyleName+"'";
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
        SetStyles(ref txt, "0", StyleName);        
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
                txt.InnerText = "₪" + Convert.ToDouble(Value.Replace("-", "")).ToString("N0") ;
                if (Value.IndexOf('-') > -1)
                    txt.InnerText = "₪" + Convert.ToDouble(Value.Replace("-", "")).ToString("N0") + " -";
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