<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ImgData.ascx.cs" Inherits="ImgData" %>
<div class="MainImgData">
    <div class="Back">
        <img alt="Back" src="../../Img/arrow-left.png" onclick="GoBack();"/>
    </div>
    <div class="idText">
        <asp:Label runat="server" ID="lblText" CssClass="lblDataImg"></asp:Label>
    </div>
    <div class="Next">
        <img alt="Next" src="../../img/arrow-right.png" onclick="GoNext();"/></div>
</div>
