<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalAvoda.aspx.cs" Inherits="Pages_Main_SalAvoda" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>סל עבודה</title>
    <link rel="SHORTCUT ICON" href="../../img/Map.ico" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css" rel="stylesheet" type="text/css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
    <script type="text/javascript">
        function CloseEditWinTaskItemBox() {
            $(".EditWinTaskItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBodyr").unblock();
        }
        function DateFormatteryyyymmdd(cellValue, options, rowObject) {
            if (cellValue)
                return cellValue.toString().substr(6, 2) + "/" + cellValue.toString().substr(4, 2) + "/" + cellValue.toString().substr(0, 4);
            else
                return cellValue;
        }
        var arrIDs = [];
        var arrTasks = [];
        function BoldFormatter(cellValue, options, rowObject) {
            //debugger;
            var scr = " onclick='OpenTask(\"" + options.rowId + "\");'";
            if (!(rowObject["TaskID"])) {
                scr = " onclick='OpenTask(\"" + arrIDs[options.rowId.replace('jQGridghead_0_', '')] + "\");'";
            }
            else {
                scr = " onclick='OpenTask(\"" + options.rowId + "\");'"
                var isNotFound = true;
                for (var i = 0; i < arrIDs.length; i++) {
                    if (arrTasks[i] == rowObject["TaskID"]) {
                        isNotFound = false;
                        break;
                    }
                }
                if (isNotFound) {
                    arrIDs.push(options.rowId);
                    arrTasks.push(rowObject["TaskID"]);
                }
            }
            return "<div style='font-weight:700;' " + scr + ">" + cellValue + "</div>";
        }
        function summaryType(val, name, record) {

            if (typeof (val) === "string" || typeof (val) == 'image') {
                val = ''; //{ max: false, totalCount: 0, checkedCount: 0 };
            }

            return val;
        }
        function mysum(val, name, record) {
            return "<div id='div" + record["TaskID"] + "'>סה''כ:" + "</div>";
        }
    </script>
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv
        {
            overflow-y: auto;
            min-height: 480px;
        }
        .ui-jqgrid-titlebar
        {
            background-color: #E2E3E4;
        }
        .ui-jqgrid-sortable
        {
            font-size: 13px !important;
            font-weight: 700;
        }
        .ui-pg-table
        {
            background-color: #E2E3E4;
            font-size: 16px;
        }
        .ui-jqgrid tr.jqgrow td
        {
            white-space: normal !important;
        }
        #searchmodfbox_jQGrid
        {
            background-color: gray !important;
        }
        .ui-paging-info
        {
            display: none;
        }
        
        
        .tbl
        {
            font-size: 14px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            width: 100%;
        }
        .HeadData
        {
            font-size: 22px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            width: 97%;
            vertical-align: top;
        }
        .DateData
        {
            font-size: 16px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            width: 92%;
            vertical-align: top;
        }
        .rtl
        {
            direction: rtl;
        }
        .logo1
        {
            text-align: left;
            vertical-align: top;
            padding-left: 5px;
        }
        .top1
        {
            vertical-align: top;
        }
        .msgData
        {
            height: 500px;
            margin-top: 200px;
            font-size: 26px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            display: none;
            padding-left: 150px;
        }
        .dCounter
        {
            text-align: right;
            font-size: 13px !important;
            padding-top: 5px;
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <table cellpadding="0" cellspacing="0" width="100%" class="rtl">
            <tr>
                <td class="HeadData">
                    הצגת סיכום ביקור של מקדם
                    <%=AgentId %>
                    <br />
                    <span class="DateData">
                        <%=DateMap %></span>
                </td>
                <td class="logo1">
                    <img src="../../img/dubekLogo.jpg" h />
                </td>
            </tr>
        </table>
    </div>
    <div class="msgData">
        אין נתונים</div>
    <div  class="rtl">
        <table>
            <tr>
                <td>
                    חיפוש ע"מ:
                </td>
                <td>
                    <input type="text" id="txtFilter" style="width: 120px" />
                </td>
                <td>
                    <input type="button" id="btnFilter" value="חפש" onclick="FilterCustCode();"/>
                </td>
            </tr>
        </table>
    </div>
    <div class="dGrid" style="text-align: center;">
        <center>
            <table id="jQGrid">
            </table>
            <div id="jQGridPager">
            </div>
            <div class="dCounter">
            </div>
        </center>
    </div>
    </form>
    <script type="text/javascript">
    var Row;
    var ridmd="0";
     var arrIDs = [];
        var arrTasks = [];
        function GreenFormatter(cellValue, options, rowObject) {
            return "<div style='color:#3AAE00;cursor:pointer;' onclick='window.location.href=\"http://www.dubek.com/+"+rowObject.CustCode+"\"'>" + cellValue + "</div>";
        }
         function HourFormatter(cellValue, options, rowObject) {

            if(cellValue>1000)
                return "<div style=''>" + (cellValue+" ").substr(0,2)+":" +(cellValue+" ").substr(2,2)+ "</div>";
            else
                return "<div style=''>0" + (cellValue+" ").substr(0,1)+":" +(cellValue+" ").substr(1,2)+ "</div>";
        }
        function summaryType(val, name, record) {

            if (typeof (val) === "string" || typeof (val) == 'image') {
                val = ''; //{ max: false, totalCount: 0, checkedCount: 0 };
            }

            return val;
        }
        function mysum(val, name, record) {
            return "<div id='div" + record["TaskID"] + "'>סה''כ:" + "</div>";
        }

    function getWidth(widthHD)
    {
//        var newWidthPer = (widthHD/1900)*100;
//        return ($(document).width()) * newWidthPer/100+"px";
        return widthHD/100 * $(document).width() +"px";

    }
    function SetGrid(filterTxt) {
   
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetUserSumVisit&User= <%=AgentId %>&Date=<%=DateData %>&Filter="+filterTxt+"&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['ע"מ','שם לקוח', 'תאריך ביקור','שעת התחלה', 'שעת סיום','אזור','מסלול','תת פעילות','POS','סידור מדף','אזל','השלמה','החדרה','תגמול','מתקנים','משך ביקור'],
                colModel: [ { name: 'CustCode', index: 'CustCode', width: getWidth(7), sorttype: 'int', align: 'right', editable: true ,summaryType:mysum},
                            { name: 'CustName', index: 'CustName', width: getWidth(16), sorttype: 'text', align: 'right', editable: true,formatter: GreenFormatter,summaryType:summaryType},
                            { name: 'EndDate', index: 'EndDate', width: getWidth(7), sorttype: 'date', align: 'right', editable: true,formatter: 'date',summaryType:summaryType,formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null}},
                            { name: 'VisitDate', index: 'VisitDate', width: getWidth(7), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType,hidden:true},
                            { name: 'AddingDate', index: 'AddingDate', width: getWidth(7), sorttype: 'int', align: 'right', editable: true ,summaryType:summaryType,formatter: HourFormatter},
                            { name: 'ezor', index: 'ezor', width: getWidth(6), sorttype: 'text', align: 'right', editable: true },
                            { name: 'Maslul', index: 'Maslul', width: getWidth(4), sorttype: 'int', align: 'right', editable: true ,summaryType:summaryType},
                            { name: 'TatPeilut', index: 'TatPeilut', width: getWidth(13), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType},
                            { name: 'Pos', index: 'Pos', width: getWidth(4), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType},
                            { name: 'SidurMadaf', index: 'SidurMadaf', width: getWidth(8),  stype: 'text',sorttype: 'text',summaryType:summaryType},
                            { name: 'Azal', index: 'Azal', width: getWidth(4), sorttype: 'text', align: 'right', editable: true,summaryType:summaryType },
                            { name: 'Ashlama', index: 'Ashlama', width: getWidth(4.5), sorttype: 'text', align: 'right', editable: true,summaryType:summaryType },
                            { name: 'Ahdara', index: 'Ahdara', width: getWidth(4.3), sorttype: 'text', align: 'right', editable: true,summaryType:summaryType },
                            { name: 'Tagmul', index: 'Tagmul', width: getWidth(4), sorttype: 'text', align: 'right', editable: true,summaryType:summaryType },
                            { name: 'Mitkan', index: 'Mitkan', width: getWidth(4.6), sorttype: 'text', align: 'right', editable: true,summaryType:summaryType },
                            { name: 'MeshehBikur', index: 'MeshehBikur', width: getWidth(6), sorttype: 'text', align: 'right', editable: true,summaryType:summaryType}
                        ],
                rowNum: 1070,
                mtype: 'POST',
                loadonce: true,
                
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,
                grouping: true, 
                
                loadComplete: function (data) {
                    try{
                    if(data.length)
                        $('.dCounter').text("מציג "+data.length+" שורות");
                    else
                    {
                        $('.dCounter').text("מציג "+data.rows.length+" שורות");
                    }
                    }
                    catch(e)
                    {
                        $('.dCounter').text("מציג 0 שורות");
                    }

                    $('tr.jqgrow').css("font-size","14px");
            },

                onSelectRow: function (id) {

                    //ridmd = id;
                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    Row = row;
                    //ridmd = row["TaskID"];                    
                    
                },
                ondblClickRow: function (id) {

//                    var row = $('#jQGrid').jqGrid('getRowData', id);
//                    Row = row;
//                   ridmd = row["TaskID"];
//                   
//                    ShowEditFormMD();
                },
                
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: false,
                           add: false,
                           del: false,
                           search: true,
                           searchtext: "",
                           addtext: "",
                           edittext: "",
                           deltext: "",
                           refreshtext: "",
                           viewtext: "צפה"
                           
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

                           if (response.responseText.indexOf('בהצלחה') > -1)
                               ShowTaskT();
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

                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');

                               return value;
                           },
                           GraphID: function () {

                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";

                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'GraphID');

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
                           if (response.responseText.indexOf('בהצלחה') > -1)
                               ShowTaskT();
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

                                   $("#jQGrid").trigger("reloadGrid", [{ current: true}]);
                                   return [false, response.responseText]
                               }
                               else {
                                   $(this).jQGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               GraphID: function () {

                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'GraphID');
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
        SetGrid(escape($('#txtFilter').val()));

        function FilterCustCode()
        {
            $("#jQGrid").jqGrid('GridUnload');
            SetGrid(escape($('#txtFilter').val()));
        }
         
        SetFieldOnlyNumbers('txtFilter');

        
    </script>
</body>
</html>
