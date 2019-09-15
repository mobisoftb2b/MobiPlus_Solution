<%@ Page Language="C#" AutoEventWireup="true" Title="עריכת מקטעים" CodeFile="EditPrnPart.aspx.cs"
    Inherits="Pages_Admin_EditPrnPart" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css">
    <script src="../../js/jquery-1.11.0.min.js"></script>
    <script src="../../js/jquery-1.10.2.js"></script>
    <script src="../../js/jquery-ui.js"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/NewMain.css" />
    <link rel="stylesheet" href="../../css/Main.css" />
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv
        {
            overflow-y: auto;
            min-height: 525px;
        }
        .ui-jqgrid-titlebar
        {
            background-color: #E2E3E4;
        }
        .ui-jqgrid-sortable
        {
            font-size: 14px;
        }
        .ui-pg-table
        {
            background-color: #E2E3E4;
            font-size: 14px;
        }
    </style>
    <script type="text/javascript">
        function CloseWinColItemEdit() {

            $(".EditWinColsItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWinDuplicateReport() {

            $(".DuplicateReport").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWindAllImgs() {

            $(".dAllImgs").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            //$("#dBody").unblock();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <br />
    <div>
        <div class="cssParts">
            <div class="ddlQueriesContainer">
                <div class="QueryHeader">
                    <div class="QueryHeaderIn">
                        בחר מקטע</div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Always">
                    <ContentTemplate>
                        <asp:DropDownList runat="server" ID="ddlParts" Width="180px" size="34" CssClass="ddlQueries"
                            onchange="GetPartData(this.value);">
                        </asp:DropDownList>
                        <span style="display: none;">
                            <asp:Button runat="server" ID="btnRefreshddlParts" OnClick="btnRefreshddlParts_click" />
                            <asp:HiddenField runat="server" ID="hdnPartID" />
                        </span>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="txtPartEditContainer">
                <div class="QueryHeader">
                    <div class="QueryHeaderIn">
                        עריכת מקטע</div>
                </div>
                <div class="PartsEdit">
                    <table class="tblParts" cellpadding="2" cellspacing="2">
                        <tr>
                            <td style="width: 40px;">
                                מקטע:
                            </td>
                            <td>
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:TextBox runat="server" ID="txtPartName" Width="155px" CssClass="Borders"></asp:TextBox>
                                        </td>
                                        <td>
                                            <a class="a2" href="javascript:if(confirm('האם אתה בטוח ברצונך למחוק את המקטע הבחור?'))SetPartData('1','1');"
                                                style="font-weight: 500;">מחק</a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                סוג:
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlPartTypes" Width="158px" CssClass="Borders"
                                    onchange='CheckForPic(this.value);'>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                נושא:
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlTopics" Width="158px" CssClass="Borders">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                מפריד<br />
                                עליון:
                            </td>
                            <td>
                                <asp:CheckBox runat="server" ID="cbhasHeaderSeparator" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                מפריד<br />
                                תחתון:
                            </td>
                            <td>
                                <asp:CheckBox runat="server" ID="cbhasFooterSeparator" />
                            </td>
                        </tr>
                        <tr id="trQueryRow">
                            <td>
                                שאילתה:
                            </td>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                                    <ContentTemplate>
                                        <asp:DropDownList runat="server" ID="ddlQueries" Width="158px" CssClass="Borders"
                                            onchange="GetQuery(this.value);">
                                        </asp:DropDownList>
                                        <a class="a2" href="javascript:if(confirm('האם אתה בטוח ברצונך למחוק את השאילתה הבחורה?'))SetQueryData('1');"
                                            style="font-weight: 500;">מחק</a> <span style="display: none;">
                                                <asp:Button runat="server" ID="btnRefreshDDLQueries" OnClick="btnRefreshDDLQueries_click" />
                                                <asp:HiddenField runat="server" ID="hdnQueryID" />
                                            </span>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr id="trQueryName">
                            <td>
                                שם:
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txtQueryName" Width="155" CssClass="Borders"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:TextBox runat="server" ID="txtQuery" Width="235px" TextMode="MultiLine" Rows="20"
                                    CssClass="txtQuery"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trIMG">
                            <td class="EditForm item" style="vertical-align:top;">
                                תמונה:
                            </td>
                            <td class="EditForm val" style="height: 25px;">
                                <img src="../../Img/web.jpg" alt="" id="itemImg" style="cursor: pointer;" onclick="ShowAllImgs();" />
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: left; padding-left: 20px; margin-top: 13px;">
                        <table width="265px">
                            <tr>
                                <td style="padding: 5px;">
                                    <input type="button" value="שכפל" class="MSBtnGeneral" style="background-image: url('../../Img/forward.png');
                                        width: 80px;" onclick="SetDuplicate();" />
                                </td>
                                <td style="width: 90%;">
                                </td>
                                <td>
                                    <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                                        width: 80px;" onclick="SetQueryData('0');" />
                                    <%-- <ms:MSBtnGeneral ID="btnSave" OnClick="btnSave_click" runat="server" Width="85px"
                        Text="שמור" ImgURL="../../Img/ok.png" />--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="txtPartsGridContainer">
                <div class="QueryHeader">
                    <div class="QueryHeaderIn">
                        עמודות מקטע</div>
                </div>
                <div class="PartsEdit">
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
    <div id="dEditColsItem" class="EditWinColsItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinColItemEdit();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <div id="sHeadEdit">
                    עריכת עמודה
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    שם עמודה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditColName" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תצוגה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditColCaption" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סדר:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditColOrder" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    רוחב:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditColWidth" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סוג:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlEditColTypeID" Width="123px" CssClass="Borders">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    פורמט:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlEditColFormatID" Width="123px" CssClass="Borders">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    ישור:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlEditColAlignmentID" Width="123px" CssClass="Borders">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr style="display: none;">
                <td class="EditForm item">
                    אורך מקס':
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditColMaxLength" Width="120px" Text="0"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    עיצוב:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlEditColStyleID" Width="123px" CssClass="Borders">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סיכום:
                </td>
                <td class="EditForm val">
                    <asp:CheckBox ID="cbEditColIsSummary" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    ירידת שורה:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlNewrow" Width="123px" CssClass="Borders">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 80px;" onclick="SavePartColData('0');" />
            <asp:HiddenField runat="server" ID="hdnridmd" />
        </div>
    </div>
    <div id="divDuplicateReport" class="DuplicateReport">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinDuplicateReport();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <div id="Div5">
                    שכפול מקטע
                </div>
            </center>
        </div>
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    שם מקטע חדש:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtDupliactePartName" Width="120px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div id="div6" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שכפל" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 100px;" onclick="SetDuplicateAjax();" />
        </div>
    </div>
    <div id="dAllImgs" class="dAllImgs" runat="server" style="">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWindAllImgs();" />
        </div>
        <br />
        <br />
    </div>
    <script type="text/javascript">
        //setTimeout('SetMSG("עריכת מקטעים")', 100);


        function SetFocus(id) {
            $('#' + id).focus();
        }
        function GetQuery(val) {
            if (val == "0") {
                $('#<%=txtQuery.ClientID %>').val("");

                $('#<%=txtQueryName.ClientID %>').val("");
                setTimeout('SetFocus("<%=txtQueryName.ClientID %>")', 100);

                $('#trQueryName').show();

                return;
            }
            
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_GetQuery&idQuery=" + val + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                        //alert(response[0].Query.replace(/gty/gi,"'"));
                $('#<%=txtQuery.ClientID %>').val(response[0].Query.replace(/gty/gi,"'"));
                $('#<%=txtQueryName.ClientID %>').val(response[0].QueryName.replace(/gty/gi,"'"));
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {
                //alert();
                    $('#<%=txtQuery.ClientID %>').val($.parseJSON(jqXHR.responseText)[0].Query.replace(/gty/gi,"'"));
                $('#<%=txtQueryName.ClientID %>').val($.parseJSON(jqXHR.responseText)[0].QueryName.replace(/gty/gi,"'"));
                }
                else {
                    //alert("Error");
                }
            });
        }
        function setNew()
        {
            $('#<%=txtPartName.ClientID %>').val("");
            $('#<%=txtPartName.ClientID %>').focus();

            $('#<%=ddlPartTypes.ClientID %>').val("-1");
            $('#<%=ddlTopics.ClientID %>').val("-1");
            $('#<%=ddlQueries.ClientID %>').val("0");
            $('#<%=txtQuery.ClientID %>').val("");
            $('#<%=txtQueryName.ClientID %>').val("");
            $('#<%=cbhasHeaderSeparator.ClientID %>')[0].checked = false;
            $('#<%=cbhasFooterSeparator.ClientID %>')[0].checked = false;
            

            $("#jQGrid").jqGrid('GridUnload');
            SetGrid();
        }
        var SelectedPart = "0";
        function GetPartData(val) {
            SelectedPart=val;
            if (val == "0") {
                setNew();
                return;
            }
            
            

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_GetPartData&idPart=" + val + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=txtPartName.ClientID %>').val(response[0].PartName.replace(/gty/gi,"'"));
                $('#<%=ddlPartTypes.ClientID %>').val(response[0].idPartType);
                $('#<%=ddlTopics.ClientID %>').val(response[0].TopicID);
                $('#<%=ddlQueries.ClientID %>').val(response[0].idQuery);
                $('#<%=txtQuery.ClientID %>').val( response[0].Query.replace(/gty/gi,"'"));
                $('#<%=txtQueryName.ClientID %>').val(response[0].QueryName.replace(/gty/gi,"'"));
                
                $('#<%=cbhasHeaderSeparator.ClientID %>')[0].checked = response[0].hasHeaderSeparator == 1 ? true :false;
                $('#<%=cbhasFooterSeparator.ClientID %>')[0].checked = response[0].hasFooterSeparator == 1 ? true :false;
                
                $("#jQGrid").jqGrid('GridUnload');
                SetGrid();

                CheckForPic($('#<%=ddlPartTypes.ClientID %>').val());
                $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=" + response[0].LayoutImgID;
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
             
                    //$('#<%=txtQuery.ClientID %>').val($.parseJSON(jqXHR.responseText));
                }
                else {
                    //alert("Error");
                }
            });
        }
        function SetQueryData(isToDelete) {
            //if ($('#<%=ddlQueries.ClientID %>').val() == "0") {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetQueryData&idQuery=" + $('#<%=ddlQueries.ClientID %>').val() + "&QueryName=" + $('#<%=txtQueryName.ClientID %>').val()  + "&isToDelete="+isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: 'Query=' + escape($('#<%=txtQuery.ClientID %>').val().split('+').join('***'))
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=hdnQueryID.ClientID %>').val(response);
                $('#<%=btnRefreshDDLQueries.ClientID %>').click();
                SetPartData(response,'0');

               
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                //debugger;
                if (jqXHR.status == 200) {
                    $('#<%=hdnQueryID.ClientID %>').val(jqXHR.responseText);

                    $('#<%=btnRefreshDDLQueries.ClientID %>').click();
                    SetPartData(jqXHR.responseText,'0');
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                }
            });
            //}
            //            else {
            //                SetPartData($('#<%=ddlQueries.ClientID %>').val());
            //            }
        }
        function SetPartData(idQuery,isToDelete) {
       
            var hasHeaderSeparator = "0";
            if($('#<%=cbhasHeaderSeparator.ClientID %>')[0].checked)
                hasHeaderSeparator="1";

            var hasFooterSeparator = "0";
            if($('#<%=cbhasFooterSeparator.ClientID %>')[0].checked)
                hasFooterSeparator="1";

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetPartData&idPart=" + $('#<%=ddlParts.ClientID %>').val() + "&PartName=" + $('#<%=txtPartName.ClientID %>').val() + "&idPartType=" + 
                $('#<%=ddlPartTypes.ClientID %>').val() + "&idQuery=" + idQuery + "&isToDelete="+isToDelete+ "&TopicID="+$('#<%=ddlTopics.ClientID %>').val() +
                "&hasHeaderSeparator="+hasHeaderSeparator + "&hasFooterSeparator="+hasFooterSeparator +"&SelectedImg=" + SelectedImg +
                 "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=hdnPartID.ClientID %>').val(response);
                $('#<%=btnRefreshddlParts.ClientID %>').click();
                alert("הנתונים נשמרו בהצלחה");
                 opener.ReloadSections();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {

                    $('#<%=hdnPartID.ClientID %>').val(jqXHR);
                    $('#<%=btnRefreshddlParts.ClientID %>').click();
                    alert("הנתונים נשמרו בהצלחה");

                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                    //alert("Error");
                }
            });
        }
        function GetPartColData(PartColID) {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_GetPartColData&PartColID=" + PartColID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                 $('#<%=txtEditColName.ClientID %>').val(response[0].ColName.replace(/gty/gi,"'"));
                $('#<%=txtEditColCaption.ClientID %>').val(response[0].ColCaption.replace(/gty/gi,"'"));
                $('#<%=txtEditColOrder.ClientID %>').val(response[0].ColOrder);
                $('#<%=txtEditColWidth.ClientID %>').val(response[0].ColWidth);
                $('#<%=ddlEditColTypeID.ClientID %>').val(response[0].ColTypeID);
                $('#<%=ddlEditColFormatID.ClientID %>').val(response[0].FormatID);
                $('#<%=ddlEditColAlignmentID.ClientID %>').val(response[0].AlignmentID);
                $('#<%=txtEditColMaxLength.ClientID %>').val(response[0].ColMaxLength);
                $('#<%=ddlEditColStyleID.ClientID %>').val(response[0].StyleID);
                $('#<%=cbEditColIsSummary.ClientID %>')[0].checked = response[0].ColIsSummary == 1 ? true :false;
                $('#<%=ddlNewrow.ClientID %>').val(response[0].NewRowID);
                setTimeout("SetFocus('<%=txtEditColName.ClientID %>');",200);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {
                 
                  
                }
                else {
                    alert("אראה שגיאה בשליפת הנתונים");
                    //alert("Error");
                }
            });
        }
     
        function SavePartColData(isToDelete) {    
        var IsSummary  = $('#<%=cbEditColIsSummary.ClientID %>')[0].checked == true ? '1' : '0';
        

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetColData&PartColID=" + ridmd + "&idPart="+ $('#<%=ddlParts.ClientID %>').val() + "&ColName="+ $('#<%=txtEditColName.ClientID %>').val()
                + "&ColCaption="+ $('#<%=txtEditColCaption.ClientID %>').val() + "&ColOrder="+ $('#<%=txtEditColOrder.ClientID %>').val()
                + "&ColWidth="+ $('#<%=txtEditColWidth.ClientID %>').val() + "&ColTypeID="+ $('#<%=ddlEditColTypeID.ClientID %>').val()+ "&FormatID="+ $('#<%=ddlEditColFormatID.ClientID %>').val()
                + "&AlignmentID="+ $('#<%=ddlEditColAlignmentID.ClientID %>').val() + "&ColMaxLength="+ $('#<%=txtEditColMaxLength.ClientID %>').val() 
                + "&StyleID="+ $('#<%=ddlEditColStyleID.ClientID %>').val() + "&ColIsSummary="+ IsSummary + "&isToDelete="+isToDelete+ "&NewRow="+$('#<%=ddlNewrow.ClientID %>').val()
                +"&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                CloseWinColItemEdit();
                RefreshMD();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {
                    CloseWinColItemEdit();
                    RefreshMD();
                }
                else {
                    alert("אראה שגיאה בשליפת הנתונים");
                    //alert("Error");
                }
            });
        }
    function changeTitle(cellVal, options, rowObject){
            return  cellVal.replace(/gty/gi,"'");
        }
       function SetGrid() {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_GetPartCols&idPart=" + SelectedPart + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['שם', 'תצוגה', 'סדר', 'רוחב','סוג','פורמט','ישור','עיצוב','סיכום','ירידת שורה','PartColID'],
                colModel: [ { name: 'ColName', index: 'ColName', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColCaption', index: 'ColCaption', width: 100, sorttype: 'text', align: 'right', editable: true,formatter: changeTitle},
                            { name: 'ColOrder', index: 'ColOrder', width: 25, sorttype: 'int', align: 'right', editable: true },
                            { name: 'ColWidth', index: 'ColWidth', width: 50, sorttype: 'text', align: 'right', editable: true },
                            { name: 'TypeName', index: 'TypeName', width: 45, sorttype: 'text', align: 'right', editable: true },
                            { name: 'FormatString', index: 'FormatString', width: 90, sorttype: 'text', align: 'right', editable: true },
                            { name: 'Alignment', index: 'Alignment', width: 50, sorttype: 'text', align: 'right', editable: true },                            
                            { name: 'StyleName', index: 'StyleName', width: 60, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColIsSummary', index: 'ColIsSummary', width: 50, sorttype: 'text', align: 'right', editable: true },
                            { name: 'NewRow', index: 'NewRow', width: 50, sorttype: 'text', align: 'right', editable: true },
                            { name: 'PartColID', index: 'PartColID', width: 50, sorttype: 'text', align: 'right', editable: true,hidden:true }
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
                    var grid = $("#jQGrid"),
                    ids = grid.getDataIDs();

                    for (var i = 0; i < ids.length; i++) {
                        grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
                    }

                    initwData(data, $("#jQGrid"));
            },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    ridmd = row["PartColID"];                    
                    
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                   ridmd = row["PartColID"];
                   
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
        function doNone() {
            return false;
        }
        var ridmd = "0";
        var IsAddMD = true;
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
        function imageFormat(cellvalue, options, rowObject) {
            return '<img src="data:image/png;base64,' + cellvalue + '" />';
        }
        function imageUnFormat(cellvalue, options, cell) {
            return $('img', cell).attr('src');
        }
        
        function ShowEditFormMD() {
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר עמודה מן הגריד תחילה.");
                return;
            }
            if (ridmd != "") {
                SetColItemDataEdit(ridmd);
                IsAddMD = false;
                $('.EditWinColsItemBox').css("display", "block");
                var top = 500;
                $(".EditWinColsItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });
            }
            else {
                alert("אנא בחר עמודה");
            }
            return false;
        }
        function ShowAddFormMD() {
            
            IsAddMD = true;
            SetColItemDataNew();
            $('.EditWinColsItemBox').css("display", "block");
            var top = 500;
            $(".EditWinColsItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר עמודה מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את העמודה המסומנת מן הגריד?")) {
                SavePartColData('1');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }

        function setGridHeaderTextColor()
        {
            $('.ui-jqgrid-sortable').css("color","white");
        }
        function SetColItemDataNew()
        {
            ridmd = "0";
            $('#<%=txtEditColName.ClientID %>').val("");
            $('#<%=txtEditColCaption.ClientID %>').val("");
            $('#<%=txtEditColOrder.ClientID %>').val("");
            $('#<%=txtEditColWidth.ClientID %>').val("");
            $('#<%=ddlEditColTypeID.ClientID %>').val("-1");
            $('#<%=ddlEditColFormatID.ClientID %>').val("-1");
            $('#<%=ddlEditColAlignmentID.ClientID %>').val("-1");
            $('#<%=txtEditColMaxLength.ClientID %>').val("");
            $('#<%=ddlEditColStyleID.ClientID %>').val("-1");
            $('#<%=cbEditColIsSummary.ClientID %>')[0].checked = false;
            $('#<%=ddlNewrow.ClientID %>').val("1");
            setTimeout("SetFocus('<%=txtEditColName.ClientID %>');",200);
            
        }

         function SetColItemDataEdit(PartColID)
        {
            GetPartColData(PartColID);            
        }

        function SetDuplicate() {
            $('.DuplicateReport').css("display", "block");
            var top = 500;
            $(".DuplicateReport").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function SetDuplicateAjax() {

            CloseWinDuplicateReport();
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetDuplicatePart&DuplicateFromPartID=" + $('#<%=ddlParts.ClientID %>').val() + "&DuplicateToPartName=" + escape($('#<%=txtDupliactePartName.ClientID %>').val()) 
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ""
            });
            request.done(function (response, textStatus, jqXHR) {

                    $('#<%=hdnPartID.ClientID %>').val(response);
                    $('#<%=btnRefreshddlParts.ClientID %>').click();
                 
                    alert("הנתונים נשמרו בהצלחה");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
            
                if (jqXHR.status == 200) {
                        $('#<%=hdnPartID.ClientID %>').val(jqXHR.responseText);
                        $('#<%=btnRefreshddlParts.ClientID %>').click();

                        alert("הנתונים נשמרו בהצלחה");
                }
                else {
                    alert("אראה שגיאה בשמירת 2 הנתונים");
                    //alert("Error");
                }
            });
        }
        function CheckForPic(val)
        {
            if(val=='7')//pic
            {
                $('#trQueryName').hide();
                $('#trQueryRow').hide();
                $('#<%=txtQuery.ClientID %>').hide();
                $('#trIMG').show();
            }
            else
            {
                $('#trQueryName').show();
                $('#trQueryRow').show();
                $('#<%=txtQuery.ClientID %>').show();
                $('#trIMG').hide();
            }
        }
        function ShowAllImgs() {
            $('#<%= dAllImgs.ClientID%>').css("display", "block");
            var top = 500;
            $("#<%= dAllImgs.ClientID%>").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            //$('#dBody').block({ message: '' });
        }


        function SetImg(id) {
            $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=" + id;
            SelectedImg = id;
            CloseWindAllImgs();
        }

       if ('<%=LayoutTypeID %>'=='1')
            $('#nDes').attr("class", "menuLink Selected");
        else
            $('#nWeb').attr("class", "menuLink Selected");

       $('#trIMG').hide();
    </script>
    </form>
</body>
</html>
