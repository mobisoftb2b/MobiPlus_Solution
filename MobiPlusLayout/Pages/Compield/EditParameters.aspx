<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditParameters.aspx.cs" Inherits="Pages_Compield_EditParameters" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>">
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/main.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/json2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="~/css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
            var href;
            switch (lang) {
                case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
               default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        }
        styler();
    </script>
    <link rel="stylesheet" href="../../css/Report.css" />

    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv {
            overflow-y: auto;
            min-height: 425px;
        }

        .ui-jqgrid-titlebar {
            background-color: #E2E3E4;
        }

        .ui-jqgrid-sortable {
            font-size: 14px;
            font-weight: 700;
        }

        .ui-pg-table {
            background-color: #E2E3E4;
            font-size: 14px;
        }

        .ui-widget-content {
            background-color: White !important;
            color: Black;
            text-align: right;
        }

        #searchmodfbox_jQGrid {
            background-color: gray !important;
        }

        .ui-paging-info {
            display: none;
        }
    </style>
    <script type="text/javascript">
        function CloseEditWinPopItemBox() {
            $(".dEditParametersPopItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBodyr").unblock();
        }
    </script>
</head>
<body id="dBodyr" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <div>
            <div class="" style="text-align: right;">
                <table id="jQGrid">
                </table>
                <div id="jQGridPager">
                </div>
            </div>
        </div>
        <div id="dEditParametersPopItemBox" style="display: none" class="dEditParametersPopItemBox">
            <div class="JumpWiX">
                <img alt="<%=StrSrc("Close")%>" src="../../img/X.png" class="imngX" onclick="CloseEditWinPopItemBox();" />
            </div>
            <div style="padding-top: 3px; background-color: #4F81BD;">
                <center>
                    <div id="sHeadEdit">
                       <%=StrSrc("EditParameters")%>  
                    </div>
                </center>
            </div>
            <br />
            <table cellpadding="2" cellspacing="2">
                <tr>
                    <td class="EditForm item">Version:
                    </td>
                    <td class="EditForm val">
                        <asp:TextBox runat="server" ID="txtPrmVersion" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="EditForm item">ID:
                    </td>
                    <td class="EditForm val">
                        <asp:TextBox runat="server" ID="txtPrmId" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="EditForm item">Value:
                    </td>
                    <td class="EditForm val">
                        <asp:TextBox runat="server" ID="txtValue" Width="200px"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <div id="div3" style="text-align: center; float: none; padding-top: 10px;">

                <input type="button" value="<%=StrSrc("Save")%>" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png'); width: 80px;"
                    onclick="SetPopData('0');" />
                <asp:HiddenField runat="server" ID="hdnridmd" />
            </div>
        </div>
    </form>
    <script type="text/javascript">
        $('#dBodyr').height($(document).height());

        function SetPopData(isToDelete) {          
            var RealID = '';
            var isServerDelete = "0";
            var PrmId = $('#txtPrmId').val();
            var PrmVersion = $('#txtPrmVersion').val();
            var Value = $('#txtValue').val();
            try {
                if (Row && Row["PrmId"] != '') {
                    RealID = Row["PrmId"];
                }
            } catch (e) { RealID = "0";}
            if (isToDelete == "1") {
                isServerDelete = "1";
            }
            if (isToDelete == "2") {
                isServerDelete = "0";
                RealID = '0';
            }
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetParametersData&PrmId=" + PrmId + "&PrmVersion=" + PrmVersion + "&RealID=" + RealID + "&Value=" + Value + "&IsToDelete=" + isServerDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
                request.done(function (response, textStatus, jqXHR) {
                    CloseEditWinPopItemBox();
                    RefreshMD();
                    ridmd = "0";
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                  
                    if (jqXHR.status == 200) {
                        if (jqXHR.responseText == "True") {
                            CloseEditWinPopItemBox();
                            RefreshMD();
                            ridmd = "0";
                        }
                        else {
                            alert("<%=StrSrc("ErrorSaving")%> - " + jqXHR.responseText);
                    }
                }
                else {
                    alert("<%=StrSrc("ErrorSaving")%>");
                }
            });
          
        }
        function SetEdit(isToDelete) {

            SetPopData('0');
        }
        function SetAdd(isToDelete) {

            SetPopData('2');
        }
        function SetDel(isToDelete) {

            SetPopData('1');
        }
        function initwData(data, GridID) {
            $(".ui-pg-div").click(doNone);

            $("#edit_" + GridID)[0].children[0].onclick = ShowEditFormMD;

            $("#add_" + GridID)[0].children[0].onclick = ShowAddFormMD;

            $("#del_" + GridID)[0].children[0].onclick = ShowDeleteFormMD;

            $("#search_" + GridID)[0].children[0].onclick = ShowSearchFormMD;

            $("#refresh_" + GridID)[0].children[0].onclick = RefreshMD;
        }
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        var ridmd = "0";
        function ShowEditFormMD() {

            $('.MSBtnGeneral').attr('onclick', 'SetEdit("1")');
            if (ridmd == "0" || ridmd == "") {
                alert("<%=StrSrc("SelectParameter")%>.");
                return;
            }
            if (ridmd != "") {
                $('#<%=txtPrmVersion.ClientID %>').val(Row["PrmVersion"]);
                $('#<%=txtPrmId.ClientID %>').val(Row["PrmId"]);
                $('#<%=txtValue.ClientID %>').val(Row["Value"]);
                IsAddMD = false;
                $('.dEditParametersPopItemBox').css("display", "block");
                var top = 500;
                $(".dEditParametersPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert("אנא בחר פרמטר");
            }
            return false;
        }

        var IsAddMD = true;
        function ShowAddFormMD() {
         
            $('.MSBtnGeneral').attr('onclick', 'SetAdd("2")');

            $('#<%=txtPrmVersion.ClientID %>').val("");
            $('#<%=txtPrmId.ClientID %>').val("");
            $('#<%=txtValue.ClientID %>').val("");
            ridmd = "0";
            IsAddMD = true;
            $('.dEditParametersPopItemBox').css("display", "block");
            var top = 500;
            $(".dEditParametersPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
        function ShowEditFormMDCust() {
            $('.MSBtnGeneral').attr('onclick', 'SetEdit("1")');
         
            if (ridmd == "0" || ridmd == "") {
                alert("<%=StrSrc("SelectParameter")%>.");
                return;
            }
            if (ridmd != "") {
                $('#<%=txtPrmVersion.ClientID %>').val("");
                $('#<%=txtPrmId.ClientID %>').val("");
                $('#<%=txtValue.ClientID %>').val("");
                IsAddMD = false;
                $('.dEditWinPopItemBox').css("display", "block");
                var top = 500;
                $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert("<%=StrSrc("SelectParameter")%>");
            }
            return false;
        }
        function ShowDeleteFormMD() {
           
            $('.MSBtnGeneral').attr('onclick', 'SetDel("1")');
            if (ridmd == "0" || ridmd == "") {
                alert("<%=StrSrc("SelectParameter")%>.");
                return;
            }
            if (confirm("<%=StrSrc("ConfirmDelete")%>?")) {
                SetPopData('1');
            }
        }
        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function doNone() {
            return false;
        }
        var Row;
        var ridmd = "0";
        function SetGrid(GridID, jQGridPager) {

            $("#" + GridID).jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetParametersData&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "<%=StrSrc("dir")%>",
                colNames: ['Parameters Version', 'ID', 'Value'],
                colModel: [{ name: 'PrmVersion', index: 'PrmVersion', width: 200, sorttype: 'int', align: 'right', editable: true },
                            { name: 'PrmId', index: 'PrmId', width: 200, sorttype: 'text', align: 'right', editable: true },
                            { name: 'Value', index: 'Value', width: 100, sorttype: 'text', align: 'right', editable: true }
                ],
                rowNum: 30,
                mtype: 'GET',
                loadonce: true,
                //rowList: [10, 20, 30],
                pager: '#' + jQGridPager,
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,

                loadComplete: function (data) {
                    $('.ui-pg-input')[0].parentElement.childNodes[0].data = " <%=StrSrc("Page")%> ";
                    $('.ui-pg-input')[0].parentElement.childNodes[2].data = " <%=StrSrc("of")%> ";
                    $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";
                    //var grid = $("#" + GridID),
                    //ids = grid.getDataIDs();

                    //for (var i = 0; i < ids.length; i++) {
                    //    grid.setRowData(ids[i], false, { height: 20 + (i * 2) });
                    //}

                    initwData(data, GridID);
                },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#' + GridID).jqGrid('getRowData', id);
                    Row = row;
                    ridmd = row["PrmId"];

                },
                ondblClickRow: function (id) {

                    var row = $('#' + GridID).jqGrid('getRowData', id);
                    Row = row;
                    ridmd = row["PrmId"];
                    ShowEditFormMD();
                },

            });

            $('#' + GridID).jqGrid('navGrid', '#' + jQGridPager,
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "",
                           addtext: "",
                           edittext: "",
                           deltext: "",
                           refreshtext: "",
                           viewtext: "<%=StrSrc("Watch")%>"

                       },
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
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

                               if (response.responseText.indexOf('<%=StrSrc("GoodLuck")%>') > -1)
                                   ShowMSGT();
                               if (response.responseText == "") {

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [true, '']
                               }
                               else {
                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [false, response.responseText]//Captures and displays the response text on th Edit window
                               }
                               $("#sData")[0].style.display = "block";

                           },

                           editData: {
                               id: function () {
                                   $("#cData")[0].innerText = "Close";
                                   $("#sData")[0].style.display = "none";

                                   var sel_id = $('#' + GridID).jqGrid('getGridParam', 'selrow');
                                   var value = $('#' + GridID).jqGrid('getCell', sel_id, 'id');

                                   return value;
                               },
                               GraphID: function () {

                                   $("#cData")[0].innerText = "Close";
                                   $("#sData")[0].style.display = "none";

                                   var sel_id = $('#' + GridID).jqGrid('getGridParam', 'selrow');
                                   var value = $('#' + GridID).jqGrid('getCell', sel_id, 'GraphID');

                                   return value;
                               },
                               GroupID: function () {

                                   return getCellGroupNameValue();
                               },
                               Grids: function () {
                                   return getCellGridsValue();
                               }
                           }
                       },
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
                       {
                           closeAfterAdd: true, //Closes the add window after add

                           afterSubmit: function (response, postdata) {
                               if (response.responseText.indexOf('<%=StrSrc("GoodLuck")%>') > -1)
                                   ShowMSGT();
                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";
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

                                   $("#jQGrid").trigger("reloadGrid", [{ current: true }]);
                                   return [false, response.responseText]
                               }
                               else {
                                   $(this).jQGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               GraphID: function () {

                                   var sel_id = $('#' + GridID).jqGrid('getGridParam', 'selrow');
                                   var value = $('#' + GridID).jqGrid('getCell', sel_id, 'GraphID');
                                   alert(value);
                                   return value;

                                   return value;
                               }
                           }
                       },
                       {//SEARCH
                           closeOnEscape: true

                       }
                );
                       }

                       SetGrid('jQGrid', 'jQGridPager');

    </script>
</body>
</html>
