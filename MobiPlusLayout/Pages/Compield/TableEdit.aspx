<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TableEdit.aspx.cs" Inherits="Pages_Compield_TableEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
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
    <script src="../../js/tableEdit.js"></script>

</head>
<body id="dBodyr" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" class="css-form" runat="server">
        <div>
            <div class="dPartItems" id="gridDiv" style="display: none; height: <%=Height %>px">
                <table id="jQGrid">
                </table>
                <div id="jQGridPager" style="position: fixed;">
                </div>
            </div>
            <div id="EditBox" runat="server" style="display: none;" class="cssEditBox">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                    <h3 runat="server" id="myModalLabel">עריכת טבלה</h3>
                    <input id="Hidden1" type="hidden" />
                </div>
            </div>
            <div id="ErrorBox" runat="server" style="display: none;" class="cssErrorBox">
                <div class="Error-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseErrorBox();">×</button>
                    <h3 id="txtError"></h3>
                </div>
            </div>
            <div id="ApprovalBox" runat="server" style="display: none;" class="cssApprovalBox">
                <div class="Approval-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseApprovalBox();">×</button>
                    <h3 id="txtApproval">האם אתה בטוח ברצונך למחוק את ערך המסומן מן הגריד?</h3>
                    <button type="button" class="btn-Approv" data-dismiss="modal" aria-hidden="true" onclick="CloseApprovalBox();">בטל</button>
                    <button type="button" class="btn-Approv" data-dismiss="modal" aria-hidden="true" onclick="doApproval();">אשר</button>
                </div>
            </div>
            <asp:HiddenField runat="server" ID="hdnGridStyles" />
            <asp:HiddenField runat="server" ID="hdnIsSummery" />
            <asp:HiddenField runat="server" ID="hdnIsLastRowFooter" />
            <asp:HiddenField runat="server" ID="hdnFooterRow" />
            <asp:HiddenField runat="server" ID="hdnFooterRowAsRow" />
            <asp:HiddenField runat="server" ID="hdnJson" />
            <asp:HiddenField runat="server" ID="hdnParams" />
            <asp:HiddenField runat="server" ID="hdnTableName" />
            <asp:HiddenField runat="server" ID="hdnParamsType" />
        </div>
    </form>
    <script type="text/javascript">
        var hdnParamsClientID = '<%=hdnParams.ClientID %>';
        var hdnTableNameClientID = '<%=hdnTableName.ClientID %>';
        var hdnParamsTypeClientID = '<%=hdnParamsType.ClientID %>';
        var Ticks =<%= DateTime.Now.Ticks.ToString()%>;
        var GridID = "jQGrid";
        $('#dBodyr').height($(document).height());
        function ShowGrid() {
            $('#gridDiv').show();
            SetGrid(); 
        }
    

        function ShowControl() {

        }
        function NavFrame(val, ControlKey) {
            parent.SethdnSrcParams('<%=ControlKey %>', val, '<%=WinID %>');
        }


        function OnInit() {

            for (var i = 0; i < $('.ui-datepicker').length; i++) {
                $('.ui-datepicker')[i].className = "ui-datepicker msdatepicker";
            }
        }
   

      
        function SetGrid() {
            var footerrow=false; 
            if($('#<%=hdnIsSummery.ClientID %>').val().split(';').length > 1 || $('#<%= hdnIsLastRowFooter.ClientID%>').val()=="True")
                footerrow = true;
            var dataReal;
            var rids;
            var arrFooter2;
            var isDeleted= false;
            var RowNum = <%=RowNum %>;
            if(RowNum=="")
                RowNum = 'auto';
            $("#jQGrid").jqGrid({
                url: "<%= url%>",
                datatype: "json",
                direction: "rtl",
                colNames:[<%=colNames %>],
                colModel:[<%=colModel %>],
                rowNum: RowNum,
                mtype: 'POST',
                loadonce: true,
                pager: '#jQGridPager',
                prmNames: {page: "pageNumber", rows: "rowSize"},
                viewrecords: true,
                sortorder: 'asc',
                caption: "<%=Caption %>",
                toppager: false,
                
                loadComplete: function (data) {
                    $('.ui-pg-input')[0].parentElement.childNodes[0].data = " דף ";
                    $('.ui-pg-input')[0].parentElement.childNodes[2].data = " מ ";
                    $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";
                    
                    initwData(data);
                    $('.ui-jqgrid-view').height($(document).height()-27);
                    
                    $('.ui-jqgrid-bdiv').height($(document).height()-47);
                },

                onSelectRow: function (id) {
                    ridmd = id;
                    var row = $('#' + GridID).jqGrid('getRowData', id);
                    Row = row;
                },
                ondblClickRow: function (id) {
                        var row = $('#' + GridID).jqGrid('getRowData', id);
                        Row = row;
                        ridmd = id;
                        ShowEditFormMD();
                },
               
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "",
                           addtext: "הוסף",
                           edittext: "ערוך",
                           deltext: "מחק",
                           refreshtext: "",
                           viewtext: "צפה"
                           
                       },
                       {   //EDIT
    
                           closeOnEscape: true, //Closes the popup on pressing escape key
                           reloadAfterSubmit: true,
                           closeAfterEdit: true,
                           clearAfterAdd: true,
                           drag: true,
                           afterSubmit: function (response, postdata) {

                               if (response.responseText.indexOf('בהצלחה') > -1)
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
                       {
                           closeAfterAdd: true, //Closes the add window after add

                           afterSubmit: function (response, postdata) {
                               if (response.responseText.indexOf('בהצלחה') > -1)
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
     


        OnInit();
        setTimeout('OnInit();',1600);
        $(".yyyymmddPopup").datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'dd/mm/yy',
            onSelect: function(dateText) {
                openPop(this);
                this.focus();
            }
        });
        $(".DateTimePopup").datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'dd/mm/yy',
            onSelect: function(dateText) {
                openPop(this);
                this.focus();
            }
        });
      
        
    </script>
</body>
</html>
