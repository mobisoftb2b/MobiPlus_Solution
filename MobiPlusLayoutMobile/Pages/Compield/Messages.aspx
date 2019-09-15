<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Messages.aspx.cs" Inherits="Pages_Compield_Messages" %>
<%@ Register TagPrefix="ctl" Src="~/Controls/ctlPopulations.ascx" TagName="ctlPopulations" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>הודעות</title>
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
        function CloseEditWinMSGItemBox() {
            $(".EditWinMSGItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBodyr").unblock();
        }
        function DateFormatteryyyymmdd(cellValue, options, rowObject) {
            if (cellValue)
                return cellValue.toString().substr(6, 2) + "/" + cellValue.toString().substr(4, 2) + "/" + cellValue.toString().substr(0, 4);
            else
                return cellValue;
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
            font-size: 14px;
            font-weight: 700;
        }
        .ui-pg-table
        {
            background-color: #E2E3E4;
            font-size: 14px;
        }
        .ui-jqgrid tr.jqgrow td
        {
            white-space:normal !important; 
        }
        
    </style>
</head>
<body id="dBodyr" >
    <form id="form1" runat="server">
    <div>
        <div class="dProfileAll">
            <div class="txtPartsGridContainer" style="width: 655px; height: 600px">
                <div class="QueryHeader" style="height: 30px; font-size: 18px;">
                    <div class="QueryHeaderIn">
                        הודעות</div>
                </div>
                <div class="PartsEdit" style="padding-right: 13px; padding-top: 5px;">
                    <div class="dPartItems">
                        <table id="jQGrid">
                        </table>
                        <div id="jQGridPager">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="dEditWinMSGItemBox" class="EditWinMSGItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseEditWinMSGItemBox();" />
        </div>
        <div style="padding-top: 3px; background-color: #4F81BD;">
            <center>
                <div id="sHeadEdit">
                    עריכת הודעה
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item" style="vertical-align: top;">
                    הודעה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtMSGText" Width="246px" TextMode="MultiLine" Rows="4"></asp:TextBox>
                </td>
            </tr>
            <tr id="rAgent">
                <td class="EditForm item">
                    מתאריך:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtMSGFromDate" Width="246px" CssClass="dtp dtp1"></asp:TextBox>
                </td>
            </tr>
            <tr id="rCustomer">
                <td class="EditForm item">
                    עד תאריך:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtMSGToDate" Width="246px" CssClass="dtp dtp2"></asp:TextBox>
                </td>
            </tr>
            <tr id="Tr1">
                <td class="EditForm item">
                    אוכלוסיות:
                </td>
                <td class="EditForm val Pop">
                    <%--<span id="aPop" href="#" onclick="ShowCtlPopulations();" style="color: Blue;text-decoration:underline;cursor:pointer">אוכלוסיות</span>--%>
                     <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <span id="aPop" href="#" onclick="ShowCtlPopulations();" style="color: Blue;text-decoration:underline;cursor:pointer"><div style="color:Black;text-decoration:'none' !important;">טוען...<img alt="טוען..." src="../../img/loading1.gif" width="16px"/></div></span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 80px;" onclick="SetMSGData('0');" />
            <asp:HiddenField runat="server" ID="hdnridmd" />
        </div>
    </div>
    <div>
        <ctl:ctlPopulations runat="server" id="ctlPopulationsR" ShowAgents="true" ShowCustomers="true" ShowItems="false" ShowCategories="false"/>
    </div>
    <script type="text/javascript">
        var isAgents = <%=Request.QueryString["Agents"].ToString() %>;
        function SetMSGData(isToDelete) {
            if( $('#aPop').text()=="אוכלוסיות" || ($('#<%=ctlPopulationsR.hdnParentsPopulationID %>').val() =="" && $('#<%=ctlPopulationsR.hdnItemsPopulationID %>').val() ==""))  
            {
                alert("אנא בחר אוכלוסיות");
                return;
            }
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetMSGData&MessageID=" + ridmd + "&MessageText="+ $('#<%=txtMSGText.ClientID %>').val() + "&MessageFromDate="+ $('#<%=txtMSGFromDate.ClientID %>').val()
                + "&MessageToDate="+ $('#<%=txtMSGToDate.ClientID %>').val() + "&IsToDelete="+ isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
               type: "post",
                data: "ParentsPopulation=" + ($('#<%=ctlPopulationsR.hdnParentsPopulationID %>').val())
                +"&ItemsPopulation="+ ($('#<%=ctlPopulationsR.hdnItemsPopulationID %>').val()) + "&UnCheckedPopulation="+ ($('#<%=ctlPopulationsR.hdnUnCheckedPopulationID %>').val())
                
            });
            request.done(function (response, textStatus, jqXHR) {
                 CloseEditWinMSGItemBox();
                 RefreshMD();

                 ridmd="0";
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")                    
                    {
                        CloseEditWinMSGItemBox();
                        RefreshMD();

                        ridmd="0";
                    }
                    else
                    {
                        alert("אראה שגיאה בשמירת הנתונים - " + jqXHR.responseText);
                    }
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                    //alert("Error");
                }
            });
        }

    function initwData(data, objMain) {
            $(".ui-pg-div").click(doNone);

            $("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMD;
            
            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMD;

            $("#del_jQGrid")[0].children[0].onclick = ShowDeleteFormMD;

            $("#search_jQGrid")[0].children[0].onclick = ShowSearchFormMD;

           $("#refresh_jQGrid")[0].children[0].onclick = RefreshMD;
        }
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        function ShowEditFormMD() {
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר הודעה מן הגריד תחילה.");
                return;
            }
            if (ridmd != "") {
               
                $('#<%=txtMSGText.ClientID %>').val(Row["MessageText"]);
                $('#<%=txtMSGFromDate.ClientID %>').val(Row["MessageFromDate"]);
                $('#<%=txtMSGToDate.ClientID %>').val(Row["MessageToDate"]);
                $('#aPop').text(Row["Populations"]);

                //$('#=ctlPopulationsR.hdnPopsValuesAgentsInitID %>').val(Row["AgentsPopulation"]);
                //$('#=ctlPopulationsR.hdnPopsValuesCustsInitID %>').val(Row["CustomersPopulation"]);
                //$('#=ctlPopulationsR.hdnPopsValuesItemsInitID %>').val(Row["ItemsPopulation"]);
                SetInit(Row["MessageID"]);

                IsAddMD = false;
                $('.EditWinMSGItemBox').css("display", "block");
                var top = 500;
                $(".EditWinMSGItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert("אנא בחר הודעה");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMD() {
            $('#<%=txtMSGText.ClientID %>').val("");
            $('#<%=txtMSGFromDate.ClientID %>').val("");
            $('#<%=txtMSGToDate.ClientID %>').val("");
            $('#aPop').text("אוכלוסיות");

            //$('#=ctlPopulationsR.hdnPopsValuesAgentsInitID %>').val("");
            //$('#=ctlPopulationsR.hdnPopsValuesCustsInitID %>').val("");
            //$('#=ctlPopulationsR.hdnPopsValuesItemsInitID %>').val("");
            SetInit('0');

            ridmd="0";
            IsAddMD = true;
            $('.EditWinMSGItemBox').css("display", "block");
            var top = 500;
            $(".EditWinMSGItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
       function ShowCtlPopulations() {

            $('.ctlPopulations').css("display", "block");
            var top = 650;
            $(".ctlPopulations").css({ top: top })
                        .animate({ "top": "15px" }, "high");
            //$('#dBodyr').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר הודעה מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את ההודעה המסומנת מן הגריד?")) {
                SetMSGData('1');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function doNone() {
            return false;
        }
    var Row;
    var ridmd="0";
    function SetGrid() {
            var PopulationTypeID="25";
            if(!isAgents)
                PopulationTypeID="50";

            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_MSG_GetAllMessages&VersionID=<%=SessionVersionID %>&PopulationTypeID=" + PopulationTypeID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','מתאריך', 'עד תאריך', 'הודעה','אוכלוסיות','AgentsPopulation','CustomersPopulation','ItemsPopulation'],
                colModel: [ { name: 'MessageID', index: 'MessageID', width: 50, sorttype: 'int', align: 'right', editable: true },
                            { name: 'MessageFromDate', index: 'MessageFromDate', width: 90, sorttype: 'date', align: 'right', editable: true,formatter: DateFormatteryyyymmdd},
                            { name: 'MessageToDate', index: 'MessageToDate', width: 120, sorttype: 'date', align: 'right', editable: true,formatter: DateFormatteryyyymmdd },
                            { name: 'MessageText', index: 'MessageText', width: 220, sorttype: 'text', align: 'right', editable: true },
                            { name: 'Populations', index: 'Populations', width: 120, sorttype: 'text', align: 'right', editable: true },

                            { name: 'AgentsPopulation', index: 'AgentsPopulation', width: 0, sorttype: 'text', align: 'right', editable: true,hidden:true },
                            { name: 'CustomersPopulation', index: 'CustomersPopulation', width: 0, sorttype: 'text', align: 'right', editable: true,hidden:true },
                            { name: 'ItemsPopulation', index: 'ItemsPopulation', width: 0, sorttype: 'text', align: 'right', editable: true,hidden:true }
                        ],
                rowNum: 70,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,
                 
                loadComplete: function (data) {
                    initwData(data, $("#jQGrid"));

                    var grid = $("#jQGrid"),
                    ids = grid.getDataIDs();

                    for (var i = 0; i < ids.length; i++) {
                        grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
                    }

                    
            },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    Row = row;
                    ridmd = row["MessageID"];                    
                    
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    Row = row;
                   ridmd = row["MessageID"];
                   
                    ShowEditFormMD();
                },
                
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
                           deltext: "מחק",
                           refreshtext: "רענן",
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
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
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
        SetGrid();

        function SavePops()
        {
            $('#aPop').text($('#<%=ctlPopulationsR.hdnPopsID %>').val());
            if($('#aPop').text() == "")
            {
                $('#aPop').text("אוכלוסיות");
            }
        }

        function OnLoadMain()
        {
            $(".dtp").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy'
                });
                
                var d = new Date();

                var month = d.getMonth()+1;
                var day = d.getDate();

                var output =  (day<10 ? '0' : '') + day + '/' +
                    (month<10 ? '0' : '') + month + '/' +
                    d.getFullYear();
                
                $('.dtp1').val(output);
                $('.dtp2').val(output);
                //$('.txtDate').val("27/11/2014");
        }

    var counterr = 0;
    function SetInit(MessageID) {
   // debugger;
    if(MessageID)
    {
        if($('.cbtree').length==0)
        {
            setTimeout("SetInit('"+MessageID+"');",100);
            return;
        }
        var request;
        request = $.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_MSG_GetMSGPopulationJSON&MessageID=" + MessageID
                 + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            type: "get",
            data: ''
        });
        request.done(function (response, textStatus, jqXHR) {
           
            counterr = 0;
            
            for (var i = 0; i < $('.cbtree').length; i++) {
                $('.cbtree')[i].checked = false;
            }

             var PopulationTypeID="2";
            if(!isAgents)
                PopulationTypeID="1";


            //debugger;
            for (var e = 1; e < 5; e++) {
                for (var y = 1; y < 5; y++) {
                    for (var i = 0; i < response.length; i++) {
                        var UserID = response[i].UserID;
                        for (var t = UserID.length; t < 4; t++) {
                            UserID = '0' + UserID;
                        }
                        if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y)) {
                            document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).checked = true;

                            counterr++;

                            try {
                                document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.children[2].style.color = "orange";
                                if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                                    document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";

                                if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                                    document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";

                                if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                                    document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";

                                if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                                    document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + e + '*' + y).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";
                            }
                            catch (e) {

                            }
                        }
                    }
                }
            }
            SaveData();
        });

        var request2;
        request2 = $.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_Tasks_GetTsakPopulationParentsJSON&TaskID=" + MessageID
                 + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            type: "get",
            data: ''
        });
        request2.done(function (response, textStatus, jqXHR) {
            for (var i = 0; i < response.length; i++) {
                if (document.getElementById('ctlPopulationsR_cb_' + response[i].ParentPopulation))
                    document.getElementById('ctlPopulationsR_cb_' + response[i].ParentPopulation).checked = true;
            }

            $('#tabAgents').tree('collapseAll');
            $('#tabCustomers').tree('collapseAll');
            $('#tabItems').tree('collapseAll');
            $('#tabCategories').tree('collapseAll');
        });

        request2.fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 200) {
            }
            else {
                alert("אראה שגיאה בשליפת הנתונים");
                //alert("Error");
            }
        });
        }
    }
        OnLoadMain();

        $('#dBodyr').height($(document).height());
    </script>
    </form>
</body>
</html>
