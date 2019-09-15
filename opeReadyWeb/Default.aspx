<%@ Page Title="opeReady" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="PQ.Admin._Default" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/ReadinessWebService.asmx" />
        </Services>
    </asp:ScriptManagerProxy>
    <!--end content-->
    <script language="javascript" type="text/javascript">
// <![CDATA[

        function submit_onclick() {

        }

// ]]>
    </script>
</asp:Content>
