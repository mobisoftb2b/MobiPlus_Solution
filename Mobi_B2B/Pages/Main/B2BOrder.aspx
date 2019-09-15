<%@ Page Language="C#" AutoEventWireup="true" CodeFile="B2BOrder.aspx.cs" Inherits="Pages_Main_B2BOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MOBI B2B Order</title>
    <link rel="stylesheet" href="../../css/Main.css" />
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <link rel="SHORTCUT ICON" href="http://www.mobisoft.co.il/images/favicon.png" />
</head>
<body id="dBody">
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="sm1">
    </asp:ScriptManager>
    <div id="MainObj" runat="server" style="display: none;">
        <center>
            <table cellpadding="0" cellspacing="0" class="OrderContainer">
                <tr>
                    <td class="OrderHeaderContainer" style="" colspan="2">
                        <table cellpadding="2" cellspacing="2" width="100%">
                            <tr>
                                <td>
                                    <img alt="Mobi B2B" src="../../img/mobisoft_logo2.png" width="120px" />
                                </td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="white-space: nowrap;" style="text-align: right;">
                                                <table cellpadding="0" cellspacing="0" style="text-align: right;">
                                                    <tr>
                                                        <td>
                                                            <asp:TextBox runat="server" ID="txtSearch" Text="חיפוש" CssClass="txtSearch" onblur="setTimeout('SetTxtSearch();',100);"
                                                                onmousedown="setTimeout('SetTxtSearch();',100);" onkeydown="setTimeout('SetTxtSearch();',100);"></asp:TextBox>
                                                        </td>
                                                        <td class="SearchImg">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <%--<td style="width: 52%;">
                                        </td>--%>
                                <td style="" class="userText">
                                    מכולת אברהם בן שבת<br />
                                    תל אביב
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td class="Sal">
                                    <table cellpadding="0" cellspacing="0" class="tblSal" onclick="ShowSal();">
                                        <tr>
                                            <td>
                                                <img alt="Mobi B2B" src="../../img/shopping-cart-hi.png" width="30px" />
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td style="width: 70px">
                                                <%--style="vertical-align:top;"--%>
                                                צפייה בסל
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="" class="exit">
                                    יציאה
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td id="OrderMenuContainer" class="OrderMenuContainer" runat="server">
                        <asp:UpdatePanel runat="server" ID="upm" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table cellpadding="0" cellspacing="0" class="tblMenu">
                                    <tr>
                                        <td class="HeadItem">
                                            חלב
                                        </td>
                                        <td onclick="HideMenu();" style="cursor: pointer;">
                                            <<
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tdHalav" runat="server">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="HeadItem">
                                            בעד
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tdBead" runat="server">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="HeadItem">
                                            ביצים
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tdMeluchim" runat="server">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td class="dtOrderDataContainer">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Always">
                            <ContentTemplate>
                                <span class="sOpen" style="display: none;" onclick="ShowMenu();">>></span>
                                <div class="InOrderDataContainer" id="InOrderDataContainer" runat="server">
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </center>
    </div>
    <center>
        <div id="divEditWinReportBox" class="EditWinReportBox">
            <div class="EditWinMDX">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="DontShowSal();" />
            </div>
            <div class="EditWinMDHead">
                <span class="bor1">&nbsp;&nbsp;&nbsp;&nbsp;סיכום הזמנה&nbsp;&nbsp;&nbsp;&nbsp; </span>
            </div>
            <div class="EditWinMDMsg">
            </div>
            <div class="EditWinMDTbl">
                <table cellpadding="0" cellspacing="0" width="100%" id="tblSal">
                    <tr>
                        <td style="width: 50%;" class="salHead">
                            פריט
                        </td>
                        <td class="salHead">
                            מחיר
                        </td>
                        <td class="salHead" style="width: 15%;">
                            כמות
                        </td>
                        <td class="salHead" style="width: 35%;" colspan="2">
                            ערך שורה
                        </td>
                    </tr>
                </table>
            </div>
            <div class="dBtns">
                <center>
                    <table cellpadding="2" cellspacing="2">
                        <tr>
                            <td>
                                <input type="button" id="btnCloseWin" value="שלח הזמנה" class="EditWinMD btn" onclick="SendSal();DontShowSal();" />
                            </td>
                        </tr>
                    </table>
                </center>
            </div>
        </div>
    </center>
    <div style="display: none;">
        <asp:UpdatePanel runat="server" ID="upa">
            <ContentTemplate>
                <asp:Button runat="server" ID="btnStart" OnClick="btnStart_Click" />
                <asp:HiddenField runat="server" ID="hdnWidth" />
                <asp:HiddenField runat="server" ID="hdnHeight" />
                <asp:HiddenField runat="server" ID="hdnParams" Value="70-8;" />
                <%--Value="70-27;70-26;"--%>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
    <script type="text/javascript">
        var Sal = [];

        function SetTxtSearch() {
            if ($('#<%= txtSearch.ClientID%>').val().length > 0) {
                if ($('#<%= txtSearch.ClientID%>').val().toString().indexOf("חיפוש") > -1) {
                    $('#<%= txtSearch.ClientID%>').val($('#<%= txtSearch.ClientID%>').val().toString().replace("חיפוש", ""));
                }
            }
            else {
                $('#<%= txtSearch.ClientID%>').val("חיפוש");
            }
        }

        function HideMenu() {
            $('#<%= OrderMenuContainer.ClientID%>').hide();
            $('.tblAll').css("padding-right", "1%");
            $('.sOpen').show();
        }
        function ShowMenu() {
            $('#<%= OrderMenuContainer.ClientID%>').show();
            $('.tblAll').css("padding-right", "0px");
            $('.sOpen').hide();
        }
        function SetPram(Param, isCheck) {
           // alert(Param);
            if ($('#<%= hdnParams.ClientID%>').val().indexOf(Param) == -1 && isCheck) {
                $('#<%= hdnParams.ClientID%>').val($('#<%= hdnParams.ClientID%>').val() + Param);
            }
            else if (!isCheck) {
                $('#<%= hdnParams.ClientID%>').val($('#<%= hdnParams.ClientID%>').val().toString().replace(Param, ""));
            }

            $('#<%=btnStart.ClientID %>')[0].click();
        }
        function Show() {
            $('#MainObj').show();
        }
        var orgHtm = "";
        function ShowSal() {
            $('.EditWinReportBox').css("display", "block");
            var top = -500;
            $(".EditWinReportBox").css({ top: top })
                        .animate({ "top": "50px" }, "slow");

            DisableWin();
            ShowSalItems();

        }
        function ShowSalItems() {

            if (orgHtm == "") {
                orgHtm = $("#tblSal").html();
            }

            $("#tblSal").html(orgHtm);

            var htm = "";
            var sum = 0;
            for (var i = 0; i < Sal.length; i++) {
                var rowArr = Sal[i].toString().split(';');
                htm += "<tr>";
                htm += "<td class='rowSal'>";
                htm += "<table ><tr><td><img alt='Mobi B2B' src='../../img/media/pictures/pictures_large/" + rowArr[0] + ".jpg' class='imgItemNSmall'  onerror=\"if (this.src.indexOf('LogoTnuva.jpg')==-1) {this.src = '../../img/LogoTnuva.jpg'; this.className='imgItemErrSamll';}\"/></td>";
                htm += "<td class='itmText' style='padding-right:5px;'>" + rowArr[0] + " - " + rowArr[1] + "</td></tr></table>";
                htm += "</td>";
                htm += "<td class='rowSal'>";
                htm += "<div class='itmText'>" + rowArr[2] + "</div>";
                htm += "</td>";
                htm += "<td class='rowSal'>";
                htm += "<div class='itmText'>"
                htm += "<img alt='Mobi B2B' src='../../img/plus.png' class='plusimg'  onclick='AddUnitsSum(\"spUnits_" + rowArr[0] + "\");'/>"
                htm += "<span id='spUnits_" + rowArr[0] + "'>" + rowArr[3] + "</span>";
                htm += "<img alt='Mobi B2B' src='../../img/minus.png' class='plusimg'  onclick='RemoveUnitsSum(\"spUnits_" + rowArr[0] + "\");'/>"
                htm += "</div>";
                htm += "</td>";
                htm += "<td class='rowSal'>";
                sum += (1.0 * rowArr[2].replace("₪", "") * rowArr[3]);
                htm += "<div class='itmText'>" + "₪" + formatMoney(1.0 * rowArr[2].replace("₪", "") * rowArr[3], 2) + "</div>";
                htm += "</td>";
                htm += "<td class='rItem itmText rowSal' title='הסר'>";
                htm += "<img alt='הסר' class='removeIcon' src='../../img/remove.png' onclick='delItemFromSal(\"" + rowArr[0] + "\");'/>";
                htm += "</td>";
                htm += "</tr>";
                //tblSal

            }

            htm += "<tr>";
            htm += "<td class='rowSal'>";
            htm += "<div class='itmText bb'>סה''כ</div>";
            htm += "</td>";
            htm += "<td class='rowSal'>";
            htm += "<div class='itmText'>" + "</div>";
            htm += "</td>";
            htm += "<td class='rowSal'>";
            htm += "<div class='itmText'>" + "</div>";
            htm += "</td>";
            htm += "<td class='rowSal'>";
            htm += "<div class='itmText bb'>" + "₪" + formatMoney(sum, 2); +"</div>";
            htm += "</td>";
            htm += "<td class='rItem itmText rowSal'>";
            htm += "&nbsp;";
            htm += "</td>";
            htm += "</tr>";

            $("#tblSal").html($("#tblSal").html() + htm);


        }
        function DontShowSal() {
            $('.EditWinReportBox').css("display", "block");
            var top = 50;
            $(".EditWinReportBox").css({ top: top })
                        .animate({ "top": "-500px" }, "slow");

            $("#dBody").unblock();

        }


        function AddToSal(ItemCode, ItemName, KimPrice, Units) {
            var isExists = false;
            for (var i = 0; i < Sal.length; i++) {
                if (Sal[i].toString().indexOf(ItemCode) > -1) {
                    isExists = true;
                    break;
                }
            }

            if (!isExists) {
                Sal.push(ItemCode + ";" + ItemName + ";" + KimPrice + ";" + Units + ";");

                $("#imgr_" + ItemCode)[0].className = "imgShoppingCartGreen";
            }
        }
        function delItemFromSal(ItemCode) {
            for (var i = 0; i < Sal.length; i++) {
                if (Sal[i].toString().indexOf(ItemCode) > -1) {
                    Sal.splice(i, 1);
                    break;
                }
            }
            ShowSalItems();
        }
        function DisableWin() {
            $('#dBody').block({ message: '' });
        }
        function formatMoney(data, c, d, t) {

            var n = data,
            c = isNaN(c = Math.abs(c)) ? 2 : c,
            d = d == undefined ? "." : d,
            t = t == undefined ? "," : t,
            s = n < 0 ? "-" : "",
            i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
            j = (j = i.length) > 3 ? j % 3 : 0;
            return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
        }
        function SetFieldOnlyNumbers(id) {
            $('#' + id).keypress(function (event) {

                if (event.which != 8 && isNaN(String.fromCharCode(event.which))) {
                    event.preventDefault();
                }
            });
            $('#' + id).bind('input propertychange', function () {
                if (!isNumber($(this).val()))
                    $(this).val("");
            });
        }
        function AddUnits(id) {
            if ($('#txtUnits' + id).val() * 1.0 >= 0)
                $('#txtUnits' + id).val($('#txtUnits' + id).val() * 1.0 + 1.0);
        }
        function DelUnits(id) {
            if ($('#txtUnits' + id).val() * 1.0 > 0)
                $('#txtUnits' + id).val($('#txtUnits' + id).val() * 1.0 - 1.0);
        }
        function AddUnitsSum(id) {
            if ($('#' + id).html() * 1.0 >= 0) {
                $('#' + id).html($('#' + id).html() * 1.0 + 1.0);

                SetSalAfter(id);
            }
        }
        function RemoveUnitsSum(id) {
            if ($('#' + id).html() * 1.0 > 0) {
                $('#' + id).html($('#' + id).html() * 1.0 - 1.0);
                SetSalAfter(id);
            }
        }
        function SetSalAfter(id) {
            for (var i = 0; i < Sal.length; i++) {
                if (Sal[i].toString().indexOf(id.replace("spUnits_", "")) > -1) {
                    var arrDS = Sal[i].toString().split(';');
                    // Sal.splice(i, 1);
                    Sal[i] = arrDS[0] + ";" + arrDS[1] + ";" + arrDS[2] + ";" + $('#' + id).html() + ";";


                    break;
                }
            }

            ShowSalItems();
        }
        function SendSal() {
            //debugger;

            for (var i = 0; i < Sal.length; i++) {
                var arrDS = Sal[i].toString().split(';');
                $("#imgr_" + arrDS[0].toString().replace("[", ""))[0].className = "imgShoppingCart";
            }

            Sal = [];
        }

        $('.OrderContainer').css("min-width", $(window).width() / 1.25 + "px");
        $('.OrderContainer').css("height", $(document).height());
        $('.tblMenu').css("height", $(window).height() - 75);

        $('#<%=hdnHeight.ClientID %>').val($(window).height() - $('.OrderHeaderContainer').height());

        if ($('.InOrderDataContainer').html().toString().length < 40) {
            $('#<%=hdnWidth.ClientID %>').val($(window).width());
            $('#<%=btnStart.ClientID %>')[0].click();
        }
        
    </script>
</body>
</html>
