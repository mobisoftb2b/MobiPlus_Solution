using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_TrucksAndTrailorInspection : PageBaseCls
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
        hidDriverStatus_Grid_Header.Value = GetLocalString("DriverStatus");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidTaskDate_Grid_Header.Value = GetLocalString("TaskDate");
        hidDistribution_Grid_Header.Value = GetLocalString("Distribution");
        hidCarNumber_Grid_Header.Value = GetLocalString("CarNumber");
        hidFileName_Grid_Header.Value = GetLocalString("FileName");
		hidTaskTime_Grid_Header.Value = GetLocalString("Time");
    }
}