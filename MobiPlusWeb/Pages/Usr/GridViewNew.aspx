<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GridViewNew.aspx.cs" Inherits="Pages_Usr_GridView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MobiPlus GridView</title>
    <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script type="text/javascript">
        function DoStart() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetPositiopnDocument&ScreenWidth=" + $(document).width() + "&ScreenHeight=" + $(document).height(),
                type: "Get",
                data: '',
                success: function () {
                    window.location.reload();
                },
                error: function () {
                    window.location.reload();
                }
            });


        }
        function DoStartWin() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetPositiopnWin&ScreenWidth=" + $(window).width() + "&ScreenHeight=" + $(window).height(),
                type: "Get",
                data: '',
                success: function () {
                    window.location.reload();
                },
                error: function () {
                    window.location.reload();
                }
            });
        }
    </script>
    <style type="text/css">
        .ui-widget-header
        {
            background: #888A83 !important;
        }
        .ui-jqgrid-sortable
        {
            color: #21225E !important;
        }
        .ui-tabs-anchor
        {
            color: #21225E !important;
        }
        .ui-tabs-anchor:hover
        {
            color: #ECEDEE !important;
            background: #3655A5 !important;
            
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
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
    </div>
    <script language="javascript" type="text/javascript">
    function Refresh() {
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=GridDataNew&GridName=<%=GridName %>&GridParameters=<%=GridParameters %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    data: "{}",
                    dataType: "json",
                    type: "get",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        jQuery("#jqGrid").jqGrid('setGridParam', { data: data }).trigger('reloadGrid');
                    }
                });

                //$('#jqGrid').setGridParam({ page: 1, datatype: "json", search: false }).trigger('reloadGrid');
            }
      jQuery(function($) {
           
            $(document).mousemove(function(event) {
                try{
                    var pageY=event.pageY;
                   
                    parent.setParentY(pageY);               
                }
                catch(e)
                {
                }
            });

            // ELSEWHERE, your code that needs to know the mouse position without an event
            
        });
        function PassFormatter(cellValue, options, rowObject) {
            return "********";
        }
         function FloatFormatter(cellValue, options, rowObject) {
            return formatMoney(cellValue,0);// + " ₪";
        }
        function PercentFormatter(cellValue, options, rowObject) {
            if(cellValue>0)
                return "<div style='color:"+rowObject.color+";font-weight:700;'>"+ formatMoney(cellValue,0).replace("-","") + "%" + (cellValue.toString().indexOf("-")>-1 ? "-" : "") + "</div>";
            else
                return "<div style='color:"+rowObject.color2+";font-weight:700;'>"+ formatMoney(cellValue,0).replace("-","") + "%" + (cellValue.toString().indexOf("-")>-1 ? "-" : "") + "</div>";
        }
        function TextDesignedFormatter(cellValue, options, rowObject) {
            return "<div style='font-weight:700;'>"+ cellValue + "</div>";
        }
        function NumbersFormatter(cellValue, options, rowObject) {
            return formatMoney(cellValue,0)
        }


         var lastSelArrRow = [],
            lastScrollLeft = 0,
            lastSelRow = null,
            saveSelection = function () {
                var $grid = $(this);
                lastSelRow = $grid.jqGrid('getGridParam', 'selrow');
                lastSelArrRow = $grid.jqGrid('getGridParam', 'selrow');
                lastSelArrRow = lastSelArrRow ? $.makeArray(lastSelArrRow) : null;
                lastScrollLeft = this.grid.bDiv.scrollLeft;
            },
            restoreSelection = function () {
                var p = this.p,
                    $grid = $(this);

                p.selrow = null;
                p.selarrrow = [];
                if (p.multiselect && lastSelArrRow && lastSelArrRow.length > 0) {
                    for (i = 0; i < lastSelArrRow.length; i++) {
                        if (lastSelArrRow[i] !== lastSelRow) {
                            $grid.jqGrid("setSelection", lastSelArrRow[i], false);
                        }
                    }
                    lastSelArrRow = [];
                }
                if (lastSelRow) {
                    $grid.jqGrid("setSelection", lastSelRow, false);
                    lastSelRow = null;
                }
                this.grid.bDiv.scrollLeft = lastScrollLeft;
            };


        var USERDATA={"total":1234,"name":"Totals"};
        $("#jQGrid").jqGrid({
            url: "../../Handlers/MainHandler.ashx?MethodName=GridDataNew&GridName=<%=GridName %>&GridParameters=<%=GridParameters %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            datatype: "json",
            autoencode: false,
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
            caption: "&nbsp;",
            footerrow : true,
            userDataOnFooter: true, 
            
            gridComplete: function(data) {
                      
                var $grid = $('#jQGrid');
                var colSum = $grid.jqGrid('getCol', 'Cust_Key', false, 'sum');
                $grid.jqGrid('footerData', 'set', { 'Cust_Key':"<span style='font-weight:700'>" + "סה\"כ: " + colSum +"</span>"});               

            },
            loadComplete: function(data) {
            //debugger;
          
                    setTimeout(initww,50);
                    try
                    {
                    
                    //debugger;
                        if(data[0].styleicon1==0 || data[0].styleicon1==1)
                        {
                            dddata=data;
                            initwData(data,$("#jQGrid"));                    
                        }
                        
                       // alert(data[0].AgentId);
                        //if(data[0].AgentId)
                        {
                           // dddata=data;
                           // initwData(data,$("#jQGrid"));                    
                        }
                    }
                    catch(e)
                    {
                        initwData(dddata,$("#jQGrid"));         
                    }
                },

            onSelectRow:  function(id) {
            var row = $('#jQGrid').jqGrid('getRowData', id);
           // debugger;
           //alert(row['<%=strGridColID.ToLower() %>']);
               $("#jQGridMasterDetails").jqGrid('GridUnload');
                SetMasterDetailsGrid(row['<%=strGridColID.ToLower() %>']);
                //alert(row['<%=strGridColID.ToLower() %>']);
                SetJumpGrid(row['<%=strGridColID.ToLower() %>'],row['<%=strDate.ToLower() %>'],row['<%=strAgentID.ToLower() %>']); 
            },
            onSortCol: function(index, iCol, sortorder){
                saveSelection.call(this);
            }
            
            /*editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEdit'*/
        });
        
        $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                   {
                       edit: false,
                       add: false,
                       del: false,
                       search: true,
                       searchtext: "חיפוש",
                       addtext: "הוסף",
                       edittext: "ערוך",
                       deltext: "מחק",
                       refreshtext:"רענן"

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
            //userdata['Cust_Key'] = "gilgo";
            function SetJumpGrid(id,Date,AgentID)
            {
                var width = 700.0; 
                var height = 500.0;
                var left = (screen.width / 2.0) - (width / 2.0);
                var top = (screen.height / 2.0) - (height / 2.0);
                 $.ajax({
                        url: "../../Handlers/MainHandler.ashx?MethodName=GetGridJump&GridName=<%=GridName %>&id="+id,
                        type: "Get",
                        data: '',
                        success: function (data) {
                            try
                            {                            
                            var GridParameters="";
                            if(id)
                                parent.SetEditWinJump(data[0].GridName,data[0].GridCaption,GridParameters);
                            }
                            catch(e)
                            {
                            }
                            //window.open("../Usr/GridViewNew.aspx?GridName="+GridName+"&GridParameters=Date:20140205;AgentID:0&ID=220&iDate=20140226&AgentID=0&ID=220", 'MobiPlus','top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes');

                        },
                        error: function (data) {
                            
                        }
                    });

                
            }
            function SetMasterDetailsGrid(id)
            {
                   
                    $("#jQGridMasterDetails").jqGrid({
                    url: "../../Handlers/MainHandler.ashx?MethodName=GridDataNew&GridName=<%=GridNameMD %>&GridParameters=<%=GridParametersMD %>&id="+id,
                    datatype: "json",
                    colNames: <%=colNamesMD %>,
                    colModel: [<%= colModelMD%>],
                    rowNum:<%=RowsModel %>,
                    mtype: 'POST',
                    loadonce: true,
                    rowList: [10, 20, 30],
                    pager: '#jQGridPagerMasterDetails',
                    sortname: 'id',
                    viewrecords: true,
                    sortorder: 'asc',
                    caption: "<%=CaptionMD %>",
                    loadComplete: function(data) {
                            setTimeout(initww,50);
                            initwData(data,$("#jQGridMasterDetails"));
                        },
                    onSortCol: function (name) {
                        saveSelection.call(this);
                    }
                    /*editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEdit'*/
                });
        
                $('#jQGridMasterDetails').jqGrid('navGrid', '#jQGridPagerMasterDetails',
                           {
                               edit: false,
                               add: false,
                               del: false,
                               search: true,
                              searchtext: "חיפוש",
                               addtext: "הוסף",
                               edittext: "ערוך",
                               deltext: "מחק",
                               refreshtext:"רענן"
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
                     $("#jQGridMasterDetails").trigger("reloadGrid");
                }
            function initww(data)
            {        
                //$('.ui-jqgrid-titlebar').first().css("padding-left",<%=GridWidth.ToString() %> - "<%=Caption %>".length*5.0 - 25 * 1.0 +"px");
                //$('.ui-jqgrid-titlebar').last().css("padding-left",<%=GridWidth.ToString() %> - "<%=CaptionMD %>".length*5.0 - 25 * 1.0 +"px");
            }
            var ColSelected = '';
            var ColSelected2 = '';
            var dddata;
            var colID=0;
            function initwData(data,objMain)
            {     
            //debugger;
            dddata=data;
               try{
                    
                    if(ColSelected=="")// && ColSelected2=="")
                    {
                    $.each(data[0], function (key, value) {
                        if(key)
                        {
                            if(key.toLocaleString().indexOf('stylecolor')>-1)
                            {
                                if(key.toLocaleString().indexOf('stylecolor_')>-1)
                                {
                                    try{
                                            if(ColSelected=='')
                                            {
                                                ColSelected = key.toLocaleString().substr(key.toLocaleString().indexOf('stylecolor_')+11,key.toLocaleString().length - (11 + key.toLocaleString().indexOf('stylecolor_')));
                                            }
                                        }
                                        catch(e)
                                        {
                                        }
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
                                setBGcolorsForCol(i+1,colID+1,obj.color,objMain);
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
                    try{
                   
                         for (var i = 0; i < data.length; i++) {
                            var obj = data[i];
                           // if(obj['styleicon1'])
                            {
                                if(obj['styleicon1']=='1')
                                {      
                                    colID = 0;
                                    var j=0;
                           
                                    setIconToRow(i+1,0,obj.Icon,objMain,obj);
                                }
                                else
                                {
                                    setIconToRow(i+1,0,obj.Icon,objMain,obj);
                                }
                        
                            }                    
                        }
                    }
                    catch(e)
                    {
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
                    try{
                    for (var i = 0; i < data.rows.length; i++)
                      {
                        var obj = data.rows[i];
                        //if(obj['styleicon1'])
                        {
                            if(obj['styleicon1']=='1')
                            {      
                                colID = 0;
                                var j=0;
                           
                                setIconToRow(i+1 ,0,obj.Icon,objMain,obj);
                            }
                            else
                            {
                                setIconToRow(i+1 ,0,obj.Icon,objMain,obj);
                            }
                        }                    
                    }
                     }
                    catch(e)
                    {
                    }
                }
               
               
                }
              catch(e)
              {
              var t=1;
              }
            }
         function setBGcolorsForCol(row,col,color,obj)
         { 
            $('#jQGrid').setCell(row,col,'',{ 'background-color':color});
           
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
          function setIconToRow(row,col,iconr,obj,dobj)
         {//debugger;
                var icon = '';
                switch(iconr)
                {
                    case "RedIcon":
                        icon = 'url(\"../../img/15dot1a.gif"\)';
                        break;
                    case "GreenIcon":
                        icon = 'url(\"../../img/15dot4a.gif"\)';
                        break;
                    case "YellowIcon":
                        icon = 'url(\"../../img/15dot3a.gif"\)';
                        break;
                     case "OrangeIcon":
                        icon = 'url(\"../../img/15dot2a.gif"\)';
                        break;
                     case "UpIcon":
                     //debugger;
                        if(dobj.styleicon1 && dobj.styleicon1==1)
                            icon = 'url(\"../../img/up.png"\)';
                        else
                            icon = 'url(\"../../img/down.png"\)';
                        break;                    
                }
                obj.setCell (row,col,'',{ 'background-image':icon});
                obj.setCell (row,col,'',{ 'background-repeat':'no-repeat'});
                obj.setCell (row,col,'',{ 'background-position':'center'});
         }
         
        try
        {
            parent.SetIFRH('<%=strID %>');
            parent.SetIFRWidth();
        }
        catch(e)
        {
        }
        setInterval(Refresh,30000);
    </script>
    </form>
</body>
</html>
