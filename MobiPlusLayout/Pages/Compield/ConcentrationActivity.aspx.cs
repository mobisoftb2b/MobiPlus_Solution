using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_ConcentrationActivity : PageBaseCls
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
        hidDriverID_Grid_Header.Value = GetLocalString("DriverID");
        hidShipment_Grid_Header.Value = GetLocalString("Shipment");
        hidCycle_Grid_Header.Value = GetLocalString("Cycle");
        hidVisit_Grid_Header.Value = GetLocalString("Visit");
        hidDelivery_Grid_Header.Value = GetLocalString("Delivery");
        hidNotVisited_Grid_Header.Value = GetLocalString("NotVisited");
        hidNotFullDelivery_Grid_Header.Value = GetLocalString("NotFullDelivery");
        hidAgentReturn_Grid_Header.Value = GetLocalString("AgentReturn");
        hidKPI_Grid_Header.Value =  GetLocalString("KPI");
        hidDriverReturn_Grid_Header.Value = GetLocalString("DriverReturn");
        hidDriverStatus_Grid_Header.Value = GetLocalString("DriverStatus");
        hidProgress_Grid_Header.Value = GetLocalString("Progress");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidTaskDate_Grid_Header.Value = GetLocalString("TaskDate");
        hidTT_Grid_Header.Value = GetLocalString("TT");

    }

  
}