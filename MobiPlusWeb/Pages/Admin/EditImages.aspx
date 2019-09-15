<%@ Page Title="ניהול תמונות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="EditImages.aspx.cs" Inherits="Pages_Admin_EditImages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
    <link rel="stylesheet" href="../../css/jquery-ui-1.9.2.custom.css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function CloseWinImageItemEdit() {

            $(".EditWinImageItemBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWindAllImgs() {

            $(".dAllImgs").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            //$("#dBody").unblock();
        }
    </script>
    <style type="text/css">
    
.ui-jqgrid .ui-jqgrid-bdiv
        {
            overflow-y: auto;
            overflow-x: hidden;
            background-color:White;
           
        }
        .ui-widget-header
        {
            background-color: #244062 !important;
        }
        .ui-jqgrid-titlebar
        {
            background-color: #E2E3E4;
        }
        .ui-jqgrid-sortable
        {
            font-size: 12px;
            font-weight: 600;
            color: White !important;
            font: 14px 'Segoe UI' , 'Helvetica Neue' , 'Droid Sans' ,Arial,Tahoma,Geneva,Sans-serif;
            background-color: #F7AF38 !important;
            border: none !important;
            min-height: 100%;
        }
        
        .ui-pg-table
        {
            background-color: #E3E3E3;
            font-size: 14px;
            text-align:right;
            direction:ltr;
        }
        
        .footrow
        {
            font-weight: 500 !important;
        }
        .footrow-rtl
        {
            font-weight: 500 !important;
        }
        .ui-jqgrid-ftable
        {
            font-weight: 500 !important;
            background-color: White !important;
            color: Gray !important;
            border-top:1px solid gray;
        }
        .ui-widget-content
        {
            background: none !important;
            color: Gray !important; /*background-color: #EDEDED !important;*/
        }
        .ui-row-rtl
        {
            background-color: white !important;
        }
        .ui-priority-secondary /*alt*/
        {
            filter: alpha(opacity=100) !important;
            -moz-opacity: 1 !important;
            -khtml-opacity: 1 !important;
            opacity: 1 !important;
            background-color: #ECECEC !important;
        }
        th.ui-th-column div
        {
            white-space: normal !important;
            height: auto !important;
            padding: 2px;
        }
        .ui-jqgrid tr.jqgrow td
        {
            white-space: normal !important;
        }
        
        .grid-col
        {
            padding: 2px !important;
            /*color: black !important;*/
            font: 14px 'Segoe UI' , 'Helvetica Neue' , 'Droid Sans' ,Arial,Tahoma,Geneva,Sans-serif;
            border-left: none !important;
        }
        .ui-widget-header
        {
            background-color: #E8E9ED !important;
            color: #7C7C7C;
            height: 22px;
            font: 14px 'Segoe UI' , 'Helvetica Neue' , 'Droid Sans' ,Arial,Tahoma,Geneva,Sans-serif;
            font-weight: 600;
        }
        .ui-jqgrid-resize.ui-jqgrid-resize-rtl
        {
            display: none !important;
        }
        .ui-jqgrid tr.ui-row-rtl td
        {
            border-left: none !important;
        }
        .ui-jqgrid .ui-jqgrid-view
        {
            font: 14px 'Segoe UI' , 'Helvetica Neue' , 'Droid Sans' ,Arial,Tahoma,Geneva,Sans-serif;
        }
        .dPartItems
        {
            background-color: #EDEDED;
        }
        .pgNum
        {
            border:1px solid black;
            text-align:center;
            padding-left:5px;
            padding-right:5px;
            font: 14px 'Segoe UI' , 'Helvetica Neue' , 'Droid Sans' ,Arial,Tahoma,Geneva,Sans-serif;
        }
        #jQGridPager_center
        {
            /*display:none;*/
        }
        #searchmodfbox_jQGrid
        {
            background-color:gray !important;
        }
         .ui-paging-info
        {
            display:none;
        }
        .ui-widget-content.ui-state-highlight
        {
            background-color:#E3E3E3 !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <img src="" alt="" id="Img1" style="cursor: pointer;" onclick="ShowAllImgs();" />
    <div style="padding: 10px; ">
        <div style="font-size:24px;padding-right:250px;">
            עריכת תמונות
        </div>
        <br />
        <div class="dImageItems" >
            <table id="jQGrid" >
            </table>
            <div id="jQGridPager">
            </div>
        </div>
    </div>
    <div id="dEditImageItem" style="display: none;" class="EditWinImageItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinImageItemEdit();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <span id="sHeadEdit">עריכת תמונה </span>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    שם תמונה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtItemName" Width="220px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    גובה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtImageHeight" Width="50px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    רוחב:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtImageWidth" Width="50px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תמונה:
                </td>
                <td class="EditForm val" style="height: 25px;">
                    <img src="" alt="" id="itemImg" style="cursor: pointer;" 
                        width="25x" />
                    &nbsp;
                    <asp:FileUpload runat="server" Width="185px" ID="fuImg" onchange="SetImgBySrc();" />
                </td>
            </tr>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" id="btnSaveItem" value="שמור" class="EditForm btn" onclick="SaveCurrentImageItem('1');" />
            <asp:HiddenField runat="server" ID="hdnridmd"/>
        </div>
    </div>
    <div id="dAllImgs" class="dAllImgs" runat="server" style="">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWindAllImgs();" />
        </div>
        <br />
        <br />
    </div>
    <div style="display: none;">
        <asp:Button runat="server" ID="btnUploadImg" OnClick="btnUploadImg_Click" />
    </div>
    <script type="text/javascript">
    var ridmd = "0";
    

    function doNone() {
            return false;
        }
    function initwData(data, objMain) {            
            $("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMD;
            $("#edit_jQGrid_top")[0].children[0].onclick = ShowEditFormMD;

            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMD;
            $("#add_jQGrid_top")[0].children[0].onclick = ShowAddFormMD;

            $("#del_jQGrid")[0].children[0].onclick = ShowDeleteFormMD;
            $("#del_jQGrid_top")[0].children[0].onclick = ShowDeleteFormMD;

            $("#search_jQGrid")[0].children[0].onclick = ShowSearchFormMD;
            $("#search_jQGrid_top")[0].children[0].onclick = ShowSearchFormMD;

            $("#refresh_jQGrid")[0].children[0].onclick = RefreshMD;
            $("#refresh_jQGrid_top")[0].children[0].onclick = RefreshMD;
            

        }
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        function imageFormat(cellvalue, options, rowObject) {
            return '<img src="data:image/png;base64,' + cellvalue + '" />';
        }
        function imageUnFormat(cellvalue, options, cell) {
            return $('img', cell).attr('src');
        }
        
        function ShowEditFormMD() {
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר תמונה מן הגריד תחילה.");
                return;
            }
            if (ridmd != "") {
                IsAddMD = false;
                SetImageItemData();
                $('.EditWinImageItemBox').css("display", "block");
                var top = 500;
                $(".EditWinImageItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });
            }
            else {
                alert("אנא בחר פריט");
            }
            return false;
        }
        function ShowAddFormMD() {
            $("#<%= hdnridmd.ClientID%>").val(ridmd);
            IsAddMD = true;
            SetImageItemDataNew();
            $('.EditWinImageItemBox').css("display", "block");
            var top = 500;
            $(".EditWinImageItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר תמונה מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את התמונה המסומן מן הגריד?")) {
                SaveCurrentImageItem('0');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        var ImgID = "0";
        var SelectedImg = "0";
        function SetImageItemData() {

            request = $.ajax({            
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetImageData&ImgID=" + ridmd
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=txtItemName.ClientID %>').val(response[0].ImgName);
                $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=" + response[0].ImgID;
                SelectedImg = response[0].ImgID;
                $('#<%= txtImageHeight.ClientID %>').val(response[0].ImgHeight);
                $('#<%= txtImageWidth.ClientID %>').val(response[0].ImgWidth);                
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {

                }
                else {
                    alert("Error");
                }
            });
        }
        function SetImageItemDataNew() {
           $('#<%=txtItemName.ClientID %>').val("");
                $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=1";
                SelectedImg = "1";
                $('#<%= txtImageHeight.ClientID %>').val("25px");
                $('#<%= txtImageWidth.ClientID %>').val("25px");  
        }
        function SaveCurrentImageItem(isActive) { 
            var LayoutTypeID="<%=LayoutTypeID %>";         
            if(!SelectedImg || SelectedImg=="")
                SelectedImg="0";
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetImage&ImgID=" + $("#<%= hdnridmd.ClientID%>").val() +"&ImgName=" + escape($('#<%=txtItemName.ClientID %>').val()) +"&ImgExtension=png&ImgHeight="+$('#<%= txtImageHeight.ClientID %>').val()+"&ImgWidth="+$('#<%= txtImageWidth.ClientID %>').val()+"&IsActive="+isActive+"&LayoutTypeID="+LayoutTypeID
                            + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });

            request.done(function (response, textStatus, jqXHR) {
                RefreshMD();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    RefreshMD();
                }
                else {
                    alert("Error");
                }
            });

            CloseWinImageItemEdit();
        }
        function SetGrid() {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetImagesForGrid&LayoutTypeID=<%=LayoutTypeID %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#', 'שם', 'גובה', 'רוחב', 'תמונה'],
                colModel: [{ name: 'ImgID', index: 'ImgID', width: 100, sorttype: 'int', align: 'right', editable: true },
                            { name: 'ImgName', index: 'ImgName', width: 170, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ImgHeight', index: 'ImgHeight', width: 100, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ImgWidth', index: 'ImgWidth', width: 100, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ImgReal', index: 'ImgReal', width: 250, sorttype: 'text', align: 'center', editable: true, formatter: imageFormat, unformat: imageUnFormat }                            
                        ],
                rowNum: 70,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: true,
                 
                loadComplete: function (data) {
                var grid = $("#jQGrid"),
                ids = grid.getDataIDs();

                for (var i = 0; i < ids.length; i++) {
                    grid.setRowData(ids[i], false, { height : 50 + (10) });
                }

                initwData(data, $("#jQGrid"));
            },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    ridmd = row["ImgID"];
                    $("#<%= hdnridmd.ClientID%>").val(ridmd);
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                   ridmd = row["ImgID"];
                   $("#<%= hdnridmd.ClientID%>").val(ridmd);
                    ShowEditFormMD();
                },
                
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "חיפוש",
                           addtext: "הוסף",
                           edittext: "ערוך",
                           deltext: "מחק",
                           refreshtext: "רענן",
                           viewtext: "צפה",
                           cloneToTop:true
                       },
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
                       {   //EDIT
                       //                       height: 300,
                       //                       width: 400,
                       //                       top: 50,
                       //                       left: 100,
                       //                       dataheight: 280,
                       closeOnEscape: true, //Closes the popup on pressing escape key
                       reloadAfterSubmit: true,
                       closeAfterEdit: true,
                       clearAfterAdd: true,
                       drag: true,
                       afterSubmit: function (response, postdata) {

                           if (response.responseText.indexOf('בהצלחה') > -1)
                               ShowMSGT();
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [false, response.responseText]//Captures and displays the response text on th Edit window
                           }
                           $("#sData")[0].style.display = "block";

                       },

                       editData: {
                           id: function () {
                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";

                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');

                               return value;
                           },
                           GraphID: function () {

                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";

                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'GraphID');

                               return value;
                           },
                           GroupID: function () {

                               return getCellGroupNameValue();
                           },
                           Grids: function () {
                               return getCellGridsValue();
                           }
                       }
                   },
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
                       {
                       closeAfterAdd: true, //Closes the add window after add

                       afterSubmit: function (response, postdata) {
                           if (response.responseText.indexOf('בהצלחה') > -1)
                               ShowMSGT();
                           $("#cData")[0].innerText = "Close";
                           $("#sData")[0].style.display = "none";
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [false, response.responseText]
                           }
                       }
                   },
                       {   //DELETE
                           closeOnEscape: true,
                           closeAfterDelete: true,
                           reloadAfterSubmit: true,
                           closeOnEscape: true,
                           drag: true,
                           afterSubmit: function (response, postdata) {
                               if (response.responseText == "") {

                                   $("#jQGrid").trigger("reloadGrid", [{ current: true}]);
                                   return [false, response.responseText]
                               }
                               else {
                                   $(this).jQGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               GraphID: function () {

                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'GraphID');
                                   alert(value);
                                   return value;

                                   return value;
                               }
                           }
                       },
                       {//SEARCH
                           closeOnEscape: true

                       }
                );
        }
        function ShowAllImgs() {
            $('#<%= dAllImgs.ClientID%>').css("display", "block");
            var top = 500;
            $("#<%= dAllImgs.ClientID%>").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            //$('#dBody').block({ message: '' });
        }


        function SetImg(id) {
            $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=" + id;
            SelectedImg = id;
            CloseWindAllImgs();
        }
        function SetImgBySrc()
        {
            $('#<%=btnUploadImg.ClientID %>').click();
        }
        function ShowImgFormUpload()
        {
            $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?UploadImg=true";

            $('.EditWinImageItemBox').css("display", "block");
            
            $('#dBody').block({ message: '' });
        }
        SetGrid();

        if ('<%=LayoutTypeID %>'=='1')
            $('#nDes').attr("class", "menuLink Selected");
        else
            $('#nWeb').attr("class", "menuLink Selected");

        $('.ui-jqgrid-bdiv').css("max-height",$(window).height()-230+"px");
    </script>
</asp:Content>
