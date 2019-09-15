<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RGPieView.aspx.cs" Inherits="Pages_Graphs_RGPaiView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MobiPlus - Pie View</title>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/RGraph.pie.js"></script>
    
    <script type="text/javascript" src="../../js/RGraph.common.core.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.dynamic.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.tooltips.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.effects.js"></script>
    <script type="text/javascript" src="../../js/RGraph.common.key.js"></script>
    <script type="text/javascript" src="../../js/RGraph.drawing.rect.js" ></script>
    <script type="text/javascript" src="../../js/Main.js" ></script>
    <link rel="stylesheet" href="demos.css" type="text/css" media="screen" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script type="text/javascript">
        // debugger;
        function DoStart() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetPositiopnWin&ScreenWidth=" + $(window).width() + "&ScreenHeight=" + $(window).height(),
                type: "Get",
                data: '',
                success: function () {
                    window.location.reload();
                },
                error: function () {
                    window.location.reload();
                }
            });
        }
        
    </script>
</head>
<body dir="rtl" style="text-align:right;">
    <form id="form1" runat="server">
    <div>
        <canvas id="cvs" width="<%=strWidth %>" height="400">[No canvas support]</canvas>
    </div>
    </form>
    <script type="text/javascript">
        var Data;
        var DataNames;
        
        var GraphID="<%=Request.QueryString["GraphID"]==null ? "" : Request.QueryString["GraphID"].ToString() %>";
        
        var Caption1="<%=Request.QueryString["Caption"]==null ? "משפחות" : Request.QueryString["Caption"].ToString() %>";
        
        jQuery.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=<%=Request.QueryString["MethodName"].ToString() %>&iDate=<%=iDate %>&AgentID=<%=AgentID %>&GraphID="+GraphID,
            direction: "rtl",
            data: '',
            type: 'POST',
            contentType: "application/json",
            success: function (data) {
            },
            complete: function (data) {
               
               try
               {
                    eval(data.responseText);
               }
               catch(e)
               {
               }
            },
            error: function (data) {
                //alert("error: " + data.status);
            },
            timeout: 15000
        });
        function SetPie(Data, DataNames) {

            var Colors = ['#FF5050', '#E3E3E3', '#009200', '#5151FF', '#FB9EC6', '#FFFF4F', '#4C4C4C', '#F4B99C', '#ED8E5F', '#9570DE', '#D0D000', '#3939FF', '#F51D1D', '#BDBDFF', '#ED6D00'];//count = 15
            if(Data)
            {
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
        try
        {
            parent.SetIFRH('<%=strID %>');
            $(document).scrollTop($(document).height()/8.0);
        }
        catch(e)
        {
        }
//        var Data = [1750, 6250, 1222, 3333, 4444, 5555, 6666, 7777, 1750, 6250, 1222, 3333, 4444, 5555, 6666];
//        var DataNames = ['מביס', 'קווין', 'גיל', "ג'ון", 'אולגה', 'לואיס', 'פט', "ברדג'ט", 'משה', 'חיים', 'יונתן', 'יוגב', 'עומר', 'איתי', 'קובי'];
//        SetPie(Data, DataNames);
    </script>
</body>
</html>
