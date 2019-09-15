<%@ Page Title="MobiPlus Home Page" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="Pre.aspx.cs" Inherits="Pages_usr_Default" %>

<%@ Register Src="~/UsrCtl/ImgsSwitcher.ascx" TagName="ImgsSwitcher" TagPrefix="MP" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function DoStart() {
            $.ajax({
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetPositiopnDocument&ScreenWidth=" + $(document).width() + "&ScreenHeight=" + $(document).height(),
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
        function SetTab(id) {
            $('#' + id).click();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                <div runat="server" id="dTabs" class="tabss">
                </div>
            </div>
        </div>
    </div>
    <div class="dWidgetsList" id="dWidgetsList" runat="server">
    </div>
    <span style="display: none;">
        <asp:Button runat="server" ID="btnInit" OnClick="btnInit_Click" />
        <asp:HiddenField runat="server" ID="hdnTab" />
    </span>
    <script type="text/javascript">
        $(function () {

            $("#tabs").tabs();

        });

        $('#tabs').width($(window).width().toLocaleString().replace("px", "") * 1.0  + "px");
        $('.tabss').css("min-height",($(window).height().toLocaleString().replace("px", "") * 1.0 - 130 + "px"));

        function resizeIframe(obj) {
            obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
            obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';

            obj.parentElement.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
            obj.parentElement.style.width = obj.contentWindow.document.body.scrollWidth + 'px';
        }


        function SetUserWidgetCol(ui, ColNum) {
            $.ajax({
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetUserWidgetCol&WidgetsUserID=" + ui.item[0].id + "&ColNum=" + ColNum + "&TabID=" + GetTabID(),
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
            $.ajax({
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetUserWidgetsOrder&jsonObj=" + JSON.stringify(jsonObj, null, 2) + "&TabID=" + GetTabID(),
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
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetUserWidgetPosition&Width=" + $("#" + ui.element.context.id).css("width").replace("px", "") + "&Height=" + $("#" + ui.element.context.id).css("height").replace("px", "") + "&WidgetsUserID=" + ui.element.context.id + "&TabID=" + GetTabID(),
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
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetUserWidgetPosition&Width=" + width + "&Height=" + height + "&WidgetsUserID=" + id + "&TabID=" + GetTabID(),
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
        function setLeft(obj, child) {
            initto();

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
        $(function () {
            $(".pt1").resizable({ alsoResize: ".l",
                stop: function (event, ui) {
                    setLeft($(".l"), $(".pt1"));
                    SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                    $(".pt2").css("max-width","1000px");
                    $(".pt3").css("max-width","1000px");
                },
                resize: function (event, ui) {
                    setSize(ui);
                    setLeft($(".l"), $(".pt1"));
                    
                    if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
                    {
                        $(".pt1").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                   
                    }
                    initt();
                }
            });
            $(".pt2").resizable({ alsoResize: ".c",
                stop: function (event, ui) {
                    setLeft($(".c"), $(".pt2"));
                    SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                    $(".pt1").css("max-width","1000px");
                    $(".pt3").css("max-width","1000px");   
                },
                resize: function (event, ui) {
                    setSize(ui);
                    setLeft($(".c"), $(".pt2"));
                    //debugger;
                    //alert($('#tabs').width().toLocaleString().replace("px","").replace(",", ""));
                    if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
                    {
                        $(".pt2").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                   
                    }
                    initt();
                }
            });
            $(".pt3").resizable({ alsoResize: ".r",
                stop: function (event, ui) {
                    setLeft($(".r"), $(".pt3"));
                    SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                    $(".pt1").css("max-width","1000px");
                    $(".pt2").css("max-width","1000px");
                },
                resize: function (event, ui) {
                    setSize(ui);
                    setLeft($(".r"), $(".pt3"));

                    if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
                    {
                        $(".pt3").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                                               
                    }
                    initt();
                }
            });
            $(".column").sortable({
                connectWith: ".column",
                handle: ".portlet-header",
                cancel: ".portlet-toggle",
                placeholder: "portlet-placeholder ui-corner-all",
                start: function (event, ui) {
                    //ui.item[0].style.width = "200px";
                },
                stop: function (event, ui) {
                    //debugger;
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
                    SetOrder(arr);

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
                stop: function (event, ui) {
                    setLeft($(".l"), $(".pt1"));
                    SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                    $(".pt2").css("max-width","1000px");
                    $(".pt3").css("max-width","1000px");
                },
                resize: function (event, ui) {
                    setSize(ui);
                    setLeft($(".l"), $(".pt1"));
                    
                    if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
                    {
                        $(".pt1").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                      
                    }
                    initt();
                }
            });
            $(".pt2").resizable({ alsoResize: ".c",
                stop: function (event, ui) {
                    setLeft($(".c"), $(".pt2"));
                    SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                    $(".pt1").css("max-width","1000px");
                    $(".pt3").css("max-width","1000px");   
                },
                resize: function (event, ui) {
                    setSize(ui);
                    setLeft($(".c"), $(".pt2"));
                   
                    if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
                    {
                        $(".pt2").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                       
                    }
                    initt();
                }
            });
            $(".pt3").resizable({ alsoResize: ".r",
                stop: function (event, ui) {
                    setLeft($(".r"), $(".pt3"));
                    SetPosNew($("#" + ui.element.context.id).css("width").replace("px", ""), $("#" + ui.element.context.id).css("height").replace("px", ""), ui.element.context.id);
                    $(".pt1").css("max-width","1000px");
                    $(".pt2").css("max-width","1000px");
                },
                resize: function (event, ui) {
                    setSize(ui);
                    setLeft($(".r"), $(".pt3"));

                    if(ui.originalSize.width < ui.size.width && ui.element[0].parentNode.parentNode.parentNode.parentNode.offsetWidth * 1.0 >= $(window).width().toLocaleString().replace("px", "").replace(",", "") * 1.0 - 60.0)
                    {
                        $(".pt3").css("max-width", ui.size.width.toLocaleString().replace("px","").replace(",", "") * 1.0 - 60 + "px");                                  
                    }
                    initt();
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
                        url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=DeleteWidget&WidgetsUserID=" + $(this)[0].parentElement.parentElement.id + "&TabID=" + GetTabID(),
                        type: "Get",
                        data: '',
                        success: function () {
                            obj.parentElement.parentElement.style.display = "none";
                        },
                        error: function () {
                            obj.parentElement.parentElement.style.display = "none";
                        }
                    });
                }
                //debugger;

                /*var icon = $(this);
                icon.toggleClass("ui-icon-close ui-icon-plusthick");
                icon.closest(".portlet").find(".portlet-content").toggle();*/
            });

        });

        function AddTab() {
            $.ajax({
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=AddTab&TabName=" + escape($('.txtAdd').val()),
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
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=GetAllWidgetsByPermissions",
                type: "Get",
                data: '',
                success: function (data) {
                    var htm = "<table width='100%' class='tblW'>";

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

            $.ajax({
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=AddWidgetToUser&WidgetID=" + WidgetID + "&TabID=" + tabid,
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
                    body.animate({ scrollTop: $('.tt' + tabid + '_')[$('.tt' + tabid + '_').length-1].offsetTop + "px"}, '500', 'swing', function () {
                        //alert("Finished animating");
                    });
        }
        function GetTab() {
            var tabid = "";
            var tab = "";
            for (var i = 0; i < $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children.length; i++) {
                if ($("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].style.display != "none") {
                    tabid = $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].id.replace("ContentPlaceHolder1_tab", "");
                    tab = "ui-id-" + (i + 1.0);
                }
            }
            return tab;
        }
        function GetTabID() {
            var tabid = "";
            var tab = "";
            for (var i = 0; i < $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children.length; i++) {
                if ($("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].style.display != "none") {
                    tabid = $("#tabs")[0].children.ContentPlaceHolder1_dTabs.children[i].id.replace("ContentPlaceHolder1_tab", "");
                    tab = "ui-id-" + (i + 1.0);
                }
            }
            return tabid;
        }
        function CloseList() {
            $('.dWidgetsList').css('display', 'none');
        }
        function DeleteTab() {
            //var txt =StrSrc("Test1", "true", "<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>");
            
            if (confirm('<%=StrSrc("ConfirmTag") %>')) {
                var obj = $(this)[0];
                $.ajax({
                    url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=DeleteTag&TabID=" + GetTabID(),
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
                 $('.ui-icon-close')[i].style.marginRight = $('.ui-icon-close')[i].parentElement.offsetWidth * 1.0 - 16 + "px";
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
            
            $('#nMimshak').attr("class", "menuLink Selected");
    </script>
</asp:Content>
