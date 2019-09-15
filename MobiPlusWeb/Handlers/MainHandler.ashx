<%@ WebHandler Language="C#" Class="MainHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using MobiPlus.BusinessLogic.Auth;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Runtime.Serialization;
using System.IO;

public class MainHandler : HandlerBaseCls
{
    private string Conn = "";
    private string[] arrTabs
    {
        get
        {
            if (HttpContext.Current.Session["arrTabs"] == null)
                HttpContext.Current.Session["arrTabs"] = new string[10];
            return (string[])HttpContext.Current.Session["arrTabs"];
        }
        set
        {
            HttpContext.Current.Session["arrTabs"] = value;
        }
    }
    public override void ProcessRequest(HttpContext context)
    {
        try
        {
            string[] arr = new string[ConStrings.DicAllConStrings.Keys.Count];
            ConStrings.DicAllConStrings.Keys.CopyTo(arr, 0);
            if (ConStrings.DicAllConStrings != null)
            {
                if (ConStrings.DicAllConStrings.Keys.Count == 1)//only one
                {
                    SessionProjectName = arr[0];
                }
            }
            SessionLanguage = "Hebrew";
            int SessionUserIDr = Convert.ToInt32(SessionUserID);
            context.Response.ContentType = "application/json";
            string strResponse = "";
            string method = context.Request.QueryString["MethodName"].ToString();
            switch (method)
            {
                case "GetJsonExm":
                    GetJsonExm();
                    break;
                case "AddEdit":
                    DateTime date = context.Request["dtCreate"] == null ? System.DateTime.Now.Date : Convert.ToDateTime(context.Request["dtCreate"]);
                    string name = context.Request["name"] == null ? "Delete" : context.Request["name"].ToString();
                    string Description = context.Request["Description"] == null ? "" : context.Request["Description"].ToString();

                    AddEdit(Convert.ToInt32(context.Request["id"]), name, Description, date, SessionUserIDr, out strResponse);

                    context.Response.Write(strResponse);
                    break;
                case "GetUsers":
                    GetUsers(context);
                    break;
                case "SetUserWidgetPosition":
                    SetUserWidgetPosition(SessionUserID.ToString(), context.Request["WidgetsUserID"].ToString(), ((Convert.ToDouble(context.Request["Width"].ToString())) / Convert.ToDouble(context.Session["DocWidth"]) * 100).ToString(),
                        (Convert.ToDouble(context.Request["Height"].ToString()) / Convert.ToDouble(context.Session["DocHeight"]) * 100).ToString(), context.Request["TabID"].ToString());
                    context.Response.Write("200");
                    break;
                case "SetPositiopnDocument":
                    context.Session["DocWidth"] = context.Request["ScreenWidth"].ToString();
                    context.Session["DocHeight"] = context.Request["ScreenHeight"].ToString();
                    context.Response.Write("200");
                    break;
                case "SetPositiopnWin":
                    context.Session["WinWidth"] = context.Request["ScreenWidth"].ToString();
                    context.Session["WinHeight"] = context.Request["ScreenHeight"].ToString();
                    if (Convert.ToDouble(context.Session["WinHeight"].ToString()) < 300)
                        context.Session["WinHeight"] = "400";

                    switch (context.Request["Type"].ToString())
                    {
                        case "RGBar":
                            context.Session["WinWidth27"] = context.Request["ScreenWidth"].ToString();
                            context.Session["WinHeight27"] = context.Request["ScreenHeight"].ToString();
                            if (Convert.ToDouble(context.Session["WinHeight27"].ToString()) < 300)
                                context.Session["WinHeight27"] = "400";
                            break;
                    }

                    context.Response.Write("200");
                    break;
                case "SetUserWidgetsOrder":
                    SetUserWidgetsOrder(SessionUserID.ToString(), context.Request["jsonObj"].ToString(), context.Request["TabID"].ToString());
                    context.Response.Write("200");
                    break;
                case "SetUserWidgetCol":
                    SetUserWidgetCol(SessionUserID.ToString(), context.Request["WidgetsUserID"].ToString(), context.Request["ColNum"].ToString(), context.Request["TabID"].ToString());
                    context.Response.Write("200");
                    break;
                case "UserLogin":
                    UserLogin(context, context.Request["UserName"].ToString(), context.Request["Password"].ToString());
                    break;
                case "AddTab":
                    AddTab(context, context.Request["TabName"].ToString());
                    break;
                case "GetAllWidgetsByPermissions":
                    GetAllWidgetsByPermissions(context);
                    break;
                case "AddWidgetToUser":
                    AddWidgetToUser(context, context.Request["WidgetID"].ToString(), context.Request["TabID"].ToString());
                    break;
                case "DeleteWidget":
                    DeleteWidget(context, context.Request["WidgetsUserID"].ToString(), context.Request["TabID"].ToString());
                    break;
                case "DeleteTag":
                    DeleteTag(context, context.Request["TabID"].ToString());
                    break;
                case "StrSrc":
                    string str = StrSrc(context.Request["url"].ToString(), context.Request["keyword"].ToString(), (context.Request["isLocal"].ToString()));
                    context.Response.Clear();
                    context.Response.ContentType = "text/plain";
                    //context.Response.AddHeader("content-length", str.Length.ToString());
                    context.Response.Flush();
                    context.Response.Write(str);
                    break;
                case "GridData":
                    GridData(context);
                    break;
                case "GridDataNew":
                    GridDataNew(context);
                    break;
                case "GridServerVersions":
                    GridServerVersions(context);
                    break;
                case "GridServerLayoutVersions":
                    GridServerLayoutVersions(context);
                    break;
                case "GetServerGroups":
                    GetServerGroups(context);
                    break;
                case "AddEditGridServerVersions":
                    AddEditGridServerVersions(context);
                    break;
                case "AddEditServerLayoutVersion":
                    AddEditServerLayoutVersion(context);
                    break;
                case "AddEditGrid":
                    AddEditGrid(context, out strResponse);

                    context.Response.Write(strResponse);
                    break;
                case "AddEditGridCols":
                    AddEditGridCols(context, out strResponse);

                    context.Response.Write(strResponse);
                    break;
                case "QueryTypes":
                    QueryTypes(context);
                    break;
                case "GetGrids":
                    GetGrids(context);
                    break;
                case "GetAlignment":
                    GetAlignment(context);
                    break;
                case "GetTypes":
                    GetTypes(context);
                    break;
                case "RetJSONBar":
                    RetJSONBar(context);
                    break;
                case "RetJSONPie":
                    RetJSONPie(context);
                    break;
                case "RetJSONLine":
                    RetJSONLine(context);
                    break;
                case "GetAgentSalesGraph":
                    GetAgentSalesGraph(context, context.Request.QueryString["iDate"].ToString(), context.Request.QueryString["AgentID"].ToString());
                    break;
                case "GroupNames":
                    GroupNames(context);
                    break;
                case "AddEditGridWidgets":
                    AddEditGridWidgets(context, out strResponse);
                    context.Response.Write(strResponse);
                    break;
                case "GetYaforaYazranPieRep":
                    GetYaforaYazranPieRep(context, context.Request.QueryString["iDate"].ToString(), context.Request.QueryString["AgentID"].ToString());
                    break;
                case "GetProjectTypes":
                    GetProjectTypes(context);
                    break;
                case "CheckRecursive":
                    CheckRecursive(context);
                    break;
                case "CheckRecursiveLayout":
                    CheckRecursiveLayout(context);
                    break;
                case "GetPieRep":
                    GetPieRep(context, context.Request.QueryString["iDate"].ToString(), context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["GraphID"].ToString());
                    break;
                case "GetBarData":
                    GetBarData(context, context.Request.QueryString["iDate"].ToString(), context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["GraphID"].ToString());
                    break;
                case "GetRGBarData":
                    GetRGBarData(context, context.Request.QueryString["iDate"].ToString(), context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["GraphID"].ToString());
                    break;
                case "GetLineData":
                    GetLineData(context, context.Request.QueryString["iDate"].ToString(), context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["GraphID"].ToString());
                    break;
                case "GetGraphsForGrid":
                    GetGraphsForGrid(context);
                    break;
                case "AddEditGraph":
                    AddEditGraph(context, out strResponse);

                    context.Response.Write(strResponse);
                    break;
                case "GetGridJump":
                    GetGridJump(context, context.Request.QueryString["GridName"].ToString(), context.Request.QueryString["id"].ToString());
                    break;
                case "GetNumerators":
                    GetNumerators(context);
                    break;
                case "SetNumerator":
                    SetNumerator(context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["NumeratorGroup"].ToString(), context.Request.QueryString["NumeratorValue"].ToString());
                    break;
                case "SetAllNumerators":
                    SetAllNumerators(context.Request.QueryString["Value"].ToString());
                    break;
                case "GetRGHBarData":
                    GetRGHBarData(context, context.Request.QueryString["GridParameters"].ToString(), context.Request.QueryString["GraphID"].ToString());
                    break;
                case "SetCustomersForAgent":
                    SetCustomersForAgent(context, context.Request.QueryString["FromAgentID"].ToString(), context.Request.QueryString["ToAgentID"].ToString(), context.Request.QueryString["StrCustmers"].ToString(), context.Request.QueryString["FromDate"].ToString(), context.Request.QueryString["ToDate"].ToString(), SessionUserID);
                    break;
                case "GetCustomersForAgent":
                    GetCustomersForAgent(context, context.Request.QueryString["FromAgentID"].ToString());
                    break;
                case "GetAllCustomersForDates":
                    GetAllCustomersForDates(context);
                    break;
                case "GetSalesMeterChart":
                    GetSalesMeterChart(context, context.Request.QueryString["Date"].ToString(), context.Request.QueryString["AgentID"].ToString());
                    break;
                case "DeleteCustomersForAgent":
                    DeleteCustomersForAgent(context, context.Request.QueryString["StrCustmers"].ToString(), SessionUserID);
                    break;
                case "DeleteTranCustomersForAgent":
                    DeleteTranCustomersForAgent(context, context.Request.QueryString["FromAgentID"].ToString(), context.Request.QueryString["StrCustmers"].ToString());
                    break;
                case "Layout_SetForm":
                    Layout_SetForm(context, context.Request.QueryString["FormID"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString(), context.Request.QueryString["FormName"].ToString(),
                        context.Request.QueryString["FormDescription"].ToString(), context.Request.QueryString["IsShowUpdateTime"].ToString(), context.Request.QueryString["IsTabAlwaysOnTop"].ToString()
                        , context.Request.QueryString["IsActive"].ToString(), context.Request.QueryString["TabAlignmentID"].ToString(), SessionUserID, context.Request.QueryString["ProjectID"].ToString(), context.Request.QueryString["IsScroll"].ToString());
                    break;
                case "Layout_GetFormData":
                    Layout_GetFormData(context, context.Request.QueryString["FormID"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString());
                    break;
                case "Layout_GetFormTabs":
                    Layout_GetFormTabs(context, context.Request.QueryString["FormID"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString());
                    break;
                case "Layout_SetFormReport":
                    string NewReportID = "";
                    Layout_SetFormReport(context, context.Request.QueryString["ReportID"].ToString(), context.Request.QueryString["ReportName"].ToString(), context.Request["ReportQuery"].ToString(), context.Request.QueryString["Report_SP_Params"].ToString(),
                        context.Request.QueryString["ReportCaption"].ToString(), context.Request.QueryString["ReportDataSourceID"].ToString(), context.Request.QueryString["ReportTypeID"].ToString(), context.Request.QueryString["IsActive"].ToString(),
                        SessionUserID, out NewReportID, context.Request.QueryString["FragmentName"].ToString(), context.Request.QueryString["FragmentDescription"].ToString(), context.Request.QueryString["FragmentTypeID"].ToString(),
                         context.Request.QueryString["FragmentHasCloseButton"].ToString(), context.Request.QueryString["HeaderZoomObjTypeID"].ToString(), context.Request.QueryString["HeaderZoomObjID"].ToString(), context.Request.QueryString["RowReportZoomObjTypeID"].ToString(),
                          context.Request.QueryString["RowReportZoomObjID"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString(), context.Request.QueryString["IzZebra"].ToString()
                          , context.Request.QueryString["IsLastRowFooter"].ToString(), context.Request.QueryString["HasSubTotals"].ToString(), context.Request.QueryString["IsToShowRowsNumberOnTitle"].ToString(), context.Request.QueryString["RowsPerPage"].ToString()
                          , context.Request.QueryString["GroupBy"].ToString(), context.Request.QueryString["HasSubTotalsOnGroup"].ToString(), context.Request.QueryString["ShowActionBattonOnTitle"].ToString(), context.Request.QueryString["ActionBattonOnTitleText"].ToString()
                          , context.Request.QueryString["ActionBattonOnTitleReportZoomObjTypeID"].ToString(), context.Request.QueryString["ActionBattonOnTitleReportZoomObjID"].ToString(), context.Request.QueryString["SectionsPerRow"].ToString()
                          , context.Request.QueryString["SectionsRowHeight"].ToString(), context.Request.QueryString["IsToShowSectionFrame"].ToString(), context.Request.QueryString["SectionImageHeightWeight"].ToString(), context.Request.QueryString["IsWebInternal"].ToString()
                          , context.Request.QueryString["tableToEdit"].ToString(), context.Request.QueryString["AllowAdd"].ToString(), context.Request.QueryString["AllowEdit"].ToString(), context.Request.QueryString["AllowDelete"].ToString()
                          , context.Request.QueryString["ChosenTemplet"].ToString(), context.Request.QueryString["FragmentID"].ToString(), context.Request.QueryString["Extra1"].ToString(), context.Request.QueryString["Extra2"].ToString(),
                          context.Request.QueryString["Extra3"].ToString(), context.Request.QueryString["Extra4"].ToString(), context.Request.QueryString["Extra5"].ToString());
                    break;
                case "Layout_GetReportCols":
                    Layout_GetReportCols(context, context.Request.QueryString["ReportID"].ToString());
                    break;
                case "Layout_SetReportCol":
                    Layout_SetReportCol(context, context.Request.QueryString["ColID"].ToString(), context.Request.QueryString["ReportID"].ToString(), context.Request.QueryString["ColName"].ToString(),
                        context.Request.QueryString["ColCaption"].ToString(),
                        context.Request.QueryString["ColOrder"].ToString(), context.Request.QueryString["ColWidthWeight"].ToString(), context.Request.QueryString["ColType"].ToString()
                        , context.Request.QueryString["FormatString"].ToString(), context.Request.QueryString["Alignment"].ToString(), context.Request.QueryString["ColMaxLength"].ToString(),
                        context.Request.QueryString["ddlStyleName"].ToString(), context.Request.QueryString["FilterID"].ToString(), context.Request.QueryString["ColIsSummary"].ToString(), "1", SessionUserID,
                        context.Request.QueryString["langID"] ==null ?null:context.Request.QueryString["langID"].ToString(), context.Request.QueryString["colCaptionTrans"] == null?null:context.Request.QueryString["colCaptionTrans"].ToString());
                    break;
                case "Layout_SetFragmentsToTabsByJson":
                    Layout_SetFragmentsToTabsByJson(context, context.Request.QueryString["FormID"].ToString(), SessionUserID);
                    break;
                case "LayoutManager_CreateXML":
                    LayoutManager_CreateXML(context, context.Request.QueryString["TabID"].ToString(), SessionUserID);
                    break;
                case "LayoutXML_SaveHTMLToTab":
                    LayoutXML_SaveHTMLToTab(context, context.Request.QueryString["TabID"].ToString(), SessionUserID);
                    break;
                case "Layout_GetReportData":
                    Layout_GetReportData(context, context.Request.QueryString["ReportID"].ToString());
                    break;
                case "Layout_SetMenusForWeb":
                    Layout_SetMenusForWeb(context, context.Request.QueryString["MenuID"].ToString(), context.Request.QueryString["MenuName"].ToString(), context.Request.QueryString["MenuDescription"].ToString(),
                        context.Request.QueryString["isActive"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString(), context.Request.QueryString["ViewType"].ToString());
                    break;
                case "Layout_GetMenuDataForWeb":
                    Layout_GetMenuDataForWeb(context, context.Request.QueryString["MenuID"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString());
                    break;
                case "Layout_GetMenuItemsForGridWeb":
                    Layout_GetMenuItemsForGridWeb(context, context.Request.QueryString["MenuID"].ToString());
                    break;
                case "Layout_SetMenuItem":
                    Layout_SetMenuItem(context, context.Request.QueryString["MenuItemID"].ToString(), context.Request.QueryString["MenuID"].ToString(), context.Request.QueryString["Description"].ToString(), context.Request.QueryString["ZoomObjTypeID"].ToString(),
                        context.Request.QueryString["ZoomObjectID"].ToString(), context.Request.QueryString["ImgID"].ToString(), context.Request.QueryString["SortOrder"].ToString(), context.Request.QueryString["IsActive"].ToString());
                    break;
                case "Layout_GetMenuItemData":
                    Layout_GetMenuItemData(context, context.Request.QueryString["MenuItemID"].ToString());
                    break;
                case "Layout_GetImagesForGrid":
                    Layout_GetImagesForGrid(context, context.Request.QueryString["LayoutTypeID"].ToString());
                    break;
                case "Layout_SetImage":
                    Layout_SetImage(context, context.Request.QueryString["ImgID"].ToString(), context.Request.QueryString["ImgName"].ToString(), (byte[])context.Session["imgFromImages"], context.Request.QueryString["ImgExtension"].ToString(), context.Request.QueryString["ImgHeight"].ToString(), context.Request.QueryString["ImgWidth"].ToString(), context.Request.QueryString["IsActive"].ToString(), context.Request.QueryString["LayoutTypeID"].ToString());
                    break;
                case "Layout_GetImageData":
                    Layout_GetImageData(context, context.Request.QueryString["ImgID"].ToString());
                    break;
                case "SetProjectName":
                    SetProjectName(context.Request.QueryString["ProjectName"].ToString());
                    break;
                case "GetNumeratorsForAgent":
                    GetNumeratorsForAgent(context, context.Request.QueryString["AgentID"].ToString());
                    break;
                case "SetNumeratorToAllByAgent":
                    SetNumeratorToAllByAgent(context, context.Request.QueryString["AgentID"].ToString(), context.Request.QueryString["NumeratorValue"].ToString());
                    break;
                case "Prn_GetQuery":
                    Prn_GetQuery(context, context.Request.QueryString["idQuery"].ToString());
                    break;
                case "Prn_GetPartData":
                    Prn_GetPartData(context, context.Request.QueryString["idPart"].ToString());
                    break;
                case "Prn_SetQueryData":
                    Prn_SetQueryData(context, context.Request.QueryString["idQuery"].ToString(), context.Request.QueryString["QueryName"].ToString(), context.Request["Query"].ToString(), SessionUserID, context.Request.QueryString["isToDelete"].ToString());
                    break;
                case "Prn_SetPartData":
                    Prn_SetPartData(context, context.Request.QueryString["idPart"].ToString(), context.Request.QueryString["PartName"].ToString(), context.Request.QueryString["idPartType"].ToString(), context.Request.QueryString["idQuery"].ToString(),
                        SessionUserID, context.Request.QueryString["isToDelete"].ToString(), context.Request.QueryString["TopicID"].ToString(), context.Request.QueryString["hasHeaderSeparator"].ToString(), context.Request.QueryString["hasFooterSeparator"].ToString(), "0");
                    break;
                case "Prn_GetPartCols":
                    Prn_GetPartCols(context, context.Request.QueryString["idPart"].ToString());
                    break;
                case "Prn_GetPartColData":
                    Prn_GetPartColData(context, context.Request.QueryString["PartColID"].ToString());
                    break;
                case "Prn_SetColData":
                    Prn_SetColData(context, context.Request.QueryString["PartColID"].ToString(), context.Request.QueryString["idPart"].ToString(), context.Request.QueryString["ColName"].ToString(), context.Request.QueryString["ColCaption"].ToString(), context.Request.QueryString["ColOrder"].ToString(), context.Request.QueryString["ColWidth"].ToString()
                        , context.Request.QueryString["ColTypeID"].ToString(), context.Request.QueryString["FormatID"].ToString(), context.Request.QueryString["AlignmentID"].ToString(), context.Request.QueryString["ColMaxLength"].ToString(), context.Request.QueryString["StyleID"].ToString()
                        , context.Request.QueryString["ColIsSummary"].ToString(), SessionUserID, context.Request.QueryString["isToDelete"].ToString(), context.Request.QueryString["NewRow"].ToString());
                    break;
                case "GetRowSectionToPrn":
                    GetRowSectionToPrn(context, context.Request.QueryString["ID"].ToString());
                    break;
                case "Prn_SetReport":
                    Prn_SetReport(context, context.Request.QueryString["id"].ToString(), context.Request.QueryString["reportName"].ToString(), context.Request.QueryString["reportDesc"].ToString(), context.Request.QueryString["rowLen"].ToString(), context.Request.QueryString["IsToDelete"].ToString(), SessionUserID);
                    break;
                case "Prn_GetReportData":
                    Prn_GetReportData(context, context.Request.QueryString["id"].ToString());
                    break;
                case "Prn_SetPartsToReport":
                    Prn_SetPartsToReport(context, context.Request["strJson"].ToString(), context.Request["strHTM"].ToString(), SessionUserID);
                    break;
                case "prn_GetReportAllData":
                    prn_GetReportAllData(context, context.Request["ReportID"].ToString());
                    break;
                case "prn_GetReportRowLen":
                    prn_GetReportRowLen(context, context.Request["ReportID"].ToString());
                    break;
                case "Prn_SetDuplicateReport":
                    Prn_SetDuplicateReport(context, context.Request["DuplicateFromReportCode"].ToString(), context.Request["DuplicateToReportName"].ToString(), SessionUserID);
                    break;
                case "Prn_SetDuplicatePart":
                    Prn_SetDuplicatePart(context, context.Request["DuplicateFromPartID"].ToString(), context.Request["DuplicateToPartName"].ToString(), SessionUserID);
                    break;
                case "Layout_GetProfileComponents":
                    Layout_GetProfileComponents(context, context.Request["LayoutTypeID"].ToString());
                    break;
                case "Layout_SetProfileData":
                    Layout_SetProfileData(context, context.Request["ProfileComponentsID"].ToString(), context.Request["ProfileTypeID"].ToString(), context.Request["ProfileName"].ToString(),
                        context.Request["FormLayoutID"].ToString(), context.Request["MenuID"].ToString(), context.Request["IsToDelete"].ToString(), SessionUserID, context.Request["LayoutTypeID"].ToString()
                        , context.Request["OrderMenuID"].ToString(), context.Request["ReceiptMenuID"].ToString(), context.Request["ProfileID"].ToString());
                    break;
                case "VerLayout_GetAllChanges":
                    VerLayout_GetAllChanges(context, context.Request["LayoutTypeID"].ToString());
                    break;
                case "VerLayout_SetNewVersion":
                    VerLayout_SetNewVersion(context, context.Request["VersionID"].ToString(), context.Request["VersionName"].ToString(), context.Request["VersionDescription"].ToString(), context.Request["LayoutTypeID"].ToString(), SessionUserID);
                    break;
                case "VerLayout_SuggestNewVersionID":
                    VerLayout_SuggestNewVersionID(context);
                    break;
                case "VerLayout_GetAllVersions":
                    VerLayout_GetAllVersions(context, context.Request["LayoutTypeID"].ToString());
                    break;
                case "VerLayout_CheckForNewVersion":
                    VerLayout_CheckForNewVersion(context);
                    break;
                case "VerLayout_SetReplaceWorkingLayout":
                    VerLayout_SetReplaceWorkingLayout(context, context.Request["ToVersionID"].ToString(), SessionUserID);
                    break;
                case "AddColdsByQuery":
                    AddColdsByQuery(context, context.Request["LayoutTypeID"].ToString(), context.Request["ReportID"].ToString(), SessionUserID, context.Request["colCaptionTrans"].ToString());

                    break;
                case "Layout_GetUsersProfileComponents":
                    Layout_GetUsersProfileComponents(context, context.Request["LayoutTypeID"].ToString());
                    break;
                case "Layout_SetUserData":
                    Layout_SetUserData(context, context.Request["Name"].ToString(), context.Request["Description"].ToString(), context.Request["UserID"].ToString(), context.Request["Password"].ToString(),
                        context.Request["Profileid"].ToString(), context.Request["Defult"].ToString(), context.Request["IsToDelete"].ToString(), context.Request["MPUserID"].ToString(), SessionUserID, context.Request["LayoutTypeID"].ToString(),
                        context.Request["UserProfileID"].ToString(), context.Request["MobileProfileid"].ToString());
                    break;
                case "Test_GetItems":
                    Test_GetItems(context);
                    break;
                case "Prn_GetReportParams":
                    Prn_GetReportParams(context, context.Request["reportCode"].ToString());
                    break;
                case "Prn_Set_ReportParameter":
                    Prn_Set_ReportParameter(context, context.Request["ReportParameterID"].ToString(), context.Request["reportCode"].ToString(), context.Request["ParameterName"].ToString(), context.Request["ParameterDescription"].ToString(),
                        context.Request["ParameterDefaultValue"].ToString(), context.Request["ParameterOrder"].ToString(), context.Request["ParamterTypeID"].ToString(), context.Request["ParamQuery"].ToString(),
                        SessionUserID, context.Request["IsToDelete"].ToString());
                    break;
                case "Frg_SetSectionData":
                    Frg_SetSectionData(context, context.Request["SectionID"].ToString(), context.Request["SectionName"].ToString(), context.Request["SectionDescription"].ToString(), context.Request["SectionValue"].ToString(),
                        context.Request["LayoutTypeID"].ToString(), context.Request["SectionTypeID"].ToString(), context.Request["SectionAlignID"].ToString(), context.Request["SectionMaxLength"].ToString(), context.Request["StyleID"].ToString(),
                        context.Request["FormatID"].ToString(), SessionUserID, context.Request["IsToDelete"].ToString());
                    break;
                case "Frg_GetSectionData":
                    Frg_GetSectionData(context, context.Request["SectionID"].ToString());
                    break;
                case "Frg_SetFragmentData":
                    string FragmentHTML = context.Server.UrlDecode(context.Request.Form.ToString().Replace("htm: ", "")).Replace("+", "%2b").Split('~')[0].Replace("+", "%2b");
                    string FragmentJson = context.Server.UrlDecode(context.Request.Form.ToString().Replace("htm: ", "")).Replace("+", "%2b").Split('~')[1].Replace("+", "%2b");
                    Frg_SetFragmentData(context, context.Request["FragmentID"].ToString(), context.Request["FragmentName"].ToString(), context.Request["FragmentDescription"].ToString(), FragmentHTML, FragmentJson, context.Request["LayoutTypeID"].ToString(),
                        context.Request["FragmentWidth"].ToString(), context.Request["FragmentHeight"].ToString(), SessionUserID, context.Request["IsToDelete"].ToString(), context.Request["FragmentBackColor"].ToString(),
                        context.Request["OrderReportID"].ToString(), context.Request["FragmentProfiles"].ToString(),
                        context.Request["IsShadow"].ToString(), context.Request["IsRounded"].ToString());
                    break;
                case "Frg_GetFragmentData":
                    Frg_GetFragmentData(context, context.Request["FragmentID"].ToString());
                    break;
                case "Frg_SetSettingsData":
                    Frg_SetSettingsData(context, context.Request["SettingID"].ToString(), context.Request["LayoutTypeID"].ToString(),
                        context.Request["ItemFragment"].ToString(), context.Request["CategoryReportID"].ToString(), context.Request["ItemReportID"].ToString(),
                        context.Request["FragmentMarginsPX"].ToString(), context.Request["DefaultCategory"].ToString(), SessionUserID,
                        context.Request["CategoryLevels"].ToString(), context.Request["CategoryFragment1"].ToString(), context.Request["CategoryFragment2"].ToString(),
                        context.Request["CategoryFragment3"].ToString(), context.Request["CategoryFragment4"].ToString(),
                        context.Request["EditWinFormID"].ToString(), context.Request["EditWinFieldID"].ToString(), context.Request["EditWinFieldPriceID"].ToString(), context.Request["EditWinFieldName"].ToString(),
                        context.Request["EditWinFieldProdHierarchy1"].ToString(), context.Request["EditWinFieldProdHierarchy2"].ToString(), context.Request["EditWinFieldProdHierarchy3"].ToString(),
                        context.Request["EditWinFieldProdHierarchy4"].ToString(), context.Request["UserProfileID"].ToString());
                    break;
                case "Frg_GetSettingsData":
                    Frg_GetSettingsData(context, context.Request["LayoutTypeID"].ToString());
                    break;
                case "DuplicateReport":
                    DuplicateReport(context, context.Request["ReportID"].ToString(), context.Request["DuplicateToReportName"].ToString(), context.Request["DB"].ToString());
                    break;
                case "DuplicateForm":
                    DuplicateForm(context, context.Request["FormID"].ToString(), context.Request["DuplicateToFormName"].ToString(), context.Request["DB"].ToString());
                    break;
            }
        }
        catch (Exception ex)
        {
            MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString(), SessionUserID, SessionUserPromt);
            context.Response.Write(ex.Message);
        }
    }

    private void ResponseJSON(HttpContext Context, string strjson)
    {
        /*Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
        Context.Response.AddHeader("content-length", strjson.Length.ToString());
        Context.Response.Flush();*/
        Context.Response.Write(strjson);
    }

    public void GetJsonExm()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        wr.RetJSON();
    }

    public void SetJsonExm(HttpContext context)
    {
        string strResponse = "";

        context.Response.Write(strResponse);
    }
    private void AddEdit(int id, string name, string Description, DateTime dtCreate, int UserID, out string strResponse)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        strResponse = "Employee record successfully updated";

        wr.AddEditUser(id, name, Description, dtCreate, UserID, ConStrings.DicAllConStrings[SessionProjectName]);
    }
    public void GetUsers(HttpContext context)
    {
        //MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        //wr.GetUsers();
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetUsers?ConString="
            + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void SetUserWidgetPosition(string UserID, string WidgetsUserID, string Width, string Height, string TabID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        wr.SetUserWidgetPosition(UserID, WidgetsUserID, Width, Height, arrTabs[Convert.ToInt32(TabID)], ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void SetUserWidgetsOrder(string UserID, string jsonObj, string TabID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        wr.SetUserWidgetOrder(UserID, jsonObj, arrTabs[Convert.ToInt32(TabID)], ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void SetUserWidgetCol(string UserID, string WidgetsUserID, string ColNum, string TabID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        wr.SetUserWidgetCol(UserID, WidgetsUserID, ColNum, arrTabs[Convert.ToInt32(TabID)], ConStrings.DicAllConStrings[SessionProjectName]);
    }

    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    private void UserLogin(HttpContext Context, string UserName, string Password, string userIP = null)
    {
        WebClient client = new WebClient();

        //string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/UserLogin?UserName=" + UserName + "&Password=" + Password +
        //    "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        string str = new UserService().MPUserLogin(UserName, Password, userIP, ConStrings.DicAllConStrings[SessionProjectName]);///client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPUserLogin?UserName=" + UserName + "&Password=" + Password + "&userIP=" + userIP + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        var objects = Newtonsoft.Json.Linq.JArray.Parse(HttpContext.Current.Server.UrlDecode(str));
        foreach (Newtonsoft.Json.Linq.JObject root in objects)
        {
            foreach (System.Collections.Generic.KeyValuePair<String, Newtonsoft.Json.Linq.JToken> app in root)
            {
                if (app.Key == "id")
                {
                    SessionUserID = ((Int32)app.Value).ToString();
                }
                if (app.Key == "Name")
                {
                    SessionUserPromt = ((string)app.Value).ToString();
                }
                if (app.Key == "GroupID")
                {
                    SessionGroupID = ((int)app.Value).ToString();
                }
            }
        }

        ResponseJSON(Context, HttpContext.Current.Server.UrlDecode(str));
    }
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    private void AddTab(HttpContext Context, string TabName)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/AddUserTab?UserID=" + SessionUserID + "&TabName=" + TabName
            + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void GetAllWidgetsByPermissions(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetAllWidgetsByPermissions?UserID=" + SessionUserID
            + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void AddWidgetToUser(HttpContext context, string WidgetID, string TabID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/AddWidgetToUserTab?UserID=" + SessionUserID + "&WidgetID=" + WidgetID + "&TabID=" + arrTabs[Convert.ToInt32(TabID)] +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void DeleteWidget(HttpContext context, string WidgetsUserID, string TabID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/DeleteUserWidget?UserID=" + SessionUserID + "&WidgetsUserID=" + WidgetsUserID + "&TabID=" + arrTabs[Convert.ToInt32(TabID)] +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void DeleteTag(HttpContext context, string TabID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/DeleteTag?UserID=" + SessionUserID + "&TabID=" + arrTabs[Convert.ToInt32(TabID)] +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public string StrSrc(string url, string key, string Language)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        return wr.StrSrc(key, url, Language);
    }
    public void GridData(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GridData?GridName=" + context.Request.QueryString["GridName"].ToString() +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void GridDataNew(HttpContext context)
    {
        WebClient client = new WebClient();
        string id = "";
        if (context.Request.QueryString["id"] != null)
            id = "&id=" + context.Request.QueryString["id"].ToString();

        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GridDataNew?GridName=" + context.Request.QueryString["GridName"].ToString() + "&GridParameters=" + context.Request.QueryString["GridParameters"].ToString() + id +
        "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void GridServerVersions(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetServerVersionForUI" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GridServerLayoutVersions(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetServerLayoutVersionForUI" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetServerGroups(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetServerGroups" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void AddEditGridServerVersions(HttpContext context)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        string Msg = "";
        string id = "0";
        string Command = "Delete";
        id = context.Request["verid"].ToString();
        if ((context.Request["Command"].ToString() != "Delete") && context.Request["AgentID"] != null && id != "undefined")
        {
            Command = "Edit";
        }
        else if (id == "undefined")
        {
            Command = "Add";
        }
        else
        {
            Command = "Delete";
        }

        if (id == "undefined")
            id = "0";

        if (Command != "Delete")
        {
            string AgentID = "";
            if (context.Request["AgentID"] != null)
                AgentID = context.Request["AgentID"].ToString();

            if (AgentID == "null")
                AgentID = "0";

            string ServerGroupName = "0";
            if (context.Request["ServerGroupName"] != null)
                ServerGroupName = context.Request["ServerGroupName"].ToString().Replace("null", "0");

            string FromVersion = "";
            if (context.Request["FromVersion"] != null)
                FromVersion = context.Request["FromVersion"].ToString();

            string ToVersion = "";
            if (context.Request["ToVersion"] != null)
                ToVersion = context.Request["ToVersion"].ToString();

            string ProjectType = "";
            if (context.Request["ProjectType"] != null)
                ProjectType = context.Request["ProjectType"].ToString();

            if (wr.AddEditServerVersion(id,
                                    AgentID,
                                    ServerGroupName,
                                    FromVersion,
                                    ToVersion,
                                    SessionUserID,
                                    Command,
                                    ProjectType,
                                    ConStrings.DicAllConStrings[SessionProjectName],
                                    out Msg)
            )
                context.Response.Write("");
            else
                context.Response.Write(Msg);
        }
        else
        {
            if (wr.AddEditServerVersion(context.Request["verid"].ToString(),
                                       "0",
                                       "0",
                                       "0",
                                       "0",
                                       SessionUserID,
                                       Command,
                                       "1",
                                       ConStrings.DicAllConStrings[SessionProjectName],
                                       out Msg)
               )
                context.Response.Write("Server version deleted successfully updated");
            else
                context.Response.Write(Msg);
        }

    }
    public void AddEditServerLayoutVersion(HttpContext context)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        string Msg = "";
        string id = "0";
        string Command = "Delete";
        id = context.Request["verid"].ToString();
        if ((context.Request["Command"].ToString() != "Delete") && context.Request["AgentID"] != null && id != "undefined")
        {
            Command = "Edit";
        }
        else if (id == "undefined")
        {
            Command = "Add";
        }
        else
        {
            Command = "Delete";
        }

        if (id == "undefined")
            id = "0";

        if (Command != "Delete")
        {
            string AgentID = "";
            if (context.Request["AgentID"] != null)
                AgentID = context.Request["AgentID"].ToString();

            if (AgentID == "null")
                AgentID = "0";

            string ServerGroupName = "0";
            if (context.Request["ServerGroupName"] != null)
                ServerGroupName = context.Request["ServerGroupName"].ToString().Replace("null", "0");

            string FromVersion = "";
            if (context.Request["FromVersion"] != null)
                FromVersion = context.Request["FromVersion"].ToString();

            string ToVersion = "";
            if (context.Request["ToVersion"] != null)
                ToVersion = context.Request["ToVersion"].ToString();

            string ProjectType = "";
            if (context.Request["ProjectType"] != null)
                ProjectType = context.Request["ProjectType"].ToString();

            if (wr.AddEditServerLayoutVersion(id,
                                    AgentID,
                                    ServerGroupName,
                                    FromVersion,
                                    ToVersion,
                                    SessionUserID,
                                    Command,
                                    ProjectType,
                                    ConStrings.DicAllConStrings[SessionProjectName],
                                    out Msg)
            )
                context.Response.Write("");
            else
                context.Response.Write(Msg);
        }
        else
        {
            if (wr.AddEditServerLayoutVersion(context.Request["verid"].ToString(),
                                       "0",
                                       "0",
                                       "0",
                                       "0",
                                       SessionUserID,
                                       Command,
                                       "1",
                                       ConStrings.DicAllConStrings[SessionProjectName],
                                       out Msg)
               )
                context.Response.Write("Server version deleted successfully updated");
            else
                context.Response.Write(Msg);
        }

    }
    private void AddEditGrid(HttpContext context, out string strResponse)
    {
        string id = context.Request["id"].ToString();

        string gridname = "";
        string gridquery = "";
        string querytype = "";
        string gridparameters = "";
        string gridcaption = "";
        string childfiltercol = "";
        string masterdetailsgridid = "";
        string rows = "";
        string jumpgridid = "";
        string UserID = SessionUserID;

        if (context.Request["gridname"] != null)
        {
            gridname = context.Request["gridname"].ToString();
            gridquery = context.Request["gridquery"].ToString();
            gridquery = gridquery.Replace("\n", " ");
            querytype = context.Request["QueryType"].ToString();
            if (querytype.IndexOf(",") > -1)
                querytype = querytype.Split(',')[0];
            gridparameters = context.Request["gridparameters"].ToString();
            gridcaption = context.Request["gridcaption"].ToString();
            childfiltercol = context.Request["childfiltercol"].ToString();
            masterdetailsgridid = context.Request["masterdetailsgridid"].ToString().Replace("null", "");
            jumpgridid = context.Request["jumpgridid"].ToString().Replace("null", "");
            rows = context.Request["rows"].ToString();
            UserID = SessionUserID;

        }
        else
        {
            gridname = "Delete";
        }

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        if (wr.IsGridNameExsits(gridname) && id == "_empty")
        {
            strResponse = "גריד בשם זהה כבר קיים, אנא בחר שם אחר.";
            return;
        }


        if (wr.AddEditGrid(id, gridname, gridquery, querytype, gridparameters, gridcaption, childfiltercol, masterdetailsgridid, rows, UserID, jumpgridid, ConStrings.DicAllConStrings[SessionProjectName]))
            strResponse = "הגריד נערך בהצלחה";
        else
            strResponse = "שגיאה בעדכון";
    }
    private void AddEditGridCols(HttpContext context, out string strResponse)
    {
        string id = context.Request["id"].ToString();

        string gridid = "";
        string colname = "";
        string colnamegrid = "";
        string colpromt = "";
        string colorder = "";
        string colwidth = "";
        string coltype = "";
        string colalignment = "";
        string colopenwindowbygridid = "";
        string UserID = SessionUserID;

        if (context.Request["colname"] != null)
        {
            gridid = context.Request["gridid"].ToString();
            colname = context.Request["colname"].ToString();
            //colnamegrid = context.Request["colnamegrid"].ToString();
            colpromt = context.Request["colpromt"].ToString();
            colorder = context.Request["colorder"].ToString();
            colwidth = context.Request["colwidth"].ToString();
            coltype = context.Request["coltype"].ToString();
            colalignment = context.Request["colalignment"].ToString();
            colopenwindowbygridid = context.Request["colopenwindowbygridid"].ToString();
            UserID = SessionUserID;
        }
        else
        {
            colname = "Delete";
        }
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        if (wr.AddEditGridCols(id, gridid, colname, colpromt, colorder, colwidth, coltype, colalignment, colopenwindowbygridid, UserID, ConStrings.DicAllConStrings[SessionProjectName]))
            strResponse = "הגריד נערך בהצלחה";
        else
            strResponse = "שגיאה בעדכון";
    }
    public void QueryTypes(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/QueryTypes");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetGrids(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetGrids" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetAlignment(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetAlignment");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetTypes(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetTypes");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void RetJSONBar(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/RetJSONBar");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void RetJSONPie(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/RetJSONPie");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void RetJSONLine(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/RetJSONLine");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void GetAgentSalesGraph(HttpContext context, string iDate, string AgentID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetAgentSalesGraph?iDate=" + iDate + "&AgentID=" + AgentID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GroupNames(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GroupNames" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void AddEditGridWidgets(HttpContext context, out string strResponse)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        string id = context.Request["id"].ToString();
        string WidgetID = "";
        string WidgetName = "";
        string Path = "";
        string GroupID = "";
        string UserID = "";

        if (context.Request["name"] != null)
        {
            if (id == "_empty")
                WidgetID = "0";
            else
                WidgetID = context.Request["widgetid"].ToString();
            WidgetName = context.Request["name"].ToString();
            Path = context.Request["path"].ToString();
            GroupID = context.Request["GroupName"].ToString();
            UserID = SessionUserID;
        }
        else
        {
            WidgetName = "Delete";
            WidgetID = context.Request["widgetID"].ToString();
        }


        if (wr.AddEditGridWidgets(id, WidgetID, WidgetName, Path, GroupID, UserID, ConStrings.DicAllConStrings[SessionProjectName]))
            strResponse = "הגריד נערך בהצלחה";
        else
            strResponse = "שגיאה בעדכון";

    }
    private void GetYaforaYazranPieRep(HttpContext context, string iDate, string AgentID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetYaforaYazranPieRep?Date=" + iDate + "&AgentID=" + AgentID);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetProjectTypes(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetProjectTypes");
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void CheckRecursive(HttpContext context)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        System.Data.DataTable dt = wr.GetServerVersionForUIDT(ConStrings.DicAllConStrings[SessionProjectName]);
        string val1 = context.Request.QueryString["val1"].ToString();
        string val2 = context.Request.QueryString["val2"].ToString();
        string ProjectType = context.Request.QueryString["ProjectType"].ToString();
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["ToVersion"].ToString() == val1 && dt.Rows[i]["FromVersion"].ToString() == val2 && ProjectType == dt.Rows[i]["ProjectTypeName"].ToString())
                {
                    context.Response.Write("false");
                    return;
                }

            }
            context.Response.Write("true");
        }
    }
    public void CheckRecursiveLayout(HttpContext context)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        System.Data.DataTable dt = wr.GetServerVersionForUIDT(ConStrings.DicAllConStrings[SessionProjectName]);
        string val1 = context.Request.QueryString["val1"].ToString();
        string val2 = context.Request.QueryString["val2"].ToString();
        string ProjectType = context.Request.QueryString["ProjectType"].ToString();
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["ToVersion"].ToString() == val1 && dt.Rows[i]["FromVersion"].ToString() == val2 && ProjectType == dt.Rows[i]["ProjectTypeName"].ToString())
                {
                    context.Response.Write("false");
                    return;
                }

            }
            context.Response.Write("true");
        }
    }
    public void GetPieRep(HttpContext context, string Date, string AgentID, string GraphID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetPieRep?Date=" + Date + "&AgentID=" + AgentID + "&GraphID=" + GraphID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetBarData(HttpContext context, string iDate, string AgentID, string GraphID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetBarData?iDate=" + iDate + "&AgentID=" + AgentID + "&GraphID=" + GraphID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetRGBarData(HttpContext context, string iDate, string AgentID, string GraphID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetRGBarData?iDate=" + iDate + "&AgentID=" + AgentID + "&GraphID=" + GraphID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetLineData(HttpContext context, string iDate, string AgentID, string GraphID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetLineData?iDate=" + iDate + "&AgentID=" + AgentID + "&GraphID=" + GraphID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    public void GetGraphsForGrid(HttpContext context)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetGraphsForGrid" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str).Replace("'", "\""));
    }
    private void AddEditGraph(HttpContext context, out string strResponse)
    {
        string GraphID = context.Request["GraphID"].ToString();
        if (GraphID == "undefined")
            GraphID = "0";

        string Name = "";
        string Promt = "";
        string Query = "";
        string QueryType = "";
        string Params = "";
        string GraphType = "";
        string UserID = SessionUserID;

        if (context.Request["Name"] != null)
        {
            Name = context.Request["Name"].ToString();
            Promt = context.Request["Promt"].ToString();
            Query = context.Request["Query"].ToString().Replace("\n", " ").Replace("\t", " ");
            QueryType = context.Request["QueryType"].ToString();
            if (QueryType.IndexOf(",") > -1)
                QueryType = QueryType.Split(',')[0];
            Params = context.Request["Params"].ToString();
            GraphType = context.Request["GraphType"].ToString();
            UserID = SessionUserID;

        }
        else
        {
            Name = "Delete";
        }

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        if (wr.IsGraphNameExsits(Name, ConStrings.DicAllConStrings[SessionProjectName]) && GraphID == "_empty")
        {
            strResponse = "גריד בשם זהה כבר קיים, אנא בחר שם אחר.";
            return;
        }

        if (wr.AddEditGraph(GraphID, Name, Query, QueryType, Params, Promt, GraphType, UserID, ConStrings.DicAllConStrings[SessionProjectName]))
            strResponse = "הגרף נערך בהצלחה";
        else
            strResponse = "שגיאה בעדכון";
    }
    public void GetGridJump(HttpContext context, string GridName, string id)
    {
        if (id == "undefined")
            id = "0";
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetGridJump?GridName=" + GridName + "&id=" + id +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str).Replace("'", "\""));
    }
    public void GetNumerators(HttpContext context)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetNumerators" +
            "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str).Replace("'", "\"").Replace("\"/", "\""));
    }
    public void SetNumerator(string AgentID, string NumeratorGroup, string NumeratorValue)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        wr.SetNumerator(AgentID, NumeratorGroup, NumeratorValue, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
    }
    private void SetAllNumerators(string Value)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        wr.SetAllNumerators(Value, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
    }
    public void GetRGHBarData(HttpContext context, string GridParameters, string GraphID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetRGHBarData?GridParameters=" + GridParameters + "&GraphID=" + GraphID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void SetCustomersForAgent(HttpContext context, string FromAgentID, string ToAgentID, string StrCustmers, string FromDate, string ToDate, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "res: " + wr.SetCustomersForAgent(FromAgentID, ToAgentID, StrCustmers, FromDate, ToDate, UserID, "0",
            ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void GetCustomersForAgent(HttpContext context, string FromAgentID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetCustomersForAgent?AgentID=" + FromAgentID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void GetAllCustomersForDates(HttpContext context)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetAllCustomersForDates?" +
            "ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void GetSalesMeterChart(HttpContext context, string Date, string AgentID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetSalesMeterChart?Date=" + Date + "&AgentID=" + AgentID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str));
    }
    private void DeleteCustomersForAgent(HttpContext context, string StrCustmers, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "res: " + wr.DeleteCustomersForAgent(StrCustmers, UserID,
            ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void DeleteTranCustomersForAgent(HttpContext context, string FromAgentID, string StrCustmers)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "res: " + wr.DeleteTranCustomersForAgent(FromAgentID, StrCustmers,
            ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Layout_SetForm(HttpContext context, string FormID, string LayoutTypeID, string FormName, string FormDescription, string IsShowUpdateTime,
        string IsTabAlwaysOnTop, string IsActive, string TabAlignmentID, string UserID, string ProjectID, string IsScroll)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "res: " + wr.Layout_SetForm(FormID, LayoutTypeID, FormName, FormDescription, IsShowUpdateTime, IsTabAlwaysOnTop, IsActive, TabAlignmentID, UserID, ProjectID, IsScroll,
            ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Layout_GetFormData(HttpContext context, string FormID, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetFormData?FormID=" + FormID + "&LayoutTypeID=" + LayoutTypeID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_GetFormTabs(HttpContext context, string FormID, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetFormTabs?FormID=" + FormID + "&LayoutTypeID=" + LayoutTypeID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_SetFormReport(HttpContext context, string ReportID, string ReportName, string ReportQuery, string Report_SP_Params, string ReportCaption, string ReportDataSourceID,
            string ReportTypeID, string IsActive, string UserID, out string NewReportID,
            string FragmentName, string FragmentDescription, string FragmentTypeID, string FragmentHasCloseButton, string HeaderZoomObjTypeID, string HeaderZoomObjID,
            string RowReportZoomObjTypeID, string RowReportZoomObjID, string LayoutTypeID, string IsZebra, string IsLastRowFooter, string HasSubTotals, string IsToShowRowsNumberOnTitle, string RowsPerPage,
            string GroupBy, string HasSubTotalsOnGroup, string ShowActionBattonOnTitle, string ActionBattonOnTitleText, string ActionBattonOnTitleReportZoomObjTypeID, string ActionBattonOnTitleReportZoomObjID,
            string SectionsPerRow, string SectionsRowHeight, string IsToShowSectionFrame, string SectionImageHeightWeight, string IsWebInternal, string tableToEdit, string AllowAdd, string AllowEdit,
            string AllowDelete, string ChosenTemplet, string FragmentID, string Extra1, string Extra2, string Extra3, string Extra4, string Extra5)
    {
        NewReportID = "";
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        wr.Layout_SetFormReport(ReportID, ReportName, ReportQuery.Replace("\n", "  ").Replace("\t", "  ").Replace("***", "+"), Report_SP_Params, ReportCaption, ReportDataSourceID,
           ReportTypeID, IsActive, UserID, FragmentName, FragmentDescription, FragmentTypeID, FragmentHasCloseButton, HeaderZoomObjTypeID, HeaderZoomObjID,
            RowReportZoomObjTypeID, RowReportZoomObjID, ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID, IsZebra, IsLastRowFooter, HasSubTotals, IsToShowRowsNumberOnTitle, RowsPerPage, GroupBy, HasSubTotalsOnGroup
            , ShowActionBattonOnTitle, ActionBattonOnTitleText, ActionBattonOnTitleReportZoomObjTypeID, ActionBattonOnTitleReportZoomObjID, SectionsPerRow, SectionsRowHeight, IsToShowSectionFrame, SectionImageHeightWeight
            , IsWebInternal, tableToEdit, AllowAdd, AllowEdit, AllowDelete, ChosenTemplet, FragmentID, Extra1, Extra2, Extra3, Extra4, Extra5, out NewReportID);

        ResponseJSON(context, "NewReportID: " + NewReportID);
    }
    private void Layout_GetReportCols(HttpContext context, string ReportID)
    {
        WebClient client = new WebClient();
        string url = "http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetReportCols?ReportID=" + ReportID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName];
        string str = client.DownloadString(url);
        ResponseJSON(context, context.Server.UrlDecode(str).Replace("'", "\""));
    }
    private void Layout_SetReportCol(HttpContext context, string ColID, string ReportID, string ColName, string ColCaption, string ColOrder, string ColWidthWeight, string ColTypeID
           , string FormatID, string AlignmentID, string ColMaxLength, string StyleID, string Filter, string ColIsSummary, string IsActive = null, string UserID = null, string langID = null, string colCaptionTrans = null)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        ResponseJSON(context, "ret: " + wr.Layout_SetReportCol(ColID, ReportID, ColName, ColCaption, ColOrder, ColWidthWeight, ColTypeID
           , FormatID, AlignmentID, ColMaxLength, StyleID, Filter, ColIsSummary, IsActive, UserID, ConStrings.DicAllConStrings[SessionProjectName], langID, colCaptionTrans).ToString());
    }
    private void Layout_SetFragmentsToTabsByJson(HttpContext context, string FormID, string UserID)
    {
        string JsonObj = context.Server.UrlDecode(context.Request.Form.ToString());
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        ResponseJSON(context, "ret: " + wr.Layout_SetFragmentsToTabsByJson(FormID, JsonObj, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void LayoutManager_CreateXML(HttpContext context, string TabID, string UserID)
    {
        if (TabID != "undefined")
        {
            MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
            ResponseJSON(context, "ret: " + wr.LayoutManager_CreateXML(TabID, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
        }
        else
        {
            ResponseJSON(context, "ret: True");
        }
    }
    private void LayoutXML_SaveHTMLToTab(HttpContext context, string TabID, string UserID)
    {
        string LayoutHTML = context.Server.HtmlDecode(context.Request.Form.ToString().Replace("htm: ", "")).Replace("+", "%2b");
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "ret: " + wr.LayoutXML_SaveHTMLToTab(TabID, LayoutHTML, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Layout_GetReportData(HttpContext context, string ReportID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetReportData?ReportID=" + ReportID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_SetMenusForWeb(HttpContext context, string MenuID, string MenuName, string MenuDescription, string isActive, string LayoutTypeID, string ViewType)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_SetMenusForWeb?MenuID=" + MenuID + "&MenuName=" + MenuName + "&MenuDescription=" + MenuDescription + "&isActive=" + isActive + "&UserID=" + SessionUserID + "&LayoutTypeID=" + LayoutTypeID + "&ViewType=" + ViewType +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_GetMenuDataForWeb(HttpContext context, string MenuID, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetMenuDataForWeb?LayoutTypeID=" + LayoutTypeID + "&MenuID=" + MenuID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_GetMenuItemsForGridWeb(HttpContext context, string MenuID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetMenuItemsForGridWeb?MenuID=" + MenuID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_SetMenuItem(HttpContext context, string MenuItemID, string MenuID, string Description, string ZoomObjTypeID, string ZoomObjectID, string ImgID, string SortOrder, string IsActive)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "ret: " + wr.Layout_SetMenuItem(MenuItemID, MenuID, Description, ZoomObjTypeID, ZoomObjectID, ImgID, SortOrder, IsActive, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Layout_GetMenuItemData(HttpContext context, string MenuItemID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetMenuItemData?MenuItemID=" + MenuItemID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_GetImagesForGrid(HttpContext context, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetImagesForGrid" +
            "?LayoutTypeID=" + LayoutTypeID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_SetImage(HttpContext context, string ImgID, string ImgName, byte[] ImgBlob, string ImgExtension, string ImgHeight, string ImgWidth, string IsActive, string LayoutTypeID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "ret: " + wr.Layout_SetImage(ImgID, ImgName, ImgBlob, ImgExtension, ImgHeight, ImgWidth, IsActive, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID).ToString());
    }
    private void Layout_GetImageData(HttpContext context, string ImgID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetImageData?ImgID=" + ImgID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void SetProjectName(string Name)
    {
        SessionProjectName = Name;
    }
    private void GetNumeratorsForAgent(HttpContext context, string AgentID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/GetNumeratorsForAgent?AgentID=" + AgentID +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void SetNumeratorToAllByAgent(HttpContext context, string AgentID, string NumeratorValue)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "ret: " + wr.SetNumeratorToAllByAgent(AgentID, NumeratorValue, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Prn_GetQuery(HttpContext context, string idQuery)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_GetQuery?idQuery=" + idQuery +
             "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Prn_GetPartData(HttpContext context, string idPart)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_GetPartData?idPart=" + idPart +
             "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str).Replace("'", ""));
    }
    private void Prn_SetQueryData(HttpContext context, string idQuery, string QueryName, string Query, string UserID, string isToDelete)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Prn_SetQueryData(idQuery, QueryName, Query.Replace("\n", "  ").Replace("\t", "  ").Replace("***", "+"), UserID, isToDelete, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Prn_SetPartData(HttpContext context, string idPart, string PartName, string idPartType, string idQuery, string UserID, string isToDelete, string TopicID, string hasHeaderSeparator, string hasFooterSeparator, string SelectedImg)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Prn_SetPartData(idPart, PartName, idPartType, idQuery, UserID, isToDelete, TopicID, hasHeaderSeparator, hasFooterSeparator, SelectedImg, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Prn_GetPartCols(HttpContext context, string idPart)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_GetPartCols?idPart=" + idPart +
             "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }

    private void Prn_GetPartColData(HttpContext context, string PartColID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_GetPartColData?PartColID=" + PartColID +
             "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Prn_SetColData(HttpContext context, string PartColID, string idPart, string ColName, string ColCaption, string ColOrder, string ColWidth, string ColTypeID, string FormatID, string AlignmentID,
            string ColMaxLength, string StyleID, string ColIsSummary, string UserID, string isToDelete, string NewRow)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, "ret: " + wr.Prn_SetColData(PartColID, idPart, ColName, ColCaption, ColOrder, ColWidth, ColTypeID, FormatID, AlignmentID,
            ColMaxLength, StyleID, ColIsSummary, UserID, isToDelete, NewRow, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private static int counterf = 0;
    private void GetRowSectionToPrn(HttpContext context, string id)
    {
        MainService.MobiPlusWS WR = new MainService.MobiPlusWS();
        System.Data.DataTable dt = WR.Prn_GetPartAndColsData(id, ConStrings.DicAllConStrings[SessionProjectName]);
        string HTM = "";
        if (dt != null && dt.Rows.Count > 0)
        {

            string ConstantRow = "";
            double width = 0;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                width += Convert.ToDouble(dt.Rows[i]["ColWidth"].ToString());
                if (dt.Rows[i]["NewRowID"].ToString() == "3")
                    break;
            }
            if (width < 40)
                width = 80;

            HTM += "<div class=\"h3LeftContainer\">"
              + "<div class=\"h3Left\" id=\"div_" + id + "_" + counterf.ToString() + "\" style=\"text-align:right;direction:rtl;\"><table class=\"tblLeft3\" style=\"width:" + (width * 10 - 15) + "px;\"><tr><td  style=\"white-space:nowrap;\">" + dt.Rows[0]["PartName"].ToString() + "</td><td style=\"width:95%;\">&nbsp;</td><td><a href=\"javascript:CloseSection('div_" + id + "_" + counterf.ToString() + "');\"><img alt=\"סגור\" src=\"../../img/X.png\" id=\"tdclose_" + id + "\" class=\"imngX ggt\" onclick=\"CloseSection('div_" + id + "_" + counterf.ToString() + "');\" /></a></td></tr></table></div>"
              + "<div class=\"dDohContainerLeft\" style=\"overflow:hidden;font-family:Courier New;\">";
            counterf++;
            if (counterf > 1000000)
            {
                counterf = 0;
            }
            switch (dt.Rows[0]["idPartType"].ToString())
            {
                case "1"://Grid
                    width = 0;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        width += Convert.ToDouble(dt.Rows[i]["ColWidth"].ToString());
                    }
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ConstantRow += GetLineToAlignment(Convert.ToInt32(dt.Rows[i]["ColWidth"].ToString()), dt.Rows[i]["AlignmentID"].ToString(), dt.Rows[i]["ColCaption"].ToString(), GetValueReplica(dt.Rows[i]["ColTypeID"].ToString(), 0, dt.Rows[i]["ColCaption"].ToString(), dt.Rows[i]["NewRowID"].ToString()), false, dt.Rows[i]["StyleID"].ToString(), dt.Rows[i]["NewRowID"].ToString());
                        if (i == dt.Rows.Count - 1)
                        {
                            ConstantRow += "<br/>";
                            for (int j = 0; j < width; j++)
                            {
                                ConstantRow += "-";
                            }
                            ConstantRow += "<br/>";
                        }

                        //ConstantRow += GetLineToAlignment(Convert.ToInt32(dt.Rows[i]["ColWidth"].ToString()), dt.Rows[i]["AlignmentID"].ToString(), dt.Rows[i]["ColCaption"].ToString(), GetValueReplica(dt.Rows[i]["ColTypeID"].ToString(), 0, dt.Rows[i]["ColCaption"].ToString(), dt.Rows[i]["NewRowID"].ToString()), false, dt.Rows[i]["StyleID"].ToString(), dt.Rows[i]["NewRowID"].ToString());
                    }
                    ConstantRow += "<br/>";
                    for (int t = 0; t < 3; t++)
                    {
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            ConstantRow += GetLineToAlignment(Convert.ToInt32(dt.Rows[i]["ColWidth"].ToString()), dt.Rows[i]["AlignmentID"].ToString(), GetValueReplica(dt.Rows[i]["ColTypeID"].ToString(), 8, dt.Rows[i]["ColCaption"].ToString(), dt.Rows[i]["NewRowID"].ToString()).Trim(), GetValueReplica(dt.Rows[i]["ColTypeID"].ToString(), 0, dt.Rows[i]["ColCaption"].ToString(), dt.Rows[i]["NewRowID"].ToString()), false, dt.Rows[i]["StyleID"].ToString(), dt.Rows[i]["NewRowID"].ToString());
                        }
                        ConstantRow += "<br/>";
                    }
                    break;
                case "2"://KeyValue

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ConstantRow += GetLineToAlignment(Convert.ToInt32(dt.Rows[i]["ColWidth"].ToString()), dt.Rows[i]["AlignmentID"].ToString(), dt.Rows[i]["ColCaption"].ToString(), GetValueReplica(dt.Rows[i]["ColTypeID"].ToString(), 8, dt.Rows[i]["ColCaption"].ToString(), dt.Rows[i]["NewRowID"].ToString()), false, dt.Rows[i]["StyleID"].ToString(), dt.Rows[i]["NewRowID"].ToString());
                        if (dt.Rows[i]["NewRowID"].ToString() == "3")
                            ConstantRow += "<br/>";
                    }
                    break;
                case "3"://KeyValueNewLine

                    break;
                case "4"://Constant
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ConstantRow += GetLineToAlignment(Convert.ToInt32(dt.Rows[i]["ColWidth"].ToString()), dt.Rows[i]["AlignmentID"].ToString(), dt.Rows[i]["ColCaption"].ToString(), "", false, dt.Rows[i]["StyleID"].ToString(), dt.Rows[i]["NewRowID"].ToString());
                        if (dt.Rows[i]["NewRowID"].ToString() == "3")
                            ConstantRow += "<br/>";
                    }
                    break;
                case "5"://Repeater
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        width = 0;
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            width += Convert.ToDouble(dt.Rows[i]["ColWidth"].ToString());
                        }
                        for (int j = 0; j < width; j++)
                        {
                            ConstantRow += dt.Rows[0]["ColCaption"].ToString();
                        }
                        if (dt.Rows[0]["NewRowID"].ToString() == "3")
                            ConstantRow += "<br/>";
                    }
                    break;
                case "6"://KeyValHalfScreen

                    break;
                case "7"://pic
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ConstantRow += GetLineToAlignment(Convert.ToInt32(dt.Rows[i]["ColWidth"].ToString()), dt.Rows[i]["AlignmentID"].ToString(), "-------------MTNImage------------------", "", false, dt.Rows[i]["StyleID"].ToString(), dt.Rows[i]["NewRowID"].ToString());
                        if (dt.Rows[i]["NewRowID"].ToString() == "3")
                            ConstantRow += "<br/>";
                    }
                    break;

            }
            ConstantRow = ConstantRow.Replace(" ", "&nbsp;");
            ConstantRow = ConstantRow.Replace("span&nbsp;", "span ");
            HTM += ConstantRow
            + "</div>"
            + "</div>";
        }
        ResponseJSON(context, HTM);
    }
    private string GetLineToAlignment(int RowLength, string AlignmentID, string Key, string Value, bool hasNewLine, string StyleID, string NewRowID)
    {
        string retVal = "";
        string pad = "";
        switch (AlignmentID)
        {
            case "1"://Right
                if (RowLength > Key.Length + Value.Length)
                    pad = retVal.PadLeft(RowLength - (Key.Length + Value.Length), ' ');
                else
                    pad = retVal.PadLeft(Key.Length + Value.Length);
                break;
            case "2"://Center
                pad = retVal.PadLeft(RowLength / 2 - (Key.Length + Value.Length) / 2, ' ');
                break;
            case "3"://Left                    
                break;
        }

        retVal = (GetLineStyle(StyleID, Key));

        switch (NewRowID)
        {
            case "1"://ללא

                break;
            case "2"://באמצע
                switch (AlignmentID)
                {
                    case "1"://Right
                        pad = "";
                        pad = pad.PadLeft(RowLength - (Key.Length), ' ');
                        retVal += pad;
                        pad = "";
                        retVal += "<br/>";
                        pad = pad.PadLeft(RowLength - (Value.Length), ' ');
                        break;
                    case "2"://Center
                        pad = "";
                        pad = pad.PadLeft(RowLength / 2 - (Key.Length), ' ');
                        retVal += pad;
                        pad = "";
                        retVal += "<br/>";
                        pad = pad.PadLeft(RowLength / 2 - (Value.Length), ' ');
                        break;
                    case "3"://Left 
                        pad = "";
                        retVal += "<br/>";
                        break;
                }

                break;
            case "3"://לאחר

                break;
        }
        retVal += GetLineStyle(StyleID, Value);
        retVal += pad;

        return retVal;
    }
    private string GetLineStyle(string StyleID, string txt)
    {
        string retVal = "";
        MainService.MobiPlusWS WR = new MainService.MobiPlusWS();
        System.Data.DataTable dt = WR.Prn_GetPartColStyle(StyleID, ConStrings.DicAllConStrings[SessionProjectName]);
        string bold = "500";
        string isUnderline = ";";
        string BGColor = ";";
        if (dt != null)
        {
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["isBold"].ToString() == "1")
                    bold = "700";

                if (dt.Rows[0]["isUnderline"].ToString() == "1")
                    isUnderline += "text-decoration:underline;";

                if (dt.Rows[0]["BackColor"].ToString() != "")
                    BGColor += "background-color:" + dt.Rows[0]["BackColor"].ToString();
                //font-family:" + dt.Rows[0]["FontFamily"].ToString() + ";
                string FontSize = "";
                if (Convert.ToInt32(dt.Rows[0]["FontSize"].ToString()) > 14)
                    FontSize = "font-size:17px;";
                retVal = "<span style=\"" + FontSize + "color:" + dt.Rows[0]["ForeColor"].ToString() + BGColor
                    + ";font-weight:" + bold + isUnderline + "; \">" + txt + "</span>";
            }
        }

        return retVal;
    }
    private string GetValueReplica(string Type, double ValueLength, string Key, string NewRowID)
    {
        ValueLength = (int)ValueLength;
        if (ValueLength == 0)
            return " ";
        string[] arrStr = { "א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט", "י", "כ", "ל", "מ", "נ", "ס", "ע", "פ", "צ", "ק", "ר", "ש", "ת" };

        string retVal = "";
        int counb = 1;
        switch (Type)
        {
            case "1"://int
                for (int i = 0; i < ValueLength; i++)
                {
                    if (i == 0 && Key.Length > 0 && NewRowID != "2")
                    {
                        retVal += " ";
                    }
                    else
                    {
                        retVal += counb.ToString();
                    }
                    counb++;
                }
                break;
            case "2"://float
                for (int i = 0; i < ValueLength; i++)
                {
                    if (i == 0 && Key.Length > 0 && NewRowID != "2")
                    {
                        retVal += " ";
                    }
                    else
                    {
                        retVal += counb.ToString();
                    }
                    counb++;
                }
                break;
            case "3"://string   
                for (int i = 0; i < ValueLength && i < 22; i++)
                {
                    if (i == 0 && Key.Length > 0 && NewRowID != "2")
                    {
                        retVal += " ";
                    }
                    else
                    {
                        retVal += arrStr[counb];
                    }

                    counb++;
                    if (counb > 21)
                        counb = 1;
                }
                break;
            case "4"://const

                break;
        }

        return retVal;
    }
    private void Prn_SetReport(HttpContext context, string id, string reportName, string reportDesc, string rowLen, string IsToDelete, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Prn_SetReport(id, reportName, reportDesc, rowLen, IsToDelete, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Prn_GetReportData(HttpContext context, string id)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_GetReportData?id=" + id +
             "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Prn_SetPartsToReport(HttpContext context, string strJson, string strHTM, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Prn_SetPartsToReport(strJson, strHTM, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void prn_GetReportAllData(HttpContext context, string ReportID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.prn_GetReportAllData(ReportID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void prn_GetReportRowLen(HttpContext context, string ReportID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.prn_GetReportRowLen(ReportID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Prn_SetDuplicateReport(HttpContext context, string DuplicateFromReportCode, string DuplicateToReportName, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Prn_SetDuplicateReport(DuplicateFromReportCode, DuplicateToReportName, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Prn_SetDuplicatePart(HttpContext context, string DuplicateFromPartID, string DuplicateToPartName, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Prn_SetDuplicatePart(DuplicateFromPartID, DuplicateToPartName, UserID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Layout_GetProfileComponents(HttpContext context, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetProfileComponents?LayoutTypeID=" + LayoutTypeID +
             "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_SetProfileData(HttpContext context, string ProfileComponentsID, string ProfileTypeID, string ProfileName,
        string FormLayoutID, string MenuID, string IsToDelete, string UserID, string LayoutTypeID, string OrderMenuID, string ReceiptMenuID, string ProfileID)
    {
        if (FormLayoutID == "null")
            FormLayoutID = "-1";

        if (MenuID == "null")
            MenuID = "-1";

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Layout_SetProfileData(ProfileComponentsID, ProfileTypeID, ProfileName, FormLayoutID, MenuID, IsToDelete, UserID, ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID, OrderMenuID, ReceiptMenuID, ProfileID).ToString());
    }
    private void VerLayout_GetAllChanges(HttpContext context, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/VerLayout_GetAllChanges" +
             "?LayoutTypeID=" + LayoutTypeID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void VerLayout_SetNewVersion(HttpContext context, string VersionID, string VersionName, string VersionDescription, string LayoutTypeID, string UserID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.VerLayout_SetNewVersion(VersionID, VersionName, VersionDescription, UserID, LayoutTypeID, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void VerLayout_SuggestNewVersionID(HttpContext context)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.VerLayout_SuggestNewVersionID(ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void VerLayout_GetAllVersions(HttpContext context, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/VerLayout_GetAllVersions" +
             "?LayoutTypeID=" + LayoutTypeID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void VerLayout_CheckForNewVersion(HttpContext context)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.VerLayout_CheckForNewVersion(ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void VerLayout_SetReplaceWorkingLayout(HttpContext context, string ToVersionID, string UserID)
    {
        string Pass = "mtn2015";
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.VerLayout_SetReplaceWorkingLayout(ToVersionID, UserID, Pass, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void AddColdsByQuery(HttpContext context, string LayoutTypeID, string ReportID, string UserID, string colCaptionTrans = null)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        System.Data.DataTable dtRerportOrg = wr.Layout_GetReportDataDT(ReportID, ConStrings.DicAllConStrings[SessionProjectName]);

        if (dtRerportOrg != null && dtRerportOrg.Rows.Count > 0)
        {
            //if (dtRerportOrg.Rows[0]["ReportTypeID"].ToString() == "1")//Grid Report
            {
                //DataTable dt = selectQuery(dtRerportOrg.Rows[0]["ReportQuery"].ToString());\
                string Query = "";
                if (LayoutTypeID == "1")
                    Query = SetAllVariables(dtRerportOrg.Rows[0]["ReportQuery"].ToString(), "''");
                else if (LayoutTypeID == "3")
                    Query = dtRerportOrg.Rows[0]["ReportQuery"].ToString();
                System.Data.DataTable dt = new System.Data.DataTable();
                if (dtRerportOrg.Rows[0]["ReportDataSourceID"].ToString() == "1")
                {
                    string[] arr = GetAllVariables(dtRerportOrg.Rows[0]["ReportQuery"].ToString());
                    for (int i = 0; i < arr.Length; i++)
                    {
                        Query = Query.Replace(arr[i] + " ", "'0' ");
                        Query = Query.Replace(arr[i] + ",", "'0' ");
                        Query = Query.Replace(arr[i] + "=", "'0'=");
                    }

                    dt = selectQuery(context, Query.ToLower(), LayoutTypeID);
                }
                else if (dtRerportOrg.Rows[0]["ReportDataSourceID"].ToString() == "3")
                {
                    string[] arrP = dtRerportOrg.Rows[0]["Report_SP_Params"].ToString().Split(';');
                    string paramsR = "";
                    for (int i = 0; i < arrP.Length; i++)
                    {
                        paramsR += arrP[i].Replace("@", "") + ":0;";
                    }
                    dt = wr.getDataTable(dtRerportOrg.Rows[0]["ReportQuery"].ToString(), "mtns2015", true, paramsR, ConStrings.DicAllConStrings[SessionProjectName]);
                }

                System.Data.DataTable dtCols = wr.Layout_GetReportColsDT(ReportID, ConStrings.DicAllConStrings[SessionProjectName]);

                System.Data.DataView dv = dtCols.DefaultView;
                dv.Sort = "ColOrder";
                dtCols = dv.ToTable();

                int counter = 0;
                string[] arrCols = new string[dt.Columns.Count];
                int MaxOrder = 10;
                if (dt != null && dtCols != null && dt.Columns.Count > 0)
                {
                    for (int t = 0; t < dt.Columns.Count; t++)
                    {
                        Object obj = dt.Columns[t];
                        //Type type = typeof(obj);
                        bool HasToAdd = true;
                        for (int i = 0; i < dtCols.Rows.Count; i++)
                        {
                            if (MaxOrder < Convert.ToInt32(dtCols.Rows[i]["ColOrder"].ToString()))
                                MaxOrder = Convert.ToInt32(dtCols.Rows[i]["ColOrder"].ToString()) + 10;
                            if (dt.Columns[t].ColumnName == dtCols.Rows[i]["ColName"].ToString())
                            {
                                HasToAdd = false;
                                break;
                            }
                        }
                        if (HasToAdd)
                        {
                            arrCols[counter] = dt.Columns[t].ColumnName + ";" + dt.Columns[t].DataType.ToString();
                            counter++;
                        }
                    }

                    for (int i = 0; i < arrCols.Length && counter > 0; i++)
                    {
                        if (arrCols[i] != null && arrCols[i] != String.Empty)
                        {
                            string ColTypeID = "3";//string

                            switch (arrCols[i].Split(';')[1].ToLower())
                            {
                                case "system.string":
                                    ColTypeID = "3";
                                    break;
                                case "system.int32":
                                    ColTypeID = "1";
                                    break;
                                case "system.float":
                                    ColTypeID = "2";
                                    break;
                            }
                            Layout_SetReportCol(context, "0", ReportID, arrCols[i].Split(';')[0], arrCols[i].Split(';')[0], ((MaxOrder)).ToString(), (100 / counter).ToString(), ColTypeID, "0", "1", "", "0", "1", "0", "1", UserID, "0", colCaptionTrans);
                            MaxOrder = MaxOrder + 10;
                        }
                    }
                }
            }
        }
    }
    private string SetAllVariables(string Query, string Value)
    {
        string[] arr = new string[Query.Split('@').Length - 1];
        int counter = 0;
        for (int i = 0; i < Query.Length; i++)
        {
            if (Query[i] == '@')
            {
                arr[counter] = Query.Substring(i, Query.Length - i);
                arr[counter] = arr[counter].Substring(0, arr[counter].IndexOf(" ") == -1 && arr[counter].IndexOf(")") == -1 ? arr[counter].Length : arr[counter].IndexOf(" "));

                i += arr[counter].Length - 1;
                counter++;


            }
        }

        for (int i = 0; i < arr.Length; i++)
        {
            Query = Query.Replace(arr[i], Value);
        }

        return Query;
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
                var = var.Substring(0, var.IndexOf("=") == -1 ? var.Length : var.IndexOf("="));
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
    private bool hasTheSameVar(string[] arr, string Var)
    {
        for (int i = 0; i < arr.Length; i++)
        {
            if (arr[i] != null && arr[i].ToLower() == Var.ToLower())
                return true;
        }
        return false;
    }
    private System.Data.DataTable selectQuery(HttpContext context, string query, string LayoutTypeID)
    {
        if (LayoutTypeID == "1")//android
        {
            System.Data.SQLite.SQLiteDataAdapter ad;
            System.Data.DataTable dt = new System.Data.DataTable();
            System.Data.SQLite.SQLiteConnection sqlite = new System.Data.SQLite.SQLiteConnection("Data Source=" + System.Configuration.ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteMtnDBPath"].ToString()); ;

            try
            {


                string path = System.Configuration.ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteBIDBPath"].ToString();
                string path2 = System.Configuration.ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteDBDBPath"].ToString();
                string path3 = System.Configuration.ConfigurationManager.AppSettings[SessionProjectName + "_" + "SqlLiteDeltaDBPath"].ToString();
                System.Data.SQLite.SQLiteCommand cmd;
                sqlite.Open();  //Initiate connection to the db
                cmd = sqlite.CreateCommand();
                cmd.CommandText = "ATTACH '" + path + "' AS BI; " + "ATTACH '" + path2 + "' AS DB1; " + "ATTACH '" + path3 + "' AS Delta; " + query;  //set the passed query
                ad = new System.Data.SQLite.SQLiteDataAdapter(cmd);
                ad.Fill(dt); //fill the datasource
            }
            catch (System.Data.SQLite.SQLiteException ex)
            {
                MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString(), SessionUserID, SessionUserPromt);
                context.Response.Write(ex.Message);
            }
            sqlite.Close();
            GC.Collect();
            return dt;
        }
        else if (LayoutTypeID == "3")//web
        {
            MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
            System.Data.DataTable dt = wr.getDataTable(query, "mtns2015", false, "", ConStrings.DicAllConStrings[SessionProjectName]);
            return dt;
        }
        return new System.Data.DataTable();
    }
    private void Layout_GetUsersProfileComponents(HttpContext context, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Layout_GetUsersProfileComponents" +
             "?LayoutTypeID=" + LayoutTypeID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Layout_SetUserData(HttpContext context, string Name, string Description, string UserName, string Password, string Profileid, string Defult, string IsToDelete, string MPUserID, string UserID,
            string LayoutTypeID, string UserProfileID, string MobileProfileid)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Layout_SetUserData(Name, Description, UserName, Password, Profileid, Defult, IsToDelete, MPUserID, UserID,
            LayoutTypeID, UserProfileID, MobileProfileid, ConStrings.DicAllConStrings[SessionProjectName]).ToString());
    }
    private void Test_GetItems(HttpContext context)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Test_GetItems" +
             "?ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private void Prn_GetReportParams(HttpContext context, string reportCode)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_GetReportParams" +
             "?reportCode=" + reportCode + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void Prn_Set_ReportParameter(HttpContext context, string ReportParameterID, string reportCode, string ParameterName, string ParameterDescription, string ParameterDefaultValue, string ParameterOrder, string ParamterTypeID, string ParamQuery,
            string UserID, string IsToDelete)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Prn_Set_ReportParameter" +
             "?ReportParameterID=" + ReportParameterID + "&reportCode=" + reportCode + "&ParameterName=" + ParameterName + "&ParameterDescription=" + ParameterDescription + "&ParameterDefaultValue=" + ParameterDefaultValue +
             "&ParameterOrder=" + ParameterOrder + "&ParamterTypeID=" + ParamterTypeID + "&ParamQuery=" + ParamQuery.Replace("\n", "  ").Replace("\t", "  ").Replace("***", "+") +
             "&UserID=" + UserID + "&IsToDelete=" + IsToDelete + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void Frg_SetSectionData(HttpContext context, string SectionID, string SectionName, string SectionDescription, string SectionValue, string LayoutTypeID, string SectionTypeID
       , string SectionAlignID, string SectionMaxLength, string StyleID, string FormatID, string UserID, string IsToDelete)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Frg_SetSectionData" +
             "?SectionID=" + SectionID + "&SectionName=" + SectionName + "&SectionDescription=" + SectionDescription + "&SectionValue=" + SectionValue + "&LayoutTypeID=" + LayoutTypeID +
             "&SectionTypeID=" + SectionTypeID + "&SectionAlignID=" + SectionAlignID + "&SectionMaxLength=" + SectionMaxLength +
             "&StyleID=" + StyleID + "&FormatID=" + FormatID + "&UserID=" + UserID + "&IsToDelete=" + IsToDelete + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void Frg_GetSectionData(HttpContext context, string SectionID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Frg_GetSectionData" +
             "?SectionID=" + SectionID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    public void Frg_SetFragmentData(HttpContext context, string FragmentID, string FragmentName, string FragmentDescription, string FragmentHTMLLayout, string FragmentSectionsJson, string LayoutTypeID, string FragmentWidth
        , string FragmentHeight, string UserID, string IsToDelete, string FragmentBackColor, string OrderReportID, string FragmentProfiles, string IsShadow, string IsRounded)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Frg_SetFragmentData(FragmentID, FragmentName, FragmentDescription, FragmentHTMLLayout, FragmentSectionsJson, LayoutTypeID, FragmentWidth
        , FragmentHeight, FragmentBackColor, OrderReportID, FragmentProfiles, IsShadow, IsRounded, UserID, IsToDelete, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    public void Frg_GetFragmentData(HttpContext context, string FragmentID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Frg_GetFragmentData" +
             "?FragmentID=" + FragmentID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str.Replace("+", "%2b")));
    }
    public void Frg_SetSettingsData(HttpContext context, string SettingID, string LayoutTypeID, string ItemFragment, string CategoryReportID, string ItemReportID, string FragmentMarginsPX
          , string DefaultCategory, string UserID, string CategoryLevels, string CategoryFragment1, string CategoryFragment2, string CategoryFragment3, string CategoryFragment4,
         string EditWinFormID, string EditWinFieldID, string EditWinFieldPriceID, string EditWinFieldName, string EditWinFieldProdHierarchy1, string EditWinFieldProdHierarchy2, string EditWinFieldProdHierarchy3,
         string EditWinFieldProdHierarchy4, string UserProfileID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ResponseJSON(context, wr.Frg_SetSettingsData(SettingID, LayoutTypeID, ItemFragment, CategoryReportID, ItemReportID, FragmentMarginsPX,
          DefaultCategory, UserID, CategoryLevels, CategoryFragment1, CategoryFragment2, CategoryFragment3, CategoryFragment4,
          EditWinFormID, EditWinFieldID, EditWinFieldPriceID, EditWinFieldName, EditWinFieldProdHierarchy1, EditWinFieldProdHierarchy2, EditWinFieldProdHierarchy3, EditWinFieldProdHierarchy4,
          UserProfileID, ConStrings.DicAllConStrings[SessionProjectName]));
    }
    public void Frg_GetSettingsData(HttpContext context, string LayoutTypeID)
    {
        WebClient client = new WebClient();
        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MobiPlusWS.asmx/Frg_GetSettingsData" +
             "?LayoutTypeID=" + LayoutTypeID + "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);
        ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str.Replace("+", "%2b")));
    }
    public void DuplicateReport(HttpContext context, string DuplicateFromReportCode, string DuplicateToReportName, string DB)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        string NewDB = (ConStrings.DicAllConStrings[DB]).ToString().Substring(((ConStrings.DicAllConStrings[DB]).ToString().ToLower().IndexOf("database=") + 9), (ConStrings.DicAllConStrings[DB]).ToString().ToLower().IndexOf(";user id=") - ((ConStrings.DicAllConStrings[DB]).ToString().ToLower().IndexOf("database=") + 9));
        ResponseJSON(context, wr.Layout_SetDuplicateReport(DuplicateFromReportCode, DuplicateToReportName, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName], NewDB).ToString());
    }
    public void DuplicateForm(HttpContext context, string DuplicateFromFormCode, string DuplicateToFormName, string DB)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        string NewDB = (ConStrings.DicAllConStrings[DB]).ToString().Substring(((ConStrings.DicAllConStrings[DB]).ToString().ToLower().IndexOf("database=") + 9), (ConStrings.DicAllConStrings[DB]).ToString().ToLower().IndexOf(";user id=") - ((ConStrings.DicAllConStrings[DB]).ToString().ToLower().IndexOf("database=") + 9));
        ResponseJSON(context, wr.Layout_SetDuplicateForm(DuplicateFromFormCode, DuplicateToFormName, SessionUserID, ConStrings.DicAllConStrings[SessionProjectName], NewDB).ToString());
    }
}


