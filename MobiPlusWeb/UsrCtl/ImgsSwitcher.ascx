<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ImgsSwitcher.ascx.cs"
    Inherits="ImgsSwitcher" %>
<%@ Register Src="~/UsrCtl/ImgData.ascx" TagName="ImgData" TagPrefix="MP" %>
<div id="slideshow">
    <div class="active">
        <div class="Img1">
            <MP:ImgData runat="server" ID="ImgData1" Text="קח את הסוכנים שלך צעד אחד קדימה<br/><b>ותרוויח</b>" />
        </div>
    </div>
    <div>
        <div class="Img2">
            <MP:ImgData runat="server" ID="ImgData2" Text="הפקת תעודה בדרך קלה וידידותית<br/><br/>זמינות של מידע רב ורלוונטי<br/>המייעלת את תהליך ההזמנה/מכירה" />
        </div>
    </div>
    <div>
        <div class="Img3">
            <MP:ImgData runat="server" ID="ImgData3" Text="מערכת משרדית מתקדמת לניהול,<br/>ניתוח, שליטה ובקרה" />
        </div>
    </div>
</div>
<script type="text/javascript">
    var interval;
    $(function () {
        interval = setInterval("slideSwitch(true)", 5000);
    });
</script>
