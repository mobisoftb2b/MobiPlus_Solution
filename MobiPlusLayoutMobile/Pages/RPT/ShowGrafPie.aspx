<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowGrafPie.aspx.cs" Inherits="Pages_RPT_ShowGrafPie" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>פיי</title>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/RGraph.pie.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.core.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.dynamic.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.tooltips.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.effects.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.key.js"></script>
    <script type="text/javascript" src="../../js/RGraph.drawing.rect.js"></script>
    <script type="text/javascript" src="../../js/Main.js"></script>
    <%--<link rel="stylesheet" href="demos.css" type="text/css" media="screen" />--%>
    <link rel="stylesheet" href="../../css/Main.css" type="text/css" media="screen" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <style type="text/css">
        
    </style>
</head>
<body class="bodyGraf1" onload="setTimeout('parent.CloseLoading();',10);">
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
        var Data;
        var DataNames;
        var Caption = "";
        eval(unescape('<%=GrafData %>'));

        $('.dCaption').text(Caption);

        function SetPie(Data, DataNames) {

            var Colors = ['#FF5050', '#E3E3E3', '#009200', '#5151FF', '#FB9EC6', '#FFFF4F', '#4C4C4C', '#F4B99C', '#ED8E5F', '#9570DE', '#D0D000', '#3939FF', '#F51D1D', '#BDBDFF', '#ED6D00']; //count = 15
            if (Data) {
                var sum = RGraph.array_sum(Data)
                for (var i = 0; i < Data.length; i++) {
                    Data[i] = (Data[i] / sum) * 100;
                }

                var sum = RGraph.array_sum(Data)
                for (var i = 0; i < Data.length; i++) {
                    DataNames[i] = DataNames[i] + " - " + formatMoney((Data[i] / sum) * 100, 2) + "%";
                }


                var pie = new RGraph.Pie('cvs', Data)
                    .set('strokestyle', 'white')
                    .set('colors', Colors)
                    .set('shadow', true)
                    .set('shadow.offsetx', 0)
                    .set('shadow.offsety', 0)
                    .set('shadow.blur', 20)
                    .set('labels.sticks', [true])
                    .set('labels.sticks.length', 20)
                    .set('strokestyle', '#e8e8e8')
                    .set('linewidth', 3)

                    .set('shadow.color', '#aaa')
                    .set('radius', 100)
                    .set('tooltips', DataNames)
                    .set('tooltips.coords.page', true)
                    .set('labels', DataNames)
                    .set('labels.sticks', true)
                    .set('labels.sticks.length', 35)

                    .set('key', DataNames)
                    .set('key.interactive', true)
                    .set('key.colors', Colors)
                    .set('key.rounded', false)
                    .set('key.halign', 'right')
                    .roundRobin()
            }
        }
        try {
            //parent.SetIFRH('<%=strID %>');
            $(document).scrollTop($(document).height() / 8.0);
        }
        catch (e) {
        }
        SetPie(Data, DataNames);
        //        var Data = [1750, 6250, 1222, 3333, 4444, 5555, 6666, 7777, 1750, 6250, 1222, 3333, 4444, 5555, 6666];
        //        var DataNames = ['מביס', 'קווין', 'גיל', "ג'ון", 'אולגה', 'לואיס', 'פט', "ברדג'ט", 'משה', 'חיים', 'יונתן', 'יוגב', 'עומר', 'איתי', 'קובי'];
        //        SetPie(Data, DataNames);

        function ReloadPage() {
            window.location.href = window.location.href;
        }
        setTimeout('ReloadPage();', 5 * 60 * 1000);
    </script>
</body>
</html>
