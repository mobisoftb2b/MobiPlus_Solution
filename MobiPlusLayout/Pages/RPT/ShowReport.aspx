<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowReport.aspx.cs" Inherits="Pages_RPT_ShowReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%--<link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" type="text/css" />--%>
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" />
    <script type="text/javascript" src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/main.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/json2.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>

    <link href="~/css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" type="text/css" />
    <link href="~/css/ui.jqgrid.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" />

    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
            var href;
            switch (lang) {
                case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                case 'Ge': href = "../../css/MainLTR.css?SessionID=<%= Session.SessionID%>"; break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        }
        styler();
    </script>
    <link rel="stylesheet" href="../../css/Report.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" />
    <script type="text/javascript" src="../../js/tableEdit.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <style type="text/css">
   
    </style>
    <script type="text/javascript">
        $.datepicker.setDefaults({ yearRange: '2010:c' });
    </script>
    <style type="text/css">
        @keyframes blinker {
            50% {
                opacity: 0;
            }
        }
    </style>
    <script type="text/javascript" src="../../js/jquery.jqGridWithSearch.js"></script>

</head>
<body id="dBodyr" onload="try{setTimeout('try{parent.CloseLoading();}catch(e){}',10);}catch(e){}" style="background-color: white; overflow-x: hidden;" onclick="try{parent.CheckSession();}catch(e){}">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <div id="tt" style="position:absolute;z-index:99999;direction:ltr;text-align:left;display:none;">Marina change 21.08.19</div>
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
                                        <td id="tdName" runat="server" onclick="SetOnStart('250px');">סוכן
                                        </td>
                                        <td style="width: 90%; text-align: left;">
                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="width: 65%;">&nbsp;
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

            <div id="EditBox" runat="server" style="display: none;" class="cssEditBox">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                    <h3 runat="server" id="myModalLabel">עדכון ערכים</h3>
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
            <asp:HiddenField runat="server" ID="hdnGridStylesByDB" />
            <asp:HiddenField runat="server" ID="hdnIsSummery" />
            <asp:HiddenField runat="server" ID="hdnIsLastRowFooter" />
            <asp:HiddenField runat="server" ID="hdnFooterRow" />
            <asp:HiddenField runat="server" ID="hdnFooterRowAsRow" />
            <asp:HiddenField runat="server" ID="hdnJson" />
            <asp:HiddenField runat="server" ID="hdnParams" />
            <asp:HiddenField runat="server" ID="hdnTableName" />
            <asp:HiddenField runat="server" ID="hdnParamsType" />
            <asp:HiddenField runat="server" ID="hdnPrimary" />
        </div>
        <div style="display: none;">
            <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Always">
                <ContentTemplate>
                    <div runat="server" id="divSelect"></div>
                    <%--style="display: block;max-height:50px;position:absolute;z-index:9999;top:30px;"--%>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel runat="server" ID="upFilters" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Button runat="server" ID="btnSetFilters" OnClick="btnSetFilters_Click" />
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnSetFilters" EventName="Click"/>
                </Triggers>
            </asp:UpdatePanel>
            <asp:Button runat="server" ID="btnDownloadXlsx" OnClick="btnDownloadXlsx_Click" />
        </div>
    </form>
    <script type="text/javascript">
        var withSearch = false;
        function ReloadPage() {
            window.location.href = window.location.href;
        }
        var scrollPosition = 0;
        var pagePosition = 1;
        var hdnParamsClientID = '<%=hdnParams.ClientID %>';
        var hdnTableNameClientID = '<%=hdnTableName.ClientID %>';
        var hdnParamsTypeClientID = '<%=hdnParamsType.ClientID %>';
        var hdnPrimaryClientID= '<%=hdnPrimary.ClientID %>';
        var Ticks =<%= DateTime.Now.Ticks.ToString()%>;
        var AllowAdd=<%=AllowAdd %>;
        
        var AllowEdit=<%=AllowEdit %>;
        var AllowDelete=<%=AllowDelete %>;
        //setTimeout('ReloadPage();', 5 * 60 * 1000);
        var GridID = "jQGrid";
        $('#dBodyr').height($(document).height());


        function ShowGrid() {
            $('#gridDiv').show();
            SetGrid();
        }
   
        var JsonStyles = $('#<%=hdnGridStylesByDB.ClientID %>').val();
        var obj = $.parseJSON(JsonStyles);
        function SetStyleValues(StyleName, i, colID, ColName) {
            //debugger;
            var counter=0;
            var t = 0;
            
            //if(!isToStyleAgain)
                //debugger;

            for (t = 0; t < obj.length; t++) {
                
                if(obj && obj[t] && obj[t].StyleName && StyleName && obj[t].StyleName.toString().toLowerCase().trim() == StyleName.toString().toLowerCase().trim())
                {
                    var color = obj[t].ForeColor.split('%23').join('#');
                    //var bgcolor = obj[t].BackColor.split('%23').join('#');
					bgcolor = obj[t].BackColor !=null?obj[t].BackColor.split('%23').join('#'):"";
                    //$('#tt').html($('#tt').html()+'; '+colID+':'+color);

                    
                    if(($('#jQGrid').jqGrid('getLocalRow', i+1)[ColName] &&  $('#jQGrid').jqGrid('getLocalRow', i+1)[ColName].toString().indexOf("<%=ColDelimiter%>")>-1 && obj[t].ChildStyleID!=''))
                    {
                        //$('#tt').text(StyleName);
                       
                        arrVals = $('#jQGrid').jqGrid('getLocalRow', i+1)[ColName].toString().split('<%=ColDelimiter%>');
                        var htm="";
                        for (var y = 0; y < arrVals.length; y++) {
                            color = obj[t].ForeColor.split('%23').join('#');
                            //bgcolor = obj[t].BackColor.split('%23').join('#');
							bgcolor = obj[t].BackColor !=null?obj[t].BackColor.split('%23').join('#'):"";
                            $('#tt').text(bgcolor);
                            if(y==0)
                                htm+="<div style='color:"+color+";font-weight:"+obj[t].isBold+" == 0 ? 500 !important : 700;animation: "+obj[t].isBlink+" == 0 ? none : blinker 1s linear infinite;text-decoration: "+obj[t].isUnderline+" == 0 ? none : underline;background-color: "+bgcolor+";font-size: "+obj[t].FontSize+"px'>"+arrVals[y]+"</div>";
                            else
                            {
                                
                                StyleID = obj[t].ChildStyleID;
                                //$('#tt').text(bgcolor);
                                for (r = 0; r < obj.length; r++) {
                                    
                                    if(obj && obj[r] && obj[r].StyleID && StyleID && StyleID!='' && obj[r].StyleID.toString().toLowerCase().trim() == StyleID.toString().toLowerCase().trim())
                                    {
                                        color = obj[r].ForeColor.split('%23').join('#');
                                        //bgcolor = obj[r].BackColor.split('%23').join('#');
										bgcolor = obj[t].BackColor !=null?obj[t].BackColor.split('%23').join('#'):"";

                                        $('#tt').text("11");
                                        htm+="<div style='color:"+color+";font-weight:"+obj[r].isBold+" == 0 ? 500 !important : 700;animation: "+obj[r].isBlink+" == 0 ? none : blinker 1s linear infinite;text-decoration: "+obj[r].isUnderline+" == 0 ? none : underline;background-color: "+bgcolor+";font-size: "+obj[r].FontSize+"px'>"+arrVals[y]+"</div>";

                                        break;
                                    }
                                }
                            }
                        }
                        $('#jQGrid').jqGrid('setCell', i + 1, ColName, htm);
                        //htm+="</div>";
                        //$('#tt').text(StyleName);
                        
                        var dt = new Date();
                        var time = dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
                        //$('#tt').text("2-"+time);
                        ////$('#jQGrid').setCell(i + 1, colID, htm, '');

                        //$('#jQGrid').jqGrid('setCell', i + 1, ColName, "<div style='color:yellow;'>"+$('#jQGrid').jqGrid('getLocalRow', i+1)[ColName]+"</div>");
                    }
                    else if($('#jQGrid').jqGrid('getLocalRow', i+1)[ColName] && $('#jQGrid').jqGrid('getLocalRow', i+1)[ColName].toString().indexOf("font-weight:")>-1)
                    {
                        $('#jQGrid').jqGrid('setCell', i + 1, ColName, $('#jQGrid').jqGrid('getLocalRow', i+1)[ColName]);
                    }
                    else
                    {
                        color = obj[t].ForeColor.split('%23').join('#');
                        //bgcolor = obj[t].BackColor.split('%23').join('#');
						bgcolor = obj[t].BackColor !=null?obj[t].BackColor.split('%23').join('#'):"";

                        var dt = new Date();
                        var time = dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
                        //$('#tt').text("3-"+time);

                        $('#jQGrid').setCell(i + 1, colID, '', { 'color': color, 'font-weight': obj[t].isBold == '0' ? '500 !important' : '700','animation': obj[t].isBlink == '0' ? '' : 'blinker 1s linear infinite','text-decoration': obj[t].isUnderline == '0' ? '' : 'underline', 'background-color': bgcolor=='' ? 'none' : bgcolor, 'font-size': obj[t].FontSize +"px"});
                    }
                    

                    // now change the internal local data
                    //myGrid.jqGrid('getLocalRow', rowid).myColumn = newValue;

                    break;
                    
                }
                else{
                    //debugger;
                }
                counter++;
            }
            //$('#tt').html($('#tt').html()+';'+i+1);
            //alert(obj.length);
            //switch (StyleName) {
            //    case "Default":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': 'black', 'font-weight': '500' });
            //        break;
            //    case "BoldBlack":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': '#000000', 'font-weight': '500' });
            //        break;

            //    case "BoldTitle":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': '#FFFFFF', 'background-color': '#C4CACC', 'font-weight': '600', 'font-size': '13px' });
            //        break;

            //    case "Blue":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': '#301EFA', 'font-weight': '500' });
            //        break;

            //    case "Green":

            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': 'Yellow', 'font-weight': '500' });//'#0BDB40'
            //        break;

            //    case "Red":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': '#F7022F', 'font-weight': '500' });
            //        break;

            //    case "#FA6E58":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': '#EF8C08', 'font-weight': '500' });
            //        break;

            //    case "BoldBlue":
            //        $('#jQGrid').setCell(i + 1, colID, '', { 'color': '#301EFA', 'font-weight': '600' });
            //        break;


            //}
        }
        function SetStyles(data) {
           
            //alert($('#<%=hdnGridStyles.ClientID %>').val());
            var arrStyles = $('#<%=hdnGridStyles.ClientID %>').val().split(';');
            for (var i = 0; i < data.length; i++) {
                var colID = 0;
                //var obj = data[i];
                $.each(data[0], function (key, value) {
                    var arrSplit = arrStyles[colID].split(':');
                    if (arrSplit != null && arrSplit.length > 0) {
                        var StyleName = arrSplit[1];

                        SetStyleValues(StyleName, i, colID,arrSplit[0]);
                        //$('#tt').html($('#tt').html()+colID+":"+StyleName+";");
                    }
                    else {
                        SetStyleValues("Default", i, colID,arrSplit[0]);
                    }
                    colID++;
                    if (colID >= arrStyles.length)
                        colID = 0;
                });
            }
            for (var i = 0; i < data.length; i++) {
                var colID = 0;
                $.each(data[i], function (key, value) {
                    var last = 0;
                    var arrSplit = arrStyles[colID].split(':');
                    if (arrSplit != null && arrSplit.length > 0) {
                        var StyleName = arrSplit[1];

                        //SetStyleValues("Default", i, 0);
                         if (key.indexOf("STYLE_") > -1) {
                             StyleName = value;
                             colID = GetColID(data, key.replace("STYLE_", ""));
                              
                             SetStyleValues(StyleName, i, colID, arrSplit[0]);
                             last = colID;
                         }
                         //else {
                         //    SetStyleValues("Default", i, colID + 1);
                         //}
                    }
                    colID++;
                    if (colID >= arrStyles.length)
                        colID = 0;
                });
            }
        }
     
      
        var RowFotter = "";


        function ShowControl() {

        }
        function NavFrame(val, ControlKey) {
            parent.SethdnSrcParams('<%=ControlKey %>', val, '<%=WinID %>');
        }
        function ClearDDL() {
            $('#<%=ddlControl.ClientID %>').val("0");
            NavFrame("0");
        }

        function SetOnStart(height) {
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

        $('#<%=ctlMain.ClientID %>').height($(document).height() - 2);

        //        if("<%=IsCtl %>"=="True")
        //            NavFrame("0","cc");

        function OnInit() {
            if ("<%=IsCtl %>" == "True") {
                NavFrame("0", "cc");
            }
            for (var i = 0; i < $('.ui-datepicker').length; i++) {
                $('.ui-datepicker')[i].className = "ui-datepicker msdatepicker";
            }
        }

        setTimeout('OnInit();', 1600);



        var isToStyleAgain = true;
        var ColName='';
        var FilterValue='';
        var OrgURL = "<%= url%>";
        var isFirstTime= true;
        function SetGrid() {
            withSearch="<%=withSearch %>";
            var footerrow=false; 
            if($('#<%=hdnIsSummery.ClientID %>').val().split(';').length > 1 || $('#<%= hdnIsLastRowFooter.ClientID%>').val()=="True")
                footerrow = true;
            var dataReal;
            var rids;
            var arrFooter2;
            var isDeleted= false;
            var RowNum = <%=RowNum %>;
            var IsZebra=<%=IsZebra%>;
            if(RowNum=="")
                RowNum = 'auto';
            $("#jQGrid").jqGrid({
                url: ("<%= url%>").toString().replace("cnn", ColName).replace("vall", FilterValue),
                /*  datatype: (!withSearch ? "json" : "jsonstring"),
                datastr: (!withSearch ? "" : "jsonstring"),*/
                datatype: "json",			
                direction: "<%=StrSrc("dir")%>",
                altRows:IsZebra,
                altclass:'ui-priority-secondary',
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
                    // alert(454);
                    $('.ui-pg-input')[0].parentElement.childNodes[0].data = "  <%=StrSrc("Page")%> "; 
                  
                    $('.ui-pg-input')[0].parentElement.childNodes[2].data = "  <%=StrSrc("of")%> ";  
                
                    $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";
             
                    initwData(data);
                    //setTimeout("initwData("+data+");",7);
                    //debugger;
                    
                    var pagePositionNew = $('#jQGrid').getGridParam('page');
                    if (pagePosition==pagePositionNew) {
                        jQuery("#jQGrid").closest(".ui-jqgrid-bdiv").scrollTop(scrollPosition)
                    }
                  
                    $('.ui-jqgrid-view').height($(document).height()-27);
                    
                    $('.ui-jqgrid-bdiv').height($(document).height()-47);
                    ReplaceCloseButton();
                    setTimeout( 'refreshHight();',1);
                   


                    if(isFirstTime)
                    {
                        SetFiltersOnStart();
                        isFirstTime=false;
                    }
                    //export to excel
                    $('.ui-jqgrid-titlebar').html($('.ui-jqgrid-titlebar').html()+'<div class="findObj" onclick="HideSearchRow();"><a role="link" href="javascript:void(0)" class="ui-jqgrid-titlebar-close HeaderButton" style="left: 0px;"><span class="ui-iconms ui-icon-circle-triangle-n"></span></a></div>');
                    $('.ui-jqgrid-titlebar').html($('.ui-jqgrid-titlebar').html()+'<div class="ExcelObj" onclick="DownloadXlsx();"><a role="link" href="javascript:void(0)" class="ui-jqgrid-titlebar-close HeaderButton" style="left: 0px;"><span class="ui-iconms-excel ui-icon-circle-triangle-n"></span></a></div>');

                    //$(".ui-icon-circle-triangle-n")[0].children[0].onclick = ShowSearchFormMD1;
                    //$(".HeaderButton").click = ShowSearchFormMD1;
                    
                },

                onSelectRow: function (id) {
                    ridmd = id;
                    var row = $('#' + GridID).jqGrid('getRowData', id);
                    var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                    Row = row;
                    try
                    {
                        var data = $('#jQGrid').jqGrid('getGridParam','data');
                        parent.ShowData(data[selr-1],selr);
                    }
                    catch(e)
                    {
                    }
                    if('<%=RowOpenReport %>'!='0')
                    {


                        
                        parent.parent.openNewReportNewr("<%=RowOpenReport %>",selr,data[selr-1]);

                        try{
                            
                            parent.parent.NavNewReport(data[selr-1].Code,selr);
                        }
                        catch(e)
                        {
                        }
                    }
                    if('<%=RowOpenForm %>'!='0')
                    {
                       
                        var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                        parent.parent.openNewForm("<%=RowOpenForm %>",selr);
                    }
                   
                    if('<%=RowOpenRoutes %>'!='0')
                    {
                        var data = $('#jQGrid').jqGrid('getGridParam','data');
                        var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                        parent.parent.openRoutesCustEdit(data[selr-1],selr);
        
                    }
                  
                },
                ondblClickRow: function (id) {
                    if (AllowEdit) {
                        var row = $('#' + GridID).jqGrid('getRowData', id);
                        Row = row;
                        ridmd = id;
                        ShowEditFormMD();
                    }
                   
                },
                onSortCol: function(index, iCol, sortorder){
                    setTimeout( 'refreshHight();',1);
                    isToStyleAgain = false;
                },
                gridComplete: function () {
                    
                    //alert(2);
                    var data = $('#jQGrid').jqGrid('getGridParam','data');
                    SetStyles(data); 
                    isToStyleAgain = true;
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
                           edit: AllowEdit,
                           add: AllowAdd,
                           del: AllowDelete,
                           search: false,
                           searchtext: "",
                           addtext: "<%=StrSrc("Add")%> ",
                           edittext: "<%=StrSrc("Edit")%> ",
                           deltext: "<%=StrSrc("Delete")%> ",
                           refreshtext: "",
                           viewtext: "<%=StrSrc("Watch")%> "
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

                   function SetSearchContralByCol(ColName,Type)
                   { 
                      
                       try {
                           $('.divSearchContralByCol_' + ColName).html($('#DDLSel'+ColName)[0].parentElement.innerHTML);
                       } catch (e) {}
    
                       try {
                           $('.divSearchContralByCol_' + ColName).html($('#txtSel'+ColName)[0].parentElement.innerHTML);
                       } catch (e) {}
                   }

                   function ReplaceCloseButton()
                   {
                       var browser= msieversion();
                       try{
                           $('.ui-jqgrid-titlebar-close')[0].children[0].className = "ui-iconms ui-icon-circle-triangle-n"; 
                           $('.ui-jqgrid-titlebar-close')[0].children[0].id="GridS";
                       }
                       catch(e)
                       {
             
                       }
                   }
                   function SetFiltersOnStart()
                   {
                       $('#<%=btnSetFilters.ClientID%>').click();
                   }
                   msieversion();
                   function DownloadXlsx()
                   {
                       $('#<%=btnDownloadXlsx.ClientID%>')[0].click();

                       <%--var DataLength = $('#jQGrid').jqGrid('getGridParam','data').length;
                       var csvStr = "";
                       for (var i = 1; i < DataLength; i++) {
                           var arr = $('#<%=hdnGridStyles.ClientID%>').val().split(';');
                           var row = $('#' + GridID).jqGrid('getRowData', i);
                           

                           for (var j = 0; j < arr.length-1; j++) {
                               var name = arr[j].split(':')[0];
                               var d = document.createElement('div');
                               if(name.indexOf("STYLE_")==-1)
                               {
                                   try{
                                       d.innerHTML = row[name];
                                       if(d)
                                           csvStr+="\""+d.innerText+"\",";
                                   }
                                   catch(e)
                                   {
                                       csvStr+="\""+row[name]+"\",";
                                   }
                               }
                           }
                           csvStr+="\r\n";
                       }--%>
                       //debugger;
                       //alert(csvStr);
                       
                   }
        function setAddUser()
        {
            $("#add_jQGrid")[0].children[0].onclick = parent.AddUser;
        }
        function setAddTask()
        {
            $(".ui-pg-div").click(parent.AddTask);
            $(".ui-pg-div")[1].onclick = parent.AddTask;
        }
       
    </script>
</body>
</html>
