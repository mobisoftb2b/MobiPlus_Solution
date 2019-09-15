using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Pages_Compield_HardwareManagement : PageBaseCls
{
    private HtmlGenericControl link;
    LiteralControl ltr = new LiteralControl();
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitHeaderCaptionValues();
        }
    }

    private void InitHeaderCaptionValues()
    {
        hidMainDivHeight.Value = Request["Height"] ?? "100vh";
        hidDriverID_Grid_Header.Value = GetLocalString("DriverID");
        hidDriverName_Grid_Header.Value = lblDriverName.InnerText = GetLocalString("DriverName");
        hidDeviceID_Grid_Header.Value = lblDeviceDeviceID.InnerText = GetLocalString("DeviceID");
        hidDeviceTypeName_Grid_Header.Value = lblDeviceType.InnerText = GetLocalString("DeviceTypeName");
        hidIsActive_Grid_Header.Value = lblIsActive.InnerText = GetLocalString("IsActive");
        hidComment_Grid_Header.Value = lblComments.InnerText = lblDeviceComments.InnerText = GetLocalString("Comment");
        hidDelete_Grid_Header.Value = GetLocalString("delete");
        hidEdit_Grid_Header.Value = GetLocalString("edit");
        lblDeviceID.InnerText = GetLocalString("hashDevice");
        hidStatus_Grid_Header.Value = lblStatus.InnerText = GetLocalString("status");
        hidAddbuttonCaption.Value = GetLocalString("addButton");
        hidSaveButtonCaption.Value = GetLocalString("saveButton");
        hidUpdateButtonCaption.Value = GetLocalString("updateButton");
        hidCancelButtonCaption.Value = GetLocalString("cancelButton");
        hidConfirmMsg.Value = GetLocalString("confirmMsg");
        hidChangeMesageConfirm.Value = GetLocalString("changeMesageConfirm");
        hidSearchButtonCaption.Value = GetLocalString("Search");
        hidExistingDeviceNumber.Value = GetLocalString("existingDeviceMsg");
        hidTitleAddD4D.Value = GetLocalString("titleAddD4D");
        hidTitleAddDevice.Value = GetLocalString("titleAddDevice");
        hidTitleWarningCaption.Value = GetLocalString("titleWarning");
        hidChangeOwnerButtonCaption.Value = GetLocalString("changeOwner");



        if (SessionLanguage.ToLower() == "he" || SessionLanguage.ToLower() == "hebrew")
        {
            divAddDevices4Driver.Style.Add("direction", "rtl");
            lnkUi.Href = @"~/css/redmond/jquery-ui.css";
            lnkStruct.Href = @"~/css/redmond/jquery-ui.structure.css";
        }
        else
        {
            divAddDevices4Driver.Style.Add("direction", "ltr");
            lnkUi.Href = @"~/css/redmond/jquery-ui.ltr.css";
            lnkStruct.Href = @"~/css/redmond/jquery-ui.structure.ltr.css";
        }
        hidLanguage.Value = SessionLanguage ?? "he";

        using (var service = new MPLayoutService())
        {
            var cid = string.IsNullOrEmpty(Request["CountryID"]) ? GetCountryIDByLanguage() : Request["CountryID"];
            var did = string.IsNullOrEmpty(Request["DistrID"]) ? null : Request["DistrID"];
            ddlDriversList.DataSource = service.GetAgents_SelectAll(SessionUserID, cid, did, ConStrings.DicAllConStrings[SessionProjectName]);
            ddlDriversList.Items.Add(new ListItem(GetLocalString("driverListGreeting"), "0", true));
            ddlDriversList.DataValueField = "AgentId";
            ddlDriversList.DataTextField = "AgentName";
            ddlDriversList.DataBind();

            ddlDeviceID.DataSource = service.DeviceList_SelectAll(cid, null, ConStrings.DicAllConStrings[SessionProjectName]);
            ddlDeviceID.Items.Add(new ListItem(GetLocalString("deviceListGreeting"), "0", true));
            ddlDeviceID.DataValueField = "MP_DeviceID";
            ddlDeviceID.DataTextField = "MP_DeviceID";
            ddlDeviceID.DataBind();


            ddlDeviceType.DataSource = service.DeviceType_Select(ConStrings.DicAllConStrings[SessionProjectName]);
            ddlDeviceType.DataValueField = "MP_DeviceTypeID";
            ddlDeviceType.DataTextField = "MP_DeviceTypeName";
            ddlDeviceType.DataBind();
            ddlDeviceType.Items.Insert(0, new ListItem(GetLocalString("deviceTypeListGreeting"), "0", true));


            ddlCountry.DataSource = service.SalesOrganizations_SelectAll(ConStrings.DicAllConStrings[SessionProjectName]);            
            ddlCountry.DataValueField = "SalesOrganization";
            ddlCountry.DataTextField = "Description";
            ddlCountry.DataBind();
            ddlCountry.Items.Insert(0, new ListItem(GetLocalString("countryListGreeting"), "0", true));

            ddlStatus.DataSource = service.Status_SelectAll(ConStrings.DicAllConStrings[SessionProjectName]);            
            ddlStatus.DataValueField = "MP_StatusID";
            ddlStatus.DataTextField = "MP_StatusName";
            ddlStatus.DataBind();
            ddlStatus.Items.Insert(0, new ListItem(GetLocalString("statusGreeting"), "0", true));


        }

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Header.DataBind();
    }

}