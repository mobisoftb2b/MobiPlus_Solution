<%@ Page Title="עריכת דוחות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="GridsEdit.aspx.cs" Inherits="Pages_Admin_GridsEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function closeWin(id) {
            var top = 100;
            $("#" + id).css({ top: top })
                    .animate({ "top": "-500" }, "slow");

        }
        var IsAdd = false;
        var IsAddMD = false;
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<iframe runat="server" id="iMain" src="../../Pages/Usr/GridViewNew.aspx?GridName=GridEditGrids&GridParameters=" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>--%>
    <div id="dBody" style="padding-top: 10px; text-align: right; direction: rtl; vertical-align: top;">
        <table cellpadding="0" cellspacing="0" width="90%" style="vertical-align: top;">
            <tr style="vertical-align: top;">
                <td style="vertical-align: top;">
                    <table id="jQGrid">
                    </table>
                    <div id="jQGridPager">
                    </div>
                </td>
                <td>
                    &nbsp;
                </td>
                <td style="vertical-align: top;">
                    <table id="jQGridMasterDetails">
                    </table>
                    <div id="jQGridPagerMasterDetails">
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding-right: 10px; padding-top: 10px;">
                    <input type="button" id="btnWidget" value="צור דוח" class="EditWin btn" onclick="SetNewWidget();"
                        style="display: none;" />
                </td>
            </tr>
        </table>
        <%--<div style="padding-top: 20px; padding-left: 10px;">
            <table cellpadding="2" cellspacing="2">
                <tr>
                    <td>
                        <%=StrSrc("SelectGrid") %>:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlGrids" onchange="ShowWin(this);">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>--%>
    </div>
    <center>
        <div id="divEditWin" class="EditWinBox">
            <div class="EditWinX">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfuly();" />
            </div>
            <div class="EditWinHead">
                <%=StrSrc("EditWinHead") %>
            </div>
            <div class="EditWinTbl">
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinName") %>
                        </td>
                        <td class="EditWin val">
                            <asp:TextBox runat="server" ID="txtName" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinPromt") %>
                        </td>
                        <td class="EditWin val">
                            <asp:TextBox runat="server" ID="txtPromt" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinQuery") %>
                        </td>
                        <td class="EditWin val leftt">
                            <asp:TextBox runat="server" ID="txtQuery" Width="250px" TextMode="MultiLine" Rows="5"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinQueryType") %>
                        </td>
                        <td class="EditWin val">
                            <asp:DropDownList runat="server" ID="ddlQueryType" Width="134px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinParams") %>
                        </td>
                        <td class="EditWin val">
                            <asp:TextBox runat="server" ID="txtParams" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinRows") %>
                        </td>
                        <td class="EditWin val">
                            <asp:TextBox runat="server" ID="txtRows" Width="30px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinCFilter") %>
                        </td>
                        <td class="EditWin val">
                            <asp:TextBox runat="server" ID="txtChieldParms" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinGridDetails") %>
                        </td>
                        <td class="EditWin val">
                            <asp:DropDownList runat="server" ID="ddlChildGrids" Width="134px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWin item">
                            <%=StrSrc("EditWinGridJump") %>
                        </td>
                        <td class="EditWin val">
                            <asp:DropDownList runat="server" ID="ddlJumpGrids" Width="134px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <div class="dBtns">
                    <center>
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td>
                                    <input type="button" id="btnEditWinCreatePass" value="<%=StrSrc("EditWinOKBtn") %>"
                                        class="EditWin btn" onclick="SaveData();" />
                                </td>
                            </tr>
                        </table>
                    </center>
                </div>
            </div>
        </div>
    </center>
    <center>
        <div id="divEditWinMDBox" class="EditWinMDBox">
            <div class="EditWinMDX">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfulyMD();" />
            </div>
            <div class="EditWinMDHead">
                <%=StrSrc("EditWinHead") %>
            </div>
            <div class="EditWinMDMsg">
            </div>
            <div class="EditWinMDTbl">
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDCol")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:TextBox runat="server" ID="txtCol" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDPromt")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:TextBox runat="server" ID="txtPromtMD" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDOrder")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:TextBox runat="server" ID="txtOrder" Width="30px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDWidth")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:TextBox runat="server" ID="txtWidth" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDColType")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:DropDownList runat="server" ID="ddlMDTypes" Width="134px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDAlign")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:DropDownList runat="server" ID="ddlMDAlign" Width="134px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="EditWinMD item">
                            <%=StrSrc("EditWinMDNewWin")%>
                        </td>
                        <td class="EditWinMD val">
                            <asp:TextBox runat="server" ID="txtNewWin" Width="130px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div class="dBtns">
                    <center>
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td>
                                    <input type="button" id="Button1" value="<%=StrSrc("EditWinMDBtn")%>" class="EditWinMD btn"
                                        onclick="SaveDataMD();" />
                                </td>
                            </tr>
                        </table>
                    </center>
                </div>
            </div>
        </div>
    </center>
    <script language="javascript" type="text/javascript">
  
        function Refresh()
         {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
         }
          function RefreshMD()
         {
            $('#jQGridMasterDetails').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
         }
    function setData(id)
         {
            if(id != "")
            {
                var row = $('#jQGrid').jqGrid('getRowData', id);
               $('#<%= txtName.ClientID%>').val(row.gridname);

               $('#<%= txtPromt.ClientID%>').val(row.gridcaption);
               $('#<%= txtQuery.ClientID%>').val(row.gridquery);
               $('#<%= ddlQueryType.ClientID%>').val(row.querytype);
               $('#<%= txtParams.ClientID%>').val(row.gridparameters);
               $('#<%= txtRows.ClientID%>').val(row.rows);

               $('#<%= txtChieldParms.ClientID%>').val(row.childfiltercol);
               $('#<%= ddlChildGrids.ClientID%>').val(row.masterdetailsgridid);
               $('#<%= ddlJumpGrids.ClientID%>').val(row.jumgridid);

               $('.EditWinHead')[0].innerText="<%=StrSrc("EditWinHead") %>";
           }
           else
           {
              $('#<%= txtName.ClientID%>').val("");

               $('#<%= txtPromt.ClientID%>').val("");
               $('#<%= txtQuery.ClientID%>').val("");
               $('#<%= ddlQueryType.ClientID%>').val("");
               $('#<%= txtParams.ClientID%>').val("");
               $('#<%= txtRows.ClientID%>').val("");

               $('#<%= txtChieldParms.ClientID%>').val("");
               $('#<%= ddlChildGrids.ClientID%>').val("");
               $('#<%= ddlJumpGrids.ClientID%>').val("");

               $('.EditWinHead')[0].innerText="<%=StrSrc("EditWinAddRow") %>";
           }
         
         }
         var gridid="0";
         function setDataMD(id)
         {
            if(id!="")
            {            
                var row = $('#jQGridMasterDetails').jqGrid('getRowData', id);

                gridid = row.gridid;

                $('#<%= txtCol.ClientID%>').val(row.colname);
                $('#<%= txtPromtMD.ClientID%>').val(row.colpromt);
                $('#<%= txtOrder.ClientID%>').val(row.colorder);
                $('#<%= txtWidth.ClientID%>').val(row.colwidth);
                $('#<%= ddlMDTypes.ClientID%>').val(row.coltype);
                $('#<%= ddlMDAlign.ClientID%>').val(row.colalignment);
                $('#<%= txtNewWin.ClientID%>').val(row.colopenwindowbygridid);
           }
           else
           {
              $('#<%= txtCol.ClientID%>').val("");
                $('#<%= txtPromtMD.ClientID%>').val("");
                $('#<%= txtOrder.ClientID%>').val("");
                $('#<%= txtWidth.ClientID%>').val("");
                $('#<%= ddlMDTypes.ClientID%>').val("");
                $('#<%= ddlMDAlign.ClientID%>').val("");
                $('#<%= txtNewWin.ClientID%>').val("");
           }
         
         }
         function UpdatedSuccessfuly()
         {
             $("#dBody").unblock();             
             Refresh();
             closeWin("divEditWin");
         }
         function UpdatedSuccessfulyMD()
         {
             $("#dBody").unblock();             
             RefreshMD();
             closeWin("divEditWinMDBox");
         }
         function DisableWin()
         {            
            $('#dBody').block({ message: '<%=StrSrc("EditWinEditMsg") %>' });           
         }
         function ShowManualForm()
         {
            
            DisableWin();
           
            $('.ManualBox').css("display","block");
            var top =500;  
            $("#divManual").css({top:top})  
            .animate({"top":"100px"}, "slow");
            
         }
        function ShowMSGT()
        {
            $('#FormError')[0].innerHTML ="<td class='MsgT' colspan='2'><%=StrSrc("EditWinEditMsgSuccess") %></td>";
        }
        function PassFormatter(cellValue, options, rowObject) {
            return "********";
        }
        var Grids="";
        var Alignment="";
        var Types="";
        var QueryTypes="";

        function initTt()
        {
            
                $.getJSON("../../Handlers/MainHandler.ashx?MethodName=GetGrids", null, function (data) {
                if (data != null) {
                    var Str = "";
                    for (var i = 0; i < data.length; i++) {
                        if (i > 0)
                            Str += ";" + data[i].GridID + ":" + unescape(data[i].GridName);
                        else
                            Str += data[i].GridID + ":" + unescape(data[i].GridName);
                    }
                    Grids = Str;
               
                }
            });
            
                $.getJSON("../../Handlers/MainHandler.ashx?MethodName=GetAlignment", null, function (data) {
                if (data != null) {
                    var Str = "";
                    for (var i = 0; i < data.length; i++) {
                        if (i > 0)
                            Str += ";" + data[i].id + ":" + unescape(data[i].Alignment);
                        else
                            Str += data[i].id + ":" + unescape(data[i].Alignment);
                    }
                    Alignment = Str;                    
                }
            });  
                
                $.getJSON("../../Handlers/MainHandler.ashx?MethodName=GetTypes", null, function (data) {
                if (data != null) {
                    var Str = "";
                    for (var i = 0; i < data.length; i++) {
                        if (i > 0)
                            Str += ";" + data[i].id + ":" + unescape(data[i].Type);
                        else
                            Str += data[i].id + ":" + unescape(data[i].Type);
                    }
                    Types = Str;
               
                }
            });  
            
                $.getJSON("../../Handlers/MainHandler.ashx?MethodName=QueryTypes", null, function (data) {
                if (data != null) {
                    var Str = "";
                    for (var i = 0; i < data.length; i++) {
                        if (i > 0)
                            Str += ";" + data[i].id + ":" + unescape(data[i].QueryType);
                        else
                            Str += data[i].id + ":" + unescape(data[i].QueryType);
                    }
                    QueryTypes = Str;
                    setTimeout(ShowGrid,500);
                }
            });  

             
        }
        function getTypes() {
      
            return Types;
        }
        function getAlignment() {
        
            return Alignment;
        }     
         function getCellGridsColsValue() {         
            return $('#gridid').val();
        }
        function getGrids() {
            return Grids;
        }
         function getCellGridsValue() {
         
            return $('#masterdetailsgridid').val();
        }
        function getQueryTypes() {
            return QueryTypes;
        }
         function getCellQueryTypesValue() {
            return $('#querytype').val();
        }
        function hookDatePicker()
        {
        }
        var GridID="";
        function ShowGrid()
        {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GridDataNew&GridName=<%=GridName %>&GridParameters=<%=GridParameters %>",
                datatype: "json",
                 direction: "rtl",
                colNames: <%=colNames %>,
                colModel: [<%= colModel%>],
                rowNum: <%=Rows %>,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: "<%=Caption %>",
               
                loadComplete: function(data) {
                        setTimeout(initww,50);
                        initwData(data,$("#jQGrid"));
                    },
             
                onSelectRow:  function(id) {
                    rid=id;
                    var row = $('#jQGrid').jqGrid('getRowData', id);                    
                
                  $('#editmodjQGrid').width("300px");
                
                   $("#jQGridMasterDetails").jqGrid('GridUnload');
                    SetMasterDetailsGrid(row['<%=strGridColID %>']);
                    GridID = row['<%=strGridColID %>'];
                    if($("#sData").length>0)
                    {
                    
                        $("#sData")[0].style.display="block"; 
                        $("#sData")[0].style.width="70px";
                         //$('#editmodjQGrid').css("left","400px");
                        }
                },
              
                editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGrid'
            });
        
            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "<%=StrSrc("Search") %>",
                           addtext: "<%=StrSrc("Add") %>",
                           edittext: "<%=StrSrc("Edit") %>",
                           deltext: "<%=StrSrc("Delete") %>",
                           refreshtext:"<%=StrSrc("Refresh") %>"
                          
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
                           
                                if(response.responseText.indexOf('בהצלחה')>-1)
                                    ShowMSGT();
                               if (response.responseText == "") {

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [true, '']
                               }
                               else {
                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [false, response.responseText]//Captures and displays the response text on th Edit window
                               }
                               if($("#sData").length > 0)
                               {
                               
                                   $("#sData")[0].style.display="block";   
                                   $("#sData")[0].style.width="70px";
                                   //$('#editmodjQGrid').css("left","400px");
                               }
                           },
                           
                           editData: {
                               id: function () {
                                   $("#cData")[0].innerText = "Close";
                                   $("#sData")[0].style.display="none";   
                                   
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');
                                   
                                   return value;
                               },
                               QueryType: function () {
                                   return getCellQueryTypesValue();
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
            var rid="";
            var ridmd="";
            function SetMasterDetailsGrid(id)
            {
         
                   
                    $("#jQGridMasterDetails").jqGrid({
                    url: "../../Handlers/MainHandler.ashx?MethodName=GridDataNew&id="+id+"&GridName=<%=GridNameMD %>&GridParameters=<%=GridParametersMD %>",
                    datatype: "json",
                     direction: "rtl",
                    colNames: <%=colNamesMD %>,
                    colModel: [<%= colModelMD%>],
                    rowNum:<%=RowsModel %>,
                    mtype: 'POST',
                    loadonce: true,
                    rowList: [10, 20, 30],
                    pager: '#jQGridPagerMasterDetails',
                    sortname: '_id',
                    viewrecords: true,
                    sortorder: 'asc',
                    caption: "<%=CaptionMD %>",
                    loadComplete: function(data) {
                            setTimeout(initww,50);
                            initwData(data,$("#jQGridMasterDetails"));
                           
                        },
                    onSelectRow:  function(id) {
                            ridmd = id;
                            if($("#sData").length>0)
                                $("#sData")[0].style.display=""; 
                            $('#sData').width("40px");
                        },
                    editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGridCols&gridid='+id
                });
        
                $('#jQGridMasterDetails').jqGrid('navGrid', '#jQGridPagerMasterDetails',
                           {
                               edit: true,
                               add: true,
                               del: true,
                               search: true,
                               searchtext: "<%=StrSrc("Search") %>",
                               addtext: "<%=StrSrc("Add") %>",
                               edittext: "<%=StrSrc("Edit") %>",
                               deltext: "<%=StrSrc("Delete") %>",
                               refreshtext:"<%=StrSrc("Refresh") %>"
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
                               
                                if(response.responseText.indexOf('בהצלחה')>-1)
                                    ShowMSGT();
                                
                                    //alert('ui-state-error');
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
                                       $("#sData")[0].style.display="none"; 
                                                                            
                                       var sel_id = $('#jQGridMasterDetails').jqGrid('getGridParam', 'selrow');
                                       var value = $('#jQGridMasterDetails').jqGrid('getCell', sel_id, 'id');
                                      
                                       return sel_id;
                                   },
                                   gridid: function () {
                                  
                                   return getCellGridsColsValue();
                               }
                               }
                           },
                           {
                               closeAfterAdd: true, //Closes the add window after add
                               afterSubmit: function (response, postdata) {
                               if( $("#cData").length>0)
                                    $("#cData")[0].innerText = "Close";
                                if($("#sData").length > 0)
                                   $("#sData")[0].style.display="none"; 
//                                    $("#cData")[0].innerText = "Close";
//                                    $("#sData")[0].style.display="none"; 
                                    if(response.responseText.indexOf('בהצלחה')>-1)
                                            ShowMSGT();
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
                     $("#jQGridMasterDetails").trigger("reloadGrid");
                     
                }
            function initww(data)
            {        
                $('.ui-jqgrid-titlebar').first().css("padding-left",<%=GridWidth.ToString() %> - "<%=Caption %>".length*5.0 - 25 * 1.0 +"px");
                $('.ui-jqgrid-titlebar').last().css("padding-left",<%=GridWidth.ToString() %> - "<%=CaptionMD %>".length*5.0 - 25 * 1.0 +"px");
            }
            var ColSelected = '';
            var ColSelected2 = '';
            
            function doNone()
            {
                return false;
            }
            function initwData(data,objMain)
            {     
                $(".ui-pg-div").click(doNone);
                $("#edit_jQGrid")[0].children[0].onclick = ShowEditForm;
                $("#add_jQGrid")[0].children[0].onclick = ShowAddForm;
                $("#del_jQGrid")[0].children[0].onclick = ShowDeleteForm;
                $("#search_jQGrid")[0].children[0].onclick = ShowSearchForm;
                $("#refresh_jQGrid")[0].children[0].onclick = Refresh;
           
                if($("#edit_jQGridMasterDetails").length>0)
                {
                    $("#edit_jQGridMasterDetails")[0].children[0].onclick = ShowEditFormMD;
                    $("#add_jQGridMasterDetails")[0].children[0].onclick = ShowAddFormMD;
                    $("#del_jQGridMasterDetails")[0].children[0].onclick = ShowDeleteFormMD;
                    $("#search_jQGridMasterDetails")[0].children[0].onclick = ShowSearchFormMD;
                    $("#refresh_jQGridMasterDetails")[0].children[0].onclick = RefreshMD;
                }
            
            $('#btnWidget').css("display","block");
           // debugger;
               try{
                    var colID=0;
                    if(ColSelected=='' && ColSelected2=='')
                    {
                    $.each(data[0], function (key, value) {
                        if(key)
                        {
                            if(key.toLocaleString().indexOf('stylecolor')>-1)
                            {
                                if(key.toLocaleString().indexOf('stylecolor_')>-1)
                                {
                                    if(ColSelected=='')
                                        ColSelected = key.toLocaleString().substr(key.toLocaleString().indexOf('stylecolor_')+11,key.toLocaleString().length - (11 + key.toLocaleString().indexOf('stylecolor_')));
                                }
                            }
                            if(ColSelected=='')
                                colID++;
                       }
                    });
                  }
              
                if(data[0])
                {
                    for (var i = 0; i < data.length; i++) {
                        var obj = data[i];
                        if(obj['stylecolor_'+ColSelected])
                        {
                            if(obj['stylecolor_'+ColSelected]=='1')
                            {      
                                colID = 0;
                                var j=0;
                                $.each(data[0], function (key, value) {    
                                    if(key.toLocaleString().indexOf(ColSelected)>-1 && colID==0)              
                                        colID=j;
                                    j++;
                                });
                                setBGcolorsForCol(i+1,colID,obj.color,objMain);
                            }
                        
                        }
                        else
                        {
                            var t=0;
                            if(obj['stylecolor']=='1')
                            {
                                $.each(data[0], function (key, value) {                          
                                    setBGcolorsForCol(i+1,t,obj.color,objMain);
                                    t++;
                                });
                            }
                        }
                    }
                }
                else
                {
                    for (var i = 0; i < data.rows.length; i++) {
                        var obj = data.rows[i];
                        if(obj['stylecolor_'+ColSelected])
                        {
                            if(obj['stylecolor_'+ColSelected]=='1')
                            {      
                                colID = 0;
                                var j=0;
                                $.each(obj, function (key, value) {    
                                    if(key.toLocaleString().indexOf(ColSelected)>-1 && colID==0)              
                                        colID=j;
                                    j++;
                                });
                                setBGcolorsForCol(i+1,colID,obj.color,objMain);
                            }
                        
                        }
                        else
                        {
                            var t=0;
                            if(obj['stylecolor']=='1')
                            {
                                $.each(data.rows[0], function (key, value) {                          
                                    setBGcolorsForCol(i+1,t,obj.color,objMain);
                                    t++;
                                });
                            }
                        }
                    }
                }
                 //debugger;
                var ColSelected2='';
                var colID=0;
                if(data[0])
                {
                    $.each(data[0], function (key, value) {
                    
                        if(key.toLocaleString().indexOf('styleicon1')>-1)
                        {
                            ColSelected2 = key;
                        }
                        if(ColSelected2=='')
                            colID++;
                    });

                     for (var i = 0; i < data.length; i++) {
                        var obj = data[i];
                        if(obj['styleicon1'])
                        {
                            if(obj['styleicon1']=='1')
                            {      
                                colID = 0;
                                var j=0;
                           
                                setIconToRow(i+1,0,'Icon1',objMain);
                            }
                        
                        }                    
                    }
                }
                else
                {
                    $.each(data.rows[0], function (key, value) {
                    
                        if(key.toLocaleString().indexOf('styleicon1')>-1)
                        {
                            ColSelected2 = key;
                        }
                        if(ColSelected2=='')
                            colID++;
                    });
                    //debugger;
                    for (var i = 0; i < data.rows.length; i++)
                      {
                        var obj = data.rows[i];
                        if(obj['styleicon1'])
                        {
                            if(obj['styleicon1']=='1')
                            {      
                                colID = 0;
                                var j=0;
                           
                                setIconToRow(i+1 ,0,'Icon1',objMain);
                            }
                        
                        }                    
                    }
                }
               
               
                }
              catch(e)
              {
              
              }
            }
         function setBGcolorsForCol(row,col,color,obj)
         {
            obj.setCell (row,col,'',{ 'background-color':color});
         }  
          function setBGcolorsForAllCol(col,color)
          {
             for (var i = 1; i <= $("#jQGrid").getGridParam("reccount"); i++) {
                $('#jQGrid').setCell (i,col,'',{ 'background-color':color});
             }    
         }
         function setIconToCol(col,iconr,obj)
         {
            var icon = '';
            switch(iconr)
            {
                case "Icon1":
                    icon = 'url(\"../../img/logout.png"\)';
                    break;
            }
            
            for (var i = 1; i <= obj.getGridParam("reccount"); i++) {
                obj.setCell (i,col,'',{ 'background-image':icon});
                obj.setCell (i,col,'',{ 'background-repeat':'no-repeat'});
            }
         }  
          function setIconToColAll(row,col,color,obj)
         {
            for (var i = 1; i <= obj.getGridParam("reccount"); i++) {
                obj.setCell (row,col,'',{ 'background-color':color});
             }  
         }  
          function setIconToRow(row,col,iconr,obj)
         {
                var icon = '';
                switch(iconr)
                {
                    case "Icon1":
                        icon = 'url(\"../../img/logout.png"\)';
                        break;
                }
                obj.setCell (row,col,'',{ 'background-image':icon});
                obj.setCell (row,col,'',{ 'background-repeat':'no-repeat'});
         }  
    </script>
    <script type="text/javascript">
        initTt();
        $('#nDohot').attr("class", "menuLink Selected");
        $.jgrid.del.msg = "מחק שורה?";

        function ShowWin(obj) {
            var gridName = $('#' + obj.id + ' option:selected').text();
            window.open("../../Pages/Usr/GridViewNew.aspx?GridName=" + gridName + "&GridParameters=");
        }
        function ShowWinR(gridName) {
            window.open("../../Pages/Usr/GridViewNew.aspx?GridName=" + gridName + "&GridParameters=Date:20140205;AgentID:0");
        }
        function ShowEditForm() {
            if (rid != "") {
                IsAdd = false;
                DisableWin();
                setData(rid);
                $('.EditWinBox').css("display", "block");
                var top = 500;
                $("#divEditWin").css({ top: top })
                        .animate({ "top": "100px" }, "slow");
            }
            else {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
            }
            return false;
        }

        function ShowAddForm() {

            IsAdd = true;
            DisableWin();
            setData("");
            $('.EditWinBox').css("display", "block");
            var top = 500;
            $("#divEditWin").css({ top: top })
                        .animate({ "top": "100px" }, "slow");

            return false;
        }

        function ShowDeleteForm() {
            $('.EditWinBox').css("display", "none");
            if (rid == "" || rid == "0") {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                return false;
            }
            if (confirm("<%=StrSrc("EditWinDelConfirm") %>")){
                var request;
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGrid&id=" + rid + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "get",
                    data: ''
                });
                request.done(function (response, textStatus, jqXHR) {
                    Refresh();
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        Refresh();
                    }
                    else {
                        alert("Error");
                    }
                });
            }
            return false;
        }

        function ShowEditFormMD() {
            $('.EditWinMDMsg')[0].innerText = "";
            if (ridmd != "") {
                IsAddMD = false;
                DisableWin();
                setDataMD(ridmd);
                $('.EditWinMDBox').css("display", "block");
                var top = 500;
                $("#divEditWinMDBox").css({ top: top })
                        .animate({ "top": "100px" }, "slow");
            }
            else {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
            }
            return false;
        }
        function ShowAddFormMD() {
            $('.EditWinMDMsg')[0].innerText = "";
            IsAddMD = true;
            DisableWin();
            setDataMD("");
            $('.EditWinMDBox').css("display", "block");
            var top = 500;
            $("#divEditWinMDBox").css({ top: top })
                        .animate({ "top": "100px" }, "slow");

            return false;
        }
        function ShowDeleteFormMD() {
            $('.EditWinBox').css("display", "none");
            if (ridmd == "" || ridmd == "0") {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                return false;
            }
            if (confirm("<%=StrSrc("EditWinDelConfirm") %>")) {
                var request;
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGridCols&id=" + ridmd + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "get",
                    data: ''
                });
                request.done(function (response, textStatus, jqXHR) {
                    ridmd = "";
                    RefreshMD();
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        ridmd = "";
                        RefreshMD();
                    }
                    else {
                        alert("Error");
                    }
                });

            }
            return false;
        }
        function ShowSearchForm()
        {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function ShowSearchFormMD()
        {
            $("#jQGridMasterDetails").searchGrid({ closeAfterSearch: false });
        }
        $('#<%=txtRows.ClientID %>').keypress(function (event) {

            if (event.which != 8 && isNaN(String.fromCharCode(event.which))) {
                event.preventDefault(); //stop character from entering input
            }
        });
        $('#<%=txtRows.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });

        $('#<%=txtOrder.ClientID %>').keypress(function (event) {

            if (event.which != 8 && isNaN(String.fromCharCode(event.which))) {
                event.preventDefault(); //stop character from entering input
            }
        });
        $('#<%=txtOrder.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });

        function SaveData() {
            if (IsAdd)
                rid = "0";
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGrid&id=" + rid + "&gridname=" + escape($('#<%= txtName.ClientID%>').val()) + "&gridquery=" + escape($('#<%= txtQuery.ClientID%>').val()) + "&QueryType=" + escape($('#<%= ddlQueryType.ClientID%>').val()) +
            "&gridparameters=" + escape($('#<%= txtParams.ClientID%>').val()) + "&gridcaption=" + escape($('#<%= txtPromt.ClientID%>').val()) + "&childfiltercol=" + escape($('#<%= txtChieldParms.ClientID%>').val()) + "&masterdetailsgridid=" + escape($('#<%= ddlChildGrids.ClientID%>').val()) +
            "&jumpgridid=" + escape($('#<%= ddlJumpGrids.ClientID%>').val())+
            "&rows=" + escape($('#<%= txtRows.ClientID%>').val()) + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                UpdatedSuccessfuly();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    UpdatedSuccessfuly();
                }
                else {
                    alert("Error");
                }
            });
        }
        function SaveDataMD() {
            if (IsAddMD)
                ridmd = "0";
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGridCols&gridid=" + rid + "&id=" + ridmd + "&colname=" + escape($('#<%= txtCol.ClientID%>').val()) + "&colpromt=" + escape($('#<%= txtPromtMD.ClientID%>').val()) + "&colorder=" + escape($('#<%= txtOrder.ClientID%>').val()) +
            "&colwidth=" + escape($('#<%= txtWidth.ClientID%>').val()) + "&coltype=" + escape($('#<%= ddlMDTypes.ClientID%>').val()) + "&colalignment=" + escape($('#<%= ddlMDAlign.ClientID%>').val()) + "&colopenwindowbygridid=" + escape($('#<%= txtNewWin.ClientID%>').val()) +
            "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                if (!IsAddMD)
                    UpdatedSuccessfulyMD();
                else {
                    $('.EditWinMDMsg')[0].innerText = "<%=StrSrc("EditWinRowAdded") %>";
                    setDataMD("");
                    RefreshMD();
                }
                ridmd = "";
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (!IsAddMD)
                        UpdatedSuccessfulyMD();
                    else {
                        $('.EditWinMDMsg')[0].innerText = "<%=StrSrc("EditWinRowAdded") %>";
                        setDataMD("");
                        RefreshMD();
                    }
                    ridmd = "";
                }
                else {
                    $('.EditWinMDMsg')[0].innerText = "<%=StrSrc("EditWinErrorMsg") %>";
                }
            });
        }
        function SetNewWidget() {
            if (rid == "" || rid == "0") {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                return false;
            }
            /*   WidgetID = context.Request["widgetid"].ToString();
            WidgetName = context.Request["name"].ToString();
            Path = context.Request["path"].ToString();
            GroupID = context.Request["GroupName"].ToString();*/
            var row = $('#jQGrid').jqGrid('getRowData', rid);
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets&id=0&widgetid=0&name=" + escape(row.gridcaption) + "&path=" + escape("GridViewNew.aspx?GridName=" + row.gridname + "&GridParameters=Date:20140205;AgentID:0") + "&GroupName=4&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                //alert("הדוח נוצר בהצלחה");
                ridmd = "";
                rid = "";
                ShowWinR(row.gridname);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    //alert("הדוח נוצר בהצלחה");
                    ridmd = "";
                    rid = "";

                    ShowWinR(row.gridname);
                }
                else {
                    alert("Error");
                }
            });
        }
    </script>
</asp:Content>
