using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MainService;

public partial class Pages_Admin_EditProfiles : PageBaseCls
{
    public string LayoutTypeID = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
            SetDDLProfiles();
        }
    }
    protected void GetAllClick(object sender, EventArgs e)
    {
        init();
    }
    protected void btnGetProfiles_Click(object sender, EventArgs e)
    {
        SetDDLProfiles();
    }
    private void init()
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        MobiPlusWS WR = new MobiPlusWS();
        DataSet ds = WR.Layout_GetProfileDDLs(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
        if (ds != null && ds.Tables.Count > 4)
        {
            ddlProfileTypes.DataSource = ds.Tables[0];
            ddlProfileTypes.DataTextField = "ProfileType";
            ddlProfileTypes.DataValueField = "ProfileTypeID";
            ddlProfileTypes.DataBind();

            ddlProfileTypes.SelectedValue = "1";

            ddlProfileType.DataSource = ds.Tables[0];
            ddlProfileType.DataTextField = "ProfileType";
            ddlProfileType.DataValueField = "ProfileTypeID";
            ddlProfileType.DataBind();

            ddlProfileType.SelectedValue = "1";


            //ddlCustomerProfile.DataSource = ds.Tables[2];
            //ddlCustomerProfile.DataTextField = "CustomerProfileName";
            //ddlCustomerProfile.DataValueField = "CustomerProfileID";
            //ddlCustomerProfile.DataBind();


            ddlProfilestoUser.DataSource = ds.Tables[1];
            ddlProfilestoUser.DataTextField = "AgentProfileName";
            ddlProfilestoUser.DataValueField = "AgentProfileID";
            ddlProfilestoUser.DataBind();

            ddlProfilestoUserMobile.DataSource = ds.Tables[1];
            ddlProfilestoUserMobile.DataTextField = "AgentProfileName";
            ddlProfilestoUserMobile.DataValueField = "AgentProfileID";
            ddlProfilestoUserMobile.DataBind();

            ddlMenues.DataSource = ds.Tables[3];
            ddlMenues.DataTextField = "MenuName";
            ddlMenues.DataValueField = "MenuID";
            ddlMenues.DataBind();

            ddlOrderMenu.DataSource = ds.Tables[3];
            ddlOrderMenu.DataTextField = "MenuName";
            ddlOrderMenu.DataValueField = "MenuID";
            ddlOrderMenu.DataBind();

            ddlReceiptMenu.DataSource = ds.Tables[3];
            ddlReceiptMenu.DataTextField = "MenuName";
            ddlReceiptMenu.DataValueField = "MenuID";
            ddlReceiptMenu.DataBind();


            ddlForms.DataSource = ds.Tables[4];
            ddlForms.DataTextField = "FormName";
            ddlForms.DataValueField = "FormID";
            ddlForms.DataBind();

            ddlProfiles.DataSource = ds.Tables[5];
            ddlProfiles.DataTextField = "ProfileName";
            ddlProfiles.DataValueField = "ProfileID";
            ddlProfiles.DataBind();

            ddlLayoutTypeID.DataSource = ds.Tables[6];
            ddlLayoutTypeID.DataTextField = "LayoutType";
            ddlLayoutTypeID.DataValueField = "LayoutTypeID";
            ddlLayoutTypeID.DataBind();

        }
    }
    private void SetDDLProfiles()
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        MobiPlusWS WR = new MobiPlusWS();
        string isAgent = "1";
        if (hdnProfileTypeID.Value == "2")
        {
            isAgent = "0";
        }

        DataSet ds = WR.Layout_GetProfilesDDL(LayoutTypeID, isAgent, ConStrings.DicAllConStrings[SessionProjectName]);
        if (ds != null && ds.Tables.Count > 0)
        {
            ddlProfiles.DataSource = ds.Tables[0];
            ddlProfiles.DataTextField = "ProfileName";
            ddlProfiles.DataValueField = "ProfileID";
            ddlProfiles.DataBind();

            try
            {
                if (hdnPrID.Value != "")
                    ddlProfiles.SelectedValue = hdnPrID.Value;
            }
            catch (Exception ex)
            {
            }

            ddlForms.DataSource = ds.Tables[1];
            ddlForms.DataTextField = "FormName";
            ddlForms.DataValueField = "FormID";
            ddlForms.DataBind();
        }
    }
}
