<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ThreatTypes.aspx.cs" Inherits="PQ.Admin.Presentation.Op_SemSettings.ThreatTypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="/opeReady/Resources/Styles/jquery.colourPicker.css" rel="stylesheet"
        type="text/css" />
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/OpSemsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OpSemSettings/threatTypes.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.color.utils-0.1.0.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.colourPicker.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:WorkStations, TT_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divThreatTypes">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblThreatTypes" style="width: 100%">
                        </table>
                        <div id="pgrThreatTypes">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divThreatTypesDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label" for="">
                        <asp:Label runat="server" ID="lblStationDesc" Text="<%$ Resources:WorkStations, TT_lblThreatTypesName %>" /></label>
                    <input type="text" class="input-hyper" id="txtThreatTypesName" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblReadinessAlert_lblEventCategory" Text="<%$ Resources:WorkStations, TT_lblThreatCategory %>" /></label>
                    <asp:DropDownList ID="ddlThreatCategory" ClientIDMode="Static" runat="server" CssClass="select-hyper"
                        DataTextField="ThreatCategory_Description" DataValueField="ThreatCategory_ID"
                        AppendDataBoundItems="true">
                        <asp:ListItem Selected="True" Text="<%$ Resources:WorkStations, TT_greetingThreatCategory %>"
                            Value="0" />
                    </asp:DropDownList>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:WorkStations, TT_lblThreatType_Description %>" /></label>
                    <input type="text" class="input-big" id="txtThreatTypeDescription" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:WorkStations, TT_lblThreatType_Color %>" /></label>
                    <div id="divColourPicker">
                        <p>
                            <input type="text" class="input-hyper" id="txtColor" />
                            <select data-msgid="txtColor" name="colours" class="input-big">
                                <option value="ffffff">White</option>
                                <option value="fe0000">Red</option>
                                <option value="00FFFF">Cyan</option>
                                <option value="FFFF00">Yellow</option>
                                <option value="808000">Olive</option>
                                <option value="3166ff">Blue</option>
                                <option value="800080">Purple</option>
                                <option value="009901">Green</option>
                                <option value="00008B">DarkBlue</option>
                            </select>
                        </p>
                    </div>
                </p>
            </div>            
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:WorkStations, TT_lblThreatType_RandomTest %>" /></label>
                    <input type="text" class="input-hyper" id="txtRandomTest" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="checkbox" class="checkbox" id="chkIsDisplay" style="margin-top: 25px"  />
                     <label class="inline checkboxinline" for="chkIsDisplay">
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:WorkStations, TT_lblThreatType_IsDisplay %>" /></label>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="checkbox" class="checkbox" id="chkIsPermited" style="margin-top: 25px" />
                    <label class="inline checkboxinline" for="chkIsPermited">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:WorkStations, TT_lblThreatType_isPermited %>" /></label>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddThreat" runat="server" value="<%$ Resources:WorkStations, TT_btnAddThreat %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:WorkStations, TT_btnClose %>"
                        onclick="$('#divThreatTypesDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidTT_HeaderDefine" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_HeaderDefine %>"></asp:Label>
        <asp:Label ID="hidTT_btnAddThreatType" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_btnAddThreatType %>"></asp:Label>
        <asp:Label ID="hidTT_Grid_ThreatType_Name" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_Grid_ThreatType_Name %>"></asp:Label>
        <asp:Label ID="hidTT_Grid_ThreatCategoriesDesc" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, TT_Grid_ThreatCategoriesDesc %>"></asp:Label>
        <asp:Label ID="hidTT_Grid_Color" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_Grid_Color %>"></asp:Label>
        <asp:Label ID="hidTT_Grid_IsDisplayed" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_Grid_IsDisplayed %>"></asp:Label>
        <asp:Label ID="hidTT_btnThreatTypeUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_btnThreatTypeUpdate %>"></asp:Label>
        <asp:Label ID="hidTT_btnAddThreat" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, TT_btnAddThreat %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidThreatType_ID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);
            threatType.CreateThreatTypeGrid();
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            $('#divColourPicker select').colourPicker({
                ico: '/opeReady/Resources/images/jquery.colourPicker.gif',
                inputElement: "#txtColor"
            });            
            $("#txtValidFrom,#txtValidTo").datepicker({ dateFormat: dateFormats });
        });

        $("#divThreatTypesDetails").delegate("#btnAddThreat", "click",
            function () {
                threatType.DefineThreatType_Save();
            });
    </script>
</asp:Content>
