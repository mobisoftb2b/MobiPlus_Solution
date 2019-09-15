<%@ Page Title="MobiPlus Home Page" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="HomeEdit.aspx.cs" Inherits="Pages_usr_Default" %>

<%@ Register Src="~/UsrCtl/ImgsSwitcher.ascx" TagName="ImgsSwitcher" TagPrefix="MP" %>
<asp:Content ID="Conent1" ContentPlaceHolderID="head" runat="Server">
<script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function DoStart() {
            try {
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=SetPositiopnDocument&ScreenWidth=" + $(document).width() + "&ScreenHeight=" + $(document).height(),
                    type: "Get",
                    data: '',
                    success: function () {
                        //debugger;
                        if (window && window.location)
                            window.location.reload();
                    },
                    error: function () {
                        if (window && window.location)
                            window.location.reload();
                    }
                });
            }
            catch (e) {
            }
        }
        function SetTab(id) {
            try {
                setTimeout('SetTabTime(\"' + id + '\");', 2500);
            }
            catch (e) {
            }

        }
        function SetTabTime(id) {
            try {
                $('#ContentPlaceHolder1_tab' + id).click();
            }
            catch (e) {
            }
        }

        function ShowProperties() {
            //debugger;
            $('.imgN').css("right", "4px");
            if ($('.winProp').css("display") == "none") {
                $('#imgArrow')[0].src = "../../Img/arrow-up.png";
                $('.winProp').css("display", "block");
            }
            else {
                $('#imgArrow')[0].src = "../../Img/arrow-down.png";
                $('.winProp').css("display", "none");
            }
        }
        function SetAllFrames() {
            //debugger;

            for (var i = 0; i < $('IFRAME').length; i++) {
                var src = $('IFRAME')[i].src;
                if (src.indexOf('iDate') > -1)
                    src = src.substring(0, src.indexOf('iDate'));
                else if (src.indexOf('?') == -1)
                    src += "?";
                else
                    src += "&";
                var arr = $('#txtDate').val().split('/');
                src += "iDate=" + arr[2] + arr[1] + arr[0];
                src += "&AgentID=" + $('#<%= ddlAgents.ClientID%>').val();
                src += "&ID=" + $('IFRAME')[i].id.replace("#", "").replace("ifr", "");

                $('IFRAME')[i].src = src;
            }
            ShowProperties();
            SetMsgLocal();
        }
        function CloseWinJump(id) {
            var top = currentMousePos.y;
            $("#divJumpGridWin").css({ top: top })
                    .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();  
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <center>
            <%--<div class="isbg">
                <MP:ImgsSwitcher runat="server" ID="imgsSwitcher" />
            </div>--%>
        </center>
        <div>
            <div id="tabs" style="text-align: left; direction: ltr; width: 99%;">
                <ul runat="server" id="tabsUl">
                </ul>
                <div class="HomeMSG">
                    <asp:Label runat="server" ID="lblMSG"></asp:Label>
                </div>
                <div class="imgN" onclick="ShowProperties();">
                    <img id="imgArrow" alt="אפשריות" src="../../Img/arrow-down.png" />
                </div>
                <div class="winProp" style="">
                    <table cellpadding="2" cellspacing="2">
                        <tr>
                            <td>
                                <%=StrSrc("DataRelevance")%>
                            </td>
                            <td>
                                <input id="txtDate" type="text" class="dtp txtDate" value="26/02/2014" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%=StrSrc("Agent")%>
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlAgents" Width="120px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: left; margin-left: 17px;">
                        <input type="button" value="<%=StrSrc("btnShowByProp")%>" style="width: 80px;" onclick="SetAllFrames();" />
                    </div>
                </div>
                <asp:UpdatePanel runat="server" ID="UpdatePaneldTabs" UpdateMode="Always">
                    <ContentTemplate>
                        <div runat="server" id="dTabs" class="tabss">
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div>
        <center>
            <div id="divJumpGridWin" class="EditWinBoxJumpGrid">
                <div class="JumpWiX">
                    <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinJump();" />
                </div>
                <div class="JumpWinHead">
                    
                </div>
                <div class="EditWinJump">
                                 
                </div>
            </div>
        </center>
    </div>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Always">
        <ContentTemplate>
            <div class="dWidgetsList" id="dWidgetsList" runat="server">
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <span style="display: none;">
        <asp:UpdatePanel runat="server" ID="upMain" UpdateMode="Always">
            <ContentTemplate>
                <asp:Button runat="server" ID="btnInit" />
                <asp:Button runat="server" ID="btnAddTab" OnClick="btnAddTab_Click" />
                <asp:HiddenField runat="server" ID="hdnTab" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </span>
    <div id="tmp">
    </div>
    <script type="text/javascript">
    function SetIFRWidth()
        {
            if($('#ifrJumper').contents().find('#jQGrid').length>0)
                $("#divJumpGridWin").css("width", $('#ifrJumper').contents().find('#jQGrid')[0].clientWidth*1.0+50.0);
        }
    var currentMousePos = { x: -1, y: -1 };
     var CurY=0;
//        jQuery(function($) {
//           
//            $(document).mousemove(function(event) {
//                currentMousePos.x = event.pageX;
//                currentMousePos.y = event.pageY-100.0;
//                CurY = currentMousePos.y;
//            });

//            // ELSEWHERE, your code that needs to know the mouse position without an event
//            if (currentMousePos.x < 10) {
//                // ....
//            }
//        });
        function setParentY(pageY)
        {
            currentMousePos.y = $(document).scrollTop() + 150.0;
        }
       
        function SetEditWinJump(GridName,JumpWinHead)
        {
            try
            {
                $("#divJumpGridWin").css("display", "block");
                var top = 1000;
                $("#divJumpGridWin").css({ top: top })
                        .animate({ "top": currentMousePos.y + "px" }, "high");

                $('#dBody').block({ message: '' });     
                $('.EditWinJump').html("<iframe id ='ifrJumper' style='height:" + ($('.EditWinJump')[0].parentElement.clientHeight * 1.0 -27.0) + "px" + "' class='ifr' src='../Usr/GridViewNew.aspx?GridName="+GridName+"&GridParameters=Date:20140205;AgentID:0&ID=220&iDate=20140226&AgentID=0&ID=220'></iframe>");
                $('.JumpWinHead').text(JumpWinHead);     
            }
            catch(e)
            {}
        }
    var selectedTab;
        function DoNow()
        {
            $(function () {

                $("#tabs").tabs();
                $('#tabs').click('tabsselect', function (event, ui) {
               
                     selectedTab = $("#tabs").tabs('option','active');
                     //debugger;
                     //TabClick(selectedTab);                     
                 });
            });
        }
        DoNow();
        function TabClick(TabID)
        {
        
            if(TabID * 1.0 + 1 < $("#tabs")[0].children[0].children.length)
            {
                $('#<%=hdnTab.ClientID %>').val(TabID);
                $('#<%=btnInit.ClientID %>').click();
            }
            else if($('.txtAdd').length==0)
            {
                $('#<%=hdnTab.ClientID %>').val(TabID);
                $('#<%=btnAddTab.ClientID %>').click();
            }
        }
        var in1;
        function MTabClick(TabID)
        {
            in1=clearInterval(in1);
            in1 = setTimeout('TabClick(\"'+TabID+'\");',700);
        }
        $('#tabs').width($(window).width().toLocaleString().replace("px", "") * 1.0  + "px");
        $('.tabss').css("min-height",($(window).height().toLocaleString().replace("px", "") * 1.0 - 130 + "px"));

        function resizeIframe(obj) {
        //debugger;
      
            obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
            obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';

            obj.parentElement.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
            obj.parentElement.style.width = obj.contentWindow.document.body.scrollWidth + 'px';
        }


        function SetUserWidgetCol(ui, ColNum) {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetUserWidgetCol&WidgetsUserID=" + ui.item[0].id + "&ColNum=" + ColNum + "&TabID=" + GetTabID(),
                type: "Get",
                data: '',
                success: function () {
                   //alert("success");
                },
                error: function () {
                    //alert("failure");
                }
            });
        }
        function SetOrder(jsonObj) {
        //debugger;
            $.ajax({
               // url: "../../Handlers/MainHandler.ashx?MethodName=SetUserWidgetsOrder&jsonObj=" + json.stringify(jsonObj, null, 2) + "&TabID=" + GetTabID(),
                
                url: "../../Handlers/MainHandler.ashx?MethodName=SetUserWidgetsOrder&jsonObj=" + jsonObj + "&TabID=" + GetTabID(),
                type: "Get",
                data:'',
                success: function () {
                    //alert("success");
                },
                error: function () {
                    //alert("failure");
                }
            });
        }
        function setSize(ui) {
            //debugger;
            /*if (ui.size.height < ui.element.context.children[1].children[0].contentWindow.document.body.scrollHeight) {
                $("#" + ui.element.context.id).css("height", ui.element.context.children[1].children[0].contentWindow.document.body.scrollHeight + 50 + "px");
            }*/
////            if (ui.size.width < ui.element.context.children[1].children[0].contentWindow.document.body.scrollWidth) {
////                $("#" + ui.element.context.id).css("width", ui.element.context.children[1].children[0].contentWindow.document.body.scrollWidth + "px");
////                if (ui.element.context.children[1].children[0].contentWindow.document.getElementById("jQGrid") != null)
////                    $("#" + ui.element.context.id).css("width", ui.element.context.children[1].children[0].contentWindow.document.getElementById("jQGrid").style.width.replace("px", "") * 1.0 + 30 + "px");
////            }

        }
        function SetPos(ui) {
        
            setSize(ui);
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetUserWidgetPosition&Width=" + $("#" + ui.element.context.id).css("width").replace("px", "") + "&Height=" + $("#" + ui.element.context.id).css("height").replace("px", "") + "&WidgetsUserID=" + ui.element.context.id + "&TabID=" + GetTabID(),
                type: "Get",
                data: '',
                success: function () {
                    //alert("success");
                },
                error: function () {
                    //alert("failure");
                }
            });
        }
        function SetPosNew(width, height, id) {
               
              
            setLeft($(".l"), $(".pt1"));
            setLeft($(".c"), $(".pt2"));
            setLeft($(".r"), $(".pt3"));
           
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetUserWidgetPosition&Width=" + width + "&Height=" + height + "&WidgetsUserID=" + id + "&TabID=" + GetTabID(),
                type: "Get",
                data: '',
                success: function (data) {
                    //alert("success");
                    
                },
                error: function (data) {                
                    //alert("failure");
                    
                }
            });
        }
        function setLeft(obj, child) {
       
            /*initto();*/

            if (obj.length > 0 && obj.css("width").replace("px", "") * 1.0 + 15.0 < obj[0].scrollWidth)
                obj.css("width", obj[0].scrollWidth);
            else {
                var Max = 0;
                for (var i = 0; i < child.length; i++) {
                    if (child[i].offsetWidth > Max)
                        Max = child[i].offsetWidth + 15;
                }
                obj.css("width", Max);
            }
        }
        function DoSortable()
        {
        var cc;
        try
        {
            $(function () {
                $(".pt1").resizable({ alsoResize: ".l",
                delay: 500,
                    stop: function (event, ui) {
                        setLeft($(".l"), $(".pt1"));
                        SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                        //$(".pt2").css("max-width","1000px");
                        //$(".pt3").css("max-width","1000px");
                        
                    },
                    resize: function (event, ui) {
                        cc=clearInterval(cc);
                        cc = setTimeout('SetAfterResize('+ui+',\".l\",\".pt1\");',500);
                    }
                });
                $(".pt2").resizable({ alsoResize: ".c",
                delay: 500,
                    stop: function (event, ui) {
                        setLeft($(".c"), $(".pt2"));
                        SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                        //$(".pt1").css("max-width","1000px");
                        //$(".pt3").css("max-width","1000px");   
                    },
                    resize: function (event, ui) {
                        cc=clearInterval(cc);
                        cc = setTimeout('SetAfterResize('+ui+',\".c\",\".pt2\");',500);
                    }
                });
                $(".pt3").resizable({ alsoResize: ".r",
                delay: 500,
                    stop: function (event, ui) {
                        setLeft($(".r"), $(".pt3"));
                        SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                        //$(".pt1").css("max-width","1000px");
                        //$(".pt2").css("max-width","1000px");
                    },
                    resize: function (event, ui) {
                        cc=clearInterval(cc);
                        cc = setTimeout('SetAfterResize('+ui+',\".r\",\".pt3\");',500);
                    }
                });
                $(".column").sortable({
                    distance: 5,
                    delay: 10,
                    opacity: 0.6,
                    cursor: 'move',
                    connectWith: ".column",
                    handle: ".portlet-header",
                    cancel: ".portlet-toggle",
                    placeholder: "portlet-placeholder ui-corner-all",
                    start: function (event, ui) {
                    
                    },
                    sort: function (event, ui) {
                        
                    },
                    cursorAt: { top:10, right: 100 },

                    stop: function (event, ui) {
                        var arr = [];
                        for (var i = 0; i < $(".portlet").length; i++) {
                            var myObject = new Object();
                            myObject.id = $(".portlet")[i].id;
                            myObject.top = $(".portlet")[i].offsetTop;
                            myObject.left = $(".portlet")[i].offsetLeft;
                            arr.push(myObject);
                        }
                        cmp = function (x, y) {
                            return x > y ? 1 : x < y ? -1 : 0;
                        };

                        arr.sort(function (a, b) {
                            //note the minus before -cmp, for descending order
                            return cmp(
                                        [cmp(a.top, b.top), cmp(a.left, b.left)],
                                        [cmp(b.top, a.top), cmp(b.left, a.left)]
                                    );
                        });

                        var objJson="[";
                        for (var i = 0; i < arr.length; i++) {                        
                            objJson+='{"id":"'+arr[i].id+'","top":'+arr[i].top+',"left":'+arr[i].left+'},';
                        }
                        objJson+="]";

                        //debugger;
                        SetOrder(objJson);
                        //SetOrder(arr);

                        //debugger;
                        if (ui.item[0].offsetLeft < ui.item[0].offsetWidth) {//fisrt col
                            ui.item.context.className = ui.item.context.className.replace("pt2", "pt1").replace("pt3", "pt1");
                            SetUserWidgetCol(ui, "1");

                            $(".l").css("width", $("#" + ui.item[0].id).css("width").replace("px", "") * 1.0 + 20 + "px");

                            SetPosNew($("#" + ui.item.context.id).css("width").replace("px", ""), $("#" + ui.item.context.id).css("height").replace("px", ""), ui.item.context.id);
                        }
                        else if (ui.item[0].offsetLeft <= $(".l").width() + 27) {//$(".l")[0].scrollWidth + 25) {//second col
                            ui.item.context.className = ui.item.context.className.replace("pt1", "pt2").replace("pt3", "pt2");
                            SetUserWidgetCol(ui, "2");

                            $(".c").css("width", $("#" + ui.item[0].id).css("width").replace("px", "") * 1.0 + 20 + "px");

                            SetPosNew($("#" + ui.item.context.id).css("width").replace("px", ""), $("#" + ui.item.context.id).css("height").replace("px", ""), ui.item.context.id);
                        }
                        else if (ui.item[0].offsetLeft > $(".l")[0].scrollWidth + $(".c")[0].scrollWidth) {//theard col
                            ui.item.context.className = ui.item.context.className.replace("pt2", "pt3").replace("pt1", "pt3");
                            SetUserWidgetCol(ui, "3");

                            $(".r").css("width", $("#" + ui.item[0].id).css("width").replace("px", "") * 1.0 + 20 + "px");

                            SetPosNew($("#" + ui.item.context.id).css("width").replace("px", ""), $("#" + ui.item.context.id).css("height").replace("px", ""), ui.item.context.id);
                        }

                        $(".pt1").resizable({ alsoResize: ".l",
                        delay: 500,
                    stop: function (event, ui) {
                        setLeft($(".l"), $(".pt1"));
                        SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                        //$(".pt2").css("max-width","1000px");
                        //$(".pt3").css("max-width","1000px");
                    },
                    resize: function (event, ui) {
                        cc=clearInterval(cc);
                        cc = setTimeout('SetAfterResize('+ui+',\".l\",\".pt1\");',500);
                    }
                });
                $(".pt2").resizable({ alsoResize: ".c",
                delay: 500,
                    stop: function (event, ui) {
                        setLeft($(".c"), $(".pt2"));
                        SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                        //$(".pt1").css("max-width","1000px");
                        //$(".pt3").css("max-width","1000px");   
                    },
                    resize: function (event, ui) {
                        cc=clearInterval(cc);
                        cc = setTimeout('SetAfterResize('+ui+',\".c\",\".pt2\");',500);
                    }
                });
                $(".pt3").resizable({ alsoResize: ".r",
                delay: 500,
                    stop: function (event, ui) {
                        setLeft($(".r"), $(".pt3"));
                        SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                        //$(".pt1").css("max-width","1000px");
                        //$(".pt2").css("max-width","1000px");
                    },
                    resize: function (event, ui) {
                        cc=clearInterval(cc);
                        cc = setTimeout('SetAfterResize('+ui+',\".r\",\".pt3\");',500);
                    }
                });
                    }

                });

                $(".portlet")
          .addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
          .find(".portlet-header")
            .addClass("ui-widget-header ui-corner-all")
            .prepend("<span class='ui-icon ui-icon-close portlet-toggle'></span>");

                $(".portlet-toggle").click(function () {
                    // alert($(this)[0].parentElement.parentElement.id);
                    if (confirm("<%=StrSrc("ConfirmDeleteWidget") %>")) {                    
                        var obj = $(this)[0];
                        $.ajax({
                            url: "../../Handlers/MainHandler.ashx?MethodName=DeleteWidget&WidgetsUserID=" + $(this)[0].parentElement.parentElement.id + "&TabID=" + GetTabID(),
                            type: "Get",
                            data: '',
                            success: function () {
                                obj.parentElement.parentElement.style.display = "none";
                                SetFotter();
                            },
                            error: function () {
                                obj.parentElement.parentElement.style.display = "none";
                                SetFotter();
                            }
                        });
                    }
                    //debugger;

                    /*var icon = $(this);
                    icon.toggleClass("ui-icon-close ui-icon-plusthick");
                    icon.closest(".portlet").find(".portlet-content").toggle();*/
                });

            });
            }
            catch(e)
            {
            }

             
        }
        DoSortable();
        function AddTab() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddTab&TabName=" + escape($('.txtAdd').val()),
                type: "Get",
                data: '',
                success: function () {
               
                    window.location.href = window.location.href;
                },
                error: function () {
               
                    window.location.href = window.location.href;
                }
            });
        }
        function addWidget() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetAllWidgetsByPermissions",
                type: "Get",
                data: '',
                success: function (data) {
                    var htm = "<table width='100%' class='tblW'>";
                   // debugger;
                    for (var i = 0; i < data.length; i++) {
                        htm += "<tr>";
                        htm += "<td class='tdAddWidget'>";
                        htm += data[i].WidgetID;
                        htm += "</td>";
                        htm += "<td class='WName tdAddWidget' onclick='addWidgetByID(\"" + data[i].WidgetID + "\")'>";
                        htm += data[i].Name;
                        htm += "</td>";
                        htm += "</tr>";
                    }
                    htm += "</table>";
                    var htm2 = "";

                    if (data.length == 0) {
                        htm2 += "<div class='WName tdAddWidget nodata'>";
                        htm2 += "<%=StrSrc("ConfirmNoWidgets") %>";
                        htm2 += "</div>";
                    }
                    if (htm2.length == 0) {
                        $('.dWidgetsList')[0].innerHTML = "<div class='dX' onclick='CloseList();'>&nbsp;[X]&nbsp;</div>" + htm;
                    }
                    else {
                        $('.dWidgetsList')[0].innerHTML = "<div class='dX' onclick='CloseList();'>&nbsp;[X]&nbsp;</div>" + htm2;
                    }
                    $('.dWidgetsList').css('display', 'block');

                    var body = $("html, body");
                    body.animate({ scrollTop: 0 }, '500', 'swing', function () {
                        //alert("Finished animating");
                    });


                },
                error: function () {
             
                    window.location.href = window.location.href;
                }
            });
        }
        function addWidgetByID(WidgetID) {
            var tabid = GetTabID();
            var tab = GetTab();
            //debugger;
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddWidgetToUser&WidgetID=" + WidgetID + "&TabID=" + tabid,
                type: "Get",
                data: '',
                success: function () {
                    $('#<%=hdnTab.ClientID %>').val(tab);
                    $('#<%=btnInit.ClientID %>').click();


                    //var body = $("html, body");
                    //body.animate({ scrollTop:$('.tt' + tabid + '_' + WidgetID)[$('.tt' + tabid + '_' + WidgetID).length-1].offsetTop + "px"}, '500', 'swing', function () {
                        //alert("Finished animating");
                   // });
                },
                error: function () {
                    $('#<%=hdnTab.ClientID %>').val(tab);
                    $('#<%=btnInit.ClientID %>').click();

                   //debugger;
                    
                }
            });
        }
        function setTop()
        {
            var tabid = GetTabID();
            var body = $("html, body");
            try
            {                
                        body.animate({ scrollTop: $('.tt' + tabid + '_')[$('.tt' + tabid + '_').length-1].offsetTop + "px"}, '500', 'swing', function () {
                            //alert("Finished animating");
                        });
            }
            catch(e)
            {
                //body.animate({ scrollTop: "5px"}, '500', 'swing', function () {
                //            //alert("Finished animating");
                //});
            }
        }
        function GetTab() {
//            var tabid = "";
//            var tab = "";
//            for (var i = 0; i < $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children.length; i++) {
//                if ($("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].style.display != "none") {
//                    tabid = $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].id.replace("ContentPlaceHolder1_tab", "");
//                    tab = "ui-id-" + (i + 1.0);
//                }
//            }
            return selectedTab;// tab;
        }
        function SetselectedTab(id)
        {
            selectedTab = id;
        }
        function GetTabID() {
//            var tabid = "";
//            var tab = "";
//            for (var i = 0; i < $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children.length; i++) {
//                if ($("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].style.display != "none") {
//                    tabid = $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].id.replace("ContentPlaceHolder1_tab", "");
//                    tab = "ui-id-" + (i + 1.0);
//                }
//            }
            
            return selectedTab;//tabid;
        }
        function CloseList() {
            $('.dWidgetsList').css('display', 'none');
        }
        function DeleteTab() {
            //var txt =StrSrc("Test1", "true", "<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>");
            
            if (confirm('<%=StrSrc("ConfirmTag") %>')) {
                var obj = $(this)[0];
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=DeleteTag&TabID=" + GetTabID(),
                    type: "Get",
                    data: '',
                    success: function () {
                        window.location.href = window.location.href;
                    },
                    error: function () {
                        window.location.href = window.location.href;
                    }
                });
            }
        }
        function initto()
        {
        //debugger;
            for (var i = 0; i < $('.ui-icon-close').length; i++) {
                 $('.ui-icon-close')[i].style.marginRight = $('.ui-icon-close')[i].parentElement.offsetWidth * 1.0 - 22 + "px";
            }
           
        }
        setTimeout(initto,200);
        
        function initt()
            {
                for (var i = 0; i < $('.ifr').length; i++) {
                    try{
                        $('.ifr')[i].style.minHeight = $('.portlet-content')[i].parentElement.style.height.replace("px","") * 1.0 - 50 + "px";
                    }
                    catch(e)
                    {
                    }
                }
            }
            setTimeout(initt,1100);

            function SetLeftAll()
            {
                setLeft($(".l"), $(".pt1"));
                setLeft($(".c"), $(".pt2"));
                setLeft($(".r"), $(".pt3"));
            }
            
            $('#nEditHome').attr("class", "menuLink Selected");

             function pageLoad() {             
                $(".dtp").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy'
                });
                
                var d = new Date();

                var month = d.getMonth()+1;
                var day = d.getDate();

                var output =  (day<10 ? '0' : '') + day + '/' +
                    (month<10 ? '0' : '') + month + '/' +
                    d.getFullYear();
                
                //$('.txtDate').val(output);
                  $('.txtDate').val("27/11/2014");

                 setTimeout(initto,200);

                 setTimeout(SetMsgLocal,100);      
            }
         pageLoad();
         function SetMsgLocal()
         {      
            var MSG = "תאריך נבחר: "+ $('#txtDate').val();   
            MSG+="<br/>";
            MSG+="סוכן: " + $("#<%= ddlAgents.ClientID%> option:selected").text();
            SetHomeMSG(MSG);
         }
         function SetIFRH(id)
         {//debugger;
             try
             {
                //$("#ifr" + ui.element.context.id).css("height",$("#" + ui.element.context.id).css("height").replace("px", ""))
                if(id!="")
                {
                    if($("#" + id).css("height").indexOf("px")>-1)
                        $("#ifr" + id).css("height",$("#" + id).css("height").replace("px", "") - 50.0)
                    else
                        $("#ifr" + id).css("height",$("#" + id).css("height") - 50.0)

                        if($("#" + "ifrJumper").css("width").indexOf("px")>-1)
                        $("#" + "ifrJumper").css("width",$("#" + id).css("width").replace("px", "") )
                    else
                        $("#" + "ifrJumper").css("width",$("#" + id).css("width") )
                }
            }
            catch(e)
            {
            }
         }
         //debugger;
         function SetHomeMSG(msg)
         {
            $('#<%=lblMSG.ClientID %>')[0].innerHTML = msg;
         }
         function SetAfterResize(ui,className,OrgClassName)
         {
            setSize(ui);
            setLeft($(className), $(OrgClassName));
                    
            if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
            {
                // $(".pt1").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                   
            }
            initt();
         }
         $('#<%=lblMSG.ClientID %>').click('tabsselect', function (event, ui) {
                     ShowProperties();
                 });

        
    </script>
</asp:Content>
