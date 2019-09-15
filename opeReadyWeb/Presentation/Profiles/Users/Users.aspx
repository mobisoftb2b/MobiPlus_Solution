<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableViewState="false" CodeBehind="Users.aspx.cs" Inherits="PQ.Admin.Presentation.Profiles.Users.Users" %>

<%@ Register Src="UserProfileControls/User2Role.ascx" TagName="User2Role" TagPrefix="uc1" %>
<%@ Register Src="UserProfileControls/User2Job.ascx" TagName="User2Job" TagPrefix="uc2" %>
<%@ Register Src="UserProfileControls/User2Unit.ascx" TagName="User2Unit" TagPrefix="uc3" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/PQWebService.asmx" />
            <asp:ServiceReference Path="~/WebService/UserProfileService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/UserProfile/userProfile.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div id="tabUserProfile" class="jquery_tab_title">
            <ul>
                <li><a href="#divMainScreen">
                    <asp:Label runat="server" ClientIDMode="Static" ID="lblHeaderGeneralInfo" Text="<%$ Resources:Profile, GeneralInfo_headerGeneralInfo %>" />
                </a></li>
                <li><a href="#tabUser2Role">
                    <asp:Label runat="server" ClientIDMode="Static" ID="lblUserProfile_tabUser2Role"
                        Text="<%$ Resources:Profile, UserProfile_tabUser2Role %>" />
                </a></li>
                <li><a href="#tabUser2Unit">
                    <asp:Label runat="server" ClientIDMode="Static" ID="lblUserProfile_tabUser2Unit"
                        Text="<%$ Resources:Profile, UserProfile_tabUser2Unit %>" />
                </a></li>
                <li><a href="#tabUser2Job">
                    <asp:Label runat="server" ClientIDMode="Static" ID="lblUserProfile_tabUser2Job" Text="<%$ Resources:Profile, UserProfile_tabUser2Job %>" />
                </a></li>
            </ul>
            <div class="jquery_tab" id="divMainScreen">
                <div>
                    <div class="emplSearch">
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Profile, GeneralInfo_lblUserName %>" /></label>
                                    <input class="input-medium" type="text" clientidmode="Static" id="txtUserName" runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:Profile, GeneralInfo_lblFirstName %>" /></label>
                                    <input class="input-medium" clientidmode="Static" type="text" id="txtFirstName" runat="server" />
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:Profile, GeneralInfo_lblLastName %>" /></label>
                                    <input class="input-medium" type="text" clientidmode="Static" id="txtLastName" runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblClassificationID" Text="<%$ Resources:Profile, GeneralInfo_lblOrganizationID %>" /></label>
                                    <input class="input-medium" clientidmode="Static" type="text" id="txtOrganizationID"
                                        runat="server" />
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblBirthDay" Text="<%$ Resources:Profile, GeneralInfo_lblEmail %>" /></label>
                                    <input class="input-medium" type="text" clientidmode="Static" id="txtEmail" runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblPhone" Text="<%$ Resources:Profile, GeneralInfo_lblSMSNum %>" /></label>
                                    <input class="input-medium" clientidmode="Static" type="text" id="txtSMSNum" runat="server" />
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <fieldset style="width: 350px">
                                <legend>
                                    <asp:Label runat="server" ID="Label23" Text="<%$ Resources:Profile, GeneralInfo_MailGroup %>" /></legend>
                                <div class="div_wrapper">
                                    <p>
                                        <asp:CheckBox ID="chkIsReadinessMail" Text="<%$ Resources:Profile, GeneralInfo_IsReadinessMail %>"
                                            runat="server" ClientIDMode="Static" /><br />
                                        <asp:CheckBox ID="chkIsAdministrativeMail" Text="<%$ Resources:Profile, GeneralInfo_IsAdministrativeMail %>"
                                            ClientIDMode="Static" runat="server" /><br />
                                        <asp:CheckBox ID="chkIsIncompleteParameterMail" Text="<%$ Resources:Profile, GeneralInfo_IsIncompleteParameterMail %>"
                                            ClientIDMode="Static" runat="server" /><br />
                                        <asp:CheckBox ID="chkIsAssetMngMail" Text="<%$ Resources:Profile, GeneralInfo_IsAssetMngMail %>"
                                            ClientIDMode="Static" runat="server" /><br/>
                                        <asp:CheckBox ID="chkSendComplTaskAlert" Text="<%$ Resources:Profile, GeneralInfo_SendComplTaskAlert %>"
                                            ClientIDMode="Static" runat="server" />&nbsp;<a href="#" style="display: none;" id="btnIsComplianceTaskAlert">select</a><br />
                                            <asp:CheckBox ID="chkSendAdminTaskAlert" Text="<%$ Resources:Profile, GeneralInfo_SendAdminTaskAlert %>"
                                            ClientIDMode="Static" runat="server" />
                                        &nbsp;<a href="#" style="display: none;" id="btnIsAdminTaskAlert">select</a>
                                    </p>
                                </div>
                            </fieldset>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <input id="btnSaveUserData" type="button" class="button" clientidmode="Static" runat="server"
                                        onclick="btnSaveUserData_Click();" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <input id="btnResetPassword" type="button" class="button" onclick="btnResetPassword_Click();"
                                        value="<%$ Resources:Profile, GeneralInfo_btnResetPassword %>" runat="server"
                                        clientidmode="Static" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <input id="btnSendEmail" type="button" class="button" onclick="btnSendEmail_Click();"
                                        value="<%$ Resources:Profile, GeneralInfo_btnSendEmail %>" runat="server" clientidmode="Static" />
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
                </div>
                <div id="divComplianceTaskAlert" style="display: none">
                    <div class="emplSearch" id="divCompliance">
                    </div>
                </div>
                <div id="divAdminTaskAlert" style="display: none">
                    <div class="emplSearch" id="divAdmin">
                    </div>
                </div>
            </div>
            <div class="jquery_tab" id="tabUser2Role">
                <div class="content_block">
                    <uc1:user2role id="User2Role1" runat="server" />
                </div>
            </div>
            <div class="jquery_tab" id="tabUser2Unit">
                <div class="content_block">
                    <uc3:user2unit id="User2Unit1" runat="server" />
                </div>
            </div>
            <div class="jquery_tab" id="tabUser2Job">
                <div class="content_block">
                    <uc2:user2job id="User2Job1" runat="server" />
                </div>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidUserProfile_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:Profile, UserProfile_btnUpdate %>"></asp:Label>
        <asp:Label ID="hidUserProfile_btnAdd" ClientIDMode="Static" runat="server" Text="<%$ Resources:Profile, UserProfile_btnAdd %>"></asp:Label>
        <asp:Label ID="hidResetPasswordSuccessMessage" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserProfile_ResetPasswordSuccessMessage%>"></asp:Label>
        <asp:Label ID="hidUserName_IsExists" ClientIDMode="Static" runat="server" Text="<%$ Resources:Profile, UserName_IsExists %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidMax" runat="server" />
    <script type="text/javascript">
        function $getAllowedUsersInt() {
            return <%= MaxAllowedUsersInt %>;
        };
        function $getQuantity() {
            return <%= Quantity %>;
        };
        $(function () {
            profile.Init();
            $("#txtUserName").focus();            
            $("#tabUserProfile").tabs().tabs("remove", 3);            
            
        });

        function btnSaveUserData_Click() {
            if (profile.RequaredFields()) {
                $("#waitplease").css({ 'display': 'block' });
                profile.SaveUserData();
            }
        }

        $("#txtFirstName").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 500);
        });
        $("#txtLastName").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 500);
        });

        $("#chkSendComplTaskAlert").change(function () {
            if ($(this).attr("checked") != true) { 
                $("#btnIsComplianceTaskAlert").fadeOut();
            } else {
                $("#btnIsComplianceTaskAlert").fadeIn();
            }
        });
        $("#chkSendAdminTaskAlert").change(function () {
            if ($(this).attr("checked") != true) { 
                $("#btnIsAdminTaskAlert").fadeOut();
            } else {
                $("#btnIsAdminTaskAlert").fadeIn();
            }
        });
        $("#txtUserName").blur(function () {
            var uid = getArgs();
            if ($(this).val() != "") {
                if ($getAllowedUsersInt() >= $getQuantity()) {
                    if (profile.CheckUserName($(this).val())) {

                        if (!uid.usid) {
                            $(this).addClass('ui-state-error');
                            $('#btnSaveUserData').attr('disabled', true);
                            RaiseWarningAlert($("#hidUserName_IsExists").text());
                        }
                        return false;
                    }
                    else {
                        $(this).removeClass('ui-state-error', 250);
                        $("#btnSaveUserData").removeAttr("disabled");
                    }
                }
            }
            return false;
        });

        $("#btnIsComplianceTaskAlert").click(function() {
            profile.SaveComplianceTaskAlert();
        });

        $("#btnIsAdminTaskAlert").click(function() {
            profile.SaveAdminTaskAlert();
        });
        function btnResetPassword_Click() {
            var uid = getArgs();
            if (uid.usid) {            
                profile.ResetUserData(uid.usid);
            }
        };

        function btnSendEmail_Click(){
             var uid = getArgs();
            if (uid.usid) {
            $("#waitplease").css({ 'display': 'block' });
                profile.SendUserEmail(uid.usid);
            }
        };
    </script>
</asp:Content>
