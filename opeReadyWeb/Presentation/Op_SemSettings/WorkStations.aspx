<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="WorkStations.aspx.cs" Inherits="PQ.Admin.Presentation.Op_SemSettings.WorkStations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/OpSemsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OpSemSettings/workStations.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.maskedinput-1.3.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:WorkStations, WS_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divWorkStations">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblWorkStations" style="width: 100%">
                        </table>
                        <div id="pgrWorkStations">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divWorkStationDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label" for="">
                        <asp:Label runat="server" ID="lblStationDesc" Text="<%$ Resources:WorkStations, WS_lblStationDesc %>" /></label>
                    <input type="text" class="input-hyper" id="txtStationDesc" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblReadinessAlert_lblEventCategory" Text="<%$ Resources:WorkStations, WS_lblStationType %>" /></label>
                    <asp:DropDownList ID="ddlStationType" ClientIDMode="Static" runat="server" CssClass="select-hyper"
                        DataTextField="StationType_Desc" DataValueField="StationType_ID" AppendDataBoundItems="true">
                        <asp:ListItem Selected="True" Text="<%$ Resources:WorkStations, WS_greetingStationType %>"
                            Value="-1" />
                    </asp:DropDownList>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:WorkStations, WS_lblStationIP %>" /></label>
                    <input type="text" class="input-hyper" id="txtStationIP" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:WorkStations, WS_lblStationValidFrom %>" /></label>
                    <input type="text" class="input-hyper" id="txtValidFrom" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:WorkStations, WS_lblStationValidTo %>" /></label>
                    <input type="text" class="input-hyper" id="txtValidTo" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddStation" runat="server" value="<%$ Resources:WorkStations, WS_btnAddStation %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:WorkStations, WS_btnClose %>"
                        onclick="$('#divWorkStationDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidWS_HeaderDefine" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, WS_HeaderDefine %>"></asp:Label>
        <asp:Label ID="hidWS_btnAddWorkStation" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, WS_btnAddWorkStation %>"></asp:Label>
        <asp:Label ID="hidWS_Grid_StationDescription" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, WS_Grid_StationDescription %>"></asp:Label>
        <asp:Label ID="hidWS_Grid_StationType" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, WS_Grid_StationType %>"></asp:Label>
        <asp:Label ID="hidWS_Grid_StationIP" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, WS_Grid_StationIP %>"></asp:Label>
        <asp:Label ID="hidWS_btnStationUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, WS_btnStationUpdate %>"></asp:Label>
        <asp:Label ID="hidWS_btnAddStation" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, WS_btnAddStation %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidStation_ID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);
            workStation.CreateWorkStationGrid();
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            //$("#txtStationIP").mask("999.999.999.999");
            $("#txtValidFrom,#txtValidTo").datepicker({ dateFormat: dateFormats });
        });

       
    </script>
</asp:Content>
