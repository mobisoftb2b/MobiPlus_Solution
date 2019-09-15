using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DayEnd : PageBaseCls
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
        hidDelivery_Grid_Header.Value = GetLocalString("Delivery");
        hidAgentReturn_Grid_Header.Value = GetLocalString("AgentReturn");
        hidDriverReturn_Grid_Header.Value = GetLocalString("DriverReturn");
        hidPallets_Grid_Header.Value = GetLocalString("Pallets");
        hidKmPlanned_Grid_Header.Value = GetLocalString("KmPlanned");
        hidActualKM_Grid_Header.Value = GetLocalString("ActualKM");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidTaskDate_Grid_Header.Value = GetLocalString("TaskDate");
		hidCycle_Grid_Header.Value = GetLocalString("Cycle");
    }
}