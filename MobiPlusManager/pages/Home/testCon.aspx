<%@ Page Title="MobiPlus Manager - בקשות להרשאות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="testCon.aspx.cs" Inherits="pages_TestCon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function closeWin(id) {
            var top = 100;
            $("#" + id).css({ top: top })
                    .animate({ "top": "-500" }, "slow");

        }
        function formatCell(cellValue, options, rowdata, action) {
            return unescape("\"" + cellValue + "\"");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="dFrames">

    </div>
    <script type="text/javascript">
        for (var i = 0; i < 30; i++) {
            $('#dFrames')[0].innerHTML += "<iframe src='1.aspx' />";
        }
        alert($('#dFrames')[0].innerHTML);
    </script>
</asp:Content>

