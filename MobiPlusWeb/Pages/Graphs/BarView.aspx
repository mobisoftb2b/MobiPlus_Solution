<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BarView.aspx.cs" Inherits="Graphs_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../js/Chart.js"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/Main.js"></script>
    <script type="text/javascript" src="../../js/Options.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script type="text/javascript">

        function DoStart() {
            $.ajax({
                url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetPositiopnWin&ScreenWidth=" + $(window).width() + "&ScreenHeight=" + $(window).height(),
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
<body id="aBody">
    <form id="form1" runat="server">
    <div>
        <article id="barChart">
            <span id="sCanvas" runat="server">
                <canvas id="Bar" width="<%=strWidth %>" height="<%=strHeight %>"></canvas>
            </span>
        </article>
        <div id="lbl">
        </div>
    </div>
    <div id="dddd"></div>
    </form>
    <script type="text/javascript">
        var dd = {};

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
            complete: function (data) {
                try
                {
                    eval(data.responseText.replace("{\"d\":null}", ""));
               //$("#dddd").text(data.responseText.replace("{\"d\":null}", ""));
                    ShowChart(dd);             
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
        /* var mydata1b = {
        labels: ["January", "February", "March", "April", "May", "June", "July"],
        datasets: [
		{
		    fillColor: "rgba(220,220,220,0.5)",
		    strokeColor: "rgba(220,220,220,1)",
		    pointColor: "rgba(220,220,220,1)",
		    pointStrokeColor: "#fff",
		    data: [565, 559, 590, 581, 556, 555, 540],
		    title: "First data"
		},
		{
		    fillColor: "rgba(151,187,205,0.5)",
		    strokeColor: "rgba(151,187,205,1)",
		    pointColor: "rgba(151,187,205,1)",
		    pointStrokeColor: "#fff",
		    data: [528, 548, 540, 519, 596, 527, 580],
		    title: "Second data"
		}
	]
    }*/
        function ShowChart(data) {
           // debugger;

            //            var data = {
            //                labels: ["January", "February", "March", "April", "May", "June", "July"],
            //                datasets: [
            //		    {
            //		        fillColor: "#497D97",
            //		        strokeColor: "#3072BC", //"rgba(220,220,220,1)",
            //		        data: [65, 59, 90, 81, 56, 55, 40]
            //		    },
            //		    {
            //		        fillColor: "#CBDDE6",
            //		        strokeColor: "#374667",
            //		        data: [28, 48, 40, 19, 96, 27, 100]
            //		    },
            //            {
            //                fillColor: "#293955",
            //                strokeColor: "#293955",
            //                data: [55, 13, 90, 69, 77, 88, 44]
            //            }
            //	    ]
            //            }
            
            setopts = newopts;
            var ctx = $("#Bar").get(0).getContext("2d");
            var myNewChart = new Chart(ctx).Bar(data, setopts);
             //var myNewChart = new Chart(ctx).Bar(data, setopts);
            Bar.defaults = {

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
                animationSteps: 20,

                //String - Animation easing effect
                animationEasing: "easeOutQuart",

                //Function - Fires when the animation is complete
                onAnimationComplete: null
            }
        }


       var newopts = {inGraphDataShow: true,
       datasetFill: true,
       inGraphDataPaddingX: 12,
       inGraphDataPaddingY: 15,
        inGraphDataAlign : "right",
        inGraphDataVAlign : "top",
        inGraphDataRotate : 1,
        inGraphDataFontFamily: "'Tahoma'",
        inGraphDataFontSize: 9,
        inGraphDataFontStyle: "bold",
        inGraphDataFontColor: "black",
        scaleOverlay: false,
        scaleOverride: false,
        scaleSteps: null,
        scaleStepWidth: 20,
        scaleStartValue: null,
        // seting x axis value.
        yAxisLabel : "מכירות",
        yAxisFontFamily : "'Arial'",
        yAxisFontSize : 16,
        yAxisFontStyle : "normal",
        yAxisFontColor : "#666",
        xAxisLabel : "סוכן",
      xAxisFontFamily : "'Arial'",
        xAxisFontSize : 16,
        xAxisFontStyle : "normal",
        xAxisFontColor : "#666",
        // y axis value
        scaleLineColor: "rgba(0,0,0,.1)",
        scaleLineWidth: 1,
        scaleShowLabels: true,

        scaleFontFamily: "'Arial'",
        scaleFontSize: 12,
        scaleFontStyle: "normal",
        scaleFontColor: "#666",
        scaleShowGridLines: true,
        scaleXGridLinesStep : 1,
        scaleYGridLinesStep : 1,
        scaleGridLineColor: "rgba(0,0,0,.05)",
        scaleGridLineWidth: 1,
        showYAxisMin: true,      // Show the minimum value on Y axis (in original version, this minimum is not displayed - it can overlap the X labels)
        rotateLabels: "smart",   // smart <=> 0 degre if space enough; otherwise 45 degres if space enough otherwise90 degre; 
        // you can force an integer value between 0 and 180 degres
        logarithmic: false, // can be 'fuzzy',true and false ('fuzzy' => if the gap between min and maximum is big it's using a logarithmic y-Axis scale
        scaleTickSizeLeft: 5,
        scaleTickSizeRight: 5,
        scaleTickSizeBottom: 5,
        scaleTickSizeTop: 5,
        bezierCurve: true,
        pointDot: true,
        pointDotRadius: 4,
        pointDotStrokeWidth: 2,
        datasetStroke: true,
        datasetStrokeWidth: 2,
        datasetFill: true,
        animation: true,
        animationSteps: 60,
        animationEasing: "easeOutQuart",
        onAnimationComplete: null,
        footNote: "",
        footNoteFontFamily: "'Arial'",
        footNoteFontSize: 14,
        footNoteFontStyle: "bold",
        footNoteFontColor: "#666",
        legend: true,
        legendFontFamily: "'Arial'",
        legendFontSize: 12,
        legendFontStyle: "normal",
        legendFontColor: "#666",
        legendBlockSize: 15,
        legendBorders: true,
        legendBordersWidth: 1,
        legendBordersColors: "#666"
    }
       //alert($(window).height());
       //$(window).height("500px");
       //alert($(window).height());
      try
        {
            

              function pageLoad() {   
               parent.SetIFRH('<%=strID %>');
               $(document).scrollTop($(document).height());
            }
         pageLoad();

        }
        catch(e)
        {
        }
        
    </script>
</body>
</html>
