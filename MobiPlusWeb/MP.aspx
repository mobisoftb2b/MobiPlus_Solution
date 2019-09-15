<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MP.aspx.cs" Inherits="MP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>
    <div id="dLog" runat="server">
    
    </div>
    <asp:Button runat="server" ID="btnRefresh" OnClick="btnRefresh_Click" style="display:none;"/>
    </form>
    <script type="text/javascript">
        function GoToServer() {
            document.getElementById("<%=btnRefresh.ClientID %>").click();
        }
        setInterval("GoToServer();",4000);
    </script>
</body>
</html>
