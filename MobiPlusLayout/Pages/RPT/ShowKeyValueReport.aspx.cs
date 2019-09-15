using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;
using System.Web.UI.HtmlControls;
using ClosedXML.Excel;
using System.IO;
using System.Configuration;
using System.Text;

public partial class Pages_RPT_ShowKeyValueReport : PageBaseCls
{
    private static string CssClassKey;
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
    public static string ColDelimiter;
    private static DataTable dtStyles;
    private static string ImagesDir;

    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (Request.QueryString["ID"] != null)
            ReportID = Request.QueryString["ID"].ToString();

        if (Request.QueryString["Name"] != null)
            ReportName = Request.QueryString["Name"].ToString();

        if (!IsPostBack)
        {
            if (Request.QueryString["Width"] != null)
                Width = Request.QueryString["Width"].ToString();

            if (Request.QueryString["Height"] != null)
                Height = Request.QueryString["Height"].ToString();

            if (Request.QueryString["WinID"] != null)
                WinID = Request.QueryString["WinID"].ToString();

            if (ColDelimiter==null && ConfigurationManager.AppSettings["GridColDelimiter"] != null)
                ColDelimiter = ConfigurationManager.AppSettings["GridColDelimiter"].ToString();

            if (ImagesDir == null && ConfigurationManager.AppSettings["ImagesDir"] != null)
                ImagesDir = ConfigurationManager.AppSettings["ImagesDir"].ToString();

            init();
        }
    }
    protected void DownloadFile(object sender, EventArgs e)
    {
        ResponsBytes(File.ReadAllBytes(ImagesDir + hdnFileName.Value), hdnFileName.Value.Split('.')[1]);
    }

    private void init()
    {
        if (CssClassKey == null)
            CssClassKey = ConfigurationManager.AppSettings["ReportKeyValueCssClassKey"].ToString();

        Literal cssFile = new Literal() { Text = @"" + CssClassKey + "" };
        stMain.Controls.Add(cssFile);


        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "UserID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
            else if (arKeys[i] == "UserID")
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
        if (dtRep != null && dtRep.Rows.Count > 0)
        {
            if (dtStyles == null)
                dtStyles = WR.MPLayout_GetReportStyles(SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
            hdnGridStylesByDB.Value = WR.GetJson(dtStyles);

            //for (int i = 0; i < dtRep.Rows.Count; i++)
            //{
            //    var Key = "STYLE_" + dtRep.Rows[i]["ColName"].ToString();
            //    if (!isThereStyle(dtRep, Key))
            //    {
            //        colNames += ",'" + Key + "'";
            //    }
            //}

            DataTable dtControl = WR.MPLayout_GetQueryDataDT(ReportID, SessionVersionID, Params, ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtControl != null && dtControl.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("<table class='tAll'>");
                bool isBlink = false;
                for (int i = 0; i < dtRep.Rows.Count; i++)
                {
                    if (Convert.ToDouble(dtRep.Rows[i]["ColWidthWeight"].ToString()) == 0)//hidden
                    {
                        sb.Append("<tr>");
                        sb.Append("<td colspan='2'>");
                        sb.Append("<input type='hidden' value='" + dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString() + "' id='hdn" + dtRep.Rows[i]["ColName"].ToString() + "' />");
                        sb.Append("</td>");
                        sb.Append("</tr>");
                    }
                    else
                    {
                        sb.Append("<tr>");
                        sb.Append("<td class='ReportKeyValueKey' style='width:"+ (100 - Convert.ToDouble(dtRep.Rows[i]["ColWidthWeight"].ToString())).ToString() + "%;'>");
                        sb.Append(dtRep.Rows[i]["ColCaption"].ToString());
                        sb.Append("</td>");
                        sb.Append("<td class='ReportKeyValueValue' >");
                        if (Convert.ToUInt32(dtRep.Rows[i]["ColTypeID"].ToString()) <= 4)//int,float,string,const
                        {
                            string style = GetStyleVals(dtRep.Rows[i]["StyleName"].ToString(), out isBlink);
                            for (int u = 0; u < dtControl.Columns.Count; u++)
                            {
                                if (dtControl.Columns[u].ColumnName == "style_" + dtRep.Rows[i]["ColName"].ToString().ToLower())//_style col
                                {
                                    style = GetStyleVals(dtControl.Rows[0][dtControl.Columns[u].ColumnName].ToString(), out isBlink);
                                }
                            }
                            

                            if (isBlink)
                                sb.Append("<span style='animation: blinker 1s linear infinite;"+ style + "'>" + GetFormatVal(dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString(), dtRep.Rows[i]["FormatID"].ToString()) + "</span>");
                            else
                                sb.Append("<span style='"+ style + "'>" + GetFormatVal(dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString(), dtRep.Rows[i]["FormatID"].ToString())+ " </ span > ");
                        }
                        else if (Convert.ToUInt32(dtRep.Rows[i]["ColTypeID"].ToString()) == 6)//image
                        {
                            byte[] data = File.ReadAllBytes(ImagesDir + dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString());

                            sb.Append("<img onclick='ShowBigImg(this.id);' class='KVImg' id='imgb"+i.ToString()+"' alt='img"+ dtRep.Rows[i]["ColName"].ToString() + "' width=" + dtRep.Rows[i]["ColWidthWeight"].ToString()  + " * 100 / $('.tAll').width() +'px' src='data:image/png;base64," + Convert.ToBase64String(data) +"' />");
                        }
                        else if (Convert.ToUInt32(dtRep.Rows[i]["ColTypeID"].ToString()) == 7)//ProgressBar
                        {
                            sb.Append("<div style='padding-top:3px;height:17px;max-width:" + dtRep.Rows[i]["ColWidthWeight"].ToString() + "px;" + GetStyleVals(dtRep.Rows[i]["StyleName"].ToString(), out isBlink) +
                                "' align='center'>"+ dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString() + "%</div>");
                        }
                        else if (Convert.ToUInt32(dtRep.Rows[i]["ColTypeID"].ToString()) == 8)//CheckBox
                        {
                            if(dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString()=="1")
                                sb.Append("<input type='checkbox' checked='checked' id='cb" + dtRep.Rows[i]["ColName"].ToString() + "' />");
                            else
                                sb.Append("<input type='checkbox'  id='cb" + dtRep.Rows[i]["ColName"].ToString() + "' />");
                        }
                        else if (Convert.ToUInt32(dtRep.Rows[i]["ColTypeID"].ToString()) == 9)//document
                        {
                            sb.Append("<a href='javascript:openDoc(\""+ dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString() + "\");'>"+ dtControl.Rows[0][dtRep.Rows[i]["ColName"].ToString()].ToString() + "</a>");
                        }
                        sb.Append("</td>");
                        sb.Append("</tr>");
                    }
                }
                sb.Append("</table>");

                dPage.InnerHtml = sb.ToString();
            }
        }
    }
    private string GetFormatVal(string val, string formatID)
    {
        try
        {
            switch (formatID)
            {
                case "0"://STRING_0// STRING
                case "1":
                    //val = val;
                    break;
                case "2"://0.00%
                    val = Convert.ToDouble(val).ToString("N2") + "%";
                    break;
                case "3"://מספר שלם
                    val = Convert.ToDouble(val).ToString("N0");
                    break;
                case "8"://1,000.00
                    val = Convert.ToDouble(val).ToString("N2");
                    break;
                case "9"://1,000.00%
                    val = Convert.ToDouble(val).ToString("N2") + "%";
                    break;
                case "11"://yyymmdd  > dd/mm/yyyy
                    val = val.Substring(6, 2) + "/" + val.Substring(4, 2) + "/" + val.Substring(0, 4);
                    break;
                case "12"://100 שח
                    val = Convert.ToDouble(val).ToString("N0") + " ₪";
                    break;
                case "13"://ddmmyyy > dd/mm/yy
                    val = val.Substring(0, 2) + "/" + val.Substring(3, 2) + "/" + val.Substring(4, 4);
                    break;
                case "14"://yyyymmdd > dd/mm/yy
                    val = val.Substring(6, 2) + "/" + val.Substring(4, 2) + "/" + val.Substring(0, 4);
                    break;
                case "25"://HHmmss  > HH:mm
                    val = val.Substring(0, 2) + ":" + val.Substring(2, 2);
                    break;
                case "27"://1,000
                    val = Convert.ToDouble(val).ToString("N0");
                    break;
                case "28"://1,000
                    val = Convert.ToDouble(val).ToString("N0") +"%";
                    break;
                case "29"://1,000 שח
                    val = Convert.ToDouble(val).ToString("N0") + " ₪";
                    break;
                case "30"://1,000.00 שח
                    val = Convert.ToDouble(val).ToString("N2") + " ₪";
                    break;

            }
        }
        catch(Exception ex)
        {

        }
        return val;
    }
    private string GetStyleVals(string StyleName, out bool isBlink)
    {
        isBlink = false;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dtStyles.Rows.Count; i++)
        {
            if (dtStyles.Rows[i]["StyleName"].ToString().ToLower() == StyleName.ToLower())
            {
                sb.Append("font-size:" + dtStyles.Rows[i]["FontSize"].ToString() + ";");
                sb.Append("font-family:" + dtStyles.Rows[i]["FontSize"].ToString() + ";");
                sb.Append("color:" + dtStyles.Rows[i]["ForeColor"].ToString() + ";");
                sb.Append("background-color:" + dtStyles.Rows[i]["BackColor"].ToString() + ";");

                if (dtStyles.Rows[i]["isBold"].ToString() == "1")
                    sb.Append("font-weight:700;");

                if (dtStyles.Rows[i]["isUnderline"].ToString() == "1")
                    sb.Append("text-decoration:'underline';");

                if (dtStyles.Rows[i]["isBlink"].ToString() == "1")
                    isBlink = true;
                break;
            }
        }
        return sb.ToString();
    }
    private void ResponsBytes(byte[] file, string Pre)
    {
        try
        {
            Response.Clear();
            switch (Pre.ToLower())
            {
                case "pdf":
                    Response.ContentType = "application/pdf";
                    break;
                case "txt":
                    Response.ContentType = "text/plain";
                    break;
                case "xls":
                    Response.ContentType = "application/vnd.ms-excel";
                    break;
                case "xlsx":
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    break;
                case "doc":
                    Response.ContentType = "application/msword";
                    break;
                case "docx":
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                    break;
                case "ppt":
                    Response.ContentType = "application/vnd.ms-powerpoint";
                    break;
                case "pptx":
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                    break;
                case "png":
                    Response.ContentType = "image/png";
                    break;
                case "jpg":
                    Response.ContentType = "image/jpeg";
                    break;
            }

            Response.AddHeader("content-disposition", "attachment;    filename=file." + Pre);
            Response.AddHeader("File-Name", "file." + Pre);
            Response.AddHeader("content-length", file.Length.ToString());
            Response.BinaryWrite(file);
            Response.Flush();
            Response.End();

            ////using (Bitmap image = new Bitmap(Context.Server.MapPath("images/stars_5.png")))
            ////{
            ////    using(MemoryStream ms = new MemoryStream())
            ////    {
            ////        image.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
            ////        ms.WriteTo(Context.Response.OutputStream);
            ////    }
            ////}

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}