<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MediaUpload.aspx.cs" Inherits="Pages_Compield_MediaUpload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css" rel="stylesheet" type="text/css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
    <style type="text/css">
        .tHead
        {
            color: White;
            background-color: #264366;
            text-align: center;
            height: 30px;
            font-size: 16px;
            font-weight:700;
        }
        .td1
        {
            width: 170px;
            font-weight:700;
        }
        .td2
        {
            width: 170px;
            border-right: 2px solid white;
        }
        .tBody
        {
            border-bottom: 2px solid white;
            font-size: 14px;
            padding: 5px;
            vertical-align: top;
        }
        .dAlll
        {
            border: 2px solid #264366;
            width: 500px;
            margin-right: 20px;
            background-color: #D2DEEF;
            -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            max-height: 700px;
            overflow-y: auto;
        }
        .img1
        {
            /*border: 2px solid #264366;*/
        }
        .MediaItem
        {
            text-align: center;
        }
        .obj
        {
            border: 4px solid #D2DEEF;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }
        .obj:hover
        {
            border: 4px solid #FA6E58;
        }
        .obj.SelectedObj
        {
            border: 4px solid #FA6E58;
        }
        .ButtonsCls
        {
            margin-right: 20px;
            margin-top: 5px;
            text-align: center;
            background-color: #264366;
            height: 45px;
            border: 2px solid #264366;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
            box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.25);
        }
        .tblBtns
        {
            padding-top: 5px;
        }
        .txtBox
        {
            width: 100px;
        }
        .ObjEditBox
        {
            top: 30px;
            right: 40px;
            margin-left: 10%;
            position: absolute;
            width: 500px;
            height: 210px;
            border: 2px groove black;
            background-color: #A2A2A2;
            color: white;
            font-size: 16px;
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            z-index: 1000;
            display: none;
        }
        .pop1
        {
            cursor: pointer;
        }
    </style>
    <script type="text/javascript">
        var ddlid = '';

        function CloseObjEditBox() {
            $(".ObjEditBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $(".divAllObjs").unblock();
        }
        function ShowBox() {
            //$('.SelectedObj')[0].className = "obj";
            $('#btnSave')[0].onclick = function () { Save('new'); };
            $('#<%=txtName.ClientID %>').val("");
            $('.fu').val("");
            $("#" + ddlid).val("");
            $(".ObjEditBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('.divAllObjs').block({ message: '' });
        }
        function EditBox() {
            $('#<%=txtName.ClientID %>').val($('.SelectedObj')[0].children[2].innerText);
            $('.fu').val("");
            $('#btnSave')[0].onclick = function () { Save('edit'); };

            $("#" + ddlid + " option").each(function () {
                if ($(this).text() == $('.SelectedObj')[0].parentElement.parentElement.parentElement.parentElement.parentElement.children[0].innerText) {
                    $(this).attr('selected', 'selected');
                }
            });
            $(".ObjEditBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('.divAllObjs').block({ message: '' });
        }
        
        //        function ShowCtlPopulations() {
        //            $('.ctlPopulations').css("display", "block");
        //            var top = "1%";
        //            var left = "10%";
        //            $(".ctlPopulations")
        //                        .animate({ "top": top, "display": "block" }, "high");

        //            $('#tabAgents').tree('collapseAll');
        //            $('#tabCustomers').tree('collapseAll');
        //            $('#tabItems').tree('collapseAll');
        //            $('#tabCategories').tree('collapseAll');
        //            //$('#dBodyr').block({ message: '' });
        //        }
        
    </script>
</head>
<body id="dBodyr" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <br />
    <div class="divAllObjs">
        <div style="" class="dAlll">
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="tHead td1">
                        אוכלוסייה
                    </td>
                    <td class="tHead td2">
                        מדייה
                    </td>
                </tr>
                <tr>
                    <td class="tBody td1">
                        שופרסל
                    </td>
                    <td class="tBody td2">
                        <table cellpadding="2" cellspacing="2">
                        <tbody>
                            <tr>
                                <td class="obj" id="obj1">
                                    <img alt="" src="../../img/logo.png" class="img1" />
                                    <br />
                                    <div class="MediaItem">
                                        לוגו אוסם
                                    </div>
                                </td>
                                <td class="obj SelectedObj" id="obj2">
                                    <img alt="" src="../../img/085.jpg" class="img1" />
                                    <br />
                                    <div class="MediaItem">
                                        במבה
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="obj" id="obj3">
                                    <img alt="" src="../../img/pdfimage.png" class="img1" />
                                    <br />
                                    <div class="MediaItem">
                                        פלוגרמה 1
                                    </div>
                                </td>
                                <%--<td class="obj" id="obj4">
                                    <img alt="" src="../../img/excel.png" class="img1" />
                                    <br />
                                    <div class="MediaItem">
                                        אנשי קשר
                                    </div>
                                </td>--%>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="tBody td1">
                        אבי כהן בע''מ
                    </td>
                    <td class="tBody td2">
                        <table cellpadding="2" cellspacing="2">
                        <tbody>
                            <tr>
                                <td class="obj" id="obj5">
                                    <img alt="" src="../../img/excel.png" class="img1" />
                                    <br />
                                    <div class="MediaItem">
                                        מוצרים
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="tBody td1">
                        גיל גולן בע''מ
                    </td>
                    <td class="tBody td2">
                        <table cellpadding="2" cellspacing="2">
                        <tbody>
                            <tr>
                                <td class="obj" id="obj6">
                                    <img alt="" src="../../img/Microsoft-word-logo.png" class="img1" />
                                    <br />
                                    <div class="MediaItem">
                                        הנחיות חלוקה
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div class="ButtonsCls">
            <table width="100%" class="tblBtns">
                <tr>
                    <td>
                        <input type="button" value="חדש" class="MSBtnGeneral" style="background-image: url('../../Img/plus.png');
                            width: 80px;" onclick="ShowBox();" />
                    </td>
                    <td>
                        <input type="button" value="ערוך" class="MSBtnGeneral" style="background-image: url('../../Img/edit.png');
                            width: 80px;" onclick="EditBox();" />
                    </td>
                    <td>
                        <input type="button" value="מחק" class="MSBtnGeneral" style="background-image: url('../../Img/delete.png');
                            width: 80px;" onclick="DelObj();" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div id="ObjEditBox" class="ObjEditBox">
        <div class="JumpWiX" style="padding-right: 3px; padding-top: 2px;">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseObjEditBox();" />
        </div>
        <div style="padding-top: 3px; background-color: #244062; height: 25px;">
            <center>
                <div id="sHeadEdit">
                    עריכת מסמך
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="4" cellspacing="2" width="450px">
            <tr>
                <td>
                    אוכלוסייה:
                </td>
                <td onclick="ShowCtlPopulations();" class="pop1" id="aPop" style="display: none;">
                    טוען...
                    <img alt="טוען..." src="../../img/loading1.gif" width="16px" />
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="ddlPops" Style="width: 104px;" onchange="RowsAdded=0;lastCounter=0;">
                        <asp:ListItem Text="מגה" Value="1"></asp:ListItem>
                        <asp:ListItem Text="שופרסל" Value="2"></asp:ListItem>
                        <asp:ListItem Text="YOU" Value="3"></asp:ListItem>
                        <asp:ListItem Text="יינות ביתן" Value="4"></asp:ListItem>
                        <asp:ListItem Text="אבי כהן בע''מ" Value="5"></asp:ListItem>
                        <asp:ListItem Text="גיל גולן בע''מ" Value="6"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    שם מסמך:
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtName" CssClass="txtBox"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    מסלול לקובץ:
                </td>
                <td>
                    <asp:FileUpload runat="server" CssClass="fu" Width="250px" />
                </td>
            </tr>
        </table>
        <div>
            <br />
            <input type="button" id="btnSave" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/save.png');
                width: 80px; margin-right: 210px" onclick="Save('new')" />
        </div>
    </div>
    <div>
        <%--<ctl:ctlPopulations runat="server" ID="ctlPopulationsR" ShowItems="false" ShowCategories="false"
            isToShowAgents="false" isToShowCategories="false" isToShowItems="false" />--%>
    </div>
    </form>
    <script type="text/javascript">

        function SavePops() {
            /*   <%--      $('#aPop').text($('#<%=ctlPopulationsR.hdnPopsID %>').val());
            if ($('#aPop').text() == "") {
            $('#aPop').text("אוכלוסיות");
            }--%>*/
        }

        $('.tblBtns').width($('.dAlll').width() / 4 + "px");
        $('.img1').width($(window).width() / 12 + "px");
        $('.img1').height($(window).height() / 10 + "px");
        $('.tblBtns').width($('.dAlll').width() + "px");
        $('.ButtonsCls').width($('.dAlll').width() + "px");
        $('.dAlll').css("max-height", $(window).height() / 1.1 + "px");

        CloseObjEditBox();
        function ShowObjInit() {
            //SetInit();
            $('.ObjEditBox').show();
        }
        setTimeout("ShowObjInit();", 500);


        var CountTR = 0;
        var lastCounter = CountTR;
        var RowsAdded = 0;

        function getImgSrc() {
            var imgSrc = "excel.png";

            switch ($('.fu').val().substr($('.fu').val().length - 3, 3).toLowerCase()) {
                case "jpg":
                case "png":
                case "gif":
                    imgSrc = "../../img/pic.jpg";
                    break;
                case "xls":
                case "lsx":
                    imgSrc = "../../img/excel.png";
                    break;
                case "doc":
                case "ocx":
                    imgSrc = "../../img/Microsoft-word-logo.png";
                    break;
                case "pdf":
                    imgSrc = "../../img/pdfimage.png";
                    break;

            }
            return imgSrc;
        }
        function DelObj() {
            $('.SelectedObj').hide();
        }
        function Save(type) {
            if ($('.fu').val() != "") {
                var counter2 = 0;
                switch (type) {
                    case "new":
                        for (var i = 0; i < $('.tBody.td1').length; i++) {
                            var imgSrc = getImgSrc();

                            CountTR = lastCounter;
                            var cg = 0;
                            if ($('.tBody.td1')[i].innerText.trim() == $('#<%= ddlPops.ClientID%> option:selected').text().trim()) {
                                try {
                                    CountTR = $('.tBody.td1')[i].parentElement.children[1].children[0].children[0].children.length;
                                    if (CountTR > lastCounter) {
                                        $('.tBody.td1')[i].parentElement.children[1].children[0].children[0].children[$('.tBody.td1')[i].parentElement.children[1].children[0].children[0].children.length - 1].innerHTML += '<td class="obj" id="objt' + (CountTR * lastCounter).toString() + '"><img alt="" src="' + imgSrc + '" class="img1" /><br /><div class="MediaItem">' + $('#<%=txtName.ClientID %>').val() + '</div></td>';
                                        cg++;
                                    }
                                }
                                catch (e) {
                                }
                                if (cg == 0) {
                                    $('.tBody.td1')[i].parentElement.children[1].children[0].children[0].innerHTML += '<tr><td class="obj" id="objs' + (CountTR * lastCounter + RowsAdded).toString() + '"><img alt="" src="' + imgSrc + '" class="img1" /><br /><div class="MediaItem">' + $('#<%=txtName.ClientID %>').val() + '</div></td></tr>';
                                    RowsAdded++;
                                }
                                counter2++;
                                lastCounter = CountTR;
                                break;
                            }
                        }
                        if (counter2 == 0) {
                            $('.tBody.td1')[$('.tBody.td1').length - 1].parentElement.parentElement.innerHTML += "<tr><td class=\"tBody td1\">" + $('#<%= ddlPops.ClientID%> option:selected').text() + "</td><td class=\"tBody td2\"><table cellpadding=\"2\" cellspacing=\"2\"><tbody><tr><td class=\"obj\" id='objd" + (CountTR * lastCounter + RowsAdded).toString() + "'><img alt=\"\" src=\"" + imgSrc + "\" class=\"img1\" /><br /><div class=\"MediaItem\">" + $('#<%=txtName.ClientID %>').val() + "</div></td></tr></tbody></table></td></tr>";
                        }

                        break;

                    case "edit":
                        for (var i = 0; i < $('.tBody.td1').length; i++) {
                            var imgSrc = getImgSrc();

                            CountTR = lastCounter;
                            var cg = 0;
                            if ($('.tBody.td1')[i].innerText.trim() == $('#<%= ddlPops.ClientID%> option:selected').text().trim()) {
                                try {
                                    CountTR = $('.tBody.td1')[i].parentElement.children[1].children[0].children[0].children.length;
                                    $('.SelectedObj')[0].innerHTML = '<td class="obj" id="objt' + (CountTR * lastCounter).toString() + '"><img alt="" src="' + imgSrc + '" class="img1" /><br /><div class="MediaItem">' + $('#<%=txtName.ClientID %>').val() + '</div></td>';
                                    cg++;
                                }
                                catch (e) {
                                }
                                if (cg == 0) {
                                    //$('.tBody.td1')[i].parentElement.children[1].children[0].children[0].innerHTML += '<tr><td class="obj" id="objs' + (CountTR * lastCounter + RowsAdded).toString() + '"><img alt="" src="' + imgSrc + '" class="img1" /><br /><div class="MediaItem">' + $('#<%=txtName.ClientID %>').val() + '</div></td></tr>';
                                    RowsAdded++;
                                }
                                counter2++;
                                lastCounter = CountTR;
                                break;
                            }
                        }
                        if (counter2 == 0) {
                            $('.tBody.td1')[$('.tBody.td1').length - 1].parentElement.parentElement.innerHTML += "<tr><td class=\"tBody td1\">" + $('#<%= ddlPops.ClientID%> option:selected').text() + "</td><td class=\"tBody td2\"><table cellpadding=\"2\" cellspacing=\"2\"><tbody><tr><td class=\"obj\" id='objd" + (CountTR * lastCounter + RowsAdded).toString() + "'><img alt=\"\" src=\"" + imgSrc + "\" class=\"img1\" /><br /><div class=\"MediaItem\">" + $('#<%=txtName.ClientID %>').val() + "</div></td></tr></tbody></table></td></tr>";
                        }

                        break;
                }




                $('.tblBtns').width($('.dAlll').width() / 4 + "px");
                $('.img1').width($(window).width() / 12 + "px");
                $('.img1').height($(window).height() / 10 + "px");
                $('.tblBtns').width($('.dAlll').width() + "px");
                $('.ButtonsCls').width($('.dAlll').width() + "px");
                $('.dAlll').css("max-height", $(window).height() / 1.1 + "px");

                setClick();
            }
            else {
                if ($('#<%=txtName.ClientID %>').val().trim() == "")
                    alert("אנא הזן שם למסמך");
                else
                    alert("אנא בחר מסמך");
            }
        }

        function ObjClick(id) {
            $('.SelectedObj')[0].className = "obj";

            $('#' + id)[0].className = "obj SelectedObj";
        }

        function setClick() {
            for (var i = 0; i < $('.obj').length; i++) {
                $('.obj')[i].onclick = function () { ObjClick(this.id); };
            }
        }
        setClick();
        ddlid = '<%=ddlPops.ClientID %>';
    </script>
</body>
</html>
