﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowGrafClock.aspx.cs" Inherits="Pages_RPT_ShowGrafClock" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>גרף שעון</title>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script src="../../js/RGraph.common.core.js"></script>
    <script src="../../js/RGraph.common.dynamic.js"></script>
    <script src="../../js/RGraph.meter.js"></script>
    <link rel="stylesheet" href="../../css/Main.css" type="text/css" media="screen" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
</head>
<body class="bodyGraf1" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <center>
        <div class="bodyGraf2">
            <div class="graf_caption">
                <div class="dCaption" style="margin-top: 3px;">
                    <%=Caption%>
                </div>
            </div>
            <div style="padding-bottom: 60px;">
                <canvas id="cvs" width="<%=Width %>" height="<%=Height %>">[No canvas support]</canvas>
            </div>
        </div>
    </center>
    </form>
    <script type="text/javascript">

        function setGraph(min, max, value) {

            var meter = new RGraph.Meter('cvs', min, max, value)
                .set('units.post', 'k')
                .set('red.start', min)
                .set('red.end', min + 25 / 100 * max)
                .set('yellow.start', min + 25 / 100 * max)
                .set('yellow.end', min + 65 / 100 * max)
                .set('green.start', min + 65 / 100 * max)
                .set('green.end', max)
                .draw();

        }


        try {
            $(document).scrollTop($(document).height() / 2.0);
        }
        catch (e) {
        }

        function ReloadPage() {
            window.location.href = window.location.href;
        }
        setTimeout('ReloadPage();', 5 * 60 * 1000);
    </script>
</body>
</html>
