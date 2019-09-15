<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowKeyValueReport.aspx.cs" Inherits="Pages_RPT_ShowKeyValueReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" id="HeadB">
    <title></title>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" />
    <script type="text/javascript" src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/main.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/json2.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery.jqGridWithSearch.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" type="text/css" />
    <link href="~/css/ui.jqgrid.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" />

    <script type="text/javascript">
        function styler() {
            var lang = '<%= Lang %>';
            var href;
            switch (lang) {
                case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        }
        styler();
    </script>
    <link rel="stylesheet" href="../../css/Report.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" />
    <script type="text/javascript" src="../../js/tableEdit.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <style type="text/css">
   
    </style>
    <script type="text/javascript">
    </script>
    <style type="text/css" runat="server" id="stMain">
        @keyframes blinker {
            50% {
                opacity: 0;
            }
        }

        .KVImg {
            cursor: pointer;
        }

        .BacjkBtn {
            position: absolute;
            bottom: 30px;
            left: 49%;
            width: 80px;
            height:30px;
            -webkit-box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            background-clip: padding-box;
        }
    </style>

</head>
<body id="dBodyr" onload="try{setTimeout('try{parent.CloseLoading();}catch(e){}',10);}catch(e){}" style="background-color: white; overflow-x: hidden;" onclick="try{parent.CheckSession();}catch(e){}">
    <form id="form1" runat="server">
        <div id="dPage" runat="server">
        </div>
        <div id="dImg" runat="server" style="display: none;">
            <img alt="Big" id="imgBig" src="" style="display: none;" />
            <input type="button" id="btnClose" value="<<<" onclick="CloseBigImg();" class="BacjkBtn" />
        </div>
        <%--<div class="ReportKeyValueKey">
    gilgo
    </div>--%>
        <div style="display: none;">
            <asp:Button runat="server" ID="btnDownload" OnClick="DownloadFile" />
            <asp:HiddenField runat="server" ID="hdnGridStylesByDB" />
            <asp:HiddenField runat="server" ID="hdnFileName" />
        </div>
    </form>
    <script type="text/javascript">
        function openDoc(val) {
            $('#<%=hdnFileName.ClientID %>').val(val);
            $('#<%=btnDownload.ClientID %>')[0].click();

        }
        function ShowBigImg(id) {
            $('#imgBig').css("max-width", $(window).width());
            $('#dImg').show();
            $('#<%=dPage.ClientID%>').hide("slow");

            $('#imgBig')[0].src = $('#' + id)[0].src;
            $('#imgBig').width($('#' + id)[0].naturalWidth);
            $('#imgBig').show();

            $('#<%=dImg.ClientID%>').show("slow");
        }
        function CloseBigImg() {
            $('#dImg').hide("slow");
            $('#<%=dImg.ClientID%>').hide();
            $('#<%=dPage.ClientID%>').show("slow");
        }
    </script>
</body>
</html>
