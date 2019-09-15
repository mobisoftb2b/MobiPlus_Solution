<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GridP.aspx.cs" Inherits="tests_GridP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../js/Main.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>
    <link rel="stylesheet" href="~/css/jquery-ui.css">
    <script src="../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>



    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../js/jquery.blockUI.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <table id="jQGrid" style="width: 100%;">
            </table>
            <div id="jQGridPager">
            </div>
    </div>
    </form>
    <script type="text/javascript">
        function ShowGrid() {
            jQuery("#jQGrid").jqGrid({
                url: "../Handlers/MainHandler.ashx?MethodName=Test_GetItems",
                datatype: "json",
                direction: "rtl",
                colNames: ['CustID', 'SalesOrganization', 'DistributionChannel', 'Division', 'CustName', 'Address', 'Phone', 'VatNum'],
                colModel: [
                            { name: 'CustID', index: 'CustID', width: 0, sorttype: 'text', editable: true, align: 'right', hidden: true },
                            { name: 'SalesOrganization', index: 'SalesOrganization', width: 150, sorttype: 'text', editable: true, align: 'right'
                            },
                            { name: 'DistributionChannel', index: 'DistributionChannel', width: 150, sorttype: 'text', editable: true, align: 'right' },
                            { name: 'Division', index: 'Division', width: 150, sorttype: 'text', align: 'right', editable: true

                            },
                            { name: 'CustName', index: 'CustName', width: 150, editable: true, sorttype: 'text', align: 'right' },
                            { name: 'Address', index: 'Address', width: 150, editable: true, sorttype: 'text', align: 'right' },
                            { name: 'Phone', index: 'Phone', width: 120, editable: true, sorttype: 'text', align: 'right', hidden: false },
                            { name: 'VatNum', index: 'VatNum', width: 150, sorttype: 'text', editable: true, align: 'right', hidden: false }
                          ],
                rowNum: 30,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',

                viewrecords: true,
                sortorder: 'desc',

                caption: "גריד נסיון",
                onSelectRow: function (id) {
                    //rid = id;

                },
                loadComplete: function (data) {
                    //debugger;
                   // alert(data.length);
                },

                editurl: ''
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "חיפוש",
                           addtext: "הוסף",
                           edittext: "ערוך",
                           deltext: "מחק"
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
                               //setTimeout(Reload, 500);
                               if ($("#sData").length > 0) {

                                   $("#sData")[0].style.display = "none";
                               }
                               if (response.responseText == "") {

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [true, '']
                               }
                               else {
                                   //debugger;
                                   if (response.responseText.toLowerCase().indexOf('error') == -1 && response.responseText.toLowerCase().indexOf('cannot') == -1)
                                       $('#FormError')[0].innerHTML = "<td class='MsgT' colspan='2'>" + response.responseText + "</td>";
                                   else
                                       $('#FormError')[0].innerHTML = "<td class='MsgError' colspan='2'>" + response.responseText + "</td>";

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [false, response.responseText]//Captures and displays the response text on th Edit window
                               }

                           },
                           editData: {
                               VerID: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },

                               ServerGroupName: function () {

                                   $("#cData")[0].innerText = "Close";
                                   return getCellServerGroupNameValue();
                               },
                               Command: function () {
                                   var value = "Edit";
                                   return value;
                               },
                               ProjectTypeName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellProjectTypeValue();
                               }
                           },
                           addData: {
                               VerID: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },

                               ServerGroupName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellServerGroupNameValue();
                               },
                               Command: function () {
                                   var value = "Add";
                                   return value;
                               },
                               ProjectTypeName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellProjectTypeValue();
                               }
                           }
                       },
                       {
                           closeAfterAdd: true, //Closes the add window after add
                           afterSubmit: function (response, postdata) {
                               if ($("#sData").length > 0) {
                                   $("#sData")[0].style.display = "none";
                               }
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
                               if ($("#sData").length > 0) {
                                   $("#sData")[0].style.display = "none";
                               }
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
                               VerID: function () {

                                   Command = "Delete";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },
                               Command: function () {
                                   var value = "Delete";
                                   return value;
                               }
                           }
                       },

                       {//SEARCH
                           closeOnEscape: true

                       }
                );
                   }
          ShowGrid();
    </script>
</body>
</html>
