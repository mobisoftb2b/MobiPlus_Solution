using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DriverReport : PageBaseCls
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
        hidDocDate_Grid_Header.Value = GetLocalString("DocDate");
        hidDocStartTime_Grid_Header.Value = GetLocalString("DocStartTime");
        hidReference_Grid_Header.Value = GetLocalString("Reference");
        hidShipmentNumber_Grid_Header.Value = GetLocalString("ShipmentNumber");
        hidCustomerData_Grid_Header.Value = GetLocalString("CustomerData");
        hidItem_Grid_Header.Value = GetLocalString("Item");
        hidOrigCases_Grid_Header.Value = GetLocalString("QTY");
        hidQTY_Grid_Header.Value = GetLocalString("QTY");
        hidReturnResCode_Grid_Header.Value = GetLocalString("ActualKM");
        hidReasonDescription_Grid_Header.Value = GetLocalString("ReasonDescription");


        hidTaskDate_Grid_Header.Value = GetLocalString("TaskDate");
        hidShipmentID_Grid_Header.Value = GetLocalString("ShipmentID");
        hidTaskID_Grid_Header.Value = GetLocalString("TaskID");
        hidDelivery_Grid_Header.Value = GetLocalString("Delivery");
        hidReportDescription_Grid_Header.Value = GetLocalString("ReportDescription");


        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidCaseQuantity_Grid_Header.Value = GetLocalString("TaskDate");
    }
}