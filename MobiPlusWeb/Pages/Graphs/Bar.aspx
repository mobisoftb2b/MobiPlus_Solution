<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Bar.aspx.cs" Inherits="Graphs_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <script type="text/javascript" src="../../js/Chart.js"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/Main.js"></script>
    <script type="text/javascript" src="../../js/Options.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <article id="lineChart">
            <canvas id="Bar" width="500" height="600"></canvas>
            
        </article>
        <div id="lbl">
        </div>
    </div>
    </form>
    <script type="text/javascript">
        var dd = { labels: ['אבי עדרי', 'אודיאל אביטן', 'אופיר עצמי', 'אוריאל דוד', 'אורן ארולקר', 'אייל קרייזל', 'אילן דנינו', 'אלון זיסרמן', 'אליעזר אביטן', 'אלכסנדר שאינין', 'אמיר ברקנר', 'אסף אלאל', 'ארז אבינו', 'אריאל שמלוב', 'אריאלי אריה', 'אריה אלימלך', 'באסל מריד', 'ברק טרבלסי', 'גאנם מועדה', 'דודי גינון', 'דימטרי גורנשטיי', 'דמיטרי גרשטור', 'יואב אחיטוב-מוכ', 'יובל בן בנימין', 'יובל דוד', 'יונית כל בו', 'יוסי אלקיים', 'יוסי בסל', 'יריב כהן', 'כיאל סעיד', 'לויט אליה', 'ליאור לוי', 'לירון ברקוביץ-0', 'לירון והב', 'מאיר בן עמי', 'מאיר דנינו', 'משה חכם', 'משה אלקיס', 'משה מלכה', 'משייב מיכאל', 'מתי אורן', 'סאלח עכאוי', 'עבאסה יאסין', 'עדי שמיע', 'עומרי פלד', 'עמנואל כהן', 'רפאעי סנאן', 'רפי מיכאלי', 'שי ברנד מוכרן', 'total', 'total2'], datasets: [{ fillColor: '#497D97', strokeColor: '#3072BC', title: 'ביצוע', data: [14164.49, 9155.41, 0, 7827.45, 42057.13, 27620.85, 62221.25, 41700.5, 54891.27, 31634.86, 4378.12, 4499.25, 8776.68, 63271.59, 38875.04, 47880.52, 238623.83, 26357.7, 26399.29, 57680.48, 90336.45, 25589.1, 94908.39, 23415.12, 59230.9, 43701.87, 0, 60079.83, 88895.86, 12574.86, 27369.98, 0, 75550.56, 40247.38, 91721.14, 70799.02, 81989.89, 7657.27, 32040.46, 18842, 53089.46, 54597.75, 101946.69, 1929.88, 24569.36, 29394.79, 55941.41, 40159.17, 34715.29, , ] }, { fillColor: '#C5D0E3', strokeColor: '#293955', title: 'יעד', data: [14228.8740454545, 10736.799, 0, 9250.62272727273, 42439.4675454546, 27620.85, 63918.1931818182, 48713.7659090909, 17964.4156363636, 10928.4061818182, 4656.72763636364, 5358.19772727273, 10412.334, 12366.7198636364, 36931.288, 94237.5689090909, 79179.7254090909, 52595.5922727273, 20519.4481363636, 19663.8, 27100.935, 26984.8690909091, 188522.574681818, 4789.45636363636, 56807.8177272727, 45886.9635, 0, 69364.8946363636, 16971.0278181818, 24692.4523636364, 9206.266, 0, 72116.4436363636, 39881.4947272727, 179690.051545454, 68224.5101818182, 83480.6152727273, 1601.06554545455, 8883.94572727273, 42994.0181818182, 15444.2065454545, 17620.1829545455, 78776.9877272727, 1973.74090909091, 49138.72, 31398.9802272727, 10425.4445909091, 42532.2118636364, 37555.6319090909, , ]}] };

        ShowChart(dd);
   
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


    var newopts = { inGraphDataShow: true,
        datasetFill: true,
        inGraphDataPaddingX: 12,
        inGraphDataPaddingY: 15,
        inGraphDataAlign: "right",
        inGraphDataVAlign: "top",
        inGraphDataRotate: 1,
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
        yAxisLabel: "מכירות",
        yAxisFontFamily: "'Arial'",
        yAxisFontSize: 16,
        yAxisFontStyle: "normal",
        yAxisFontColor: "#666",
        xAxisLabel: "סוכן",
        xAxisFontFamily: "'Arial'",
        xAxisFontSize: 16,
        xAxisFontStyle: "normal",
        xAxisFontColor: "#666",
        // y axis value
        scaleLineColor: "rgba(0,0,0,.1)",
        scaleLineWidth: 1,
        scaleShowLabels: true,

        scaleFontFamily: "'Arial'",
        scaleFontSize: 12,
        scaleFontStyle: "normal",
        scaleFontColor: "#666",
        scaleShowGridLines: true,
        scaleXGridLinesStep: 1,
        scaleYGridLinesStep: 1,
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
        legendBordersColors: "#666",
        legendAlignment:"right"
    };
        
    </script>
</body>
</html>
