<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesMerchandiseWidjet.aspx.cs"
    Inherits="Pages_Usr_Widgets_SalesMerchandiseWidjet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../../js/Main.js" type="text/javascript"></script>
    <script src="../../../js/json2.js" type="text/javascript"></script>
    <link rel="stylesheet" href="~/css/jquery-ui.css">
    <script src="../../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        select option:checked
        {
            background-color: #FD9100;
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
                setTimeout("DontShowBar();",400);
            }
        }
        function DontShowBar() {
            $('#ddMerchandise_left')[0].style.display = "none";
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
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
                                                <%=StrSrc("Agent")%>
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td style="width: 75%;">
                                                            &nbsp;
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:LinkButton runat="server" ID="lbClearAgent" CssClass="aLink" OnClick="lbClearAgent_Click"><%=StrSrc("Clear")%></asp:LinkButton>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:LinkButton runat="server" ID="lbClearAll" CssClass="aLink" OnClick="lbClearAll_Click"><%=StrSrc("ClearAll")%></asp:LinkButton>
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
                                                <%=StrSrc("Customer")%>
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <asp:LinkButton runat="server" ID="lbClearCustomer" CssClass="aLink" OnClick="lbClearCustomer_Click"><%=StrSrc("Clear")%></asp:LinkButton>
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
                                                <%=StrSrc("Category")%>
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <asp:LinkButton runat="server" ID="lbClearCategory" CssClass="aLink" OnClick="lbClearCategory_Click"><%=StrSrc("Clear")%></asp:LinkButton>
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
                                                <%=StrSrc("Item")%>
                                            </td>
                                            <td style="width: 90%; text-align: left;">
                                                <asp:LinkButton runat="server" ID="lbClearItem" CssClass="aLink" OnClick="lbClearItem_Click"><%=StrSrc("Clear")%></asp:LinkButton>
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
                                <%=StrSrc("Items")%>
                            </div>
                        </div>
                        <div id="dCategories" class="dMerchandiseItem" onclick="NavFrame(3);">
                            <div class="dMerchandiseItemText">
                                <%=StrSrc("Categories")%>
                            </div>
                        </div>
                        <div id="dCustomers" class="dMerchandiseItem" onclick="NavFrame(2);">
                            <div class="dMerchandiseItemText">
                                <%=StrSrc("Customers")%>
                            </div>
                        </div>
                        <div id="dAgents" class="dMerchandiseItem Selected" onclick="NavFrame(1);">
                            <div class="dMerchandiseItemText">
                                <%=StrSrc("Agents")%>
                            </div>
                        </div>
                    </center>
                </div>
            </center>
            <div class="">
                <!--mifr--->
                <iframe class="mmifr" style="" frameborder="0" scrolling="no"></iframe>
            </div>
        </div>
        <div class="openLeftBar">
            <img alt="bar" src="../../../Img/leftArrow.png" onclick="ShowBar1();" />
        </div>
        
        <div id="ddMerchandise_left" style="display:none;">
        <br />
        <br />
            <div class="" id="Merchandise_left" style="position:fixed;left:0px;width:470px;background-color:#E2E3E4;border:1px solid #888A83;overflow-y:auto;height:830px;">
                <div>
                    <iframe id="barifr" class="barifr" frameborder="0" scrolling="no" style="width: 100%">
                    </iframe>
                </div>
            </div>
        </div>
    </div>
    <div>
        <center>
            <div id="divJumpGridWin" class="EditWinBoxJumpGrid">
                <div class="JumpWiX">
                    <img alt="סגור" src="../../../img/X.png" class="imngX" onclick="CloseWinJump();" />
                </div>
                <div class="JumpWinHead">
                </div>
                <div class="EditWinJump">
                </div>
            </div>
        </center>
    </div>
    <script type="text/javascript">
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
                        $(".mmifr")[0].src = "../GridViewNew.aspx?GridName=GridDailyS&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#barifr")[0].src = "../../Graphs/HBarView.aspx?MethodName=GetRGHBarData&GraphID=15&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dAgents")[0].className = "dMerchandiseItem Selected";
                        break;
                    case 2: //לקוחות
                        $(".mmifr")[0].src = "../GridViewNew.aspx?GridName=GridDailyCustomers&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#barifr")[0].src = "../../Graphs/HBarView.aspx?MethodName=GetRGHBarData&GraphID=16&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dCustomers")[0].className = "dMerchandiseItem Selected";
                        break;
                    case 3: //קטגוריות                        
                        $(".mmifr")[0].src = "../GridViewNew.aspx?GridName=GridSalesCategories&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#barifr")[0].src = "../../Graphs/HBarView.aspx?MethodName=GetRGHBarData&GraphID=18&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#dCategories")[0].className = "dMerchandiseItem Selected";
                        break;
                    case 4: //פריטים
                        $(".mmifr")[0].src = "../GridViewNew.aspx?GridName=GrisRepItemsSales&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

                        $("#barifr")[0].src = "../../Graphs/HBarView.aspx?MethodName=GetRGHBarData&GraphID=17&GridParameters=StartDate:" + getDateAsNumber($('#txtDTFrom').val()) + ";EndDate:" + getDateAsNumber($('#txtDTTo').val()) +
                        ";AgentID:" + $('#<%=ddlAgents.ClientID %>').val() + ";Cust_Key:" + $('#<%=ddlCustomer.ClientID %>').val() + ";FamilyId:" + $('#<%=ddlCategory.ClientID %>').val() + ";ItemID:" + $('#<%=ddlItem.ClientID %>').val();

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

                var d = new Date();

                var month = d.getMonth() + 1;
                var day = d.getDate();

                var output = (day < 10 ? '0' : '') + day + '/' +
                    (month < 10 ? '0' : '') + month + '/' +
                    d.getFullYear();


                $('#txtDTFrom').val("27/11/2014");
                $('#txtDTTo').val("27/11/2014");

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
                //$("#ifr" + ui.element.context.id).css("height",$("#" + ui.element.context.id).css("height").replace("px", ""))
                if(h!='' && h*1.0>0)
                    $('.barifr').height(h*1.0+50);
            }
            catch(e)
            {
            }
         }
            //$('#nMerchandise').attr("class", "menuLink Selected");
            NavFrame(1);
           // setTimeout('SetFotter();', 20);
            $('.mmifr').width($(document).width().toString().replace("px","") * 1.0 * 47 /100);
            $('.mmifr').height(($(document).height().toLocaleString().replace("px","") * 1.0 -100)+"px");
            
            //$('.Merchandise_left').height($(document).height().replace("px","") * 1.0 - 200.0);
            //$('.Merchandise_left').width(($(document).width().toLocaleString().replace("px","") * 1.0 * 70/100) + "px");
            $('.Merchandise_left').css("overflow-y","auto");
    </script>
    </form>
</body>
</html>
