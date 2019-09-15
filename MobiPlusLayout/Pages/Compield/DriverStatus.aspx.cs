using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DriverStatus : PageBaseCls
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
        hidDriverID_Grid_Header.Value = GetLocalString("DriverID");
        hidCycle_Grid_Header.Value = GetLocalString("Cycle");
        hidUpdateDate_Grid_Header.Value = GetLocalString("UpdateDate");
        hidLineDownload_Grid_Header.Value = GetLocalString("LineDownload");
        hidWise_Grid_Header.Value = GetLocalString("Wise");
        hidToDiplomat_Grid_Header.Value = GetLocalString("ToDiplomat");
        hidLineEnded_Grid_Header.Value = GetLocalString("LineEnded");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidimgArriveBB_Grid_Header.Value = GetLocalString("imgArriveBB");
        hidimgLeaveBB_Grid_Header.Value = GetLocalString("imgLeaveBB");
	hidTaskDate_Grid_Header.Value = GetLocalString("TaskDate");

    }
}