<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowReport.aspx.cs" Inherits="Pages_RPT_ShowReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css">
    <script src="../../js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="../../js/main.js"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
    <script type="text/javascript" src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/json2.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/Main.css" />
    <link rel="stylesheet" href="../../css/Report.css" />
    <style type="text/css">
        
    </style>
    <script type="text/javascript">
        
    </script>
</head>
<body style="background-color: white; overflow-x: hidden;" onclick="parent.CheckSession();">
    <form id="form1" runat="server">
    <div>
        <div class="dPartItems" id="gridDiv" style="display: none; height: <%=Height %>px">
            <table id="jQGrid">
            </table>
            <div id="jQGridPager" style="position: fixed;">
            </div>
        </div>
        <div class="dPartItems" id="ctlMain" style="display: none; height: 100%;" runat="server">
            <div class="dMerchandise_rightDDLs">
                <table cellpadding="2" cellspacing="2" width="100%">
                    <tr>
                        <td class="ddlFilter line">
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td id="tdName" runat="server" onclick="SetOnStart('250px');">
                                        סוכן
                                    </td>
                                    <td style="width: 90%; text-align: left;">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 65%;">
                                                    &nbsp;
                                                </td>
                                                <td style="text-align: left;">
                                                    <asp:LinkButton runat="server" ID="lbClearAgent" CssClass="aLink" OnClientClick="ClearDDL();">נקה</asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="">
                            <asp:DropDownList runat="server" ID="ddlControl" onchange="NavFrame(this.value);"
                                CssClass="ddlFilterItem" size="9">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:HiddenField runat="server" ID="hdnGridStyles" />
        <asp:HiddenField runat="server" ID="hdnIsSummery" />
        <asp:HiddenField runat="server" ID="hdnIsLastRowFooter" />
        <asp:HiddenField runat="server" ID="hdnFooterRow" />
        <asp:HiddenField runat="server" ID="hdnFooterRowAsRow" />
        <asp:HiddenField runat="server" ID="hdnJson" />
    </form>
    <script type="text/javascript">
    function ReloadPage() {
        window.location.href = window.location.href;
    }
    setTimeout('ReloadPage();',5 * 60 * 1000);
        function ShowGrid() {
            $('#gridDiv').show();
            SetGrid(); 
        }
        function SetStyleValues(StyleName,i,colID)
        {
            switch(StyleName)
            {
                case "Default":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'black','font-weight': '500'});
                break;
                case "BoldBlack":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'#000000','font-weight': '500'});
                break;

                case "BoldTitle":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'#FFFFFF','background-color':'#C4CACC','font-weight': '600','font-size':'13px'});
                break;

                case "Blue":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'#301EFA','font-weight': '500'});
                break;

                case "Green":
               
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'Yellow','font-weight': '500'});//'#0BDB40'
                break;

                case "Red":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'#F7022F','font-weight': '500'});
                break;

                 case "#FA6E58":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'#EF8C08','font-weight': '500'});
                break;

                case "BoldBlue":
                    $('#jQGrid').setCell(i+1,colID,'',{ 'color':'#301EFA','font-weight': '600'});
                break;

                          
            }
        }
        function SetStyles(data)
        {
            var arrStyles = $('#<%=hdnGridStyles.ClientID %>').val().split(';');
            for (var i = 0; i < data.length; i++) {
                var colID = 0;
                //var obj = data[i];
                $.each(data[0], function (key, value) {
                
                    var arrSplit = arrStyles[colID].split(':');
                    if(arrSplit!=null && arrSplit.length > 0)
                    {
                        var StyleName = arrSplit[1];
                        
                        SetStyleValues(StyleName,i,colID);
                        
                    }
                    else{
                        SetStyleValues("Default",i,colID);
                    }
                    colID++;
                    if(colID >= arrStyles.length)
                        colID=0;
                });
            }
            for (var i = 0; i < data.length; i++) {
                var colID = 0;
                $.each(data[i], function (key, value) {
                    var last=0;
                    var arrSplit = arrStyles[colID].split(':');
                    if(arrSplit!=null && arrSplit.length > 0)
                    {
                        var StyleName = arrSplit[1];

                        SetStyleValues("Default",i,0);

                        if(key.indexOf("STYLE_")>-1)
                        {
                            StyleName=value;
                            colID = GetColID(data,key.replace("STYLE_",""))-1;
                            SetStyleValues(StyleName,i,colID+1);
                            last=colID+1;
                        }
                        else{                                                       
                                SetStyleValues("Default",i,colID+1);
                    }
                    }
                    colID++;
                    if(colID >= arrStyles.length)
                        colID=0;
                });
            }
        }
        function GetColID(data,ColName)
        {
       
            var ColID=0;
            var RetColID=0;
                 $.each(data[0], function (key, value) {
                    if(key == ColName)
                    {
                        RetColID = ColID;
                    }
                    ColID++;
                 });
           return RetColID;
        }
        var RowFotter="";
        
        function SetGrid() {
            var footerrow=false; 
            if($('#<%=hdnIsSummery.ClientID %>').val().split(';').length > 1 || $('#<%= hdnIsLastRowFooter.ClientID%>').val()=="True")
                footerrow = true;
            
            var dataReal;
            var rids;
           //debugger;
            var arrFooter2;
            var isDeleted= false;
            var RowNum = <%=RowNum %>;//($(document).height())/22.7 -4;
            if(RowNum=="")
            RowNum = 'auto';
            $("#jQGrid").jqGrid({
                url: "<%= url%>",
                //data: $.parseJSON('<%=JsonString %>'),
                datatype: "json",//local
                direction: "rtl",
                colNames:[<%=colNames %>],
                colModel:[<%=colModel %>],
                rowNum: RowNum,
                mtype: 'POST',
                loadonce: true,
                //rowList: [10],
                pager: '#jQGridPager',
                 prmNames: {page: "pageNumber", rows: "rowSize"},
                /*sortname: '_id',*/
                viewrecords: true,
                sortorder: 'asc',
                caption: "<%=Caption %>",
                toppager: false,

                //height:"<%=Height %>" -16+"px",//'auto',//"<%=Height %>" -95 +"px", //'auto',//"
                footerrow: footerrow, userDataOnFooter: true,
                //altRows: <%=IsZebra %>,
                //sortname: 'AgentName',

                grouping:<%=isToShowGroups %>, 
                groupingView : { 
                     groupField : ['<%=GroupBy %>'],
                    // groupOrder : ['desc'] ,
                     //groupDataSorted : true,
                     groupSummary:<%=HasSubTotalsOnGroup %>
                  }, 
                loadComplete: function (data) {
                   
                //debugger;
        //$('.ui-pg-input')[0].parentElement.style.display="none";
        $('.ui-pg-input')[0].parentElement.childNodes[0].data = " דף ";
        $('.ui-pg-input')[0].parentElement.childNodes[2].data = " מ ";
        $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";
              

                $("#jQGrid").jqGrid('setGridHeight',$("#gridDiv").height() - $(".ui-jqgrid-titlebar").height() - $("#jQGridPager").height()-$(".footrow").height()-$("#jQGridPager").height()-$(".ui-jqgrid-sortable").height()+10);
                for (var i = 0; i < $('.ui-jqgrid-sortable').length; i++) {
                    if($('.ui-jqgrid-sortable')[i].innerText.split(' ').length==1)
                        $('.ui-jqgrid-sortable')[i].style.paddingTop = ($('.ui-jqgrid-sortable')[i].offsetHeight-$('.ui-jqgrid-sortable')[i].innerText.split(' ').length+1  * 40)/2 - 30 + "px";
                }
                


                var HeaderFontColor = "#BEBEBE";
                var HeaderBackgroundColor = "white";
                $(".ui-jqgrid-sortable").each(function() {
                    this.style.color = HeaderFontColor;
                    this.style.backgroundColor = HeaderBackgroundColor;
                });

                //debugger;
                try{
                    setTimeout('parent.CloseLoading();',10);
                
                    dataReal = $('#jQGrid').jqGrid('getGridParam','data');
                    //debugger;
                    //rids = $('#jQGrid').jqGrid('getDataIDs');
                    if($('#<%= hdnIsLastRowFooter.ClientID%>').val()=="True")
                        $('#jQGrid').jqGrid('delRowData',dataReal[dataReal.length-1]["_id_"]);

                    if('<%= IsToShowRowsNumberOnTitle%>'=='True')
                    {
                       $("#dCaption")[0].outerHTML  ="<%=Caption %>";
                        $("#dCaption").html($("#dCaption").html()+" ("+dataReal.length+")");
                        }
                    var arrFooter = $('#<%=hdnIsSummery.ClientID %>').val().split(';');
                    if(arrFooter.length > 1)
                    {
                      var $this = $(this),
                                sum = $this.jqGrid("getCol", "CountSalesReturns", false, "sum"),
                                $footerRow = $(this.grid.sDiv).find("tr.footrow"),
                                localData = $this.jqGrid("getGridParam", "data"),
                                totalRows = localData.length,
                                totalSum = 0,
                                $newFooterRow,
                                i;
                            $newFooterRow = $(this.grid.sDiv).find("tr.myfootrow");
                            if ($newFooterRow.length === 0) {
                                $newFooterRow = $footerRow.clone();
                                $newFooterRow.children("td").each(function () {
                                    this.style.width = ""; // remove width from inline CSS
                                });
                            }
                            var RowFotter="";
                            for (var j = 0; j < arrFooter.length; j++) {
                                totalSum=0;
                                for (i = 0; i < totalRows; i++) {
                                    totalSum += parseFloat(localData[i][arrFooter[j]], 10);
                                }
                                if(totalSum)
                                    RowFotter+="\"" + arrFooter[j] + "\":\"" +totalSum.toString() + "\",";
                            }
                            RowFotter=RowFotter.substr(0,RowFotter.length-1);

                            $this.jqGrid("footerData", "set", $.parseJSON("{"+RowFotter+"}"));

                     }
                    if($('#<%= hdnIsLastRowFooter.ClientID%>').val()=="True")
                    {
                        arrFooter2 = $('#<%=hdnFooterRow.ClientID %>').val().split(';');
                                     

                        if(arrFooter2.length > 1)
                        {
                          dataReal = $('#jQGrid').jqGrid('getGridParam','data');
                     

                          var $this = $(this),
                                    sum = $this.jqGrid("getCol", "CountSalesReturns", false, "sum"),
                                    $footerRow = $(this.grid.sDiv).find("tr.footrow"),
                                    localData = $this.jqGrid("getGridParam", "data"),
                                    totalRows = localData.length,
                                    totalSum = 0,
                                    $newFooterRow,
                                    i;
                                $newFooterRow = $(this.grid.sDiv).find("tr.myfootrow");
                                if ($newFooterRow.length === 0) {
                                    $newFooterRow = $footerRow.clone();
                                    $newFooterRow.children("td").each(function () {
                                        this.style.width = ""; // remove width from inline CSS
                                    });
                                }
                           isDeleted=false;
                      
                           if($('#<%= hdnFooterRowAsRow.ClientID%>').val()=="")
                           {
                                var RowFotter="";
                                for (var j = 0; j < arrFooter2.length; j++) {
                                        RowFotter+="\"" + arrFooter2[j] + "\":\"" +dataReal[dataReal.length-1][arrFooter2[j]] + "\",";
                               }
                               
                               RowFotter=RowFotter.substr(0,RowFotter.length-1);
                               $this.jqGrid("footerData", "set", $.parseJSON("{"+RowFotter+"}"));
                               //alert(rids.length);
                               
                           
                                $('#<%= hdnFooterRowAsRow.ClientID%>').val(RowFotter);

                            }       
                        
                       
                         }
                     }
                      }
                   catch(e) 
                   {
                   }
                },

                onSelectRow: function (id) {
                    if('<%=RowOpenReport %>'!='0')
                    {
                        var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                        parent.openNewReport("<%=RowOpenReport %>",selr);

                        try{
                            var data = $('#jQGrid').jqGrid('getGridParam','data');
                            parent.NavNewReport(data[selr-1].Code,selr);
                        }
                        catch(e)
                        {
                        }
                    }
                        if('<%=RowOpenForm %>'!='0')
                    {
                        var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                        parent.openNewForm("<%=RowOpenForm %>",selr);
                    }
                  
                },
                ondblClickRow: function (id) {

                   
                },
                gridComplete: function () {
                    var data = $('#jQGrid').jqGrid('getGridParam','data');
                    SetStyles(data); 
                    dataReal = $('#jQGrid').jqGrid('getGridParam','data');
                   // var rids = $('#jQGrid').jqGrid('getDataIDs');
                    //alert(data.length);
                    //var nth_row_id = rids[data.length-1]; //bec the row array starts from zero.
                   
                    //$('#jQGrid').jqGrid('delRowData',nth_row_id);
                    
                   
                    if($('#<%= hdnIsLastRowFooter.ClientID%>').val()=="True")
                    {
                        arrFooter2 = $('#<%=hdnFooterRow.ClientID %>').val().split(';');
                
                        if(arrFooter2.length > 1 && !isDeleted)
                        {
                            isDeleted=true;
                        }
                    }

                    try{
                            if(parent.isFirstClick)
                                parent.NavNewReport(data[0].Code,0);
                            parent.isFirstClick = false;

                        }
                        catch(e)
                        {
                        }
                }
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: false,
                           add: false,
                           del: false,
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
        function ShowControl()
        {
            
        }
       function NavFrame(val,ControlKey)
       {
            parent.SethdnSrcParams('<%=ControlKey %>',val,'<%=WinID %>');
       }
       function ClearDDL()
       {
            $('#<%=ddlControl.ClientID %>').val("0");
            NavFrame("0");
       }

       function SetOnStart(height)
       {
//            $('.dMerchandise_rightDDLs').height(height);
//            //alert($('#<%=ddlControl.ClientID %>').css("display"));
//            if($('#<%=ddlControl.ClientID %>').css("display")=="inline-block")
//            {
//                $('#<%=ddlControl.ClientID %>').slideUp("fast");
//                //alert('<%=WinID %>');
//                parent.SetHeight("25px",'<%=WinID %>');
//            }
//            else
//            {
//                $('#<%=ddlControl.ClientID %>')[0].size="9";
//                $('#<%=ddlControl.ClientID %>').slideDown("fast");
//                parent.SetHeight(height,'<%=WinID %>');
//            }

            
       }
        
        $('#<%=ctlMain.ClientID %>').height($(document).height()-2);

//        if("<%=IsCtl %>"=="True")
//            NavFrame("0","cc");

        function OnInit()
        {
            if("<%=IsCtl %>"=="True")
            {
                NavFrame("0","cc");
            }    
        }
        OnInit();
        setTimeout('OnInit();',1600);
           
        
    </script>
</body>
</html>
