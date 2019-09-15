using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Admin_ReportsEdit : PageBaseCls
{
    public string colModel = "";
    public string colNames = "";
    public string Caption = "";
    public string GridName = "";
    public double GridWidth = 0;
    public string GridParameters = "";

    public string colModelMD = "";
    public string colNamesMD = "";
    public string CaptionMD = "";
    public string GridNameMD = "";
    public double GridWidthMD = 0;
    public string GridParametersMD = "";
    public int Rows = 10;
    public int RowsModel = 10;

    public string LayoutTypeID="1";

    public string strGridColID = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    protected void ddlZoomObjTypes_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        DataTable dt1 = new DataTable("dt1");
        dt1.Columns.Add("Name");
        dt1.Columns.Add("id");

        ddlHeaderZoomObjs.DataSource = dt1;
        ddlHeaderZoomObjs.DataTextField = "Name";
        ddlHeaderZoomObjs.DataValueField = "id";
        ddlHeaderZoomObjs.DataBind();    

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        switch (ddlZoomObjTypes.SelectedValue)
        {
            case "1"://Compiled Activity  
                ddlHeaderZoomObjs.DataSource = wr.Layout_GetCompileActivities(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlHeaderZoomObjs.DataTextField = "CompileActivityName";
                ddlHeaderZoomObjs.DataValueField = "CompileActivityID";
                ddlHeaderZoomObjs.DataBind();                
                break;
            case "2"://Report 
                ddlHeaderZoomObjs.DataSource = wr.Layout_GetReports(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
                ddlHeaderZoomObjs.DataTextField = "ReportName";
                ddlHeaderZoomObjs.DataValueField = "ReportID";
                ddlHeaderZoomObjs.DataBind();   
                break;
            case "3"://Menu
                ddlHeaderZoomObjs.DataSource = wr.Layout_GetMenusForWeb(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
                ddlHeaderZoomObjs.DataTextField = "MenuName";
                ddlHeaderZoomObjs.DataValueField = "MenuID";
                ddlHeaderZoomObjs.DataBind();
                break;
            case "4"://Questionnaire
                ddlHeaderZoomObjs.DataSource = wr.Layout_GetQuestionnaires(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlHeaderZoomObjs.DataTextField = "questionnaireDescription";
                ddlHeaderZoomObjs.DataValueField = "idQuestionnaire";
                ddlHeaderZoomObjs.DataBind();
                break;
            case "5"://Designer Form 
                ddlHeaderZoomObjs.DataSource = wr.Layout_GetForms(LayoutTypeID,ConStrings.DicAllConStrings[SessionProjectName]);
                ddlHeaderZoomObjs.DataTextField = "FormName";
                ddlHeaderZoomObjs.DataValueField = "FormID";
                ddlHeaderZoomObjs.DataBind();
                ddlHeaderZoomObjs.Items.Remove(ddlHeaderZoomObjs.Items.FindByValue("0"));                
                break;
            case "6"://Doc Type 
                ddlHeaderZoomObjs.DataSource = wr.Layout_GetDocTypes(LayoutTypeID, ConStrings.DicAllConStrings[SessionProjectName]);
                ddlHeaderZoomObjs.DataTextField = "Description";
                ddlHeaderZoomObjs.DataValueField = "DocTypeId";
                ddlHeaderZoomObjs.DataBind();
                break;
        }
        upddlHeaderZoomObjs.Update();
    }

    protected void ddlRowReportZoomObjTypes_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        DataTable dt1 = new DataTable("dt1");
        dt1.Columns.Add("Name");
        dt1.Columns.Add("id");

        ddlRowReportZoomObjs.DataSource = dt1;
        ddlRowReportZoomObjs.DataTextField = "Name";
        ddlRowReportZoomObjs.DataValueField = "id";
        ddlRowReportZoomObjs.DataBind();    

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        switch (ddlRowReportZoomObjTypes.SelectedValue)
        {
            case "1"://Compiled Activity  
                ddlRowReportZoomObjs.DataSource = wr.Layout_GetCompileActivities(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlRowReportZoomObjs.DataTextField = "CompileActivityName";
                ddlRowReportZoomObjs.DataValueField = "CompileActivityID";
                ddlRowReportZoomObjs.DataBind();
                break;
            case "2"://Report 
                ddlRowReportZoomObjs.DataSource = wr.Layout_GetReports(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
                ddlRowReportZoomObjs.DataTextField = "ReportName";
                ddlRowReportZoomObjs.DataValueField = "ReportID";
                ddlRowReportZoomObjs.DataBind();
                break;
            case "3"://Menu
                break;
            case "4"://Questionnaire  
                break;
            case "5"://Designer Form 
                ddlRowReportZoomObjs.DataSource = wr.Layout_GetForms(LayoutTypeID,ConStrings.DicAllConStrings[SessionProjectName]);
                ddlRowReportZoomObjs.DataTextField = "FormName";
                ddlRowReportZoomObjs.DataValueField = "FormID";
                ddlRowReportZoomObjs.DataBind();
                ddlRowReportZoomObjs.Items.Remove(ddlRowReportZoomObjs.Items.FindByValue("0"));
                break;
            case "6"://Doc Type  
                ddlRowReportZoomObjs.DataSource = wr.Layout_GetDocTypes(LayoutTypeID, ConStrings.DicAllConStrings[SessionProjectName]);
                ddlRowReportZoomObjs.DataTextField = "Description";
                ddlRowReportZoomObjs.DataValueField = "DocTypeId";
                ddlRowReportZoomObjs.DataBind();
                
                break;
        }
        upddlRowReportZoomObjs.Update();
    }
    protected void ddlActionBtnOnTitleZoomType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        DataTable dt1 = new DataTable("dt1");
        dt1.Columns.Add("Name");
        dt1.Columns.Add("id");

        ddlActionBtnOnTitleZoomObj.DataSource = dt1;
        ddlActionBtnOnTitleZoomObj.DataTextField = "Name";
        ddlActionBtnOnTitleZoomObj.DataValueField = "id";
        ddlActionBtnOnTitleZoomObj.DataBind();

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        switch (ddlActionBtnOnTitleZoomType.SelectedValue)
        {
            case "1"://Compiled Activity  
                ddlActionBtnOnTitleZoomObj.DataSource = wr.Layout_GetCompileActivities(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlActionBtnOnTitleZoomObj.DataTextField = "CompileActivityName";
                ddlActionBtnOnTitleZoomObj.DataValueField = "CompileActivityID";
                ddlActionBtnOnTitleZoomObj.DataBind();
                break;
            case "2"://Report 
                ddlActionBtnOnTitleZoomObj.DataSource = wr.Layout_GetReports(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
                ddlActionBtnOnTitleZoomObj.DataTextField = "ReportName";
                ddlActionBtnOnTitleZoomObj.DataValueField = "ReportID";
                ddlActionBtnOnTitleZoomObj.DataBind();
                break;
            case "3"://Menu
                break;
            case "4"://Questionnaire  
                break;
            case "5"://Designer Form 
                ddlActionBtnOnTitleZoomObj.DataSource = wr.Layout_GetForms(LayoutTypeID, ConStrings.DicAllConStrings[SessionProjectName]);
                ddlActionBtnOnTitleZoomObj.DataTextField = "FormName";
                ddlActionBtnOnTitleZoomObj.DataValueField = "FormID";
                ddlActionBtnOnTitleZoomObj.DataBind();
                ddlActionBtnOnTitleZoomObj.Items.Remove(ddlRowReportZoomObjs.Items.FindByValue("0"));
                break;
            case "6"://Doc Type  
                ddlActionBtnOnTitleZoomObj.DataSource = wr.Layout_GetDocTypes(LayoutTypeID, ConStrings.DicAllConStrings[SessionProjectName]);
                ddlActionBtnOnTitleZoomObj.DataTextField = "Description";
                ddlActionBtnOnTitleZoomObj.DataValueField = "DocTypeId";
                ddlActionBtnOnTitleZoomObj.DataBind();
                break;
        }
        upddlActionBtnOnTitleZoomObj.Update();
    }
    private void init()
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        ddlReportTypes.DataSource = wr.Layout_GetReportTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlReportTypes.DataTextField = "ReportType";
        ddlReportTypes.DataValueField = "ReportTypeID";
        ddlReportTypes.DataBind();
        ddlReportTypes.SelectedValue = "1";

        ddlReportDataSources.DataSource = wr.Layout_GetReportsDataSources(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlReportDataSources.DataTextField = "ReportDataSourceName";
        ddlReportDataSources.DataValueField = "ReportDataSourceID";
        ddlReportDataSources.DataBind();
        ddlReportDataSources.SelectedValue = "1";

        ddlZoomObjTypes.DataSource = wr.Layout_GetZoomObjTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlZoomObjTypes.DataTextField = "ZoomObjType";
        ddlZoomObjTypes.DataValueField = "ZoomObjTypeID";
        ddlZoomObjTypes.DataBind();

        ddlRowReportZoomObjTypes.DataSource = wr.Layout_GetZoomObjTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlRowReportZoomObjTypes.DataTextField = "ZoomObjType";
        ddlRowReportZoomObjTypes.DataValueField = "ZoomObjTypeID";
        ddlRowReportZoomObjTypes.DataBind();

        ddlActionBtnOnTitleZoomType.DataSource = wr.Layout_GetZoomObjTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlActionBtnOnTitleZoomType.DataTextField = "ZoomObjType";
        ddlActionBtnOnTitleZoomType.DataValueField = "ZoomObjTypeID";
        ddlActionBtnOnTitleZoomType.DataBind();

        DataSet ds = wr.Layout_GetDDLs(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
        if (ds != null && ds.Tables.Count>3)
        {
            ddlColType.DataSource = ds.Tables[0];
            ddlColType.DataTextField = "TypeName";
            ddlColType.DataValueField = "ColTypeID";
            ddlColType.DataBind();

            ddlFormatString.DataSource = ds.Tables[1];
            ddlFormatString.DataTextField = "FormatString";
            ddlFormatString.DataValueField = "FormatID";
            ddlFormatString.DataBind();

            ddlAlignment.DataSource = ds.Tables[2];
            ddlAlignment.DataTextField = "Alignment";
            ddlAlignment.DataValueField = "AlignmentID";
            ddlAlignment.DataBind();


            ddlStyleName.DataSource = ds.Tables[3];
            ddlStyleName.DataTextField = "StyleName";
            ddlStyleName.DataValueField = "StyleID";
            ddlStyleName.DataBind();

            ddlReports.DataSource = ds.Tables[4];
            ddlReports.DataTextField = "ReportName";
            ddlReports.DataValueField = "ReportID";
            ddlReports.DataBind();

            try
            {
                if (Request.QueryString["ID"] != null)
                {
                    ddlReports.SelectedValue = Request.QueryString["ID"].ToString();
                }
                else
                {
                    ddlReports.SelectedValue = "0";
                }
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "GetReportData();", "setTimeout('GetReportData(); ShowCols();',100);", true);
            }
            catch (Exception ex)
            {
            }
        }

        
    }
}
