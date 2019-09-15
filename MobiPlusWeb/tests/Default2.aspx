<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="tests_Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script type="text/javascript" src="../js/Chart.js"></script>
    <script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="../js/Main.js"></script>
    <script type="text/javascript" src="../js/Options.js"></script>
    <script type="text/javascript">

        function DoStart() {
            $.ajax({
                url: "http://gildesktop:8090/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=SetPositiopnWin&ScreenWidth=" + $(window).width() + "&ScreenHeight=" + $(window).height(),
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
    <form method="post" action="BarView.aspx?MethodName=GetAgentSalesGraph&amp;iDate=20140226&amp;AgentID=0&amp;ID=194"
    id="form1">
    "<div class="FragmentHead">
        <div class="JumpWiXLeft" id="ContentPlaceHolder1_JumpWiXLeft63">
            <img class="imngX" onclick="CloseWinReport('draggable63');" alt="סגור" src="../../img/X.png"></div>
        <div class="FragmentHeadText">
            WebWidjet1</div>
        <div class="imgg" id="ContentPlaceHolder1_report0">
            <table style="border: 1px dotted gray; border-image: none; color: gray; background-color: white;">
                <tbody>
                    <tr>
                        <td>
                            <img class="imgrep" src="../../Img/web.jpg">
                        </td>
                        <td>
                            <table cellspacing="2" cellpadding="2">
                                <tbody>
                                    <tr>
                                        <td class="repItem">
                                            דוח אינטרנט ראשון
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="repItem">
                                            Web Widjet
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="repItem">
                                            מציג את כל האנשים
                                        </td>
                                    </tr>
                                    <tr>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="gtr1" style="padding-top: 75px; position: fixed;">
        <span id="d_">רוחב: 893; גובה: 559</span></div>
    <div class="ui-resizable-handle ui-resizable-e" style="z-index: 90;">
    </div>
    <div class="ui-resizable-handle ui-resizable-s" style="z-index: 90;">
    </div>
    <div class="ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se"
        style="z-index: 90;">
    </div>
    "
</body>
</html>
