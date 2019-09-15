<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowGraphHBar.aspx.cs" Inherits="Pages_RPT_ShowGraphHBar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../js/Main.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.pie.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.hbar.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.common.core.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.common.dynamic.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.common.tooltips.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.common.effects.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.common.key.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/RGraph.drawing.rect.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
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
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <center>
            <div class="bodyGraf2">
                <div class="graf_caption">
                    <div class="dCaption" style="margin-top: 3px;">
                    </div>
                </div>
                <canvas id="cvs" width="<%=Width %>" height="<%=Height %>">[No canvas support]</canvas>
            </div>
        </center>
    </form>
    <script type="text/javascript">

        var data = {};
        var labels = {};
        var labels = ''; //= new Object();
        var Caption = "";
        var Title = "";
        var maxScale="10000";
        var Colors = ['Gradient(#4F81BD)', 'Gradient(#FD9100)'];
        eval('<%=GrafData %>');
        $('.dCaption').text(Caption);

        function setGraph(data,labels) {
            //var data = [[4, 8], [5, 7], [1, 7], [6, 3], [3, 7]];
            
            
            
            var hbar = new RGraph.HBar('cvs', data)
           .set('background.grid', false)
           .set('xmax', maxScale)
           .set('scale.decimals', 1)
           .set('colors', Colors)
           .set('colors.sequential', true)
           .set('labels', labels)
                
           .set('gutter.left',130)
           .set('labels.above', true)
           .set('labels.above.decimals', 0)
           .set('noxaxis', true)
           .set('xlabels', false)
           .set('vmargin', 10)
             .set('title', Title)
           .set('key', Title)
           .set('key.interactive', true)
           .set('key.colors', Colors)
           .set('key.rounded', false)
           .set('key.halign', 'left')
           .grow();
                
        }
        setGraph(data, labels);


        function ReloadPage() {
            window.location.href = window.location.href;
        }
        setTimeout('ReloadPage();', 5 * 60 * 1000);
    </script>
</body>
</html>
