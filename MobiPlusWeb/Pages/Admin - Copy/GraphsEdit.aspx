<%@ Page Title="עריכת דוחות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="GraphsEdit.aspx.cs" Inherits="Pages_Admin_GridsEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
       <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        
    </style>
     <script type="text/javascript">
         function closeWin(id) {
             var top = 100;
             $("#" + id).css({ top: top })
                    .animate({ "top": "-500" }, "slow");

         }
         var IsAdd = false;
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="padding-top: 10px;" id="dBody">
        <center>
            <table id="jQGrid">
            </table>
            <div id="jQGridPager">
            </div>
            <div style="text-align: right; padding-right: 10px; padding-top: 10px; width: 746px;">
                <input type="button" id="btnWidget" value="צור דוח" class="EditWin btn" onclick="SetNewWidget();"
                    style="display: none;" />
            </div>
        </center>
    </div>
      <center>
        <div id="divEditWin" class="EditWinBoxGraphs">
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
                            <%=StrSrc("EditWinGraphType") %>
                        </td>
                        <td class="EditWin val">
                            <asp:DropDownList runat="server" ID="ddlGraphType" Width="134px">
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
    <input type="hidden" id="hdnQuery"/>
    <script language="javascript" type="text/javascript">
       function SetNewWidget() {
            if (rid == "" || rid == "0") {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                return false;
            }
           
            var row = $('#jQGrid').jqGrid('getRowData', rid);
            var request;
            var url ="";
            
            var q = "";
            switch(row.QueryType)  
            {       
             case "Query":                                  
                    q = "&Query=" + escape(row.GraphQuery); 
                break;
             case "Stored procedure":
                    q = "&SPName=" + escape(row.GraphQuery);
                break;
                case "View":                
                    q = "&View=" + escape(row.GraphQuery);     
                break;
            }
            $('#hdnQuery').val(row.GraphQuery);
            switch(row.GraphType)  
            {
             case "Pie":                                       
                    url ="../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets&id=0&widgetid=0&name=" + escape(row.GraphPromt) + "&path=" + escape("../Graphs/RGPieView.aspx?MethodName=GetPieRep&GraphID="+row.GraphID+"&Caption=" + row.GraphPromt + q + "&iDate=20140610&AgentID=0")+"&GroupName=4&Tiks=<%= DateTime.Now.Ticks.ToString()%>";
                break;
             case "Bar":
                    url ="../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets&id=0&widgetid=0&name=" + escape(row.GraphPromt) + "&path=" + escape("../Graphs/RGBarView.aspx?MethodName=GetRGBarData&GraphID="+row.GraphID+"&Caption=" + row.GraphPromt + q + "&iDate=2014226&AgentID=0")+"&GroupName=4&Tiks=<%= DateTime.Now.Ticks.ToString()%>";
                break;
             case "Line":                
                    url ="../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets&id=0&widgetid=0&name=" + escape(row.GraphPromt) + "&path=" + escape("../Graphs/LineView.aspx?MethodName=GetLineData&GraphID="+row.GraphID+"&Caption=" + row.GraphPromt + q + "&iDate=2014226&AgentID=0")+"&GroupName=4&Tiks=<%= DateTime.Now.Ticks.ToString()%>";
                break;
             case "Meter":                
                    url ="../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets&id=0&widgetid=0&name=" + escape(row.GraphPromt) + "&path=" + escape("../Graphs/MeterChart.aspx?MethodName=GetSalesMeterChart&GraphID="+row.GraphID+"&Caption=" + row.GraphPromt + q + "&Date=2014226&AgentID=0")+"&GroupName=4&Tiks=<%= DateTime.Now.Ticks.ToString()%>";
                break;
            }
            var  formData = "name1=ravi&age1=31";

                request = $.ajax({
                    url: url,
                    //contentType: "application/json; charset=utf-8",
                    type: "POST",
                    //data: "{'QueryStr':'"+escape(row.GraphQuery)+"'}"
                    data: formData
                
                });
                request.done(function (response, textStatus, jqXHR) {
                    //alert("הדוח נוצר בהצלחה");
                    ridmd = "";
                    rid = "";
                    ShowWinR(row.GraphType,row.GraphPromt,row.GraphQuery,row.QueryType,row.GraphID);
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        //alert("הדוח נוצר בהצלחה");
                        ridmd = "";
                        rid = "";

                        ShowWinR(row.GraphType,row.GraphPromt,row.GraphQuery,row.QueryType,row.GraphID);
                    }
                    else {
                        alert("Error");
                    }
                });
        }
         function ShowWinR(GraphType,GraphPromt,GraphQuery,QueryType,GraphID) {
            var q = "";
//            switch(QueryType)  
//            {       
//             case "Query":                                  
//                    q = "&Query=" + escape(GraphQuery);     
//                break;
//             case "Stored procedure":
//                    q = "&SPName=" + escape(GraphQuery);
//                break;
//                case "View":                
//                    q = "&View=" + escape(GraphQuery);     
//                break;
//            }
            switch(GraphType)  
            {
                case "Pie":                    
                    window.open("../../Pages/Graphs/RGPieView.aspx?MethodName=GetPieRep&iDate=20140610&AgentID=0" + "&GraphID=" + GraphID + "&Caption="+escape(GraphPromt));
                break;
                case "Bar":
                    window.open("../../Pages/Graphs/RGBarView.aspx?MethodName=GetRGBarData&iDate=20140226&AgentID=0" + "&GraphID=" + GraphID + "&Caption="+escape(GraphPromt) );
                break;
                case "Line":
                    window.open("../../Pages/Graphs/LineView.aspx?MethodName=GetLineData&iDate=20140226&AgentID=0" + "&GraphID=" + GraphID + "&Caption="+escape(GraphPromt));
                break;
                case "Meter":
                    window.open("../../Pages/Graphs/MeterChart.aspx?MethodName=GetSalesMeterChart&Date=20140710&AgentID=0" + "&GraphID=" + GraphID + "&Caption="+escape(GraphPromt));
                break;

            }
            
        }
        function ShowMSGT()
        {
            $('#FormError')[0].innerHTML ="<td class='MsgT' colspan='2'>הגריד נערך בהצלחה</td>";
        }
        function PassFormatter(cellValue, options, rowObject) {
            return "********";
        }
        var Grids="";
        var Alignment="";
        var Types="";
        var QueryTypes="";
        var GroupNames="";

        function initTt()
        {
            $.getJSON("../../Handlers/MainHandler.ashx?MethodName=GroupNames", null, function (data) {
                if (data != null) {
                    var Str = "";
                    for (var i = 0; i < data.length; i++) {
                        if (i > 0)
                            Str += ";" + data[i].id + ":" + unescape(data[i].GroupName);
                        else
                            Str += data[i].id + ":" + unescape(data[i].GroupName);
                    }
                    GroupNames = Str;
                    QueryTypesGet();
                }
            }); 
        }
        function QueryTypesGet()
        {
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
        
         function getCellGroupNameValue() {         
            return $('#GroupName').val();
        }
         function getGroupNames() {
      
            return GroupNames;
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
        var rid="";
        //GraphID, GraphName, GraphQuery, QueryType, GraphParameters, GraphPromt
        function ShowGrid()
        {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetGraphsForGrid",
                datatype: "json",
                 direction: "rtl",
                colNames: ['#','שם','שאילתה','סוג שאילתה','פרמטרים','כותרת','סוג גרף'],
                colModel: [{ name: 'GraphID', index: 'GraphID', width: 47.575, sorttype: 'int', align: 'right', editable: true},
                            { name: 'GraphName', index: 'GraphName', width: 142.725, sorttype: 'text', align: 'right', editable: true},
                            { name: 'GraphQuery', index: 'GraphQuery', width: 237.875, sorttype: 'text', align: 'right', editable: true},
                            { name: 'QueryType', index: 'QueryType', width: 95.15, sorttype: 'text', align: 'right', editable: true,edittype: 'select',editoptions:{ value: getQueryTypes() }, editrules: { required: true }},
                            { name: 'GraphParameters', index: 'GraphParameters', width: 95.15, sorttype: 'text', align: 'right', editable: true},
                            { name: 'GraphPromt', index: 'GraphPromt', width: 95.15, sorttype: 'text', align: 'right', editable: true},
                            { name: 'GraphType', index: 'GraphType', width: 95.15, sorttype: 'text', align: 'right', editable: true}
                        ],
                rowNum: 25,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
               
                loadComplete: function(data) {
                        setTimeout(initww,5);
                        initwData(data,$("#jQGrid"));
                    },
             
                onSelectRow:  function(id) {

                    rid = id;
                
                    var row = $('#jQGrid').jqGrid('getRowData', id);          
                },
            
                editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets'
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
                           refreshtext:"רענן",
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
                               $("#sData")[0].style.display="block";   
                               
                           },
                           
                           editData: {
                               id: function () {
                                   $("#cData")[0].innerText = "Close";
                                   $("#sData")[0].style.display="none";   
                                   
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');
                                   
                                   return value;
                               },
                               GraphID: function () {
                                   
                                       $("#cData")[0].innerText = "Close";
                                       $("#sData")[0].style.display="none"; 
                                                                            
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
                           if(response.responseText.indexOf('בהצלחה')>-1)
                                    ShowMSGT();
                            $("#cData")[0].innerText = "Close";
                                   $("#sData")[0].style.display="none"; 
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
        
            function SaveData() {
                if (IsAdd)
                    rid = "0";
                var row = $('#jQGrid').jqGrid('getRowData', rid);     
                var request;
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGraph&id=" + rid + "&GraphID=" + row.GraphID +"&Name=" + escape($('#<%= txtName.ClientID%>').val()) + "&Query=" + escape($('#<%= txtQuery.ClientID%>').val()) + "&QueryType=" + escape($('#<%= ddlQueryType.ClientID%>').val()) +
                "&Params=" + escape($('#<%= txtParams.ClientID%>').val()) + "&Promt=" + escape($('#<%= txtPromt.ClientID%>').val()) + "&GraphType=" + escape($('#<%= ddlGraphType.ClientID%>').val()) + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
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
            function setData(id)
             {            
                if(id != "")
                {
                    var row = $('#jQGrid').jqGrid('getRowData', id);
                   $('#<%= txtName.ClientID%>').val(row.GraphName);

                   $('#<%= txtPromt.ClientID%>').val(row.GraphPromt);
                   $('#<%= txtQuery.ClientID%>').val(row.GraphQuery);
                   $('#<%= ddlQueryType.ClientID%>').val(row.QueryType);
                   $('#<%= txtParams.ClientID%>').val(row.GraphParameters);
                   $('#<%= ddlGraphType.ClientID%>').val(row.GraphType);

                   $('.EditWinHead')[0].innerText="<%=StrSrc("EditWinHead") %>";
               }
               else
               {
                  $('#<%= txtName.ClientID%>').val("");

                   $('#<%= txtPromt.ClientID%>').val("");
                   $('#<%= txtQuery.ClientID%>').val("");
                   $('#<%= txtParams.ClientID%>').val("");
                   $('#<%= ddlGraphType.ClientID%>').val("Pie");
                   $('.EditWinHead')[0].innerText="<%=StrSrc("EditWinAddRow") %>";
               }
         
             }
            function DisableWin()
             {            
                $('#dBody').block({ message: '<%=StrSrc("EditWinEditMsg") %>' });           
             }
              function ShowAddForm() {

                    IsAdd = true;
                    DisableWin();
                    setData("");
                    $('.EditWinBoxGraphs').css("display", "block");
                    var top = 500;
                    $("#divEditWin").css({ top: top })
                                .animate({ "top": "100px" }, "slow");

                    return false;
                }

            function ShowEditForm() {
                if (rid != "") {
                    IsAdd = false;
                    DisableWin();
                    setData(rid);
                    $('.EditWinBoxGraphs').css("display", "block");
                    var top = 500;
                    $("#divEditWin").css({ top: top })
                            .animate({ "top": "100px" }, "slow");
                }
                else {
                    alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                }
                return false;
            }
            function ShowDeleteForm() {
                var row = $('#jQGrid').jqGrid('getRowData', rid);     
                $('.EditWinBoxGraphs').css("display", "none");
                if (rid == "" || rid == "0") {
                    alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                    return false;
                }
                if (confirm("<%=StrSrc("EditWinDelConfirm") %>")){
                    var request;
                    request = $.ajax({
                        url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGraph&id=" + rid + "&GraphID=" + row.GraphID +"&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
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
            function UpdatedSuccessfuly()
             {
                 $("#dBody").unblock();             
                 Refresh();
                 closeWin("divEditWin");
             }
            function Refresh()
             {
                $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
             }
            function doNone()
            {
                return false;
            }
             function ShowSearchForm()
            {
                $("#jQGrid").searchGrid({ closeAfterSearch: false });
            }
            function initww(data)
            {        
                $('.ui-jqgrid-titlebar').first().css("padding-left",<%=GridWidth.ToString() %> - "<%=Caption %>".length * 5.0 - 25 * 1.0 +"px");
                
                $(".ui-pg-div").click(doNone);
                $("#edit_jQGrid")[0].children[0].onclick = ShowEditForm;
                $("#add_jQGrid")[0].children[0].onclick = ShowAddForm;
                $("#del_jQGrid")[0].children[0].onclick = ShowDeleteForm;
                $("#search_jQGrid")[0].children[0].onclick = ShowSearchForm;
                $("#refresh_jQGrid")[0].children[0].onclick = Refresh;
            }
            var ColSelected = '';
            var ColSelected2 = '';
            function initwData(data,objMain)
            {     
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
                initTt();
    </script>
    <script type="text/javascript">
 
        $('#nGraphsEdit').attr("class", "menuLink Selected");
        $.jgrid.del.msg = "מחק שורה?";

        function ShowWin(obj) {
            var gridName = $('#' + obj.id + ' option:selected').text();
            window.open("http://<%=System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() %>/MobiPlusWeb/Pages/Usr/GridViewNew.aspx?GridName=" + gridName + "&GridParameters=");
        }
    </script>
</asp:Content>
