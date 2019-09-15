<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Goals.aspx.cs" Inherits="Pages_Compield_Goals" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link href="../../css/WebMain.css" rel="stylesheet" type="text/css" />
    <link href="../../css/General.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <link rel="stylesheet" href="~/css/jquery-ui.css">
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        select option:checked
        {
            background-color: #FD9100;
        }
        .ui-widget-header
        {
            background: #264366 !important;
        }
        .ui-jqgrid-sortable
        {
            color: #21225E !important;
        }
        .ui-tabs-anchor
        {
            color: #21225E !important;
        }
        .ui-tabs-anchor:hover
        {
            color: #ECEDEE !important;
            background: #3655A5 !important;
        }
        
        .tHead
        {
            color: White;
            background-color: #264366;
            text-align: center;
            height: 30px;
            font-size: 16px;
            font-weight: 700;
        }
        .td1
        {
            width: 170px;
            font-weight: 700;
        }
        .td2
        {
            width: 170px;
            border-right: 2px solid white;
        }
        .tBody
        {
            border-bottom: 2px solid white;
            font-size: 14px;
            padding: 5px;
            vertical-align: top;
        }
        #dalll
        {
            border: 2px solid #264366;
            width: 500px;
            margin-right: 20px;
            background-color: #D2DEEF;
            -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            max-height: 700px;
            overflow-y: auto;
        }
        .img1
        {
            /*border: 2px solid #264366;*/
        }
        .MediaItem
        {
            text-align: center;
        }
        .obj
        {
            border: 4px solid #D2DEEF;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }
        .obj:hover
        {
            border: 4px solid #FA6E58;
        }
        .obj.SelectedObj
        {
            border: 4px solid #FA6E58;
        }
        .ButtonsCls
        {
            margin-right: 20px;
            margin-top: 5px;
            text-align: center;
            background-color: #264366;
            height: 45px;
            border: 2px solid #264366;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
        }
        .tblBtns
        {
            padding-top: 5px;
        }
        .txtBox
        {
            width: 100px;
        }
        .ObjEditBox
        {
            top: -140px;
            right: 40px;
            margin-left: 10%;
            position: absolute;
            width: 240px;
            height: 310px;
            border: 2px groove black;
            background-color: #A2A2A2;
            color: white;
            font-size: 16px;
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            z-index: 9989;
            display: none;
        }
        .pop1
        {
            cursor: pointer;
        }
        .txt2
        {
            width: 100px;
        }
        .txtBox2
        {
            width: 100px;
        }
        .per
        {
            direction: ltr;
            text-align: right;
        }
        .loading1
        {
            text-align: center;
            position: fixed;
            width: 170px;
            height: 110px;
            background-color: #264366; /*left: 43%;
    top: 45%;*/
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            font-size: 20px;
            color: White;
            -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
            -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
            box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
            z-index:9990;
        }
    </style>
    <script type="text/javascript">
        function ShowBar1() {

            if ($('#ddMerchandise_left')[0].style.display == "none") {
                $('#ddMerchandise_left')[0].style.display = "block";
                $("#Merchandise_left").css({ left: -400 }).animate({ "left": "0" }, "high");
            }
            else {
                $("#Merchandise_left").css({ left: 0 }).animate({ "left": -400 }, "high");
                setTimeout("DontShowBar();", 400);
            }
        }
        function DontShowBar() {
            $('#ddMerchandise_left')[0].style.display = "none";
        }
    </script>
    <script type="text/javascript">
        var ddlid = '';

        function CloseObjEditBox() {
            $(".ObjEditBox").css({ top: 40 })
                            .animate({ "top": "-600" }, "high");
            $("#dall").unblock();
            $(".ifrtt").unblock();
        }
        function ShowBox() {

        }
        function EditBox() {
            if (ObjSelectedID == "0" || ObjSelectedID == "") {
                alert("אנא בחר שורה");
                return;
            }

            $('#<%= txtMonyGoal.ClientID%>').val(SumSales);

            $(".ObjEditBox").show();
            $(".ObjEditBox").css({ top: top })
                        .animate({ "top": "40px" }, "high");
            $('.ifrtt').block({ message: '' });
            $('#dall').block({ message: '' });
        }         
        
    </script>
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div></div>
    <div style="text-align: right; float: right; overflow-x: auto;" id="dall">
        <asp:UpdatePanel runat="server" ID="upTBL">
            <ContentTemplate>
                <div style="float: right; max-width: 30%;">
                    <div class="dMerchandiseDTBox">
                        <center>
                            <div id="Div1" class="dMerchandiseItemDT">
                                <div>
                                    <div class="dmHead">
                                        מתאריך:
                                    </div>
                                    <div class="dmItem">
                                        <input type="text" id="txtDTFrom" class="dtp txt" />
                                    </div>
                                    <div class="dmHead" style="width: 70px;">
                                        עד תאריך:
                                    </div>
                                    <div class="dmItem">
                                        <input type="text" id="txtDTTo" class="dtp txt" />
                                    </div>
                                </div>
                            </div>
                        </center>
                    </div>
                    <div class="dMerchandise_rightDDLs" style="margin-top: 70px;">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td class="ddlFilter line">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                סוכן
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td style="width: 75%;">
                                                            &nbsp;
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:LinkButton runat="server" ID="lbClearAgent" CssClass="aLink" OnClick="lbClearAgent_Click">נקה</asp:LinkButton>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:LinkButton runat="server" ID="lbClearAll" CssClass="aLink" OnClick="lbClearAll_Click">נקה הכל</asp:LinkButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlAgents" AutoPostBack="true" size="9" OnSelectedIndexChanged="UpdateDDls"
                                        onchange="NavFrame(SelID);" CssClass="ddlFilterItem">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="dMerchandise_rightDDLs">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td class="ddlFilter line">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                לקוח
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <asp:LinkButton runat="server" ID="lbClearCustomer" CssClass="aLink" OnClick="lbClearCustomer_Click">נקה</asp:LinkButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlCustomer" AutoPostBack="true" size="9" OnSelectedIndexChanged="UpdateDDls"
                                        onchange="NavFrame(SelID);" CssClass="ddlFilterItem">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="dMerchandise_rightDDLs">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td class="ddlFilter line">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                קטגורייה
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <asp:LinkButton runat="server" ID="lbClearCategory" CssClass="aLink" OnClick="lbClearCategory_Click">נקה</asp:LinkButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlCategory" AutoPostBack="true" size="9" OnSelectedIndexChanged="UpdateDDls"
                                        onchange="NavFrame(SelID);" CssClass="ddlFilterItem">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="dMerchandise_rightDDLs">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td class="ddlFilter line">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                פריט
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <asp:LinkButton runat="server" ID="lbClearItem" CssClass="aLink" OnClick="lbClearItem_Click">נקה</asp:LinkButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlItem" AutoPostBack="true" size="9" OnSelectedIndexChanged="UpdateDDls"
                                        onchange="NavFrame(SelID);" CssClass="ddlFilterItem">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div class="Merchandise_right" style="width: 47%;">
            <center>
                <div class="dMerchandiseBox">
                    <center>
                        <div id="dItems" class="dMerchandiseItem" onclick="NavFrame(4);">
                            <div class="dMerchandiseItemText">
                                פריטים
                            </div>
                        </div>
                        <div id="dCategories" class="dMerchandiseItem" onclick="NavFrame(3);">
                            <div class="dMerchandiseItemText">
                                קטגוריות
                            </div>
                        </div>
                        <div id="dCustomers" class="dMerchandiseItem" onclick="NavFrame(2);">
                            <div class="dMerchandiseItemText">
                                לקוחות
                            </div>
                        </div>
                        <div id="dAgents" class="dMerchandiseItem Selected" onclick="NavFrame(1);">
                            <div class="dMerchandiseItemText">
                                סוכנים
                            </div>
                        </div>
                    </center>
                </div>
            </center>
            <div class="ifrtt">
                <!--mifr--->
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="vertical-align: top;">
                            <iframe class="mmifr" style="" frameborder="0" scrolling="no"></iframe>
                        </td>
                        <td style="">
                            &nbsp;&nbsp;&nbsp;
                        </td>
                        <td style="vertical-align: top;">
                            <iframe class="mmifrGoals" style="height: 100%;" frameborder="0" scrolling="no">
                            </iframe>
                        </td>
                    </tr>
                </table>
                <br />
                <input type="button" id="btnOpenGoalsBox" value="קבע יעד" class="MSBtnGeneral" style="background-image: url('../../Img/edit.png');
                    width: 100px;" onclick="EditBox();" />
            </div>
            <div>
            </div>
        </div>
        <div class="openLeftBar">
            <%--<a href="javascript:ShowBar1();" style="color: #264366 !important;">הצג גרף</a>--%>
            &nbsp; &nbsp;
            <!--<img alt="bar" src="../../img/leftArrow.png" onclick="ShowBar1();" />--->
        </div>
        <div id="ddMerchandise_left" style="display: none;">
            <br />
            <br />
            <div class="" id="Merchandise_left" style="position: fixed; left: 0px; width: 470px;
                background-color: #E2E3E4; border: 1px solid #264366; overflow-y: auto; height: 830px;">
                <div>
                    <%--<iframe id="barifr" class="barifr" frameborder="0" scrolling="no" style="width: 100%">
                    </iframe>--%>
                </div>
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
    <div id="ObjEditBox" class="ObjEditBox">
        <div class="JumpWiX" style="padding-right: 3px; padding-top: 2px;">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseObjEditBox();" />
        </div>
        <div style="padding-top: 3px; background-color: #244062; height: 25px;">
            <center>
                <div id="sHeadEdit">
                    קביעת יעד
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="4" cellspacing="2" width="230px">
            <tr>
                <td>
                    מתאריך:
                </td>
                <td>
                    <input runat="server" type="text" id="txtFromDate" class="dtp2 txt2 fromDate" />
                </td>
            </tr>
            <tr>
                <td>
                    עד תאריך
                </td>
                <td>
                    <input runat="server" type="text" id="txtToDate" class="dtp2 txt2 toDate" />
                </td>
            </tr>
            <tr>
                <td>
                    אחוז גידול רצוי
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtPercents" CssClass="txtBox2 per" onblur="SetGoalMony(this.value);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    או הזן יעד כספי
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtMonyGoal" CssClass="txtBox2" onblur="SetGoalPercents(this.value);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    החל על אוכלוסיות המשנה
                </td>
                <td>
                    <asp:CheckBox runat="server" ID="cbSetOnChildrens" />
                </td>
            </tr>
        </table>
        <div>
            <br />
            <input type="button" id="btnSave" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/save.png');
                width: 80px; margin-right: 85px" onclick="SaveGoal();" />
        </div>
    </div>
    <div id="dLoading" class="loading1" style="display:none;">
        <br />
        <img alt="...טוען" src="../../img/loading1.gif" width="50px;" />
        <br />
        שומר יעדים...
    </div>
    <script type="text/javascript">
     $("#dLoading").css("left",$(window).width()/2+"px");
     function CloseLoading() {
                var top = ((20 / 100) * $(document).height());
                $("#dLoading").css({ top: $("#dLoading").css("top") })
                    .animate({ "top": "-700" }, "high");

                $("#dLoading").css("display","none");
                $("#dall").unblock();
                $('.ifrtt').unblock();
                $('.ObjEditBox').unblock();
            
        }
        function ShowLoading() {
            $("#dLoading").css("display", "block");
            //$("#dLoading").css("left", ($(document).width() - 280) / 2 + 100);
            var top = ((20/100) * $(document).height());
            $("#dLoading").css({ top: $("#dLoading").css("top") })
                    .animate({ "top": top }, "high");

           $('#dall').block({ message: '' });
           $('.ifrtt').block({ message: '' });
           $('.ObjEditBox').block({ message: '' });
        }

    //$('#Merchandise_left').css("display","none");
        
            function CloseWinJump(id) {
                var top = currentMousePos.y;
                $("#divJumpGridWin").css({ top: top })
                    .animate({ "top": "-600" }, "high");
                $("#dBody").unblock();
            }
            var currentMousePos = { x: -1, y: -1 };
            var CurY = 0;
            function setParentY(pageY) {
                currentMousePos.y = $(document).scrollTop() + 70.0;
            }
            function SetEditWinJump(GridName, JumpWinHead, GridParameters) {

                try {
                    $("#divJumpGridWin").css("display", "block");
                    var top = 1000;
                    $("#divJumpGridWin").css({ top: top })
                        .animate({ "top": currentMousePos.y + "px" }, "high");

                    $('#dBody').block({ message: '' });
                    $('.EditWinJump').html("<iframe id ='ifrJumper' style='height:" + ($('.EditWinJump')[0].parentElement.clientHeight * 1.0 - 27.0) + "px" + "' class='ifr' src='GridViewNew.aspx?GridName=" + GridName + "&GridParameters=Date:20140205;AgentID:0&ID=220&iDate=20140226&AgentID=0&ID=220'></iframe>");
                    $('.JumpWinHead').text(JumpWinHead);
                }
                catch (e)
                { }
            }

            var SelID = 0;
            function NavFrame(id) {
                $("#dAgents")[0].className = "dMerchandiseItem";
                $("#dCustomers")[0].className = "dMerchandiseItem";
                $("#dCategories")[0].className = "dMerchandiseItem";
                $("#dItems")[0].className = "dMerchandiseItem";
                SelID = id;
                switch (id) {
                    case 1: //סוכנים
                    //alert($(".mmifr")[0].src);
                   // window.status = $(".mmifr")[0].src;
                        $(".mmifr")[0].src = "obj/GridViewNew.aspx?GridName=GridDailySGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + "0" + ";FamilyId:" + "0" + ";ItemID:" + "0"  + ";ObjTypeID:"+id;
                        
                        //$("#barifr")[0].src = "obj/HBarView.aspx?MethodName=GetRGHBarData&WinWidth="+$(window).width()+"&GraphID=15&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        //";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dAgents")[0].className = "dMerchandiseItem Selected";
                        break;
                    case 2: //לקוחות
                         $(".mmifr")[0].src = "obj/GridViewNew.aspx?GridName=GridDailyCustomersGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + "0" + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + "0" + ";ItemID:" + "0"  + ";ObjTypeID:"+id;
                        
                        //$("#barifr")[0].src = "obj/HBarView.aspx?MethodName=GetRGHBarData&WinWidth="+$(window).width()+"&GraphID=16&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        //";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dCustomers")[0].className = "dMerchandiseItem Selected";
                        break;
                    case 3: //קטגוריות                        
                        $(".mmifr")[0].src = "obj/GridViewNew.aspx?GridName=GridSalesCategoriesGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + "0" + ";Cust_Key:0" + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + "0"  + ";ObjTypeID:"+id;                   

                        //$("#barifr")[0].src = "obj/HBarView.aspx?MethodName=GetRGHBarData&WinWidth="+$(window).width()+"&GraphID=18&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        //";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dCategories")[0].className = "dMerchandiseItem Selected";
                        break;
                    case 4: //פריטים
                        $(".mmifr")[0].src = "obj/GridViewNew.aspx?GridName=GrisRepItemsSalesGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                         $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + "0" + ";Cust_Key:0" + ";FamilyId:" + "0" + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val() + ";ObjTypeID:"+id;                        

                        //$("#barifr")[0].src = "obj/HBarView.aspx?MethodName=GetRGHBarData&WinWidth="+$(window).width()+"&GraphID=17&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        //";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dItems")[0].className = "dMerchandiseItem Selected";
                        break;
                }

            }

            function getDateAsNumber(dt) {
                var arr = dt.split('/');
                return arr[2] + '' + arr[1] + '' + arr[0]
            }
            function pageLoad() {
                $(".dtp").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy',
                    onSelect: function(date) {
                        NavFrame(SelID);
                    },
                });

                $(".dtp2").datepicker({
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


                $('#txtDTFrom').val("16/04/2015");
                $('#txtDTTo').val("16/04/2015");

                //setTimeout('SetSelectedBGColor();',3500);
            }
            pageLoad();

            try
            {
                parent.SetIFRH('<%=strID %>');
                //parent.SetIFRH('barifr');
                //$(document).scrollTop($(document).height()/2.0);
            }
            catch(e)
            {
            }

            function SetIFRH(h)
         {//debugger;
             try
             {
//                if(h!='' && h*1.0>0)// 28/5/15
//                    $('.barifr').height(h*1.0+50);
            }
            catch(e)
            {
            }
         }

         function onGridLoad(width,height)
         {
            $('.mmifr').height(height +"px");
            $('.mmifrGoals').height(height +"px");
         }

         var ObjSelectedID = "0";
         var SumSales = 0;
         function SetGridRowClick(row)
         {
            switch(SelID)
            {
                case 1:
                    ObjSelectedID = row["AgentId"];
                    SumSales = row["SumSales"];
                    
                     $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + (row["AgentId"]*1.0).toString() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val()   + ";ObjTypeID:"+SelID; 
                        
                break;

               case 2://customers
                ObjSelectedID = row["Cust_Key"];
                SumSales = row["SumSales"];

                $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + (row["Cust_Key"]*1.0).toString()  + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val()   + ";ObjTypeID:"+SelID; 
                        
               break;

               case 3://categories
                ObjSelectedID = row["FamilyId"];
                SumSales = row["SumSales"];
                
                $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + (row["FamilyId"]*1.0).toString() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val()   + ";ObjTypeID:"+SelID; 
                     
               break;

               case 4://items
                 ObjSelectedID = row["ItemID"];
                SumSales = row["SumSales"];

                $(".mmifrGoals")[0].src = "obj/GridViewNew.aspx?GridName=GridGoals&WinWidth="+$(window).width()+"&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" +  $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:"+$('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + (row["ItemID"]*1.0).toString()  + ";ObjTypeID:"+SelID; 

               break;
                
            }
            if(!ObjSelectedID)
            {
                ObjSelectedID="0";
                SumSales=0;
            }
         }

         function SetGoalPercents(goalSum)
         {
            $('#<%= txtPercents.ClientID%>').val(formatMoney(goalSum*100/SumSales.replace(",","")-100,2)  + "%");
         }
          function SetGoalMony(txt)
         {
            $('#<%= txtMonyGoal.ClientID%>').val(formatMoney((txt.replace("%","")*1.0  +100.0 *1.0) * SumSales.replace(",","")/100,2));
         }
         function SaveGoal()
         {
            if($('.fromDate').val()=="")
            {
                alert("אנא בחר תאריך בשדה מתאריך");
                return;
            }
            else if($('.toDate').val()=="")
            {
                alert("אנא בחר תאריך בשדה עד תאריך");
                return;
            }
            else if($('#<%= txtPercents.ClientID%>').val()=="")
            {
                alert("אנא הזן יעד");
                return;
            }
            var isToSetChildrens="0";
            if($('#<%=cbSetOnChildrens.ClientID %>')[0].checked)
               isToSetChildrens="1";
               
            ShowLoading();
            var AgentID=$('#<%=ddlAgents.ClientID %>').val();
            var Cust_Key=$('#<%=ddlCustomer.ClientID %>').val();
            var SubCode=$('#<%=ddlCategory.ClientID %>').val();
            var ItemID=$('#<%=ddlItem.ClientID %>').val();

            switch(SelID)
            {
                case 1:
                    AgentID = ObjSelectedID;
                break;
                case 2:
                    Cust_Key = ObjSelectedID;
                break;
                case 3:
                    SubCode = ObjSelectedID;
                break;
                case 4:
                    ItemID = ObjSelectedID;
                break;
            }

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetGoalByDates&ObjTypeID=" + SelID + "&AgentID="+ AgentID + "&Cust_Key="+ Cust_Key + "&SubCode="+ SubCode + "&ItemID="+ ItemID + "&FromDate="+ $('#<%=txtFromDate.ClientID %>').val()
                + "&ToDate="+ $('#<%=txtToDate.ClientID %>').val() +  "&Goal="+ $('#<%=txtMonyGoal.ClientID %>').val().replace(",","")+  "&GoalPercents="+ $('#<%=txtPercents.ClientID %>').val().replace(",","")                
                + "&isToSetChildrens="+isToSetChildrens
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ""
            });
            request.done(function (response, textStatus, jqXHR) {
                 CloseObjEditBox();

                 $(".mmifrGoals")[0].src = $(".mmifrGoals")[0].src;

                 CloseLoading();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")                    
                    {
                        CloseObjEditBox();

                        $(".mmifrGoals")[0].src = $(".mmifrGoals")[0].src;

                        CloseLoading();
                    }
                    else
                    {
                        alert("אראה שגיאה בשמירת הנתונים - " + jqXHR.responseText);

                        CloseLoading();
                    }
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים, "+ jqXHR.responseText);

                    CloseLoading();
                    //alert("Error");
                }
            });
          
         }

        NavFrame(1);
        $('.mmifr').width("420px");
        $('.mmifrGoals').width("420px");
        $('.mmifr').height("510px");
        $('.mmifrGoals').height("510px");

           
        $('.Merchandise_left').css("overflow-y","auto");

        $('.ObjEditBox').css("right",$(document).width()/2-200+"px");

    </script>
    </form>
</body>
</html>
