<%@ Page Title="ניהול תפריטים" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="MenusEdit.aspx.cs" Inherits="Pages_Admin_MenusEdit" %>

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
    <style type="text/css">
        .select
        {
            padding: 5px;
            font-size: 20px;
            border: 0px;
            -webkit-appearance: none;
            outline: none;
        }
        
        .styledDropDown1
        {
            float: right;
            height: 400px;
        }
        
        
        option1
        {
            background-color: #C9CBCD;
            width: 200px;
        }
    </style>
    <script type="text/javascript">

        function CloseWinMenuEdit() {

            $(".EditWinBoxEditMenu").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWinMenuItemEdit() {

            $(".EditWinMenuItemBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWindAllImgs() {

            $(".dAllImgs").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            //$("#dBody").unblock();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <div class="dAllMenus">
        <div class="dMenus">
            <div class="dMenuHeadLine">
                תפריטים</div>
            <asp:UpdatePanel runat="server" UpdateMode="Always">
                <ContentTemplate>
                    <asp:DropDownList runat="server" ID="ddlMenus" Width="194px" size="20" CssClass="styledDropDown select"
                        onchange="ShowGrid();">
                    </asp:DropDownList>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div>
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td>
                            <a href="javascript:ShowNewMenuWin();">חדש</a>
                        </td>
                        <td>
                            <a href="javascript:GetMenuData();">ערוך</a>
                        </td>
                        <td>
                            <a href="javascript:ShowDeleteMenuWin();">מחק</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="dMenuItems">
            <table id="jQGrid">
            </table>
            <div id="jQGridPager">
            </div>
        </div>
    </div>
    <div id="dMenuEdit" style="display: none;" class="EditWinBoxEditMenu">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinMenuEdit();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <span id="dEditMenuHead">עריכת תפריט </span>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    שם תפריט:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtMenuName" Width="220px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תאור:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtMenuDescription" Width="217px" TextMode="MultiLine"
                        Rows="3"></asp:TextBox>
                </td>
            </tr>
              <tr>
                <td class="EditForm item">
                    צפה כ:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlViewTypeDescription" Width="223px"></asp:DropDownList>
                </td>
            </tr>
        </table>
        <div id="div2" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" id="btnCloseForms" value="שמור" class="EditForm btn" onclick="SaveCurrentMenu();" />
        </div>
    </div>
    <div id="dEditMenuItem" style="display: none;" class="EditWinMenuItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinMenuItemEdit();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <span id="Span1">עריכת פריט בתפריט </span>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    תאור פריט:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtItemName" Width="220px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סוג זום לרכיב:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel runat="server" ID="upTabMSG" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlItemObjectType" Width="223px" OnSelectedIndexChanged="ddlItemObjectType_SelectedIndexChanged"
                                AutoPostBack="true">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    זום לרכיב:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel runat="server" ID="upddlHeaderZoomObjs" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlItemObjectID" Width="223px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תמונה:
                </td>
                <td class="EditForm val" style="height: 25px;">
                    <img src="" alt="" id="itemImg" style="cursor: pointer;" onclick="ShowAllImgs();" />
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סדר:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtItemOrder" Width="30px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" id="btnSaveItem" value="שמור" class="EditForm btn" onclick="SaveCurrentMenuItem('1');" />
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
        <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Button runat="server" ID="btnGetMenusData" OnClick="btnGetMenusData_Click" />
                <asp:Button runat="server" ID="btnGetMenuItemData" OnClick="btnGetMenuItemData_Click" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        var isNewMenu = false;
        var SelectedImg = "";
        var CurrentObjID = "";

        function ShowNewMenuWin() {
            isNewMenu = true;
            $("#dEditMenuHead").text("הוספת תפריט");
            $(".EditWinBoxEditMenu").css("display", "block");
            var top = "80";
            $(".EditWinBoxEditMenu").css({ top: top })
                        .animate({ "top": +top + "px" }, "high");

            $('#dBody').block({ message: '' });
        }
        function ShowDeleteMenuWin() {
            var LayoutTypeID="<%=LayoutTypeID %>";
            if (confirm("האם הנך בטוח ברצונך למחוק את התפריט הבחור?")) {
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetMenusForWeb&MenuID=" + $('#<%=ddlMenus.ClientID %>').val() + "&MenuName=" + escape($("#<%=txtMenuName.ClientID %>").val()) + "&MenuDescription=" + escape($("#<%=txtMenuDescription.ClientID %>").text()) + "&isActive=0"+ "&LayoutTypeID="+LayoutTypeID+ "&ViewType="+$("#<%=ddlViewTypeDescription.ClientID %>").val()
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "get",
                    data: ''
                });
                request.done(function (response, textStatus, jqXHR) {
                CloseWinMenuEdit();
                    $("#<%=btnGetMenusData.ClientID %>").click();
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                    CloseWinMenuEdit();
                        $("#<%=btnGetMenusData.ClientID %>").click();
                    }
                    else {
                        alert("Error");
                    }
                });
            }

            $('#dBody').block({ message: '' });
        }
        function SaveCurrentMenu() {
            var LayoutTypeID="<%=LayoutTypeID %>";
            var MenuID = $('#<%=ddlMenus.ClientID %>').val();

            if (isNewMenu) {
                MenuID = "0";
            }
            // debugger;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetMenusForWeb&MenuID=" + MenuID + "&MenuName=" + escape($("#<%=txtMenuName.ClientID %>").val()) + "&MenuDescription=" + escape($("#<%=txtMenuDescription.ClientID %>").text()) +$("#<%=ddlViewTypeDescription.ClientID %>").val()+ "&isActive=1"+ "&LayoutTypeID="+LayoutTypeID+ "&ViewType="+$("#<%=ddlViewTypeDescription.ClientID %>").val()
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                alert("success");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    CloseWinMenuEdit();
                    $("#<%=btnGetMenusData.ClientID %>").click();
                }
                else {
                    alert("Error");
                }
            });
        }
        function GetMenuData() {
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetMenuDataForWeb&MenuID=" + $('#<%=ddlMenus.ClientID %>').val()+"&LayoutTypeID=" + <%=LayoutTypeID %>
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                //debugger;
                $("#<%=txtMenuName.ClientID %>").val(response[0].MenuName);
                $("#<%=txtMenuDescription.ClientID %>").text(response[0].MenuDescription);
                $("#<%=ddlViewTypeDescription.ClientID %>").val(response[0].ViewType);
                ShowMenuEdit();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {

                }
                else {
                    alert("Error");
                }
            });
        }
        function ShowMenuEdit() {
            isNewMenu = false;
            $("#dEditMenuHead").text("עריכת תפריט");
            //debugger;
            $(".EditWinBoxEditMenu").css("display", "block");
            var top = "80";
            $(".EditWinBoxEditMenu").css({ top: top })
                        .animate({ "top": +top + "px" }, "high");

            $('#dBody').block({ message: '' });
        }
        function doNone() {
            return false;
        }
        function initwData(data, objMain) {
            $(".ui-pg-div").click(doNone);
            $("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMD;
            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMD;
            $("#del_jQGrid")[0].children[0].onclick = ShowDeleteFormMD;
            $("#search_jQGrid")[0].children[0].onclick = ShowSearchFormMD;
            $("#refresh_jQGrid")[0].children[0].onclick = RefreshMD;
        }
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        var ridmd = "0";
        function ShowEditFormMD() {
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר רכיב מן הגריד תחילה.");
                return;
            }
            if (ridmd != "") {
                IsAddMD = false;
                SetMenuItemData();
                $('.EditWinMenuItemBox').css("display", "block");
                var top = 500;
                $(".EditWinMenuItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });
            }
            else {
                alert("אנא בחר פריט");
            }
            return false;
        }
        function ShowAddFormMD() {
            IsAddMD = true;
            SetMenuItemDataNew();
            $('.EditWinMenuItemBox').css("display", "block");
            var top = 500;
            $(".EditWinMenuItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר רכיב מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את הרכיב המסומן מן הגריד?")) {
                SaveCurrentMenuItem('0');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function imageFormat(cellvalue, options, rowObject) {
            return '<img src="data:image/png;base64,' + cellvalue + '" />';
        }
        function imageUnFormat(cellvalue, options, cell) {
            return $('img', cell).attr('src');
        }

        function SetGrid(id) {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetMenuItemsForGridWeb&MenuID=" + $('#<%=ddlMenus.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#', 'תיאור', 'סוג זום', 'רכיב זום', 'תמונה', 'סדר'],
                colModel: [{ name: 'MenuItemID', index: 'MenuItemID', width: 100, sorttype: 'int', align: 'right', editable: true },
                            { name: 'Description', index: 'Description', width: 170, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ZoomObjType', index: 'ZoomObjType', width: 100, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ZoomObject', index: 'ZoomObject', width: 100, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ImgReal', index: 'ImgReal', width: 150, sorttype: 'text', align: 'center', editable: true, formatter: imageFormat, unformat: imageUnFormat },
                            { name: 'SortOrder', index: 'SortOrder', width: 70, sorttype: 'text', align: 'right', editable: true }
                        ],
                rowNum: 25,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                 
                loadComplete: function (data) {
                var grid = $("#jQGrid"),
                ids = grid.getDataIDs();

                for (var i = 0; i < ids.length; i++) {
                    grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
                }

                initwData(data, $("#jQGrid"));
            },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    ridmd = row["MenuItemID"];
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    ridmd = row["MenuItemID"];
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
                           viewtext: "צפה"
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
        function ShowGrid() {
            ridmd = "0";
            $("#jQGrid").jqGrid('GridUnload');
            SetGrid($('#<%=ddlMenus.ClientID %>').val());
        }

        var ImgID = "0";
        function SetMenuItemData() {
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetMenuItemData&MenuItemID=" + ridmd
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
           
                $('#<%=txtItemName.ClientID %>').val(response[0].Description);
                $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=" + response[0].ImgID;
                SelectedImg = response[0].ImgID;
                $('#<%= txtItemOrder.ClientID %>').val(response[0].SortOrder);
                $('#<%= ddlItemObjectType.ClientID %>').val(response[0].ZoomObjTypeID);
                CurrentObjID = response[0].ZoomObjectID;
                $('#<%= btnGetMenuItemData.ClientID %>')[0].click();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                
                }
                else {
                    alert("Error");
                }
            });
        }
        function SetMenuItemDataNew() {
            $('#<%=txtItemName.ClientID %>').val("");
            $('#itemImg')[0].src = "../../Handlers/ShowImage.ashx?id=1";
            SelectedImg = "0";
            $('#<%= txtItemOrder.ClientID %>').val("");
            $('#<%= ddlItemObjectType.ClientID %>').val("0");
            CurrentObjID = "0";
        }
        function SaveCurrentMenuItem(isActive) {
            var ZoomObj = $('#<%=ddlItemObjectID.ClientID %>').val();
            if (ZoomObj == "" || !ZoomObj)
                ZoomObj = "0";

            if(!SelectedImg || SelectedImg=="")
                SelectedImg="0";

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetMenuItem&MenuItemID=" + ridmd + "&MenuID=" + $('#<%=ddlMenus.ClientID %>').val() + "&Description=" + escape($('#<%=txtItemName.ClientID %>').val()) + "&ZoomObjTypeID=" + $('#<%=ddlItemObjectType.ClientID %>').val()
                            + "&ZoomObjectID=" + ZoomObj + "&ImgID=" + SelectedImg + "&SortOrder=" + $('#<%=txtItemOrder.ClientID %>').val() + "&IsActive=" + isActive
                            + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    ShowGrid();
                }
                else {
                    alert("Error");
                }
            });

            CloseWinMenuItemEdit();
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
        function SetObj() {
            $('#<%= ddlItemObjectID.ClientID %>').val(CurrentObjID);
        }

        $('#<%=txtItemOrder.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });

        if ('<%=LayoutTypeID %>'=='1')
            $('#nDes').attr("class", "menuLink Selected");
        else
            $('#nWeb').attr("class", "menuLink Selected");
    </script>
</asp:Content>
