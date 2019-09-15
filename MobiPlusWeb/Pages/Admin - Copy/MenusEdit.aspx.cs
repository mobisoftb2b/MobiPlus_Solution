using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Admin_MenusEdit : PageBaseCls
{
    public string LayoutTypeID = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if(Request.QueryString["LayoutTypeID"] != null)
                LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
            initMenus();
            initMenuItems();
            initImgs();
        }
    }
    protected void btnGetMenusData_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        initMenus();
    }
    protected void btnGetMenuItemData_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        ddlItemObjectType_SelectedIndexChanged(this, new EventArgs());
    }
    protected void ddlItemObjectType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt1 = new DataTable("dt1");
        dt1.Columns.Add("Name");
        dt1.Columns.Add("id");

        ddlItemObjectID.DataSource = dt1;
        ddlItemObjectID.DataTextField = "Name";
        ddlItemObjectID.DataValueField = "id";
        ddlItemObjectID.DataBind();

        switch (ddlItemObjectType.SelectedValue)
        {
            case "1"://Compiled Activity  
                ddlItemObjectID.DataSource = wr.Layout_GetCompileActivities(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlItemObjectID.DataTextField = "CompileActivityName";
                ddlItemObjectID.DataValueField = "CompileActivityID";
                ddlItemObjectID.DataBind();
                break;
            case "2"://Report 
                ddlItemObjectID.DataSource = wr.Layout_GetReports(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
                ddlItemObjectID.DataTextField = "ReportName";
                ddlItemObjectID.DataValueField = "ReportID";
                ddlItemObjectID.DataBind();
                break;
            case "3"://Menu
                ddlItemObjectID.DataSource = wr.Layout_GetMenusForWeb(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
                ddlItemObjectID.DataTextField = "MenuName";
                ddlItemObjectID.DataValueField = "MenuID";
                ddlItemObjectID.DataBind();
                break;
            case "4"://Questionnaire  
                ddlItemObjectID.DataSource = wr.Layout_GetQuestionnaires(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlItemObjectID.DataTextField = "questionnaireDescription";
                ddlItemObjectID.DataValueField = "idQuestionnaire";
                ddlItemObjectID.DataBind();
                break;
            case "5"://Designer Form 
                ddlItemObjectID.DataSource = wr.Layout_GetForms(LayoutTypeID,ConStrings.DicAllConStrings[SessionProjectName]);
                ddlItemObjectID.DataTextField = "FormName";
                ddlItemObjectID.DataValueField = "FormID";
                ddlItemObjectID.DataBind();
                ddlItemObjectID.Items.Remove(ddlItemObjectID.Items.FindByValue("0"));
                break;
            case "6"://Doc Type 
                ddlItemObjectID.DataSource = wr.Layout_GetDocTypes(LayoutTypeID, ConStrings.DicAllConStrings[SessionProjectName]);
                ddlItemObjectID.DataTextField = "Description";
                ddlItemObjectID.DataValueField = "DocTypeId";
                ddlItemObjectID.DataBind();
                break;
            case "7"://Printer
                ddlItemObjectID.DataSource = wr.Prn_GetReports(ConStrings.DicAllConStrings[SessionProjectName]);
                ddlItemObjectID.DataTextField = "reportName";
                ddlItemObjectID.DataValueField = "reportCode";
                ddlItemObjectID.DataBind();
                break;
        }
        upddlHeaderZoomObjs.Update();

        ScriptManager.RegisterClientScriptBlock(this.Page,typeof(Page),"jkey1","setTimeout('SetObj();',400);",true);
    }
    private void initMenus()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ddlMenus.DataSource = wr.Layout_GetMenusForWeb(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
        ddlMenus.DataTextField = "MenuName";
        ddlMenus.DataValueField = "MenuID";
        ddlMenus.DataBind();

        ddlViewTypeDescription.DataSource = wr.Layout_GetViewTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlViewTypeDescription.DataTextField = "ViewTypeDescription";
        ddlViewTypeDescription.DataValueField = "ViewType";
        ddlViewTypeDescription.DataBind();

        if (ddlMenus.Items.Count > 0)
        {
            ddlMenus.Items[0].Selected = true;
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "jkey1", "setTimeout('ShowGrid();',200);", true);
        }
    }
    private void initMenuItems()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ddlItemObjectType.DataSource = wr.Layout_GetZoomObjTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlItemObjectType.DataTextField = "ZoomObjType";
        ddlItemObjectType.DataValueField = "ZoomObjTypeID";
        ddlItemObjectType.DataBind();
    }
    private void initImgs()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt = wr.Layout_GetAllImages(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
        if (dt != null && dt.Rows.Count > 0)
        {
            //dAllImgs
            HtmlGenericControl dynTBLAll = new HtmlGenericControl("table");
            dynTBLAll.Attributes["cellpadding"] = "2";
            dynTBLAll.Attributes["cellspacing"] = "2";
            dynTBLAll.Style["min-height"] = "150px";


            HtmlGenericControl dynTR = new HtmlGenericControl("tr");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynTD = new HtmlGenericControl("td");
                dynTD.InnerHtml = dt.Rows[i]["ImgName"].ToString() + "<br/><br/>";
                dynTD.Style["width"] = "100px";
                dynTD.Style["border"] = "1px solid black";
                dynTD.Style["text-align"] = "center";
                dynTD.Style["background-color"] = "white";
                dynTD.Style["cursor"] = "pointer";
                dynTD.Attributes["onclick"] = "SetImg('" + dt.Rows[i]["ImgID"].ToString() + "');";
                Image img = new Image();
                img.ImageUrl = "~/Handlers/ShowImage.ashx?id=" + dt.Rows[i]["ImgID"].ToString();
                img.Style["max-width"] = "100px";

                dynTD.Controls.Add(img);

                HtmlGenericControl dynDiv = new HtmlGenericControl("div");
                dynDiv.Style["text-align"] = "left";
                dynDiv.InnerHtml = "<br/>Width: " + dt.Rows[i]["imgWidth"].ToString() + "<br/>Height: " + dt.Rows[i]["imgHeight"].ToString() + "<br/>";

                dynTD.Controls.Add(dynDiv);

                dynTR.Controls.Add(dynTD);
                if ((i+1) % 4 == 0)
                {
                    dynTBLAll.Controls.Add(dynTR);
                    dynTR = new HtmlGenericControl("tr");
                }
            }

            dynTBLAll.Controls.Add(dynTR);
            dAllImgs.Controls.Add(dynTBLAll);
        }
    }
}