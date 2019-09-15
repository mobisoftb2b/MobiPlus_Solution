<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomersToAgents.aspx.cs"
    Inherits="Pages_Compield_CustomersToAgents" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>לקוחות לסוכנים</title>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css">
    <script src="../../js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="../../js/main.js"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
    <script type="text/javascript" src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/json2.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="~/css/report.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/Main.css" />
    <script type="text/javascript" src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function closeWin(cls) {
            var top = 100;
            $("." + cls).css({ top: top })
                    .animate({ "top": "-500" }, "high");
            $("#dBody1").unblock();
        }
        var IsAdd = false;
    </script>
    <style type="text/css">
        #ui-datepicker-div
        {
            background-color:#F0F0F0 !important;
        }
    </style>
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div id="dBody1">
        <center>
            <div id="dMSG" style="margin-top: 10px;">
                <asp:Label runat="server" ID="lblMSG" Height="25px" Font-Bold="true" ForeColor="Red"
                    Font-Size="14px" Width="300px"></asp:Label>
            </div>
            <div>
                <div class="dConCust bgCust" style="max-width: 820px; -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
                    -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65); box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);">
                    <div class="dConCust agent">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td>
                                    <asp:CheckBox runat="server" ID="cbAll" onchange="SetAllCb();" />
                                </td>
                                <td class="">
                                    &nbsp;
                                </td>
                                <td class="CustAgentHead">
                                    סוכן:
                                </td>
                                <td>
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList runat="server" ID="ddlAgents" Width="150px" AutoPostBack="true"
                                                onchange="SetGrid();" OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td>
                                    תאריך ביקור:
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="txtRouteDate" Width="74px" onclick="SetGrid();"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="dConCust">
                        <table id="jQGrid">
                        </table>
                        <div id="jQGridPager">
                        </div>
                    </div>
                </div>
                <div style="text-align: center; margin-top: 58px; float: right; width: 54px; padding-right: 7px;
                    padding-left: 2px;">&nbsp;
                    <input type="button" value="העבר ->" class="btn MSBtn" onclick="OpenMoveWin();" style="width: 70px;" />
                </div>
                <div class="dConCust bgCustLeft" style="max-width: 856px; -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
                    -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65); box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);">
                    <div class="dConCust agent" style="width: 100%; height: 27px; text-align: left;">
                        <span style="color: White; text-decoration: underline; cursor: pointer;" onclick="ShowDeleteForm();">
                            מחק</span> &nbsp;
                    </div>
                    <div class="dConCust">
                        <div class="dConCust">
                            <table id="jQGridTo">
                            </table>
                            <div id="jQGridPagerTo">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </center>
        <div style="clear: both;">
        </div>
    </div>
    <div class="dMoveBox">
        <center>
            <div class="dMoveBoxin">
                <div class="EditWinX">
                    <img alt="Close" src="../../img/X.png" class="imngX" onclick="closeWin('dMoveBox');" />
                </div>
                <div class="dMoveHead">
                    העבר לקוחות לסוכן
                </div>
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="CustAgentHead">
                            סוכן יעד:
                        </td>
                        <td>
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList runat="server" ID="ddlToAgents" Width="150px" AutoPostBack="true"
                                        OnSelectedIndexChanged="ddlToAgents_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            מתאריך:
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="dtFrom" Width="146px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            עד תאריך:
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="dtTo" Width="146px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div style="text-align: center; margin-top: 10px;">
                    <asp:UpdatePanel ID="UpdatePanel22" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <input type="button" value="העבר" class="btn btnMove" id="btnMove" onclick="MoveItems();" />
                            <span style="display: none;">
                                <asp:Button runat="server" ID="btnRefresh" Text="העבר" CssClass="btn btnMove" OnClick="btnRefresh_Click" />
                                <asp:HiddenField runat="server" ID="hdnCbsChecked" />
                            </span>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </center>
    </div>
    <div id="dLoading" class="loadingCust">
        <center>
            <img alt="" src="../../Img/loading1.gif" width="64px" />
            <br />
            <br />
            טוען נתונים...
        </center>
    </div>
    <script type="text/javascript">
        var arrData = [];
        function MoveItems() {

            if ($('#<%=ddlToAgents.ClientID %>').val() != "0") {

                $('#dLoading').css("display", "block");
                CountCallAjax = 0;
                CountReturnAjax = 0;
                closeWin('dMoveBox');
                isAllOK = true;
                var isOK = true;
                var customeres = '[';
                var counter = 0;
                var data = $('#jQGrid').jqGrid('getGridParam', 'data');
                var coiunter2 = 0;
                var tmp;
                var t = 0;
               //debugger;
                $('#jQGrid tr').each(function () {
                    if ($('#cb_' + coiunter2).length > 0 && $('#cb_' + coiunter2)[0].checked && data[coiunter2 - 1].CustID) {
                        customeres += "{ \"CustID\": " + data[coiunter2 - 1].CustID + "},";
                        t++;
                    }
                    if (t >= 50) {
                        if (counter > 0 && customeres.length > 0)
                            customeres = allChecked.substring(0, allChecked.length - 1);
                        customeres += ']';
                        CountCallAjax++;
                        isOK = SetCustomersForAgent(customeres);
                        arrData.push(customeres);
                        customeres = '[';
                        t = 0;
                    }
                    coiunter2++;
                });

                if (counter > 0 && customeres.length > 0)
                    customeres = allChecked.substring(0, allChecked.length - 1);
                customeres += ']';
                //debugger;
                //if (counter > 0) {
                CountCallAjax++;
                isOK = SetCustomersForAgent(customeres);
                arrData.push(customeres);
                // }
            }
            else {
                alert("אנא בחר סוכן יעד");
            }
        }

        function ShowDeleteForm() {
            var customeres = '[';
            var counter = 0;
            var data = $('#jQGridTo').jqGrid('getGridParam', 'data');
            var coiunter2 = 0;
            var tmp;
            $('#jQGridTo tr').each(function () {
                if ($('#cbto_' + coiunter2).length > 0 && $('#cbto_' + coiunter2)[0].checked && data[coiunter2 - 1].PermissionsSubAgentsID)
                    customeres += "{ \"PermissionsSubAgentsID\": " + data[coiunter2 - 1].PermissionsSubAgentsID + "},";
                coiunter2++;
            });

            if (counter > 0 && customeres.length > 0)
                customeres = allChecked.substring(0, allChecked.length - 1);
            customeres += ']';

            if (customeres.length < 10) {
                alert("אנא בחר רשומות");
                return false;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את הרשומות המסומנות?")) {
                var request;
                del(customeres);
            }
            return false;
        }
        function del(customeres) {
            request = $.ajax({
                url: "../../Handlers/WebMainHandler.ashx?MethodName=DeleteCustomersForAgent&StrCustmers=" + customeres + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

                $('#<%=lblMSG.ClientID %>').text("הפעולה הסתיימה בהצלחה");
                shakeMSG();

                SetGridTo();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    $('#<%=lblMSG.ClientID %>').text("הפעולה הסתיימה בהצלחה");
                    shakeMSG();

                    SetGridTo();
                }
                else {
                    alert("Error");
                }
            });
        }
        function delTran(customeres) {
            request = $.ajax({
                url: "../../Handlers/WebMainHandler.ashx?MethodName=DeleteTranCustomersForAgent&FromAgentID=" + $('#<%=ddlAgents.ClientID %>').val() + "&StrCustmers=" + customeres + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

                $('#<%=lblMSG.ClientID %>').text("הפעולה נכשלה");
                shakeMSG();

                SetGridTo();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    $('#<%=lblMSG.ClientID %>').text("הפעולה נכשלה");
                    shakeMSG();

                    SetGridTo();
                }
                else {
                    alert("Error");
                }
            });
        }
        var maxWidth = $(document).width() - 150.0;

        function GetWidth(per) {
            return maxWidth / 2 * (per / 100.0);
        }
        function SetGrid() {
            $("#jQGrid").jqGrid('GridUnload');

            var RouteDate = $('#<%=txtRouteDate.ClientID %>').val();
            var arr = RouteDate.split('/');
            RouteDate = arr[2] + "" + arr[1] + "" + arr[0];

            $("#jQGrid").jqGrid({
                url: "../../Handlers/WebMainHandler.ashx?MethodName=GetCustomersForAgent&FromAgentID=" + $('#<%=ddlAgents.ClientID %>').val() + "&RouteDate=" + RouteDate,
                datatype: "json",
                autoencode: false,
                direction: "rtl",
                colNames: [' ', '#', 'שם', 'כתובת', 'ישוב', 'ת.ב. קרוב'],
                colModel: [
                        { name: 'cb1', index: "cb1", type: 'int', sorttype: 'int', width: GetWidth(4), align: 'center', formatter: function (cellValue, option) { return '<input type="checkbox" style=\"text-align:center;\" class="cbb1"  name="cb1" id="cb_' + option.rowId + '"'; } },
                        { name: 'CustID', index: 'CustID', width: GetWidth(12), sorttype: 'int', align: 'right', editable: true },
                        { name: 'CustName', index: 'CustName', width: GetWidth(28), sorttype: 'text', align: 'right', editable: true },
                        { name: 'Address', index: 'Address', width: GetWidth(25), sorttype: 'text', align: 'right', editable: true },
                        { name: 'City', index: 'City', width: GetWidth(13), sorttype: 'text', align: 'right', editable: true },
                        { name: 'DateNearVisited', index: 'DateNearVisited', width: GetWidth(10), type: 'date', sorttype: 'date', formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/y'} }
                       ],
                rowNum: 500,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: 'CustID',
                viewrecords: true,
                sortorder: 'asc',
                caption: "לקוחות מועברים",
                footerrow: true,
                userDataOnFooter: true,

                gridComplete: function (data) {

                    var $grid = $('#jQGrid');
                    var colSum = $grid.jqGrid('getCol', 'Cust_Key', false, 'sum');
                    // $grid.jqGrid('footerData', 'set', { 'Cust_Key': "<span style='font-weight:700'>" + "סה\"כ: " + colSum + "</span>" });

                },
                loadComplete: function (data) {
                    $('.ui-pg-input')[0].parentElement.childNodes[0].data = " דף ";
                    $('.ui-pg-input')[0].parentElement.childNodes[2].data = " מ ";
                    $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";

                    //debugger;

                    //setTimeout(initww, 50);
                    try {

                        //debugger;
                        if (data[0].styleicon1 == 0 || data[0].styleicon1 == 1) {
                            dddata = data;
                            //initwData(data, $("#jQGrid"));
                        }

                        // alert(data[0].AgentId);
                        //if(data[0].AgentId)
                        {
                            // dddata=data;
                            // initwData(data,$("#jQGrid"));                    
                        }
                    }
                    catch (e) {
                        //initwData(dddata, $("#jQGrid"));
                    }
                },

                onSelectRow: function (id) {
                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    // debugger;



                },
                onSortCol: function (index, iCol, sortorder) {
                    //saveSelection.call(this);
                }

                /*editurl: '../../Handlers/WebMainHandler.ashx?MethodName=AddEdit'*/
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                   {
                       edit: false,
                       add: false,
                       del: false,
                       search: true,
                       searchtext: "",
                       addtext: "הוסף",
                       edittext: "ערוך",
                       deltext: "מחק",
                       refreshtext: ""

                   },
                   {   //EDIT
                       //                       height: 300,
                       //                       width: 400,
                       //                       top: 50,
                       //                       left: 100,
                       //                       dataheight: 280,
                       closeOnEscape: true, //Closes the popup on pressing escape key
                       reloadAfterSubmit: true,
                       closeAfterEdit: true,
                       clearAfterAdd: true,
                       drag: true,
                       afterSubmit: function (response, postdata) {
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [false, response.responseText]//Captures and displays the response text on th Edit window
                           }
                       },
                       editData: {
                           id: function () {
                               $("#cData")[0].innerText = "Close";
                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');
                               return value;
                           }
                       }
                   },
                   {
                       closeAfterAdd: true, //Closes the add window after add
                       afterSubmit: function (response, postdata) {
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [false, response.responseText]
                           }
                       }
                   },

                   {//SEARCH
                       closeOnEscape: true

                   }
            );
        }
        SetGrid();

        function shakeMSG() {
            $('#dMSG').effect("shake", { direction: "down", times: 4, distance: 5 }, 1000);
        }
        $(':file').change(function () {
            var file = this.files[0];
            var name = file.name;
            var size = file.size;
            var type = file.type;
            //Your validation
        });

        function SetGridTo() {
            $("#jQGridTo").jqGrid('GridUnload');           

            $("#jQGridTo").jqGrid({
                url: "../../Handlers/WebMainHandler.ashx?MethodName=GetAllCustomersForDates",
                datatype: "json",
                autoencode: false,
                direction: "rtl",
                colNames: [' ', 'סוכן מקורי', 'סוכן חדש', 'קוד לקוח', 'שם לקוח', 'מתאריך', 'עד תאריך', ''],
                colModel: [
                        { name: 'cb1', index: "cb1", type: 'int', sorttype: 'int', width: GetWidth(4), align: 'center', formatter: function (cellValue, option) { return '<input type="checkbox" style=\"text-align:center;\" class="cbb12"  name="cb1" id="cbto_' + option.rowId + '"'; } },
                        { name: 'OrgAgentName', index: 'OrgAgentName', width: GetWidth(20), sorttype: 'text', align: 'right', editable: true },
                        { name: 'CurrentAgentName', index: 'CurrentAgentName', width: GetWidth(17), sorttype: 'text', align: 'right', editable: true },
                        { name: 'CustID', index: 'CustID', width: GetWidth(11), sorttype: 'text', align: 'right', editable: true },
                        { name: 'CustName', index: 'CustName', width: GetWidth(24), sorttype: 'text', align: 'right', editable: true },
                        { name: 'FromDate', index: 'FromDate', width: GetWidth(10), align: "right", type: 'date', sorttype: 'date', formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/y'} },
                        { name: 'ToDate', index: 'ToDate', width: GetWidth(10), align: "right", type: 'date', sorttype: 'date', formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/y'} },
                        { name: 'PermissionsSubAgentsID', index: 'PermissionsSubAgentsID', width: 0, sorttype: 'int', align: 'right', editable: true, hidden: true }
                       ],
                rowNum: 2000,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPagerTo',
                sortname: 'CustID',
                viewrecords: true,
                sortorder: 'asc',
                caption: "&nbsp;",
                footerrow: true,
                userDataOnFooter: true,

                gridComplete: function (data) {

                    var $grid = $('#jQGrid');
                    var colSum = $grid.jqGrid('getCol', 'Cust_Key', false, 'sum');
                    // $grid.jqGrid('footerData', 'set', { 'Cust_Key': "<span style='font-weight:700'>" + "סה\"כ: " + colSum + "</span>" });

                },
                loadComplete: function (data) {
                    $('.ui-pg-input')[1].parentElement.childNodes[0].data = " דף ";
                    $('.ui-pg-input')[1].parentElement.childNodes[2].data = " מ ";
                    $('.ui-pg-input')[1].parentElement.childNodes[1].style.textAlign = "center";
                    // $('.ui-jqgrid-bdiv').height("319px");
                    setTimeout(OnGridLoad, 50);
                    try {

                        //debugger;
                        if (data[0].styleicon1 == 0 || data[0].styleicon1 == 1) {
                            dddata = data;
                            //initwData(data, $("#jQGrid"));
                        }

                        // alert(data[0].AgentId);
                        //if(data[0].AgentId)
                        {
                            // dddata=data;
                            // initwData(data,$("#jQGrid"));                    
                        }
                    }
                    catch (e) {
                        //initwData(dddata, $("#jQGrid"));
                    }
                },

                onSelectRow: function (id) {
                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    // debugger;



                },
                onSortCol: function (index, iCol, sortorder) {
                    //saveSelection.call(this);
                }

                /*editurl: '../../Handlers/WebMainHandler.ashx?MethodName=AddEdit'*/
            });

            $('#jQGridTo').jqGrid('navGrid', '#jQGridPagerTo',
                   {
                       edit: false,
                       add: false,
                       del: false,
                       search: true,
                       searchtext: "",
                       addtext: "הוסף",
                       edittext: "ערוך",
                       deltext: "מחק",
                       refreshtext: ""

                   },
                   {   //EDIT
                       //                       height: 300,
                       //                       width: 400,
                       //                       top: 50,
                       //                       left: 100,
                       //                       dataheight: 280,
                       closeOnEscape: true, //Closes the popup on pressing escape key
                       reloadAfterSubmit: true,
                       closeAfterEdit: true,
                       clearAfterAdd: true,
                       drag: true,
                       afterSubmit: function (response, postdata) {
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [false, response.responseText]//Captures and displays the response text on th Edit window
                           }
                       },
                       editData: {
                           id: function () {
                               $("#cData")[0].innerText = "Close";
                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');
                               return value;
                           }
                       }
                   },
                   {
                       closeAfterAdd: true, //Closes the add window after add
                       afterSubmit: function (response, postdata) {
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [false, response.responseText]
                           }
                       }
                   },
                   {   //DELETE
                       closeOnEscape: true,
                       closeAfterDelete: true,
                       reloadAfterSubmit: true,
                       closeOnEscape: true,
                       drag: true,
                       afterSubmit: function (response, postdata) {
                           if (response.responseText == "") {

                               $("#jQGrid").trigger("reloadGrid", [{ current: true}]);
                               return [false, response.responseText]
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                               return [true, response.responseText]
                           }
                       },
                       delData: {
                           EmpId: function () {
                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, '_id');
                               return value;
                           }
                       }
                   },
                   {//SEARCH
                       closeOnEscape: true

                   }
            );
        }
        function OnGridLoad() {
            //$("#del_jQGridTo")[0].children[0].onclick = ShowDeleteForm;
        }
        SetGridTo();



        function shakeMSG() {
            $('#dMSG').effect("shake", { direction: "down", times: 4, distance: 5 }, 1000);
        }
        $(':file').change(function () {
            var file = this.files[0];
            var name = file.name;
            var size = file.size;
            var type = file.type;
            //Your validation
        });
        function DisableWin() {
            $('#dBody1').block({ message: '...' });
        }
        var CountCallAjax = 0;
        var CountReturnAjax = 0;
        var ctt = 0;
        function ReturnFromAjax() {
            CountReturnAjax++;

            if (CountReturnAjax == CountCallAjax && isAllOK) {//success
                $('#<%=lblMSG.ClientID %>').text("הפעולה הסתיימה בהצלחה");
                shakeMSG();
                $('#dLoading').css("display", "none");
                $('#<%=btnRefresh.ClientID %>').click();
                SetGridTo();
                return;
            }
            if (!isAllOK) {
                // if (CountReturnAjax == CountCallAjax) 
                {
                    $('#<%=lblMSG.ClientID %>').text("הפעולה נכשלה");
                    shakeMSG();
                    $('#dLoading').css("display", "none");
                    //debugger;
                    for (var r = 0; r < arrData.length; r++) {
                        var data = arrData[r];
                        delTran(data);
                    }
                }
                custhis = "";
            }
        }

        function replaceAll(find, replace, str) {
            return str.replace(new RegExp(find, 'g'), replace);
        }
        var isAllOK = true;
        var custhis = "";
        function SetCustomersForAgent(allChecked) {
            var isOK = true;
            var FromDate = $('#<%=dtFrom.ClientID %>').val();
            var arr = FromDate.split('/');
            FromDate = arr[2] + "" + arr[1] + "" + arr[0];

            var RouteDate = $('#<%=txtRouteDate.ClientID %>').val();
            var arr = RouteDate.split('/');
            RouteDate = arr[2] + "" + arr[1] + "" + arr[0];

            var ToDate = $('#<%=dtTo.ClientID %>').val();
            arr = ToDate.split('/');
            ToDate = arr[2] + "" + arr[1] + "" + arr[0];
            custhis += allChecked;
            $.ajax({
                url: "../../Handlers/WebMainHandler.ashx?MethodName=SetCustomersForAgent&FromAgentID=" + $('#<%=ddlAgents.ClientID %>').val() + "&ToAgentID=" + $('#<%=ddlToAgents.ClientID %>').val() + "&StrCustmers=" + allChecked + "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&RouteDate=" + RouteDate,
                type: "Get",
                data: '',
                complete: function (data) {
                    try {

                        ReturnFromAjax();
                    }
                    catch (e) {
                    }

                },
                success: function (data) {
                    try {
                        if (data.responseText.toString().indexOf("res: True") > -1) {
                            isOK = true;
                        }
                        else {
                            isAllOK = false;
                            isOK = false;
                        }
                    }
                    catch (e) {
                    }

                },
                error: function (data) {
                    if (data.responseText.toString().indexOf("res: True") > -1) {
                        isOK = true;
                    }
                    else {
                        isAllOK = false;
                        isOK = false;
                    }
                }
            });
        }

        function SetAllCb() {
            var isToCheck = $('#<%=cbAll.ClientID %>')[0].checked;
            var i = 0;

            var allRowsInGrid = $('#jQGrid').jqGrid('getGridParam', 'data');
            for (i = 0; i < allRowsInGrid.length; i++) {
                if ($("#cb_" + i).length > 0)
                    $("#cb_" + i)[0].checked = isToCheck;

            }
        }
        function OpenMoveWin() {

            $('#<%=lblMSG.ClientID %>').text("");

            $('.dMoveBox').css("display", "block");
            DisableWin();
            var top = 500;
            $('.dMoveBox').css({ top: top })
                        .animate({ "top": "100px" }, "high");
        }
        setDtNoTime('<%= dtFrom.ClientID%>');
        setDtNoTime('<%= dtTo.ClientID%>');
        

        function setDtNoTimeNN(id) {

            $("#" + id).datepicker({
                onSelect: function (dateText) {
                    SetDateNow("1");
                },
                changeMonth: true,
                changeYear: true,
                dateFormat: 'dd/mm/yy'
            });

            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var output = (day < 10 ? '0' : '') + day + '/' +
                    (month < 10 ? '0' : '') + month + '/' +
                    d.getFullYear();

            $('#' + id).val(output);
        }
        function SetDateNow(v) {
            SetGrid();
        }
        setDtNoTimeNN('<%= txtRouteDate.ClientID%>');
        
    </script>
    </form>
</body>
</html>
