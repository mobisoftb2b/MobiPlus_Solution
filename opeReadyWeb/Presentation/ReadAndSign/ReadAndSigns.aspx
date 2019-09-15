<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ReadAndSigns.aspx.cs" Inherits="PQ.Admin.Presentation.ReadAndSign.ReadAndSigns" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/ReadSignsService.svc" />
            <asp:ServiceReference Path="~/WebService/EmployeeSearchWS.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.qtip-1.0.0-rc3.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/moment.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.waitforimages.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/ReadAndSign/readsign.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div>
            <h2>
                <asp:Label runat="server" ClientIDMode="Static" ID="lblReadSign_headerReadSign" Text="<%$ Resources:ReadSign, ReadSign_headerReadSign %>" /></h2>
        </div>
        <div id="divSearchPanel">
            <fieldset>
                <div class="emplSearch">
                    <div class="div_wrapper treeUnitsEdit">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblUnit" Text="<%$ Resources:ReadSign, ReadSign_lblUnit %>" /></label>
                            <span>
                                <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static" />
                                <div id="treeUnits">
                                </div>
                            </span>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="checkbox" runat="server" class="checkbox" checked="True" id="chkIsActive"
                                clientidmode="Static" style="margin-top: 25px" />
                            <label class="inline checkboxinline" for="chkIsActive">
                                <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblIsActive" Text="<%$ Resources:ReadSign, ReadSign_chkIsActive %>" /></label>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            &nbsp;&nbsp;&nbsp;<input class="button" style="margin-top: 20px;" id="btnFilter"
                                type="button" runat="server" value="<%$ Resources:ReadSign, ReadSign_btnFilter %>"
                                clientidmode="Static" />
                        </p>
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <div id="divResultPanel" class="grid">
                    <table id="tblReadSign">
                    </table>
                    <div id="pgrReadSign">
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divReadSignDetails" style="overflow-x: hidden; display: none">
        <fieldset>
            <div class="emplSearch">
                <div class="div_wrapper treeUnitsEdit">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblUnit %>" /></label>
                        <span>
                            <input class="combobox" type="text" id="txtUnit" runat="server" clientidmode="Static" />
                            <div id="treeUnitsSec">
                            </div>
                        </span>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblInitDate  %>" /></label>
                        <input type="text" class="input-medium PQ_datepicker_input" id="txtInitDate" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblExpireDate  %>" /></label>
                        <input type="text" class="input-medium PQ_datepicker_input" id="txtExpireDate" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblTitle  %>" /></label>
                        <input type="text" style="width: 543px" class="input-big" id="txtTitle" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblRemarks  %>" /></label>
                        <textarea style="width: 543px; height: 60px" id="txtRemarks"></textarea>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblUseName  %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <asp:Label ID="lblUseName" runat="server" ClientIDMode="Static" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnAddNewReadSign" runat="server" value="<%$ Resources:ReadSign, ReadSign_btnAddReadSign %>"
                            class="button" clientidmode="Static" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnClose" runat="server" value="<%$ Resources:ReadSign, ReadSign_btnCloseDialog %>"
                            onclick="$('#divReadSignDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </fieldset>
        <fieldset id="accEmployee">
            <legend>
                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblRS2Person %>"
                    ClientIDMode="Static" />
            </legend>
            <div id="divPersons" class="grid">
                <table id="tblPersons">
                </table>
                <div id="pgrPersons">
                </div>
            </div>
        </fieldset>
        <fieldset id="accAttach">
            <legend>
                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:ReadSign, ReadSign_lblAttachment %>"
                    ClientIDMode="Static" /></legend>
            <div id="divRSAttachment" class="grid">
                <table id="tblRSAttachment">
                </table>
                <div id="pgrRSAttachment">
                </div>
            </div>
        </fieldset>
    </div>
    <div id="divFileUpload" class="modalPopup" style="overflow-x: hidden; display: none">
        <div class="div_wrapper">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblDateAttachment" Text="<%$ Resources:ReadSign, lblReadSignAttachName %>" /></label>
                        <span>
                            <asp:TextBox CssClass="input-large" ID="txtReadSignAttachName" runat="server" ClientIDMode="Static" />
                        </span>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <label class="inline">
                        <asp:Label runat="server" ID="lblChooseFile" Text="<%$ Resources:ReadSign, lblReadSignAttachmet %>" /></label>
                </div>
                <div class="div_wrapper">
                    <label class="inline">
                        <asp:Label runat="server" ID="lblFileName" ClientIDMode="Static" /></label>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnBrowse" class="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:ReadSign, ReadSign_btnBrowse %>" />
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
                        <input type="button" id="btnRSUpload" class="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:ReadSign, ReadSign_btnUpload %>" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" class="button" id="btnClosePopUp" onclick="$('#divFileUpload').dialog('destroy');"
                            runat="server" value="<%$ Resources:ReadSign, ReadSign_btnCloseUpload %>" />
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div id="divEmployeeForReadSign" style="display: none">
        <div>
            <h2 id="h2Empl">
                <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:ReadSign, ReadSign_EmployeeSearch %>" /></h2>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:ReadSign, ReadSign_FirstName %>" /></label>
                        <input class="input-medium" clientidmode="Static" type="text" id="txtFirstName" runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:ReadSign, ReadSign_LastName %>" /></label>
                        <input class="input-medium" type="text" clientidmode="Static" id="txtLastName" runat="server" />
                    </p>
                </div>
                <div class="div_wrapper treeUnits">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label4" Text="<%$ Resources:ReadSign, ReadSign_lblUnit %>" /></label>
                        <div>
                            <asp:TextBox CssClass="combobox-big" ID="txtPerson2Unit" runat="server" ClientIDMode="Static"
                                validate="required:true" />
                            <div id="divPerson2Unit">
                            </div>
                        </div>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblJob" Text="<%$ Resources:ReadSign, ReadSign_lblJob %>" /></label>
                        <asp:DropDownList ID="ddlJob" AppendDataBoundItems="true" CssClass="select-hyper"
                            Width="200px" ClientIDMode="Static" runat="server" DataTextField="Job_Name" DataValueField="Job_ID">
                            <asp:ListItem Value="0" Text="<%$ Resources:ReadSign, ReadSign_grtSelectJobs %>"></asp:ListItem>
                        </asp:DropDownList>
                    </p>
                </div>
                <div class="div_wrapper" style="margin-top: 23px">
                    <p>
                        <input type="button" class="button" id="btnSearch" clientidmode="Static" runat="server"
                            value="<%$ Resources:ReadSign, ReadSign_btnSearch %>" />
                    </p>
                </div>
            </div>
            <div class="emplSearch" id="divEmployee2Event" style="height: 450px; overflow: auto">
                <div class="div_wrapper" id="divEmployee">
                    <table id="tlbEmlpoyee">
                    </table>
                    <div id="pgrEmployee">
                    </div>
                </div>
            </div>
            <asp:HiddenField ID="hidPersonID" ClientIDMode="Static" runat="server" />
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" class="button" id="btnAddEmployee" runat="server" clientidmode="Static"
                            value="<%$ Resources:ReadSign, ReadSign_btnAddEmployee %>" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" class="button" id="btnCancel" runat="server" onclick="$('#divEmployeeForReadSign').dialog('close');"
                            value="<%$ Resources:ReadSign, ReadSign_btnClose %>" />
                    </p>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidUnitIDSec" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidReadAndSignID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidReadAndUnitID" ClientIDMode="Static" runat="server" />
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label ID="hidReadSign_Grid_lblInitDate" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:ReadSign, ReadSign_Grid_lblInitDate  %>" />
        <asp:Label ID="hidReadSign_Grid_lblExpirationDate" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_lblExpirationDate %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_lblAssignedEmployees" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_lblAssignedEmployees %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_lblSignedEmployees" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_lblSignedEmployees %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_btnEdit" runat="server" Text="<%$ Resources:ReadSign, ReadSign_btnEdit %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_btnDelete" runat="server" Text="<%$ Resources:ReadSign, ReadSign_btnDelete %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_btnAdd" runat="server" Text="<%$ Resources:ReadSign, ReadSign_btnAdd %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_HeaderDefine" runat="server" Text="<%$ Resources:ReadSign, ReadSign_HeaderDefine %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_btnUpdateReadSign" runat="server" Text="<%$ Resources:ReadSign, ReadSign_btnUpdateReadSign %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_btnAddReadSign" runat="server" Text="<%$ Resources:ReadSign, ReadSign_btnAddReadSign %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_AttachmentsName" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_AttachmentsName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_FirstsName" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_FirstsName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_LastName" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_LastName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_PersonID" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_PersonID %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Grid_SignatureDate" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Grid_SignatureDate %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_grtSelectJobs" runat="server" Text="<%$ Resources:ReadSign, ReadSign_grtSelectJobs %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Search_Grid_FirstsName" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Search_Grid_FirstsName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Search_Grid_LastName" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Search_Grid_LastName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Search_Grid_PersonID" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Search_Grid_PersonID %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Search_Grid_Job_Name" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Search_Grid_Job_Name %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadSign_Search_Grid_Unit_Name" runat="server" Text="<%$ Resources:ReadSign, ReadSign_Search_Grid_Unit_Name %>"
            ClientIDMode="Static" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidReadSign_Header_Attachment"
            Text="<%$ Resources:ReadSign, ReadSign_Header_Attachment %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidReadSign_Grid_Title" Text="<%$ Resources:ReadSign, ReadSign_Grid_Title %>" />
    </div>
</asp:Content>
