<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="Merchandise.aspx.cs" Inherits="Pages_Usr_Merchandise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <iframe class="ifM_Merchandise" frameborder="0" scrolling="no" src="Widgets/SalesMerchandiseWidjet.aspx"></iframe>
    <script type="text/javascript">
        $('#nMerchandise').attr("class", "menuLink Selected");
        setTimeout('SetFotter();', 20);
    </script>
</asp:Content>
