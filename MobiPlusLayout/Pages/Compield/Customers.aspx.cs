using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_Customers : PageBaseCls
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
        hidTaskDate_Grid_Header.Value = GetLocalString("TaskDate");
        hidShipment_Grid_Header.Value = GetLocalString("Shipment");
        hidDriver_Grid_Header.Value = GetLocalString("DriverName");
        hidCustomer_Grid_Header.Value = GetLocalString("Cust");
        hidTravelHours_Grid_Header.Value = GetLocalString("TravelHours");
        hidServiceHours_Grid_Header.Value = GetLocalString("ServiceHours");
        hidOriginalTime_Grid_Header.Value = GetLocalString("OriginalTime");
        hidDeliveryTime_Grid_Header.Value = GetLocalString("DeliveryTime");
        hidDelivery_Grid_Header.Value = GetLocalString("Delivery");
        hidCustReturn_Grid_Header.Value = GetLocalString("AgentReturn");
        hidDriverReturn_Grid_Header.Value = GetLocalString("DriverReturn");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidCollectedSurfaces_Grid_Header.Value = GetLocalString("Pallets");
        hidCustomerAddress_Grid_Header.Value = GetLocalString("Address");
		hidMission_Grid_Header.Value = GetLocalString("Mission");
		hidQuality_Grid_Header.Value = GetLocalString("Quality");
		hidCycle_Grid_Header.Value = GetLocalString("Cycle");
        hidSortOrder_Grid_Header.Value = GetLocalString("Order");
        hidActualSortOrder_Grid_Header.Value = GetLocalString("ActualSortOrder");
        hidRouteAdherence_Grid_Header.Value = GetLocalString("RouteAdherence");
        hidServiceHourMin_Grid_Header.Value = GetLocalString("ServiceHoursMinutes");
        hidTravelHourMin_Grid_Header.Value = GetLocalString("TravelHoursMinutes");
    }
}