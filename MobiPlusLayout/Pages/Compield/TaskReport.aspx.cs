using MobiPlus.BusinessLogic.Tasks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_TaskReport : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitHeaderCaptionValues();
        }
        Page.Header.DataBind();
    }
    private void InitHeaderCaptionValues()
    {
        var cid = string.IsNullOrEmpty(Request["CountryID"]) ? "1000" : Request["CountryID"];
        var did = string.IsNullOrEmpty(Request["DistrID"]) ? "1000" : Request["DistrID"];

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

        var dt = new MPLayoutService().GetAgentsL(SessionUserID, cid, did, ConStrings.DicAllConStrings[SessionProjectName]);
        lstAgents.DataSource = dt;
        lstAgents.DataValueField = "DriverID";
        lstAgents.DataTextField = "DriverName";
        lstAgents.DataBind();
        lstAgents.Focus();

        ddlDriversList.DataSource = dt;
        ddlDriversList.DataValueField = "DriverID";
        ddlDriversList.DataTextField = "DriverName";
        ddlDriversList.DataBind();
        ddlDriversList.Focus();

        var types = new TaskService().Layout_GetTaskTypes(int.Parse(cid), ConStrings.DicAllConStrings[SessionProjectName]);
        ddlTaskType.DataSource = types;
        ddlTaskType.DataValueField = "TaskTypeID";
        ddlTaskType.DataTextField = "TaskType";
        ddlTaskType.DataBind();
        ddlTaskType.Focus();
		ddlTaskType.SelectedValue = types.Rows.Count > 0 ? "5" : "0";

        hidLanguage.Value = SessionLanguage ?? "he";
        hidDriverName_Grid_Header.Value = GetLocalString("DriverName");
        lblDriverName.InnerText = GetLocalString("DriverName");
        hidDriverID_Grid_Header.Value = GetLocalString("DriverID");

        lblCustomer.InnerText = GetLocalString("Customer");
        hidCustomerCode_Grid_Header.Value = GetLocalString("Customer");
        hidTaskID_Grid_Header.Value = GetLocalString("TaskID");
        hidTaskType_Grid_Header.Value = GetLocalString("TaskType");
        lblTaskType.InnerText = GetLocalString("TaskType");
        hidTaskDesc_Grid_Header.Value = GetLocalString("Task");
        lblTaskDesc.InnerText = GetLocalString("Task");
        hidDriverName_Grid_Header.Value = GetLocalString("DriverName");
        hidDateTo_Grid_Header.Value = GetLocalString("ToDate");
		 hidDateFrom_Grid_Header.Value = GetLocalString("FromDate");
        lblToDate.InnerText = GetLocalString("ToDate");
        hidCustAddress_Grid_Header.Value = GetLocalString("CustAddress");
        lblCustomerAddress.InnerText = GetLocalString("CustAddress");
        hidCustCity_Grid_Header.Value = GetLocalString("City");
        lblCustomerCity.InnerText = GetLocalString("City");
        hidFromDate_Grid_Header.Value = GetLocalString("FromDate");
        lblFromDate.InnerText = GetLocalString("FromDate");

        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSearchButtonCaption.Value = GetLocalString("Search");

        hidCustCity_Grid_Header.Value = GetLocalString("City");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSaveButtonCaption.Value = GetLocalString("saveButton");
        hidUpdateButtonCaption.Value = GetLocalString("updateButton");
        hidCancelButtonCaption.Value = GetLocalString("cancelButton");
        hidConfirmMsg.Value = GetLocalString("confirmMsg");
        hidChangeMesageConfirm.Value = GetLocalString("changeMesageConfirm");
        hidSearchButtonCaption.Value = GetLocalString("Search");
    }
}