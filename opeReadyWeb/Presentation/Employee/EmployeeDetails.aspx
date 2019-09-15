<%@ Page Language="C#" Async="true" MasterPageFile="~/Site.Master" CodeBehind="EmployeeDetails.aspx.cs"
    EnableViewState="true" EnableEventValidation="false" ValidateRequest="false"
    Inherits="PQ.Admin.Presentation.Employee.EmployeeDetails" %>

<%@ Register Src="EmploymentUserControls/Attachments.ascx" TagName="Attachments"
    TagPrefix="uc3" %>
<%@ Register Src="EmploymentUserControls/PerfomanceAnalysis.ascx" TagName="PerfomanceAnalysis"
    TagPrefix="uc1" %>
<%@ Register Src="EmploymentUserControls/ComplianceException.ascx" TagName="ComplianceException"
    TagPrefix="uc2" %>
<%@ Register Src="EmploymentUserControls/SubQualificationBarException.ascx" TagName="SubQualificationBarException"
    TagPrefix="uc4" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ClientIDMode="Static" ContentPlaceHolderID="MainContent" ID="cphEmpDetails"
    runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/ReadinessWebService.asmx" />
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
            <asp:ServiceReference Path="~/WebService/EventRecords.asmx" />
            <asp:ServiceReference Path="~/WebService/UnitEvents.asmx" />
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
            <asp:ServiceReference Path="~/WebService/EmployeeSearchWS.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.tmpl.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/employee.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/employmentHistory.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/unitsJobs.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/administrativeTasks.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/personAttachment.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/readinessInfo.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/perfomanceAnalisys.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/eventRecords.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/compException.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/adminException.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.maskedinput-1.3.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.waitforimages.js" />
            <%--<asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.gauges.js" />--%>
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div id="divNameContaner" class="jquery_name_container no-display">
            <div>
                <span id="lblNameContaner" style="font-weight: bold; font-size: 13px"></span>
            </div>
        </div>
        <div id="tabEmployeeProfile" class="jquery_tab_title">
            <ul>
                <li><a href="#divMainScreen">
                    <asp:Label runat="server" ID="lblHeaderGeneralInfo" Text="<%$ Resources:Employee, headerGeneralInfo %>" />
                </a></li>
                <li class="tabEmploymentHistory"><a href="#tabEmploymentHistory">
                    <asp:Label runat="server" ID="lblEmploymentHistory" Text="<%$ Resources:Employee, headerEmploymentHistory %>" />
                </a></li>
                <li class="tabAdminTask"><a href="#tabAdminTask">
                    <asp:Label runat="server" ID="lblAdminTask" Text="<%$ Resources:Employee, headerAdminTask %>" />
                </a></li>
                <li class="tabAttachments"><a href="#tabAttachments">
                    <asp:Label runat="server" ID="lblAttachments" Text="<%$ Resources:Employee, headerAttachments %>" />
                </a></li>
                <li><a href="#tabJobUnit">
                    <asp:Label runat="server" ID="lblheaderJobUnit" Text="<%$ Resources:Employee, headerJobUnit %>" />
                </a></li>
                <li><a href="#tabEventsRecord">
                    <asp:Label runat="server" ID="lblheaderEventsRecord" Text="<%$ Resources:Employee, headerEventsRecord %>" />
                </a></li>
                <li><a href="#tabPerfomanceAnalysis">
                    <asp:Label runat="server" ID="lblPerfomanceAnalysis" Text="<%$ Resources:Employee, tabPerfomanceAnalysis %>" />
                </a></li>
                <li><a href="#tabReadinessInfo">
                    <asp:Label runat="server" ID="lblheaderReadinessInfo" Text="<%$ Resources:Employee, headerReadinessInfo %>" />
                </a></li>
            </ul>
            <div class="jquery_tab" id="divMainScreen">
                <div>
                    <div>
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="width: 145px; vertical-align: top" rowspan="3">
                                    <div class="div_wrapper">
                                        <div id="loader" class="loading" onclick="return CheckPhoto();">
                                        </div>
                                    </div>
                                </td>
                                <td class="clear">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="lblEmployeeID" Text="<%$ Resources:Employee, GeneralInfo_lblEmployeeID %>" /></label>
                                            <input class="input-medium" maxlength="9" type="text" id="txtEmployeeID" runat="server"
                                                clientidmode="Static" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper no-display" style="margin-top: 25px" id="divEmployeeIDIsExist">
                                        <span class="grade">
                                            <asp:Label runat="server" ID="lblEmployeeIDIsExist" Text="<%$ Resources:Employee, GeneralInfo_EmployeeIDIsExist %>" /></span>
                                    </div>
                                    <div class="div_wrapper" id="divUpdatePersonID">
                                        <p>
                                            <input class="button" style="margin-top: 22px;" disabled="True" id="btnUpdatePersonID"
                                                clientidmode="Static" type="button" runat="server" value="<%$ Resources:Employee, btnUpdatePersonID %>" />
                                        </p>
                                    </div>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:Employee, GeneralInfo_lblFirstName %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtFirstNameDetails"
                                                    runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblMiddleName" Text="<%$ Resources:Employee, GeneralInfo_lblMiddleName %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtMiddleNameDetails"
                                                    runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:Employee, GeneralInfo_lblLastName %>" /></label>
                                                <input class="input-medium" type="text" clientidmode="Static" id="txtLastNameDetails"
                                                    runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblClassification" Text="<%$ Resources:Employee, GeneralInfo_lblClassification %>" /></label>
                                                <asp:DropDownList ID="ddlClassification" ViewStateMode="Enabled" EnableViewState="true"
                                                    CssClass="select" runat="server" DataTextField="PersonCategory_Name" DataValueField="PersonCategory_ID" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblClassificationID" Text="<%$ Resources:Employee, GeneralInfo_lblOrganizationID %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtOrganizationID"
                                                    runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblBirthDay" Text="<%$ Resources:Employee, GeneralInfo_lblBirthDay %>" />
                                                    <span id="spanAge" class="grade">(<asp:Label runat="server" ID="lblGeneralInfo_lblAge"
                                                        Text="<%$ Resources:Employee, GeneralInfo_lblAge %>" />
                                                        - <span id="lblAge"></span>) </span>
                                                </label>
                                                <input class="input-medium" type="text" clientidmode="Static" id="txtBirthDay" runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                </td>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblPhone" Text="<%$ Resources:Employee, GeneralInfo_lblPhone %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtPhone" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblCellular" Text="<%$ Resources:Employee, GeneralInfo_lblCellular %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtCellular" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblFax" Text="<%$ Resources:Employee, GeneralInfo_lblFax %>" /></label>
                                                <input class="input-medium" type="text" clientidmode="Static" id="txtFax" runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                </td>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblCity" Text="<%$ Resources:Employee, GeneralInfo_lblCity %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtCity" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblStreet" Text="<%$ Resources:Employee, GeneralInfo_lblStreet %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtStreet" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblApartment" Text="<%$ Resources:Employee, GeneralInfo_lblApartment %>" /></label>
                                                <asp:TextBox CssClass="input-medium" ClientIDMode="Static" ID="txtApartment" runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                </td>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label38" Text="<%$ Resources:Employee, GeneralInfo_txtAddInfo1 %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtAddInfo1" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label39" Text="<%$ Resources:Employee, GeneralInfo_txtAddInfo2 %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtAddInfo2" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label40" Text="<%$ Resources:Employee, GeneralInfo_txtAddInfo3 %>" /></label>
                                                <asp:TextBox CssClass="input-medium" ClientIDMode="Static" ID="txtAddInfo3" runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                </td>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label6" Text="<%$ Resources:Employee, GeneralInfo_lblExtSourceID1 %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtExtSourceID1"
                                                    runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label21" Text="<%$ Resources:Employee, GeneralInfo_lblExtSourceID2 %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtExtSourceID2"
                                                    runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label28" Text="<%$ Resources:Employee, GeneralInfo_lblExtSourceID3 %>" /></label>
                                                <asp:TextBox CssClass="input-medium" ClientIDMode="Static" ID="txtExtSourceID3" runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="clear">
                                </td>
                                <td class="clear">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblEmail" Text="<%$ Resources:Employee, GeneralInfo_lblEmail %>" /></label>
                                                <input class="input-medium" clientidmode="Static" type="text" id="txtEmail" runat="server" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="checkbox" runat="server" class="checkbox" id="chkActiveEmployee" clientidmode="Static"
                                                    style="margin-top: 25px" />
                                                <label class="inline checkboxinline" for="chkActiveEmployee">
                                                    <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblActiveEmployee"
                                                        Text="<%$ Resources:Employee, GeneralInfo_lblActiveEmployee %>" /></label>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="checkbox" runat="server" class="checkbox" id="chkIsReadiness" clientidmode="Static"
                                                    style="margin-top: 25px" />
                                                <label class="inline checkboxinline" for="chkIsReadiness">
                                                    <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblIsReadiness" Text="<%$ Resources:Employee, GeneralInfo_lblIsReadiness %>" />
                                                </label>
                                            </p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblAdditionalInfo" Text="<%$ Resources:Employee, GeneralInfo_lblAdditionalInfo %>" /></label>
                                    <textarea id="txtAdditionalInfoRemarks" style="width: 690px; height: 220px" runat="server"
                                        cols="90" clientidmode="Static" rows="15"></textarea>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <input class="button" id="btnUpdate" clientidmode="Static" type="button" runat="server"
                                        value="<%$ Resources:Employee, btnUpdate %>" onclick="employeePages.CheckRequaredFields();" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <input class="button" id="btnDeleteUser" clientidmode="Static" type="button" runat="server"
                                        value="<%$ Resources:Employee, btnDelete %>" onclick="employeePages.EmployeeDetails_DeleteEmployee();" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <asp:Button CssClass="button" ID="btnGenerateReport" runat="server" Text="<%$ Resources:Reports, ReportsParam_btnGenerateReport %>"
                                        ClientIDMode="Static" OnClick="btnGenerateReport_Click" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <asp:Label runat="server" ID="lblLicenseLimitMessage" Style="color: Red" Visible="false"
                                        Text="<%$ Resources:Resource, LicenseLimitMessage %>" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <!--end content_block-->
                </div>
            </div>
            <!-- end jquery_tab -->
            <%--Employment History tab --%>
            <div class="jquery_tab" id="tabEmploymentHistory" runat="server" clientidmode="Static">
                <div class="content_block">
                    <div id="phEmploymentHistory">
                        <div class="content_block">
                            <div class="emplSearch" id="divEmploymentHistory">
                                <fieldset>
                                    <legend>
                                        <asp:Label runat="server" ID="Label7" Text="<%$ Resources:Employee, EH_pnEmploymentHistory %>"></asp:Label></legend>
                                    <table id="gvEmlpoymentHistory" width="100%" cellpadding="0" cellspacing="0">
                                    </table>
                                    <div id="pagerEmlpoymentHistory" style="width: 100%">
                                    </div>
                                </fieldset>
                            </div>
                        </div>
                        <div id="divEmploymentHistoryEdit" style="overflow-x: hidden; display: none">
                            <h2>
                                <asp:Label ID="lblEmploymentHistoryHeader" runat="server" Text="<%$ Resources:Employee, EH_pnEmploymentHistoryEdit %>" /></h2>
                            <div id="ppEmploymentHistoryEdit">
                                <div class="emplSearch">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblEmployeeStatus" Text="<%$ Resources:Employee, EH_lblEmployeeStatus %>" /></label>
                                                <select id="ddlEmployeeStatus" runat="server" datatextfield="EmploymentHistoryType_Name"
                                                    clientidmode="Static" datavaluefield="EmploymentHistoryType_ID">
                                                </select>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblFromDateEmploymentHistory" Text="<%$ Resources:Employee, EH_lblFromDate %>" /></label>
                                                <span>
                                                    <asp:TextBox CssClass="input-medium PQ_datepicker_input" ID="txtFromDateEmploymentHistory"
                                                        runat="server" ValidationGroup="adFromDateEmploymentHistory" ClientIDMode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="lblToDateEmploymentHistory" Text="<%$ Resources:Employee, EH_lblToDate %>" /></label>
                                                <span>
                                                    <asp:TextBox runat="server" ID="txtToDateEmploymentHistory" CssClass="input-medium PQ_datepicker_input"
                                                        ClientIDMode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label29" Text="<%$ Resources:Employee, EH_lblRemarks %>" /></label>
                                                <span style="width: 700px">
                                                    <textarea id="txtEmploymentHistoryRemarks" cols="85" rows="15" style="width: 570px"></textarea>
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="button" class="button" id="btnAddEmploymentHistory" clientidmode="Static"
                                                    onclick="return RequaredAddEmploymentHistoryFields(this.event);" runat="server"
                                                    value="<%$ Resources:Employee, EH_btnAddEdit %>" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="button" class="button" id="Button1" runat="server" onclick="$('#divEmploymentHistoryEdit').dialog('destroy');"
                                                    value="<%$ Resources:Employee, btnCloseUpload %>" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hidPersonEmploymentHistory_ID" ClientIDMode="Static" runat="server" />
                            </div>
                        </div>
                        <div id="Div1" style="display: none">
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidlblEmployeeStatus" Text="<%$ Resources:Employee, EH_Grid_lblEmployeeStatus %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidlblFromDate" Text="<%$ Resources:Employee, EH_Grid_lblFromDate %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidEH_Grid_lblToDate" Text="<%$ Resources:Employee, EH_Grid_lblToDate %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="lbllblPersonEmploymentHistoryRemarks"
                                Text="<%$ Resources:Employee, lblPersonEmploymentHistoryRemarks %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidbtnEdit" Text="<%$ Resources:Employee, EH_Grid_btnEdit %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidbtnDelete" Text="<%$ Resources:Employee, EH_Grid_btnDelete %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidEH_grtEmployeeStatus" Text="<%$ Resources:Employee, EH_grtEmployeeStatus %>" />
                        </div>
                    </div>
                </div>
                <!--end content_block-->
            </div>
            <!--end $ tab-->
            <%--Administrative Tasks tab --%>
            <div class="jquery_tab" id="tabAdminTask" runat="server" clientidmode="Static">
                <div class="content_block">
                    <div class="content_block" id="divAdminTask">
                        <fieldset>
                            <legend>
                                <asp:Label runat="server" ID="pnEmploymentHistory" Text="<%$ Resources:Employee, pnAdminTasks %>"></asp:Label></legend>
                            <div class="divAdmnTask">
                                <table id="tblAdminTask" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="pgrAdminTask">
                                </div>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" id="btnAdminExceptions" runat="server" class="button" value="<%$Resources:Employee,ER_btnAdminExceptions %>" />
                                    </p>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                    <div id="divAdminExceptionsDetails" style="overflow-x: hidden; display: none">
                        <uc4:SubQualificationBarException ID="SubQualificationBarException1" runat="server" />
                    </div>
                    <div id="divAdminTasksEdit" style="overflow-x: hidden; display: none">
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblSubQualificationType_Names" Text="<%$ Resources:Employee, lblSubQualificationType_Names %>" /></label>
                                    <select id="ddlPersonSubQualification" runat="server" datatextfield="SubQualificationType_Name"
                                        clientidmode="Static" datavaluefield="SubQualificationType_ID">
                                    </select>
                                    <input type="text" id="txtPersonSubQualification" runat="server" clientidmode="Static"
                                        class="input-medium" style="width: 250px" readonly="readonly" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblFromDateAdminTask" Text="<%$ Resources:Employee, AT_lblFromDate %>" /></label>
                                    <span>
                                        <asp:TextBox CssClass="input-medium PQ_datepicker_input" ID="txtAdTaskFromDate" runat="server"
                                            ClientIDMode="Static" />
                                    </span>
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label30" Text="<%$ Resources:Employee, AT_lblRemarks %>" /></label>
                                    <textarea id="editorAdminTaskRemarks" runat="server" clientidmode="Static" cols="90"
                                        style="width: 570px" rows="15"></textarea>
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <input type="button" class="button" id="btnAddAdTask" onclick="return RequaredAdminTaskFields();"
                                        clientidmode="Static" runat="server" value="<%$ Resources:Employee, AT_btnAddEdit %>" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <input type="button" class="button" id="btnCancel" runat="server" onclick="$('#divAdminTasksEdit').dialog('destroy');"
                                        value="<%$ Resources:Employee, AT_btnClose %>" />
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end $ tab-->
            <%--Attachments tab --%>
            <div class="jquery_tab" id="tabAttachments" runat="server" clientidmode="Static">
                <div class="content_block">
                    <uc3:Attachments runat="server" ID="PersonAttachments" />
                </div>
            </div>
            <!--end $ tab-->
            <%--Job & Unit tab --%>
            <div class="jquery_tab" id="tabJobUnit">
                <div class="content_block">
                    <div id="phUnitsJobs">
                        <div class="content_block" id="divUnitJob">
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <fieldset>
                                        <legend>
                                            <asp:Label runat="server" ID="grbCurrActiveJob" Text="<%$ Resources:Employee, grbCurrActiveJob %>" /></legend>
                                        <div class="emplSearch">
                                            <div class="div_wrapper">
                                                <div class="wrapMessages" id="divCurrJob" runat="server" clientidmode="Static">
                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                                <div class="div_wrapper">
                                    <fieldset>
                                        <legend>
                                            <asp:Label runat="server" ID="Label8" Text="<%$ Resources:Employee, grbCurrActiveUnit %>" /></legend>
                                        <div class="emplSearch">
                                            <div class="div_wrapper">
                                                <div class="wrapMessages" id="divCurrUnits" runat="server" clientidmode="Static">
                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                            </div>
                            <div class="emplSearch">
                                <fieldset>
                                    <legend>
                                        <asp:Label runat="server" ID="grbJobHistory" Text="<%$ Resources:Employee, grbJobHistory %>" /></legend>
                                    <div class="grid">
                                        <table id="tblJobHistory" width="100%" cellpadding="0" cellspacing="0">
                                        </table>
                                        <div id="pgrJobHistory" style="width: 100%">
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <div class="emplSearch">
                                <fieldset>
                                    <legend>
                                        <asp:Label runat="server" ID="grbUnitHistory" Text="<%$ Resources:Employee, grbUnitHistory  %>" /></legend>
                                    <div class="grid">
                                        <table id="tblUnitHistory" width="100%" cellpadding="0" cellspacing="0">
                                        </table>
                                        <div id="pgrUnitHistory" style="width: 100%">
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                        </div>
                        <div id="divJobHistoryEdit" style="display: none">
                            <div>
                                <div class="emplSearch">
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label9" Text="<%$ Resources:Employee, JU_lblEmployeeStatus %>" /></label>
                                                <select id="ddlJob" runat="server" datatextfield="Job_Name" datavaluefield="Job_ID"
                                                    class="select-hyper" clientidmode="Static" validate="required:true">
                                                </select>
                                                <input type="text" class="input-large" id="txtJobName" readonly="readonly" style="width: 250px"
                                                    runat="server" clientidmode="Static" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Labe8" Text="<%$ Resources:Employee, JU_lblJobStatus %>" /></label>
                                                <span>
                                                    <select id="ddlJobStatus" runat="server" class="select-hyper" datatextfield="JobStatus_ORGName"
                                                        validate="required:true" datavaluefield="JobStatus_ID" clientidmode="Static">
                                                    </select>
                                                    <input type="text" class="input-medium" id="txtJobStatus" style="width: 250px" readonly="readonly"
                                                        runat="server" clientidmode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label10" Text="<%$ Resources:Employee, JU_JobHistory_lblFromDate %>" /></label>
                                                <span>
                                                    <asp:TextBox CssClass="input-medium PQ_datepicker_input" ID="txtFromDateJobHistory"
                                                        Style="width: 250px" runat="server" ValidationGroup="adFromDateJobHistory" ClientIDMode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label11" Text="<%$ Resources:Employee, JU_JobHstr_lblToDate %>" /></label>
                                                <span>
                                                    <asp:TextBox runat="server" ID="txtToDateJobHistory" CssClass="input-medium PQ_datepicker_input"
                                                        Style="width: 250px" ClientIDMode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="button" class="button" id="btnAddJobHistory" runat="server" value="<%$ Resources:Employee, JU_JobHstr_btnAdd %>"
                                                    onclick="btnAddJobHistory_Click();" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="button" class="button" id="Button2" runat="server" onclick="$('#divJobHistoryEdit').dialog('destroy');"
                                                    value="<%$ Resources:Employee, JU_JobHstr_btnClose %>" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <asp:HiddenField ID="HiddenField1" ClientIDMode="Static" runat="server" />
                            </div>
                        </div>
                        <div id="divUnitHistoryEdit" style="display: none">
                            <div>
                                <div class="emplSearch">
                                    <div class="emplSearch" style="height: 300px">
                                        <div class="div_wrapper UnitHistoryEdit">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label14" Text="<%$ Resources:Employee, JU_UnitHstr_lblUnit %>" /></label>
                                                <asp:TextBox CssClass="combobox-big" ID="ddlUnit" runat="server" ClientIDMode="Static"
                                                    onclick="OnClientPopup_Click();" validate="required:true" />
                                                <div id="treeUnits" style="height: 300px; overflow: auto">
                                                </div>
                                                <input type="text" readonly="readonly" class="input-large" style="display: none"
                                                    id="txtUnit" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label12" Text="<%$ Resources:Employee, JU_UnitHstr_lblFromDate %>" /></label>
                                                <span>
                                                    <asp:TextBox CssClass="input-medium PQ_datepicker_input" ID="txtFromUnitHistory"
                                                        runat="server" ValidationGroup="adFromDateUnitHistory" ClientIDMode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <label class="label">
                                                    <asp:Label runat="server" ID="Label13" Text="<%$ Resources:Employee, JU_UnitHstr_lblToDate %>" /></label>
                                                <span>
                                                    <asp:TextBox runat="server" ID="txtToUnitHistory" CssClass="input-medium PQ_datepicker_input"
                                                        ClientIDMode="Static" />
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch">
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="button" class="button" clientidmode="Static" id="btnUnitHistoryAdd"
                                                    runat="server" value="<%$ Resources:Employee, JU_UnitHstr_btnAdd %>" onclick="btnUnitHistoryAdd_Click();" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="button" class="button" id="btnUnitHistoryClose" runat="server" onclick="$('#divUnitHistoryEdit').dialog('destroy');"
                                                    value="<%$ Resources:Employee, JU_UnitHstr_btnClose %>" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="Div2" style="display: none">
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryFromDate" Text="<%$ Resources:Employee, JU_UnitHstr_JobHstr_lblFromDate %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryUnitHstrFromDate" Text="<%$ Resources:Employee, JU_UnitHstr_UnitHstr_lblFromDate %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryToDate" Text="<%$ Resources:Employee, JU_UnitHstr_JobHstr_lblToDate %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryUnitHstrToDate" Text="<%$ Resources:Employee, JU_UnitHstr_UnitHstr_lblToDate %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidJobName" Text="<%$ Resources:Employee, lblJobName %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidJobStatus" Text="<%$ Resources:Employee, JU_JobHstr_Grid_JobStatus %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryEdit" Text="<%$ Resources:Employee, JU_JobHstr_Grid_btnEdit %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryJobGridDelete" Text="<%$ Resources:Employee, JU_JobHstr_Grid_btnDelete %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryUnitGridEdit" Text="<%$ Resources:Employee, JU_UnitHstr_Grid_btnEdit %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidHistoryUnitGridDelete" Text="<%$ Resources:Employee, JU_UnitHstr_Grid_btnDelete %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidUnitName" Text="<%$ Resources:Employee, lblUnitName %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="lblGrtJobStatus" Text="<%$ Resources:Employee, grtJobStatus %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="lblGrtJobCategory" Text="<%$ Resources:Employee, grtJob %>" />
                            <asp:Label runat="server" ClientIDMode="Static" ID="hidJU_btnAdd_Edit" Text="<%$ Resources:Employee, JU_btnAdd_Edit %>" />
                        </div>
                        <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
                    </div>
                </div>
            </div>
            <!--end $ tab-->
            <%--Events Record tab --%>
            <div class="jquery_tab" id="tabEventsRecord">
                <div class="content_block">
                    <div id="phEventsRecords">
                        <div class="content_block" id="divEventRecords">
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <fieldset>
                                        <legend>
                                            <asp:Label runat="server" ID="Label17" Text="<%$ Resources:Employee, grbEventRecordFilter %>" /></legend>
                                        <div class="emplSearch" id="divFilterArea">
                                            <div class="div_wrapper">
                                                <asp:DropDownList ID="ddlTrainingEventType" ClientIDMode="Static" runat="server"
                                                    CssClass="select" DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID" />
                                            </div>
                                            <div class="div_wrapper">
                                                <input type="button" id="btnTrainingEventTypeFilter" runat="server" class="button"
                                                    onclick="ReloadEventHistoryGrid($('#ddlTrainingEventType').val());" value="<%$ Resources:Employee, ER_lblFilter %>" />
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                                <div class="div_wrapper" style="margin-top: 30px">
                                    <p>
                                        <asp:CheckBox ID="chkIsSimfox" ClientIDMode="Static" runat="server" />
                                        <label class="inline checkboxinline" for="chkIsSimfox">
                                            <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblIsSimfox" Text="<%$ Resources:Employee, ER_lblIsSimfox %>" /></label>
                                    </p>
                                </div>
                            </div>
                            <div class="emplSearch">
                                <fieldset>
                                    <legend>
                                        <asp:Label runat="server" ID="Label18" Text="<%$ Resources:Employee, ER_lblEventHistory %>" /></legend>
                                    <div class="grid" id="divEventHistoryTable">
                                        <table id="tblEventHistory" width="100%" cellpadding="0" cellspacing="0">
                                        </table>
                                        <div id="pagerEventHistory" style="width: 100%">
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" id="btnComplianceException" runat="server" class="button" value="<%$Resources:Employee,ER_btnComplianceException %>" />
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div id="divComplianceExceptionDetails" style="overflow-x: hidden; display: none">
                            <uc2:ComplianceException ID="ComplianceException1" runat="server" />
                        </div>
                        <div id="divTrainingEventForm" style="overflow-x: hidden; display: none">
                            <div id="tabs">
                                <ul>
                                    <li><a href="#tabs-1">
                                        <asp:Label runat="server" ID="lblEventInformation" Text="<%$ Resources:Employee, ER_lblEventInformation %>" /></a></li>
                                    <li><a href="#tabs-2">
                                        <asp:Label runat="server" ID="tabDetailedEvaluation" Text="<%$ Resources:Employee, ER_tabDetailedEvaluation %>" /></a></li>
                                    <li><a href="#tabs-3">
                                        <asp:Label runat="server" ID="Label19" Text="<%$ Resources:Employee, ER_lblEventAttachment %>" /></a></li>
                                </ul>
                                <div id="tabs-1">
                                    <div class="emplSearch">
                                        <div class="emplSearch">
                                            <fieldset>
                                                <legend id="lgdGeneralInfo">
                                                    <asp:Label runat="server" ID="headerGeneralInfo" Text="<%$ Resources:Employee, ER_headerGeneralInfo %>" /></legend>
                                                <div id="divGeneralInfo">
                                                    <div class="emplSearch">
                                                        <div class="div_wrapper" id="divHiddenFields">
                                                            <p>
                                                                <label class="label">
                                                                    <asp:Label runat="server" ID="lblEventDate" Text="<%$ Resources:Employee, ER_lblEventDate %>" /></label>
                                                                <input class="input-medium PQ_datepicker_input" type="text" id="txtEventDate" runat="server"
                                                                    onkeypress="event.keyCode = 0;" clientidmode="Static" />
                                                                <div class="wrapper divTotalScore no-display" id="divTotalScore">
                                                                    <p>
                                                                        <label class="label">
                                                                            <asp:Label runat="server" ID="Label20" Text="<%$ Resources:Employee, ER_lblEventScore %>" /></label>
                                                                        <input class="input-medium wrappered" type="text" id="txtTotalScore" runat="server" />
                                                                    </p>
                                                                </div>
                                                                <div class="wrapper divPerfomanceLevel no-display" id="divPerfomanceLevel">
                                                                    <p>
                                                                        <label class="label">
                                                                            <asp:Label runat="server" ClientIDMode="Static" ID="lblERPerfomanceLevel" Text="<%$ Resources:Employee, ER_lblPerfomanceLabel %>" /><span
                                                                                id="spanPerfomanceLevel" class="grade"></span></label>
                                                                        <select class="select wrappered" id="ddlPerfomanceLevel" datatextfield="ExecutionLevel_ORGName"
                                                                            runat="server" datavaluefield="ExecutionLevel_ID">
                                                                        </select>
                                                                        <input type="text" class="input-medium no-display" id="txtPerfomanceLevel" readonly="readonly" />
                                                                        <span id="spPerfomanceLevelGrade"></span>
                                                                    </p>
                                                                </div>
                                                                <div class="wrapper divQuality no-display" id="divQuality">
                                                                    <p>
                                                                        <label class="label">
                                                                            <asp:Label runat="server" ID="Label22" Text="<%$ Resources:Employee, ER_lblQuantity %>" /></label>
                                                                        <input class="input-medium wrappered" type="text" id="txtQuality" runat="server" />
                                                                    </p>
                                                                </div>
                                                            </p>
                                                        </div>
                                                        <div class="div_wrapper">
                                                            <p>
                                                                <label class="label">
                                                                    <asp:Label runat="server" ID="lblEventType" Text="<%$ Resources:Employee, ER_lblEventType %>" /></label>
                                                                <asp:DropDownList ID="ddlEventType" runat="server" ClientIDMode="Static" CssClass="select"
                                                                    DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID" />
                                                                <input type="text" class="input-medium no-display" id="txtEventType" readonly="readonly" />
                                                            </p>
                                                            <p>
                                                                <label class="label">
                                                                    <asp:Label runat="server" ID="lblPerformanceTime" Text="<%$ Resources:Employee, ER_lblPerformanceTime %>" /></label>
                                                                <asp:TextBox CssClass="input-medium" ID="txtPerformanceTime" ClientIDMode="Static"
                                                                    runat="server" Style="direction: ltr" />
                                                            </p>
                                                        </div>
                                                        <div class="div_wrapper" id="divEmployeeEvaluationTotal">
                                                            <fieldset>
                                                                <legend>
                                                                    <asp:Label runat="server" ID="lblEventSubjects" Text="<%$ Resources:Employee, ER_lblEventSubjects %>" /></legend>
                                                                <div class="emplSearch">
                                                                    <div class="div_wrapper">
                                                                        <div class="wrapMessages" id="divEmployeeEvaluation">
                                                                        </div>
                                                                        <input id="btnAddEventSubject" type="button" clientidmode="Static" class="button"
                                                                            runat="server" value="<%$ Resources:Employee, ER_btnAddSubject %>" onclick="divAddEventSubject_Open();" />
                                                                    </div>
                                                                </div>
                                                            </fieldset>
                                                        </div>
                                                    </div>
                                                    <div class="emplSearch">
                                                        <div class="div_wrapper">
                                                            <p>
                                                                <label class="label">
                                                                    <asp:Label runat="server" ID="lblRemarks" Text="<%$ Resources:Employee, ER_lblRemarks %>" /></label>
                                                                <textarea id="editRemarks" cols="85" rows="15" style="width: 770px; height: 200px"></textarea>
                                                        </div>
                                                    </div>
                                                </div>
                                            </fieldset>
                                        </div>
                                        <div class="emplSearch" id="divManagerArea">
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Employee, ER_lblManagerName %>" />:
                                                    <input type="text" id="txtManagerName" class="input-medium" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:Label runat="server" ID="Label37" Text="<%$ Resources:Employee, ER_lblEventLocation %>" />:
                                                    <input type="text" id="txtEventLocation" class="input-medium" />
                                                </p>
                                            </div>
                                        </div>
                                        <div class="emplSearch" id="divButtonArea">
                                            <div class="div_wrapper">
                                                <p>
                                                    <input class="button" id="btnUpdateEvent" type="button" runat="server" value="<%$ Resources:Employee, ER_DetailedEvaluation_btnUpdate %>"
                                                        onclick="btnUpdate_onclick(true);" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <input class="button" id="btnClose" type="button" runat="server" onclick="$('#divTrainingEventForm').dialog('destroy');"
                                                        value="<%$ Resources:Employee, ER_btnClose %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <input class="button" id="btnEventCopy" type="button" runat="server" value="<%$ Resources:Employee, ER_btnEventCopy %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Employee, ER_lblUpdaterName %>" />
                                                    <label id="lblUpdaterName">
                                                    </label>
                                                    &nbsp;&nbsp;<label id="lblUpdateTime"></label>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="tabs-2">
                                    <div class="emplSearch" id="divDetailedEvaluation">
                                        <fieldset>
                                            <legend>
                                                <asp:Label runat="server" ID="Label23" Text="<%$ Resources:Employee, ER_tabDetailedEvaluationEdit %>" /></legend>
                                            <div style="min-height: 402px">
                                                <table id="tlbDetailedEvaluation" cellpadding="0" cellspacing="0">
                                                </table>
                                                <div id="pgrDetailedEvaluation">
                                                </div>
                                            </div>
                                        </fieldset>
                                        <div class="div_wrapper">
                                            <p>
                                                <input class="button" id="Button4" type="button" runat="server" onclick="$('#divTrainingEventForm').dialog('destroy');"
                                                    value="<%$ Resources:Employee, ER_DetailedEvaluation_btnClose %>" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div id="tabs-3">
                                    <div class="emplSearch">
                                        <fieldset>
                                            <legend>
                                                <asp:Label runat="server" ID="lblEventAttachments" Text="<%$ Resources:Employee, grbAttachments %>" /></legend>
                                            <div style="min-height: 402px">
                                                <table id="tlbEventAttachment" cellpadding="0" cellspacing="0">
                                                </table>
                                                <div id="pgrEventAttachment">
                                                </div>
                                            </div>
                                        </fieldset>
                                        <div class="div_wrapper">
                                            <p>
                                                <input class="button" id="Button5" type="button" runat="server" onclick="$('#divTrainingEventForm').dialog('destroy');"
                                                    value="<%$ Resources:Employee, ER_DetailedEvaluation_Attach_btnClose %>" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <asp:Button runat="server" ID="btnReviewDownloadEventFile" ClientIDMode="Static"
                                                    OnClick="btnReviewDownloadEventFile_Click" CssClass="no-display" />
                                                <asp:HiddenField ID="hidEventAttachmentsID" runat="server" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%--Add event Subjects--%>
                        <div id="divAddEventSubject" style="overflow-x: hidden; display: none">
                            <h2 id="h2">
                                <asp:Label ID="lblEventsSubject" runat="server" Text="<%$ Resources:Employee, ER_EventSubject_lblEventSubjects %>" /></h2>
                            <div class="emplSearch" style="max-height: 220px">
                                <table id="tblEventSubjects" width="100%" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="pgrEventSubjects" style="width: 100%">
                                </div>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" class="button" id="btnEventsSubject" onclick="getSelectedIDs();"
                                            runat="server" value="<%$ Resources:Employee, ER_EventSubject_btnAdd %>" />
                                    </p>
                                </div>
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" class="button" id="Button6" runat="server" onclick="$('#divAddEventSubject').dialog('destroy');"
                                            value="<%$ Resources:Employee, ER_EventSubject_btnClose %>" />
                                    </p>
                                </div>
                            </div>
                        </div>
                        <%--  Add Deatail Evaluation --%>
                        <div id="divAddDetailEvaluation" style="overflow-x: hidden; display: none" runat="server"
                            title="<%$ Resources:Employee, tabDetailedEvaluation %>">
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="lblSubEvaluationType" Text="<%$ Resources:Employee, ER_DetailedEvaluation_lblTaskType %>" /></label>
                                        <select id="ddlSubEvaluationType" runat="server" datatextfield="SubEvaluationType_Name"
                                            datavaluefield="SubEvaluationType_ID" clientidmode="Static" validate="required:true">
                                        </select>
                                        <input type="text" id="txtSubEvaluationTypeEdit" readonly="readonly" class="input-medium no-display" />
                                    </p>
                                </div>
                                <div class="div_wrapper divTotalScore">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="Label24" Text="<%$ Resources:Employee, ER_DetailedEvaluation_lblEventScore %>" /></label>
                                        <asp:TextBox ID="txtDetailEvaluationScore" CssClass="input-medium" ClientIDMode="Static"
                                            runat="server"></asp:TextBox>
                                    </p>
                                </div>
                                <div class="div_wrapper divPerfomanceLevel">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="Label25" Text="<%$ Resources:Employee, ER_DetailedEvaluation_lblPerfomanceLabel %>" /></label>
                                        <select class="select" id="ddlDetEvalPerfomanceLabel" datatextfield="ExecutionLevel_ORGName"
                                            runat="server" datavaluefield="ExecutionLevel_ID">
                                        </select>
                                    </p>
                                </div>
                                <div class="div_wrapper divQuality">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="Label26" Text="<%$ Resources:Employee, ER_DetailedEvaluation_lblQuantity %>" /></label>
                                        <input class="input-medium" type="text" id="txtDetEvalQuantity" runat="server" />
                                    </p>
                                </div>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="Label36" Text="<%$ Resources:Employee, ER_DetailedEvaluation_lblRemarks %>" /></label>
                                        <textarea id="txtSubEvaluation2TrainingEvent_Remarks" style="width: 600px; height: 220px"
                                            runat="server" cols="90" clientidmode="Static" rows="15"></textarea>
                                    </p>
                                </div>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" class="button" id="btnAddDeatilEvaluation" onclick="btnAddDeatilEvaluation_Click();"
                                            runat="server" value="<%$ Resources:Employee, ER_DetailedEvaluation_Edit_btnAdd %>" />
                                    </p>
                                </div>
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" class="button" id="Button7" runat="server" onclick="$('#divAddDetailEvaluation').dialog('destroy');"
                                            value="<%$ Resources:Employee, ER_DetailedEvaluation_Edit_btnClose %>" />
                                    </p>
                                </div>
                            </div>
                        </div>
                        <%--Event Attachments--%>
                        <div id="divEventAttachment" style="display: none">
                            <div class="div_wrapper">
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="lblEventAttachmentName" Text="<%$ Resources:Employee, ER_EventAttach_Edit_lblEvenAttachName %>" /></label>
                                            <span>
                                                <asp:TextBox CssClass="input-large" ID="txtEventAttachmentName" runat="server" ValidationGroup="EventAttachmentName"
                                                    ClientIDMode="Static" />
                                            </span>
                                        </p>
                                    </div>
                                </div>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <label class="inline">
                                            <asp:Label runat="server" ID="lblChooseFile" Text="<%$ Resources:Employee, lblEventAttachmet %>" /></label>
                                    </div>
                                    <div class="div_wrapper">
                                        <label class="inline">
                                            <asp:Label runat="server" ID="lblEventAttachmentFileName" ClientIDMode="Static" /></label>
                                    </div>
                                </div>
                                <div class="emplSearch">
                                    <div class="div_wrapper no-display" id="divErrorMessage">
                                        <p>
                                            <label class="label">
                                                <asp:Label ClientIDMode="Static" runat="server" ID="Label27" Text="<%$ Resources:Employee, ER_EventAttach_Edit_lblUploadErrorMessage %>" /></label>
                                        </p>
                                    </div>
                                </div>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <input type="button" id="btnBrowseEventAttachment" class="button" clientidmode="Static"
                                                runat="server" value="<%$ Resources:Employee, Attachment_btnBrowse %>" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <div style="width: 40px">
                                                &nbsp;</div>
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <input type="button" id="btnEventAttachmentUpload" class="button" clientidmode="Static"
                                                runat="server" value="<%$ Resources:Employee, btnUpload %>" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <input type="button" class="button" id="btnCloseEventAttachment" onclick="$('#divEventAttachment').dialog('destroy');"
                                                runat="server" value="<%$ Resources:Employee, ER_EventAttach_Edit_btnClose %>" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%--Event Copy Person list--%>
                        <div id="divEventCopyEmployeeList" style="display: none">
                            <div>
                                <h2 id="h1">
                                    <asp:Label ID="Label31" runat="server" Text="<%$ Resources:Employee, lblEventRecords_EmployeeSearch %>" /></h2>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="Label32" Text="<%$ Resources:Employee, lblEventRecords_FirstName %>" /></label>
                                            <input class="input-medium" clientidmode="Static" type="text" id="txtFirstName" runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="Label33" Text="<%$ Resources:Employee, lblEventRecords_LastName %>" /></label>
                                            <input class="input-medium" type="text" clientidmode="Static" id="txtLastName" runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper treeUnitsEdit">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="Label34" Text="<%$ Resources:Employee, lblUnit %>" /></label>
                                            <span>
                                                <asp:TextBox CssClass="combobox-big" ID="txtEventCopyUnit" runat="server" ClientIDMode="Static"
                                                    onclick="CreateUnitTree(treeEventCopyUnit);" validate="required:true" />
                                                <div id="treeEventCopyUnit">
                                                </div>
                                            </span>
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="Label35" Text="<%$ Resources:Employee, lblJob %>" /></label>
                                            <asp:DropDownList ID="ddlJobEventCopy" AppendDataBoundItems="true" CssClass="select-hyper"
                                                Width="200px" ClientIDMode="Static" runat="server" DataTextField="Job_Name" DataValueField="Job_ID">
                                                <asp:ListItem Value="0" Text="<%$ Resources:Employee, GroupEvent_grtSelectJobs %>"></asp:ListItem>
                                            </asp:DropDownList>
                                        </p>
                                    </div>
                                    <div class="div_wrapper" id="divSearchEventCopyEmployment" style="margin-top: 23px">
                                        <p>
                                            <asp:Button CssClass="button" ID="btnSearchEmployee" ClientIDMode="Static" runat="server"
                                                Text="<%$ Resources:Employee, btnSearch %>" />
                                        </p>
                                    </div>
                                </div>
                                <div class="emplSearch" id="div6" style="height: 450px; overflow: auto">
                                    <div class="div_wrapper" id="div7">
                                        <table id="tlbEventCopyEmlpoyeeGrid" cellpadding="0" cellspacing="0">
                                        </table>
                                        <div id="pgrEventCopyEmlpoyeeGrid">
                                        </div>
                                    </div>
                                </div>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <input type="button" clientidmode="Static" class="button" id="btnEventCopy_EmployeeAdd"
                                                runat="server" value="<%$ Resources:Employee, btnAdd %>" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <input type="button" class="button" id="btnECClose" runat="server" clientidmode="Static"
                                                value="<%$ Resources:Employee, btnCloseUpload %>" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <asp:HiddenField ID="hidExecutionLevel_ID" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="hidtrainingEventID" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="hidTrainingEventType_ID" ClientIDMode="Static" runat="server" />
                    </div>
                </div>
                <div style="display: none">
                    <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtSubEvaluationType" Text="<%$ Resources:Employee, grtSubEvaluationType %>" />
                </div>
            </div>
            <!--end $ tab-->
            <%--Perfomance Analysis tab --%>
            <div class="jquery_tab" id="tabPerfomanceAnalysis">
                <div class="content_block">
                    <div class="emplSearch">
                        <uc1:PerfomanceAnalysis ID="PerfomanceAnalysis1" runat="server" />
                    </div>
                </div>
            </div>
            <!--end $ tab-->
            <%--Readiness Info tab --%>
            <div class="jquery_tab" id="tabReadinessInfo">
                <div class="content_block">
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <fieldset>
                                <legend>
                                    <asp:Label runat="server" ID="grbReadinessInfo" Text="<%$ Resources:Employee, grbCurrentStatus %>" /></legend>
                                <iframe id="frmGauges" width="230px" style="overflow: hidden" frameborder="0" height="220px"
                                    scrolling="no"></iframe>
                            </fieldset>
                        </div>
                        <div class="div_wrapper">
                            <div class="div_wrapper">
                                <fieldset>
                                    <legend></legend>
                                    <div id="tabsAlerts" style="margin: 0; background: transparent!important">
                                        <ul>
                                            <li><a href="#tabReadinessAcception">
                                                <asp:Label runat="server" ID="Label15" Text="<%$ Resources:Employee, grbReadinessAcceptions %>" /></a></li>
                                            <li><a href="#tabAdminAlert">
                                                <asp:Label runat="server" ID="Label16" Text="<%$ Resources:Employee, grbAdminAlert %>" /></a></li>
                                        </ul>
                                        <div id="tabReadinessAcception" style="margin: 0">
                                            <asp:TextBox ClientIDMode="Static" Height="175" ID="txtReadinessAcception" Rows="3"
                                                runat="server" Style="font-size: 1em" TextMode="MultiLine" Width="350"></asp:TextBox>
                                        </div>
                                        <div id="tabAdminAlert">
                                            <asp:TextBox ID="txtAdminAlert" TextMode="MultiLine" Style="font-size: 1em" Rows="3"
                                                Height="175" Width="350" ClientIDMode="Static" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                        </div>
                    </div>
                    <div class="div_wrapper">
                        <fieldset>
                            <legend>
                                <asp:Label runat="server" ID="Label4" Text="<%$ Resources:Employee, grbReadinessHistory %>" /></legend>
                            <div class="loading charts" id="divChrtReadinessHistory">
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
            <!--end $ tab-->
        </div>
    </div>
    <div id="photoUpload" class="modalPopup" style="display: none">
        <div class="emplSearch">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Employee, lblChoosePhoto %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <label class="inline">
                        <asp:Label runat="server" ID="lblPhotoFileName" ClientIDMode="Static" /></label>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnPhotoBrowse" class="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:Employee, Attachment_btnBrowse %>" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <span style="width: 40px">&nbsp;</span>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnAddPhoto" class="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:Employee, PU_btnUpload %>" /></p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" class="button" id="btnCloseUpload" onclick="ClosePhotoDialog();"
                            runat="server" value="<%$ Resources:Employee, PU_btnCloseUpload %>" /></p>
                </div>
            </div>
        </div>
    </div>
    <div id="divConfirmDeleteEmployee" class="emplSearch" style="display: none">
        <p>
            <label class="label">
                <asp:Label runat="server" ID="Label5" Text="<%$ Resources:Employee, lblConfirmDelete %>" /></label>
            <%--  <label class="label">
                <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Employee, lblDeleteEmployeeConfirmMessage %>" />
            </label>--%>
        </p>
        <%-- <div class="div_wrapper">
            <p>
                <input type="password" class="input-medium" id="txtConfirmDelete" maxlength="6" /></p>
        </div>--%>
    </div>
    <div class="emplSearch" id="divReportViewer" style="direction: ltr">
        <asp:UpdatePanel ID="updShowEmployeeReport" runat="server">
            <ContentTemplate>
                <rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowToolBar="true" Width="100%"
                    Height="100%" OnReportError="ReportViewer1_ReportError">
                    <LocalReport EnableExternalImages="True" EnableHyperlinks="True">
                    </LocalReport>
                </rsweb:ReportViewer>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnGenerateReport" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <asp:HiddenField ID="hidFileUpload" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="xmlTreeDoc" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidEventTypeID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidReportURL" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidEmp" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidUs" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidECUnitID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidTrainingEventTypeID" ClientIDMode="Static" runat="server" />
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventRecordsFromDate" Text="<%$ Resources:Employee, AT_Grid_lblFromDate %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventRecordsToDate" Text="<%$ Resources:Employee, AT_Grid_lblToDate %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventType" Text="<%$ Resources:Employee, AT_Grid_lblEventType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventRecordsEdit" Text="<%$ Resources:Employee, AT_Grid_btnEdit %>" />`
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventRecordsDelete" Text="<%$ Resources:Employee, AT_Grid_btnDelete %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidTrainingEventAttachCount"
            Text="<%$ Resources:Employee, AT_Grid_TrainingEventAttachCount %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidReadinessLabel" Text="<%$ Resources:Employee, AT_Grid_lblPerfomanceLabel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventScore" Text="<%$ Resources:Employee, lblEventScore %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidQuantity" Text="<%$ Resources:Employee, lblQuantity %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidTrainingEventCategoryName"
            Text="<%$ Resources:Employee, lblTrainingEventCategoryName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="headerTrainingEventForm" Text="<%$ Resources:Employee, headerTrainingEventForm %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidSubEvaluationType" Text="<%$ Resources:Employee, ER_DetailedEvaluation_SubEvaluationType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidSubEvaluationType_Incomplete"
            Text="<%$ Resources:Employee, ER_DetailedEvaluation_SubEvaluationType_Incomplete %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidRequirementType" Text="<%$ Resources:Employee, AT_Grid_Header_RequirementType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidPersonAttachName" Text="<%$ Resources:Employee, lblPersonAttachName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidDate" Text="<%$ Resources:Employee, EventAttachment_Grid_lblDate %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidUpdate" Text="<%$ Resources:Employee, btnUpdate %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdd" Text="<%$ Resources:Employee, btnAdd %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidRemarks" Text="<%$ Resources:Employee, lblPersonEmploymentHistoryRemarks %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtSubQualificationType" Text="<%$ Resources:Employee, grtSubQualificationType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEH_btnAddEdit" Text="<%$ Resources:Employee, EH_btnAdd %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAT_btnAdd" Text="<%$ Resources:Employee, AT_btnAdd %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidJU_btnAdd" Text="<%$ Resources:Employee, JU_btnAdd %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidER_btnAddEvent" Text="<%$ Resources:Employee, ER_btnAddEvent %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidER_DetailedEvaluation_Edit_btnAdd"
            Text="<%$ Resources:Employee, ER_DetailedEvaluation_Edit_btnAdd %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidER_DetailedEvaluation_Attach_btnAdd"
            Text="<%$ Resources:Employee, ER_DetailedEvaluation_Attach_btnAdd %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtTrainingEventType" Text="<%$ Resources:Employee, grtTrainingEventType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtPerfomanceLabel" Text="<%$ Resources:Employee, grtPerfomanceLabel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtSubjectEvaluation" Text="<%$ Resources:Employee, PerfomanceAnalysis_GrtSubjectEvaluation %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblGeneral_FIleUploadErrorMessage"
            Text="<%$ Resources:Employee, General_FIleUploadErrorMessage %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrbEventAttachments" Text="<%$ Resources:Employee, grbAttachments %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTitleBarUpload" Text="<%$ Resources:Employee, lblTitleBarUpload %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventCopy_grtSelectJobs" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeEventCopy" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEmployeeID" Text="<%$ Resources:Employee, lblEventRecords_EmployeeID %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidFirstName" Text="<%$ Resources:Employee, lblEventRecords_FirstName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidLastName" Text="<%$ Resources:Employee, lblEventRecords_LastName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidJob" Text="<%$ Resources:Employee, lblJob %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidUnit" Text="<%$ Resources:Employee, lblUnit %>" />
        <asp:Label ID="hidConfirmDeletePerson" ClientIDMode="Static" runat="server" Text="<%$ Resources:Employee, Dialog_lblConfirmDeletePerson %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_btnCloseParentDialog"
            Text="<%$ Resources:Employee, ComplException_btnCloseParentDialog %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_HeaderParentDialog"
            Text="<%$ Resources:Employee, ComplException_HeaderParentDialog %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_btnCloseParentDialog"
            Text="<%$ Resources:Employee, AdminException_btnCloseParentDialog %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_HeaderParentDialog"
            Text="<%$ Resources:Employee, AdminException_HeaderParentDialog %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Grid_TrainingEventType_Name"
            Text="<%$ Resources:Employee, ComplException_Grid_TrainingEventType_Name %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Grid_TrainingEventCategory_Name"
            Text="<%$ Resources:Employee, ComplException_Grid_TrainingEventCategory_Name %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Grid_Edit"
            Text="<%$ Resources:Employee, ComplException_Grid_Edit %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Grid_Delete"
            Text="<%$ Resources:Employee, ComplException_Grid_Delete %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Grid_AddException"
            Text="<%$ Resources:Employee, ComplException_Grid_AddException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrbComplianceException" Text="<%$ Resources:Employee, ComplException_grbComplianceException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Greeting_ddlTrainingEventTypeException"
            Text="<%$ Resources:Employee, ComplException_Greeting_ddlTrainingEventTypeException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_Greeting_ddlTrainingEventCategoryException"
            Text="<%$ Resources:Employee, ComplException_Greeting_ddlTrainingEventCategoryException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_btnAddException"
            Text="<%$ Resources:Employee, ComplException_btnAddException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidComplException_btnCancel"
            Text="<%$ Resources:Employee, ComplException_btnCancel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_Grid_SubQualificationType_Name"
            Text="<%$ Resources:Employee, AdminException_Grid_SubQualificationType_Name %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_Grid_Delete"
            Text="<%$ Resources:Employee, AdminException_Grid_Delete %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_Grid_AddException"
            Text="<%$ Resources:Employee, AdminException_Grid_AddException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="Label41" Text="<%$ Resources:Employee, ComplException_grbComplianceException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_ddlSubQualificationType"
            Text="<%$ Resources:Employee, AdminException_ddlSubQualificationType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_btnAddException"
            Text="<%$ Resources:Employee, AdminException_btnAddException %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAdminException_btnCancel"
            Text="<%$ Resources:Employee, AdminException_btnCancel %>" />
    </div>
    <%-- ReSharper disable AssignToImplicitGlobalInFunctionScope --%>
    <script type="text/javascript">
        var delID, tr_id, _langDir, _trainEvTypeID, _evTypeID, _trainingEventType_ID, dateFormats, speedGauge;
        employeePages.pathSrc = '<%= ResolveClientUrl("~/Presentation/Gauge/PersonGauges.aspx") %>';
        employeePages.employeeDetailsPath = '<%= ResolveClientUrl("~/Presentation/Employee/EmployeeDetails.aspx") %>';
        employeePages.employeeListPage = '<%= ResolveClientUrl("~/Presentation/Employee/EmployeeSearch.aspx") %>';


        $(function () {
            var pid = getArgs();
            $('#tabEmployeeProfile').tabs('length');
            if (!pid.eid)
                $("#tabEmployeeProfile").tabs().tabs("option", "disabled", [1, 2, 3, 4, 5, 6, 7, 8]);
            else
                $("#tabEmployeeProfile").tabs();
            if ($("#tabEmploymentHistory").length == 0)
                $(".tabEmploymentHistory").hide();
            if ($("#tabAdminTask").length == 0)
                $(".tabAdminTask").hide();
            if ($("#tabAttachments").length == 0)
                $(".tabAttachments").hide();

        });

        $(function () {
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            $("#txtBirthDay").datepicker({
                changeYear: true, changeMonth: true, yearRange: '1945:2010', dateFormat: dateFormats, defaultDate: '-50y'
            });

            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);
            $("#tabsAlerts").tabs({ selected: 0 });
            var param = getArgs();
            if (param.eid)
                $("#btnDeleteUser, #btnGenerateReport").removeClass("no-display");
            else
                $("#btnDeleteUser, #btnGenerateReport").addClass("no-display");
            $("#txtPerformanceTime").mask("99:99:99");

            employeePages.LoadEmployeeDetailsGeneral();
            //employeePages.Create_tab('#content', '.jquery_tab_title', '.jquery_tab');
            $("#tabEmployeeProfile").bind("tabsselect", function (event, ui) {
                employeePages.TabPopulateSelector(ui.index);
            });
            employeePages.ReviewGauges();

            $("#txtEmployeeID").ForceNumericOnly();
        });

        $(document).ready(function () {
            $('.imgJobHistory').each(function () {
                if (this.isdeletable == 'True')
                    $(this).addClass('no-display');
            });
           
        });

        $(document).ready(function () {
            eventRecords.SetDeleteEventSubjects();
            $("#tabs").bind("tabsselect", function (event, ui) {
                var selected = ui.tab.hash;
                if (selected) {
                    switch (selected) {
                        case "#tabs-3":
                            $('#tlbEventAttachment').GridUnload();
                            eventRecords.EventAttachmentGrid($('#hidtrainingEventID').val());
                            break;
                    }
                }
            });
        });

        $(document).ready(function () {
            if ($.cookie("userRole") == "6") {
                $("#btnAddEventSubject, #btnUpdateEvent, #btnEventCopy, #btnAddJobHistory, #btnUnitHistoryAdd").hide();
                $("#btnUpdate, #btnDeleteUser, #btnComplianceException, #btnAdminExceptions, #btnAddAdTask, #btnAddEmploymentHistory").hide();

            }
        });


        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("UnitHistoryEdit"))
                $("#treeUnits").hide();
        });
        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeEventCopyUnit").hide();
        });
        $("#txtEmail").blur(function () {
            if ($(this).val().trim() != "") {
                if (!isValidEmailAddress($(this).val())) {
                    $(this).addClass("ui-state-error").focus();
                }
                else {
                    $(this).removeClass('ui-state-error', 500);
                }
            }
            else { $(this).removeClass('ui-state-error', 500); }
            return false;
        });
        //------------------------------------- Change internal status of the control -------------------------------
        $("#txtEmployeeID").change(function () {
            if ($(this).val().trim() != "") {
                $(this).removeClass('ui-state-error', 100);
                $("#btnUpdatePersonID").removeAttr("disabled");
            }
        });
        $("#txtFirstNameDetails").change(function () {
            if ($(this).val().trim() != "") {
                $(this).removeClass('ui-state-error', 100);
            }
        });
        $("#txtLastNameDetails").change(function () {
            if ($(this).val().trim() != "") {
                $(this).removeClass('ui-state-error', 100);
            }
        });
        $("#ddlPersonSubQualification").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#txtAdTaskFromDate").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#ddlEmployeeStatus").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#txtFromDateEmploymentHistory").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#ddlJob").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#ddlJobStatus").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#txtFromDateJobHistory").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 100);
        });
        $("#txtFromUnitHistory").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 100);
        });
        //----------------------------------------------------------------------------

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("dropdown"))
                $(".dropdown dd ul").hide();
            if (!$clicked.hasClass("langBar"))
                $("#ulListTheme").hide();
        });



        $('#ddlEventType').change(function (value) {
            SetVisibilityText($(this).val());
        });

        $('#ddlPerfomanceLevel').change(function (value) {
            var text = " (" + $("#ddlPerfomanceLevel option:selected").attr('rel') + " ) ";
            $('#spanPerfomanceLevel').text(text);
        });

        function kriesi_closeable_divs(element) {
            $(element).each(function () {
                $(this).append('<div class="click_to_close"></div>');
            });
            $(".click_to_close").click(function () {
                $(this).parent().slideUp(200);
            });
        }

        function btnAddEventHistoryItem_Click(e) {
            divTrainingEventForm_Open();
            $('#ddlEventType').val('0').removeClass("no-display");
            $('#txtEventDate,#editRemarks,#txtManagerName,#txtEventLocation,#txtTotalScore,#hidTrainingEventTypeID, #hidtrainingEventID,#txtPerformanceTime').val('');
            $("#txtPerformanceTime").mask("99:99:99");
            $('#txtEventType').addClass("no-display");
            $('#spanPerfomanceLevel').text('');
            $('#ddlPerfomanceLevel').val('0');
            _trainingEventID = null;
            divEmployeeEvaluation.innerHTML = "";
            $("#tabs").tabs({ selected: 0, disabled: [1, 2] });
            eventRecords.AutocompleteLocationField();
            eventRecords.AutocompleteManageField();
            $("#divTrainingEventForm").unblock();
            return false;
        };

        ///-----------------------------------------  Open Dialog Pop-Ups Area -----------------------------------------------------------------
        function divTrainingEventForm_Open() {
            $("#divTrainingEventForm").block({
                css: { border: '0px' },
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            }).dialog({ autoOpen: true, resizable: false, position: 'center', closeOnEscape: true, width: '880px', minHeight: 560, modal: true, zIndex: 50,
                title: $('#headerTrainingEventForm').text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $("#tabs").tabs({ selected: 0 }); //.find(".ui-tabs-nav").sortable({ axis: 'x' });
                    var attachTab = '<%=ConfigurationManager.AppSettings["tabAttachments"] %>';
                    if (!attachTab.bool()) {
                        $("#tabs").tabs("remove", 2);
                    }
                    SetVisibilityText($('#ddlTrainingEventType  option:selected').val());
                    $('#lblUpdaterName, #lblUpdateTime').text("");
                    $("#divGeneralInfo").each(function () {
                        if ($(this).find("input").hasClass("ui-state-error"))
                            $(this).find("input").removeClass('ui-state-error', 100);
                        if ($(this).find("div").hasClass("ui-state-error"))
                            $(this).find("div").removeClass('ui-state-error', 100);
                    });
                }
            });
            return false;
        }

        function divEmploymentHistoryEdit_Open() {
            $("#divEmploymentHistoryEdit").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '630px', modal: true, zIndex: 50,
                title: $('h2 span[id=lblEmploymentHistoryHeader]').text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 100,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                    $("#divEmploymentHistoryEdit").each(function () {
                        if ($(this).find("input").hasClass("ui-state-error"))
                            $(this).find("input").removeClass('ui-state-error', 100);
                        if ($(this).find("select").hasClass("ui-state-error"))
                            $(this).find("select").removeClass('ui-state-error', 100);
                    });
                }
            });
            return false;
        }

        function photoUpload_Open() {
            $("#photoUpload").dialog({ autoOpen: true, closeOnEscape: true, show: 'slow', width: '350px', modal: true,
                title: $('#lblTitleBarUpload').text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $("#btnAddPhoto").removeAttr("disabled", 100);
                    var button = $('#btnPhotoBrowse');
                    var param = getArgs();
                    var upload = new AjaxUpload(button, {
                        action: '<%=ResolveUrl("~/Handlers/photoUpload.ashx?eid=' + param.eid + '") %>',
                        name: 'myfile',
                        autoSubmit: false,
                        onChange: function (file, ext) {
                            if (!checkFileExtension(null, ext)) {
                                $("#btnAddPhoto").attr("disabled", true);
                            }
                            else { $("#btnAddPhoto").removeAttr("disabled", 100); }
                            $("#lblPhotoFileName").block({
                                css: { border: '0px' },
                                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                                message: ''
                            });
                            setTimeout(function () { $("#lblPhotoFileName").unblock().text(file); }, 500);

                        },
                        onSubmit: function () {
                            $("#waitplease").css({ 'display': 'block' });
                            $("#loader").empty().addClass('loading');
                            this.disable();
                        },
                        onComplete: function (file, response) {
                            this.enable();
                            setTimeout(function () {
                                var image = new Image(145, 167);
                                employeePages.LoadPhoto(image);
                                $("#waitplease").css({ 'display': 'none' });
                            }, 500);
                            ClosePhotoDialog();
                            if (response != "") {
                                RaiseWarningAlert($("#lblGeneral_FIleUploadErrorMessage").text());
                            }
                        }
                    });

                    $("#btnAddPhoto").live("click", function () {
                        upload.submit();
                    });
                }
            });
            return false;
        };

        function divAddEventSubject_Open() {
            if (RequaredTrainingEventFields(false)) {
                $("#waitplease").css({ 'display': 'block' });
                var tet = $('#ddlEventType').val() == "0" ? $('#hidTrainingEventTypeID').val() : $('#ddlEventType').val();
                var pid = getArgs();
                if (pid.eid) {
                    var trainingEvent = {
                        TrainingEvent2Person_Score: $('#txtTotalScore').val(),
                        ExecutionLevel_ID: $('#ddlPerfomanceLevel').val(),
                        TrainingEvent2Person_Quantity: $('#txtQuality').val() == "" ? null : $('#txtQuality').val(),
                        TrainingEventRemarks: $("#editRemarks").val(),
                        TrainingEvent_ID: $('#hidtrainingEventID').val() == "" ? null : $('#hidtrainingEventID').val(),
                        TrainingEvent_Date: $('#txtEventDate').val(),
                        TrainingEventType_ID: parseInt(tet),
                        TrainingEvent2Person_Remarks: $('#txtRemarksEvaluation').val(),
                        ExecutionTimeStr: $("#txtPerformanceTime").val(),
                        Person_ID: pid.eid,
                        UserFullName: $("#lnkAdmin").text()
                    };
                    try {
                        PQ.Admin.WebService.EventRecords.TrainingEvent_Save(trainingEvent, function (result) {
                            if (result) {
                                $('#hidtrainingEventID').val(result);
                                $("#divAddEventSubject").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, position: 'center', width: '430px', modal: true, zIndex: 50,
                                    title: $('h2 span[id*=lblEventsSubject]').text(),
                                    open: function () {
                                        $("#waitplease").css({ 'display': 'block' });
                                        $(this).parent().appendTo("form");
                                        $('#tblEventSubjects').GridUnload();
                                        eventRecords.AddEventSubjectsGrid(tet);
                                        $("#tabs").tabs("option", "disabled", false);
                                        eventRecords.ReloadDetailEvaluationGrid(pid.eid, result, trainingEvent.TrainingEventType_ID);
                                    }
                                });
                            }
                            $('#tblEventHistory').GridUnload();
                            _trainEvTypeID = _trainEvTypeID == undefined ? null : _trainEvTypeID;
                            _evTypeID = $('#hidEventTypeID').val() == '' ? null : parseInt($('#hidEventTypeID').val());
                            var isSimfox = $("#chkIsSimfox").attr("checked");
                            CreateAndPopulateEventRecordsGrid(_trainEvTypeID, _evTypeID, isSimfox);
                            $("#waitplease").css({ 'display': 'none' });
                        }, function () {
                            $("#waitplease").css({ 'display': 'none' });
                            $('#divTrainingEventForm').dialog('destroy');
                        });
                    } catch (e) {
                        alert(e.Description);
                    }
                }
            }
            return false;

        };


        function divAddDetailEvaluation_Open() {
            $("#divAddDetailEvaluation").dialog({ autoOpen: true, resizable: false, closeOnEscape: true, position: 'center', width: '677px', modal: true, zIndex: 500,
                open: function () {
                    $(this).parent().appendTo("form");
                    var tet = $('#ddlEventType').val() == "0" ? $('#hidTrainingEventTypeID').val() : $('#ddlEventType').val();
                    SetVisibilityText(tet);
                }
            });
            return false;
        };

        /// divEventAttachment Area. Add any attachment files into database
        function divEventAttachment_Opent() {
            var button = $('#btnBrowseEventAttachment');
            var param = getArgs();
            $("#divEventAttachment").dialog({ autoOpen: true, resizable: false, closeOnEscape: true, position: 'center', width: '400px', modal: true, zIndex: 50,
                title: $('#hidGrbEventAttachments').text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 300,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                    $("#lblEventAttachmentFileName").text("");
                    $("#btnEventAttachmentUpload").removeAttr("disabled", 100);
                    var upload = new AjaxUpload(button, {
                        action: '<%=ResolveUrl("~/Handlers/EventAttachmentFileUpload.ashx?eid=' + param.eid + '") %>',
                        name: 'myfile',
                        autoSubmit: false,
                        onChange: function (file, ext) {
                            if (!checkNotAllowedFileExtension(null, ext)) {
                                $("#btnEventAttachmentUpload").attr("disabled", true);
                            }
                            else { $("#btnEventAttachmentUpload").removeAttr("disabled", 100); }
                            $("#lblEventAttachmentFileName").block({
                                css: { border: '0px' },
                                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                                message: ''
                            });
                            setTimeout(function () { $("#lblEventAttachmentFileName").unblock().text(file); }, 500);
                        },
                        onSubmit: function () {
                            $("#waitplease").css({ 'display': 'block' });
                            this.disable();
                        },
                        onComplete: function () {
                            this.enable();
                            EventAttachmentOnClientUploadComplete();
                            $("#waitplease").css({ 'display': 'none' });
                        }
                    });

                    $("#btnEventAttachmentUpload").live("click", function () {
                        if (RequaredEventAttachFields()) {
                            upload.setData({ "TrainingEventID": $("#hidtrainingEventID").val(), "EventAttachmentName": $("#txtEventAttachmentName").val() });
                            upload.submit();
                        }
                    });
                }
            });
            return false;
        };

        ///divAdminTasksEdit Area. Open Add/Edit form of the Periodical-legal Requirements area
        function divAdminTasksEdit_Open() {
            $("#divAdminTasksEdit").dialog({ autoOpen: true, closeOnEscape: true, position: 'center', modal: true, width: '670px', resizable: false, zIndex: 50,
                title: $("#pnEmploymentHistory").text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 300,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                    $("#divAdminTasksEdit").each(function () {
                        if ($(this).find("input").hasClass("ui-state-error"))
                            $(this).find("input").removeClass('ui-state-error', 500);
                        if ($(this).find("select").hasClass("ui-state-error"))
                            $(this).find("select").removeClass('ui-state-error', 500);
                    });

                }
            });
            return false;
        };

        function divJobHistoryEdit_Open() {
            $("#divJobHistoryEdit").dialog({ autoOpen: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
                title: $("#grbJobHistory").text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 300,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                }
            });
            return false;
        };

        ///divUnitHistoryEdit Area. Open Add/Edit Unit History form
        function divUnitHistoryEdit_Open() {
            $("#divUnitHistoryEdit").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, width: '720px', height: 400, modal: true, zIndex: 50,
                title: $("#grbUnitHistory").text(),
                open: function () {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 300,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                }
            });
            return false;
        }

        ///----------------------------------------- End Open Dialog Pop-Ups Area --------------------------------------------------------------

        function btnAddDetailedEvaluation_Click() {
            $('#ddlSubEvaluationType').val('0').removeClass("no-display");
            $('#txtDetailEvaluationScore').val('');
            $('#ddlDetEvalPerfomanceLabel').val('0');
            $('#txtSubEvaluationTypeEdit').val('').addClass("no-display");
            divAddDetailEvaluation_Open();
            $('#btnAddDeatilEvaluation').val($('#hidAdd').text());
            $('#txtSubEvaluation2TrainingEvent_Remarks').val("");
            return false;
        }




        function clearContents() {
            $("#lblFileName").text("");
            if ($('#txtPersonAttachName').hasClass("ui-state-error"))
                $('#txtPersonAttachName').removeClass('ui-state-error', 500);
        }


        //--------------------------------------- Photo ----------------------------------------------------------------------------//

        function CheckPhoto() {
            var pid = getArgs();
            if (pid.eid) {
                photoUpload_Open();
            }
            return false;
        }

        function Photo_OnClientUploadComplete() {
            $("#imgEmployee").addClass('loading');
            var pid = getArgs();
            if (pid.eid) {
                employeePages.LoadImage("loader", pid.eid);
            }
            $("#waitplease").css({ 'display': 'none' });
            return true;
        }

        function Photo_OnClientUploadError() {
            employeePages.LoadEmployeeDetailsGeneral();
            return false;
        }

        function ClosePhotoDialog() {
            clearContents();
            $("#lblPhotoFileName").text("");
            $('#photoUpload').dialog('destroy');
        }

        function OpenReportViewerPopup() {
            $("#divReportViewer").dialog({ autoOpen: true, bgiframe: true, resizable: true, closeOnEscape: true, width: '800px', height: 700, modal: true, zIndex: 50,
                open: function () {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 100,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                }
            });
            return false;
        }
        //--------------------------------------- End Photo ------------------------------------------------------------------------//
        $("#txtPerformanceTime").change(function () {
            if (CheckTimeValid()) {
                $("#txtPerformanceTime").removeClass('ui-state-error', 200);
            }
            else {
                $("#txtPerformanceTime").addClass('ui-state-error');
                return false;
            }
            return false;
        });


        $("#chkIsSimfox").change(function () {
            var isSimfox = $("#chkIsSimfox").attr("checked");
            if (isSimfox) $("#divFilterArea, #btnTrainingEventTypeFilter").attr("disabled", true);
            else $("#divFilterArea, #btnTrainingEventTypeFilter").attr("disabled", false);
            $('#tblEventHistory').GridUnload();
            CreateAndPopulateEventRecordsGrid(_trainEvTypeID, _evTypeID, isSimfox);

        });


        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
            if (args.get_error()) {
                args.set_errorHandled(true);
            };
        });

        $("#divButtonArea").delegate("#btnEventCopy", "click", function () {
            divEventCopyEmployeeList_Open();
        });


        function divEventCopyEmployeeList_Open() {
            $("#divEventCopyEmployeeList").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, width: '1024px', modal: true, zIndex: 50,
                open: function () {
                    $(this).parent().appendTo("form");
                    eventRecords.SetFirstNameArray();
                    eventRecords.SetLastNameArray();
                    $('#hidATUnitID').val("");
                }
            });
            return false;
        };

        $("#divSearchEventCopyEmployment").delegate("#btnSearchEmployee", "click", function () {
            $("#tlbEventCopyEmlpoyeeGrid").GridUnload();
            eventRecords.GetEventCopyEmlpoyeeGrid();
            return false;
        });

        $("#divEventCopyEmployeeList").delegate("#btnEventCopy_EmployeeAdd", "click", function () {
            var pid = getArgs();
            var tet = $('#ddlEventType').val() == "0" ? $('#hidTrainingEventTypeID').val() : $('#ddlEventType').val();
            if (pid.eid) {
                var prsn = {
                    Person_ID: pid.eid,
                    TrainingEventType_ID: tet,
                    TrainingEvent_Date: $("#txtEventDate").val()
                };
                eventRecords.EventCopySelectedEmployeeIDs(prsn);

            }
            return false;
        });
        $("#divEventCopyEmployeeList").delegate("#btnECClose", "click", function () {
            $("#txtFirstName,#txtLastName,#txtEventCopyUnit,#hidECUnitID").val("");
            $("#ddlJobEventCopy").val("0");
            $("#tlbEventCopyEmlpoyeeGrid").GridUnload();
            $('#divEventCopyEmployeeList').dialog('destroy');
            return false;
        });

        function CreateUnitTree(sender, args) {
            $('#treeEventCopyUnit').toggle(500);
            try {
                eventRecords.CreateUnitTree(args, sender);
            } catch (e) {
                return false;
            }
            return false;
        };

        $("#divUpdatePersonID").delegate("#btnUpdatePersonID", "click", function () {
            var pid = getArgs();
            if (pid.eid) {
                $("#waitplease").css({ 'display': 'block' });
                employeePages.Person_ChangeID(pid.eid, $("#txtEmployeeID").val());
            }
            return false;
        });


        $("#btnComplianceException").live("click", function () {
            employeePages.ComplianceException_OnClick();
        });

        $("#btnAdminExceptions").live("click", function () {
            employeePages.AdminException_OnClick();
        });
        
    </script>
    <%-- ReSharper restore AssignToImplicitGlobalInFunctionScope --%>
</asp:Content>
