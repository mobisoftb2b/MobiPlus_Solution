<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImageViewer.aspx.cs" Inherits="PQ.Admin.Presentation.Readiness.ImageViewer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>opeReady</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link rel="stylesheet" id="Link1" type="text/css" media="screen" />
    <link href="../../favicon_16x16.ico" rel="shortcut icon" type="image/x-icon" />
    <link rel="stylesheet" id="cssTheme" type="text/css" media="screen" />
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/OpSemsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery-1.5.2.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery-ui-1.8.12.custom.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.common.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.cookie.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OpSemSettings/imageOverview.js" />
        </Scripts>
    </asp:ScriptManager>
    <div id="top">
        <div id="bg_wrapper">
                <div id="divMainContent">
                    <div id="divImageDetails">
                        <div id="divScaleImage">
                            <select id="ddlScaleImage" class="select-small" style="width: 70px">
                                <option value="85%">100%</option>
                                <option value="75%">90%</option>
                                <option value="65%">80%</option>
                                <option value="55%">75%</option>
                                <option value="45%">50%</option>
                            </select>
                        </div>
                        <div id="divClose">
                            <input type="button" class="button" id="btnClose" clientidmode="Static" runat="server"
                                value="<%$ Resources:WorkStations, IO_btnClose  %>" />
                        </div>
                        <div id="tabImageDetails">
                            <ul>
                                <li><a href="#tabOriginalScreen">
                                    <asp:Label runat="server" ID="Label3" Text="<%$ Resources:WorkStations, IO_tabOriginalScreen%>" />
                                </a></li>
                                <li><a href="#tabScreenerImage">
                                    <asp:Label runat="server" ID="lblOriginalScreen" Text="<%$ Resources:WorkStations, IO_tabThreatScreen  %>" />
                                </a></li>
                                <li><a href="#tabSearcherImage">
                                    <asp:Label runat="server" ID="Label8" Text="<%$ Resources:WorkStations, IO_tabSearcherScreen  %>" />
                                </a></li>
                            </ul>
                            <div id="tabOriginalScreen">
                                <div id="imgOriginalScreen" class="loading">
                                </div>
                            </div>
                            <div id="tabScreenerImage">
                                <div id="imgScreenerImage" class="loading">
                                </div>
                                <div class="emplSearch" id="divColoredButtonsA">
                                </div>
                            </div>
                            <div id="tabSearcherImage">
                                <div id="imgSearcherImage" class="loading">
                                </div>
                                <div class="emplSearch" id="divColoredButtonsC">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    </div>
    <script type="text/javascript">
        $(function () {
            if ($.cookie("css")) {
                $("#cssTheme").attr("href", $.cookie("css"));
            }
            else {
                $("#cssTheme").attr("href", "/opeReady/Resources/Styles/redmond/redmond.css");
            }
            if ($.cookie("scaleImage")) {
                $("#ddlScaleImage").val($.cookie("scaleImage"));
            }
            else {
                $("#ddlScaleImage").val("100%");
            }
            imageOver.ImageReview(getInputParam(), 0);
            
            $("#tabImageDetails").tabs({ selected: 0 }).bind("tabsselect", function (event, ui) {
                $("#waitplease").css({ 'display': 'block' });
                imageOver.ImageReview(getInputParam(), ui.index);               
            });
            
        });

        function getInputParam() {
            return window.dialogArguments[0];
        }

        function getSelectedTabIndex() {
            return $("#tabImageDetails").tabs('option', 'selected');
        }
        $("#divImageDetails").delegate("#btnClose", "click", function (sender, args) {
            self.close();
        });
        $("#divScaleImage").delegate("#ddlScaleImage", "change", function (sender, args) {
            $("#imgOriginalScreen, #imgScreenerImage,#imgSearcherImage").block({
                css: { border: '0px' },
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            });
            $.cookie("scaleImage", $(this).val());
            imageOver.ScalingImages(getSelectedTabIndex(), $(this).val());
        });        
    </script>
    </form>
</body>
</html>
