<%@ Page Title="עריכת דוחות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="WidgetsEdit.aspx.cs" Inherits="Pages_Admin_GridsEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
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
        </table>
       <%-- <div style="padding-top: 20px; padding-left: 10px;">
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
    <script language="javascript" type="text/javascript">
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


                
                  $('#editmodjQGrid').width("600px");
                

                var row = $('#jQGrid').jqGrid('getRowData', id);
          
                   $("#jQGridMasterDetails").jqGrid('GridUnload');
                    SetMasterDetailsGrid(row['<%=strGridColID %>']);
                    GridID = row['<%=strGridColID %>'];
                    if($("#sData").length>0)
                    {
                        $("#sData")[0].style.display="block"; 
                        $('#sData')[0].style.width="40px";
                        $('#sData')[0].parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.style.width="300px";
                    }
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
                               widgetid: function () {
                                   
                                       $("#cData")[0].innerText = "Close";
                                       $("#sData")[0].style.display="none"; 
                                                                            
                                       var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                       var value = $('#jQGrid').jqGrid('getCell', sel_id, 'widgetid');
                                      
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
                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               widgetID: function () {
                                 
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'widgetid');
                                   
                                   return value;
                               }
                           }
                       },
                       {//SEARCH
                           closeOnEscape: true

                       }
                );

            }
            function SetMasterDetailsGrid(id)
            {
         
                   
//                    $("#jQGridMasterDetails").jqGrid({
//                    url: "../../Handlers/MainHandler.ashx?MethodName=GridDataNew&id="+id+"&GridName=<%=GridNameMD %>&GridParameters=<%=GridParametersMD %>",
//                    datatype: "json",
//                     direction: "rtl",
//                    colNames: <%=colNamesMD %>,
//                    colModel: [<%= colModelMD%>],
//                    rowNum:<%=RowsModel %>,
//                    mtype: 'POST',
//                    loadonce: true,
//                    rowList: [10, 20, 30],
//                    pager: '#jQGridPagerMasterDetails',
//                    sortname: '_id',
//                    viewrecords: true,
//                    sortorder: 'asc',
//                    caption: "<%=CaptionMD %>",
//                    loadComplete: function(data) {
//                            setTimeout(initww,50);
//                            initwData(data,$("#jQGridMasterDetails"));
//                           
//                        },
//                    onSelectRow:  function(id) {
//                            if($("#sData").length>0)
//                            {
//                                $("#sData")[0].style.display=""; 
//                                $('#sData')[0].style.width="40px";
//                            }
//                        },
//                    editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGridCols&gridid='+id
//                });
//        
//                $('#jQGridMasterDetails').jqGrid('navGrid', '#jQGridPagerMasterDetails',
//                           {
//                               edit: true,
//                               add: true,
//                               del: true,
//                               search: true,
//                               searchtext: "חיפוש",
//                               addtext: "הוסף",
//                               edittext: "ערוך",
//                               deltext: "מחק",
//                               refreshtext:"רענן"                              
//                           },
//                           {   //EDIT
//                               //                       height: 300,
//                               //                       width: 400,
//                               //                       top: 50,
//                               //                       left: 100,
//                               //                       dataheight: 280,
//                               closeOnEscape: true, //Closes the popup on pressing escape key
//                               reloadAfterSubmit: true,
//                               closeAfterEdit: true,
//                               clearAfterAdd: true,
//                               drag: true,
//                               
//                               afterSubmit: function (response, postdata) {
//                               
//                                if(response.responseText.indexOf('בהצלחה')>-1)
//                                    ShowMSGT();
//                                
//                                    //alert('ui-state-error');
//                                   if (response.responseText == "") {

//                                       $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
//                                       return [true, '']
//                                   }
//                                   else {
//                                       $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
//                                       return [false, response.responseText]//Captures and displays the response text on th Edit window
//                                   }
//                                  
//                               },
//                               editData: {
//                                   id: function () {
//                                   
//                                       $("#cData")[0].innerText = "Close";
//                                       $("#sData")[0].style.display="none"; 
//                                                                            
//                                       var sel_id = $('#jQGridMasterDetails').jqGrid('getGridParam', 'selrow');
//                                       var value = $('#jQGridMasterDetails').jqGrid('getCell', sel_id, 'id');
//                                      
//                                       return sel_id;
//                                   },
//                                   widgetid: function () {
//                                   
//                                       $("#cData")[0].innerText = "Close";
//                                       $("#sData")[0].style.display="none"; 
//                                                                            
//                                       var sel_id = $('#jQGridMasterDetails').jqGrid('getGridParam', 'selrow');
//                                       var value = $('#jQGridMasterDetails').jqGrid('getCell', sel_id, 'widgetid');
//                                      
//                                       return value;
//                                   },
//                                   gridid: function () {
//                                  
//                                   return getCellGridsColsValue();
//                               },
//                               }
//                           },
//                           {
//                               closeAfterAdd: true, //Closes the add window after add
//                               afterSubmit: function (response, postdata) {
////                                    $("#cData")[0].innerText = "Close";
////                                    $("#sData")[0].style.display="none"; 
//                                    if(response.responseText.indexOf('בהצלחה')>-1)
//                                            ShowMSGT();
//                                   if (response.responseText == "") {
//                                        
//                                       $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
//                                       return [true, '']
//                                   }
//                                   else {
//                                       $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
//                                       return [false, response.responseText]
//                                   }
//                               }
//                           },
//                           {   //DELETE
//                               closeOnEscape: true,
//                               closeAfterDelete: true,
//                               reloadAfterSubmit: true,
//                               closeOnEscape: true,
//                               drag: true,
//                               
//                               afterSubmit: function (response, postdata) {
//                                   if (response.responseText == "") {

//                                       $("#jQGrid").trigger("reloadGrid", [{ current: true}]);
//                                       return [false, response.responseText]
//                                   }
//                                   else {
//                                       $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
//                                       return [true, response.responseText]
//                                   }
//                               },
//                               delData: {
//                                   EmpId: function () {
//                                       var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
//                                       var value = $('#jQGrid').jqGrid('getCell', sel_id, '_id');
//                                       return value;
//                                   }
//                               }
//                           },
//                           {//SEARCH
//                               closeOnEscape: true

//                           }
//                    );
//                     $("#jQGridMasterDetails").trigger("reloadGrid");
                }
            function initww(data)
            {        
                $('.ui-jqgrid-titlebar').first().css("padding-left",<%=GridWidth.ToString() %> - "<%=Caption %>".length*5.0 - 25 * 1.0 +"px");
                $('.ui-jqgrid-titlebar').last().css("padding-left",<%=GridWidth.ToString() %> - "<%=CaptionMD %>".length*5.0 - 25 * 1.0 +"px");
            }
            var ColSelected = '';
            var ColSelected2 = '';
            function initwData(data,objMain)
            {     
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
 
        $('#nMimshak').attr("class", "menuLink Selected");
        $.jgrid.del.msg = "מחק שורה?";

        function ShowWin(obj) {
            var gridName = $('#' + obj.id + ' option:selected').text();
            window.open("http://<%=System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() %>/MobiPlusWeb/Pages/Usr/GridViewNew.aspx?GridName=" + gridName + "&GridParameters=");
        }
    </script>
</asp:Content>
