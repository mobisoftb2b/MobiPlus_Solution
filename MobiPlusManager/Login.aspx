<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <link href="css/Main.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="js/Main.js" type="text/javascript"></script>
    <link rel="SHORTCUT ICON" href="Img/package_network.ico"/>
    <title>MobiPlus Manager Login</title>
    <script type="text/javascript">
        function LoginFaild() {
            document.getElementById("lblMsg").innerHTML = "קוד מנהל או סיסמה אינם נכונים,<br/>אנא נסה שנית";
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <center class="">
            <%--<img src="Img/logo.jpg" style="padding-top:10px;"/>--%>
            <div class="">
                &nbsp;
            </div>
            <div class="">
                &nbsp;
            </div>
            <div class="">
            </div>
            <div>
                <center>
                    <img src="Img/logo.jpg" style="padding-top: 10px; height: 100px; padding-bottom: 10px;" />
                </center>
            </div>
            <div class="dLoginBox">
                <div>
                    &nbsp;</div>
                <div class="dLoginHeadText">
                    MobiPlus Manager כניסה
                </div>
                <div id="u">
                    <div class="dLoginMsg">
                        <div id="lblMsg" class="LoginMsg">
                        </div>
                    </div>
                    <div class="dLoginData" onkeypress="CheckForEnter(event,$('#btnLogin'));">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td>
                                   קוד מנהל:
                                </td>
                                <td>
                                    <input name="txtUN" type="text" id="txtUN" style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    סיסמה:
                                </td>
                                <td>
                                    <input name="txtPassword" type="password" id="txtPassword" style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: left;">
                                    <input type="button" name="btnLogin" value="כניסה" id="btnLogin"
                                        class="btn login" style="width: 75px;" onclick="Login();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
           
        </center>
    </div>
    </form>
    <script type="text/javascript">
        function SetFocus() {
            document.getElementById("txtUN").focus();
        }
        setTimeout(SetFocus, 200);

        function Login() {

            $.ajax({
                url: "Handlers/MainHandler.ashx?MethodName=UserLogin&UserName=" + $('#txtUN').val() + "&Password=" + $('#txtPassword').val()+"&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "Get",
                data: '',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
             
                    if (data && data[0] && data[0].Success=="true") {                   
                            Nav("Pages/Home/GridRequests.aspx");
                    }
                    else {
                        LoginFaild();
                    }
                },
                error: function (data) {
                //debugger;
                alert(data);
                    alert("error: failure");
                }
            });
        }
        $('#txtUN').keypress(function(event){

           if(event.which != 8 && isNaN(String.fromCharCode(event.which))){
               event.preventDefault(); //stop character from entering input
           }
       });
      $('#txtUN').bind('input propertychange', function() {
        if(!isNumber($(this).val()))
            $(this).val("");
        });
        //$('.dLoginBox').css("margin-top", $(window).height() / 3.0 - 260 + "px");
    </script>
</body>
</html>
