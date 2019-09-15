<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestWS.aspx.cs" Inherits="tests_ClientWS" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
    <style type="text/css">
        .sDate
        {
            font-size: 14px;
            color:White;
        }
        .rotate
        {
            /* Safari, Chrome */
            -webkit-transform: rotate(-15deg); /* Firefox */
            -moz-transform: rotate(-15deg); /* IE */
            -ms-transform: rotate(-15deg); /* Opera */
            -o-transform: rotate(-15deg); /* Older versions of IE */
            filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1); /* CSS3 standard as defined here: http://www.w3.org/TR/css3-transforms/ */
            transform: rotate(-15deg);
        }
        .msg
        {
            background-color:#009ACD;
            width:95%;
            border-bottom:2px solid #3F3D47;
            text-align:left;
            padding:5px;
        }
        .uName
        {
            color:White;
        }
        .iMsg
        {
            color:#3F3D47;
            
        }
        .headTxt
        {
            font-size:16px;
        }
    </style>
</head>
<body style="background-color: #3F3D47; color: White; font-size: 20px;">
    <center>
        <div class="" style="margin-top: 50px; font-size: 45px; color: #009ACD; font-weight: 700;">
            WS Checker
        </div>
    </center>
    <div style="height: 400px; margin-top: 50px;">
        <center>
            <table style="width:90%%;">
                <tr>
                    <td class="headTxt">
                        User Name:
                    </td>
                    <td>
                        <input type="text" id="txtUserName" style="height: 40px; width: 100%; font-size: 24px;" />
                    </td>
                </tr>
                <tr>
                    <td style="padding-top:20px;" class="headTxt">
                        Text:
                    </td>
                    <td style="width:90%;">
                        <input type="text" id="txt" style="height: 40px; width: 100%; font-size: 24px;"
                            onkeyup="CheckForEnter(event.keyCode);" />                        
                    </td>
                </tr>
            </table>
            <a href="#" onclick="Send();" style="color: White;" class="headTxt">send</a>
            <div id="msg">
            </div>
            <div id="res">
            </div>
    </div>
    </center>
    <script type="text/javascript">
        var socket;
        function Con() {
            //socket = new WebSocket('ws://10.0.0.85:8097/PushServer?AgentID=1234;9-8-7-6&NewWS=true');
            socket = new WebSocket('ws://212.143.57.226:8097/PushServer?AgentID=gg;9-8-7-6&NewWS=true');            
            socket.onopen = function () {
                alert("onopen");
                //document.getElementById("msg").innerText = 'handshake successfully established. May send data now...';
                //socket.send(document.getElementById("txt").value);
            };
            socket.onmessage = function (evt) {
                document.getElementById("msg").innerText = 'About to receive data';
                var received_msg = evt.data;
               // alert(received_msg);
                var dt = new Date();
                var time = dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
                var date = (dt.getDate() * 1.0) + "/" + (dt.getMonth() * 1.0 + 1.0) + "/" + dt.getFullYear();

                document.getElementById("msg").innerText = "";
                try {
                    var arr = received_msg.split(':');
                    var msg = '';
                    if (arr[1])
                        msg = arr[1];
                    else
                        msg = arr[0];
                    document.getElementById("res").innerHTML = "<div class='msg'><span class='sDate'>On: " + date + " " + time + " - </span>" + "<sapn class='uName'>" + arr[0] + ":</span><span class='iMsg'>" + msg + "</span></div>" + document.getElementById("res").innerHTML;
                }
                catch (e) {
                    document.getElementById("res").innerHTML = "<div class='msg'><span class='sDate'>On: " + date + " " + time + " - </span>" + "<sapn class='uName'>Server: </span><span class='iMsg'>" + received_msg + " <span class='sDate'>Size: " + received_msg.size + "</span></span></div>" + document.getElementById("res").innerHTML;
                }
            };
            socket.onclose = function (e) {
                document.getElementById("msg").innerText = 'connection closed';
            };
        }
        function Send() {
           // alert(document.getElementById("txt").value);
            //socket.send(document.getElementById("txtUserName").value + ": " + document.getElementById("txt").value);
            socket.send(document.getElementById("txt").value);
            //alert(document.getElementById("txt").value);
            document.getElementById("txt").value = "";
            document.getElementById("txt").focus();
        }
        function CheckForEnter(code) {
            if (code == 13) {
                Send();
            }
        }
        Con();
        //document.getElementById("txtUserName").focus();
        function OpenKB() {
            document.getElementById("txt").value = "";
            document.getElementById("txtUserName").focus();
        }
        setTimeout('OpenKB();', 1500);
    </script>
</body>
</html>
