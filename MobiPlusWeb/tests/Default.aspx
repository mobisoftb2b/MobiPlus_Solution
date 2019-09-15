<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="tests_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <input type="button" id="btn" value="Start"/>
    <div id="getjs"></div>
    </div>
    </form>
     <script type="text/javascript">
         $(function () {
             $("#btn").click(function () {
                 $.ajax({
                     url: "http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/tests/test_query.js",
                     cache: false,
                     async: true,
                     success: function (data) {
                         alert(data);
                         $("#getjs").append(data);
                     },
                     error: function (data) {
                         $("#getjs")[0].innerHTML=data.responseText;
                         // debugger;
                         alert(data.statusText);
                     }
                 });
             });
         });
         function require(e) {
         }
 </script> 
</body>
</html>
