using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Compield_Mecher : PageBaseCls
{
    public string strID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SetDDls("0", "0", "0", "0");

            if (Request.QueryString["ID"] != null)
                strID = Request.QueryString["ID"].ToString();
        }
    }

    protected void UpdateDDls(object sender, EventArgs e)
    {
        SetDDls(ddlAgents.SelectedValue, ddlCustomer.SelectedValue, ddlCategory.SelectedValue, ddlItem.SelectedValue);
    }
    protected void lbClearAgent_Click(object sender, EventArgs e)
    {
        SetDDls("0", ddlCustomer.SelectedValue, ddlCategory.SelectedValue, ddlItem.SelectedValue);
        ClearJS();
    }
    protected void lbClearCustomer_Click(object sender, EventArgs e)
    {
        SetDDls(ddlAgents.SelectedValue, "0", ddlCategory.SelectedValue, ddlItem.SelectedValue);
        ClearJS();
    }
    protected void lbClearCategory_Click(object sender, EventArgs e)
    {
        SetDDls(ddlAgents.SelectedValue, ddlCustomer.SelectedValue, "0", ddlItem.SelectedValue);
        ClearJS();
    }
    protected void lbClearItem_Click(object sender, EventArgs e)
    {
        SetDDls(ddlAgents.SelectedValue, ddlCustomer.SelectedValue, ddlCategory.SelectedValue, "0");
        ClearJS();
    }
    protected void lbClearAll_Click(object sender, EventArgs e)
    {
        SetDDls("0", "0", "0", "0");
        ClearJS();
    }
    private void ClearJS()
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "dd" + DateTime.Now.Ticks.ToString(), "setTimeout('NavFrame(SelID);',200);", true);
    }

    private void SetDDls(string AgentID, string Cust_Key, string FamilyId, string ItemID)
    {
        MPLayoutService.MPLayoutService wr = new MPLayoutService.MPLayoutService();
        DataSet ds = wr.GetSalesDDls(AgentID, Cust_Key, FamilyId, ItemID, ConStrings.DicAllConStrings[SessionProjectName]);

        if (ds != null && ds.Tables.Count > 3)
        {
            ddlAgents.DataSource = ds.Tables[0];
            ddlAgents.DataTextField = "Name";
            ddlAgents.DataValueField = "AgentId";
            ddlAgents.DataBind();

            try
            {
                ddlAgents.SelectedValue = AgentID;
            }
            catch
            {

            }

            ddlCustomer.DataSource = ds.Tables[1];
            ddlCustomer.DataTextField = "CustName";
            ddlCustomer.DataValueField = "Cust_Key";
            ddlCustomer.DataBind();

            try
            {
                ddlCustomer.SelectedValue = Cust_Key;
            }
            catch
            {

            }

            ddlCategory.DataSource = ds.Tables[2];
            ddlCategory.DataTextField = "FamilyName";
            ddlCategory.DataValueField = "FamilyId";
            ddlCategory.DataBind();

            try
            {
                ddlCategory.SelectedValue = FamilyId;
            }
            catch
            {

            }
            ddlItem.DataSource = ds.Tables[3];
            ddlItem.DataTextField = "ItemName";
            ddlItem.DataValueField = "ItemID";
            ddlItem.DataBind();

            try
            {
                ddlItem.SelectedValue = ItemID;
            }
            catch
            {

            }

        }
    }
}