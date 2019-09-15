<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="PQ.Admin.Account.ErrorPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>opeReady</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link rel="stylesheet" id="cssTheme" type="text/css" media="screen" />
    <link href="../Resources/Styles/style_all.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form runat="server" id="frmScoutForm" clientidmode="Static">
    <asp:ScriptManager ID="ScriptManager2" runat="server" ScriptMode="Release">
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery-1.5.2.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery-ui-1.8.12.custom.min.js" />
        </Scripts>
    </asp:ScriptManager>
    <div id="top">
        <div id="head">
            <h1 class="logo">
                <a href="/opeReady/Default.aspx"></a>
            </h1>
            <div class="headGreeting" id="divHeadGreeting" runat="server" clientidmode="Static">
            </div>
            <div class="headVersion" id="divHeadVersion" runat="server" clientidmode="Static">
            </div>
            <!--end head_memberinfo-->
        </div>
        <!--end head-->
        <div style="margin:0px auto">
            <div id="divMainContent" style="min-height: 500px;margin:0 auto">
                <div class="emplSearch">
                    <div class="div_wrapper" style="margin-top:25px">
                        <p>
                            <img src="../Resources/images/panneau_018.png" alt="Error" width="200px" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <div style="margin-top:25px;">
                                <div class="div_wrapper">
                                    <p>
                                        <asp:Label runat="server" style="color:Black;font-size:large" ID="lblErrorMessage" />
                                    </p>
                                </div>
                            </div>
                        </p>
                    </div>
                </div>
            </div>
            <!--end main-->
        </div>
        <!--end bg_wrapper-->
        <div id="footer">
        </div>
        <!--end footer-->
    </div>
    <!-- end top -->
    <script type="text/javascript" language="javascript">
        //kriesi_navigation(".nav"); /*remove this if you dont want a $ sidebar menu*/
        var outerLayout, innerLayout, dateFormatStr;
        $(document).ready(function () {
            //------------------------------------ End Toggle Panes ----------------------------------------------------------
            $("#cssTheme").attr("href", "/opeReady/Resources/Styles/redmond/redmond.css");
        });



        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

        function endRequestHandler(sender, args) {
            if (args.get_error()) {
                args.set_errorHandled(true);
            };
            $("#waitplease").css({ 'display': 'none' });
        }
        function beginRequestHandler() {
            $("#waitplease").css({ 'display': 'block' });
        }

    </script>
    </form>
</body>
</html>
