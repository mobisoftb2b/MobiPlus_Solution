<%@ Page Title="הגדרות B2B" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="B2BSettings.aspx.cs" Inherits="Pages_Admin_B2BSettings" %>

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="padding-top: 20px; text-align: right; direction: rtl; vertical-align: top;">
        <fieldset class="fieldset2" style=" float: right;">
            <legend>הגדרות B2B</legend>
            <table cellpadding="2" cellspacing="2" style="vertical-align: top;">
                <tr>
                    <td class="b2bSetttings_head">ממשק:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlLayoutType" Width="154px" Height="22px" onchange="GetSettingsData();">
                        </asp:DropDownList>
                    </td>
                </tr>
                  <tr>
                    <td class="b2bSetttings_head">כמות קטגוריות:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlCategoriesGroupsCount" Width="154px" Height="22px">
                            <asp:ListItem Value="4">4</asp:ListItem>
                            <asp:ListItem Value="3">3</asp:ListItem>
                            <asp:ListItem Value="2">2</asp:ListItem>
                            <asp:ListItem Value="1">1</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">מקטע קטגוריות א:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlFrgCat1" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">מקטע קטגוריות ב:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlFrgCat2" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">מקטע קטגוריות ג:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlFrgCat3" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">מקטע קטגוריות ד:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlFrgCat4" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">מקטע פריטים:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlFrgItems" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">דוח קטגוריות:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlCatReport" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">דוח פריטים:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlItemsReport" Width="154px" Height="22px" onchange="SetWidjet();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">מרווח בין מקטעים:
                    </td>
                    <td>
                        <input type="text" id="txtSpace" class="txtSec" />
                        (קטגוריות ופריטים)
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">קטגורית ברירת מחדל:
                    </td>
                    <td>
                        <input type="text" id="txtDefaultCat" class="txtSec" />
                    </td>
                </tr>
               
                 
                <tr>
                    <td class="b2bSetttings_head">פרטי פריט - טופס:
                    </td>
                    <td>
                         <asp:DropDownList runat="server" ID="ddlEditWinForms" Width="154px" Height="22px">
                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr>
                    <td class="b2bSetttings_head">פרטי פריט - אינדקס מוביל:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldID" class="txtSec" />
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">פרטי פריט - שדה מחיר:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldPriceID" class="txtSec" />
                    </td>
                </tr>
                <tr>
                    <td class="b2bSetttings_head">פרטי פריט - שדה שם:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldName" class="txtSec" />
                    </td>
                </tr>
                 <tr>
                    <td class="b2bSetttings_head">פרטי פריט - שדה קטגורית אבא 1:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldProdHierarchy1" class="txtSec" />
                    </td>
                </tr>
                  <tr>
                    <td class="b2bSetttings_head">פרטי פריט - שדה קטגורית אבא 2:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldProdHierarchy2" class="txtSec" />
                    </td>
                </tr>
                  <tr>
                    <td class="b2bSetttings_head">פרטי פריט - שדה קטגורית אבא 3:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldProdHierarchy3" class="txtSec" />
                    </td>
                </tr>
                  <tr>
                    <td class="b2bSetttings_head">פרטי פריט - שדה קטגורית אבא 4:
                    </td>
                    <td>
                         <input type="text" id="txtEditWinFieldProdHierarchy4" class="txtSec" />
                    </td>
                </tr>

                <tr>
                    <td class="b2bSetttings_head">פרופיל משתמש:
                    </td>
                    <td>
                         <asp:DropDownList runat="server" ID="ddlUserProfileID" Width="154px" Height="22px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:left;padding-left:92px;">
                        <input style="" type="button" id="btnSaveFrg" value="שמור" class="EditForm btn" onclick="SetSettingsData('0');" />
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
    <script type="text/javascript">
        var SettingID = "0";
        function SetSettingsData() {
      
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_SetSettingsData&SettingID=" + SettingID + "&LayoutTypeID=" + $('#<%=ddlLayoutType.ClientID%>').val() + "&CategoryFragment=" + $('#<%=ddlFrgCat1.ClientID%>').val() +
                    "&ItemFragment=" + $('#<%=ddlFrgItems.ClientID%>').val() + "&CategoryReportID=" + $('#<%=ddlCatReport.ClientID%>').val() + "&ItemReportID=" + $('#<%=ddlItemsReport.ClientID%>').val() +
                    "&FragmentMarginsPX=" + $('#txtSpace').val() + "&DefaultCategory=" + $('#txtDefaultCat').val()
                    +"&CategoryLevels="+$('#<%=ddlCategoriesGroupsCount.ClientID %>').val()
                    +"&CategoryFragment1="+$('#<%=ddlFrgCat1.ClientID %>').val()
                    +"&CategoryFragment2="+$('#<%=ddlFrgCat2.ClientID %>').val()
                    +"&CategoryFragment3="+$('#<%=ddlFrgCat3.ClientID %>').val()
                    +"&CategoryFragment4="+$('#<%=ddlFrgCat4.ClientID %>').val() 
                    +"&EditWinFormID="+$('#<%=ddlEditWinForms.ClientID %>').val()                    
                    + "&EditWinFieldID=" + $('#txtEditWinFieldID').val()
                    + "&EditWinFieldPriceID=" + $('#txtEditWinFieldPriceID').val()
                    + "&EditWinFieldName=" + $('#txtEditWinFieldName').val()

                    + "&EditWinFieldProdHierarchy1=" + $('#txtEditWinFieldProdHierarchy1').val()
                    + "&EditWinFieldProdHierarchy2=" + $('#txtEditWinFieldProdHierarchy2').val()
                    + "&EditWinFieldProdHierarchy3=" + $('#txtEditWinFieldProdHierarchy3').val()
                    + "&EditWinFieldProdHierarchy4=" + $('#txtEditWinFieldProdHierarchy4').val()

                    + "&UserProfileID=" + $('#<%=ddlUserProfileID.ClientID %>').val()
                    +"&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True") {
                        alert("ההגדרות עודכנו בהצלחה");
                        GetSettingsData();
                    }
                    else
                        alert("אראה שגיאה, " + jqXHR.responseText);
                }
                else {
                    alert("Error");
                }
            });
        }

        function GetSettingsData() {
            $('#txtSpace').val("");
            $('#txtDefaultCat').val("");
            $('#<%=ddlCatReport.ClientID %>').val("0");
            $('#<%=ddlItemsReport.ClientID %>').val("0");
            $('#<%=ddlUserProfileID.ClientID %>').val("-1");

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Frg_GetSettingsData"+ "&LayoutTypeID=" + $('#<%=ddlLayoutType.ClientID%>').val()  + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=ddlLayoutType.ClientID %>').val(response[0].LayoutTypeID);
                $('#<%=ddlCategoriesGroupsCount.ClientID %>').val(response[0].CategoryLevels);
                $('#<%=ddlFrgCat1.ClientID %>').val(response[0].CategoryFragment1);
                $('#<%=ddlFrgCat2.ClientID %>').val(response[0].CategoryFragment2);
                $('#<%=ddlFrgCat3.ClientID %>').val(response[0].CategoryFragment3);
                $('#<%=ddlFrgCat4.ClientID %>').val(response[0].CategoryFragment4);
                $('#<%=ddlUserProfileID.ClientID %>').val(response[0].UserProfileID);                
                $('#<%=ddlFrgItems.ClientID %>').val(response[0].ItemFragment);
                $('#<%=ddlCatReport.ClientID %>').val(response[0].CategoryReportID);
                $('#<%=ddlItemsReport.ClientID %>').val(response[0].ItemReportID);
                $('#txtSpace').val(response[0].FragmentMarginsPX);
                $('#txtDefaultCat').val(response[0].DefaultCategory);
                
                $('#<%=ddlEditWinForms.ClientID %>').val(response[0].EditWinFormID)                
                $('#txtEditWinFieldID').val(response[0].EditWinFieldID)
                $('#txtEditWinFieldPriceID').val(response[0].EditWinFieldPriceID)
                $('#txtEditWinFieldName').val(response[0].EditWinFieldName)

                $('#txtEditWinFieldProdHierarchy1').val(response[0].EditWinFieldProdHierarchy1)
                $('#txtEditWinFieldProdHierarchy2').val(response[0].EditWinFieldProdHierarchy2)
                $('#txtEditWinFieldProdHierarchy3').val(response[0].EditWinFieldProdHierarchy3)
                $('#txtEditWinFieldProdHierarchy4').val(response[0].EditWinFieldProdHierarchy4)
                txtEditWinFieldProdHierarchy4
                
                 

                SettingID = response[0].SettingID;
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {


                }
                else {
                    alert("Error");
                }
            });
        }
        GetSettingsData();
    </script>
</asp:Content>

