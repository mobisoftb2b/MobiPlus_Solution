<%@ Page Title="MobiPlus - מונים" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="Numerators.aspx.cs" Inherits="Pages_Admin_Numerators" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-htable th div
        {
            height: 35px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="dGrid">
        <table>
            <tr>
                <td>
                    שנה ערכים ריקים ל:
                </td>
                <td>
                    <input type="text" id="txtAll" style="width: 80px;" maxlength="8"/>
                </td>
                <td>
                    <input type="button" id="btnSetAll" value="שנה הכל" onclick="SetAllNumerators();"/>
                </td>
            </tr>
        </table>
        <center>
            <div class="loadingDiv" style="">
                <div class="dLoadingBoxx">
                    <img src="../../Img/loading1.gif" width="50px" alt="Loading..." />
                    <br />
                    מעדכן נתונים...
                </div>
            </div>
            <table id="jQGrid">
            </table>
            <div id="jQGridPager">
            </div>
        </center>
    </div>
    <script type="text/javascript">
    function DisableWin()
    {            
        $('#dGrid').block({ message: '' });           
    }
    function Refresh() {
            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetNumerators",
                data: "{}",
                dataType: "json",
                type: "get",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
               
                    jQuery("#jQGrid").jqGrid('setGridParam', { data: data }).trigger('reloadGrid');
                    $('.loadingDiv').css("display","none");
                    $("#dGrid").unblock();
                }
            });

            //$('#jqGrid').setGridParam({ page: 1, datatype: "json", search: false }).trigger('reloadGrid');
        }
        var clcikk='';
        function ShowTXT(id,val,rowid,colName)
        {
            //try{
                if(val==-1)
                {
                    var row = $('#jQGrid').jqGrid('getRowData', rowid);
                    //debugger;
                    val = row[colName].substring(row[colName].indexOf('>')+1,row[colName].indexOf('</'));     
                    //debugger;                        
                }
                
                clcikk = $('#txt_' + id + '_' + rowid)[0].onclick;
                $('#txt_' + id + "_" + rowid)[0].onclick = "";
                $('#txt_' + id + "_" + rowid).html("<input type='text' maxlength='10' style='width:80px;' onblur='SetNumertor(" + id + ",this.value," + rowid + ",\"" + colName + "\");'  value='" + val + "' id='tttxt'" + id + "  class='tttxt" + id +'_'+ rowid + "' onkeydown='SetArrows("+id+","+rowid+",\""+colName+"\");' />");
                setTimeout('setTxtF('+rowid+','+id+');',50);
                setTxtF(rowid,id);
                SetFieldOnlyNumbers($('.tttxt' + id + "_" + rowid)[0].id);
            //}
            //catch(e)
            //{
            //}
        }
        function SetArrows(id,rowid,colName)
        {
        //debugger;
       // alert(event.keyCode);
            switch(event.keyCode)
            {
                case 40://down
                    ShowTXT(id,-1,rowid+1,colName);
                break;
                case 38://up
                    if(rowid-1>0)
                        ShowTXT(id,-1,rowid-1,colName);
                break;
                
                case 37://left arrow
                    var cm = $('#jQGrid').jqGrid("getGridParam", "colModel");
                    if(id==cm.length-1)
                    {
                        colName = cm[1].name;
                        ShowTXT(1,-1,rowid+1,colName);
                    }
                    else
                    {
                        colName = cm[id+1].name;
                        ShowTXT(id+1,-1,rowid,colName);
                    }
                     
                break;
                case 39://right arrow
                    var cm = $('#jQGrid').jqGrid("getGridParam", "colModel");
                    if(id==1)
                    {
                        colName = cm[cm.length-1].name;
                        ShowTXT(cm.length-1,-1,rowid-1,colName);
                    }
                    else
                    {
                        colName = cm[id-1].name;
                        ShowTXT(id-1,-1,rowid,colName);
                    }
                break;
            }
        }
        function setTxtF(rowid,id)
        {
            $('.tttxt' + id + "_" + rowid).select();
        }
        function SetNumertor(id,val,rowid,colName)
        {            
            var row = $('#jQGrid').jqGrid('getRowData', rowid);
            var agentID = row.AgentID.substring(row.AgentID.indexOf('>')+1,row.AgentID.indexOf('</'));
            var numertorGroup = colName.substring(colName.indexOf('-')+1,colName.length).toLocaleString().trim();

            var url="../../Handlers/MainHandler.ashx?MethodName=SetNumerator&AgentID=" + agentID + "&NumeratorGroup=" + numertorGroup + "&NumeratorValue=" + val;
            request = $.ajax({
                    url: url,
                    //contentType: "application/json; charset=utf-8",
                    type: "POST",
                    //data: "{'QueryStr':'"+escape(row.GraphQuery)+"'}"
                    data: ""
                
                });
                request.done(function (response, textStatus, jqXHR) {
                     $('#txt_' + id + '_' + rowid).html(val);
                     $('#txt_' + id + '_' + rowid)[0].onclick = clcikk;                     
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        $('#txt_' + id + '_' +  rowid).html(val);
                        $('#txt_' + id + '_' +  rowid)[0].onclick = clcikk;
                    }
                    else {
                        alert("Error");
                    }
                });
        }
        function SetAllNumerators()
        {
           if(!confirm("האם לבצע שינוי לכל הערכים הריקים?\n\nפעולה זו תערך מספר דקות."))
                return;
            
            DisableWin();   
            $('.loadingDiv').css("display","block");

            var url="../../Handlers/MainHandler.ashx?MethodName=SetAllNumerators&Value=" + $('#txtAll').val();
            request = $.ajax({
                    url: url,
                    //contentType: "application/json; charset=utf-8",
                    type: "POST",
                    //data: "{'QueryStr':'"+escape(row.GraphQuery)+"'}"
                    data: ""
                
                });
                request.done(function (response, textStatus, jqXHR) {
                     Refresh();                     
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        Refresh();                        
                    }
                    else {
                        alert("Error");
                        $('.loadingDiv').css("display","none");
                    }
                });
        }
        var GridID = "";
        var rid = "";
        function ShowGrid() {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetNumerators",
                datatype: "json",
                direction: "rtl",
                colNames: <%=colNames %>,
                colModel:<%=colModel %>,
                rowNum: 50,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: "נומרטורים",

                loadComplete: function (data) {
                    //setTimeout(initww, 5);
                    //initwData(data, $("#jQGrid"));
                },

                onSelectRow: function (id) {

                    rid = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
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
        ShowGrid();
        SetFieldOnlyNumbers('txtAll');
       // $('#nNumerators').attr("class", "menuLink Selected");
    </script>
</asp:Content>
