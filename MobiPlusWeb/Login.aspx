<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="css/Main.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="js/Main.js" type="text/javascript"></script>
     <script src="js/jquery.blockUI.js" type="text/javascript"></script>
    <link rel="SHORTCUT ICON" href="Img/box3.ico"/>
    <title>MobiPlus Login</title>
    <script type="text/javascript">
        function LoginFaild() {
		//gggggg12223333
            document.getElementById("lblMsg").innerHTML = "שם משתמש או סיסמה אינם נכונים,<br/>אנא נסה שנית";
        }
    </script>
</head>
<body id="dBody">
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
                <img src="Img/logo.jpg" style="padding-top:10px;height:100px;padding-bottom:10px;"/>
            </center>
        </div>
            <div class="dLoginBox">
                <div>
                    &nbsp;</div>
                <div class="dLoginHeadText">
                    <%= StrSrc("Header")%>
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
                                    <%= StrSrc("UserName")%>
                                </td>
                                <td>
                                    <input name="txtUN" type="text" id="txtUN" style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <%= StrSrc("Pass")%>
                                </td>
                                <td>
                                    <input name="txtPassword" type="password" id="txtPassword" style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: left;">
                                    <input type="button" name="btnLogin" value=" <%= StrSrc("btnLogin") %>" id="btnLogin"
                                        class="btn login" style="width: 75px;" onclick="Login();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div style="text-align:center;">
            <center>
            <%--<div style="background-image: url('img/bgjpg.jpg');background-position:center top;background-repeat:no-repeat;height:400px;margin-top:50px;">&nbsp;</div>--%>
            </center>
            </div>
        </center>
    </div>
    <center>
        <div id="divAllProjects" runat="server" class="EditWinProjects">
            <div class="prHead">
                אנא בחר פרויקט
            </div>
            <%--<div class="prItem" onclick="SetProjectName('Strauss');">
                Strauss
            </div>
             <div class="prItem" onclick="SetProjectName('Sides');">
                Sides
            </div>--%>
        </div>
    </center>
    </form>
    <script type="text/javascript">
        function SetFocus() {
            document.getElementById("txtUN").focus();
        }
        setTimeout(SetFocus, 200);

        function Login() {
            
            $.ajax({
                url: "Handlers/MainHandler.ashx?MethodName=UserLogin&UserName=" + $('#txtUN').val() + "&Password=" + $('#txtPassword').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "Get",
                data: '',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    //document.write(data);
                    //return;
                    if (data != '') {                   
                            Nav("Pages/Usr/Home.aspx");
                    }
                    else {
                        LoginFaild();
                    }
                },
                error: function (err) {
                
                    alert("error: failure");
                }
            });
        }
        function SetProjectName(ProjectName) {

            $.ajax({
                url: "Handlers/MainHandler.ashx?MethodName=SetProjectName&ProjectName=" + ProjectName + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "Get",
                data: '',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    CloseWinProjects();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        CloseWinProjects();
                    }
                    else {
                        alert("error: failure");
                    }
                }
            });
        }
        function CloseWinProjects() {

            $(".EditWinProjects").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }

        $("#dBody").height($(document).height());
       
        //SetProjectName(context.Request.QueryString["ProjectName"].ToString());
        //$('.dLoginBox').css("margin-top", $(window).height() / 3.0 - 260 + "px");
    </script>
</body>
</html>
