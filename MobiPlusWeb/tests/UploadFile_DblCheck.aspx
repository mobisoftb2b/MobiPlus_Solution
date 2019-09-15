<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UploadFile_DblCheck.aspx.cs" Inherits="UploadFile" %>


<!DOCTYPE html>
<html>
<head>
</head>
<body id="body1">
    <form id="Form1" runat="server">
        <asp:FileUpload runat="server" ID="upMain"/>
        <asp:Button runat="server" ID="btn" OnClick="btn_click" Text="Upload File" OnClientClick="javascript:SetFiles();"/>
        <br />
        <br />
        <br />
        
        <div id="dMsg" runat="server"></div>
    </form>
    <script type="text/javascript">
      
    </script>
    </body>
</html>