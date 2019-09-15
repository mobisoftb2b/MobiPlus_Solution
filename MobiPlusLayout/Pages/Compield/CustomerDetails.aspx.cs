using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_CustomerDetails : PageBaseCls
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack) InitHeaderCaptionValues();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Header.DataBind();
    }

    private void InitHeaderCaptionValues()
    {
        if (SessionLanguage.ToLower() == "he" || SessionLanguage.ToLower() == "hebrew")
        {
            lnkUi.Href = @"~/css/redmond/jquery-ui.css";
            lnkStruct.Href = @"~/css/redmond/jquery-ui.structure.css";
        }
        else
        {
            lnkUi.Href = @"~/css/redmond/jquery-ui.ltr.css";
            lnkStruct.Href = @"~/css/redmond/jquery-ui.structure.ltr.css";
        }

        hidLanguage.Value = SessionLanguage ?? "he";
        hidTaskDescription_Grid_Header.Value = GetLocalString("TaskDescription");
        hidShipment_Grid_Header.Value = GetLocalString("Shipment");
        hidDriver_Grid_Header.Value = GetLocalString("DriverName");
        hidCustomer_Grid_Header.Value = GetLocalString("Cust");
        hidDeliveryNum_Grid_Header.Value = GetLocalString("DeliveryNum");
        hidComment_Grid_Header.Value = GetLocalString("Comment");
        hidDescription_Grid_Header.Value = GetLocalString("Description");
        hidDelivery_Grid_Header.Value = GetLocalString("Delivery");
	hidCustomerAddress_Grid_Header.Value = GetLocalString("CustAddress");
    }

}