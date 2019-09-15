<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Widget1.aspx.cs" Inherits="Widgets_Widget1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../../js/grid.locale-en.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 350px; background-color: Yellow;">
        <table id="jQGrid" style="width: 350px;">
        </table>
        <div id="jQGridPager" style="width: 350px;">
        </div>
    </div>
    </form>
    <script language="javascript" type="text/javascript">
        function PassFormatter(cellValue, options, rowObject) {
            return "********";
        }
        $("#jQGrid").jqGrid({
            url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=GetUsers",
            datatype: "json",
            colNames: ['id', 'Name', 'Description', 'dtCreate', 'UserName', 'Password'],
            colModel: [
                        { name: 'id', index: 'id', width: 90, stype: 'number', editable: true },
                        { name: 'Name', index: 'Name', width: 90, editable: true },
                        { name: 'Description', index: 'Description', width: 90, editable: true },
                        { name: 'dtCreate', index: 'dtCreate', width: 90, editable: true, formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null} },
                        { name: 'UserName', index: 'UserName', width: 0, width: 90, hidden: false },
                        { name: 'Password', index: 'Password', width: 90, editable: true, hidden: false, formatter: PassFormatter,  stype: 'password' },

                      ],
            rowNum: 10,
            mtype: 'POST',
            loadonce: true,
            rowList: [10, 20, 30],
            pager: '#jQGridPager',
            sortname: '_id',
            viewrecords: true,
            sortorder: 'desc',
            caption: "List Employee Details",
            editurl: 'http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=AddEdit'
        });

        $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                   {
                       edit: true,
                       add: true,
                       del: true,
                       search: true,
                       searchtext: "Search",
                       addtext: "Add",
                       edittext: "Edit",
                       deltext: "Delete"
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
        //jQuery("iframe", top.document).contents().height = 500;
        //alert(jQuery("iframe",top.document).contents().height());
                   //$("#frameId").height($("#frameId").contents().find("html").height());
                   
    </script>
</body>
</html>
