<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RGBarView.aspx.cs" Inherits="Pages_Graphs_RGBarView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="demos.css" type="text/css" media="screen" />
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

    <script type="text/javascript">

        function DoStart() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetPositiopnWin&ScreenWidth=" + $(window).width() + "&ScreenHeight=" + $(window).height()+"&Type=RGBar",
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
<body>
    <form id="form1" runat="server">
    <div>
        <article id="barChart">
            <span id="sCanvas" runat="server">
                <canvas id="cvs" width="<%=strWidth %>" height="<%=strHeight %>"></canvas>
            </span>
        </article>
    </div>
    </form>
    <script type="text/javascript">
    var data = {};
    var labels={};
       var labels = ''; //= new Object();
       var GraphID="<%=Request.QueryString["GraphID"]==null ? "" : Request.QueryString["GraphID"].ToString() %>";
        jQuery.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=<%=Request.QueryString["MethodName"].ToString() %>&iDate=<%=iDate %>&AgentID=<%=AgentID %>&GraphID="+GraphID,
            direction: "rtl",
            data: '',
            type: 'POST',
            contentType: "application/json",
            success: function (data) {
            },
            complete: function (data1) {
                try
                {             
                    eval(data1.responseText);
                   
                    setGraph(data,labels);             
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
        function setGraph(data,labels) {
            //var data = [[4, 8], [5, 7], [1, 7], [6, 3], [3, 7]];
            
            var Colors = ['Gradient(#8674BA:#4D3594:#4D3594:#4D3594:#4D3594)', 'Gradient(#EF9643:#E76400:#E76400:#E76400:#E76400)'];
            
            var bar = new RGraph.Bar('cvs', data)
                .set('gutter.left', 65)
                .set('gutter.bottom', 65)
                //.set('linewidth', 2)

                .set('hmargin', 10)

                .set('labels', labels)//['ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי'])
                .set('colors', Colors)
                //.set('text.angle', 45)

                .set('labels.above', true)
                .set('labels.bottom', 65)
            //.set('units.post', '%')


                .set('title', ['יעד', 'ביצוע'])
                .set('key', ['יעד', 'ביצוע'])
                .set('key.interactive', true)
                .set('key.colors', Colors)
                .set('key.rounded', false)
                .set('key.halign', 'center')

            RGraph.ISOLD ? bar.draw() : bar.wave({ frames: 20 })
        }
        try
        {
            parent.SetIFRH('<%=strID %>');
            $(document).scrollTop($(document).height()/2.0);
        }
        catch(e)
        {
        }
    </script>
</body>
</html>
