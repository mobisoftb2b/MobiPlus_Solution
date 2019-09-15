<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AirlineCompanies.aspx.cs" Inherits="PQ.Admin.Presentation.Op_SemSettings.AirlineCompanies" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/OpSemsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OpSemSettings/airCompany.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:WorkStations, APC_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divAirplaneCompanys">
                    <div class="div_wrapper">
                        <table id="tblAirplaneCompanies" style="width: 100%">
                        </table>
                        <div id="pgrAirplaneCompanies">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divAirlineCompanyDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label" for="">
                        <asp:Label runat="server" ID="lblStationDesc" Text="<%$ Resources:WorkStations, APC_lblAirlineCompanyShortName %>" /></label>
                    <input type="text" class="input-hyper" id="txtAirlineCompanyName" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <label class="label" for="">
                            <asp:Label runat="server" ID="Label2" Text="<%$ Resources:WorkStations, APC_lblAirlineCompanyLongName %>" /></label>
                        <input type="text" class="input-hyper" id="txtAirlineCompanyLongName" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:WorkStations, APC_lblAirlineCompany_IATACode %>" /></label>
                    <input type="text" class="input-hyper" id="txtIATACode" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:WorkStations, APC_lblAirlineCompany_ICAOCode %>" /></label>
                    <input type="text" class="input-hyper" id="txtICAOCode" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="checkbox" class="checkbox" id="chkIsDisplay" />
                    <label class="inline checkboxinline" for="chkIsDisplay">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:WorkStations, APC_lblAirlineCompany_IsDisplay %>" /></label>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div id="uploadLogo" style="display: none">
                <div class="div_wrapper">
                    <p>
                        <div class="div_wrapper">
                            <div id="loader" style="width: 80px; height: 70px; padding: 5px" class="loading">
                            </div>
                        </div>
                        <label class="label">
                            <asp:Label runat="server" ID="lblLogoFileName" Text="<%$ Resources:WorkStations, APC_lblAirlineCompany_LogoFileName %>" /></label>
                        <span>
                            <asp:TextBox CssClass="input-hyper" ID="txtLogo" runat="server" ClientIDMode="Static" />
                            <input type="button" id="btnBrowse" class="button" clientidmode="Static" runat="server"
                                value="<%$ Resources:WorkStations, APC_btnBrowse %>" />
                        </span>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnUpload" class="button" style="margin-top: 22px;" disabled="disabled"
                            clientidmode="Static" runat="server" value="<%$ Resources:WorkStations, APC_btnUpload %>" />
                    </p>
                </div>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddAirlineCompany" runat="server" value="<%$ Resources:WorkStations, APC_btnAddAirlineCompany %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:WorkStations, APC_btnClose %>"
                        onclick="$('#divAirlineCompanyDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidAPC_HeaderDefine" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, APC_HeaderDefine %>"></asp:Label>
        <asp:Label ID="hidAPC_btnAddAirlineCompanyUpper" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_btnAddAirlineCompanyUpper %>"></asp:Label>
        <asp:Label ID="hidAPC_Grid_AirlineCompany_ShortName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_Grid_AirlineCompany_ShortName %>"></asp:Label>
        <asp:Label ID="hidAPC_Grid_AirlineCompany_LongName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_Grid_AirlineCompany_LongName %>"></asp:Label>
        <asp:Label ID="hidAPC_Grid_AirlineCompany_IATACode" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_Grid_AirlineCompany_IATACode %>"></asp:Label>
        <asp:Label ID="hidAPC_Grid_AirlineCompany_ICAOCode" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_Grid_AirlineCompany_ICAOCode %>"></asp:Label>
        <asp:Label ID="hidAPC_Grid_AirlineCompany_isDisplayed" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_Grid_AirlineCompany_isDisplayed%>"></asp:Label>
        <asp:Label ID="hidAPC_btnAirlineCompanyUpdate" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_btnAirlineCompanyUpdate %>"></asp:Label>
        <asp:Label ID="hidAPC_btnAddAirlineCompany" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, APC_btnAddAirlineCompany %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidAirlineCompany_ID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);

            airplane.CreateAirplaneCompanyGrid(null);
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }

        });

        $("#divAirlineCompanyDetails").delegate("#btnAddAirlineCompany", "click",
        function () {
            airplane.DefineAirplaneCompany_Save();
        });

       


       
    </script>
</asp:Content>
