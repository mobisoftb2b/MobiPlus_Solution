<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocManagement.aspx.cs" Inherits="Pages_Compield_DocManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
    <script src="../../js/FileSaver.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <style type="text/css">
        .DocMFile {
            margin: 10px;
            text-align: center;
            vertical-align: central;
            height: 150px;
            width: 310px;
            float: right;
            background-color: lightgray;
            -webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
            -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
            box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);
            color: black;
            font-size: 14px;
            position: relative;
        }

        .Oc {
            font-size: 12px;
            position: absolute;
            bottom: 35px;
            right: 5px;
        }

        .btn {
            font-size: 14px;
            position: absolute;
            bottom: 5px;
            left: 5px;
            height: 40px;
            width: 40px;
        }

        .btnAdd {
            font-size: 24px;
            position: absolute;
            bottom: 5px;
            left: 5px;
            height: 50px;
            width: 50px;
        }

        .btnAct {
            font-size: 14px;
            height: 30px;
            width: 60px;
        }

        .Desc {
            padding-top: 10px;
            padding-right: 50px;
            direction: ltr;
            text-align: right;
            max-width: 80%;
            font-size: 16px;
            color: black;
        }

        .MObj {
        }

        .txt {
            width: 180px;
        }

        .txt2 {
            width: 182px;
        }

        .dOC {
            background-color: white;
            height: 320px;
            overflow-y: scroll;
            overflow-x: hidden;
            text-align: right;
            width: 90%;
            margin-right: 10px;
        }

        .OCName {
            margin-right: 15px;
            font-weight: 700;
        }

        .dBtns {
            text-align: left;
            padding-left: 5px;
            padding-top: 10px;
        }

        #myModalLabel {
            font-size: 18px;
            font-weight: 700;
        }

        .NameF {
            width: 100%;
            text-align: left;
            direction: ltr;
            margin: -5px;
            position: absolute;
            bottom: 10px;
            font-size: 12px;
        }

        .Link {
            width: 100%;
            text-align: left;
            direction: ltr;
            float: left;
            width: 30px;
        }

        .borderCenter {
            border-right: 1px solid gray;
        }
        .FilterHead
        {
            padding:5px;
            border-bottom:1px solid gray;
        }
        .ddlFilter
        {
            width:100px;
        }
        .dDir
        {
            overflow-y:auto;
            overflow-x:hidden;
        }
    </style>
    <script type="text/javascript">
        function CloseEditBoxPopup() {
            ShowEditBox();
        }

    </script>
</head>
<body id="dBodyr" onload="try{setTimeout('parent.CloseLoading();',10);}catch(e){}">
    <form id="form1" runat="server">
        <div class="dAllPage">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top">
                        <div class="FilterHead">סנן</div>
                        <div runat="server" id="dFilter" style="width:100px;">
                        </div>
                    </t>
                    <td valign="top">
                        <div runat="server" id="dDir" class="dDir">
                        </div>
                    </td>
                </tr>
            </table>

            <div class='btn'>
                <input value=' + ' class='btnAdd' type='button' id='btnAdd' onclick="AddDoc();" />
            </div>
        </div>
        <div>
            <div id="EditBox" runat="server" style="display: none;" class="ImgEditBoxED Boxee">
                <div class="modal-header2">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                    <div id="myModalLabel">עריכת מסמך</div>
                    <h5 style="color: red;" id="errMsg"></h5>
                </div>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top">
                            <table cellpadding="2" cellspacing="2">
                                <tr>
                                    <td>בחר מסמך: </td>
                                    <td>
                                        <asp:FileUpload runat="server" ID="FileUpload1" CssClass="fuImgMedia" onnkeyup="SetName(this.value);" onmouseup="SetName(this.value);" onblur="SetName(this.value);" /></td>
                                </tr>
                                <tr>
                                    <td style="width: 70px">שם מסמך:
                                    </td>
                                    <td>
                                        <input type="text" id="txtFileName" class="txt2" readonly="readonly" />
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">תאור:
                                    </td>
                                    <td>
                                        <textarea class="txt" style="height: 70px;" rows="4" cols="1" id="txtDesc"></textarea>
                                    </td>
                                </tr>

                            </table>
                        </td>
                        <td class="borderCenter">&nbsp;
                        </td>
                        <td style="width: 220px;">
                            <div class="OCName">
                                אוכלוסיות
                            </div>
                            <div>
                                <input type="checkbox" id="cbAll" style="margin-right: 13px;" onchange="cbAllChecked(this.checked);" />
                            </div>
                            <div id="dOC" class="dOC" runat="server">
                            </div>
                            <div class="dBtns">
                                <asp:HiddenField runat="server" ID="hdnIsUpload" Value="0" />
                                <asp:Button runat="server" ID="btnFileUpload" Style="display: none;" OnClick="FileUpload_Click" />
                                <input runat="server" value='אישור' class='btnAct' type='button' id='btnOK' onclick="SetDocManagement('0');" />
                                <input value='מחק' class='btnAct' type='button' id='btnDel' onclick="SetDocManagement('1');" />
                            </div>
                        </td>
                    </tr>
                </table>


            </div>

        </div>
        <asp:HiddenField runat="server" ID="hdnObjectsTypeID" Value="1" />
        <asp:HiddenField runat="server" ID="hdnPre" Value="1" />
        <asp:HiddenField runat="server" ID="hdnDoc" Value="" />
        <asp:Button runat="server" ID="btnShowFile" Style="display: none;" OnClick="btnShowFile_Click" />
    </form>
    <script type="text/javascript">
        var DocManagementID = "0";
        var Objects = "";
        var isAdd = true;
        function ShowEditBox() {
            if (isAdd) {
                DocManagementID = "0";
                $('#myModalLabel').html("הוספת מסמך");
                $('#btnDel').hide();
            }
            else {
                $('#myModalLabel').html("עריכת מסמך");
                $('#btnDel').show();

            }
            if ($('#EditBox')[0].style.display == 'none') {
                $('#EditBox').show('fast');
                $('#dBodyr').block({ message: '' });
            }
            else {
                $('#EditBox').hide('fast');
                $("#dBodyr").unblock();
            }
        }
        function EditDoc(val, FileName, FileDesc, strOc) {

            DocManagementID = val;
            isAdd = false;

            $('#txtFileName').val(unescape(FileName));
            $('#txtDesc').val(unescape(FileDesc));

            var arr = strOc.split(',');

            for (var i = 0; i < $('.OCT').length ; i++) {
                $('.OCT')[i].checked = false;
            }

            for (var l = 0; l < arr.length; l++) {
                if (arr[l] != "") {
                    for (var i = 0; i < $('.OCT').length ; i++) {
                        if (arr[l] == $('.OCT')[i].value)
                            $('.OCT')[i].checked = true;
                    }
                }
            }

            ShowEditBox();
        }
        function AddDoc() {
            for (var i = 0; i < $('.OCT').length ; i++) {
                $('.OCT')[i].checked = false;
            }

            $('#txtFileName').val("");
            $('#txtDesc').val("");

            DocManagementID = "0";
            isAdd = true;
            ShowEditBox();
        }

        function SetDocManagement(isToDelete) {

            $('#<%=hdnIsUpload.ClientID%>').val("1");

            Objects = "";
            for (var i = 0; i < $('.OCT').length; i++) {
                if ($('.OCT')[i].checked)
                    Objects += $('.OCT')[i].value + ",";
            }

            if (Objects == "") {
                alert("אנא בחר אוכלוסיות");
                return false;
            }
            else if ($('#<%=FileUpload1.ClientID%>').val() == "" && $('#txtFileName').val() == "") {
                alert("אנא בחר מסמך");
                return false;
            }
            else if ($('#txtDesc').val() == "") {
                alert("אנא הזן תיאור למסמך");
                return false;
            }
            else if ('<%=FilePrefixes%>'.indexOf($('#<%=FileUpload1.ClientID%>').val().split('.')[$('#<%=FileUpload1.ClientID%>').val().split('.').length - 1]) == -1) {
                alert("סוג המסמך שנבחר אינו נתמך, אנא בחר מסמך אחר");
                return false;
            }

            gisToDelete = isToDelete;
            SetD();
            $('#btnFileUpload')[0].click();
           
            
        }
        var gisToDelete;
        function SetD() {
            var isToDelete = gisToDelete;
             $('#<%=hdnIsUpload.ClientID%>').val("1");

            Objects = "";
            for (var i = 0; i < $('.OCT').length; i++) {
                if ($('.OCT')[i].checked)
                    Objects += $('.OCT')[i].value + ",";
            }

            if (Objects == "") {
                alert("אנא בחר אוכלוסיות");
                return false;
            }
            else if ($('#<%=FileUpload1.ClientID%>').val() == "" && $('#txtFileName').val() == "") {
                alert("אנא בחר מסמך");
                return false;
            }
            else if ($('#txtDesc').val() == "") {
                alert("אנא הזן תיאור למסמך");
                return false;
            }
            else if ('<%=FilePrefixes%>'.indexOf($('#<%=FileUpload1.ClientID%>').val().split('.')[$('#<%=FileUpload1.ClientID%>').val().split('.').length - 1]) == -1) {
                alert("סוג המסמך שנבחר אינו נתמך, אנא בחר מסמך אחר");
                return false;
            }

             var request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetDocManagement&DocManagementID=" + DocManagementID + "&FileName=" + escape($('#txtFileName').val()) + "&FileDesc=" + escape($('#txtDesc').val())
    + "&ObjectsTypeID=" + $("#<%=hdnObjectsTypeID.ClientID%>").val() + "&IsToDelete=" + isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: 'Objects=' + escape(Objects)
            });
            request.done(function (response, textStatus, jqXHR) {
                CloseEditBoxPopup();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True") {
                        CloseEditBoxPopup();
                    }
                    else {
                        alert("אראה שגיאה בשמירת הנתונים - " + jqXHR.responseText);
                    }
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                    //alert("Error");
                }
            });
        }
        function SetName(val) {
            $('#txtFileName').val(val.split('\\')[val.split('\\').length - 1]);
        }
        function openDoc(doc) {
            $('#<%=hdnPre.ClientID%>').val(doc);
            $('#<%=hdnDoc.ClientID%>').val(doc);
            $('#<%=btnShowFile.ClientID%>')[0].click();
        }
        function cbAllChecked(checked) {
            for (var i = 0; i < $('.OCT').length ; i++) {
                $('.OCT')[i].checked = checked;
            }
        }
        function setFilter(txt)
        {
            for (var i = 0; i < $('.Oc').length ; i++) {
                $('.Oc')[i].parentElement.style.display = "none";
                if ($('.Oc')[i].innerText.indexOf(txt) > -1 || txt=='0')
                    $('.Oc')[i].parentElement.style.display = "block";

            }
        }
        $('.ddlFilter').height($(window).height()-24);
        $('.dAllPage').height($(window).height());
        $('.dDir').height($(window).height());
    </script>
</body>
</html>

