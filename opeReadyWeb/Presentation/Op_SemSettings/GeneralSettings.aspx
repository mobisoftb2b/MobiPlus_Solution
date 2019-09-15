<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="GeneralSettings.aspx.cs" Inherits="PQ.Admin.Presentation.Op_SemSettings.GeneralSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/OpSemsService.svc"/>
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OpSemSettings/systemConfig.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:WorkStations, GS_MainGreeting %>" /></h2>
        <div class="emplSearch" id="UpdateGeneralSetting">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:WorkStations, GS_lblFilePath %>" /></label>
                            <input type="text" id="txtFilePath" class="input-hyper" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label7" Text="<%$ Resources:WorkStations, GS_lblFilePathBackup %>" /></label>
                            <input type="text" id="txtFilePathBackup" class="input-hyper" />
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label8" Text="<%$ Resources:WorkStations, GS_lblEditedFilePath %>" /></label>
                            <input type="text" id="txtEditedFilePath" class="input-hyper" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label11" Text="<%$ Resources:WorkStations, GS_lblImageThreatRadius %>" /></label>
                            <input type="text" id="txtImageThreatRadius" class="input-hyper" maxlength="5" />
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label2" Text="<%$ Resources:WorkStations, GS_lblImageThreaThickness %>" /></label>
                            <input type="text" id="txtImageThreatThickness" class="input-hyper" maxlength="5" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label4" Text="<%$ Resources:WorkStations, GS_lblAlarmInterval %>" /></label>
                            <input type="text" id="txtAlarmInterval" class="input-hyper" maxlength="5" />
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblSystemLanguage" Text="<%$ Resources:WorkStations, GS_lblImageFormat %>" /></label>
                            <asp:DropDownList runat="server" CssClass="select-hyper" ID="ddlImageFormat" ClientIDMode="Static">
                                <asp:ListItem Text="JPG" Value="JPG" Selected="True" />
                                <asp:ListItem Text="PNG" Value="PNG" />
                                <asp:ListItem Text="BMP" Value="BMP" />
                                <asp:ListItem Text="TIF" Value="TIF" />
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <div class="emplSearch" style="display: none">
                    <div class="div_wrapper">
                        <p>
                            <input type="checkbox" class="checkbox" id="chkFullAirlineName" style="margin-top: 25px" />
                            <label class="inline checkboxinline" for="chkFullAirlineName">
                                <asp:Label runat="server" ID="Label6" Text="<%$ Resources:WorkStations, GS_chkFullAirlineName %>" /></label>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="checkbox" class="checkbox" id="chkIsIATACode" style="margin-top: 25px" />
                            <label class="inline checkboxinline" for="chkIsIATACode">
                                <asp:Label runat="server" ID="Label3" Text="<%$ Resources:WorkStations, GS_chkIsIATACode %>" /></label>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="checkbox" class="checkbox" id="chkIsICAOCode" style="margin-top: 25px" />
                            <label class="inline checkboxinline" for="chkIsICAOCode">
                                <asp:Label runat="server" ID="Label5" Text="<%$ Resources:WorkStations, GS_chkIsICAOCode %>" /></label>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <input type="button" id="btnUpdateGeneralSetting" runat="server" clientidmode="Static"
                                value="<%$ Resources:WorkStations, GS_btnUpdateGeneralSetting %>" class="button" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="button" id="btnArchive" runat="server" clientidmode="Static" value="<%$ Resources:WorkStations, GS_btnArchive %>"
                                class="button" />
                        </p>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidGS_CompleteMessage" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, GS_CompleteMessage %>"></asp:Label>
    </div>
    <script type="text/javascript">

        $(function () {
            systemConfig.LoadSystemConfig();
        });

        $("#UpdateGeneralSetting").delegate("#btnUpdateGeneralSetting", "click",
        function () {
            $("#waitplease").css({ 'display': 'block' });
            var sysConfig = {
                FilePath: $("#txtFilePath").val(),
                ImageFormat: $("#ddlImageFormat").val(),
                ImageThreatRadius: $("#txtImageThreatRadius").val(),
                ImageThreaThickness: $("#txtImageThreatThickness").val(),
                IsFullAirlineName: $("#chkFullAirlineName").attr("checked"),
                AlarmInterval: $("#txtAlarmInterval").val(),
                IsIATACode: $("#chkIsIATACode").attr("checked"),
                IsICAOCode: $("#chkIsICAOCode").attr("checked"),
                FilePathBackup: $("#txtFilePathBackup").val(),
                EditedFilePath: $("#txtEditedFilePath").val()
            };
            systemConfig.UpdateSystemConfig(sysConfig);
        });

        $("#UpdateGeneralSetting").delegate("#btnArchive", "click",
        function () {
            $("#waitplease").css({ 'display': 'block' });
            systemConfig.RunArchive();
        });
    </script>
</asp:Content>
