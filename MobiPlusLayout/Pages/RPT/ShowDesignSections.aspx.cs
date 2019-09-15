using System;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Pages_RPT_ShowSections : PageBaseCls
{
    public string ReportID = "";
    public string Width = "";
    public string Height = "";
    public string WinID = "WinID";
    public string RowOpenReport = "0";
    public string RowOpenForm = "0";
    public string RowOpenRoutes = "0";
    public string Params = "";
    public string Lang = "";
    public static DataTable dtStyles;

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
            Height = (Convert.ToDouble(Height) - 10).ToString();
            if (Request.QueryString["WinID"] != null)
                WinID = Request.QueryString["WinID"].ToString();

            init();
        }
    }
    private void init()
    {
        Params = "";
        DataTable dtG = null;
        MPLayoutService WR = null;
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "ID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
        }
        StringBuilder sb = new StringBuilder();
        try
        {
            WR = new MPLayoutService();
            dtG = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
        }
        catch (Exception)
        {

        }
        if (dtG != null && dtG.Rows.Count > 0)
        {
            try
            {

                DataTable dtControl = WR.MPLayout_GetQueryDataDT(ReportID, SessionVersionID, Params, ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtControl != null)
                {
                    hdnData.Value = WR.GetJson(dtControl);

                    if (dtG.Rows.Count > 0)
                    {
                        if (dtG.Rows[0]["HeaderZoomObjTypeID"].ToString() == "2")//report
                        {
                            RowOpenReport = dtG.Rows[0]["HeaderZoomObjID"].ToString();
                        }
                        else if (dtG.Rows[0]["HeaderZoomObjTypeID"].ToString() == "5")//form
                        {
                            RowOpenForm = dtG.Rows[0]["HeaderZoomObjID"].ToString();
                        }

                    }

                    switch (dtG.Rows[0]["ChosenTemplet"].ToString())
                    {
                        case "טאמפלט 1":
                            sb.Append("");
                            sb.Append("<div class=\"TempletBox PerG\" style=\"width:" + Width + "px;height:" + Height + "px;\"><div>");
                            for (int i = 0; i < dtControl.Rows.Count; i++)
                            {
                                sb.Append("<table cellpadding =\"0\" cellspacing=\"0\" width=\"100%\" class=\"tblValues\">" +
                                         "<tr> " +
                                             "<td>" + dtControl.Rows[i]["Title"].ToString() + " " + dtControl.Rows[i]["Percents"].ToString() + "% " +
                                             "</td> " +
                                         "</tr> " +
                                         "<tr> " +
                                             "<td colspan =\"2\"> " +
                                                 "<div class=\"rowAllvalue\"> " +
                                                     "<div class=\"dValue2\" style=\"background-color:" + dtControl.Rows[i]["PercentsBGColor"].ToString() + ";width: " + dtControl.Rows[i]["Percents"].ToString() + "%;\">&nbsp;</div> " +
                                                 "</div> " +
                                             "</td> " +
                                         "</tr> " +
                                     "</table>");

                            }
                            sb.Append("</div></div>");

                            break;
                        case "טאמפלט 2":
                            sb.Append("<div class=\"TempletBox PerG\" style=\"width:" + Width + "px;height:" + Height + "px;\"><div>");
                            for (int i = 0; i < dtControl.Rows.Count; i++)
                            {
                                sb.Append("<table cellpadding =\"0\" cellspacing=\"0\" width=\"100%\" class=\"tblValues\"> " +
                                        "<tr> " +
                                            "<td> " + dtControl.Rows[i]["Title"].ToString() + " " +
                                            "</ td> " +
                                        "</ tr> " +
                                        "<tr> " +
                                            "<td colspan =\"2\"> " +
                                                "<div class=\"rowAllvalue2\"> " +
                                                    "<div class=\"dValue12\" style=\"background-color:" + dtControl.Rows[i]["PercentsBGColor"].ToString() + ";width: " + dtControl.Rows[i]["Percents"].ToString() + "%;\">" + dtControl.Rows[i]["Percents"].ToString() + "%</div> " +
                                                "</div> " +
                                            "</td> " +
                                        "</tr> " +
                                    "</table>");
                            }

                            sb.Append("</div></div>");
                            break;
                        case "טאמפלט 3":
                        case "טאמפלט 4":
                        case "טאמפלט 5":
                        case "טאמפלט 6":
                            sb.Append("<div class=\"TempletBox\" style=\"width:" + Width + "px;height:" + Height + "px;\"> " +
                               "<div class=\"ColordBox\" style=\"background-color:" + dtControl.Rows[0]["BGColor"].ToString() + " !important;\"> " +
                                   "<div class=\"ColordMainValue\"> " +
                                       "<div class=\"Colorval1\" style=\"color:" + dtControl.Rows[0]["Color"].ToString() + ";\">" + dtControl.Rows[0]["Value"].ToString() + "</div> " +
                                       "<div class=\"Colorval2\"> " +
                                           "<img class='imgTempletBox' src=\"../../Handlers/ShowImage.ashx?id=" + dtControl.Rows[0]["ImgID"].ToString() + "\" /> " +
                                       "</div> " +
                                   "</div> " +
                                   "<div class=\"ColordSecondValue\" style=\"color:" + dtControl.Rows[0]["Color"].ToString() + ";\">" + dtControl.Rows[0]["Title"].ToString() + "</div> " +
                               "</div> " +
                           "</div> ");

                            break;
                        case "טאמפלט 7":
                        case "טאמפלט 8":
                        case "טאמפלט 9":
                        case "טאמפלט 10":
                        case "טאמפלט 11":
                            //N'יומי' AS TileDayly, N'שבועי' AS TileWeekly, N'חודשי' AS TileMonthly
                            sb.Append("<div class=\"TempletBox cGreenVis\" style=\"color:" + dtControl.Rows[0]["Color"].ToString() + " !important;background-color:" + dtControl.Rows[0]["BGColor"].ToString() + " !important;width:" + Width + "px;height:" + Height + "px;\"> " +
                                          "<div class=\"Visd\"> " +
                                              "<div class=\"VisHeader\"> " +
                                                  dtControl.Rows[0]["Title"].ToString() + " " +
                                              "</div> " +
                                              "<table cellpadding =\"0\" cellspacing=\"0\" class=\"tblVis\"> " +
                                                  "<tr> " +
                                                      "<td class=\"tnlVisHeader\">" + dtControl.Rows[0]["TitleMonthly"].ToString() + " " +
                                                      "</td> " +
                                                      "<td class=\"tblVizBorder\">&nbsp;</td> " +
                                                      "<td class=\"tnlVisHeader\">" + dtControl.Rows[0]["TitleWeekly"].ToString() + " " +
                                                      "</td> " +
                                                      "<td class=\"tblVizBorder\">&nbsp;</td> " +
                                                      "<td class=\"tnlVisHeader\">" + dtControl.Rows[0]["TitleDayly"].ToString() + " " +
                                                      "</td> " +
                                                  "</tr> " +
                                                  "<tr> " +
                                                      "<td class=\"tnlVisItem\">" + dtControl.Rows[0]["Monthly"].ToString() + " " +
                                                      "</td> " +
                                                      "<td class=\"tblVizBorder\">&nbsp;</td> " +
                                                      "<td class=\"tnlVisItem\">" + dtControl.Rows[0]["Weekly"].ToString() + " " +
                                                      "</td> " +
                                                      "<td class=\"tblVizBorder\">&nbsp;</td> " +
                                                      "<td class=\"tnlVisItem\">" + dtControl.Rows[0]["Percents"].ToString() + " " +
                                                      "</td> " +
                                                  "</tr> " +
                                              "</table> " +
                                              "<div class=\"rowAllvalue3\"> " +
                                                  "<div class=\"dValueVis\" style=\"background-color:" + dtControl.Rows[0]["LineColor"].ToString() + ";width: " + dtControl.Rows[0]["Percents"].ToString() + "%;\"></div> " +
                                              "</div> " +
                                              "<div class=\"VisFotter\"> " +
                                                  "<table cellpadding =\"1\" cellspacing=\"1\"> " +
                                                      "<tr> ");
                            if (dtControl.Rows[0]["IsUp"].ToString() == "1")
                            {
                                sb.Append("<td>▲ " + dtControl.Rows[0]["Percents"].ToString() + "%+  " +
                                   dtControl.Rows[0]["Footer"].ToString() + " " +
                                                                "</td> " +
                                                            "</tr> " +
                                                        "</table> " +
                                                    "</div> " +
                                                "</div> " +
                                            "</div>");
                            }
                            else
                            {
                                sb.Append("<td>▼ " + dtControl.Rows[0]["Percents"].ToString() + "%-  " +
                                dtControl.Rows[0]["Footer"].ToString() + " " +
                                                             "</td> " +
                                                         "</tr> " +
                                                     "</table> " +
                                                 "</div> " +
                                             "</div> " +
                                         "</div>");
                            }

                            break;

                        case "1טאמפלט 2":
                        case "טאמפלט 13":
                        case "טאמפלט 14":
                        case "טאמפלט 15":
                        default:
                            sb.Append("<div class=\"TempletBox cGray\"  style=\"color:" + dtControl.Rows[0]["Color"].ToString() + " !important;background-color:" + dtControl.Rows[0]["BGColor"].ToString() + " !important;width:" + Width + "px;height:" + Height + "px;\"> " +
                                          "<div class=\"FeedMSGHeader\"> " +
                                                dtControl.Rows[0]["Title"].ToString() + " " +
                                            "</div> " +
                                            "<div> ");

                            for (int i = 0; i < dtControl.Rows.Count; i++)
                            {
                                sb.Append("<table cellpadding =\"1\" cellspacing=\"1\" class=\"tblFeed\" style=\"border-bottom: 1px solid " + dtControl.Rows[i]["LineColor"].ToString() + ";\"> " +
                                                        "<tr> " +
                                                            "<td rowspan =\"2\"> " +
                                                                "<img alt =\"\" class=\"FeedImg\" src=\"../../Handlers/ShowImage.ashx?id=" + dtControl.Rows[i]["ImgID"].ToString() + "\" /> " +
                                                            "</td> " +
                                                            "<td class=\"FeedHeader\">" + dtControl.Rows[i]["RowTitle"].ToString() + " " +
                                                            "</td> " +
                                                        "</tr> " +
                                                        "<tr> " +
                                                            "<td>" + dtControl.Rows[i]["RowText"].ToString() + " " +
                                                            "</td> " +
                                                        "</tr> " +
                                                    "</table> ");
                            }
                            sb.Append("</div> " +
                            "</div>");
                            break;
                    }
                }
            }
            catch (Exception) { }

            SectionsDiv.InnerHtml = sb.ToString();

        }
    }

    private void SetStyles(ref HtmlGenericControl txt, string StyleID, string StyleName = "")
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
                txt.InnerText = "₪" + Convert.ToDouble(Value.Replace("-", "")).ToString("N0");
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