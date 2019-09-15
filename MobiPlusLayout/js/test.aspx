<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>תכנון מסלולים</title>
    <script src="scripts/jquery-1.11.0.min.js"></script>
    <script src="scripts/jquery-ui-resizeRight.js"></script>



    <link href="css/Planning.css" rel="stylesheet" />

    <link href="css/fullcalendar.css" rel="stylesheet" />

    <script src="scripts/moment.min.js"></script>
    <script src="scripts/fullcalendar.js"></script>
    <script src="scripts/he.js"></script>
    <script>
        $(function () {
            $("#Planningdiv").tabs();
        });
    </script>
</head>
<body style="direction: rtl;">

    <div id="Planningdiv">
        <ul style="direction: rtl;">
            <li><a href="#tab3"><span>תכנון</span></a></li>
            <li><a href="#tab2"><span>לוח שנה</span></a></li>
            <li><a href="#tab1"><span>ימים לא פעילים</span></a></li>
            <li><a href="#tab0"><span>הגדרות</span></a></li>
        </ul>
        <div id="tab0">
            <h1>הגדרות</h1>
            <p>Proin elit arcu, rutrum commodo, vehicula tempus, commodo a, risus. Curabitur nec arcu. Donec sollicitudin mi sit amet mauris. Nam elementum quam ullamcorper ante. Etiam aliquet massa et lorem. Mauris dapibus lacus auctor risus. Aenean tempor ullamcorper leo. Vivamus sed magna quis ligula eleifend adipiscing. Duis orci. Aliquam sodales tortor vitae ipsum. Aliquam nulla. Duis aliquam molestie erat. Ut et mauris vel pede varius sollicitudin. Sed ut dolor nec orci tincidunt interdum. Phasellus ipsum. Nunc tristique tempus lectus.</p>
        </div>
        <div id="tab1">
            <h1>ימים לא פעילים</h1>
            <p>Morbi tincidunt, dui sit amet facilisis feugiat, odio metus gravida ante, ut pharetra massa metus id nunc. Duis scelerisque molestie turpis. Sed fringilla, massa eget luctus malesuada, metus eros molestie lectus, ut tempus eros massa ut dolor. Aenean aliquet fringilla sem. Suspendisse sed ligula in ligula suscipit aliquam. Praesent in eros vestibulum mi adipiscing adipiscing. Morbi facilisis. Curabitur ornare consequat nunc. Aenean vel metus. Ut posuere viverra nulla. Aliquam erat volutpat. Pellentesque convallis. Maecenas feugiat, tellus pellentesque pretium posuere, felis lorem euismod felis, eu ornare leo nisi vel felis. Mauris consectetur tortor et purus.</p>

        </div>
        <div id="tab2">
            <h1>לוח שנה</h1>

        </div>
        <div id="tab3">
            <table>
                <tr>
                    <td>
                        <div style="width: 180px">
                            try
                        </div>
                    </td>
                    <td>
                          <div id="calendar" class="fc fc-ltr fc-unthemed"></div>
                    </td>
                </tr>
            </table>


        </div>
    </div>
    <script type="text/javascript">
        $('#calendar').fullCalendar({
            dayClick: function () {
                alert('a day has been clicked!');
            }
        })

    </script>

</body>
</html>
