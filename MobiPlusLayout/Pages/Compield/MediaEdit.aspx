<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MediaEdit.aspx.cs" Inherits="Pages_Compield_MediaEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>media</title>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
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
        function CloseEditBoxPopup() {
            $("#dBodyr").unblock();
            $("#EditBox").css({ top: top })
                             .animate({ "top": "-1000px" }, "high");
        }

    </script>
</head>
<body id="dBodyr" onload="try{setTimeout('parent.CloseLoading();',10);}catch(e){}" >
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <div id="dAll" style="overflow:auto;">
            <asp:UpdatePanel UpdateMode="Always" runat="server">
                <ContentTemplate>
                    <table id="tblMain" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="padding-left: 0px; padding-right: 10px; width: 164px; vertical-align: top;">

                                
                                <div class="AgentsHederDiv">משפחות פריטים</div>

                                <asp:ListBox CssClass="LBAgents1" Width="160px" Height="300px" ID="FamilyList" runat="server" onchange="" AutoPostBack="true" OnSelectedIndexChanged="LoadImages"></asp:ListBox>

                            </td>
                            <td id="ImgObj" runat="server" style="vertical-align: top;"></td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div>
            <div id="EditBox" runat="server" style="display: none;" class="ImgEditBoxx Boxee">
                <div class="modal-header2">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                    <h3 id="myModalLabel">עריכת תמונה</h3>
                    <h5 style="color: red;" id="errMsg"></h5>
                </div>
                <div class="BigImgEditBox">
                    <img alt="אין תמונה" class="BigImgEdit" />
                    <div>
                        <div id="txtDesc" class="txtEditImg">
                        </div>
                    </div>
                    <div>
                        <table cellpadding="2" cellspacing="2" width="100%">
                            <tr>
                                <td>בחר תמונה: </td>
                                <td><asp:FileUpload runat="server" ID="fuMain" CssClass="fuImgMedia" /></td>
                            </tr>
                        </table>
                        
                    </div>
                    <div style="padding-top: 15px; padding-bottom: 10px;">
                                <button type="button" class="btn-Approv" data-dismiss="modal" aria-hidden="true" onclick="CheckImg();">אישור</button>
                                <asp:Button ID="btnUploadImg" class="btn-Approv" data-dismiss="modal" aria-hidden="true" OnClick="UploadImg" runat="server" Style="display: none;" />
                                <button type="button" class="btn-Approv" data-dismiss="modal" aria-hidden="true" onclick="DelItem();">מחק</button>
                                <button type="button" class="btn-Approv" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">ביטול</button>
                                <asp:Button ID="btnDel" class="btn-Approv" data-dismiss="modal" aria-hidden="true" OnClick="DelImg" runat="server" Style="display: none;" />
                    </div>
                </div>

            </div>


        </div>
        <asp:HiddenField runat="server" ID="hdnItemID"/>
    </form>
    <script type="text/javascript">
        var hasImg = false;
        function ShowEditImgBox(id, desc, tiks) {
            $("#<%=hdnItemID.ClientID%>").val(id);
            $('#errMsg').text("");
            hasImg = false;
            $('.BigImgEdit')[0].src = "<%= MediaShowBigImages%>/" + id + ".jpg?TT=" + tiks;
            $('#myModalLabel').html('עריכת תמונה' + ' - ' + id);
            $('#txtDesc').html(desc);
            $('#dBodyr').block({ message: '' });
            $("#EditBox").show();
            $("#EditBox").css({ top: top })
                             .animate({ "top": "30px" }, "high");
        }

        function readURL(input) {

            if (input.files && input.files[0]) {
                hasImg = true;
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('.BigImgEdit').attr('src', e.target.result);
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        $("#<%=fuMain.ClientID%>").change(function () {
            readURL(this);
        });

        function CheckImg() {

            if (!hasImg) {
                $('#errMsg').text("אנא בחר תמונה");
                return false;
            }
            else {
                $('#errMsg').text("");
                $('#<%=btnUploadImg.ClientID%>')[0].click();
                return true;
            }
        }
        function DelItem()
        {
            if(confirm("האם אתה בטוח ברצונך למחוק את התמונות מהפריט הבחור?"))
            {
                $('#<%=btnDel.ClientID%>')[0].click();
            }
        }
        $('#dAll').height($(window).height());
        $('.BigImgEdit').css("max-height",0.45 * $(document).height());
    </script>
</body>
</html>
