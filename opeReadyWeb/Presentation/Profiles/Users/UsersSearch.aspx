<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="UsersSearch.aspx.cs" Inherits="PQ.Admin.Presentation.Profiles.Users.UsersSearch" %>

<%@ OutputCache NoStore="true" VaryByParam="none" Duration="1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
    <Services>
        <asp:ServiceReference Path="~/WebService/UserProfileService.asmx" />
    </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/UserProfile/userSearch.min.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2 id="h2Empl">
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:Profile, lblUserSettings %>" /></h2>
        <div id="divSearchPanel">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblUserName" Text="<%$ Resources:Profile, UserSearch_lblUserName %>" /></label>
                        <input class="input-medium" clientidmode="Static" type="text" id="txtUserName" runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:Profile, UserSearch_lblFirstName %>" /></label>
                        <input class="input-medium" clientidmode="Static" type="text" id="txtFirstName" runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:Profile, UserSearch_lblLastName %>" /></label>
                        <input class="input-medium" type="text" clientidmode="Static" id="txtLastName" runat="server" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnSearch" type="button" runat="server" value="<%$ Resources:Profile, UserSearch_btnSearch %>"
                            clientidmode="Static" onclick="UserSearch_Click();" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnClear" type="button" runat="server" onclick="Clearence();"
                            value="<%$ Resources:Profile, UserSearch_btnClear %>" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnAddNewEmployee" type="button" runat="server" value="<%$ Resources:Profile, UserSearch_btnAddNewUser %>"
                            clientidmode="Static" onserverclick="btnAddNewEmployee_Click" />
                    </p>
                </div>
            </div>
        </div>
        <h2>
            <asp:Label ID="lblResult" runat="server" Text="<%$ Resources:Profile, UserSearch_lblResult %>" /></h2>
        <div id="divResultPanel" class="grid">
            <table id="tblUserDetailsGrid" cellpadding="0" cellspacing="0">
            </table>
            <div id="pgrUserDetailsGrid">
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidUserSettings_HeaderDefine" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, lblUserSettings %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_UserID" ClientIDMode="Static" runat="server" Text="<%$ Resources:Profile, UserSearch_Grid_UserID %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_User_OrganizationID" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_User_OrganizationID %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_UserName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_UserName %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_FirstName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_FirstName %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_LastName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_LastName %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_UserEmail" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_UserEmail %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_UserSMS_Number" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_UserSMS_Number %>"></asp:Label>
        <asp:Label ID="hidUserSearch_Grid_UserDomaimID" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Profile, UserSearch_Grid_UserDomaimID %>"></asp:Label>
    </div>
    <script type="text/javascript">
        $(function () {
            userSearch.SetUserFirstNameArray();
            userSearch.SetUserLastNameArray();
            userSearch.SetUserNameArray();
        });

        function UserSearch_Click() {
            $("#waitplease").css({ 'display': 'block' });
            $("#tblUserDetailsGrid").GridUnload();
            userSearch.CreateUserCollectionGrid();
        };
        function Clearence() {
            $("#txtUserName, #txtFirstName, #txtLastName").val("");
        }; 

    </script>
</asp:Content>
