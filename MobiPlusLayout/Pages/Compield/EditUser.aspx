<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditUser.aspx.cs" Inherits="Pages_Compield_EditUser" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>עריכת משתמש</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
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
    <script src="../../js/tree/jquery.tree.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <style type="text/css">
       
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <div>
            <div class="close cclose" onclick="CloseEditBoxPopup();">
                x
            </div>
            <div class="header_user">
                <%=StrSrc("UpdateUser") %>
            </div>
            <div align="center">
                <table>
                    <tr>
                        <td class="headData">#
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtNum" class="txtU userInput" readonly="readonly" />
                        </td>
                        <td>
                            <a href="javascript:Save(1);"><%=StrSrc("Delete") %></a>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("User") %>
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtUserName" class="txtU userInput" />
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Role") %>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlRoles" class="ddlU userInput"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Country") %>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCountries" class="ddlU userInput"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("MCenter") %>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlDistributionCenter" class="ddlU userInput"></asp:DropDownList>
                        </td>
                    </tr>

                    <tr>
                        <td class="headData"><%=StrSrc("Manager") %>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlManagers" class="ddlU userInput"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Name") %>
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtName" class="txtU userInput" />
                        </td>
                    </tr>

                    <tr>
                        <td class="headData"><%=StrSrc("Password") %>
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtPass" class="txtU userInput" />
                        </td>
                    </tr>
                    <tr>
                        <td class="headData vat"><%=StrSrc("Lang") %>
                        </td>
                        <td class="vat">
                            <asp:UpdatePanel runat="server" ID="upPr">
                                <ContentTemplate>
                                    <table>
                                        <tr>
                                            <td class="vat bor">
                                                <asp:DropDownList runat="server" ID="ddlLanguage" class="ddlUHaf userInputHaf" size="10" AutoPostBack="true" OnSelectedIndexChanged="ddlLanguage_SelectedIndexChanged" onchange="setCB();"></asp:DropDownList></td>
                                            <td class="vat bor">
                                                <asp:DropDownList runat="server" ID="ddlProfile" class="ddlUHaf userInput" onchange="setPrArrServer();"></asp:DropDownList>
                                                <br />
                                                <asp:CheckBox runat="server" ID="cbDef" Checked="false" Text="" onchange="setPrArr();"/>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                        </td>

                    </tr>

                    <tr>
                        <td colspan="2" align="left">
                            <input type="button" id="btnSave" onclick="Save(0);" value="<%=StrSrc("Save") %>" class="btnSave" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:HiddenField runat="server" ID="hdnUserID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnLanguageID" Value="0" />
    </form>
    <script type="text/javascript">

        parent.document.getElementById("MainObj").style.height = "500px";
        parent.document.getElementById("MainObj").style.width = "500px";
        function CloseEditBoxPopup() {
            parent.CloseEditBox();
        }
        function Save(IsToDelete) {
            //debugger;
            if (IsToDelete) {
                if (!confirm("<%=StrSrc("Confirm") %> " + $('#<%=txtName.ClientID%>').val() + "?"))
                    return;
            }

            var prStr = "";
            for (var key in arrPr) {
                prStr += key + ":" + arrPr[key] + ";";
            }
            alert(prStr);

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SeUserData&UserID=" + $('#<%=hdnUserID.ClientID%>').val() + "&UserName=" + $('#<%=txtUserName.ClientID%>').val()
                     + "&Name=" + $('#<%=txtName.ClientID%>').val() + "&Password=" + $('#<%=txtPass.ClientID%>').val() + "&UserCode=" + $('#<%=txtUserName.ClientID%>').val()
                    + "&UserRoleID=" + $('#<%=ddlRoles.ClientID%>').val() + "&CountryID=" + $('#<%=ddlCountries.ClientID%>').val() + "&DistributionCenterID=" + $('#<%=ddlDistributionCenter.ClientID%>').val()
                    + "&ManagerUserID=" + $('#<%=ddlManagers.ClientID%>').val() + "&prStr=" + prStr + "&IsToDelete=" + IsToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: '',
            });
            request.done(function (response, textStatus, jqXHR) {


            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText=="True")
                        CloseEditBoxPopup();
                    else 
                        alert(jqXHR.responseText);
                }
                else {
                    alert(jqXHR.responseText);
                }
            });
        }
        var arrPr = {};

        function setPrArr() {

            var key = $('#<%=ddlLanguage.ClientID%>').val();
            var val = $('#<%=ddlProfile.ClientID%>').val();

            for (var key1 in arrPr) {
                if (!($('#<%=cbDef.ClientID%>')[0].checked))
                    arrPr[key1] = arrPr[key1].toString().split('^').join();
            }

            arrPr[key] = val;
            if($('#<%=cbDef.ClientID%>')[0].checked)
                arrPr[key] = val+"^";
        }
         function setPrArrServer() {

            var key = $('#<%=ddlLanguage.ClientID%>').val();
            var val = $('#<%=ddlProfile.ClientID%>').val();

            arrPr[key] = val;
            if($('#<%=cbDef.ClientID%>')[0].checked)
                arrPr[key] = val+"^";
        }
        function setCB()
        {
            $('#<%=cbDef.ClientID%>')[0].checked = false;
        }
        
    </script>
</body>
</html>
