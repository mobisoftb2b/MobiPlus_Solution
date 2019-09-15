<%@ Page Title="עריכת מקטעים" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="EditFragments.aspx.cs" Inherits="Pages_Admin_EditFragments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <link rel="stylesheet" href="~/css/jquery-ui.css">
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script type="text/javascript">
        function CloseEditBoxPopup() {
            $("#dBodyr").unblock();
            $(".SectionsSelectorObj").css({ top: top })
                             .animate({ "top": "-1700px" }, "high");
        }

    </script>
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
            float: left;
            width: 99%;
        }

            #tabs ul li {
                float: left;
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
        var isDragging = false;
        var ObjID = "";
        function SetDraggable() {

            $(".SectionDiv").draggable({
                start: function () {

                },
                drag: function () {
                    $('#' + this.id).find('.close3').css("padding-left", ($('.dObjAb').width() * 1.0 - $("#" + this.id).width() * 1.0 - 7.0) + "px");
                    //$('#' + this.id).find('.close3').css("position", "fixed").css("top", ($('.dObjAb')[0].offsetTop * 1.0 +129.0 + $("#" + this.id)[0].offsetTop * 1.0 + 2.0) + "px");
                    //$('#' + $('.FrgObj')[0].children[i].id).find('.close3').css("left", $('.mainObjk')[0].scrollLeft * -1.0 + 162.0 + $('#' + $('.FrgObj')[0].children[i].id)[0].offsetLeft * 1.0);
                },
                stop: function () {

                }
            });
            $(".sortableSections").droppable({

            });

        }


        function SetDisplayEmpty() {
            for (var i = 0; i < 237; i++) {
                var iDiv = document.createElement('div');
                iDiv.className = "SectionDivEmpty";
                iDiv.id = "SectionDivEmptyID_" + i.toString();

                $('.sortableSections')[0].appendChild(iDiv);
            }
        }
        function addDisplayEmpty() {
            for (var i = 0; i < 10; i++) {
                var iDiv = document.createElement('div');
                iDiv.className = "SectionDivEmpty";
                iDiv.id = "SectionDivEmptyID_" + i.toString();

                $('.sortableSections')[0].appendChild(iDiv);
            }
        }
        function isIE() {
            if (navigator.userAgent.indexOf('MSIE') !== -1 || navigator.appVersion.indexOf('Trident/') > 0) {
                return true;
            }
            return false;
        }
        function SetResizable() {
            //$(".SectionDiv").resizable({});
            $(".SectionDiv").resizable({
                alsoResize: ".iiimg_" + SelID.toString(),
                start: function (event, ui) { RID++; },
                stop: function (event, ui) {


                },
                resize: function (event, ui) {
                    $('#' + $(ui.element[0])[0].id).find('.ui-resizable-se').css("right", "-" + ($('#' + $(ui.element[0])[0].id).width() * 1.0 - 31.0) + "px");
                    $('#' + this.id).find('.close3').css("padding-left", ($('.dObjAb').width() * 1.0 - $("#" + this.id).width() * 1.0 - 7.0) + "px");
                    //$('#' + this.id).find('.close3').css("position", "fixed").css("top", ($('.dObjAb')[0].offsetTop * 1.0 + $("#" + this.id)[0].offsetTop * 1.0 + 2.0) + "px");
                }
            });
        }
        var SelID = 0;
        var RID = 0;
        function CheckForAddFragment() {
            SelID++;
            //debugger;
            if (isDragging) {
                var iDiv = document.createElement('div');
                iDiv.id = "id_" + ObjID; //SelID.toString();
                if (!isGraf) {
                    iDiv.className = "SectionDiv ui-widget-content ui-widget-content_" + SelID.toString();
                }
                else {
                    iDiv.className = "SectionDiv MobiGraf ui-widget-content ui-widget-content_" + SelID.toString() + " Rep_" + IndexForGrafReal.toString();
                }
                GetSection(ObjID, iDiv);

                SetDraggable();
                SetResizable();

            }
        }




    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>
    <div id="dBody" style="padding-top: 10px;">
        <fieldset class="fieldset2" style="width: 45%; float: right;">
            <legend>בניית חלקים</legend>
            <div style="padding-top: 10px; text-align: right; direction: rtl; vertical-align: top; float: right; width: 310px;">
                <table cellpadding="0" cellspacing="0" width="90%" style="vertical-align: top;">
                    <tr style="vertical-align: top;">
                        <td>חלק
                        <br />
                            <asp:UpdatePanel runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList runat="server" ID="ddlSections" Height="630px" Width="304px" onchange="GetSectionData();"
                                        size="37">
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <br />
                            <a href="javascript:DelSection();">מחק</a>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="padding-top: 20px; text-align: right; direction: rtl; vertical-align: top; float: right; width: 310px;">
                <table cellpadding="2" cellspacing="2" style="vertical-align: top;">
                    <tr style="vertical-align: top;">
                        <td class="SecHead">סוג: 
                        </td>
                        <td class="ReportWin val">
                            <asp:DropDownList runat="server" ID="ddlSectionTypes" Width="154px" Height="22px" onchange="SetWidjet();">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">שם: 
                        </td>
                        <td>
                            <input type="text" id="txtName" class="txtSec" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">תאור: 
                        </td>
                        <td>
                            <input type="text" id="txtDesc" class="txtSec" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">ערך: 
                        </td>
                        <td>
                            <input type="text" id="txtValue" class="txtSec" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">ישור: 
                        </td>
                        <td class="ReportWin val">
                            <asp:DropDownList runat="server" ID="ddlAlign" Width="154px" Height="22px" onchange="SetWidjet();">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">פורמט: 
                        </td>
                        <td class="ReportWin val">
                            <asp:DropDownList runat="server" ID="ddlFormats" Width="154px" Height="22px" onchange="SetWidjet();">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">סגנון: 
                        </td>
                        <td class="ReportWin val">
                            <asp:DropDownList runat="server" ID="ddlStyles" Width="154px" Height="22px" onchange="SetWidjet();">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">אורך מקס': 
                        </td>
                        <td>
                            <input type="text" id="txtMaxLength" class="txtSec" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead" colspan="2" style="text-align: left;">
                            <input type="button" id="btnSaveSection" value="שמור" class="EditForm btn" onclick="SetSectionData('0');" />
                        </td>
                    </tr>
                </table>
            </div>
        </fieldset>
        <div style="float: right; width: 7%;">&nbsp;</div>
        <fieldset class="fieldset2" style="width: 45%; float: right;overflow:auto;">
            <legend>בניית מקטעים</legend>
            <div style="padding-top: 10px; text-align: right; direction: rtl; vertical-align: top; float: right;">
                <table cellpadding="0" cellspacing="0" width="90%" style="vertical-align: top;">
                    <tr style="vertical-align: top;">
                        <td>מקטע
                        <br />
                            <asp:UpdatePanel runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList runat="server" ID="ddlFragments" Height="630px" Width="200px" onchange="GetFragmentData();"
                                        size="37">
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <br />
                            <a href="javascript:DelFragment();">מחק</a>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="padding-top: 20px; text-align: right; direction: rtl; vertical-align: top; float: right; width: 277px;">
                <table cellpadding="2" cellspacing="2" style="vertical-align: top;">

                    <tr style="vertical-align: top;">
                        <td class="SecHead">שם: 
                        </td>
                        <td>
                            <input type="text" id="txtFrgName" class="txtSec" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">תאור: 
                        </td>
                        <td>
                            <input type="text" id="txtFrgDesc" class="txtSec" />
                        </td>
                    </tr>
                    <%--<tr style="vertical-align: top;">
                        <td class="SecHead">פרופילים: 
                        </td>
                        <td class="ReportWin val">
                            <div style="padding-right:55px;padding-top:5px;border:1px solid #A9A9A9;width:97px;height:16px;overflow-y:scroll;overflow-x:hidden;background-color:white;color:black;" onclick="if($('.dcbListPr')[0].style.display=='none'){$('.dcbListPr').show();} else{$('.dcbListPr').hide();} ">בחר
                            </div>
                            <div class="dcbListPr" style="display:none;position:fixed;color:black;background-color:white;border:1px solid #A9A9A9;width:153px;">
                                <div class='close4' onclick="$('.dcbListPr').hide();">x</div>
                                <asp:CheckBoxList runat="server" ID="ddlProfiles"></asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>--%>

                    <tr style="vertical-align: top;">
                        <td class="SecHead">רוחב: 
                        </td>
                        <td>
                            <input type="text" id="txtFrgWidth" class="txtSec" onblur="GetFragmentDataByVal();" onkeyup="GetFragmentDataByVal();" />px
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">גובה: 
                        </td>
                        <td>
                            <input type="text" id="txtFrgHeight" class="txtSec" onblur="GetFragmentDataByVal();" onkeyup="GetFragmentDataByVal();" />px
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">צבע רקע: 
                        </td>
                        <td>
                            <input type="text" id="txtFragmentBackColor" class="txtSec" onblur="GetFragmentDataByVal();" onkeyup="GetFragmentDataByVal();" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">צל: 
                        </td>
                        <td>
                            <input type="checkbox" id="cbIsShadow" onchange="GetFragmentDataByVal();" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead">מעוגל: 
                        </td>
                        <td>
                            <input type="checkbox" id="cbIsRounded" onchange="GetFragmentDataByVal();" />
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td class="SecHead" colspan="2" style="text-align: left; padding-left: 15px;"></td>
                    </tr>
                </table>
            </div>
            <div style="padding-top: 20px; text-align: right; direction: rtl; vertical-align: top; float: right;">
                <div style="height: 25px;">
                    <a href="javascript:SelectSection();">הוסף חלק</a>
                </div>
                <div style="max-width:350px;overflow:auto;position: static;" class="mainObjk">
                <div style="overflow: hidden;  text-align: left; direction: ltr;padding:5px;" class="dObjAb">
                    <div id="FrgObj" class="FrgObj sortableSections " style="text-align: right; direction: rtl;">&nbsp;</div>
                </div>
                    </div>
                <div>
                <input style="position:fixed;left:20px;top:70%;" type="button" id="btnSaveFrg" value="שמור" class="EditForm btn" onclick="SetFragmentData('0');" />
            </div>
            </div>
            
        </fieldset>
    </div>

    <div style="display: none;">
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <asp:Button runat="server" ID="btnRefreshSections" OnClick="btnRefreshSections_Click" />
                <asp:Button runat="server" ID="btnRefreshddlFragments" OnClick="btnRefreshddlFragments_Click" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="SectionsSelectorObj" style="display: none;">
        <div class="" style="vertical-align: top;">
            <div class="modal-header2">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                <h3 id="myModalLabel">בחר חלק</h3>
                <h5 style="color: red;" id="errMsg"></h5>
            </div>

        </div>
        <asp:UpdatePanel runat="server">

            <ContentTemplate>
                <asp:DropDownList runat="server" ID="ddlSectionsForAdd" Height="630px" Width="304px" onchange="AddSection();"
                    size="37">
                </asp:DropDownList>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        function SetSectionData(IsToDelete) {
            var LayoutTypeID = "<%=LayoutTypeID %>";
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_SetSectionData&SectionID=" + $('#<%=ddlSections.ClientID%>').val() + "&SectionName=" + $('#txtName').val() + "&SectionDescription=" + $('#txtDesc').val() + "&SectionValue=" + $('#txtValue').val()
                    + "&LayoutTypeID=" + LayoutTypeID + "&SectionTypeID=" + $('#<%=ddlSectionTypes.ClientID%>').val() + "&SectionAlignID=" + $('#<%=ddlAlign.ClientID%>').val() + "&SectionMaxLength=" + $('#txtMaxLength').val() + "&StyleID=" + $('#<%=ddlStyles.ClientID%>').val()
                    + "&FormatID=" + $('#<%=ddlFormats.ClientID%>').val() + "&IsToDelete=" + IsToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True") {
                        $('#<%=btnRefreshSections.ClientID%>')[0].click();
                        
                        alert("החלק עודכן בהצלחה");
                    }
                    else
                        alert("אראה שגיאה, " + jqXHR.responseText);
                }
                else {
                    alert("Error");
                }
            });
        }
        function GetSectionData() {
            var LayoutTypeID = "<%=LayoutTypeID %>";

            $('#txtName').val("");
            $('#txtDesc').val("");
            $('#txtValue').val("");
            $('#<%=ddlSectionTypes.ClientID %>').val("1");
            $('#<%=ddlAlign.ClientID %>').val("1");
            $('#txtMaxLength').val("");
            $('#<%=ddlStyles.ClientID %>').val("1");
            $('#<%=ddlFormats.ClientID %>').val("1");

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_GetSectionData&SectionID=" + $('#<%=ddlSections.ClientID%>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#txtName').val(response[0].SectionName);
                $('#txtDesc').val(response[0].SectionDescription);
                $('#txtValue').val(response[0].SectionValue);
                $('#<%=ddlSectionTypes.ClientID %>').val(response[0].SectionTypeID);
                $('#<%=ddlAlign.ClientID %>').val(response[0].SectionAlignID);
                $('#txtMaxLength').val(response[0].SectionMaxLength);
                $('#<%=ddlStyles.ClientID %>').val(response[0].StyleID);
                $('#<%=ddlFormats.ClientID %>').val(response[0].FormatID);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {


                }
                else {
                    alert("Error");
                }
            });
        }
        function DelSection() {
            if (confirm("האם הנך בטוח ברצונך למחוק את החלק הבחור?"))
                SetSectionData('1');
        }
        function LoadAgain() {
            $('#<%=ddlFragments.ClientID%>').val(frID);
            GetFragmentData();
        }
        var frID = $('#<%=ddlFragments.ClientID%>').val();
        function SetFragmentData(IsToDelete) {
            var json = GetFragmentJSON();

            //if ($('#txtFrgWidth').val() * 1.0 > 350.0) {
            //alert("רוחב המקטע אינו יכול לעלות על 350 פיקסלים (רוחב טלפון)");
            //return;
            //}
            var IsShadow = "0";
            if ($('#cbIsShadow')[0].checked)
                IsShadow = "1";

            var IsRounded = "0";
            if ($('#cbIsRounded')[0].checked)
                IsRounded = "1";

            <%--var FragmentProfiles = "";
           // debugger;
            for (var i = 0; i < $('#<%=ddlProfiles.ClientID %>')[0].children[0].children.length; i++) {
                if($('#<%=ddlProfiles.ClientID %>')[0].children[0].children[i].children[0].children[0].checked)
                    FragmentProfiles += $('#<%=ddlProfiles.ClientID %>')[0].children[0].children[i].children[0].children[1].innerText.split(' - ')[0]+",";
            }
            if (FragmentProfiles.length > 0)
                FragmentProfiles = FragmentProfiles.substr(0, FragmentProfiles.length - 1);--%>
            var FragmentProfiles = "[]";
            //ui-resizable-handle ui-resizable-e
            $('.FrgObj').find('.ui-resizable-handle').remove();
            frID = $('#<%=ddlFragments.ClientID%>').val();
            var LayoutTypeID = "<%=LayoutTypeID %>";
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_SetFragmentData&FragmentID=" + frID + "&FragmentName=" + escape($('#txtFrgName').val()) + "&FragmentDescription=" + escape($('#txtFrgDesc').val())
                    + "&LayoutTypeID=" + LayoutTypeID + "&FragmentBackColor=" + escape($('#txtFragmentBackColor').val()) + "&OrderReportID=0&FragmentProfiles=" + FragmentProfiles + "&IsShadow=" + IsShadow + "&IsRounded="
                    + IsRounded + "&FragmentWidth=" + $('#txtFrgWidth').val() + "&FragmentHeight=" + $('#txtFrgHeight').val() + "&IsToDelete=" + IsToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: escape($('.FrgObj').html()) + "~" + escape(json)
            });//FragmentBackColor,string IsShadow,string IsRounded
            request.done(function (response, textStatus, jqXHR) {

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True") {
                        $('#<%=btnRefreshddlFragments.ClientID%>')[0].click();
                        alert("המקטע עודכן בהצלחה");

                    }
                    else
                        alert("אראה שגיאה, " + jqXHR.responseText);

                    $('#<%=ddlFragments.ClientID%>').val();
                }
                else {
                    alert("Error");
                }
            });
        }
        function DelFragment() {
            if (confirm("האם הנך בטוח ברצונך למחוק את המקטע הבחור?"))
                SetFragmentData('1');
        }
        function GetFragmentData() {
            var LayoutTypeID = "<%=LayoutTypeID %>";

            $('.sortableSections').html("");

            $('#txtFrgName').val("");
            $('#txtFrgDesc').val("");
            $('#txtFrgWidth').val("");
            $('#txtFrgHeight').val("");
            $('.FrgObj').width("200px");
            $('.FrgObj').height("200px");
            //$('.FrgObj').css("max-width", "200px");
            //$('.FrgObj').css("max-height", "200px");

            $('#txtFragmentBackColor').val("");
            $('#cbIsShadow')[0].checked = false;
            $('#cbIsRounded')[0].checked = false;
            $('.FrgObj').css("background-color", "white");
            $('.FrgObj').css("-webkit-box-shadow", "none");
            $('.FrgObj').css("-moz-box-shadow", "none");
            $('.FrgObj').css("box-shadow", "none");
            $('.FrgObj').css("-moz-border-radius", "0");
            $('.FrgObj').css("-webkit-border-radius", "0");
            $('.FrgObj').css("border-radius", "0");
            <%--for (var i = 0; i < $('#<%=ddlProfiles.ClientID %>')[0].children[0].children.length; i++) {
                    $('#<%=ddlProfiles.ClientID %>')[0].children[0].children[i].children[0].children[0].checked = false;                        
            }--%>

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_GetFragmentData&FragmentID=" + $('#<%=ddlFragments.ClientID%>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#txtFrgName').val(response[0].FragmentName.replace(/\+/g, ' '));
                $('#txtFrgDesc').val(response[0].FragmentDescription.replace(/\+/g, ' '));
                $('#txtFrgWidth').val(response[0].FragmentWidth);
                $('#txtFrgHeight').val(response[0].FragmentHeight);

                var src = unescape(response[0].FragmentHTMLLayout).toString().replace(/\+/g, ' ').split("''").join("'");

                $('.FrgObj')[0].innerHTML = src;

                isDragging = false;

                GetFragmentDataByVal();

                //var arrPr = response[0].Profiles.split(',');

                <%--for (var h = 0; h < arrPr.length; h++) {
                    for (var i = 0; i < $('#<%=ddlProfiles.ClientID %>')[0].children[0].children.length; i++) {
                        if ($('#<%=ddlProfiles.ClientID %>')[0].children[0].children[i].children[0].children[1].innerText.split(' - ')[0] == arrPr[h] ) {
                            $('#<%=ddlProfiles.ClientID %>')[0].children[0].children[i].children[0].children[0].checked = true;
                        }
                      }
                }--%>

                $('.FrgObj').width(response[0].FragmentWidth + "px");
                $('.FrgObj').height(response[0].FragmentHeight + "px");

                $('#txtFragmentBackColor').val(response[0].FragmentBackColor);
                $('.FrgObj').css("background-color", response[0].FragmentBackColor);
                if (response[0].IsShadow == "1") {
                    $('#cbIsShadow')[0].checked = true;
                    $('.FrgObj').css("-webkit-box-shadow", "1px 1px 9px 0px rgba(0,0,0,0.65)");
                    $('.FrgObj').css("-moz-box-shadow", "1px 1px 9px 0px rgba(0,0,0,0.65)");
                    $('.FrgObj').css("box-shadow", "1px 1px 9px 0px rgba(0,0,0,0.65)");
                }
                if (response[0].IsRounded == "1") {
                    $('#cbIsRounded')[0].checked = true;
                    $('.FrgObj').css("-moz-border-radius", "6px");
                    $('.FrgObj').css("-webkit-border-radius", "6px");
                    $('.FrgObj').css("border-radius", "6px");
                }

                SetDraggable();
                SetResizable();
                //debugger;
                for (var i = 0; i < $('.obj').length ; i++) {
                    if ($('.obj')[i].parentNode.style.width.replace("px", "") != "")
                        $('#' + $('#' + $('.obj')[i].id)[0].parentNode.id).find('.ui-resizable-se').css("right", "-" + ($('.obj')[i].parentNode.style.width.replace("px", "") * 1.0 - 31.0) + "px");
                    else
                        $('#' + $('#' + $('.obj')[i].id)[0].parentNode.id).find('.ui-resizable-se').css("right", "-" + ($('.obj')[i].style.width.replace("px", "") * 1.0 - 31.0) + "px");
                }
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {


                }
                else {
                    alert("Error");
                }
            });
        }
        function GetFragmentDataByVal() {
            $('.dObjAb').width($('#txtFrgWidth').val() + "px");
            $('.dObjAb').height($('#txtFrgHeight').val() + "px");
            $('.FrgObj').width($('#txtFrgWidth').val() + "px");
            $('.FrgObj').height($('#txtFrgHeight').val() + "px");
            $('.FrgObj').css("background-color", $('#txtFragmentBackColor').val());

            $('.FrgObj').css("-webkit-box-shadow", "none");
            $('.FrgObj').css("-moz-box-shadow", "none");
            $('.FrgObj').css("box-shadow", "none");
            $('.FrgObj').css("-moz-border-radius", "0px");
            $('.FrgObj').css("-webkit-border-radius", "0px");
            $('.FrgObj').css("border-radius", "0px");

            if ($('#cbIsShadow')[0].checked) {
                $('.FrgObj').css("-webkit-box-shadow", "1px 1px 9px 0px rgba(0,0,0,0.65)");
                $('.FrgObj').css("-moz-box-shadow", "1px 1px 9px 0px rgba(0,0,0,0.65)");
                $('.FrgObj').css("box-shadow", "1px 1px 9px 0px rgba(0,0,0,0.65)");
            }


            if ($('#cbIsRounded')[0].checked) {
                $('.FrgObj').css("-moz-border-radius", "6px");
                $('.FrgObj').css("-webkit-border-radius", "6px");
                $('.FrgObj').css("border-radius", "6px");
            }
        }
        function SelectSection() {
            $(".SectionsSelectorObj").show();
            $(".SectionsSelectorObj").css({ top: top })
                             .animate({ "top": "30px" }, "high");
        }
        function AddSection() {
            CloseEditBoxPopup();
            ObjClick($('#<%=ddlSectionsForAdd.ClientID%>').val(), false, 0);
        }
        var isGraf = false;
        var IndexForGrafReal = 0;
        function ObjClick(id, isGrafR, IndexForGraf) {
            isDragging = true;
            isGraf = isGrafR;
            ObjID = id;//"ctl00_"
            IndexForGrafReal = IndexForGraf;
            setTimeout(CheckForAddFragment, 200);


            ClosedivAddReport();
        }
        function GetSection(id, iDiv) {
            var LayoutTypeID = "<%=LayoutTypeID %>";


            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_GetSectionData&SectionID=" + id + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

                var text = "";
                if (response[0].SectionTypeID == "1")//Constant
                {
                    text = response[0].SectionValue;
                }
                else if (response[0].SectionTypeID == "2")//FromQuery
                {
                    text = response[0].SectionName;
                }
                else if (response[0].SectionTypeID == "3")//Image
                {
                    text = response[0].SectionName;
                }
                else if (response[0].SectionTypeID == "4")//ResourceImage
                {
                    text = response[0].SectionName;
                }
                else if (response[0].SectionTypeID == "5")//OrderControls
                {
                    text = response[0].SectionName;
                }

                var Date1 = new Date();  // for example
                id = id + "_" + Date1.getTime();
                iDiv.innerHTML = "<div id='" + id + "' class='" + id + " obj' style='position:relative;height:25px;z-index:9999;width:" + ($('.sortableSections').width() * 1.0 - 10.0) + "px;'><div class='close3' onclick=\"CloseSection(&quot;" + id + "&quot;);\">x</div>" + text + "</div>";

                $('#<%=ddlSectionsForAdd.ClientID%>').val("");

                $('.sortableSections')[0].appendChild(iDiv);
                //addDisplayEmpty();

                isDragging = false;

                SetDraggable();
                SetResizable();

                $('#' + iDiv.id).find('.ui-resizable-se').css("right", "-" + ($('#' + iDiv.id).width() * 1.0 - 31.0) + "px");
                //$('#' + iDiv.id).find('.close3').css("padding-left", $('#' + iDiv.id)[0].offsetLeft + "px !important");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {


                }
                else {
                    alert("Error");
                }
            });

            //return "<div style='background-color:yellow;'>aa</div>";
        }
        function CloseSection(cls) {
            var report = $('.' + cls)[0];
            $(report.parentNode).remove();
        }
        function GetFragmentJSON() {
            var Json = "[";
            //Json += "\"HTML\": \"" + $('.FrgObj')[0].innerHTML + "\"";
           // debugger;
            for (var i = 0; i < $('.FrgObj')[0].children.length; i++) {

                Json += "{";
                Json += "\"id\": " + $('.FrgObj')[0].children[i].id + ",";
                Json += "\"Width\": " + $('.FrgObj')[0].children[i].clientWidth + ",";
                Json += "\"Height\": " + $('.FrgObj')[0].children[i].clientHeight + ",";
                Json += "\"Left\": " + $('.FrgObj')[0].children[i].offsetLeft + ",";
                Json += "\"Right\": " + ($('.FrgObj').width() * 1.0 - ($('.FrgObj')[0].children[i].clientWidth * 1.0 + $('.FrgObj')[0].children[i].offsetLeft * 1.0)) + ",";
                Json += "\"Top\": " + $('.FrgObj')[0].children[i].offsetTop + ",";
                Json += "},";
            }

            Json += "]";
            //alert(Json);
            return Json;
        }
  
        $(".mainObjk").bind('scroll', function () {
            OnScroll();
        });
        function OnScroll()
        {
            //debugger;
            for (var i = 0; i < $('.FrgObj')[0].children.length; i++) {

                //$('#' + $('.FrgObj')[0].children[i].id).find('.ui-resizable-se').css("right", "-" + ($('#' + $('.FrgObj')[0].children[i].id).width() * 1.0 - 31.0) + "px");
                //$('#' + $('.FrgObj')[0].children[i].id).find('.close3').css("left", $('.mainObjk')[0].scrollLeft * -1.0 + 162.0 + $('#' + $('.FrgObj')[0].children[i].id)[0].offsetLeft *1.0);
                //alert($('#' + $('.FrgObj')[0].children[i].id).offetLeft);
                //$('#' + iDiv.id).find('.close3').css("padding-left", $('#' + iDiv.id)[0].offsetLeft + "px !important");
                //$('#' + $('.FrgObj')[0].children[i].id).find('.close3').css("padding-left", $('.FrgObj')[0].children[i].offsetLeft + "px");
                // alert($('.FrgObj')[0].children[i].offsetLeft);
            }
        }
    </script>
</asp:Content>


