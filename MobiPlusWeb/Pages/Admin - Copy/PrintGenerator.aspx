<%@ Page Title="מחולל הדפסות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="PrintGenerator.aspx.cs" Inherits="Pages_Admin_PrintGenerator" %>

<%@ Register TagPrefix="ms" TagName="MSBtnGeneral" Src="~/UsrCtl/MSBtnGeneral.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css">
    <script src="../../js/jquery-1.11.0.min.js"></script>
    <script src="../../js/jquery-1.10.2.js"></script>
    <script src="../../js/jquery-ui.js"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/NewMain.css" />
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        .ui-accordion-content
        {
            border: none;
            max-height:450px;
        }
    </style>
    <script>
        function SetAccordionLeft() {

            $(".accordionLeft").accordion({

                header: ".h3Left",
                active: false,
                collapsible: true,
                heightStyle: "content",
                heading: null,  //mandatory to provide Heading tag to attach event
                content: null, //mandatory to provide Content to show/hide
                headingEvent: "click",   //Attach Event
                active: 0, //By default visible element
                //to hide all on page load
                expandAll: "expandAll",   //Element name on Expand All Functionality attached
                collapsAll: "collapsAll", //Element name on Collapse All Functionality attached
                headingClass: "accordion-header",   //Accordion Heading Class
                contentClass: "accordion-content"   //Accordion Content Class
                /*}).mouseout(function () {
                $(this).accordion({
                active: false
                });*/
            });

            $(".dDoh1").accordion({

                header: ".h3Section",
                active: false,
                collapsible: true,
                heightStyle: "content",
                heading: null,  //mandatory to provide Heading tag to attach event
                content: null, //mandatory to provide Content to show/hide
                headingEvent: "click",   //Attach Event
                active: 0, //By default visible element
                //to hide all on page load
                expandAll: "",   //Element name on Expand All Functionality attached
                collapsAll: "", //Element name on Collapse All Functionality attached
                headingClass: "accordion-header",   //Accordion Heading Class
                contentClass: "accordion-content"   //Accordion Content Class
                /*}).mouseout(function () {
                $(this).accordion({
                active: false
                });*/
            });
        }



        function SetDraggable() {
            //$(".MSItem").draggable();
        }

        var RID = 0;
        function SetResizable() {
            ////            $(".dDohContainerLeft").resizable({
            ////                handles: 'n,  s, w',
            ////                // alsoResize: ".iiimg_" + SelID.toString(),
            ////                start: function (event, ui) { RID++; },
            ////                stop: function (event, ui) {
            ////                },
            ////                resize: function (event, ui) {
            ////                }
            ////            });


            //$(".dDohContainerLeft").resizable({ handles: "n, e, s, w, ne, se, sw, n" });
            // $('.ui-resizable-sw').addClass('ui-icon ui-icon-gripsmall-diagonal-sw');
        }

        function SetClick(obj) {
            $('.MSItemSelected').length > 0 ? $('.MSItemSelected')[0].className = 'MSRowItem' : '';
            obj.className = 'MSItemSelected';
            // SetDraggable();
        }
        function setOnStartUfterexpandAll() {
            $(".accordion").accordion({
                header: ".h3",
                active: false,
                collapsible: true,
                heightStyle: "content"
                /*}).mouseout(function () {
                $(this).accordion({
                active: false
                });*/
            });
        }
        function AddToPrinterSectionFromServer(htm) {
           // alert(htm);
            htm = htm.replace("-------------MTNImage------------------", "<img src='../../img/logo.jpg' alt='Demo'/>");        
            $('.accordionLeft').append(htm);
            $('.accordionLeft').accordion("refresh");
            collapsAll();

            setSortable();
            SetResizable();
            selRowLength_change($('#selRowLength').val());
        }

        function setSortable() {
            $(".accordionLeft").sortable({
                axis: "y",
                handle: "div",
                stop: function (event, ui) {
                    // IE doesn't register the blur when sorting
                    // so trigger focusout handlers to remove .ui-state-focus
                    // ui.item.children("div").triggerHandler("focusout");

                    // Refresh accordion to handle new order
                    // $(this).accordion("refresh");
                }
            });


        }
        function AddToPrinterSection(id, tiks) {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetRowSectionToPrn&ID=" + id + "&Tiks=" + tiks,
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                AddToPrinterSectionFromServer(response);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                //debugger;
                if (jqXHR.status == 200) {
                    AddToPrinterSectionFromServer(jqXHR.responseText);
                }
                else {
                    alert("אראה שגיאה בנתונים");
                }
            });
        }
        function AddToPrinterSectionByEdit(tiks, arrIDs) {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetRowSectionToPrn&ID=" + arrIDs[0] + "&Tiks=" + tiks,
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                AddToPrinterSectionFromServer(response);
                
                if (arrIDs.length > 1) {
                    arrIDs.shift();
                    if (arrIDs[0] != "")
                        AddToPrinterSectionByEdit(tiks + arrIDs[0], arrIDs);
                }
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                //debugger;
                if (jqXHR.status == 200) {
                    AddToPrinterSectionFromServer(jqXHR.responseText);

                    if (arrIDs.length > 1) {
                        arrIDs.shift();
                        if (arrIDs[0]!="")
                            AddToPrinterSectionByEdit(tiks + arrIDs[0], arrIDs);
                    }
                }
                else {
                    alert("אראה שגיאה בנתונים");
                }
            });
        }
        function CloseWinReportItemEdit() {

            $(".EditWinReportItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWinDuplicateReport() {

            $(".DuplicateReport").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseSection(id) {

            $('#' + id).parent().remove();
            return false;
        }
        function CloseWinParamsItemEdit() {

            $(".EditWinParamsItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWinParamsEditItemEdit() {

            $(".EditWinEditParamsItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
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
        }
        .ui-pg-table
        {
            background-color: #E2E3E4;
            font-size: 14px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <div class="dAllPr">
        <div class="option">
            <a href="#" class="expandAll a1">פתח הכל</a> | <a href="#" class="collapsAll a1">סגור
                הכל</a> | <a href="#" class="removeHeaderAll a1">ללא כותרות</a> | <a href="#" class="showHeaderAll a1">
                    כותרות</a> | <a href="#" class='a1' onclick="javascript:SetReshet();">רשת</a>
            | <span class='a1'>אורך שורה:</span><select id="selRowLength" onchange="selRowLength_change(this.value);">
                <option value="80">80</option>
                <option value="60" selected="selected">60</option>
                <option value="40">40</option>
            </select></div>
        <div class="dRightPrinterDohot">
            <div id="Div1">
                <div class="h3Header">
                    <div class="h3HeaderText">
                        דוחות</div>
                </div>
                <div class="dDohContainer1">
                    <div class="dDoh1" runat="server" id="Div2">
                        <asp:UpdatePanel runat="server" UpdateMode="Always">
                            <ContentTemplate>
                                <asp:DropDownList runat="server" ID="ddlDohot" CssClass="Borders" size="33" Width="182px"
                                    Style="padding-top: 10px;" onchange="GetReportHTM();GetReportRowLen();">
                                </asp:DropDownList>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div style="text-align: right; padding-top: 5px;">
                        <input type="button" value="חדש" class="MSBtnGeneral" style="background-image: url('../../Img/add1-16.png');
                            width: 89px;" onclick="ShowAddFormMD();" />
                        <input type="button" value="ערוך" class="MSBtnGeneral" style="background-image: url('../../Img/edit16.png');
                            width: 89px;" onclick="ShowEditFormMD();" />
                    </div>
                </div>
            </div>
        </div>
        <div class="dRightPrinter" style="overflow: hidden">
            <div id="accordion" style="overflow: hidden">
                <div class="h3Header">
                    <div class="h3HeaderText">
                        מקטעים</div>
                </div>
                <div class="dDohContainer1" style="overflow: hidden">
                    <div class="dDoh1" runat="server" id="dtblSections" style="overflow: hidden">
                    </div>
                    <div style="text-align: right; padding-top: 5px;">
                        <input type="button" value="מקטע חדש" class="MSBtnGeneral" style="background-image: url('../../Img/new doc.png');
                            width: 120px;" onclick="OpenEditSections('0');" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="dLeftPrn">
        <div class="dLeftPrinter">
            <div id="dReshet" style="position: absolute; display: none;">
            </div>
            <div id="accordionLeft" class="accordionLeft" onclick="SetHeaderLeft();" runat="server"
                style="text-align: left; direction: ltr;">
            </div>
        </div>
        <div class="dBtnsPr">
            <table width="815px">
                <tr>
                    <td style="">
                        <input type="button" value="שכפל" class="MSBtnGeneral" style="background-image: url('../../Img/forward.png');
                            width: 80px;" onclick="SetDuplicate();" />
                    </td>
                    <td style="width: 90%;">
                    </td>
                    <td>
                        <input type="button" value="שמור" class="MSBtnGeneral btnSave" style="background-image: url('../../Img/ok.png');
                            width: 100px;" onclick="SaveSections();" />
                        <%-- <ms:MSBtnGeneral ID="btnSave" OnClick="btnSave_click" runat="server" Width="85px"
                        Text="שמור" ImgURL="../../Img/ok.png" />--%>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div id="dEditColsItem" class="EditWinReportItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinReportItemEdit();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <div id="sHeadEdit">
                    עריכת דוח
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    שם דוח:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditReportName" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תאור:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditReportDesc" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    אורך שורה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtEditRowLen" Width="120px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div>
            &nbsp;<a href="#" onclick="ShowEditParams();">פרמטרים</a>
        </div>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 100px;" onclick="SetReport('0');" />
            <input type="button" value="מחק" id="btnDelReport" class="MSBtnGeneral" style="background-image: url('../../Img/X.png');
                width: 100px;" onclick="if(confirm('האם אתה בטוח ברצונך למחוק את הדוח הבחור?'))SetReport('1');" />
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
                    שכפול דוח
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    שם דוח חדש:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtDupliacteReportName" Width="120px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div id="div6" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שכפל" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 100px;" onclick="SetDuplicateAjax();" />
        </div>
    </div>
    <div id="EditWinParamsItemBox" class="EditWinParamsItemBox">
        <div class="dParmsGridContainer">
            <div class="JumpWiX">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinParamsItemEdit();" />
            </div>
            <div class="QueryHeader">
                <div class="QueryHeaderIn">
                    פרמטרים</div>
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
    <div id="EditWinEditParamsItemBox" class="EditWinEditParamsItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinParamsEditItemEdit();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
               <div class="QueryHeader">
                <div class="QueryHeaderIn">
                    עריכת פרמטר</div>
            </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">           
            <tr>
                <td class="EditForm item">
                    מזהה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtParameterName" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תצוגה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtParameterDescription" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סוג:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlParamterType" CssClass="Borders" Width="124px"
                        Style="padding-top: 10px;" onchange="checkForSQL(this.value);">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item" style="white-space: nowrap;">
                    סדר
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtParamOrder" Width="40px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item" style="white-space: nowrap;">
                    ב. מחדל:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtParameterDefaultValue" Width="120px"></asp:TextBox>
                </td>
            </tr>
            <tr id="trSQL" style="display:none;">
                <td class="EditForm item">
                    SQL:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtQuery" TextMode="MultiLine" Rows="8" Width="160px"
                        Style="direction: ltr; text-align: left;"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div id="div8" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 100px;" onclick="setParameter('0');" />
           <%-- <input type="button" value="מחק" id="Button1" class="MSBtnGeneral" style="background-image: url('../../Img/X.png');
                width: 100px;" onclick="if(confirm('האם אתה בטוח ברצונך למחוק את הדוח הבחור?'))SetReport('1');" />--%>
            <asp:HiddenField runat="server" ID="HiddenField1" />
        </div>
    </div>
    <div style="display: none;">
        <asp:HiddenField runat="server" ID="hdnSelectedPartID" />
        <asp:Button runat="server" ID="btnAddSecrtionHidden" OnClick="btnAddSecrtionHidden_Click" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:HiddenField runat="server" ID="hdnReportID" />
                <asp:Button runat="server" ID="btnRefreshReports" OnClick="btnRefreshReports_Click" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        function SetHeader() {
            $(".h3.ui-accordion-header").css("background", "#4071CA");
            $(".h3.ui-accordion-header.ui-state-active ").css("background", "#4071CA");
        }
        function SetHeaderLeft() {
            $(".h3Left.ui-accordion-header").css("background", "#4F81BD");
            $(".h3Left.ui-accordion-header.ui-state-active ").css("background", "#4F81BD");

            $(".h3Left3.ui-accordion-header").css("background", "#4F81BD");
            $(".h3Left3.ui-accordion-header.ui-state-active ").css("background", "#4F81BD");

            $(".h3Section.ui-accordion-header").css("background", "#4F81BD");
            $(".h3Section.ui-accordion-header.ui-state-active ").css("background", "#4F81BD");

            $(".h3Section.ui-accordion-header").css("background", "#4F81BD");
            $(".h3Section.ui-accordion-header.ui-state-active ").css("background", "#4F81BD");

            $(".divSections").css("padding-right", "1%");
            $(".divSections").css("overflow-x", "hidden");


        }

        $(".expandAll").click(function () {
            expandAll();
        });
        function collapsAll() {
            $(".dDohContainerLeft.ui-accordion-content.ui-helper-reset.ui-widget-content.ui-corner-bottom").hide();
            SetHeaderLeft();
        }
        function removeHeaderAll() {
            $('.h3Left').hide();
            $('.h3Left3').hide();
        }
        function showHeaderAll() {
            $('.h3Left').show();
            $('.h3Left3').show();
        }
        $(".collapsAll").click(function () {
            collapsAll();
        });
        $(".removeHeaderAll").click(function () {
            removeHeaderAll();
            expandAll();
        });
        $(".showHeaderAll").click(function () {
            showHeaderAll();
        });
        function expandAll() {
            SetAccordionLeftAll();
            // $(".ui-accordion-content").show();
            $(".dDohContainerLeft.ui-accordion-content.ui-helper-reset.ui-widget-content.ui-corner-bottom").show();
            //$(".divSections.ui-accordion-content.ui-helper-reset.ui-widget-content.ui-corner-bottom").hide();
        }
        function collapsAll2() {
            SetAccordionLeftAll();
            $(".dDohContainerLeft.ui-accordion-content.ui-helper-reset.ui-widget-content.ui-corner-bottom").hide();

        }
        function SetAccordionLeftAll() {
            SetAccordionLeft();
            SetHeaderLeft();
        }

        function SetReshet() {
            //debugger;
            if ($("#dReshet").css("display") == "none") {
                var RowWidth = $('#selRowLength').val() * 1.0;
                $("#dReshet").css("display", "block");

                var id = 8;
                var htm = "<table cellpadding='0' cellspacing='0' border='0' style='font-family:Courier New;border-color:#EEEEEE;font-size:12px;'>";
                htm += "<tr>";

                switch ($('#selRowLength').val()) {
                    case "80":
                        $("#dReshet").css("right", ($(".dRightPrinter").width() + $(".dRightPrinterDohot").width() + 31 * 1.0) + "px");
                        id = 7;
                        for (var i = 0; i < RowWidth + 8; i++) {
                            htm += "<td style='border:1px solid #EEEEEE;'>"
                                        + id.toString()
                                    + "</td>";

                            id++;
                            if (id > 9)
                                id = 0;
                        }
                        break;
                    case "60":
                        $("#dReshet").css("right", ($(".dRightPrinter").width() + $(".dRightPrinterDohot").width() + 31 * 1.0) + "px");
                        id = 9;
                        for (var i = 0; i < RowWidth + 5; i++) {
                            htm += "<td style='border:1px solid #EEEEEE;'>"
                                        + id.toString()
                                    + "</td>";

                            id++;
                            if (id > 9)
                                id = 0;
                        }
                        break;
                    case "40":
                        $("#dReshet").css("right", ($(".dRightPrinter").width() + $(".dRightPrinterDohot").width() + 31 * 1.0) + "px");
                        id = 9;
                        for (var i = 0; i < RowWidth + 2; i++) {
                            htm += "<td style='border:1px solid #EEEEEE;'>"
                                        + id.toString()
                                    + "</td>";

                            id++;
                            if (id > 9)
                                id = 0;
                        }
                        break;
                }


                htm += "</tr>";
                htm += "</table>";

                htm += "<table cellpadding='0' cellspacing='0' border='0' style='font-family:Courier New;border-color:#EEEEEE;font-size:14px;'>";
                for (var j = 0; j < 35; j++) {//lines
                    htm += "<tr>";

                    switch ($('#selRowLength').val()) {
                        case "80":
                            for (var i = 0; i < RowWidth + 8; i++) {
                                htm += "<td style='border:1px solid #EEEEEE;padding-right:7px;padding-top:16px;'>"
                                        + ""
                                    + "</td>";
                            }
                            break;
                        case "60":
                            for (var i = 0; i < RowWidth + 5; i++) {
                                htm += "<td style='border:1px solid #EEEEEE;padding-right:7px;padding-top:16px;'>"
                                        + ""
                                    + "</td>";
                            }
                            break;
                        case "40":
                            for (var i = 0; i < RowWidth + 2; i++) {
                                htm += "<td style='border:1px solid #EEEEEE;padding-right:7px;padding-top:16px;'>"
                                        + ""
                                    + "</td>";
                            }
                            break;
                    }


                    htm += "</tr>";
                }
                htm += "</table>";



                $("#dReshet").html(htm);
            }
            else {
                $("#dReshet").css("display", "none");
            }
        }

        function ShowEditFormMD() {
            ridmd = $('#<%=ddlDohot.ClientID %>').val();
            if (ridmd == null || ridmd == "0" || ridmd == "") {
                alert("אנא בחר דוח מן הרשימה תחילה.");
                return;
            }
            $("#jQGrid").jqGrid('GridUnload');
            SetGrid();
            if (ridmd != "") {
                SetReportItemDataEdit(ridmd);
                IsAddMD = false;
                $('.EditWinReportItemBox').css("display", "block");
                var top = 500;
                $(".EditWinReportItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });
            }
            else {
                alert("אנא בחר דוח");
            }
            return false;
        }
        function ShowAddFormMD() {

            IsAddMD = true;
            SeReportItemDataNew();
            $('.EditWinReportItemBox').css("display", "block");
            var top = 500;
            $(".EditWinReportItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }

        var ridmd = "0";
        function SeReportItemDataNew() {
            ridmd = "0";
            $('#sHeadEdit').text("דוח חדש");
            $('#<%=txtEditReportName.ClientID %>').val("");
            $('#<%=txtEditReportDesc.ClientID %>').val("");
            $('#<%=txtEditRowLen.ClientID %>').val("");

            $('#btnDelReport').css("visibility", "hidden");

            setTimeout("setFocusLocal('<%=txtEditReportName.ClientID %>');", 200);
        }
        function setFocusLocal(id) {
            $('#' + id).focus();
        }
        function SetReportItemDataEdit(ReportID) {
            ridmd = ReportID;
            $('#btnDelReport').css("visibility", "visible");
            $('#sHeadEdit').text("עריכת דוח");
            GetReportData();
        }
        function SetReport(isToDelete) {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetReport&id=" + ridmd + "&reportName=" + $('#<%=txtEditReportName.ClientID %>').val() + "&reportDesc=" + $('#<%=txtEditReportDesc.ClientID %>').val() + "&rowLen=" + $('#<%=txtEditRowLen.ClientID %>').val() + "&isToDelete=" + isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=hdnReportID.ClientID %>').val(response);
                $('#<%=btnRefreshReports.ClientID %>').click();
                alert("הנתונים נשמרו בהצלחה");
                CloseWinReportItemEdit();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {

                    $('#<%=hdnReportID.ClientID %>').val(jqXHR);
                    $('#<%=btnRefreshReports.ClientID %>').click();
                    alert("הנתונים נשמרו בהצלחה");
                    CloseWinReportItemEdit();
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                    //alert("Error");
                }
            });
        }
        function GetReportData() {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_GetReportData&id=" + ridmd + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

                $('#<%=txtEditReportName.ClientID %>').val(response[0].reportName);
                $('#<%=txtEditReportDesc.ClientID %>').val(response[0].reportDesc);
                $('#<%=txtEditRowLen.ClientID %>').val(response[0].rowLen);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {

                    $('#<%=txtEditReportName.ClientID %>').val(jqXHR.reportName);
                    $('#<%=txtEditReportDesc.ClientID %>').val(jqXHR.reportDesc);
                    $('#<%=txtEditRowLen.ClientID %>').val(jqXHR.rowLen);
                }
                else {
                    alert("אראה שגיאה בטעינת הנתונים");
                    //alert("Error");
                }
            });
        }
        function SaveSections() {
            if ($('#<%=ddlDohot.ClientID %>').val() == "0" || $('#<%=ddlDohot.ClientID %>').val() == "" || $('#<%=ddlDohot.ClientID %>').val() == null) {
                alert("אנא בחר דוח מן הרשימה תחילה.");
                return;
            }
            var json = "[";
            for (var i = 0; i < $(".accordionLeft")[0].childNodes.length; i++) {
                json += "{";

                json += "\"ReportID\":\"" + $('#<%=ddlDohot.ClientID %>').val() + "\"";
                json += ",\"PartID\":\"" + $(".accordionLeft")[0].childNodes[i].children[0].id.split('_')[1] + "\"";
                json += ",\"Order\":\"" + (i + 1).toString() + "\"";

                if (i < $(".accordionLeft")[0].childNodes.length - 1)
                    json += "},";
                else
                    json += "}";
            }
            json += "]";

            //$('#dBody')[0].innerHTML = $('#dBody')[0].innerHTML + "<br/><br/>" + json;

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetPartsToReport&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                //contentType: "application/json; charset=utf-8",
                //dataType: "json",
                data: 'strHTM=' + escape($(".accordionLeft").html()) + '&strJson=' + escape(json)
            });
            request.done(function (response, textStatus, jqXHR) {

                if (response == "True")
                    alert("הנתונים נשמרו בהצלחה");
                else
                    alert("אראה שגיאה בשמירת הנתונים");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                //debugger;
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True")
                        alert("הנתונים נשמרו בהצלחה");
                    else
                        alert("אראה שגיאה בשמירת הנתונים");
                }
                else {
                    alert("אראה שגיאה בשמירת 2 הנתונים");
                    //alert("Error");
                }
            });
        }
        function ReloadSections() {
       
            if ($('#<%=ddlDohot.ClientID %>').val() == "0" || $('#<%=ddlDohot.ClientID %>').val() == "" || $('#<%=ddlDohot.ClientID %>').val() == null) {
                alert("אנא בחר דוח מן הרשימה תחילה.");
                return;
            }
           
            var secIds = "";
            for (var i = 0; i < $(".accordionLeft")[0].childNodes.length; i++) {
                secIds+=$(".accordionLeft")[0].childNodes[i].children[0].id.split('_')[1] + ",";
            }

            $(".accordionLeft").html("");

            var arr = secIds.split(',');
        
            AddToPrinterSectionByEdit('<%= DateTime.Now.Ticks.ToString()%>',arr);
           
            $('.accordionLeft').accordion("refresh");
        }
        function GetReportHTM() {

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=prn_GetReportAllData&ReportID=" + $('#<%=ddlDohot.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $(".accordionLeft").html(response);

                setTimeout('expandAll()', 40);
                setTimeout('setOnStartUfterexpandAll()', 25);
                setTimeout('SetResizable()', 45);
                setTimeout('setSortable()', 145);
                $('.accordionLeft').accordion("refresh");

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    $(".accordionLeft").html(jqXHR.responseText);
                    setTimeout('expandAll()', 40);
                    setTimeout('setOnStartUfterexpandAll()', 25);
                    setTimeout('SetResizable()', 45);
                    setTimeout('setSortable()', 145);
                    $('.accordionLeft').accordion("refresh");
                }
                else {
                    alert("אראה שגיאה בשליפת הנתונים");
                    //alert("Error");
                }
            });
        }

        function GetReportRowLen() {

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=prn_GetReportRowLen&ReportID=" + $('#<%=ddlDohot.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#selRowLength').val(response);
                selRowLength_change($('#selRowLength').val());

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    $(".accordionLeft").html(jqXHR.responseText);
                    $('#selRowLength').val(jqXHR.responseText);
                    selRowLength_change($('#selRowLength').val());

                }
                else {
                    alert("אראה שגיאה בשליפת הנתונים");
                    //alert("Error");
                }
            });
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
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_SetDuplicateReport&DuplicateFromReportCode=" + $('#<%=ddlDohot.ClientID %>').val() + "&DuplicateToReportName=" + escape($('#<%=txtDupliacteReportName.ClientID %>').val())
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ""
            });
            request.done(function (response, textStatus, jqXHR) {

                $('#<%=hdnReportID.ClientID %>').val(response);
                $('#<%=btnRefreshReports.ClientID %>').click();

                alert("הנתונים נשמרו בהצלחה");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {
                    $('#<%=hdnReportID.ClientID %>').val(jqXHR.responseText);
                    $('#<%=btnRefreshReports.ClientID %>').click();

                    alert("הנתונים נשמרו בהצלחה");
                }
                else {
                    alert("אראה שגיאה בשמירת 2 הנתונים");
                    //alert("Error");
                }
            });
        }
        function OpenEditSections(id) {
            var width = 1200.0;
            var height = 670.0;
            var left = (screen.width / 2.0) - (width / 2.0);
            var top = (screen.height / 2.0) - (height / 2.0);

            var win = window.open("EditPrnPart.aspx?ID=" + id, 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes');
            win.focus();
        }

        function selRowLength_change(val) {

            switch (val) {
                case "80":
                    $('.dDohContainerLeft').width("745px");
                    $('.h3Left').width("745px");

                    $('.h3LeftContainer').width("785px");
                    $('.accordionLeft').width("795px");
                    $('.tblLeft3').width("795px");
                    $('.tblLeft3').css("padding-right", "10px");
                    $('.dLeftPrinter').width("815px");
                    $('.dLeftPrn').width("815px");
                    $('.btnSave').css("margin-left", "0px");
                    $('.h3Left').css("padding-right", "0px");
                    $('.h3Left').css("padding-left", "45px");
                    break;
                case "60":

                    $('.dDohContainerLeft').width("545px");
                    $('.h3Left').width("600px");
                    $('.h3LeftContainer').width("585px");
                    $('.accordionLeft').width("595px");
                    $('.tblLeft3').width("590px");
                    $('.tblLeft3').css("padding-right", "10px");
                    $('.dLeftPrinter').width("615px");
                    $('.dLeftPrn').width("615px");
                    $('.btnSave').css("margin-left", "200px");
                    $('.h3Left').css("padding-left", "0px");

                    break;
                case "40":
                    $('.dDohContainerLeft').width("345px");
                    $('.h3Left').width("400px");

                    $('.h3LeftContainer').width("385px");
                    $('.accordionLeft').width("395px");
                    $('.tblLeft3').width("390px");
                    $('.tblLeft3').css("padding-right", "10px");
                    $('.dLeftPrinter').width("415px");
                    $('.dLeftPrn').width("415px");
                    $('.btnSave').css("margin-left", "400px");
                    $('.h3Left').css("padding-left", "0px");

                    break;
            }
            if ($("#dReshet").css("display") != "none") {
                $("#dReshet").css("display", "none");
                SetReshet();
            }

        }

        function ShowEditParams() {

            //ridmd = $('#<%=ddlDohot.ClientID %>').val();

            //if (ridmd != "") {
            //SetReportItemDataEdit(ridmd);
            //IsAddMD = false;
            $('.EditWinParamsItemBox').css("display", "block");
            var top = 500;
            $(".EditWinParamsItemBox").css({ top: top })
                    .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });

            return false;
        }

        function SetGrid() {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_GetReportParams&reportCode=" + $('#<%=ddlDohot.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','דוח', 'מזהה', 'תיאור','סוג', 'ב. מחדל','סדר','ParamterTypeID','Query'],
                colModel: [ { name: 'ReportParameterID', index: 'ReportParameterID', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'reportName', index: 'reportName', width: 90, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ParameterName', index: 'ParameterName', width: 100, sorttype: 'text', align: 'right', editable: true},
                            { name: 'ParameterDescription', index: 'ParameterDescription', width: 118, sorttype: 'int', align: 'right', editable: true },
                            { name: 'ParamterTypeName', index: 'ParamterTypeName', width: 50, sorttype: 'text', align: 'right', editable: true },                            
                            { name: 'ParameterDefaultValue', index: 'ParameterDefaultValue', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ParameterOrder', index: 'ParameterOrder', width: 45, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ParamterTypeID', index: 'ParamterTypeID', width: 45, sorttype: 'text', align: 'right', editable: true ,hidden:true},
                            { name: 'Query', index: 'Query', width: 45, sorttype: 'text', align: 'right', editable: true ,hidden:true}
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
                    ridmdparam =id;    
                    riReportParameterID = row["ReportParameterID"];                
                    
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    ridmdparam = id;
                    riReportParameterID = row["ReportParameterID"];
                   
                    ShowEditFormMDGrid();
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
        
        function doNone() {
            return false;
        }
        var ridmdparam = "0";
        var riReportParameterID = "0";
        var IsAddMD = true;
        function initwData(data, objMain) {
            $(".ui-pg-div").click(doNone);

            $("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMDGrid;

            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMDParams;

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
        
        function ShowEditFormMDGrid() {
            if(ridmdparam=="0" || ridmdparam =="") {
                alert("אנא בחר פרמטר מן הגריד תחילה.");
                return;
            }
            if (ridmdparam != "") {
                SetParamDataEdit(ridmdparam);
                IsAddMD = false;
                $('.EditWinEditParamsItemBox').css("display", "block");
                var top = 500;
                $(".EditWinEditParamsItemBox").css({ top: top })
                        .animate({ "top": "200px" }, "high");
                $('#dBody').block({ message: '' });
            }
            else {
                alert("אנא בחר עמודה");
            }
            return false;
        }
        function ShowAddFormMDParams() {
            ridmdparam = "0";
            IsAddMD = true;
            SetParamItemDataNew();
            $('.EditWinEditParamsItemBox').css("display", "block");
            var top = 500;
            $(".EditWinEditParamsItemBox").css({ top: top })
                        .animate({ "top": "200px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            
            if(ridmdparam=="0" || ridmdparam =="") {
                alert("אנא בחר פרמטר מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את הפרמטר המסומן מן הגריד?")) {
                setParameter('1');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function SetParamItemDataNew()
        {
            ridmdparam = "0";
            $('#<%=txtParameterName.ClientID %>').val("");
            $('#<%=txtParameterDescription.ClientID %>').val("");
            $('#<%=ddlParamterType.ClientID %>').val("-1");
            $('#<%=txtParameterDefaultValue.ClientID %>').val("");
            $('#<%=txtQuery.ClientID %>').val("");            
            $('#<%=txtParamOrder.ClientID %>').val("");  
            $('#trSQL').hide();  
            $('.EditWinEditParamsItemBox').height("240px");
        }
        function SetParamDataEdit(id)
        {      
            var data = $('#jQGrid').jqGrid('getRowData', id);
            $('#<%=txtParameterName.ClientID %>').val(data["ParameterName"]);
            $('#<%=txtParameterDescription.ClientID %>').val(data["ParameterDescription"]);
            $('#<%=ddlParamterType.ClientID %>').val(data["ParamterTypeID"]);
            $('#<%=txtParameterDefaultValue.ClientID %>').val(data["ParameterDefaultValue"]);
            $('#<%=txtQuery.ClientID %>').val(data["Query"]);   
            $('#<%=txtParamOrder.ClientID %>').val(data["ParameterOrder"]);              

            $('.EditWinEditParamsItemBox').height("240px");
            $('#trSQL').hide();  
            if(data["ParamterTypeID"]=="7")
            {
                $('.EditWinEditParamsItemBox').height("380px");
                $('#trSQL').show();  
            }

        }
        function setParameter(istoDelete)
        {        
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Prn_Set_ReportParameter&ReportParameterID=" + riReportParameterID + "&reportCode=" + $('#<%=ddlDohot.ClientID %>').val()+"&ParameterName="+ $('#<%=txtParameterName.ClientID %>').val()
                +"&ParameterDescription="+ $('#<%=txtParameterDescription.ClientID %>').val()
                +"&ParameterDefaultValue="+ $('#<%=txtParameterDefaultValue.ClientID %>').val()
                +"&ParameterOrder="+ $('#<%=txtParamOrder.ClientID %>').val()
                +"&ParamterTypeID="+ $('#<%=ddlParamterType.ClientID %>').val()
                +"&IsToDelete="+ istoDelete
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: "ParamQuery="+escape($('#<%=txtQuery.ClientID %>').val().split('+').join('***'))
            });
            request.done(function (response, textStatus, jqXHR) {

               if(response=="True")
               {
                    CloseWinParamsEditItemEdit();
                    $("#jQGrid").jqGrid('GridUnload');
                    SetGrid();
                    alert("הנתונים נשמרו בהצלחה");
                }
                else
                alert("אראה שגיאה בשמירת הנתונים");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {                    
                    CloseWinParamsEditItemEdit();
                    $("#jQGrid").jqGrid('GridUnload');
                    SetGrid();
                    alert("הנתונים נשמרו בהצלחה");
                }
                else {
                    alert("אראה שגיאה בשמירת 2 הנתונים");
                    //alert("Error");
                }
            });
        }
        function checkForSQL(val)
        {
            $('.EditWinEditParamsItemBox').height("240px");
            $('#trSQL').hide();  
            if(val=="7")
            {
                $('.EditWinEditParamsItemBox').height("380px");
                $('#trSQL').show();  
            }
        }

        setTimeout('expandAll()', 40);
        setTimeout('setOnStartUfterexpandAll()', 25);
        setTimeout('SetResizable()', 45);
        setTimeout('setSortable()', 145);

        setTimeout('SetMSG("מחולל הדפסות")', 100);


        selRowLength_change($('#selRowLength').val());

        $('#nDes').attr("class", "menuLink Selected");
    </script>
</asp:Content>
