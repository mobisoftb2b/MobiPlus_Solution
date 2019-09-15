<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LineView.aspx.cs" Inherits="Graphs_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../js/Chart.js"></script>
    <script src="../../js/jquery-1.10.2.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
     <script type="text/javascript">

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
<body>
    <form id="form1" runat="server">
    <div>
        <article id="lineChart">
            <canvas id="Line"  width="<%=strWidth %>" height="<%=strHeight %>"></canvas>
            
        </article>
       
        <div id="lbl">
        </div>
    </div>
    </form>
    <script type="text/javascript">
    function GetData()
    {
        var GraphID="<%=Request.QueryString["GraphID"]==null ? "" : Request.QueryString["GraphID"].ToString() %>";
        jQuery.ajax({
            
            url: "../../Handlers/MainHandler.ashx?MethodName=<%=Request.QueryString["MethodName"].ToString() %>&iDate=<%=iDate %>&AgentID=<%=AgentID %>&GraphID="+GraphID,
            direction: "rtl",
            data: '',
            data: '',
            type: 'POST',
            contentType: "application/json",
            success: function (data) {
            },
            complete: function (data) {
                if(data.responseText!="")
                {
                    try
                   {
                        eval(data.responseText);
                        ShowChart(dd);
                   }
                   catch(e)
                   {
                   }
                    
                }
            },
            error: function (data) {
                 //alert("error: " + data.status);
            },
            timeout: 15000
        });
     }
     GetData();
        function ShowChart(data) {
            /*var data = {
                labels: ["January", "February", "March", "April", "May", "June", "July"],
                datasets: [
		{
		    fillColor: "rgba(220,220,220,0.5)",
		    strokeColor: "rgba(220,220,220,1)",
		    pointColor: "rgba(220,220,220,1)",
		    pointStrokeColor: "#fff",
		    data: [65, 59, 90, 81, 56, 55, 40]
		},
		{
		    fillColor: "rgba(151,187,205,0.5)",
		    strokeColor: "rgba(151,187,205,1)",
		    pointColor: "rgba(151,187,205,1)",
		    pointStrokeColor: "#fff",
		    data: [28, 48, 40, 19, 96, 27, 100]
		}
	]
            }

            */
            var ctx = $("#Line").get(0).getContext("2d");
            //var ctx = $("#Bar").get(0).getContext("2d");
            var myNewChart = new Chart(ctx).Line(data, '');
            //var myNewChart2 = new Chart(ctx).Bar(data, '');

            //var Line = new Chart(ctx);//new Chart(ctx).PolarArea(data, options);


            Line.defaults = {

                //Boolean - If we show the scale above the chart data			
                scaleOverlay: false,

                //Boolean - If we want to override with a hard coded scale
                scaleOverride: false,

                //** Required if scaleOverride is true **
                //Number - The number of steps in a hard coded scale
                scaleSteps: null,
                //Number - The value jump in the hard coded scale
                scaleStepWidth: null,
                //Number - The scale starting value
                scaleStartValue: null,

                //String - Colour of the scale line	
                scaleLineColor: "rgba(0,0,0,.1)",

                //Number - Pixel width of the scale line	
                scaleLineWidth: 1,

                //Boolean - Whether to show labels on the scale	
                scaleShowLabels: true,

                //Interpolated JS string - can access value
                scaleLabel: "lbl",

                //String - Scale label font declaration for the scale label
                scaleFontFamily: "'Arial'",

                //Number - Scale label font size in pixels	
                scaleFontSize: 12,

                //String - Scale label font weight style	
                scaleFontStyle: "normal",

                //String - Scale label font colour	
                scaleFontColor: "#666",

                ///Boolean - Whether grid lines are shown across the chart
                scaleShowGridLines: true,

                //String - Colour of the grid lines
                scaleGridLineColor: "rgba(0,0,0,.05)",

                //Number - Width of the grid lines
                scaleGridLineWidth: 1,

                //Boolean - Whether the line is curved between points
                bezierCurve: true,

                //Boolean - Whether to show a dot for each point
                pointDot: true,

                //Number - Radius of each point dot in pixels
                pointDotRadius: 3,

                //Number - Pixel width of point dot stroke
                pointDotStrokeWidth: 1,

                //Boolean - Whether to show a stroke for datasets
                datasetStroke: true,

                //Number - Pixel width of dataset stroke
                datasetStrokeWidth: 2,

                //Boolean - Whether to fill the dataset with a colour
                datasetFill: true,

                //Boolean - Whether to animate the chart
                animation: true,

                //Number - Number of animation steps
                animationSteps: 60,

                //String - Animation easing effect
                animationEasing: "easeOutQuart",

                //Function - Fires when the animation is complete
                onAnimationComplete: null

            }
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
