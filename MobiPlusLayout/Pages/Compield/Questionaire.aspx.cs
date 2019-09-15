﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_Questionaire : PageBaseCls
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
        hidDistribution_Grid_Header.Value = GetLocalString("Distribution");
        hidDriverName_Grid_Header.Value = GetLocalString("Driver");
        hidCustomer_Grid_Header.Value = GetLocalString("Customer");
        hidDocNum_Grid_Header.Value = GetLocalString("QDocNum");
        hidStatus_Grid_Header.Value = GetLocalString("Status");
        hidFileName_Grid_Header.Value = GetLocalString("FileName");
        hidSearchButtonCaption.Value = GetLocalString("Search");
    }
}