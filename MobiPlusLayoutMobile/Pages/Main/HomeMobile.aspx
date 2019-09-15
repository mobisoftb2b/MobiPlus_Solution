<%@ Page Title="MobiSoft - Mobi Plus" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Pages_Main_Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="../../css/jquery-ui-1.9.2.custom.css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
    <style type="text/css">
        #droppable
        {
            padding: 0.5em;
            margin: 10px;
        }
        
        .Fragment h3
        {
            text-align: center;
            margin: 0;
            
        }
        .ui-widget-content .ui-icon
        {
            background-image: url(../../css/images/ui-icons_222222_256x240.png);
            width: 100%;
        }
        
        #tabs ul
        {
            float: right;
            width: 99%;
            padding-right:6px;
            padding-bottom:5px;
        }
        #tabs ul li
        {
            float: right;
            border: 1px solid black;
        }
        .srtableM
        {
            background-color: white;
            height: 100%;
        }
        
        
        .highlight
        {
        }
        .divForm
        {
            margin-top: 10px;
            width: 100%;
            border: 2px groove white;
            float: right;
            text-align: right;
            height: 610px;
        }
        .FragmentDiv
        {
            float: right;
        }
        .FragmentAfteDivr
        {
            float: right;
            margin-bottom: 15px !important;
            
        }
       
    </style>
    <script type="text/javascript">
        var isFirstClick = true;
        function SetMenu(htm) {
            setTimeout("setMenuReal('" + htm + "');", 100);
        }
        function setMenuReal(htm) {
            //alert(htm);
            $('#dMenuN')[0].innerHTML = htm;
            //$('#dMenur')[0].innerHTML = '<ul  id="menu" class="menu" style="z-index: 1111;"><li><a href="#">טופס 1</a></li><li><a href="#">טופס 1</a></li><li><a href="#">טופס 1</a></li></ul>'; //'<ul id="menu" class="menu" style="z-index: 1111;">                               <li><a href="#"><img src="../../img/Network.ico" width="16px"/>Item 1</a></li>                                <li><a href="#">Item 2</a></li>                                <li id="i3"><a href="#"><table cellpadding="0" cellspacing="0" style="white-space:nowrap;"><tr><td>Item 3</td><td style="width:80%;">&nbsp;</td><td>></td></tr></table></a>                                    <ul class="inner">                                        <li><a href="#">Item 3-1</a> </li>                                        <li><a href="#">Item 3-2</a></li>                                        <li><a href="#">Item 3-3</a></li>                                        <li><a href="#"><table cellpadding="0" cellspacing="0" style="white-space:nowrap;"><tr><td>Item 3-4</td><td style="width:80%;">&nbsp;</td><td>></td></tr></table></a>                                            <ul class="inner" style="z-index: 9999;">                                                <li><a href="#">Item 5</a></li>                                                <li><a href="#">Item 6</a></li>                                                <li><a href="#">Item 7</a></li>                                                <li><a href="#">Item 8</a></li>                                                <li><a href="#">Item 9</a></li>                                            </ul>                                        </li>                                        <li><a href="#">Item 3-5</a></li>                                    </ul>                                </li>                                <li><a href="#">Item 4</a></li>                                <li><a href="#">Item 5</a></li>                            </ul>';
            //$("#menu").menu();
           

        }
        function SetMenuName(name) {
            setTimeout('SetMenuNameReal(\"' + name + '\");', 100);
        }
        function SetMenuNameReal(name) {
            $('.menuLink').text(name);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="background-color: white;" onclick="CheckSession();">
        <div class="">
            <div id="tabs" style="text-align: right; direction: rtl; width: 99.2%; min-height: 99.2%;  overflow: hidden"
                class="srtableM">
                <ul runat="server" id="tabsUl" style="text-align: right; direction: rtl;">
                </ul>
                <div class="imgN" onclick="ShowFilters();" style="z-index: 1;">
                    <img id="imgArrow" alt="אפשריות" src="../../Img/arrow-up.png" height="25px" style="z-index: 1;" />
                </div>
                <div style="height: 60px; background-color: white; border-bottom: 2px solid white;
                    padding-bottom: 25px; width: 99.3%; display: none;" id="divFiltersContainer">
                    <asp:UpdatePanel runat="server" ID="UpdatePaneldivFilters" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div id="divFilters" runat="server">
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div style="clear: both;">
                </div>
                <div class="sortable" style="">
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField runat="server" ID="hdnSrcParams" />
    <asp:HiddenField runat="server" ID="hdnSelectedTabID" />
    <asp:HiddenField runat="server" ID="hdnIsFirstLoad" Value="true" />
    <asp:HiddenField runat="server" ID="hdnMenuSelectedItem" Value="sm_0" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Button runat="server" Style="display: none;" ID="btnIniFilters" OnClick="btnIniFilters_Click" />
            <asp:Button runat="server" Style="display: none;" ID="btnSetMenuSelectedItem" OnClick="btnSetMenuSelectedItem_Click" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dLoading" class="loading1" style="display:none;">
    <br />

        <img alt="...טוען" src="../../img/loading1.gif" width="50px;" />
        <br />
        טוען נתונים...
    </div>
    <script type="text/javascript">
        coner = 0;
        $("#dLoading").css("left",($(document).width()-280)/2);
        function CloseLoading() {
            coner++;
            var top = ((40 / 100) * $(document).height());
            if (coner >= $(".FragmentAfteDivr").length) {
                coner = 0;
                $("#dLoading").css({ top: $("#dLoading").css("top") })
                    .animate({ "top": "-700" }, "high");

                $("#dLoading").css("display","none");
                
            }
        }
        function ShowLoading() {
            $("#dLoading").css("display", "block");
            $("#dLoading").css("left", ($(document).width() - 280) / 2);
            var top = ((40/100) * $(document).height());
            $("#dLoading").css({ top: $("#dLoading").css("top") })
                    .animate({ "top": top }, "high");

        }
        //alert($('body').height());
        //$('#tabs').height($('.sortable').height() + "px");
        ////$('#tabs').height($(document).height() -30 + "px");
        //$('#tabs').css("min-height", $(document).height() - 90 + "px");

        var NewHeight = $(document).height() - 160;
        var NewWidth = $(document).width() - 85;
        var Width = 870;
        var Height = 700;

        if ("<%= isToHideHedders%>" == "True") {
            $('.mpHeadRow').hide();
            NewHeight = $(document).height() - 30;
            //$('#tabs').height($(document).height() - 45 + "px");
            setTimeout("SetFooterForHome();", 100);
        }
        function SetFooterForHome() {
            //$('#tabs').height(oldh-100 + "px");
            $('.mainfotter').css("margin-top", 5); //oldh + 30.0 - $('#dContent').height() - 36
        }
        function LoadTabsData() {
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetFormTabs&FormID=<%=FormiD %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=tabsUl.ClientID %>')[0].innerHTML = "";

                if (response.length > 0) {
                    selectedTab = response[0].TabID;
                    $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);
                }


                arrData = new Array(response.length);
                arrOuterData = new Array(response.length);
                arrTabIDs = new Array(response.length);
                arrTabIDsTouch = new Array(response.length);

                if (response.length > 0) {
                    SelectedTab = response[0].TabID;
                    $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);
                }
                //debugger;

                for (var i = 0; i < response.length; i++) {

                    arrTabIDs.push(response[i].TabID);
                    if (response[i].TabHTMLLayout != "") {
                        arrData[response[i].TabID] = unescape(response[i].TabHTMLLayout).toString().replace(/\+/g, ' ');
                        var ddiv = document.createElement('div');
                        ddiv.innerHTML = arrData[response[i].TabID];
                        arrOuterData[response[i].TabID] = ddiv.outerHTML;
                        arrTabIDs[response[i].TabID] = response[i].TabID;

                        if (i == 0) {
                            if (arrData[response[0].TabID]) {
                                $('.sortable')[0].innerHTML = unescape(arrData[response[0].TabID]).toString().replace(/\+/g, ' ');
                            }

                            //SetResizable();

                            //alert(unescape(arrData[response[0].TabID]).toString().replace(/\+/g, ' '));
                        }
                    }
                    else {
                        $('.sortable')[0].innerHTML = ""; //  EmptyObj;
                    }

                    var iLi = document.createElement('li');
                    var iTab = document.createElement('a');
                    iTab.id = "Tab_" + response[i].TabID;
                    iTab.innerHTML = response[i].TabName;
                    iTab.style["color"] = "white";
                    iTab.style["background-color"] = "#264366";
                    iTab.href = "javascript:onTabClick('" + iTab.id + "'," + i + ");";

                    iLi.innerHTML = iTab.outerHTML;
                    $('#<%=tabsUl.ClientID %>')[0].appendChild(iLi);


                }
                $('#Tab_' + SelectedTab).css("color", "#FA6E58");

                $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);

                arrTabIDsTouch[response[0].TabID] = true;
                onTabClick("Tab_" + response[0].TabID, 0);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {

                }
                else {
                    //alert("Error");
                }
            });
        }




        function DoNow() {

            $(function () {

                $("#tabs").tabs();
                //$('#tabs').tabs().tabs('rotate', 2000, 'true');
                $("#tabs").css("direction", "rtl")
                $("#tabs").css("text-align", "right");
                $('#tabs').click('tabsselect', function (event, ui) {

                    selectedTab = $("#tabs").tabs('option', 'active');
                    $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);
                    //debugger;
                    //TabClick(selectedTab);                     
                });
            });
        }
        var tabsClicked = "";
        var isNewWidth = false;
        var SelectedTab = "1";
        var lastIndex = 0;
        var arrData;
        var arrOuterData;
        var arrTabIDs;
        var arrTabIDsTouch;
        var EmptyObj;
        var Heightt = 0;
        function onTabClick(tabID, index) {
            ShowLoading();
            //NewWidth = $(document).width() - 84;
            NewWidth = $(window).width();
            $('#<%=hdnSrcParams.ClientID %>').val("");
            arrTabIDsTouch[tabID.replace("Tab_", "")] = true;
            //debugger;
            $('#Tab_' + SelectedTab).css("color", "#FFFFFF");
            var oldTab = SelectedTab;
            SelectedTab = tabID.replace("Tab_", "");

            $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);

           

            ///$(".FragmentDiv").resizable({ disabled: true });
            //$('.FragmentDiv').resizable("destroy");
            var data = $('.sortable')[0].innerHTML;
            var dataOuter = $('.sortable')[0].outerHTML;

            $('#' + tabID).css("color", "#FA6E58");

            //debugger;

            if (lastIndex > -1) {
                arrData[oldTab] = data;
                arrOuterData[oldTab] = dataOuter;
                arrTabIDs[oldTab] = oldTab;
            }
            lastIndex = index;

            if (arrData[SelectedTab]) {
                $(".FragmentDiv").resizable({ disabled: true });
                $('.FragmentDiv').resizable("destroy");
                $('.sortable')[0].innerHTML = unescape(arrData[SelectedTab]).toString().replace(/\+/g, ' ');
            }
            else {
                $('.sortable')[0].innerHTML = ""; //  EmptyObj;
            }
            Heightt = 0;
            var topt = 0;


            
            for (var i = 0; i < $(".FragmentDiv").length; i++) {
                $(".FragmentDiv")[i].style.paddingTop = "8px";
                $(".FragmentDiv")[i].style.paddingRight = "10px";
                $(".FragmentDiv")[i].style.backgroundColor = "white";
                $(".FragmentDiv")[i].style.border = "none";
                var id = $(".FragmentDiv")[i].id.replace("id_", "");
                var width = ((((NewWidth - (Width / 4.7)) * (($(".FragmentDiv")[i].style.width.replace("px", "") * 1.0 * 99.3) / (Width))) / 100));
                if ($('.MenuN').css("display") == "none" && tabsClicked.indexOf(tabID + ";") == -1) {
                    //NewWidth=550;
                    //alert($(window).width());
                    if (NewWidth > 990)
                        width = ((((NewWidth - (Width / 8.7)) * (($(".FragmentDiv")[i].style.width.replace("px", "") * 1.0 * 99.3) / (200 * 4.1 * 1.91))) / 100)); //(width.replace("px", "") * 1.0 + $('.MenuN').width() * 1.0 / 2);
                    else
                        width = NewWidth * (94) / 100;
                        //width = ((((NewWidth) * (($(".FragmentDiv")[i].style.width.replace("px", "") * 1.0 * 99.3) / (200 * 4.1 * 1.91))) / 100)); //(width.replace("px", "") * 1.0 + $('.MenuN').width() * 1.0 / 2);
                    //alert(width);
                }

                $(".FragmentDiv")[i].innerHTML = "";

                $(".FragmentDiv")[i].style.width = width + 3 + "px";
                $(".FragmentDiv")[i].style.height = ($(".FragmentDiv")[i].style.height.replace("px", "") * 1.0 * 100.0 / Height) / 100 * NewHeight + "px"; //$(".FragmentDiv")[i].style.height.replace("px", "") * 1.45 + "px";
                if (topt < $(".FragmentDiv")[i].offsetTop)
                    Heightt += ($(".FragmentDiv")[i].style.height.replace("px", "") * 1.0 * 100.0 / Height) / 100 * NewHeight;
                topt = $(".FragmentDiv")[i].offsetTop;
            }


            for (var i = 0; i < $(".FragmentAfteDivr").length; i++) {
                $(".FragmentAfteDivr")[i].style.paddingTop = "8px";
                $(".FragmentAfteDivr")[i].style.paddingRight = "10px";
                $(".FragmentAfteDivr")[i].style.backgroundColor = "white";
                $(".FragmentAfteDivr")[i].style.border = "none";
                var id = $(".FragmentAfteDivr")[i].id.replace("id_", "");
                var width = $(".FragmentAfteDivr")[i].style.width.replace("px", ""); //((((NewWidth - (Width / 4.7)) * (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0 * 99.3) / (Width))) / 100));
                if ($('.MenuN').css("display") == "none" && tabsClicked.indexOf(tabID + ";") == -1) {
                    //alert(NewWidth);
                    //alert(3);
                    if (NewWidth > 990)
                        width = ((((NewWidth - (Width / 8.7)) * (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0 * 99.3) / (200 * 4.1 * 1.91))) / 100)); //(width.replace("px", "") * 1.0 + $('.MenuN').width() * 1.0 / 2);
                    else
                        width = NewWidth * (94) / 100;  //((((NewWidth*8.75) * (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0 * 99.3) / (200 * 4.1 * 1.91))) / 100)); //(width.replace("px", "") * 1.0 + $('.MenuN').width() * 1.0 / 2);
                    //alert(width);
                }

                $(".FragmentAfteDivr")[i].innerHTML = "";

                $(".FragmentAfteDivr")[i].style.width = width + 3 + "px";
                //$(".FragmentAfteDivr")[i].style.height = ($(".FragmentAfteDivr")[i].style.height.replace("px", "") * 1.0 * 100.0 / Height) / 100 * NewHeight + "px"; //$(".FragmentDiv")[i].style.height.replace("px", "") * 1.45 + "px";
                //if (topt < $(".FragmentAfteDivr")[i].offsetTop)
                    //Heightt += ($(".FragmentAfteDivr")[i].style.height.replace("px", "") * 1.0 * 100.0 / Height) / 100 * NewHeight;
                topt = $(".FragmentAfteDivr")[i].offsetTop;
            }
            //alert(2);
            if ($(".FragmentAfteDivr").length > 0 && $('.MenuN').css("display") == "none") {
                isNewWidth = true;
                tabsClicked += tabID + ";";
            }

//            if ($(".FragmentDiv").length > 0) {
//                if ($(document).height() <= Heightt)
//                    $('#tabs').height(Heightt - 75 + "px");
//                else
//                    $('#tabs').height($(document).height() - 90 + "px");

//                alert(5);
//            }

            $('.sortable')[0].innerHTML = $('.sortable')[0].innerHTML.replace(/FragmentDiv/g, 'FragmentAfteDivr');

            $('#<%=hdnIsFirstLoad.ClientID %>').val("true");

            if ($('.sortable')[0].innerHTML.toString().indexOf("iframe")>0)
            {
                $('#<%=hdnIsFirstLoad.ClientID %>').val("false");
            }

            $('#<%=btnIniFilters.ClientID %>').click();

            
            //$('#tabs').css("min-height",$('body').height() - 90 + "px");
        }
        function ObjClick(id) {
            setTimeout(CheckForAddFragment, 200);
            isDragging = true;

            ObjID = id;

            ClosedivAddReport();
        }

        var arrControls = new Array();
        var isNavOne = true;
        var key11;
        var val11;
        var currentID11;
        function SethdnSrcParams(key, val, currentID) {
            key11 = key;
            val11 = val;
            currentID11 = currentID;
            var NewHeight = $(document).height() - 160;
            //var NewWidth = $(document).width() - 85;
            var Width = 870;
            var Height = 700;

            var isFound = false;
            for (var i = 0; i < arrControls.length; i++) {
                if (arrControls[i] == currentID) {
                    isFound = true;
                    break;
                }
            }

            if (!isFound) {
                arrControls.push(currentID);
            }
            //debugger;
            if (!isNavOne) {
                if ($('#<%=hdnSrcParams.ClientID %>').val().indexOf(key.replace("@", "")) > -1) {
                    var arr = $('#<%=hdnSrcParams.ClientID %>').val().split("&");
                    var params = "";
                    for (var i = 1; i < arr.length; i++) {
                        var value = val;
                        if (val.indexOf(';') > -1)
                            value = val.split(';')[i - 1];
                        if (arr[i].indexOf(key.replace("@", "")) > -1) {
                            params += "&" + key.replace("@", "") + "=" + value;
                        }
                        else {

                            params += "&" + arr[i];

                            params = params.replace("&&", "&");
                            params = params.replace("@", "");
                        }
                    }
                    params = params.replace("&&", "&");
                    params = params.replace("@", "");
                    $('#<%=hdnSrcParams.ClientID %>').val(params);
                }
                else {
                    
                    $('#<%=hdnSrcParams.ClientID %>')[0].value = $('#<%=hdnSrcParams.ClientID %>')[0].value + "&" + key.replace("@", "") + "=" + val;
                }
            }

            $('#<%=hdnSrcParams.ClientID %>')[0].value = $('#<%=hdnSrcParams.ClientID %>')[0].value.replace(/@/g, '');
          
            for (var i = 0; i < $(".FragmentAfteDivr").length; i++) {
                var id = $(".FragmentAfteDivr")[i].id.replace("id_", "");
                var isFoundControl = false;
                for (var j = 0; j < arrControls.length; j++) {
                    if (arrControls[j] == 'if_' + i.toString()) {
                        isFoundControl = true;
                        break;
                    }
                }
                
                setTimeout("GetIframe('" + $(".FragmentAfteDivr")[i].className + "'," + i + "," + id + ");", (i + 1) * 150);
                //$(".FragmentAfteDivr")[0].innerHTML = GetIframe($(".FragmentAfteDivr")[0].className, 1, id);
            }
        }

        function GetIframe(Rep, i, id) {
            if (Rep.indexOf("Rep_7") > -1) {//pie
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowGrafPie.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_8") > -1) {//bar
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowGrafBar.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_9") > -1) {//clock
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowGrafClock.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_10") > -1) {//hbar
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowGraphHBar.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_5") > -1) {//Compiled
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowReport.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_11") > -1) {//Sections
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowSections.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport2' />";
                $(".FragmentAfteDivr")[i].style.marginRight = "-10px";
            }
            else if (Rep.indexOf("Rep_12") > -1) {// MobiEmpty   
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowEmpty.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport3' />";                
            } 
            else {//grid
                $(".FragmentAfteDivr")[i].innerHTML = "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='../RPT/ShowReport.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + (($(".FragmentAfteDivr")[i].style.width.replace("px", "") * 1.0) - 34.0 * 1.0) + "&Height=" + $(".FragmentAfteDivr")[i].style.height.replace("px", "") + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
        }
        function openNewForm(id, RowID) {
            var width = $(document).width();
            var height = $(document).height();
            var left = 0;
            var top = 0;

            var win = window.open("../Main/Home.aspx?FormiD=" + id + "&IsAllPage=true&RowID=" + RowID + $('#<%=hdnSrcParams.ClientID %>').val(), 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes');
            win.focus();
        }
        function openNewReport(id, RowID) {
            var width = 1200.0;
            var height = 630.0;
            var left = (screen.width / 2.0) - (width / 2.0);
            var top = (screen.height / 2.0) - (height / 2.0);

            var win = window.open("ShowFrame.aspx?ID=" + id + "&RowID=" + RowID + $('#<%=hdnSrcParams.ClientID %>').val(), 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes');
            win.focus();
        }

        function openNewForm2(id, params) {
            var width = $(document).width();
            var height = $(document).height();
            var left = 0;
            var top = 0;

            var win = window.open("../Main/Home.aspx?FormiD=" + id + "&IsAllPage=true&" + params, 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes');
            win.focus();
        }
        function openNewForm3(id, params) {
            var width = $(document).width();
            var height = $(document).height();
            var left = 0;
            var top = 0;

            window.location = "../Main/Home.aspx?SelectedMenuItem=" + $('#<%= hdnMenuSelectedItem.ClientID%>').val() + "&FormiD=" + id + "&IsAllPage=false", 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes';
        }
        function openNewReport2(id, params) {
            var width = 1200.0;
            var height = 630.0;
            var left = (screen.width / 2.0) - (width / 2.0);
            var top = (screen.height / 2.0) - (height / 2.0);

            var win = window.open("ShowFrame.aspx?ID=" + id +"&"+ params, 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes');
            win.focus();
        }
        function openNewReport3(id, params) {
            var width = 1200.0;
            var height = 630.0;
            var left = (screen.width / 2.0) - (width / 2.0);
            var top = (screen.height / 2.0) - (height / 2.0);

            window.location = "ShowFrame.aspx?SelectedMenuItem=" + $('#<%= hdnMenuSelectedItem.ClientID%>').val() + "&ID=" + id + "&" + params, 'WinOpenEditSections', 'top=' + top + ', left=' + left + ', width=' + width + ',height=' + height + ',resizable=yes,location=no,scrollbars=yes';
            
        }
        function SetHeight(val, currentID) {
            for (var i = 0; i < $(".FragmentAfteDivr").length; i++) {
                var id = $(".FragmentAfteDivr")[i].id.replace("id_", "");
                for (var j = 0; j < arrControls.length; j++) {
                    if (arrControls[j] == 'if_' + i.toString() && currentID == 'if_' + i.toString()) {
                        $(".FragmentAfteDivr")[i].style.height = val;
                        //alert(8);
                        break;
                    }
                }

            }
        }
        SetHeight();
        var oldh = $(document).height();
        function ShowFilters() {
            if ($('#divFiltersContainer').css("display") == "none") {

                $('#divFiltersContainer').slideDown("slow");

                $('#imgArrow')[0].src = "../../Img/arrow-Down.png";

                $('.srtableM').height(oldh + 190);
                
            }
            else {
                $('#imgArrow')[0].src = "../../Img/arrow-up.png";
                $('#divFiltersContainer').slideUp();
                SetFooterForHome();
                if ($(document).height() > Heightt)
                    Heightt = $(document).height()-20;
                //$('#tabs').height(Heightt -80 + "px");
                //alert(Heightt);

                
            }

        }
        
        function NavFrame(val, ControlKey) {
           
            //debugger;
            //alert($('#<%=hdnSrcParams.ClientID %>')[0].value);
            var ValUfter = "";
            var arrval = $('#<%=hdnSrcParams.ClientID %>')[0].value.split('&');
            for (var i = 0; i < arrval.length; i++) {
                if (arrval[i].indexOf(ControlKey.replace("@","")) > -1) {
                    var arrS = arrval[i].split('=');
                    arrval[i] = arrS[0] + "=" + val;
                }
                if (arrval[i]!="")
                    ValUfter += "&@" + arrval[i];
            }
            $('#<%=hdnSrcParams.ClientID %>')[0].value = ValUfter;
            isNavOne = true;
            
            SethdnSrcParams(ControlKey, ValUfter, '1');
            isNavOne = false;

            //SetOnStart("25px");
        }
        var arr;
        var v;
        function NavAllFrame(val, ControlKeies) {
            val1 = val;
            ControlKey1 = ControlKeies;
            v = val;
            arr = ControlKeies.split(';');
            var arrVals = val.split(';');
            for (var i = 0; i < arr.length; i++) {
                if (arr[i] != "")
                    $('#<%=hdnSrcParams.ClientID %>')[0].value = $('#<%=hdnSrcParams.ClientID %>')[0].value + "&" + arr[i].replace("@", "") + "=" + arrVals[i];
            }
            setTimeout("OnStart();", 100);
           

            //SetOnStart("25px");
        }
        function OnStart() {
           //onTabClick("Tab_0", 0);
           SethdnSrcParams(arr[0], v, '1');
        }
        function ClearDDL(id, ControlKey) {
            $('#' + id).val("0");
            NavFrame("0", ControlKey);
        }

        function setPickers() {
            $(".dtp").datepicker({
                changeMonth: true,
                changeYear: true,
                dateFormat: 'dd/mm/yy'
            });

            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var output = (day < 10 ? '0' : '') + day + '/' +
                    (month < 10 ? '0' : '') + month + '/' +
                    d.getFullYear();

            //$('.txtDate').val(output);
            //$('.txtDate').val("27/11/2014");

        }
        function SetMenuSelectedItenmLocal(id) {
//            if ($('.smSelected').length>0)
//                $('.smSelected')[0].className = "sm";
//            $('#' + id)[0].className = "smSelected";
        }
        function SetMenuSelectedItenm(id) {
            SetMenuSelectedItenmLocal(id);
            $('#<%= hdnMenuSelectedItem.ClientID%>').val(id);
            $('#<%= btnSetMenuSelectedItem.ClientID%>')[0].click();
        }
        DoNow();
        LoadTabsData();
        //ShowFilters();

        $('.MenuN').hide();
        $('#tdMenu').show().toggle(400);
        $('.ImgMenu').css("right", "3px");
        $('#imgShowMenu')[0].src = "../../img/show_menu.png";
        $('.ImgMenu').css("background-color", "white");
        NewWidth = $(document).width() + 90;
    </script>
</asp:Content>
