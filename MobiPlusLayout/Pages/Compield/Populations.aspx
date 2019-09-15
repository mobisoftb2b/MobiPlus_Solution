<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Populations.aspx.cs" Inherits="Pages_Compield_Populations" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>אוכלוסיות</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/Main.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/json2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
  
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
             var href;
             switch (lang) {
                 case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>""; break;
                 case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>""; break;
                 default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
             }
             document.getElementById('MainStyleSheet').href = href;
        }
        styler();
    </script>
    <%-- <link href="../../css/MainLTR.css" rel="stylesheet" />--%>
    <script type="text/javascript">
        function CloseEditWinPopItemBox() {
            $(".dEditWinPopItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBodyr").unblock();
        }
        function SetAccordion() {

            $("#Accordion").accordion({

                header: ".header",
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
        }

    </script>
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv {
            overflow-y: auto;
            min-height: 450px;
        }

        .ui-jqgrid-titlebar {
            background-color: #E2E3E4;
        }

        .ui-jqgrid-sortable {
            font-size: 14px;
            font-weight: 700;
        }

        .ui-pg-table {
            background-color: #E2E3E4;
            font-size: 14px;
        }

        .ui-widget-content {
            background-color: White !important;
            color: Black;
            text-align: right;
        }

        #searchmodfbox_jQGrid {
            background-color: gray !important;
        }

        .ui-paging-info {
            display: none;
        }
    </style>
</head>
<body id="dBodyr" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <div class="dProfileAll">
            <div class="txtPartsGridContainer" style="width: 685px; height: 715px">
                <div class="PopHeader" style="height: 30px; font-size: 18px;">
                    <div class="QueryHeaderIn">
                        <%=StrSrc("HeadText1")%>
                    </div>
                </div>
                <div class="PartsEdit" style="padding-top: 5px;">
                    <div id="Accordion">
                        <div>
                            <div class="header">
                                <%=StrSrc("HeadText2")%>
                            </div>
                            <div>
                                <div class="" style="text-align: right;">
                                    <table id="jQGrid">
                                    </table>
                                    <div id="jQGridPager">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div>
                            <div class="header">
                                <%=StrSrc("HeadText3")%>
                            </div>
                            <div>
                                <div class="" style="text-align: right;">
                                    <table id="jQGridCust">
                                    </table>
                                    <div id="jQGridCustPager">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div>
                            <div class="header">
                                <%=StrSrc("HeadText4")%>
                            </div>
                            <div>
                                <div class="" style="text-align: right;">
                                    <table id="jQGridItems">
                                    </table>
                                    <div id="jQGridItemsPager">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div>
                            <div class="header">
                                <%=StrSrc("HeadText5")%>
                            </div>
                            <div>
                                <div class="" style="text-align: right;">
                                    <table id="jQGridCategories">
                                    </table>
                                    <div id="jQGridPagerCategories">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="dEditWinPopItemBox" class="dEditWinPopItemBox">
            <div class="JumpWiX">
                <img alt="<%=StrSrc("Close")%>" src="../../img/X.png" class="imngX" onclick="CloseEditWinPopItemBox();" />
            </div>
            <div style="padding-top: 3px; background-color: #4F81BD;">
                <center>
                    <div id="sHeadEdit">
                        <%=StrSrc("HeadEdit")%>
                   
                    </div>
                </center>
            </div>
            <br />
            <table cellpadding="2" cellspacing="2">
                <tr>
                    <td class="EditForm item">
                        <%=StrSrc("Description")%>:
                    </td>
                    <td class="EditForm val">
                        <asp:TextBox runat="server" ID="txtPopulationDescription" Width="368px"></asp:TextBox>
                    </td>
                </tr>
                <tr id="rAgent">
                    <td class="EditForm item" style="vertical-align: top;">
                        <%=StrSrc("Query")%>:
                    </td>
                    <td class="EditForm val">
                        <asp:TextBox runat="server" ID="txtPopulationQuery" Width="366px" TextMode="MultiLine"
                            Rows="10" Style="direction: ltr; text-align: left;"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
                <input type="button" value="<%=StrSrc("Save")%>" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png'); width: 80px;"
                    onclick="SetPopData('0', '2');" />
                <asp:HiddenField runat="server" ID="hdnridmd" />
            </div>
        </div>
    </form>
    <script type="text/javascript">
        function SetHeader() {
            $(".header.ui-accordion-header").css("background", "#4071CA");
            $(".header.ui-accordion-header.ui-state-active ").css("background", "#4071CA");
            $(".ui-widget-content").css("background", "#4071CA");
            $(".ui-widget-content").width($(".header.ui-accordion-header").width() - 22);

        }
        SetAccordion();
        SetHeader();

        $('#dBodyr').height($(document).height());

        function SetPopData(isToDelete, PopulationTypeID) {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetPopulationData&PopulationID=" + ridmd + "&PopulationTypeID=" + PopulationTypeID + "&PopulationDescription=" + $('#<%=txtPopulationDescription.ClientID %>').val()
                + "&IsToDelete=" + isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: 'PopulationQuery=' + escape($('#<%=txtPopulationQuery.ClientID %>').val().split('+').join('***').split("'").join("&&&"))
            });
            request.done(function (response, textStatus, jqXHR) {
                CloseEditWinPopItemBox();
                if (PopulationTypeID == "1")
                    RefreshMD();
                else if (PopulationTypeID == "2")
                    RefreshMDCust();
                else if (PopulationTypeID == "3")
                    RefreshMDItems();
                else if (PopulationTypeID == "4")
                    RefreshMDCategories();

                ridmd = "0";
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True") {
                        CloseEditWinPopItemBox();
                        if (PopulationTypeID == "1")
                            RefreshMD();
                        else if (PopulationTypeID == "2")
                            RefreshMDCust();
                        else if (PopulationTypeID == "3")
                            RefreshMDItems();
                        else if (PopulationTypeID == "4")
                            RefreshMDCategories();

                        ridmd = "0";
                    }
                    else {
                     
                        alert('<%=StrSrc("ErrorSaving")%>'+" - " + jqXHR.responseText);
                    }
                }
                else {
                    alert('<%=StrSrc("ErrorSaving")%>');
                    //alert("Error");
                }
            });
        }


        function initwData(data, objMain, GridID) {
            if (GridID == "jQGrid") {
                $(".ui-pg-div").click(doNone);

                $("#edit_" + GridID)[0].children[0].onclick = ShowEditFormMD;

                $("#add_" + GridID)[0].children[0].onclick = ShowAddFormMD;

                $("#del_" + GridID)[0].children[0].onclick = ShowDeleteFormMD;

                $("#search_" + GridID)[0].children[0].onclick = ShowSearchFormMD;

                $("#refresh_" + GridID)[0].children[0].onclick = RefreshMD;
            }
            else if (GridID == "jQGridCust") {
                $("#edit_" + GridID)[0].children[0].onclick = ShowEditFormMDCust;

                $("#add_" + GridID)[0].children[0].onclick = ShowAddFormMDCust;

                $("#del_" + GridID)[0].children[0].onclick = ShowDeleteFormMDCust;

                $("#search_" + GridID)[0].children[0].onclick = ShowSearchFormMDCust;

                $("#refresh_" + GridID)[0].children[0].onclick = RefreshMDCust;
            }
            else if (GridID == "jQGridItems") {
                $("#edit_" + GridID)[0].children[0].onclick = ShowEditFormMDItems;

                $("#add_" + GridID)[0].children[0].onclick = ShowAddFormMDItems;

                $("#del_" + GridID)[0].children[0].onclick = ShowDeleteFormMDItems;

                $("#search_" + GridID)[0].children[0].onclick = ShowSearchFormMDItems;

                $("#refresh_" + GridID)[0].children[0].onclick = RefreshMDItems;
            }
            else if (GridID == "jQGridCategories") {
                $("#edit_" + GridID)[0].children[0].onclick = ShowEditFormMDCategories;

                $("#add_" + GridID)[0].children[0].onclick = ShowAddFormMDCategories;

                $("#del_" + GridID)[0].children[0].onclick = ShowDeleteFormMDCategories;

                $("#search_" + GridID)[0].children[0].onclick = ShowSearchFormMDCategories;

                $("#refresh_" + GridID)[0].children[0].onclick = RefreshMDCategories;
            }
        }
        function SetClick(PopulationTypeID) {
            SetPopData('0', PopulationTypeID);
        }
        function SetDel(PopulationTypeID) {
            SetPopData('1', PopulationTypeID);
        }
        /************************************************************************/
        function RefreshMDCategories() {
            $('#jQGridCategories').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }

        function ShowEditFormMDCategories() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("4")');

            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (ridmd != "") {
                $('#<%=txtPopulationDescription.ClientID %>').val(Row["PopulationDescription"]);
                $('#<%=txtPopulationQuery.ClientID %>').val(Row["PopulationQuery"].replace(/gty/gi, "'"));

                IsAddMD = false;
                $('.dEditWinPopItemBox').css("display", "block");
                var top = 500;
                $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMDCategories() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("4")');
            $('#<%=txtPopulationDescription.ClientID %>').val("");
           $('#<%=txtPopulationQuery.ClientID %>').val("");

            ridmd = "0";
            IsAddMD = true;
            $('.dEditWinPopItemBox').css("display", "block");
            var top = 500;
            $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
        function ShowCtlPopulationsCategories() {

            $('.ctlPopulations').css("display", "block");
            var top = 450;
            $(".ctlPopulations").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            //$('#dBodyr').block({ message: '' });
        }
        function ShowDeleteFormMDCategories() {
            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (confirm('<%=StrSrc("ConfirmDelete")%>'+"?")) {
                SetPopData('1', '3');
            }
        }

        function ShowSearchFormMDCategories() {
            $("#jQGridCategories").searchGrid({ closeAfterSearch: false });
        }
        /************************************************************************/
        function RefreshMDItems() {
            $('#jQGridItems').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }

        function ShowEditFormMDItems() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("3")');

            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (ridmd != "") {
                $('#<%=txtPopulationDescription.ClientID %>').val(Row["PopulationDescription"]);
                $('#<%=txtPopulationQuery.ClientID %>').val(Row["PopulationQuery"].replace(/gty/gi, "'"));

                IsAddMD = false;
                $('.dEditWinPopItemBox').css("display", "block");
                var top = 500;
                $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMDItems() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("3")');
            $('#<%=txtPopulationDescription.ClientID %>').val("");
           $('#<%=txtPopulationQuery.ClientID %>').val("");

            ridmd = "0";
            IsAddMD = true;
            $('.dEditWinPopItemBox').css("display", "block");
            var top = 500;
            $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
        function ShowCtlPopulationsItems() {

            $('.ctlPopulations').css("display", "block");
            var top = 450;
            $(".ctlPopulations").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            //$('#dBodyr').block({ message: '' });
        }
        function ShowDeleteFormMDItems() {
            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (confirm('<%=StrSrc("ConfirmDelete")%>'+"?")) {
                SetPopData('1', '3');
            }
        }

        function ShowSearchFormMDItems() {
            $("#jQGridItems").searchGrid({ closeAfterSearch: false });
        }
        /************************************************************************/
        function RefreshMDCust() {
            $('#jQGridCust').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }

        function ShowEditFormMDCust() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("1")');

            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (ridmd != "") {
                $('#<%=txtPopulationDescription.ClientID %>').val(Row["PopulationDescription"]);
                $('#<%=txtPopulationQuery.ClientID %>').val(Row["PopulationQuery"].replace(/gty/gi, "'"));

                IsAddMD = false;
                $('.dEditWinPopItemBox').css("display", "block");
                var top = 500;
                $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMDCust() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("1")');
            $('#<%=txtPopulationDescription.ClientID %>').val("");
           $('#<%=txtPopulationQuery.ClientID %>').val("");

            ridmd = "0";
            IsAddMD = true;
            $('.dEditWinPopItemBox').css("display", "block");
            var top = 500;
            $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
        function ShowCtlPopulationsCust() {

            $('.ctlPopulations').css("display", "block");
            var top = 450;
            $(".ctlPopulations").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            //$('#dBodyr').block({ message: '' });
        }
        function ShowDeleteFormMDCust() {
            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (confirm('<%=StrSrc("ConfirmDelete")%>'+"?")) {
                SetPopData('1', '1');
            }
        }

        function ShowSearchFormMDCust() {
            $("#jQGridCust").searchGrid({ closeAfterSearch: false });
        }
        /************************************************************************/
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        var ridmd = "0";
        function ShowEditFormMD() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("2")');
            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (ridmd != "") {
                $('#<%=txtPopulationDescription.ClientID %>').val(Row["PopulationDescription"]);
                $('#<%=txtPopulationQuery.ClientID %>').val(Row["PopulationQuery"].replace(/gty/gi, "'"));

                IsAddMD = false;
                $('.dEditWinPopItemBox').css("display", "block");
                var top = 500;
                $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMD() {
            $('.MSBtnGeneral').attr('onclick', 'SetClick("2")');

            $('#<%=txtPopulationDescription.ClientID %>').val("");
            $('#<%=txtPopulationQuery.ClientID %>').val("");

            ridmd = "0";
            IsAddMD = true;
            $('.dEditWinPopItemBox').css("display", "block");
            var top = 500;
            $(".dEditWinPopItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
        function ShowCtlPopulations() {

            $('.ctlPopulations').css("display", "block");
            var top = 450;
            $(".ctlPopulations").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            //$('#dBodyr').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            $('.MSBtnGeneral').attr('onclick', 'SetDel("1")');
            if (ridmd == "0" || ridmd == "") {
                alert('<%=StrSrc("SelectPopulation")%>'+".");
                return;
            }
            if (confirm('<%=StrSrc("ConfirmDelete")%>'+"?")) {
                SetPopData('1', '2');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function doNone() {
            return false;
        }
        var Row;
        var ridmd = "0";
        function SetGrid(GridID, jQGridPager, PopulationTypeID) {
            $("#" + GridID).jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetPopulations&PopulationTypeID=" + PopulationTypeID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "<%=StrSrc("dir")%>",
                colNames: ['#',' <%=StrSrc("Description")%>',' <%=StrSrc("Query")%>'],
                colModel: [{ name: 'PopulationID', index: 'PopulationID', width: 70, sorttype: 'int', align: 'right', editable: true },
                            { name: 'PopulationDescription', index: 'PopulationDescription', width: 140, sorttype: 'text', align: 'right', editable: true },
                            { name: 'PopulationQuery', index: 'PopulationQuery', width: 400, sorttype: 'text', align: 'left', editable: true }
                ],
                rowNum: 70,
                mtype: 'POST',
                loadonce: true,
                //rowList: [10, 20, 30],
                pager: '#' + jQGridPager,
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,

                loadComplete: function (data) {
                    $('.ui-pg-input')[0].parentElement.childNodes[0].data = " <%=StrSrc("Page")%> ";
                    $('.ui-pg-input')[0].parentElement.childNodes[2].data = " <%=StrSrc("of")%> ";
                    $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";
                    var grid = $("#" + GridID),
                    ids = grid.getDataIDs();

                    for (var i = 0; i < ids.length; i++) {
                        grid.setRowData(ids[i], false, { height: 20 + (i * 2) });
                    }

                    initwData(data, $("#" + GridID), GridID);
                },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#' + GridID).jqGrid('getRowData', id);
                    Row = row;
                    ridmd = row["PopulationID"];

                },
                ondblClickRow: function (id) {

                    var row = $('#' + GridID).jqGrid('getRowData', id);
                    Row = row;
                    ridmd = row["PopulationID"];

                    if (GridID == "jQGrid")
                        ShowEditFormMD();
                    else if (GridID == "jQGridCust")
                        ShowEditFormMDCust();
                    else if (GridID == "jQGridItems")
                        ShowEditFormMDItems();
                    else if (GridID == "jQGridCategories")
                        ShowEditFormMDCategories();
                },

            });

            $('#' + GridID).jqGrid('navGrid', '#' + jQGridPager,
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "",
                           addtext: "",
                           edittext: "",
                           deltext: "",
                           refreshtext: "",
                           viewtext: "<%=StrSrc("Watch")%>"

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

                               if (response.responseText.indexOf('<%=StrSrc("GoodLuck")%>') > -1)
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

                                   var sel_id = $('#' + GridID).jqGrid('getGridParam', 'selrow');
                                   var value = $('#' + GridID).jqGrid('getCell', sel_id, 'id');

                                   return value;
                               },
                               GraphID: function () {

                                   $("#cData")[0].innerText = "Close";
                                   $("#sData")[0].style.display = "none";

                                   var sel_id = $('#' + GridID).jqGrid('getGridParam', 'selrow');
                                   var value = $('#' + GridID).jqGrid('getCell', sel_id, 'GraphID');

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
                               if (response.responseText.indexOf('<%=StrSrc("GoodLuck")%>') > -1)
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

                                   $("#jQGrid").trigger("reloadGrid", [{ current: true }]);
                                   return [false, response.responseText]
                               }
                               else {
                                   $(this).jQGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               GraphID: function () {

                                   var sel_id = $('#' + GridID).jqGrid('getGridParam', 'selrow');
                                   var value = $('#' + GridID).jqGrid('getCell', sel_id, 'GraphID');
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
        SetGrid('jQGrid', 'jQGridPager', '2');
        SetGrid('jQGridCust', 'jQGridCustPager', '1');
        SetGrid('jQGridItems', 'jQGridItemsPager', '3');
        SetGrid('jQGridCategories', 'jQGridPagerCategories', '4');

    </script>
</body>
</html>
