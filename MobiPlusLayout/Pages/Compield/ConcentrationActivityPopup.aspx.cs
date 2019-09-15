using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_ConcentrationActivityPopup : PageBaseCls
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
        Page.Header.DataBind();
    }

    private void InitHeaderCaptionValues()
    {
        hidLanguage.Value = SessionLanguage ?? "he";
        hidShipment_Grid_Header.Value = GetLocalString("Shipment");
        hidDriverName_Grid_Header.Value = GetLocalString("DriverName");
        hidCycle_Grid_Header.Value = GetLocalString("Cycle");
        hidOrder_Grid_Header.Value = GetLocalString("Order");
        hidActualSortOrder_Grid_Header.Value = GetLocalString("ActualSortOrder");
        hidCustomer_Grid_Header.Value = GetLocalString("Customer");
        hidAddress_Grid_Header.Value = GetLocalString("Address");
        hidTravelHours_Grid_Header.Value = GetLocalString("TravelHours");
        hidServiceHours_Grid_Header.Value = GetLocalString("ServiceHours");
        hidOriginalTime_Grid_Header.Value = GetLocalString("OriginalTime");
        hidDeliveryTime_Grid_Header.Value = GetLocalString("DeliveryTime");
        hidAgentReturn_Grid_Header.Value = GetLocalString("AgentReturn");
        hidDeliveries_Grid_Header.Value = GetLocalString("Delivery");
        hidDriverReturn_Grid_Header.Value = GetLocalString("DriverReturn");
        hidDriverStatus_Grid_Header.Value = GetLocalString("DriverStatus");
        hidPallets_Grid_Header.Value = GetLocalString("Pallets");
    }
}