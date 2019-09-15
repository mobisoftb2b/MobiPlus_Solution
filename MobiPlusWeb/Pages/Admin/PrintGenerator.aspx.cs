using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MainService;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Admin_PrintGenerator : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    protected void btnSave_click(object sender, EventArgs e)
    {

    }
    protected void btnRefreshReports_Click(object sender, EventArgs e)
    {
        SetddlDohot();
    }
    protected void btnAddSecrtionHidden_Click(object sender, EventArgs e)
    {

        // init();


    }
    private void SetddlDohot()
    {
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dtReports = WR.Prn_GetReports(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtReports != null)
        {
            ddlDohot.DataSource = dtReports;
            ddlDohot.DataTextField = "reportName";
            ddlDohot.DataValueField = "id";
            ddlDohot.DataBind();

            try
            {
                if (hdnReportID.Value != "")
                {
                    ddlDohot.SelectedValue = hdnReportID.Value;
                }
                else if(ddlDohot.Items.Count > 0)
                {
                    ddlDohot.SelectedValue = dtReports.Rows[0]["id"].ToString();
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "setNew1", "setTimeout('GetReportHTM();GetReportRowLen();',100);", true);
                }
            }
            catch (Exception ex)
            {
            }
        }
    }
    private void init()
    {
        MobiPlusWS WR = new MobiPlusWS();
        SetddlDohot();

        ddlParamterType.DataSource=WR.Prn_GetParameterTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlParamterType.DataTextField="ParamterTypeName";
        ddlParamterType.DataValueField="ParamterTypeID";
        ddlParamterType.DataBind();
        
        DataTable dtTopics = WR.Prn_GetTopics(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtTopics != null && dtTopics.Rows.Count > 0)
        {
            for (int r = 0; r < dtTopics.Rows.Count; r++)
            {
                DataTable dt = WR.Prn_GetPartsByTopicID(dtTopics.Rows[r]["TopicID"].ToString(),ConStrings.DicAllConStrings[SessionProjectName]);
                //dt.Rows.RemoveAt(0);
                if (dt != null && dt.Rows.Count > 0)
                {
                    HtmlGenericControl divSectionHeader = new HtmlGenericControl("div");
                    divSectionHeader.Attributes["class"] = "h3Section";
                    divSectionHeader.InnerText = dtTopics.Rows[r]["Topic"].ToString();

                    HtmlGenericControl divSections = new HtmlGenericControl("div");
                    divSections.Attributes["class"] = "divSections";

                    HtmlGenericControl tblSections = new HtmlGenericControl("table");
                    tblSections.Attributes["cellpadding"] = "0";
                    tblSections.Attributes["cellspacing"] = "0";
                    tblSections.Attributes["class"] = "MSGrid";

                    HtmlGenericControl dynTR = new HtmlGenericControl("tr");

                    HtmlGenericControl dynTDID = new HtmlGenericControl("td");
                    HtmlGenericControl dynTDName = new HtmlGenericControl("td");
                    HtmlGenericControl dynTDType = new HtmlGenericControl("td");
                    HtmlGenericControl dynTDBtn = new HtmlGenericControl("td");

                    dynTDID.InnerText = "ID";
                    dynTDID.Attributes["class"] = "MSHeader rbr";

                    dynTDName.InnerText = "שם מקטע";
                    dynTDName.Attributes["class"] = "MSHeader";

                    dynTDType.InnerText = "סוג";
                    dynTDType.Attributes["class"] = "MSHeader lbr";

                    dynTDBtn.Attributes["class"] = "MSHeader";
                    dynTDBtn.Style["width"] = "80px";

                    dynTR.Controls.Add(dynTDID);
                    dynTR.Controls.Add(dynTDName);
                    dynTR.Controls.Add(dynTDType);
                    dynTR.Controls.Add(dynTDBtn);

                    tblSections.Controls.Add(dynTR);

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dynTR = new HtmlGenericControl("tr");

                        dynTDID = new HtmlGenericControl("td");
                        dynTDName = new HtmlGenericControl("td");
                        dynTDType = new HtmlGenericControl("td");
                        dynTDBtn = new HtmlGenericControl("td");

                        dynTDID.InnerText = dt.Rows[i]["idPart"].ToString();
                        dynTDID.Attributes["class"] = "MSItem";

                        dynTDName.InnerText = dt.Rows[i]["PartName"].ToString();
                        dynTDName.Attributes["class"] = "MSItem";

                        dynTDType.InnerText = dt.Rows[i]["PartTypeName"].ToString();
                        dynTDType.Attributes["class"] = "MSItem";

                       // dynTDBtn.InnerHtml = "<input type='button' value='הוסף' class='MSBtnGeneral' style=\"background-image: url('../../Img/plus_16.png');width: 70px;\" onclick=\"AddToPrinterSection(" + dt.Rows[i]["idPart"].ToString() + ",'" + DateTime.Now.Ticks.ToString() + "')\" />";
                        dynTDBtn.InnerHtml = "<a class='a1' href=\"javascript:AddToPrinterSection(" + dt.Rows[i]["idPart"].ToString() + ",'" + DateTime.Now.Ticks.ToString() + "')\">הוסף לטופס</a><br/><a class='a1' href='javascript:OpenEditSections(\"" + dt.Rows[i]["idPart"].ToString() + "\");'>ערוך</a>";
                        dynTDBtn.Attributes["class"] = "MSItem";

                        dynTR.Controls.Add(dynTDID);
                        dynTR.Controls.Add(dynTDName);
                        dynTR.Controls.Add(dynTDType);
                        dynTR.Controls.Add(dynTDBtn);

                        tblSections.Controls.Add(dynTR);
                    }

                    divSections.Controls.Add(tblSections);

                    dtblSections.Controls.Add(divSectionHeader);
                    dtblSections.Controls.Add(divSections);
                }
            }
        }
    }

}