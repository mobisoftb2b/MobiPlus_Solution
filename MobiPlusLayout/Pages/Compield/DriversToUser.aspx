<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DriversToUser.aspx.cs" Inherits="Pages_Compield_DriversToUser" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DriversToUser</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/Main.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/json2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function SetReportGrid(val) {
            //alert($(window).height());
            $('#dAll1').height($(window).height() + "px");
            //$('.ifReport').height($(window).height() + "px");
            var width = $(window).width() - 20 * 1.0;
            $('.ifReport')[0].src = '../RPT/ShowReport.aspx?Name=GridDriversToUser&SelectedUserID='+val+'&WinID=1if_1&Width=' + width + '&Height=' + ($(window).height()-47.0);
        }
    </script>
     <script type="text/javascript">
         function SetDriverToUser(val,type,checked) {
             //debugger;
             var isToDelete = "0";
             if (!checked)
                 isToDelete = "1";

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=SetDriverToUser&SelectedUserID=" + $('#<%=ddlUsers.ClientID%>').val() + "&DriverID=" + val
                     + "&DriverTypeID=" + type + "&isToDelete=" + isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: '',
            });
            request.done(function (response, textStatus, jqXHR) {


            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText=="True")
                        {}
                    else 
                        alert(jqXHR.responseText);
                }
                else {
                    alert(jqXHR.responseText);
                }
            });
        }
    </script>
    <style type="text/css">
        .ddlBig {
            width: 200px;
            height: 30px;
        }
    </style>
</head>
<body onload="SetReportGrid($('#<%=ddlUsers.ClientID%>').val());setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <div>
            <div id="dAll1">
                <table style="width:100%;height:100%;">
                    <tr>
                        <td style="height:30px;"> <table style="height:30px;">
                    <tr>
                        <td><%=StrSrc("User") %>:
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlUsers" CssClass="ddlBig" onchange="SetReportGrid(this.value);"></asp:DropDownList>
                        </td>
                    </tr>
                </table></td>
                    </tr>
                    <tr>
                        <td>
                            <iframe id='1if_1' frameborder='0' scrolling='no' src='' class='ifReport' />
                        </td>
                    </tr>
                </table>
               
                
            </div>

        </div>
    </form>
   
        
    
</body>
</html>
