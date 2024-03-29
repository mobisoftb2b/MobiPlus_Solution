﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Radar.aspx.cs" Inherits="Graphs_Default" %>

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
        <article id="lineChart">
            <canvas id="Radar" width="400" height="400"></canvas>
            
        </article>
        <div id="lbl">
        </div>
    </div>
    </form>
    <script type="text/javascript">

        var data = {
            labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Partying", "Running"],
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


var ctx = $("#Radar").get(0).getContext("2d");
        //var ctx = $("#Bar").get(0).getContext("2d");
var myNewChart = new Chart(ctx).Radar(data, '');

        Radar.defaults = {

            //Boolean - If we show the scale above the chart data			
            scaleOverlay: false,

            //Boolean - If we want to override with a hard coded scale
            scaleOverride: false,

            //** Required if scaleOverride is true **
            //Number - The number of steps in a hard coded scale
            scaleSteps: null,
            //Number - The value jump in the hard coded scale
            scaleStepWidth: null,
            //Number - The centre starting value
            scaleStartValue: null,

            //Boolean - Whether to show lines for each scale point
            scaleShowLine: true,

            //String - Colour of the scale line	
            scaleLineColor: "rgba(0,0,0,.1)",

            //Number - Pixel width of the scale line	
            scaleLineWidth: 1,

            //Boolean - Whether to show labels on the scale	
            scaleShowLabels: false,

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

            //Boolean - Show a backdrop to the scale label
            scaleShowLabelBackdrop: true,

            //String - The colour of the label backdrop	
            scaleBackdropColor: "rgba(255,255,255,0.75)",

            //Number - The backdrop padding above & below the label in pixels
            scaleBackdropPaddingY: 2,

            //Number - The backdrop padding to the side of the label in pixels	
            scaleBackdropPaddingX: 2,

            //Boolean - Whether we show the angle lines out of the radar
            angleShowLineOut: true,

            //String - Colour of the angle line
            angleLineColor: "rgba(0,0,0,.1)",

            //Number - Pixel width of the angle line
            angleLineWidth: 1,

            //String - Point label font declaration
            pointLabelFontFamily: "'Arial'",

            //String - Point label font weight
            pointLabelFontStyle: "normal",

            //Number - Point label font size in pixels	
            pointLabelFontSize: 12,

            //String - Point label font colour	
            pointLabelFontColor: "#666",

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
    </script>
</body>
</html>
