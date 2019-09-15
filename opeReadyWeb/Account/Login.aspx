<%@ Page Title="opeReady" Language="C#" AutoEventWireup="true" MasterPageFile="~/Account/Login.Master"
    Culture="auto" CodeBehind="Login.aspx.cs" Inherits="PQ.Admin.Account.Login" meta:resourcekey="PageResource1" %>

<asp:Content ContentPlaceHolderID="MainContent" ID="cphLogin" runat="server">
    <div class="loginLogo">
        <h1>
            <a href="/opeReady/Default.aspx">
                <asp:Label runat="server" ID="Label6" Text="<%$ Resources:Resource, lnkLogo %>"></asp:Label></a>
        </h1>
    </div>
    <div class="headLoginGreeting" id="divHeadGreeting" runat="server" clientidmode="Static">
    </div>
    <div id="login">
        <h2 class="loginheading">
            <asp:Label runat="server" ID="Label4" meta:resourcekey="Label4Resource1" /></h2>
        <div class="icon_login ie6fix">
        </div>
        <div class="info_enter">
            <p>
                <asp:Label runat="server" ID="lblName" meta:resourcekey="lblNameResource1" />
                <input class="input-flex" type="text" id="txtLogin" />
            </p>
            <p>
                <asp:Label runat="server" ID="Label1" meta:resourcekey="Label1Resource1" />
                <input class="input-flex" type="password" id="txtPassword" />
            </p>
            <p class="remember">
                <asp:Label runat="server" ID="Label2" CssClass="inline" meta:resourcekey="Label2Resource1" />
                <input type="checkbox" value="1" name="checkbox1" runat="server" id="chkPersist" />
            </p>
            <div class="forgot_pw">
                <a href="#">
                    <asp:Label runat="server" ID="Label3" meta:resourcekey="Label3Resource1" /></a></div>
            <br />
            <div>
                <p>
                    <input type="button" clientidmode="Static" class="button" id="btnLogin" meta:resourcekey="ButtonResource1"
                        runat="server" />
                </p>
            </div>
        </div>
    </div>
    <div id="divError" class="login_message message error">
        <p>
            <asp:Label runat="server" ID="Label5" meta:resourcekey="Label5Resource1" /></p>
    </div>
    <asp:HiddenField ID="hidUserName" ClientIDMode="Static" runat="server" />
    <asp:Button ID="hidLogIn" runat="server" Style="display: none" OnClick="btnLogin_Click"
        ClientIDMode="Static" />
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $('#txtLogin').focus();
        });
        $('#btnLogin').click(function () {
            try {
                $('#divError').css('visibility', 'hidden');
                var user = new PQ.BE.User();
                user.UserName = $('#txtLogin').val();
                user.User_Password = $('#txtPassword').val();
                userAccount.DBAuthentication(user);
            } catch (e) {
            }
        });

        $("#frmLoginForm").keypress(function (e) {
            code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13)
                $("#btnLogin").click();
        });

    </script>
</asp:Content>
