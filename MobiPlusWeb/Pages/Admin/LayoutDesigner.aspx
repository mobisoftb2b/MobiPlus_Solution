<%@ Page Title="עיצוב מסכים" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="LayoutDesigner.aspx.cs" Inherits="Pages_Admin_LayoutDesigner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui-1.9.2.custom.css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <style type="text/css">
        #droppable {
            padding: 0.5em;
            margin: 10px;
        }

        .Fragment h3 {
            text-align: center;
            margin: 0;
        }

        .ui-widget-content .ui-icon {
            background-image: url(../../css/images/ui-icons_222222_256x240.png);
            width: 100%;
        }

        #tabs ul {
            float: right;
            width: 99%;
        }

            #tabs ul li {
                float: right;
                border: 1px solid black;
            }

        .srtableM {
            background-color: #808080;
            height: 100%;
            overflow-y: scroll;
            overflow-x: hidden;
        }


        .highlight {
            <%-- border: 1px solid red;
            font-weight: bold;
            font-size: 45px;
            background-color: lightblue;
            --%>;
        }

        .dynTrHead {
            background-color: #4F81BD;
            color: White;
            border-bottom: 2px solid white;
            font-weight: 700;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            for (var key in sessionStorage) {
                ClearDictionary(key);
            }
        });
        var isDragging = false;
        var ObjID = "";
        function SetDraggable() {

            $(".FragmentDiv1").draggable({
                start: function () {
                    //                    for (var i = 0; i < $('.FragmentDivEmpty').length; i++) {
                    //                        $('.sortable')[0].removeChild($('.FragmentDivEmpty')[i]);
                    //                    }

                    //                    setTimeout(CheckForAddFragment, 500);
                    //                    isDragging = true;
                    //                    
                    //                    ObjID = this.id;
                },
                drag: function () {

                },
                stop: function () {
                    //                    isDragging = false;
                    //                    ObjID = "";
                }
            });
            $("#divArena").droppable({

            });

        }
        $(function () {
            //SetDraggable();
            $("#divArena").droppable({

            });
        });

        $(function () {
            $("#divArena").sortable({
                placeholder: "highlight",
                start: function (event, ui) {
                    ui.item.toggleClass("highlight");
                },
                stop: function (event, ui) {
                    ui.item.toggleClass("highlight");
                }
            });
            $("#divArena").disableSelection();
            //            $(".sortable").sortable({
            //                start: function (e, ui) {
            //                
            //                }
            //            });            
        });

        function SetDisplayEmpty() {
            for (var i = 0; i < 237; i++) {
                var iDiv = document.createElement('div');
                iDiv.className = "FragmentDivEmpty";
                iDiv.id = "FragmentDivEmptyID_" + i.toString();
                //iDiv.style["float"]="left";
                //iDiv.style["width"]="300px";
                //iDiv.style["height"]="300px";
                $('#divArena').append(iDiv);
            }
        }
        function addDisplayEmpty() {
            for (var i = 0; i < 10; i++) {
                var iDiv = document.createElement('div');
                iDiv.className = "FragmentDivEmpty";
                iDiv.id = "FragmentDivEmptyID_" + i.toString();
                //iDiv.style["float"]="left";
                //iDiv.style["width"]="300px";
                //iDiv.style["height"]="300px";
                $('#divArena').append(iDiv);
            }
        }
        function isIE() {
            if (navigator.userAgent.indexOf('MSIE') !== -1 || navigator.appVersion.indexOf('Trident/') > 0) {
                return true;
            }
            return false;
        }
        function SetResizable() {
            //$("#ContentPlaceHolder1_report0").resizable({});
            $(".FragmentDiv").resizable({
                alsoResize: ".iiimg_" + SelID.toString(),
                start: function (event, ui) { RID++; },
                stop: function (event, ui) {


                },
                resize: function (event, ui) {
                    // debugger;
                    // this is the View

                    //$('.gtr1').css("display","none");
                    //<div class="imgg" id="ContentPlaceHolder1_report10">
                    //var ua = window.navigator.userAgent;
                    //var msie = ua.indexOf("MSIE ");

                    var iDivDet = document.createElement('div');
                    iDivDet.id = "dd7" + SelID.toString();
                    //                    iDivDet.style["position"] = "fixed";
                    //                    iDivDet.style["padding-top"] = "75px";
                    //                    iDivDet.className = "gtr1";
                    var oldW = ui.originalSize.width;

                    var id = ui.element[0].innerHTML.substr(ui.element[0].innerHTML.indexOf("d=\"ContentPlaceHolder1_report") + 29, 3).replace("\"", "").replace(">", "");

                    //$("#ContentPlaceHolder1_report" + id).text("רוחב: " + ui.size.width.toString() + "; גובה: " + ui.size.height.toString());
                    //$("#ContentPlaceHolder1_dynDivStyles_" + id).text("רוחב: " + ui.size.width.toString() + "; גובה: " + ui.size.height.toString());

                    $("#dr_" + id).text("רוחב: " + ui.size.width.toString() + "; גובה: " + ui.size.height.toString());
                    $("#ContentPlaceHolder1_dynDivStyles_" + id).text("רוחב: " + ui.size.width.toString() + "; גובה: " + ui.size.height.toString()); //new work

                    //this.innerHTML=this.innerHTML.substring(0,this.innerHTML.indexOf('<spanr>'));
                    //this.innerHTML += iDivDet.innerHTML;

                    var newW = ui.size.width;
                    var deltaWidth = newW - oldW;
                    var deltaRatio = deltaWidth / oldW;
                }
            });
        }
        var SelID = 0;
        var RID = 0;
        function CheckForAddFragment() {
            SelID++;

            //if (isDragging) {
            var iDiv = document.createElement('div');

            iDiv.id = "id_" + ObjID.replace("ctl00_ContentPlaceHolder1_draggable", ""); //SelID.toString();
            //alert(iDiv.id);
            if (!isGraf) {
                iDiv.className = "FragmentDiv ui-widget-content ui-widget-content_" + SelID.toString();
            }
            else {
                iDiv.className = "FragmentDiv MobiGraf ui-widget-content ui-widget-content_" + SelID.toString() + " Rep_" + IndexForGrafReal.toString();
            }
            var OrgObjID = ObjID;
            if (!$('#' + ObjID)[0])
                ObjID = ObjID.replace("ctl00_", "");

            iDiv.innerHTML = $('#' + ObjID)[0].innerHTML.replace('class="iiimg"', 'class="iiimg iiimg_' + SelID.toString() + '"');
            iDiv.innerHTML = iDiv.innerHTML.replace("clseccc", "");
            iDiv.innerHTML = iDiv.innerHTML.replace("EditFr", "");

            $('#divArena').append(iDiv);
            addDisplayEmpty();

            //$('#' + ObjID).css("display", "none");

            isDragging = false;

            SetResizable();

            //setTimeout(SetDisplayEmpty, 500);

            ////                var iDiv2 = document.createElement('div');
            ////                iDiv2.className = $('#' + ObjID)[0].className;
            ////                iDiv2.id = "idr_" + SelID.toString();
            ////                iDiv2.innerHTML = $('#' + ObjID)[0].innerHTML;
            ////                dObjects.appendChild(iDiv2);
            ObjID = OrgObjID;
            SetDraggable();


            //}
        }
        function CloseWinReport(id) {
            var report = $('#id_' + id.replace("draggable", ""))[0];
            report.parentNode.removeChild(report);
        }

        function ClosedivAddReport() {
            $("#divAddReport").css({ top: 100 })
                .animate({ "top": "-1600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWinTabsEdit() {
            $("#dTabsEdit").css({ top: 100 })
                .animate({ "top": "-600" }, "high");

            ddlFormsChange();

            $("#dBody").unblock();
        }
        function SetAccordionReports() {

            $(".dTBL").accordion({

                header: ".dHeadCat",
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div style="text-align: right;">
        <table cellpadding="2" cellspacing="2" style="">
            <tr>
                <td style="vertical-align: top; text-align: right;">בחר פרויקט:
            <br />
                    <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="dllProjects" Width="200px" AutoPostBack="true"
                                OnSelectedIndexChanged="dllProjects_SelectedIndexChanged" onchange="setFormView();">
                            </asp:DropDownList>
                            <span style="display: none;">
                                <asp:Button runat="server" ID="btnShowForms" OnClick="dllProjects_SelectedIndexChanged2"
                                    Text="שמור" CssClass="EditForm btn" />
                            </span>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <br />
                    בחר טופס:
            <br />
                    <asp:UpdatePanel runat="server" ID="UpdatePanelddlForms" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlForms" ClientIDMode="Static" Width="200px" size="20" onchange="ddlFormsChange();">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <br />
                    <a href="javascript:ShowFormEdit();" id="aEdit">פרטי טופס</a> &nbsp; <a href="javascript:DeleteForm();"
                        id="a1">מחק</a>
                </td>
                <td id="trForm" style="visibility: hidden;"></td>
                <td>
                    <div style="text-align: right; padding-right: 5px; display: none; white-space: nowrap;"
                        id="lAdd">
                        <table>
                            <tr>
                                <td>
                                    <a href="javascript:EditTabs();">עריכת טאבים</a> &nbsp; <a href="javascript:ShowFragments();">הוסף דוח</a>
                                </td>
                                <td style="display: none;">
                                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" onchange="SetWidth();">
                                        <asp:ListItem Selected="True" Text="טאבלט" Value="1"></asp:ListItem>
                                        <asp:ListItem Selected="False" Text="טלפון" Value="2"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divAddReport" style="display: none; text-align: right;" class="EditWinBoxReports">
                        <div>
                        </div>
                        <div style="height: 95%; padding-top: 5px;">
                            <div>
                                <div class="JumpWiX" style="float: right; width: 100px;">
                                    <img alt="סגור" src="../../img/X.png" class="imngX" onclick="ClosedivAddReport();" />
                                </div>
                                <div style="float: right; padding-right: 10px; width: 75%; text-align: center; font-size: 18px; font-weight: 700;">
                                    הוספת דוח
                                </div>
                                <div style="float: left; padding-left: 10px;">
                                    <a href='javascript:SetNewReport();' onclick='SetNewReport();' style='color: White;'>חדש</a>
                                </div>
                            </div>
                            <br />
                            <%-- <div class="dHeadCat">
                        דוחות טבלאים
                    </div>--%>
                            <div id="dTBL" runat="server" style="text-align: center; padding-right: 10px; padding-top: 5px;"
                                class="dTBL">
                            </div>
                        </div>
                    </div>
                    <div id="divForm" class="divForm" style="visibility: hidden;">
                        <div id="tabs" style="text-align: right; direction: rtl; width: 99.5%; height: 99.5%"
                            class="srtableM">
                            <ul runat="server" id="tabsUl" style="text-align: right; direction: rtl;">
                            </ul>
                            <div class="sortable" id="divArena" style="height: 100%;">
                            </div>
                        </div>
                        <div id="divFormBtn" style="visibility: hidden; text-align: left; float: none; width: 925px;">
                            <input type="button" id="Button1" value="שמור" class="EditForm btn" onclick="SaveData();" />
                            <input type="button" id="btnDuplicateFormort" value="שכפל טופס" class="EditForm btn" onclick="ShowDuplicateFormort();" />
                            <asp:Button runat="server" ID="btnlbDelTab" OnClick="lbDelTab_Click" Style="display: none;" />
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <center>
    <div id="dTabsEdit" style="display: none;" class="EditWinBoxEditTabs">
        <div style="background-color: #4F81BD; height: 25px;">
            &nbsp;
            <div class="JumpWiX" style="">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinTabsEdit();" />
            </div>
            <div style="float: left; width: 90%; margin-top: 5px; font-weight: 700;">
                עריכת טאבים
            </div>
        </div>
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item" colspan="2" id="TabsMsg" style="height: 20px;">
                    <asp:UpdatePanel runat="server" ID="upTabMSG" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Label runat="server" ID="lblTabMsg"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">בחר טאב:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel runat="server" ID="upddlTabs" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlTabs" Width="251px" AutoPostBack="true" OnSelectedIndexChanged="ddlTabs_SelectedIndexChanged">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:LinkButton runat="server" ID="lbDelTab" Text="מחק" OnClientClick="DelTab();"
                                            Style="color: White !important;"></asp:LinkButton>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">שם טאב:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel runat="server" ID="upTabName" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:TextBox runat="server" ID="txtTabName" Width="247px"></asp:TextBox>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">תיאור טאב:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel runat="server" ID="upTabDesc" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:TextBox runat="server" ID="txtTabDesc" Width="245px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">סדר הטאב:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel4" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:TextBox runat="server" ID="txtTabOrder" Width="247px" CssClass="gg"></asp:TextBox>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
        <br />
        <asp:UpdatePanel runat="server" ID="UpdatePaneldFilterControls" UpdateMode="Conditional">
            <ContentTemplate>
                <div id="dFilterControls" runat="server" class="dFilterControls" style="text-align: right; padding-right: 20px;">
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div id="div1" style="padding-top: 20px;">
            <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                <ContentTemplate>
                    <input type="button" id="btnSetFormTabClient" value="שמור" class="EditForm btn" onclick="SaveTab();" />
                    <asp:Button runat="server" Style="display: none;" ID="btnSetFormTab" OnClick="btnSetFormTab_Click"
                                CssClass="EditForm btn" />
                    <asp:HiddenField runat="server" ID="hdnJsonFilters" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div style="display: none;">
            <asp:UpdatePanel runat="server" ID="up1" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Button runat="server" ID="btnGetTabEditData" OnClick="btnGetTabEditData_Click" />
                    <asp:Button runat="server" ID="btnddlTabs" OnClick="initConntrols_SelectedIndexChanged"
                                Style="display: none;" />
                    <asp:HiddenField runat="server" ID="hdnTabIDSelected"/>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="dFormsEdit" style="display: none;" class="EditWinBoxEditForm">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinFormEdit();" />
        </div>
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">שם טופס:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtFormName" Width="117px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">סוג טופס:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlLayoutType" Width="120px" ClientIDMode="Static">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">תיאור:
                </td>
                <td class="EditForm val leftt">
                    <asp:TextBox runat="server" ID="txtFormDescription" Width="213px" Rows="3" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">סקרול:
                </td>
                <td class="EditForm val">
                    <asp:CheckBox runat="server" ID="cbIsScroll" />
                </td>
            </tr>
            <tr>
                <td class="EditForm item">הצג תאריך עדכון:
                </td>
                <td class="EditForm val">
                    <asp:CheckBox runat="server" ID="cbIsShowUpdateTime" />
                </td>
            </tr>
            <tr>
                <td class="EditForm item">טאב תמיד למעלה:
                </td>
                <td class="EditForm val">
                    <asp:CheckBox runat="server" ID="cbIsTabAlwaysOnTop" />
                </td>
                <%--  <td>
                                <input type="button" id="Button1" value="שמור" class="EditForm btn"
                                    onclick="SaveData();" />
                            </td>--%>
            </tr>
            <tr>
                <td class="EditForm item">סידור טאבים:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlTabAlignments" Width="120px">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <div id="div2" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" id="btnCloseForms" value="אישור" class="EditForm btn" onclick="SaveCurrentForm();" />
        </div>
    </div>
</center>
    </div>
    <div id="dAddReportWin" style="display: none; text-align: center;" class="EditWinBoxAddReport">
        <div style="float: left; text-align: center; width: 90%; height: 25px; padding-top: 5px; font-weight: 700;">
            עריכת דוח
        </div>
        <div class="EditWinMDX" id="EditWinMDX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="parent.$('#dAddReportWin').css('display','none');" />
        </div>
        <iframe src="ReportsEdit.aspx?isUpdate=False" width="99%" height="91%" id="ifEditReport"
            style="border-top: 1px solid white;"></iframe>
    </div>
    <div style="" class="DuplicateForm">
        <div class="newx">
            <span onclick="closeWinDuplicateForm();">X</span>
        </div>
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td>מסד נתונים:
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="ddlDBs" Width="173px" Enabled="false"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>שם טופס חדש:</td>
                <td>
                    <input type="text" id="txtFormNameNew" class="txtFormNameNew" />
                </td>
            </tr>
        </table>
        <div align="center" style="padding-top: 60px;">
            <input type="button" id="btnDup" value="שכפל טופס" class="EditForm btn" onclick="DuplicateForm();" />
        </div>
    </div>
    <script type="text/javascript">

        var SelectedTab = "1";
        var lastIndex = 0;
        var arrOuterData = [];
        var arrTabIDs = [];
        var arrTabIDsTouch = [];
        var EmptyObj;
        function onTabClick(tabID, index) {
            //arrTabIDsTouch[tabID.replace("Tab_", "")] = true;
            arrTabIDsTouch.push(true);
            //debugger;
            $('#Tab_' + SelectedTab).css("color", "#FFFFFF");
            debugger;
            var oldTab = SelectedTab;
            SelectedTab = tabID.replace("Tab_", "");

            $('#<%= hdnTabIDSelected.ClientID%>').val(SelectedTab);

            $(".FragmentDiv").resizable({ disabled: true });
            $('.FragmentDiv').resizable("destroy");
            //var data = $('.sortable')[0].innerHTML;
            //var dataOuter = $('.sortable')[0].outerHTML;

            var data = $('#divArena').html();
            var dataOuter = $('#divArena').html();


            $('#' + tabID).css("color", "orange");

            debugger;

            lastIndex = index;
            let layout = GetDictionary(SelectedTab);


            if (layout) {
                $(".FragmentDiv").resizable({ disabled: true });
                $('.FragmentDiv').resizable("destroy");
                $('#divArena').html(unescape(layout.TabHTMLLayout).toString().replace(/\+/g, ' '));
                SetResizable();

            }
            else {
                //$('.sortable')[0].innerHTML = ""; //  EmptyObj;
                $('#divArena').html('');
                //SetDisplayEmpty();
            }
            //////              $(".ui-widget-content_"+SelID.toString()).resizable({
            //////                    alsoResize: ".iiimg_"+SelID.toString(),
            //////                });
        }
        var isGraf = false;
        var IndexForGrafReal = 0;
        function ObjClick(id, isGrafR, IndexForGraf) {
            isDragging = true;
            isGraf = isGrafR;
            ObjID = "ctl00_" + id;
            IndexForGrafReal = IndexForGraf;
            setTimeout(CheckForAddFragment, 200);


            ClosedivAddReport();
        }
        function SetNewReport() {
            $('#ifEditReport')[0].src = "ReportsEdit.aspx?isUpdate=False&ID=0";

            $("#dAddReportWin").css("display", "block");
            $("#dAddReportWin").css("right", "28px");
            var top = "";
            $("#dAddReportWin").css({ top: top })
                .animate({ "top": +top + "px" }, "high");

        }
        function SetEditReport(ID) {
            $('#ifEditReport')[0].src = "ReportsEdit.aspx?isUpdate=False&ID=" + ID + "&LayoutTypeID=<%=LayoutTypeID %>";

            $("#dAddReportWin").css("display", "block");
            $("#dAddReportWin").css("right", "28px");
            var top = "60";
            $("#dAddReportWin").css({ top: top })
                .animate({ "top": +top + "px" }, "high");
        }
        function ShowFragments() {
            $("#divAddReport").css("display", "block");
            $("#divAddReport").css("right", "28px");
            var top = "80";
            $("#divAddReport").css({ top: top })
                .animate({ "top": +top + "px" }, "high");

            $('#dBody').block({ message: '' });
        }
        function EditTabs() {

            $("#<%=btnGetTabEditData.ClientID %>").click();
            $("#dTabsEdit").css("display", "block");
            $("#dTabsEdit").css("left", $("#aEdit")[0].parentElement.offsetParent.offsetLeft - 78);
            var top = "80";
            $("#dTabsEdit").css({ top: top })
                .animate({ "top": +top + "px" }, "high");

            $('#dBody').block({ message: '' });

            $("#<%=txtTabName.ClientID %>").val("");
            $("#<%=txtTabDesc.ClientID %>").val("");
            $("#<%=txtTabOrder.ClientID %>").val("");
            $("#<%=btnddlTabs.ClientID %>").click();
        }
        function ShowFormEdit() {
            var LayoutTypeID = $("#ddlLayoutType").val(); //"<%=LayoutTypeID %>";
            //            if (LayoutTypeID == "1")
            //                $("#<%=ddlLayoutType.ClientID %>").val("1");
            //            else if (LayoutTypeID == "2")
            //                $("#<%=ddlLayoutType.ClientID %>").val("2");
            //            else 
            if (LayoutTypeID == "3")
                $("#ddlLayoutType").val("3");
            //debugger;
            $("#dFormsEdit").css("display", "block");
            $("#dFormsEdit").css("left", $("#aEdit")[0].parentElement.offsetParent.offsetLeft - 380);
            var top = "80";
            $("#dFormsEdit").css({ top: top })
                .animate({ "top": +top + "px" }, "high");

            $('#dBody').block({ message: '' });
        }
        function ddlFormsChange() {
            $(".divForm").css("visibility", "visible");
            $("#divFormBtn").css("visibility", "visible");

            $("#dLinkEditTabs").css("display", "block");
            $("#lAdd").css("display", "block");

            if ($("#<%=ddlForms.ClientID %>").val() == "0") {//new
                ShowFormEdit();
            }
            else {//edit
                if ($("#<%=ddlForms.ClientID %>").val() * 1.0 > 0)
                    LoadFormData();
            }

        }
        setTimeout(setInit, 100);
        function setInit() {
            //$(".divForm").css("height", $("body").height() - 200);
        }

        function DisableWin() {
            $('#dBody').block({ message: '<%=StrSrc("EditFormEditMsg") %>' });
        }
        var strJson = "[]";
        function SaveCurrentForm() {
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetForm&FormID=" + $("#<%=ddlForms.ClientID %>").val() + "&LayoutTypeID=" + $("#ddlLayoutType").val() + "&FormName=" + $("#<%=txtFormName.ClientID %>").val() + "&FormDescription=" + $("#<%=txtFormDescription.ClientID %>").val()
                    + "&IsShowUpdateTime=" + $("#<%=cbIsShowUpdateTime.ClientID %>").val() + "&IsScroll=" + $("#<%=cbIsScroll.ClientID %>")[0].checked + "&IsTabAlwaysOnTop=" + $("#<%=cbIsTabAlwaysOnTop.ClientID %>").val() + "&IsActive=1&TabAlignmentID=" + $("#<%= ddlTabAlignments.ClientID %>").val() + "&ProjectID=" + $("#<%= dllProjects.ClientID %>").val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    CloseWinFormEdit();
                    $('#<%= btnShowForms.ClientID%>').click();
                }
                else {
                    alert("Error");
                }
            });
        }
        function DeleteCurrentForm() {
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetForm&FormID=" + $("#<%=ddlForms.ClientID %>").val() + "&LayoutTypeID=" + $("#ddlLayoutType").val() + "&FormName=" + $("#<%=txtFormName.ClientID %>").val() + "&FormDescription=" + $("#<%=txtFormDescription.ClientID %>").val()
                    + "&IsShowUpdateTime=" + $("#<%=cbIsShowUpdateTime.ClientID %>").val() + "&IsScroll=" + $("#<%=cbIsScroll.ClientID %>")[0].checked + "&IsTabAlwaysOnTop=" + $("#<%=cbIsTabAlwaysOnTop.ClientID %>").val() + "&IsActive=0&TabAlignmentID=" + $("#<%= ddlTabAlignments.ClientID %>").val() + "&ProjectID=" + $("#<%= dllProjects.ClientID %>").val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    CloseWinFormEdit();
                    $('#<%= btnShowForms.ClientID%>').click();
                }
                else {
                    alert("Error");
                }
            });
        }
        function elementChildren(element) {
            var childNodes = $(element).children(),
                children = [],
                i = childNodes.length;

            while (i--) {
                if (childNodes[i].nodeType == 1) {
                    children.unshift(childNodes[i]);
                }
            }

            return children;
        }
        var lastarrOuterData = "";



        function SaveData() {
            var LayoutTypeID = $("#ddlLayoutType").val();// "<%=LayoutTypeID %>";
            let urlParam = "../../Handlers/MainHandler.ashx?MethodName=Layout_SetForm&FormID=" +
                $("#<%=ddlForms.ClientID %>").val() +
                "&LayoutTypeID=" +
                LayoutTypeID +
                "&FormName=" +
                $("#<%=txtFormName.ClientID %>").val() +
                "&FormDescription=" +
                $("#<%=txtFormDescription.ClientID %>").val() +
                "&IsShowUpdateTime=" +
                $("#<%=cbIsShowUpdateTime.ClientID %>").val() +
                "&IsScroll=" +
                $("#<%=cbIsScroll.ClientID %>")[0].checked +
                "&IsLastRowFooter=" + $("#cbIsLastRowFooter").attr("checked") +
                "&IsTabAlwaysOnTop=" +
                $("#<%=cbIsTabAlwaysOnTop.ClientID %>").val() +
                "&IsActive=1&TabAlignmentID=" +
                $("#<%= ddlTabAlignments.ClientID %>").val() +
                "&ProjectID=" +
                $("#<%= dllProjects.ClientID %>").val() +
                "&Tiks=<%= DateTime.Now.Ticks.ToString()%>";

            $.ajax({
                type: 'get',
                url: urlParam,
                contentType: "application/text; charset=utf-8",
                dataType: "text",
                error: function (xhr, statusText) {
                    console.log("Error: " + statusText);
                },
                success: function (result) {
                    $(".FragmentDiv").resizable({ disabled: true });
                    $('.FragmentDiv').resizable("destroy");

                    var CurrentData = $('#divArena').html();

                    var ddiv = $("<div></div>");//('div');

                    ddiv.append(CurrentData);
                    arrOuterData = [];
                    arrOuterData.push(ddiv.html());

                    strJson = "[";

                    for (var i = 0; i < arrOuterData.length; i++)//tabs
                    {
                        lastarrOuterData = arrOuterData[i];

                        let $div = $('<div/>', {
                            html: unescape(lastarrOuterData),
                            css: {
                                'top': "0px",
                                'left': '0px',
                                'width': $('#divArena').width() + "px",
                                'height': $('#divArena').height() + "px"
                            }
                        });


                        $('#divArena').html('');
                        $('#divArena').append($div);
                        debugger;
                        let child = elementChildren($div);

                        if (child && lastarrOuterData && i >= 0) {
                            if (strJson.length > 1)
                                strJson += ",";

                            //debugger;
                            var minLeft = 100;
                            for (var j = 0; j < child.length; j++)//widgets
                            {
                                var width = child[j].offsetWidth * 1.0 + 1.0 * 5.0;
                                if (child[j].id.toString().indexOf('id_') > -1) {
                                    if ($('#' + child[j].id).css("display") == "block") {
                                        if (minLeft > child[j].offsetLeft)
                                            minLeft = child[j].offsetLeft;
                                    }
                                }
                            }
                            var minTop = 300;
                            for (var j = 0; j < child.length; j++)//widgets
                            {
                                if (child[j].id.toString().indexOf('id_') > -1) {
                                    if ($('#' + child[j].id).css("display") == "block") {
                                        if (minTop > $('#' + child[j].id).offset().top)
                                            minTop = $('#' + child[j].id).offset().top;
                                    }
                                }
                            }
                            for (var r = 0; r < $('.FragmentDivEmpty').length; r++) {
                                try {
                                    var report = $('.FragmentDivEmpty')[r];
                                    report.parentNode.removeChild(report);
                                }
                                catch (e) {
                                    //alert(e);
                                    break;
                                }
                            }
                            for (var r = 0; r < $('.FragmentDivEmpty').length; r++) {
                                try {
                                    var report = $('.FragmentDivEmpty')[r];
                                    report.parentNode.removeChild(report);
                                }
                                catch (e) {
                                    //alert(e);
                                    break;
                                }
                            }

                            for (var r = 0; r < $('.rrgg').length; r++) {
                                try {
                                    var report = $('.rrgg')[r];
                                    report.parentNode.removeChild(report);
                                }
                                catch (e) {
                                    //alert(e);
                                    break;
                                }
                            }
                            //alert($('#tabs')[0].scrollHeight);

                            var h = $('#tabs')[0].scrollHeight - $('.ui-tabs-nav').height() - 24.64;

                            //alert(minTop);
                            //alert(div.childNodes[0].children.length);
                            for (var j = 0; j < child.length; j++)//widgets
                            {
                                if (child[j].id.toString().indexOf('id_') > -1) {
                                    if ($('#' + child[j].id).css("display") == "block") {

                                        var id = child[j].id.replace("id_", "");
                                        var height = child[j].offsetHeight * 1.0 + 1.0 * 5.0;
                                        var _width = child[j].offsetWidth * 1.0 + 1.0 * 5.0;
                                        var left = child[j].offsetLeft - minLeft;
                                        var ParentLeft = child[j].parentNode.offsetLeft - minLeft;
                                        var ParentWidth = child[j].parentNode.offsetWidth * 1.0 - 1.0 * 5.0;
                                        var parentHeight = child[j].parentNode.offsetHeight;
                                        var heightWeight = formatMoney(height * 1.0 * 100 * 1.0 / h * 1.0, 2);
                                        var topWeight = formatMoney((($('#' + child[j].id).offset().top) - minTop) * 1.0 * 100 * 1.0 / h * 1.0, 2);
                                        var leftWeight = formatMoney(left * 1.0 * 100 * 1.0 / ParentWidth * 1.0, 2);

                                        strJson += "{";
                                        strJson += "\"id\": " + id + ",";
                                        strJson += "\"TabId\": " + SelectedTab + ",";
                                        strJson += "\"Top\": \"" + ($('#' + child[j].id).offset().top * 1.0 + 1.0 * 10.0) + "\",";
                                        strJson += "\"Left\": " + formatMoney(left, 2) + ",";
                                        strJson += "\"Height\": " + formatMoney(height, 2) + ",";
                                        strJson += "\"Width\": " + _width + ","; //add 5px
                                        strJson += "\"ParentLeft\": " + ParentLeft + ",";
                                        strJson += "\"ParentWidth\": " + ParentWidth + ",";
                                        strJson += "\"ParentHeight\": " + parentHeight + ",";
                                        strJson += "\"HeightWeight\": " + heightWeight + ",";
                                        strJson += "\"TopWeight\": " + topWeight + ",";
                                        strJson += "\"LeftWeight\": " + leftWeight + ",";
                                        strJson += "},";
                                    }
                                }
                            }

                            strJson = strJson.substring(0, strJson.length - 1) == '' ? strJson : strJson.substring(0, strJson.length - 1);

                        }
                        $div.css({
                            "display": "none"
                        });
                    }
                    strJson += "]";

                    //alert(strJson);

                    if (strJson.length > 3) {
                        $(".FragmentDiv").resizable({ disabled: true });
                        $('.FragmentDiv').resizable("destroy");
                        let currentData = CurrentData;
                        $('#divArena').html(currentData);
                        SetDictionary(SelectedTab, { TabHTMLLayout: currentData });
                        SetFragmentsToTabsByJson(strJson);
                    }

                }
            });


            $(".FragmentDiv").resizable("destroy");


        }

        function LayoutManager_CreateXML(tabID) {
            if (tabID) {
                $.ajax({
                    type: 'get',
                    url: "../../Handlers/MainHandler.ashx?MethodName=LayoutManager_CreateXML&TabID=" + tabID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    contentType: "application/text; charset=utf-8",
                    dataType: "text",
                    error: function (xhr, statusText) {
                        console.log("Error: " + statusText);
                        if (xhr.message)
                            alert("אראה שגיאה בשמירת הXML");
                    },
                    success: function (result) {
                        console.log("הנתונים נשמרו בהצלחה");
                    }
                });

            }
        }
        function SetHTMLToTab() {
            //alert(escape($('.sortable')[0].innerHTML));  
            $.post("../../Handlers/MainHandler.ashx?MethodName=LayoutXML_SaveHTMLToTab&TabID=" + SelectedTab + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                escape(escape($('#divArena').html())),
                function (data) {
                    SetResizable();
                    SetDictionary(SelectedTab, { TabHTMLLayout: $('#divArena').html() });
                    alert("הנתונים נשמרו בהצלחה");
                }).fail(function (e) {
                    console.log("Error: " + e.message);
                    if (e.message) alert("אראה שגיאה בשמירת הXML");
                    else { SetResizable(); alert("הנתונים נשמרו בהצלחה"); }
                });
        }

        function SetFragmentsToTabsByJson(JsonObj) {

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetFragmentsToTabsByJson&FormID=" + $("#<%=ddlForms.ClientID %>").val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: (JsonObj)
            });
                request.done(function (response, textStatus, jqXHR) {
                    //////                    $(".FragmentDiv").resizable({
                    //////                        alsoResize: ".iiimg_"+SelID.toString(),
                    //////                    });
                    for (var i = 0; i < arrTabIDs.length; i++) {
                        if (arrTabIDs[i])
                            LayoutManager_CreateXML(arrTabIDs[i]);
                    }
                    SetHTMLToTab();
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    //debugger;
                    if (jqXHR.status == 200 && jqXHR.responseText == "ret: True") {

                        //////                    $(".FragmentDiv").resizable({
                        //////                        alsoResize: ".iiimg_"+SelID.toString(),
                        //////                    });

                        for (var i = 0; i < arrTabIDs.length; i++) {
                            if (arrTabIDs[i])
                                LayoutManager_CreateXML(arrTabIDs[i]);
                        }
                        SetHTMLToTab();
                    }
                    else {
                        alert("אראה שגיאה בשמירת הנתונים");
                        //alert("Error");
                    }
                });
            }
            function LoadFormData() {
                var LayoutTypeID = "<%=LayoutTypeID %>";
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetFormData&FormID=" + $("#<%=ddlForms.ClientID %>").val() + "&LayoutTypeID=" + LayoutTypeID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $("#<%=ddlLayoutType.ClientID %>").val(response[0].LayoutTypeID);
                $("#<%=txtFormName.ClientID %>").val(response[0].FormName);
                $(".txtFormNameNew").val(response[0].FormName);
                $("#<%=txtFormDescription.ClientID %>").val(response[0].FormDescription);

                if (response[0].IsShowUpdateTime == "1")
                    $("#<%=cbIsShowUpdateTime.ClientID %>")[0].checked = true;
                else
                    $("#<%=cbIsShowUpdateTime.ClientID %>")[0].checked = false;

                if (response[0].IsTabAlwaysOnTop == "1")
                    $("#<%=cbIsTabAlwaysOnTop.ClientID %>")[0].checked = true;
                else
                    $("#<%=cbIsTabAlwaysOnTop.ClientID %>")[0].checked = false;

                if (response[0].IsScroll == "1")
                    $("#<%=cbIsScroll.ClientID %>")[0].checked = true;
                else
                    $("#<%=cbIsScroll.ClientID %>")[0].checked = false;

                $("#<%= ddlTabAlignments.ClientID %>").val(response[0].TabAlignmentID);


                LoadTabsData();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {

                }
                else {
                    //alert("Error");
                }
            });
        }

        function LoadTabsData() {
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetFormTabs&FormID=" + $("#<%=ddlForms.ClientID %>").val() + "&LayoutTypeID=<%=LayoutTypeID %> &Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=tabsUl.ClientID %>')[0].innerHTML = "";

                if (response.length > 0) {
                    selectedTab = response[0].TabID;
                }

                arrOuterData = [];//new Array(response.length);
                arrTabIDs = [];//new Array(response.length);
                arrTabIDsTouch = [];//new Array(response.length);

                if (response.length > 0) {
                    SelectedTab = response[0].TabID;
                }
                //debugger;

                for (var i = 0; i < response.length; i++) {

                    arrTabIDs.push(response[i].TabID);
                    if (response[i].TabHTMLLayout != "") {
                        let layout = unescape(response[i].TabHTMLLayout).toString().replace(/\+/g, ' ');

                        SetDictionary(response[i].TabID, { TabHTMLLayout: layout });
                        var ddiv = document.createElement('div');
                        ddiv.innerHTML = layout;

                        arrOuterData.push(ddiv.outerHTML);
                        //arrTabIDs[i] = layout;

                        if (i == 0) {
                            if (layout) {
                                $('#divArena').html(unescape(layout)); ///?????
                            }

                            SetResizable();
                        }
                    }
                    else {
                        $('#divArena').html('');//[0].innerHTML = ""; //  EmptyObj;
                    }

                    var iLi = document.createElement('li');
                    var iTab = document.createElement('a');
                    iTab.id = "Tab_" + response[i].TabID;
                    iTab.innerText = response[i].TabName;
                    iTab.style["color"] = "white";
                    iTab.style["background-color"] = "gray";
                    iTab.href = "javascript:onTabClick('" + iTab.id + "'," + i + ");";

                    iLi.innerHTML = iTab.outerHTML;
                    $('#<%=tabsUl.ClientID %>')[0].appendChild(iLi);

                    $('.divForm').width("360px");
                    if (response[0].LayoutTypeID == "1" || response[0].LayoutTypeID == "3")//tablet or web
                    {
                        $('.divForm').width("920px");
                    }
                }
                $('#Tab_' + SelectedTab).css("color", "orange");
                //arrTabIDsTouch[response[0].TabID] = true;
                arrTabIDsTouch.push(true);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                //if (jqXHR.status == 200) {

                //}
                //else {
                //    //alert("Error");
                //}
            });
        }

        var selectedTab = "";
        function DoNow() {
            $(function () {

                $("#tabs").tabs();
                //$('#tabs').tabs().tabs('rotate', 2000, 'true');
                $("#tabs").css("direction", "rtl");
                $("#tabs").css("text-align", "right");
                $('#tabs').click('tabsselect', function (event, ui) {

                    selectedTab = $("#tabs").tabs('option', 'active');
                    //debugger;
                    //TabClick(selectedTab);                     
                });
            });
        }
        function setFormView() {
            if ($("#<%= dllProjects.ClientID %>").val() != "-1")
                $("#trForm").css("visibility", "visible");
            else
                $("#trForm").css("visibility", "hidden");
        }
        function SetFormSelected() {
            if ($('#<%=ddlForms.ClientID %>')[0]) {
                var latest_value = $("option:last", $('#<%=ddlForms.ClientID %>')).val();
                $('#<%=ddlForms.ClientID %>').val(latest_value);
                ddlFormsChange();
            }
        }
        function DelTab() {
            if (confirm("האם אתה בטוח ברצונך למחוק את הטאב הבחור?"))
                $('#<%=btnlbDelTab.ClientID %>').click();
        }
        function DeleteForm() {
            if (confirm("האם אתה בטוח ברצונך למחוק את הטופס הבחור?"))
                DeleteCurrentForm();
        }

        function SetHeaderReportsAccordion() {
            $(".ui-accordion-header").css("background", "#4F81BD");
            $(".ui-accordion-header").css("color", "white");
            $(".ui-accordion-header.ui-state-active ").css("background", "#4F81BD");
        }

        function SaveTab() {
            var json = "[";

            for (var i = 0; i < $('.cbFilter').length; i++) {
                var id = $('.cbFilter')[i].id.replace("cbFilter_", "");
                if ($('.cbFilter')[i].checked) {
                    if ($('#txtFilterOrder_' + id).val() == "")//order empty
                    {
                        alert("אנא הזן סדר לפילטר");
                        return;
                    }
                    var DefaltVal = $('#txtFilterDefaltVal_' + id).val();
                    json += "{\"ReportID\":" + id + ",\"Order\":" + $('#txtFilterOrder_' + id).val() + ",\"DefaltVal\":\"" + DefaltVal + "\"}";

                    if (i <= $('.cbFilter').length - 2)
                        json += ",";
                }
            }
            json += "]";
            $('#<%=hdnJsonFilters.ClientID %>').val(json);

            $('#<%=btnSetFormTab.ClientID %>').click();
        }
        function SetWidth() {
            var val = $("input:radio[name='ctl00$ContentPlaceHolder1$RadioButtonList1']:checked").val();
            if (val == "1") {
                $('.divForm').width("920px");
            }
            else {
                $('.divForm').width("360px");
            }
        }
        //$("#<%=ddlForms.ClientID %> option[value='-1']").remove();
        //$('#<%=ddlForms.ClientID %>').val("-1");
        DoNow();
        SetDisplayEmpty();
        EmptyObj = $('#divArena').html();

        SetAccordionReports();
        SetHeaderReportsAccordion();
        if ('<%=LayoutTypeID %>' == '1')
            $('#nDes').attr("class", "menuLink Selected");
        else
            $('#nWeb').attr("class", "menuLink Selected");

        SetFieldOnlyNumbers('txtFilterOrder', true);

        function SetTxtOrderTab() {

            SetFieldOnlyNumbers('gg', true);
        }
        function DuplicateForm() {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=DuplicateForm&FormID=" + $('#<%=ddlForms.ClientID %>').val() + "&DuplicateToFormName=" + $('.txtFormNameNew').val() + "&DB=" + $('#<%=ddlDBs.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                window.location.href = window.location.href;
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {

                    window.location.href = window.location.href;
                }
                else {
                    alert("Error");
                }
            });
        }
        function ShowDuplicateFormort() {
            DisableWin();
            $(".DuplicateForm").show('fast');
        }
        function closeWinDuplicateForm() {
            $(".DuplicateForm").hide('fast');
            $("#dBody").unblock();
        }
        function CloseWinFormEdit() {
            $("#dFormsEdit").css({ top: 100 })
                .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();

        }

    </script>
</asp:Content>
