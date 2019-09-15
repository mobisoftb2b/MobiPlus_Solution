using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_EditUser : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        cbDef.Text = StrSrc("Default");

        MPLayoutService WR = new MPLayoutService();
        DataSet ds = WR.MPLayout_GetUserRoles(SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);

        ddlRoles.DataSource = ds.Tables[0];
        ddlRoles.DataValueField = "UserRoleID";
        ddlRoles.DataTextField = "RoleName";
        ddlRoles.DataBind();
        ddlRoles.SelectedValue = "-1";

        ddlCountries.DataSource = ds.Tables[1];
        ddlCountries.DataValueField = "CountryID";
        ddlCountries.DataTextField = "CountryName";
        ddlCountries.DataBind();
        ddlCountries.SelectedValue = "-1";

        ddlDistributionCenter.DataSource = ds.Tables[2];
        ddlDistributionCenter.DataValueField = "DistributionCenterID";
        ddlDistributionCenter.DataTextField = "DistributionCenterName";
        ddlDistributionCenter.DataBind();
        ddlDistributionCenter.SelectedValue = "-1";

        ddlProfile.DataSource = ds.Tables[3];
        ddlProfile.DataValueField = "ProfileComponentsID";
        ddlProfile.DataTextField = "AgentProfileName";
        ddlProfile.DataBind();
        ddlProfile.SelectedValue = "-1";

        ddlManagers.DataSource = ds.Tables[4];
        ddlManagers.DataValueField = "UserID";
        ddlManagers.DataTextField = "Name";
        ddlManagers.DataBind();
        ddlManagers.SelectedValue = "-1";

        ddlLanguage.DataSource = ds.Tables[5];
        ddlLanguage.DataValueField = "LanguageID";
        ddlLanguage.DataTextField = "Language";
        ddlLanguage.DataBind();
        ddlLanguage.SelectedValue = "-1";

        if (Request.QueryString["UserRoleID"]!=null && Request.QueryString["UserRoleID"]!= "undefined")
            ddlRoles.SelectedValue = Server.UrlDecode(Request.QueryString["UserRoleID"]);

        hdnUserID.Value = "-1";

        if (Request.QueryString["UserID"] != null && Request.QueryString["UserID"] != "undefined")
            hdnUserID.Value = Server.UrlDecode(Request.QueryString["UserID"]);

        if (Request.QueryString["CountryID"] != null && Request.QueryString["CountryID"] != "undefined")
            ddlCountries.SelectedValue = Server.UrlDecode(Request.QueryString["CountryID"]);

        if (Request.QueryString["DistributionCenterID"] != null && Request.QueryString["DistributionCenterID"] != "undefined")
            ddlDistributionCenter.SelectedValue = Server.UrlDecode(Request.QueryString["DistributionCenterID"]);

        if (Request.QueryString["ProfileComponentsID"] != null && Request.QueryString["ProfileComponentsID"] != "undefined")
        {
            ddlProfile.SelectedValue = Server.UrlDecode(Request.QueryString["ProfileComponentsID"]);
            cbDef.Checked = true;
        }

        if (Request.QueryString["ManagerUserID"] != null && Request.QueryString["ManagerUserID"] != "undefined")
            ddlManagers.SelectedValue = Server.UrlDecode(Request.QueryString["ManagerUserID"]);

        txtUserName.Value = "";

        if (Request.QueryString["UserName"] != null && Request.QueryString["UserName"] != "undefined")
            txtUserName.Value = Server.UrlDecode(Request.QueryString["UserName"]);

        txtName.Value = "";

        if (Request.QueryString["Name"] != null && Request.QueryString["Name"] != "undefined")
            txtName.Value = Server.UrlDecode(Request.QueryString["Name"]);

        txtPass.Value = "";

        if (Request.QueryString["Password"] != null && Request.QueryString["Password"] != "undefined")
            txtPass.Value = Server.UrlDecode(Request.QueryString["Password"]);

        txtNum.Value = "0";

        if (Request.QueryString["UserID"] != null && Request.QueryString["UserID"] != "undefined")
            txtNum.Value = Server.UrlDecode(Request.QueryString["UserID"]);

        ddlLanguage.SelectedValue = "0";

        if (Request.QueryString["LanguageID"] != null && Request.QueryString["LanguageID"] != "undefined")
            ddlLanguage.SelectedValue = Server.UrlDecode(Request.QueryString["LanguageID"]);

        if (txtNum.Value=="-1")
        {
            txtNum.Value = "חדש";
        }
    }

    protected void ddlLanguage_SelectedIndexChanged(object sender, EventArgs e)
    {
        cbDef.Checked = false;
        ddlProfile.SelectedValue = "-1";
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.MPLayout_GetUserProfile(hdnUserID.Value, ddlLanguage.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlProfile.SelectedValue = dt.Rows[0]["ProfileComponentsID"].ToString();

            if(dt.Rows[0]["Defult"].ToString()=="1")
                cbDef.Checked = true;

        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "setPrArrServer();", "setTimeout('setPrArrServer();',100);", true); 
    }
}