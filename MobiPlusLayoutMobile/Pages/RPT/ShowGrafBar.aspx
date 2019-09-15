﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowGrafBar.aspx.cs" Inherits="Pages_RPT_ShowGrafBar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../js/Main.js"></script>
    <script type="text/javascript" src="../../js/RGraph.pie.js"></script>
    <script type="text/javascript" src="../../js/RGraph.bar.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.core.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.dynamic.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.tooltips.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.effects.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.key.js"></script>
    <script type="text/javascript" src="../../js/RGraph.drawing.rect.js"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link rel="stylesheet" href="../../css/Main.css" type="text/css" media="screen" />
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <center>
        <div class="bodyGraf2">
            <div class="graf_caption">
                <div class="dCaption" style="margin-top: 3px;">
                </div>
            </div>
            <br />
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
        var Colors = ['Gradient(#8674BA:#4D3594:#4D3594:#4D3594:#4D3594)', 'Gradient(#EF9643:#E76400:#E76400:#E76400:#E76400)'];
        var maxScale = "";

        eval('<%=GrafData %>');
        $('.dCaption').text(Caption);
        
        function setGraph(data, labels) {
           // data = [[4, 8], [5, 7], [1, 7], [6, 3], [3, 7]];
            //debugger;

           
            var bar = new RGraph.Bar('cvs', data)
                .set('gutter.left', 75)
                .set('gutter.bottom', 65)
            //.set('linewidth', 2)

                .set('hmargin', 10)

                .set('labels', labels)//['ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי'])
                .set('colors', Colors)
            //.set('text.angle', 45)

                .set('labels.above', true)
                .set('labels.bottom', 65)
            //.set('units.post', '%')


                .set('title', Title)
                .set('key', Title)
                .set('key.interactive', true)
                .set('key.colors', Colors)
                .set('key.rounded', false)
                .set('key.halign', 'left')
            bar.draw()// RGraph.ISOLD ? bar.draw() : bar.wave({ frames: 20 })
        }
        setGraph(data, labels);

        function ReloadPage() {
            window.location.href = window.location.href;
        }
        setTimeout('ReloadPage();', 5 * 60 * 1000);
    </script>
</body>
</html>
