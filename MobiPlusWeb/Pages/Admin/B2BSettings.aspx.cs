using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Admin_B2BSettings : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();


        ddlLayoutType.DataSource = wr.Frg_Layout_GetLayoutTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlLayoutType.DataTextField = "LayoutType";
        ddlLayoutType.DataValueField = "LayoutTypeID";
        ddlLayoutType.DataBind();
        try
        {
            ddlLayoutType.SelectedValue = "3";
        }
        catch (Exception ex)
        { }

        DataTable dt1 = wr.Layout_GetReports(ConStrings.DicAllConStrings[SessionProjectName], "3"); ;
        ddlCatReport.DataSource = dt1;
        ddlCatReport.DataTextField = "ReportName";
        ddlCatReport.DataValueField = "ReportID";
        ddlCatReport.DataBind();

        ddlItemsReport.DataSource = dt1;
        ddlItemsReport.DataTextField = "ReportName";
        ddlItemsReport.DataValueField = "ReportID";
        ddlItemsReport.DataBind();

        DataTable dt2 = wr.Frg_GetDDLFrgments(ConStrings.DicAllConStrings[SessionProjectName]); ;

        ddlFrgCat1.DataSource = dt2;
        ddlFrgCat1.DataTextField = "FragmentName";
        ddlFrgCat1.DataValueField = "FragmentID";
        ddlFrgCat1.DataBind();
        ddlFrgCat1.Items.RemoveAt(0);

        ddlFrgCat2.DataSource = dt2;
        ddlFrgCat2.DataTextField = "FragmentName";
        ddlFrgCat2.DataValueField = "FragmentID";
        ddlFrgCat2.DataBind();
        ddlFrgCat2.Items.RemoveAt(0);

        ddlFrgCat3.DataSource = dt2;
        ddlFrgCat3.DataTextField = "FragmentName";
        ddlFrgCat3.DataValueField = "FragmentID";
        ddlFrgCat3.DataBind();
        ddlFrgCat3.Items.RemoveAt(0);

        ddlFrgCat4.DataSource = dt2;
        ddlFrgCat4.DataTextField = "FragmentName";
        ddlFrgCat4.DataValueField = "FragmentID";
        ddlFrgCat4.DataBind();
        ddlFrgCat4.Items.RemoveAt(0);

        ddlFrgItems.DataSource = dt2;
        ddlFrgItems.DataTextField = "FragmentName";
        ddlFrgItems.DataValueField = "FragmentID";
        ddlFrgItems.DataBind();
        ddlFrgItems.Items.RemoveAt(0);

        ddlEditWinForms.DataSource = wr.Layout_GetForms(ddlLayoutType.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);
        ddlEditWinForms.DataTextField = "FormName";
        ddlEditWinForms.DataValueField = "FormID";
        ddlEditWinForms.DataBind();

        ddlEditWinForms.Items.RemoveAt(1);
        ddlEditWinForms.SelectedValue = "-1";

        DataSet ds4 = wr.Layout_GetProfileDDLs(ConStrings.DicAllConStrings[SessionProjectName], ddlLayoutType.SelectedValue);
        ddlUserProfileID.DataSource = ds4.Tables[1];
        ddlUserProfileID.DataTextField = "AgentProfileName";
        ddlUserProfileID.DataValueField = "AgentProfileID";
        ddlUserProfileID.DataBind();
    }
}