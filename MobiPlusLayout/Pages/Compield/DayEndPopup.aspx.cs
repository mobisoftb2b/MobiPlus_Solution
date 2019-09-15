using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DayEndPopup : PageBaseCls
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitHeaderCaptionValues();
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
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
        hidDriverName_Grid_Header.Value = GetLocalString("DriverName");
        hidShipment_Grid_Header.Value = GetLocalString("Shipment");
        hidDelivery_Grid_Header.Value = GetLocalString("Delivery");
        hidAgentReturn_Grid_Header.Value = GetLocalString("AgentReturn");
        hidDriverReturn_Grid_Header.Value = GetLocalString("DriverReturn");
        hidDriverStatus_Grid_Header.Value = GetLocalString("DriverStatus");
        hidCollectedSurfaces_Grid_Header.Value = GetLocalString("CollectedSurfaces");
        hidOrder_Grid_Header.Value = GetLocalString("Order");
        hidCustomer_Grid_Header.Value = GetLocalString("Customer");
        hidAddress_Grid_Header.Value = GetLocalString("Address");
		hidCycle_Grid_Header.Value = GetLocalString("Cycle");

        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");

    }
}