using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Usr_AddDeals : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
            DataTable dt = wr.GetDemoPritim(ConStrings.DicAllConStrings[SessionProjectName]);
            if (dt != null)
            {
                ddlPritim.DataSource = dt;
                ddlPritim.DataTextField = "ItemName";
                ddlPritim.DataValueField = "ItemID";
                ddlPritim.DataBind();                
            }
            DataTable dtCust = wr.GetDemoCustomers(ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtCust != null)
            {

                cblCustomersI.DataSource = dtCust;
                cblCustomersI.DataTextField = "CustName";
                cblCustomersI.DataValueField = "CustID";
                cblCustomersI.DataBind();

                cblHachragaCustl.DataSource = dtCust;
                cblHachragaCustl.DataTextField = "CustName";
                cblHachragaCustl.DataValueField = "CustID";
                cblHachragaCustl.DataBind();   
            }

            DataTable dtItems = wr.GetDemoItems(ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtItems != null)
            {

                cblItemsl.DataSource = dtItems;
                cblItemsl.DataTextField = "ItemName";
                cblItemsl.DataValueField = "ItemID";
                cblItemsl.DataBind();

                cblHachragaPrl.DataSource = dtItems;
                cblHachragaPrl.DataTextField = "ItemName";
                cblHachragaPrl.DataValueField = "ItemID";
                cblHachragaPrl.DataBind();
            }
        }
    }
}