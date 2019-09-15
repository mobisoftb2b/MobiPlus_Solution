<%@ Page Title="עריכת פרופילים" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="EditProfiles.aspx.cs" Inherits="Pages_Admin_EditProfiles" enableEventValidation="false"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css">
    <script src="../../js/jquery-1.11.0.min.js"></script>
    <script src="../../js/jquery-1.10.2.js"></script>
    <script src="../../js/jquery-ui.js"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/NewMain.css" />
    <script type="text/javascript">
        function CloseWinProfilesItemBox() {

            $(".EditWinProfilesItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
        function CloseWinUsersItemBox() {

            $(".EditWinUsersItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
    </script>
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv
        {
            overflow-y: auto;
            min-height: 480px;
        }
        .ui-jqgrid-titlebar
        {
            background-color: #E2E3E4;
        }
        .ui-jqgrid-sortable
        {
            font-size: 14px;
            font-weight: 700;
        }
        .ui-pg-table
        {
            background-color: #E2E3E4;
            font-size: 14px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <div class="dProfileAll">
        <div class="txtPartsGridContainer" style="width: 580px; height: 600px">
            <div class="QueryHeader" style="height: 30px; font-size: 18px;">
                <div class="QueryHeaderIn">
                    פרופילים</div>
            </div>
            <div class="PartsEdit" style="padding-right: 23px; padding-top: 15px;">
                <div class="dPartItems">
                    <table id="jQGrid">
                    </table>
                    <div id="jQGridPager">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="dProfileAll">
        <div class="txtPartsGridContainer" style="width: 540px; height: 600px">
            <div class="QueryHeader" style="height: 30px; font-size: 18px;">
                <div class="QueryHeaderIn">
                    משתמשים</div>
            </div>
            <div class="PartsEdit" style="padding-right: 23px; padding-top: 15px;">
                <div class="dPartItems">
                    <table id="jQGridUsers">
                    </table>
                    <div id="jQGridPagerUsers">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="dEditProfilesItem" class="EditWinProfilesItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinProfilesItemBox();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <div id="sHeadEdit">
                    עריכת קשר לפרופיל
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    סוג:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlProfileTypes" Width="150px" onchange="ddlProfileTypes_change();SetProfileType();">
                            </asp:DropDownList>
                            <asp:HiddenField runat="server" ID="hdnProfileTypeID" Value="1" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <%--<tr id="rAgent" style="display:none;">
                <td class="EditForm item">
                    שם פרופיל:
                </td>
                <td class="EditForm val">
                    
                    <asp:TextBox runat="server" ID="ddlAgentProfile" Width="146px" style="display:none;"></asp:TextBox>
                </td>
            </tr>--%>
            <tr id="Tr5">
                <td class="EditForm item">
                    פרופיל:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlProfiles" Width="150px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:TextBox runat="server" ID="ddlAgentProfile" Width="146px" Style="display: none;"></asp:TextBox>
                </td>
            </tr>
              <tr id="Tr6">
                <td class="EditForm item">
                    מכשיר:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlLayoutTypeID" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="Tr4" style="display: none;">
                <td class="EditForm item">
                    סוג:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlProfileType" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="rCustomer" style="display: none;">
                <td class="EditForm item">
                    פרופיל לקוח:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlCustomerProfile" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    טופס:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlForms" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תפריט:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlMenues" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="trOrder">
                <td class="EditForm item">
                    תפריט הזמנה:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlOrderMenu" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="trRecipt">
                <td class="EditForm item">
                    תפריט קבלה:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlReceiptMenu" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 80px;" onclick="SetProfileData('0');" />
            <asp:HiddenField runat="server" ID="hdnridmd" />
        </div>
    </div>
    <div id="EditWinUsersItemBox" class="EditWinUsersItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinUsersItemBox();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <div id="Div2">
                    עריכת משתמש
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr id="Tr1">
                <td class="EditForm item">
                    משתמש:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtUserID" Width="146px"></asp:TextBox>
                </td>
            </tr>
            <tr id="Tr2">
                <td class="EditForm item">
                    שם:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtUserName" Width="146px"></asp:TextBox>
                </td>
            </tr>
            <tr id="Tr3" style="display: none;">
                <td class="EditForm item">
                    תאור:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtUserDesc" Width="146px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סיסמה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtPass" Width="146px" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    אימות סיסמה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtPass2" Width="146px" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    פרופיל:
                </td>
                <td class="EditForm val">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                            <asp:DropDownList runat="server" ID="ddlProfilestoUser" Width="150px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
        <div id="div4" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 80px;" onclick="SetUserData('0');" />
            <asp:HiddenField runat="server" ID="hdnUserProfileID" Value="0" />
            <asp:HiddenField runat="server" ID="hdnMPUserID" Value="0" />
            <span style="display: none;">
                <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Button runat="server" ID="btnGetAll" OnClick="GetAllClick" />
                        <asp:Button runat="server" ID="btnGetProfiles" OnClick="btnGetProfiles_Click" />
                        <asp:HiddenField runat="server" ID="hdnPrID"/>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </span>
        </div>
    </div>
    <script type="text/javascript">
    function initwData(data, objMain) {
            $(".ui-pg-div").click(doNone);

            $("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMD;

            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMD;

            $("#del_jQGrid")[0].children[0].onclick = ShowDeleteFormMD;

            $("#search_jQGrid")[0].children[0].onclick = ShowSearchFormMD;

            $("#refresh_jQGrid")[0].children[0].onclick = RefreshMD;
        }
        function initwDataUsers(data, objMain) {
            $(".ui-pg-div").click(doNone);

            $("#edit_jQGridUsers")[0].children[0].onclick = ShowEditFormMDUsers;

            $("#add_jQGridUsers")[0].children[0].onclick = ShowAddFormMDUsers;

            $("#del_jQGridUsers")[0].children[0].onclick = ShowDeleteFormMDUsers;

            $("#search_jQGridUsers")[0].children[0].onclick = ShowSearchFormMDUsers;

            $("#refresh_jQGridUsers")[0].children[0].onclick = RefreshMDUsers;
        }
        var ridmdUsers="0";
        function ShowEditFormMDUsers() {
            if(ridmdUsers=="0" || ridmdUsers =="") {
                alert("אנא בחר משתמש מן הגריד תחילה.");
                return;
            }
            if (ridmdUsers != "") {
            
                $('#<%=ddlProfilestoUser.ClientID %>').val(Row["AgentProfileID"]);
                $('#<%=txtUserID.ClientID %>').val(Row["UserName"]);
                $('#<%=txtUserName.ClientID %>').val(Row["Name"]);
                
                $('#<%=txtUserDesc.ClientID %>').val(Row["Description"]);
                $('#<%=txtPass.ClientID %>').val("");
                $('#<%=txtPass2.ClientID %>').val("");
                 $('#<%=hdnUserProfileID.ClientID %>').val(Row["UserProfileID"]);
                 $('#<%=hdnMPUserID.ClientID %>').val(Row["UserID"]);

                ddlProfileTypes_change();
                IsAddMD = false;
                $('.EditWinUsersItemBox').css("display", "block");
                var top = 500;
                $(".EditWinUsersItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });
            }
            else {
                alert("אנא בחר משתמש");
            }
            return false;
        }
        var IsAddMDUser = true;
        function ShowAddFormMDUsers() {
            $('#<%=ddlProfilestoUser.ClientID %>').val("-1");
            $('#<%=txtUserID.ClientID %>').val("");
            $('#<%=txtUserName.ClientID %>').val("");
            $('#<%=txtUserDesc.ClientID %>').val("");
            $('#<%=txtPass.ClientID %>').val("");
            $('#<%=txtPass2.ClientID %>').val("");
             $('#<%=hdnUserProfileID.ClientID %>').val("0");             

            ridmdUsers="0";
            IsAddMDUser = true;
            $('.EditWinUsersItemBox').css("display", "block");
            var top = 500;
            $(".EditWinUsersItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function ShowDeleteFormMDUsers() {
            if(ridmdUsers=="0" || ridmdUsers =="") {
                alert("אנא בחר משתמש מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את המשתמש המסומן מן הגריד?")) {
                SetUserData('1');
            }
        }
         function ShowSearchFormMDUsers() {
            $("#jQGridUsers").searchGrid({ closeAfterSearch: false });
        }
         function RefreshMDUsers() {
            $('#jQGridUsers').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }

        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        var ridmd="0";
        function ShowEditFormMD() {
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר פרופיל מן הגריד תחילה.");
                return;
            }
            if (ridmd != "") {
                //$('#<%=ddlProfileTypes.ClientID %>').val("-1");
                $('#<%=ddlCustomerProfile.ClientID %>').val(Row["ProfileID"]);
                $('#<%=ddlProfileTypes.ClientID %>').val(Row["ProfileTypeID"]);
                //$('#<%=ddlProfileTypes.ClientID %>').val(Row["ProfileTypeID"]);
                $('#<%=ddlAgentProfile.ClientID %>').val(Row["ProfileName"]);
                $('#<%=ddlCustomerProfile.ClientID %>').val(Row["CustomerProfileID"]);
                $('#<%=ddlMenues.ClientID %>').val(Row["MenuID"]);
                $('#<%=ddlForms.ClientID %>').val(Row["FormID"]);
                
                $('#<%=hdnPrID.ClientID %>').val(Row["ProfileID"]);
                $('#<%=ddlProfiles.ClientID %>').val(Row["ProfileID"]);

                $('#<%=ddlOrderMenu.ClientID %>').val(Row["OrderMenuID"]);
                $('#<%=ddlReceiptMenu.ClientID %>').val(Row["ReceiptMenuID"]);
                
                $('#<%=ddlLayoutTypeID.ClientID %>').val(Row["LayoutTypeID"]);

                

                ddlProfileTypes_change();
                IsAddMD = false;
                $('.EditWinProfilesItemBox').css("display", "block");
                var top = 500;
                $(".EditWinProfilesItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });

                SetProfileType();
            }
            else {
                alert("אנא בחר פרופיל");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMD() {
            //$('#<%=ddlProfileTypes.ClientID %>').val("-1");
            $('#<%=ddlAgentProfile.ClientID %>').val("");
            $('#<%=ddlCustomerProfile.ClientID %>').val("-1");
            $('#<%=ddlMenues.ClientID %>').val("-1");
            $('#<%=ddlForms.ClientID %>').val("-1");

            $('#<%=ddlOrderMenu.ClientID %>').val("-1");
            $('#<%=ddlReceiptMenu.ClientID %>').val("-1");

            $('#<%=ddlLayoutTypeID.ClientID %>').val("-1");

            $('#<%=ddlProfiles.ClientID %>').val("0");

            ridmd="0";
            IsAddMD = true;
            //SetColItemDataNew();
            $('.EditWinProfilesItemBox').css("display", "block");
            var top = 500;
            $(".EditWinProfilesItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBody').block({ message: '' });
        }
        function ShowDeleteFormMD() {
            
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר פרופיל מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את הפרופיל המסומן מן הגריד?")) {
                SetProfileData('1');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function doNone() {
            return false;
        }
        var Row;
    function SetGrid() {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetProfileComponents&LayoutTypeID=<%=LayoutTypeID %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','סוג', 'פרופיל',  'ת. ראשי','טופס',  'ת. הזמנה',  'ת. קבלה','ProfileTypeID','AgentProfileID','CustomerProfileID','OrderMenuID','ReceiptMenuID','MenuID','FormID','ProfileID','LayoutTypeID'],//'פרופיל לקוח',
                colModel: [ { name: 'ProfileComponentsID', index: 'ProfileComponentsID', width: 50, sorttype: 'int', align: 'right', editable: true },
                            { name: 'ProfileType', index: 'ProfileType', width: 70, sorttype: 'text', align: 'right', editable: true},
                            { name: 'ProfileName', index: 'ProfileName', width: 80, sorttype: 'text', align: 'right', editable: true },
//                            { name: 'CustomerProfileName', index: 'CustomerProfileName', width: 120, sorttype: 'text', align: 'right', editable: true },
                            { name: 'MenuName', index: 'MenuName', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'FormName', index: 'FormName', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'OrderMenu', index: 'OrderMenu', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ReceiptMenu', index: 'ReceiptMenu', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ProfileTypeID', index: 'ProfileTypeID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'AgentProfileID', index: 'AgentProfileID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'CustomerProfileID', index: 'CustomerProfileID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'OrderMenuID', index: 'OrderMenuID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'ReceiptMenuID', index: 'ReceiptMenuID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'MenuID', index: 'MenuID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'FormID', index: 'FormID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},
                            { name: 'ProfileID', index: 'ProfileID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},
                            { name: 'LayoutTypeID', index: 'LayoutTypeID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true}
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
                toppager: false,
                 
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
                    Row = row;
                    ridmd = row["ProfileComponentsID"];                    
                    
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    Row = row;
                   ridmd = row["ProfileComponentsID"];
                   
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
        SetGrid();
         function SetGridUsers() {
            $("#jQGridUsers").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetUsersProfileComponents&LayoutTypeID=<%=LayoutTypeID %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#',  'משתמש','שם','תאור','סיסמה','פרופיל','UserID','AgentProfileID','UserID2','ProfileID'],
                colModel: [ { name: 'ProfileComponentsID', index: 'ProfileComponentsID', width: 50, sorttype: 'int', align: 'right', editable: true ,hidden:true},
                            { name: 'UserName', index: 'UserName', width: 80, sorttype: 'int', align: 'right', editable: true },
                            { name: 'Name', index: 'Name', width: 120, sorttype: 'text', align: 'right', editable: true },
                            { name: 'Description', index: 'Description', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},                            
                            { name: 'Password', index: 'Password', width: 0, sorttype: 'int', align: 'right', editable: true},
                            { name: 'ProfileName', index: 'ProfileName', width: 120, sorttype: 'text', align: 'right', editable: true },
                            { name: 'UserProfileID', index: 'UserProfileID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},
                            { name: 'AgentProfileID', index: 'AgentProfileID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},
                            { name: 'UserID', index: 'UserID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true},
                            { name: 'ProfileID', index: 'ProfileID', width: 0, sorttype: 'int', align: 'right', editable: true,hidden:true}                         
                          
                        ],
                rowNum: 70,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPagerUsers',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,
                 
                loadComplete: function (data) {
                    var grid = $("#jQGridUsers"),
                    ids = grid.getDataIDs();

                    for (var i = 0; i < ids.length; i++) {
                        grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
                    }

                    initwDataUsers(data, $("#jQGridUsers"));
            },

                onSelectRow: function (id) {

                    //ridmd = id;

                    var row = $('#jQGridUsers').jqGrid('getRowData', id);
                    Row = row;
                    ridmdUsers = row["UserProfileID"];
                    $('#<%=hdnUserProfileID.ClientID %>').val(row["UserProfileID"]);
                    
                },
                ondblClickRow: function (id) {

                    var row = $('#jQGridUsers').jqGrid('getRowData', id);
                    Row = row;
                   ridmdUsers = row["UserProfileID"];
                   
                    ShowEditFormMDUsers();
                },
                
            });

            $('#jQGridUsers').jqGrid('navGrid', '#jQGridPagerUsers',
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

                               var sel_id = $('#jQGridUsers').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGridUsers').jqGrid('getCell', sel_id, 'id');

                               return value;
                           },
                           GraphID: function () {

                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";

                               var sel_id = $('#jQGridUsers').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGridUsers').jqGrid('getCell', sel_id, 'GraphID');

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

                                   $("#jQGridUsers").trigger("reloadGrid", [{ current: true}]);
                                   return [false, response.responseText]
                               }
                               else {
                                   $(this).jQGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               GraphID: function () {

                                   var sel_id = $('#jQGridUsers').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGridUsers').jqGrid('getCell', sel_id, 'GraphID');
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
        SetGridUsers();


        function SetUserData(isToDelete) {  
            var LayoutTypeID = "<%=LayoutTypeID %>";
            
            if(isToDelete=='0' && ($('#<%=txtPass.ClientID %>')[0].value.length==0 || $('#<%=txtPass.ClientID %>').val()!=$('#<%=txtPass2.ClientID %>').val()))
            {
                alert("אנא הזן סיסמה ואימות סיסמה זהה");
                return;
            }
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetUserData&UserID=" + $('#<%=txtUserID.ClientID %>').val() + "&Description="+ $('#<%=txtUserDesc.ClientID %>').val() + "&UserName="+ $('#<%=txtUserID.ClientID %>').val()
                + "&Password="+ $('#<%=txtPass.ClientID %>').val() + "&Profileid="+ $('#<%=ddlProfilestoUser.ClientID %>').val()+ "&UserProfileID="+ $('#<%=hdnUserProfileID.ClientID %>').val() + "&MPUserID="+ $('#<%=hdnMPUserID.ClientID %>').val() 
                 + "&Name="+  $('#<%=txtUserName.ClientID %>').val() + "&IsToDelete="+ isToDelete + "&LayoutTypeID="+ LayoutTypeID  + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                CloseWinUsersItemBox();
                 
                RefreshMDUsers();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")                    
                    {
                        CloseWinUsersItemBox();
                       
                        RefreshMDUsers();
                    }
                    else
                    {
                        alert("אראה שגיאה בשמירת הנתונים - " + jqXHR.responseText);
                    }
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                    //alert("Error");
                }
            });
        }

        function SetProfileData(isToDelete) {  
//        if($('#<%=ddlProfileTypes.ClientID %>').val()=="-1" && isToDelete=="0")
//        {
//            alert("אנא בחר סוג פרופיל");
//            return;
//        }
       
        if($('#<%=ddlProfiles.ClientID %>').val()=="" && isToDelete=="0")
        {
            alert("אנא בחר פרופיל לסוכן");
            return;
        }
//        else if($('#<%=ddlCustomerProfile.ClientID %>').val()=="-1" && $('#<%=ddlProfileTypes.ClientID %>').val()=="2" && isToDelete=="0")
//        {
//            alert("אנא בחר פרופיל ללקוח");
//            return;
//        }

        var LayoutTypeID = $('#<%=ddlLayoutTypeID.ClientID %>').val();//"<%=LayoutTypeID %>";

        var ProfileName  = $('#<%=ddlLayoutTypeID.ClientID %>').val();
//        if($('#<%=ddlProfileTypes.ClientID %>').val()=="2")//customer
//            ProfileID  = $('#<%=ddlCustomerProfile.ClientID %>').val();

/*OrderMenuID"].ToString(), context.Request["ReceiptMenuID*/
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetProfileData&ProfileComponentsID=" + ridmd + "&ProfileTypeID="+ $('#<%=ddlProfileTypes.ClientID %>').val() + "&ProfileName="+ ProfileName
                + "&FormLayoutID="+ $('#<%=ddlForms.ClientID %>').val() + "&MenuID="+ $('#<%=ddlMenues.ClientID %>').val() + "&ProfileID="+ $('#<%=ddlProfiles.ClientID %>').val()
                + "&IsToDelete="+ isToDelete + "&LayoutTypeID="+ LayoutTypeID  
                + "&OrderMenuID="+ $('#<%=ddlOrderMenu.ClientID %>').val() 
                + "&ReceiptMenuID="+ $('#<%=ddlReceiptMenu.ClientID %>').val() 
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                CloseWinProfilesItemBox();
                $('#<%=btnGetAll.ClientID %>').click();
                RefreshMD();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")                    
                    {
                        CloseWinProfilesItemBox();
                        $('#<%=btnGetAll.ClientID %>').click();
                        RefreshMD();
                    }
                    else
                    {
                        alert("אראה שגיאה בשמירת הנתונים - " + jqXHR.responseText);
                    }
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים");
                    //alert("Error");
                }
            });
        }

        function ddlProfileTypes_change()
        {
           // $('#rCustomer').show();
            $('#rAgent').show();
            $('#trOrder').show();
            $('#trRecipt').show();
            
            if($('#<%=ddlProfileTypes.ClientID %>').val()=="1")//agent
            {
                $('#rCustomer').hide();
                $('#trOrder').hide();
                $('#trRecipt').hide();
            }
            else
            {
                $('#rAgent').hide();                
            }
           
        }
        function SetProfileType()
        {
         $('#<%=hdnProfileTypeID.ClientID %>').val($('#<%=ddlProfileTypes.ClientID %>').val());
            $('#<%=btnGetProfiles.ClientID %>').click();
        }
         
        $('#<%=ddlProfileTypes.ClientID %>').val("1");
        ddlProfileTypes_change();
       if ('<%=LayoutTypeID %>'=='1')
            $('#nDes').attr("class", "menuLink Selected");
        else
            $('#nWeb').attr("class", "menuLink Selected");
    </script>
</asp:Content>
