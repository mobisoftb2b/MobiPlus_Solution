<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Doughnut.aspx.cs" Inherits="Graphs_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../js/Chart.js"></script>
    <script src="../js/jquery-1.10.2.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <article id="DoughnutChart">
            <canvas id="Doughnut" width="400" height="400"></canvas>
            
        </article>
        <div id="lbl">
        </div>
    </div>
    </form>
    <script type="text/javascript">

        var data = [
	{
	    value: 30,
	    color: "#F7464A"
	},
	{
	    value: 50,
	    color: "#E2EAE9"
	},
	{
	    value: 100,
	    color: "#D4CCC5"
	},
	{
	    value: 40,
	    color: "#949FB1"
	},
	{
	    value: 120,
	    color: "#4D5360"
	}

]


var ctx = $("#Doughnut").get(0).getContext("2d");
        //var ctx = $("#Bar").get(0).getContext("2d");
var myNewChart = new Chart(ctx).Doughnut(data, '');
Doughnut.defaults = {

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

            //Boolean - If there is a stroke on each bar	
            barShowStroke: true,

            //Number - Pixel width of the bar stroke	
            barStrokeWidth: 2,

            //Number - Spacing between each of the X value sets
            barValueSpacing: 5,

            //Number - Spacing between data sets within X values
            barDatasetSpacing: 1,

            //Boolean - Whether to animate the chart
            animation: true,

            //Number - Number of animation steps
            animationSteps: 60,

            //String - Animation easing effect
            animationEasing: "easeOutQuart",

            //Function - Fires when the animation is complete
            onAnimationComplete: null

        }
    </script>
</body>
</html>
