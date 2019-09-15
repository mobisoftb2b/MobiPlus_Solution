<%@ Page Title="עריכת דוחות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="EditLayoutReport.aspx.cs" Inherits="Pages_Admin_EditLayoutReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <iframe src="ReportsEdit.aspx?isUpdate=True&LayoutTypeID=<%=LayoutTypeID %>" width="99%" height="900px" scrolling="no" frameborder="0"></iframe>
<script type="text/javascript">
    setTimeout('SetMSG("עריכת דוחות")', 100);

    if ('<%=LayoutTypeID %>' == '1')
        $('#nDes').attr("class", "menuLink Selected");
    else
        $('#nWeb').attr("class", "menuLink Selected");
</script>
</asp:Content>

