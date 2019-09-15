<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PieView.aspx.cs" Inherits="Graphs_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
    <style type="text/css">
        
    </style>
    <script type="text/javascript" src="../../js/Chart.js"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/Main.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <article id="PieChart">
            <canvas id="Pie" width="<%=strWidth %>" height="400"></canvas>
            
        </article>
        <div id="lbl">
        </div>
    </div>
    </form>
    <script type="text/javascript">
    var mydata2;
    var SPName="<%=Request.QueryString["SPName"]==null ? "" : Request.QueryString["SPName"].ToString() %>";
    var Caption1="<%=Request.QueryString["Caption"]==null ? "משפחות" : Request.QueryString["Caption"].ToString() %>";
        jQuery.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=<%=Request.QueryString["MethodName"].ToString() %>&iDate=<%=iDate %>&AgentID=<%=AgentID %>&SPName="+SPName,
            direction: "rtl",
            data: '',
            type: 'POST',
            contentType: "application/json",
            success: function (data) {
            },
            complete: function (data) {
               
                eval(data.responseText);

                ShowChart(mydata2);
            },
            error: function (data) {
                //alert("error: " + data.status);
            },
            timeout: 15000
        });

        function ShowChart(mydata2) {

            defCanvasWidth = 1200;
            defCanvasHeight = 600;


            var optionschart = {
                scaleOverlay: false,
                scaleOverride: true,
                scaleSteps: 25,
                scaleStepWidth: 4,
                scaleStartValue: 0,
                annotateDisplay: true,
                savePng: true
                //       scaleShowLabels : true,
            }


         /*   var mydata2 = [
	{
	    value: 30,
	    color: "#D97041",
	    title: "קובי"
	},
	{
	    value: 90,
	    color: "#C7604C",
	    title: "data2"
	},
	{
	    value: 24,
	    color: "#21323D",
	    title: "data3"
	},
	{
	    value: 58,
	    color: "#9D9B7F",
	    title: "data4"
	},
	{
	    value: 82,
	    color: "#7D4F6D",
	    title: "data5"
	},
	{
	    value: 8,
	    color: "#584A5E",
	    title: "data6"
	}
]
*/











            var allopts = {
                //Boolean - If we show the scale above the chart data	  -> Default value Changed
                scaleOverlay: true,
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
                scaleLabel: "100",
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
                //Boolean - Whether the line is curved between points -> Default value Changed 
                bezierCurve: false,
                //Boolean - Whether to show a dot for each point -> Default value Changed
                pointDot: false,
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
                //Boolean - Whether to animate the chart             -> Default value changed
                animation: false,
                //Number - Number of animation steps
                animationSteps: 60,
                //String - Animation easing effect
                animationEasing: "easeOutQuart",
                //Function - Fires when the animation is complete
                onAnimationComplete: null,
                canvasBorders: false,
                canvasBordersWidth: 0,
                canvasBordersColor: "white",
                yAxisLeft: true,
                yAxisRight: true,
                yAxisLabel: "Y axis",
                yAxisFontFamily: "'Arial'",
                yAxisFontSize: 50,
                yAxisFontStyle: "normal",
                yAxisFontColor: "#666",
                xAxisLabel: "",
                xAxisFontFamily: "'Arial'",
                xAxisFontSize: 16,
                xAxisFontStyle: "normal",
                xAxisFontColor: "#666",
                yAxisUnit: "UNIT",
                yAxisUnitFontFamily: "'Arial'",
                yAxisUnitFontSize: 12,
                yAxisUnitFontStyle: "normal",
                yAxisUnitFontColor: "#666",
                graphTitle: "",
                graphTitleFontFamily: "'Arial'",
                graphTitleFontSize: 24,
                graphTitleFontStyle: "bold",
                graphTitleFontColor: "#666",
                graphSubTitle: "",
                graphSubTitleFontFamily: "'Arial'",
                graphSubTitleFontSize: 18,
                graphSubTitleFontStyle: "normal",
                graphSubTitleFontColor: "#666",
                footNote: "Footnote",
                footNoteFontFamily: "'Arial'",
                footNoteFontSize: 50,
                footNoteFontStyle: "bold",
                footNoteFontColor: "#666",
                legend: true,
                legendFontFamily: "'Arial'",
                legendFontSize: 18,
                legendFontStyle: "normal",
                legendFontColor: "#666",
                legendBlockSize: 30,
                legendBorders: false,
                legendBordersWidth: 0,
                legendBordersColor: "#666",
                //  ADDED PARAMETERS 
                graphMin: "DEFAULT",
                graphMax: "DEFAULT"

            }

            var noopts = {
                nooptions: "",
                yAxisRight: true,
                scaleTickSizeLeft: 0,
                scaleTickSizeRight: 0,
                scaleTickSizeBottom: 0,
                scaleTickSizeTop: 1


            }

            var onlyborderopts = {
                canvasBorders: false,
                canvasBordersWidth: 3,
                canvasBordersColor: "black"

            }

            var nooptions = {}

            var newopts = {
                inGraphDataShow: true,
                datasetFill: false,
                scaleLabel: "100",
                scaleTickSizeRight: 5,
                scaleTickSizeLeft: 5,
                scaleTickSizeBottom: 5,
                scaleTickSizeTop: 5,
                scaleFontSize: 16,
                canvasBorders: false,
                canvasBordersWidth: 3,
                canvasBordersColor: "black",
                graphTitle: Caption1,
                graphTitleFontFamily: "'Arial'",
                graphTitleFontSize: 24,
                graphTitleFontStyle: "bold",
                graphTitleFontColor: "#666",
                graphSubTitle: "",
                graphSubTitleFontFamily: "'Arial'",
                graphSubTitleFontSize: 18,
                graphSubTitleFontStyle: "normal",
                graphSubTitleFontColor: "#666",
                footNote: "מקרא",
                footNoteFontFamily: "'Arial'",
                footNoteFontSize: 8,
                footNoteFontStyle: "bold",
                footNoteFontColor: "#666",
                legend: true,
                legendFontFamily: "'Arial'",
                legendFontSize: 12,
                legendFontStyle: "normal",
                legendFontColor: "#666",
                legendBlockSize: 15,
                legendBorders: false,
                legendBordersWidth: 1,
                legendBordersColors: "#666",
                yAxisLeft: false,
                yAxisRight: true,
                xAxisBottom: false,
                xAxisTop: false,
                yAxisLabel: "Y Axis Label",
                yAxisFontFamily: "'Arial'",
                yAxisFontSize: 16,
                yAxisFontStyle: "normal",
                yAxisFontColor: "#666",
                xAxisLabel: "pX Axis Label",
                xAxisFontFamily: "'Arial'",
                xAxisFontSize: 16,
                xAxisFontStyle: "normal",
                xAxisFontColor: "#666",
                yAxisUnit: "Y Unit",
                yAxisUnitFontFamily: "'Arial'",
                yAxisUnitFontSize: 8,
                yAxisUnitFontStyle: "normal",
                yAxisUnitFontColor: "#666",
                annotateDisplay: true,
                spaceTop: 0,
                spaceBottom: 0,
                spaceLeft: 0,
                spaceRight: 0,
                logarithmic: false,
                //      showYAxisMin : false,
                rotateLabels: "smart",
                xAxisSpaceOver: 0,
                xAxisSpaceUnder: 0,
                xAxisLabelSpaceAfter: 0,
                xAxisLabelSpaceBefore: 0,
                legendBordersSpaceBefore: 0,
                legendBordersSpaceAfter: 0,
                footNoteSpaceBefore: 0,
                footNoteSpaceAfter: 0,
                startAngle: 0,
                dynamicDisplay: true
            }


//             var pieData = [{
//                    value: 30,
//                    color: "#F38630",
//                    label: 'HELLO',
//                    labelColor: 'black',
//                    labelFontSize: '16'
//                }, {
//                    value: 50,
//                    color: "#E0E4CC"
//                }, {
//                    value: 100,
//                    color: "#69D2E7"
//                }];



            //setopts = allopts;
            //setopts = onlyborderopts;
            //setopts = noopts;
            setopts = newopts;
            var myPie = new Chart(document.getElementById("Pie").getContext("2d")).Pie(mydata2, setopts);

          } 

        

        function dispPct(numtxt, valtxt, ctx, config, posX, posY, borderX, borderY, overlay, data, animPC) {
            return (Math.round(100 * animPC));
        }

        try
        {
            parent.SetIFRH('<%=strID %>');
        }
        catch(e)
        {
        }
    </script>
</body>
</html>
