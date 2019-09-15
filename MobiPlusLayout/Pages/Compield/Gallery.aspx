<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Gallery.aspx.cs" Inherits="Pages_Compield_Gallery" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gallery</title>
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

        function styler() {
            var lang = '<%= Lang %>';
            var href;
            switch (lang) {

                case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>"; break;
                case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>"; break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        }
        styler();
        function CloseEditBoxPopup() {
            $(".GalleryBigImage").css({ top: 100 })
                            .animate({ "top": "-1640" }, "high");
        }
       
    </script>
</head>
<body onload="SetH();try{setTimeout('parent.CloseLoading();',10);}catch(e){}">
    <form id="form1" runat="server">
        <div id="gg">
            <div style="float: right; width: 10%;">
                <asp:DropDownList runat="server" ID="ddlAgents" CssClass="LBAgents2" size="50" onchange="SetH();"></asp:DropDownList>
            </div>
            <div style="float: right; width: 27%;">
                <iframe id='1if_1' frameborder='0' scrolling='no' src='' class='ifReport'></iframe>
            </div>
            <div id="dGallery" style="float: left; width: 60%; margin-right:20px;overflow-y:auto;">

            </div>
            <div class="LoadMore"">
                <a style="color:blue;text-decoration:underline;cursor:pointer;" id="a1" onclick="GetImages($('.GalleryImageIn')[$('.GalleryImageIn').length-1].id.toString().replace('id_',''), SelectedCust_Key);"><%=StrSrc("LoadMore")%> </a>
            </div>
        </div>
        <div class="GalleryBigImage">
            <div class="ggs" style="height:30px;overflow:hidden;">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <button type="button" class="close2" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();"> × </button>
                            </td>
                        </tr>
                    </table>
                </div>
            <table cellpadding="2" cellspacing="2" width="100%">
                <tr>
                    <td style="width:18%;vertical-align:top;border-left:2px solid gray;" class="GalleryBigImageTitle"></td>
                    <td style="width:81.7%;"><img alt="MobiPlus" id="iGalleryBigImage" class="iGalleryBigImage" src="" width="80%"/></td>
                    <td></td>
                </tr>
            </table>
            
        </div>
    </form>
    <script type="text/javascript">
        function SetH() {
            //alert($(window).height());
            $('#dAll1').height($(window).height() + "px");
            $('#dGallery').height($(window).height() + "px");
            $('.LBAgents2').height($(window).height() + "px");
            $('.ifReport').height($(window).height() + "px");
            var width = ($(window).width()) * 1.0;
            $('.ifReport')[0].src = '../RPT/ShowReport.aspx?Name=CustomersOnGallery&WinID=1if_1&Width=' + width + '&Height=' + $(window).height() + "&AgentId="+$('#<%=ddlAgents.ClientID%>').val();
        }

        function GetImages(id,CustKey)
        {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetGalleryData&id=" + id + "&AgentID=" + $('#<%=ddlAgents.ClientID%>').val() + "&Cust_Key=" + CustKey + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "POST",
                data: ""
            });
            request.done(function (response, textStatus, jqXHR) {
               
               
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    $('#dGallery').html($('#dGallery').html() + jqXHR.responseText);
                    for (var i = 0; i < $('.GalleryImageIn').length; i++) {
                        $('.GalleryImageIn')[i].title = decodeURI($('.GalleryImageIn')[i].title);
                    }
                    try {
                        //$('#a1')[0].href = "#" + $('.GalleryImageIn')[$('.GalleryImageIn').length - 1].id;
                        $('#dGallery').scrollTop($('#dGallery').height()*2 +200);
                    }
                    catch(e)
                    {

                    }
                }
                else {
                }
            });
        }
        GetImages(0, 0);

        var SelectedCust_Key = "";
        function ShowData(obj, id)
        {
            id = 0;
            $('#dGallery').html("");
            SelectedCust_Key = obj.Cust_Key;
            GetImages(id, SelectedCust_Key);
        }
        function ShowBigImage(src,title)
        {
            $('.GalleryBigImage').css("display", "block");
            $(".GalleryBigImage").css({ top: top }).animate({ "top": "5px" }, "high");
            $(".iGalleryBigImage")[0].src = src;
            var obj = decodeURI(title.toString()).split('^');
            var tbl = "<table>";
            for (var i = 0; i < obj.length; i++) {
                var row = obj[i].toString().split(': ');
                tbl += "<tr>";
                tbl += "<td style='width:30%;'>";
                tbl += row[0];
                tbl += "</td>";
                tbl += "<td class='boldy'>";
                tbl += row[1];
                tbl += "</td>";
                tbl += "</tr>";
            }
            tbl += "</table>";
            $(".GalleryBigImageTitle").html(tbl);//.join('<br/>'));
        }
    </script>
</body>
</html>
