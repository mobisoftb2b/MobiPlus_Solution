﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PolarArea.aspx.cs" Inherits="Graphs_Default" %>

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
            <canvas id="PolarArea" width="400" height="400"></canvas>
            
        </article>
        <div id="lbl">
        </div>
    </div>
    </form>
    <script type="text/javascript">
        var data = [
	{
	    value: 30,
	    color: "#D97041"
	},
	{
	    value: 90,
	    color: "#C7604C"
	},
	{
	    value: 24,
	    color: "#21323D"
	},
	{
	    value: 58,
	    color: "#9D9B7F"
	},
	{
	    value: 82,
	    color: "#7D4F6D"
	},
	{
	    value: 8,
	    color: "#584A5E"
	}
]


var ctx = $("#PolarArea").get(0).getContext("2d");
        //var ctx = $("#Bar").get(0).getContext("2d");
var myNewChart = new Chart(ctx).PolarArea(data, '');
PolarArea.defaults = {

    //Boolean - Whether we show the scale above or below the chart segments
    scaleOverlay: true,

    //Boolean - If we want to override with a hard coded scale
    scaleOverride: false,

    //** Required if scaleOverride is true **
    //Number - The number of steps in a hard coded scale
    scaleSteps: null,
    //Number - The value jump in the hard coded scale
    scaleStepWidth: null,
    //Number - The centre starting value
    scaleStartValue: null,

    //Boolean - Show line for each value in the scale
    scaleShowLine: true,

    //String - The colour of the scale line
    scaleLineColor: "rgba(0,0,0,.1)",

    //Number - The width of the line - in pixels
    scaleLineWidth: 1,

    //Boolean - whether we should show text labels
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

    //Boolean - Show a backdrop to the scale label
    scaleShowLabelBackdrop: true,

    //String - The colour of the label backdrop	
    scaleBackdropColor: "rgba(255,255,255,0.75)",

    //Number - The backdrop padding above & below the label in pixels
    scaleBackdropPaddingY: 2,

    //Number - The backdrop padding to the side of the label in pixels	
    scaleBackdropPaddingX: 2,

    //Boolean - Stroke a line around each segment in the chart
    segmentShowStroke: true,

    //String - The colour of the stroke on each segement.
    segmentStrokeColor: "#fff",

    //Number - The width of the stroke value in pixels	
    segmentStrokeWidth: 2,

    //Boolean - Whether to animate the chart or not
    animation: true,

    //Number - Amount of animation steps
    animationSteps: 100,

    //String - Animation easing effect.
    animationEasing: "easeOutBounce",

    //Boolean - Whether to animate the rotation of the chart
    animateRotate: true,

    //Boolean - Whether to animate scaling the chart from the centre
    animateScale: false,

    //Function - This will fire when the animation of the chart is complete.
    onAnimationComplete: null
}
    </script>
</body>
</html>
