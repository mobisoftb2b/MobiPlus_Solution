<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MeterChart.aspx.cs" Inherits="Pages_Graphs_HBarView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Meter Chart</title>
    <script type="text/javascript" src="../../js/Main.js"></script>
    <script src="../../js/RGraph.common.core.js"></script>
    <script src="../../js/RGraph.common.dynamic.js"></script>
    <script src="../../js/RGraph.meter.js"></script>
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
    <div>
        <div>
            <article id="barChart">
            <span id="sCanvas" runat="server">
                <center>
                  
                    <div style="font-size:24px;position:absolute;left:40%;">
                    <br />
                    <br />
                        <%=Caption %>
                    </div>
                    <canvas id="cvs" width="<%=strWidth %>" height="<%=strHeight %>"></canvas>
                </center>
            </span>
        </article>
        </div>
    </div>
    </form>
    <script type="text/javascript">
    
        var GraphID="<%=Request.QueryString["GraphID"]==null ? "" : Request.QueryString["GraphID"].ToString() %>";
        jQuery.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=<%=Request.QueryString["MethodName"].ToString() %>&Date=<%=iDate %>&AgentID=<%=AgentID %>&GraphID="+GraphID,
            direction: "rtl",
            data: '',
            type: 'POST',
            contentType: "application/json",
            success: function (data) {
            },
            complete: function (data1) {
                try
                {             
                    setGraph(0,data1.responseJSON[0].MaxSumSales/1000,data1.responseJSON[0].SumSales/1000);
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
        function setGraph(min,max,value) {

            var meter = new RGraph.Meter('cvs', min, max, value)
                .set('units.post', 'k')
                .set('red.start',  min)
                .set('red.end', min+25/100*max)
                .set('yellow.start',  min+25/100*max)
                .set('yellow.end', min+65/100*max)
                .set('green.start', min+65/100*max)
                .set('green.end', max)
                .draw();

        }
        setGraph();
        try
            {
                parent.SetIFRH('<%=strHeight %>');
                 $(document).scrollTop($(document).height()/2.0);
                //parent.SetIFRH('barifr');
                //$(document).scrollTop($(document).height()/2.0);
            }
            catch(e)
            {
            }
    </script>
</body>
</html>
