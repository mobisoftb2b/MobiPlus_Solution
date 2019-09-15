using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DriverStatusPopup : PageBaseCls
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (SessionUserID == "0")
        {
            Response.Redirect("~/Login.aspx");
        }
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
        hidTaskTime_Grid_Header.Value = GetLocalString("TaskTime");
        hidShipmentID_Grid_Header.Value = GetLocalString("ShipmentID");
        hidCust_Grid_Header.Value = GetLocalString("Cust");
        hidCustAddress_Grid_Header.Value = GetLocalString("CustAddress");
        hidTaskID_Grid_Header.Value = GetLocalString("TaskID");
        hidDocNum_Grid_Header.Value = GetLocalString("DocNum");
        hidReportCode_Grid_Header.Value = GetLocalString("ReportCode");
        hidDescription_Grid_Header.Value = GetLocalString("Description");
        hidComment_Grid_Header.Value = GetLocalString("Comment");
        hidLastChange_Grid_Header.Value = GetLocalString("LastChange");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");

    }

}