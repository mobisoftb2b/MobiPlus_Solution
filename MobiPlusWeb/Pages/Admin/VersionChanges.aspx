<%@ Page Title="ניהול גרסאות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="VersionChanges.aspx.cs" Inherits="Pages_Admin_VersionChanges" %>

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
        function CloseWinVersionItemBox() {

            $(".EditWinVersionItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBody").unblock();
        }
    </script>
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv
        {
            overflow-y: auto;
            overflow-x: hidden;
            max-height: 450px;
            min-height: 450px;
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
    <div>
        <div class="dProfileAll">
            <div class="txtPartsGridContainer" style="width: 700px; height: 600px">
                <div class="QueryHeader" style="height: 30px; font-size: 18px;">
                    <div class="QueryHeaderIn">
                        שינויים בגרסת עבודה</div>
                </div>
                <div class="PartsEdit" style="padding-right: 23px; padding-top: 15px;">
                    <div class="dPartItems">
                        <table id="jQGrid">
                        </table>
                        <div id="jQGridPager">
                        </div>
                        <div style="text-align: left; padding-top: 8px; padding-left: 20px;">
                            <input type="button" value="צור גרסה" class="MSBtnGeneral" style="background-image: url('../../Img/upload.png');
                                width: 100px;" onclick="OpenWinNewVersion();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="dProfileAll">
            <div class="txtPartsGridContainer" style="width: 700px; height: 600px">
                <div class="QueryHeader" style="height: 30px; font-size: 18px;">
                    <div class="QueryHeaderIn">
                        גרסאות</div>
                </div>
                <div class="PartsEdit" style="padding-right: 23px; padding-top: 15px;">
                    <div class="dPartItems">
                        <table id="jQGridVer">
                        </table>
                        <div id="jQGridPagerVer">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="dEditVersionItem" class="EditWinVersionItemBox">
        <div class="JumpWiX">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseWinVersionItemBox();" />
        </div>
        <div style="padding-top: 5px;">
            <center>
                <div id="sHeadEdit">
                    יצירת גרסה
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td class="EditForm item">
                    מספר גרסה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtVersionID" Width="150px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    שם גרסה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtVersionName" Width="150px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תאור גרסה:
                </td>
            </tr>
            <tr>
                <td class="EditForm val" colspan="2" style="padding-right: 5px;">
                    <asp:TextBox runat="server" ID="txtVersionDesc" Rows="4" TextMode="MultiLine" Width="250px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 80px;" onclick="SetNewVersion();" />
        </div>
    </div>
    <script type="text/javascript">
    function SetGrid() {
    
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=VerLayout_GetAllChanges&LayoutTypeID=<%=LayoutTypeID %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','דוח','תאור', 'משתמש אחרון', 'תאריך'],
                colModel: [ { name: 'ObjID', index: 'ObjID', width: 40, sorttype: 'int', align: 'right', editable: true },
                            { name: 'ObjType', index: 'ObjType', width: 100, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ObjName', index: 'ObjName', width: 190, sorttype: 'text', align: 'right', editable: true},
                            { name: 'LastUser', index: 'LastUser', width: 130, sorttype: 'text', align: 'right', editable: true },
                            { name: 'DateChange', index: 'DateChange', width: 170, align: 'right', editable: true,formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'G:i:s  d/m/Y ', defaultValue: null} }
                          
                           
                        ],
                rowNum: 20000,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,
                height:"400px",
                 
                loadComplete: function (data) {
                   
            },

                onSelectRow: function (id) {
                
                    
                },
                ondblClickRow: function (id) {

                   
                },
                
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: false,
                           add: false,
                           del: false,
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
        
        
        function returnMyLink(cellValue, options, rowdata, action) 
        {
            return "<a href='javascript:CheckForLoadVersion("+rowdata.VersionID+");'>טען גרסה</a>";
        }  
        function SetGridVer() {
            $("#jQGridVer").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=VerLayout_GetAllVersions&LayoutTypeID=<%=LayoutTypeID %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','גירסה','תאור', 'משתמש', 'תאריך','טען'],
                colModel: [ { name: 'VersionID', index: 'VersionID', width: 40, sorttype: 'int', align: 'right', editable: true },
                            { name: 'VersionName', index: 'VersionName', width: 100, sorttype: 'text', align: 'right', editable: true },
                            { name: 'VersionDescription', index: 'VersionDescription', width: 190, sorttype: 'text', align: 'right', editable: true},
                            { name: 'CreateBy', index: 'CreateBy', width: 70, sorttype: 'text', align: 'right', editable: true },
                            { name: 'VersionDate', index: 'VersionDate', width: 170, align: 'right', editable: true,formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'G:i:s  d/m/Y ', defaultValue: null} },
                            {name:'load_link', width: 50, formatter:returnMyLink}
                          
                           
                        ],
                rowNum: 20000,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPagerVer',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,
                height:"400px",
                 
                loadComplete: function (data) {
                   
            },

                onSelectRow: function (id) {
                
                    
                },
                ondblClickRow: function (id) {

                   
                },
                
            });

            $('#jQGridVer').jqGrid('navGrid', '#jQGridPagerVer',
                       {
                           edit: false,
                           add: false,
                           del: false,
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
        SetGridVer();    

        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
         function Refreshver() {
            $('#jQGridVer').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        function SetNewVersion() {  
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=VerLayout_SetNewVersion&VersionID="+$('#<%= txtVersionID.ClientID%>').val() + "&VersionName="+$('#<%= txtVersionName.ClientID%>').val()  
                + "&VersionDescription="+$('#<%= txtVersionDesc.ClientID%>').val() + "&LayoutTypeID=<%=LayoutTypeID %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                if(response=="True")
                {
                    CloseWinVersionItemBox();
                    RefreshMD();
                    Refreshver();
                    alert("הגרסה נשמרה בהצלחה");
                }
                else
                {
                    alert("אראה שגיאה בשמירת הנתונים - " + response);
                }
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")                    
                    {
                        CloseWinVersionItemBox();
                        RefreshMD();
                        Refreshver();
                        alert("הגרסה נשמרה בהצלחה");
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
        function OpenWinNewVersion()
        {
            $('#<%= txtVersionName.ClientID%>').val("");
            $('#<%= txtVersionDesc.ClientID%>').val("");

            SuggestNewVersionID();

            $('.EditWinVersionItemBox').css("display", "block");
                var top = 500;
                $(".EditWinVersionItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
                $('#dBody').block({ message: '' });
        }

        function SuggestNewVersionID() {  
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=VerLayout_SuggestNewVersionID&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%= txtVersionID.ClientID%>').val(response);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    $('#<%= txtVersionID.ClientID%>').val(jqXHR.responseText);
                }
                else {
                    alert("אראה שגיאה בשליפת הנתונים");
                    //alert("Error");
                }
            });
        }

        function CheckForLoadVersion(version)
        {
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=VerLayout_CheckForNewVersion&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                if(response=="0")// no changes
                {
                    SetReplaceWorkingLayout(version);
                }
                else if(response=="-1")//error
                {
                   alert("אראה שגיאה בשליפת הנתונים");
                }
                else
                {
                    if(confirm("ישנם "+response+" נתונים שאינם נשמרו לגרסה, האם להמשיך?"))
                    {
                        SetReplaceWorkingLayout(version);
                    }
                }
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                     if(jqXHR.responseText=="0")// no changes
                    {
                        SetReplaceWorkingLayout(version);
                    }
                    else if(jqXHR.responseText=="-1")//error
                    {
                       alert("אראה שגיאה בשליפת הנתונים");
                    }
                    else
                    {
                        if(confirm("ישנם "+jqXHR.responseText+" נתונים שאינם נשמרו לגרסה, האם להמשיך?"))
                        {
                            SetReplaceWorkingLayout(version);
                        }
                    }
                }
                else {
                    alert("אראה שגיאה בשליפת הנתונים");
                    //alert("Error");
                }
            });
        }

         function SetReplaceWorkingLayout(ToVersionID) {  
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=VerLayout_SetReplaceWorkingLayout&ToVersionID="+ ToVersionID +"&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                if(response=="True")
                    {
                        alert("הגרסה נטענה בהצלחה");
                         RefreshMD();
                    }
                    else
                    {
                        alert("אראה שגיאה בטעינת הנתונים; "+response);
                    }
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")
                    {
                        alert("הגרסה נטענה בהצלחה");
                         RefreshMD();                         
                    }
                    else
                    {
                        alert("אראה שגיאה בטעינת הנתונים; "+jqXHR.responseText);
                    }
                }
                else {
                    alert("אראה שגיאה בטעינת הנתונים");
                    //alert("Error");
                }
            });
        }


         SetFieldOnlyNumbers('<%=txtVersionID.ClientID %>');
        if ('<%=LayoutTypeID %>'=='1')
            $('#nDes').attr("class", "menuLink Selected");
        else
            $('#nWeb').attr("class", "menuLink Selected");
    </script>
</asp:Content>
