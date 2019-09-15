<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="DefaultLanguage.aspx.cs" Inherits="PQ.Admin.Presentation.SystemSettings.DefaultLanguage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/SystemSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/SystemSettings/languageSettings.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:SystemSettings, Language_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblSystemLanguage" Text="<%$ Resources:SystemSettings, Language_lblSystemLanguage %>" /></label>
                            <asp:DropDownList runat="server" CssClass="select" ID="ddlSystemLanguage" DataValueField="LanguageID"
                                DataTextField="Language_CommonName" ClientIDMode="Static">
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblDateFormat" Text="<%$ Resources:SystemSettings, Language_lblDateFormat %>" /></label>
                            <asp:DropDownList runat="server" CssClass="select" ID="ddlDateFormat" DataValueField="DateCode" DataTextField="DateFormat_Name"
                                ClientIDMode="Static">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblClientTitle" Text="<%$ Resources:SystemSettings, Language_lblClientTitle %>" /></label>
                            <asp:TextBox runat="server" ID="txtClientTitle"  CssClass="input-big" ClientIDMode="Static">
                            </asp:TextBox>
                        </p>
                    </div>
                </div>
                  <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:SystemSettings, Language_txtSiteURL %>" /></label>
                            <asp:TextBox runat="server" ID="txtSiteURL"  CssClass="input-big" ClientIDMode="Static">
                            </asp:TextBox>
                        </p>
                    </div>
                </div>
                  <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label2" Text="<%$ Resources:SystemSettings, Language_txtReadSignUrl %>" /></label>
                            <asp:TextBox runat="server" ID="txtReadSignUrl"  CssClass="input-big" ClientIDMode="Static">
                            </asp:TextBox>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <input type="button" id="btnUpdateSystemSetting" runat="server" clientidmode="Static"
                                value="<%$ Resources:SystemSettings, Language_btnUpdateSystemSetting %>" class="button"
                                onclick="btnUpdateSystemSetting_Click();" />
                        </p>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
//            if ($.cookie("lang"))
//                $("#ddlSystemLanguage").val($.cookie("langID"));
            if ($.cookie("dateFormat"))
                $("#ddlDateFormat").val($.cookie("dateFormat"));
        });

        function btnUpdateSystemSetting_Click() {
            $("#waitplease").css({ 'display': 'block' });
            var settings = {
                DateCode: $("#ddlDateFormat").val(),
                LanguageID: $("#ddlSystemLanguage").val(),
                DateFormat_Name: $("#ddlDateFormat option:selected").text(),
                ClientTitle: $("#txtClientTitle").val(),
                ReadSignUrl: $("#txtReadSignUrl").val(),
                SiteURL: $("#txtSiteURL").val()
            };
            language.UpdateSystemSetting(settings);
        };
        

    </script>
</asp:Content>
