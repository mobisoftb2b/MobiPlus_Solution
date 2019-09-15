<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HBarView.aspx.cs" Inherits="Pages_Graphs_HBarView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HBar</title>
    <script type="text/javascript" src="../../js/Main.js"></script>
    <script type="text/javascript" src="../../js/RGraph.pie.js"></script>
    <script type="text/javascript" src="../../js/RGraph.hbar.js"></script>
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
                url: "../../Handlers/MainHandler.ashx?MethodName=SetPositiopnWin&ScreenWidth=" + $(window).width() + "&ScreenHeight=" + $(window).height() + "&Type=RGBar",
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
    <div >
        <div>
            <article id="barChart">
            <span id="sCanvas" runat="server">
                <canvas id="cvs" width="<%=strWidth %>" height="<%=strHeight %>"></canvas>
            </span>
        </article>
        </div>
    </div>
    </form>
    <script type="text/javascript">
    var data = {};
    var labels={};
       var labels = ''; //= new Object();
       var GraphID="<%=Request.QueryString["GraphID"]==null ? "" : Request.QueryString["GraphID"].ToString() %>";
        jQuery.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=<%=Request.QueryString["MethodName"].ToString() %>&GridParameters=<%=Request.QueryString["GridParameters"].ToString() %>&GraphID="+GraphID,
            direction: "rtl",
            data: '',
            type: 'POST',
            contentType: "application/json",
            success: function (data) {
            },
            complete: function (data1) {
                try
                {          
                //debugger;   
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
            
            var Colors = ['Gradient(#4F81BD)', 'Gradient(#FD9100)'];
            
                 var hbar = new RGraph.HBar('cvs', data)
                .set('background.grid', false)
                .set('xmax', <%=maxScale %>)
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
                .set('title', ['יעד', 'ביצוע'])
                .set('key', ['ביצוע', 'יעד'])
                .set('key.interactive', true)
                .set('key.colors', Colors)
                .set('key.rounded', false)
                .set('key.halign', 'left')
                .grow();
                
        }
        try
            {
                parent.SetIFRH('<%=strHeight %>');
                //parent.SetIFRH('barifr');
                //$(document).scrollTop($(document).height()/2.0);
            }
            catch(e)
            {
            }
    </script>
</body>
</html>
