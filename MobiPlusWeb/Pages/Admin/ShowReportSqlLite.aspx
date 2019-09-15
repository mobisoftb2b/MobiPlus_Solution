<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowReportSqlLite.aspx.cs"
    Inherits="Pages_Admin_ShowReportSqlLite" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>הצגת דוחות</title>
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
    <script type="text/javascript">
        function closeWin(id) {
            var top = 100;
            $("#" + id).css({ top: top })
                    .animate({ "top": "-500" }, "slow");

        }
        var IsAdd = true;
        var IsAddMD = true;
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="dParams" runat="server" class="ShowWinReportBoxParms">
            <div class="ParamHead">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <span style="display: none;">
                                <asp:Button runat="server" ID="btnSetParamsServer" Text="שמור" OnClick="btnSetParamsServer_Click" />
                                <asp:HiddenField runat="server" ID="hdnParams" />
                            </span>
                            <input type="button" id="btnSetParams" value="הצג" onclick="SetParams();" />
                        </td>
                        <td style="padding-left: 80px;">
                            הזן פרמטרים
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <center>
            <br />
            <div id="dReport" runat="server" style="height:680px;overflow-y:auto;">
            </div>
        </center>
    </div>
    </form>
    <script type="text/javascript">
        function SetParams() {
            //hdnParams
            $('#<%=hdnParams.ClientID %>').val("");
            for (var i = 0; i < 100; i++) {
                if ($('#Param' + i.toString()).length > 0) {
                    $('#<%=hdnParams.ClientID %>').val($('#<%=hdnParams.ClientID %>').val() + "," + $('#Param' + i.toString()).val());
                }
                else {
                    break;
                }
            }
            $('#<%=btnSetParamsServer.ClientID %>').click();
        }
    </script>
</body>
</html>
