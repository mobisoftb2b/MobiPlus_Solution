<%@ Page Title="MobiPlus Manager - בקשות להרשאות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="GridRequests.aspx.cs" Inherits="pages_GridRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function closeWin(id) {
            var top = 100;
            $("#" + id).css({ top: top })
                    .animate({ "top": "-500" }, "slow");

        }
        function formatCell(cellValue, options, rowdata, action) {
            return unescape("\"" + cellValue + "\"");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>   
        <table cellpadding="2" cellspacing="2">
            <tr>
                <td>
                    בקשות:        
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="ddlRequests" onchange="GetData();">
                        <asp:ListItem Selected="True" Text="חדשות" Value="0"></asp:ListItem>
                        <asp:ListItem Text="מאושרות" Value="2"></asp:ListItem>
                        <asp:ListItem Text="נדחו" Value="3"></asp:ListItem>
                        <asp:ListItem Text="בוטלו" Value="1001"></asp:ListItem>
                        <asp:ListItem Text="כולן" Value="7"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    תקופה:
                </td>
                <td>
                    <asp:RadioButton runat="server" ID="rbToday" Text="יומי" Checked="true" onclick="GetData();" GroupName="g1"/>
                    &nbsp;
                    <asp:RadioButton runat="server" ID="rbHistory" Text="הסטורייה" onclick="GetData();" GroupName="g1"/>
                </td>
            </tr>
        </table>
        

    </div>
    <div style="margin-top: 30px;height:100%;" id="dGrid">
        <center>
            <table id="jQGrid">
            </table>
            <div id="jQGridPager">
            </div>
        </center>
    </div>
    <center>
        <div id="ItemEdit" class="ItemEditBox">
            <div class="ItemEditX">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfuly();" />
            </div>
            <div class="ItemEditHead">
                בקשה חדשה
            </div>
            <div class="ItemEditTbl">
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="ItemEdit item">
                            סוכן
                        </td>
                        <td class="ItemEdit val">
                            <asp:Label runat="server" ID="lblAgent"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="ItemEdit item">
                            עובד
                        </td>
                        <td class="ItemEdit val">
                            <asp:Label runat="server" ID="lblEmploy"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="ItemEdit item">
                            נושא פעילות
                        </td>
                        <td class="ItemEdit val">                            
                            <asp:Label runat="server" ID="lblMainCon"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="ItemEdit item">
                            לקוח
                        </td>
                        <td class="ItemEdit val">
                            <asp:Label runat="server" ID="lblCustomer"></asp:Label>
                        </td>
                    </tr>
                     <tr>
                        <td class="ItemEdit item">
                            נושא
                        </td>
                        <td class="ItemEdit val">
                           <asp:Label runat="server" ID="lblSubjectDescription"></asp:Label> 
                        </td>
                    </tr>
                    <tr>
                        <td class="ItemEdit item">
                            הערה
                        </td>
                        <td class="ItemEdit val">
                           <asp:Label runat="server" ID="lblComment"></asp:Label> 
                        </td>
                    </tr>
                    <tr>
                        <td class="ItemEdit item">
                            הערת מנהל
                        </td>
                        <td class="ItemEdit val">
                            <asp:TextBox runat="server" ID="txtManagerComment" Rows="2" Width="220px" TextMode="MultiLine"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div class="dBtns">
                    <center>
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td>
                                    <input type="button" id="btnOK" value="מאשר" class="ItemEdit btn" onclick="SendReplay('2');SetManagerData('2',$('#<%=txtManagerComment.ClientID %>    ')[0].innerText);"/>
                                </td>
                                <td>
                                    <input type="button" id="btnCancel" value="לא מאשר" class="ItemEdit btn"  onclick="SendReplay('3');SetManagerData('3',$('#<%=txtManagerComment.ClientID %>    ')[0].innerText);"/>
                                </td>
                            </tr>
                        </table>
                    </center>
                </div>
            </div>
        </div>
    </center>

     <center>
        <div id="divManual" class="ManualBox">
            <div class="ManualX">
                <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfulyManual();" />
            </div>
            <div class="ManualHead">
                סיסמה ידנית
            </div>
            <div class="ManualTbl">
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="Manual item">
                            סוכן
                        </td>
                        <td class="Manual val">
                            <input type="text" id="txtManualAgent" style="width:120px;" onkeypress="CheckForEnterAndFocusNextField(event,'<%=ddlMainCon.ClientID %>');" onfocus="RemovePass();"/>
                            
                        </td>
                    </tr>                   
                    <tr>
                        <td class="Manual item">
                            נושא פעילות
                        </td>
                        <td class="Manual val">
                            <asp:DropDownList runat="server" ID="ddlMainCon"></asp:DropDownList>
                            <%--<input type="text" id="txtManualAction" style="width:120px;" onkeypress="CheckForEnterAndFocusNextField(event,'txtManualCustomer');" onfocus="RemovePass();"/>   --%>                         
                        </td>
                    </tr>
                    <tr>
                        <td class="Manual item">
                            לקוח
                        </td>
                        <td class="Manual val">
                            <input type="text" id="txtManualCustomer" style="width:120px;" onkeypress="CheckForEnterAndFocusNextField(event,'txtManualReq');" onfocus="RemovePass();"/>                            
                        </td>
                    </tr>
                     <tr>
                        <td class="Manual item">
                            מזהה בקשה
                        </td>
                        <td class="Manual val">
                            <input type="text" id="txtManualReq" style="width:120px;" onkeypress="CheckForEnter(event,$('#btnManualCreatePass'));" onfocus="RemovePass();"/>                            
                        </td>
                    </tr>
                   
                </table>
                <div class="divPass">
                
                </div>
                <div class="dBtns">
                    <center>
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td>
                                    <input type="button" id="btnManualCreatePass" value="צור סיסמה" class="Manual btn" onclick="SetNewPass();"/>
                                </td>
                            </tr>
                        </table>
                    </center>
                </div>
            </div>
        </div>
    </center>
    <script language="javascript" type="text/javascript">
        function PassFormatter(cellValue, options, rowObject) {
            return "********";
        }
        var RequsetID="";
        

        function GetData()
        {    
            var Period="1";
      
            if($('#<%= rbHistory.ClientID%>')[0].checked)
            Period="2";
            
        $("#jQGrid").jqGrid('GridUnload');       
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetManagerGridData&RequestStatus=" + $('#<%= ddlRequests.ClientID%>').val() + "&Period=" + Period + "&Tiks="+(((new Date()).getTime() * 10000) + 621355968000000000),//GetManagerGridData(context, SessionUserID, context.Request["RequestStatus"].ToString(), context.Request["Period"].ToString());
                direction: "rtl",
                datatype: "json",
                colNames: <%=colNames %>,
                colModel: <%= colModel%>,
                rowNum: 30,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: "בקשות להרשאה",
                autodecode: true,

                onSelectRow:function(id) {
                        var row = $('#jQGrid').jqGrid('getRowData', id);
                        if(row.styleicon1==0)
                        {
                            RequsetID=row.RequestID;
                            DisableWin();
                            setData(id);
                            $('.ItemEditBox').css("display","block");
                            var top =500;  
                            $("#ItemEdit").css({top:top})  
                            .animate({"top":"100px"}, "slow");
                        }
                    },
                loadComplete: function(data) {
                //debugger;
           
                        setTimeout(initww,50);
                        try
                        {
                            //if(data[0].AgentCode)
                            {
                                dddata=data;
                                if(data.rows)
                                    dddata=data.rows;
                                initwData(dddata,$("#jQGrid"));                    
                            }
                        }
                        catch(e)
                        {
                            initwData(dddata,$("#jQGrid"));         
                        }
                    
                    }
                /*editurl: 'http://<%=HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port.ToString() %>/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=AddEdit'*/
            });
        
            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: false,
                           add: false,
                           del: false,
                           search: true,
                           refresh:false,
                           searchtext: "חיפוש",
                           addtext: "Add",
                           edittext: "Edit",
                           deltext: "Delete"
                       },
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
                               if (response.responseText == "") {

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [true, '']
                               }
                               else {
                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [false, response.responseText]//Captures and displays the response text on th Edit window
                               }
                           },
                           editData: {
                               id: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');
                                   return value;
                               }
                           }
                       },
                       {
                           closeAfterAdd: true, //Closes the add window after add
                           afterSubmit: function (response, postdata) {
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
                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               EmpId: function () {
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, '_id');
                                   return value;
                               }
                           }
                       },
                       {//SEARCH
                           closeOnEscape: true

                       }
                );

                $(".ui-jqgrid-bdiv").css("height","650px");
            }
            function initww()
            {             
                $(".loading")[0].innerText="טוען נתונים ...";
                $(".loading").css("display", "block");
                $('.ui-jqgrid-titlebar').css("padding-left",<%=GridWidth.ToString() %> - "<%=Caption %>".length*5.0 - 25 * 1.0 +"px");      
                setTimeout("stopLoading();",500);
            }
            function stopLoading()
            {
                $(".loading").css("display", "none");
            }

            var ColSelected = '';
            var ColSelected2 = '';
            var dddata;
            var colID=0;
            function initwData(data,objMain)
            {     
            //debugger;
            $('#jqgh_jQGrid_GridIcon')[0].innerHTML="<img alt='רענן' src='../../img/refresh.png' onclick='Refresh();' class='imgRef' />";
            
           

            //debugger;
                dddata=data
                if(data.rows)
                    dddata=data.rows;
                data = dddata;
               try{
                    
                    if(ColSelected=="")// && ColSelected2=="")
                    {
                    $.each(dddata[0], function (key, value) {
                    
                        if(key)
                        {
                            if(key.toLocaleString().indexOf('stylecolor')>-1)
                            {
                                if(key.toLocaleString().indexOf('stylecolor_')>-1)
                                {
                                    if(ColSelected=='')
                                        ColSelected = key.toLocaleString().substr(key.toLocaleString().indexOf('stylecolor_')+11,key.toLocaleString().length - (11 + key.toLocaleString().indexOf('stylecolor_')));
                                }
                            }
                            if(ColSelected=='')
                                colID++;
                       }
                    });
                  }
              
                if(data[0])
                {
                    for (var i = 0; i < data.length; i++) {
                        var obj = data[i];
                        if(obj['stylecolor_'+ColSelected])
                        {
                            if(obj['stylecolor_'+ColSelected]=='1')
                            {      
                                colID = 0;
                                var j=0;
                                $.each(data[0], function (key, value) {
                               
                                    if(key.toLocaleString().indexOf(ColSelected)>-1 && colID==0)              
                                        colID=j;
                                    j++;
                                });
                                setBGcolorsForCol(i+1,colID+1,obj.color,objMain);
                            }
                        
                        }
                        else
                        {
                            var t=0;
                            if(obj['stylecolor']=='1')
                            {
                                $.each(data[0], function (key, value) {                          
                                    setBGcolorsForCol(i+1,t,obj.color,objMain);
                                    t++;
                                });
                            }
                        }
                    }
                }
                else
                {
                    for (var i = 0; i < data.rows.length; i++) {
                        var obj = data.rows[i];
                        if(obj['stylecolor_'+ColSelected])
                        {
                            if(obj['stylecolor_'+ColSelected]=='1')
                            {      
                                colID = 0;
                                var j=0;
                                $.each(obj, function (key, value) {    
                                    if(key.toLocaleString().indexOf(ColSelected)>-1 && colID==0)              
                                        colID=j;
                                    j++;
                                });
                                setBGcolorsForCol(i+1,colID,obj.color,objMain);
                            }
                        
                        }
                        else
                        {
                            var t=0;
                            if(obj['stylecolor']=='1')
                            {
                                $.each(data.rows[0], function (key, value) {                          
                                    setBGcolorsForCol(i+1,t,obj.color,objMain);
                                    t++;
                                });
                            }
                        }
                    }
                }
                 
                var ColSelected2='';
                var colID=0;
                if(data[0])
                {
                    $.each(data[0], function (key, value) {
                    
                        if(key.toLocaleString().indexOf('styleicon1')>-1)
                        {
                            ColSelected2 = key;
                        }
                        if(ColSelected2=='')
                            colID++;
                    });
                    try{
                   // debugger;
                         for (var i = 0; i < data.length; i++) {
                            var obj = data[i];
                           // if(obj['styleicon1'])
                            {
                                //if(obj['styleicon1']=='1')
                                {      
                                    colID = 0;
                                    var j=0;
                           
                                    setIconToRow(i+1,0,obj.Icon,objMain,obj);
                                }
//                                else
//                                {
//                                    setIconToRow(i+1,0,obj.Icon,objMain,obj);
//                                }
                        
                            }                    
                        }
                    }
                    catch(e)
                    {
                    }
                }

                else
                {
                    $.each(data.rows[0], function (key, value) {
                    
                        if(key.toLocaleString().indexOf('styleicon1')>-1)
                        {
                            ColSelected2 = key;
                        }
                        if(ColSelected2=='')
                            colID++;
                    });
                    //debugger;
                    try{
                    for (var i = 0; i < data.rows.length; i++)
                      {
                        var obj = data.rows[i];
                        //if(obj['styleicon1'])
                        {
                            //if(obj['styleicon1']=='1')
                            {      
                                colID = 0;
                                var j=0;
                           
                                setIconToRow(i+1 ,0,obj.Icon,objMain,obj);
                            }
//                            else
//                            {
//                                setIconToRow(i+1 ,0,obj.Icon,objMain,obj);
//                            }
                        }                    
                    }
                     }
                    catch(e)
                    {
                    var t=1;
                    }
                }
               
               
                }
              catch(e)
              {
              var t=1;
              }
              SetFotter();
            }
         function setBGcolorsForCol(row,col,color,obj)
         {
            obj.setCell (row,col,'',{ 'background-color':color});
         }  
          function setBGcolorsForAllCol(col,color)
          {
             for (var i = 1; i <= $("#jQGrid").getGridParam("reccount"); i++) {
                $('#jQGrid').setCell (i,col,'',{ 'background-color':color});
             }    
         }
        
          function setIconToRow(row,col,iconr,obj,dobj)
         {//debugger;
                var icon = '';
                switch(dobj.styleicon1)
                {
                    case "0":
                        icon = 'url(\"../../img/QuestionMark.png"\)';
                        break;
                    case "1":                        
                    case "2":
                        icon = 'url(\"../../img/V.png"\)';                       
                        break;
                    case "3":                       
                    case "1001":
                        icon = 'url(\"../../img/X.png"\)';
                        break;                           
                }
                obj.setCell (row,col,'',{ 'background-image':icon});
                obj.setCell (row,col,'',{ 'background-repeat':'no-repeat'});
                obj.setCell (row,col,'',{ 'background-position':'center'});                
         }
         function changeTitle(cellVal, options, rowObject){
         
                 var tooltip = '';
                switch(rowObject.styleicon1)
                {
                    case "0":
                        tooltip ='חדש';
                        break;
                    case "1":
                        tooltip ='מאושר';
                        break;
                    case "2":
                        tooltip ='לא מאושר';
                        break;                           
                }

            return  "<div title='"+tooltip+"'>&nbsp;</div>";

        }
         function Refresh()
         {
            GetData();
            //$('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
         }
         setInterval("Refresh();",300000);

         var AgentID="0";
         var requestId="0";
         function setData(id)
         {
         //debugger;
            var row = $('#jQGrid').jqGrid('getRowData', id);
           
            $('#<%= lblAgent.ClientID%>')[0].innerText = row.AgentId + " - " + row.ManagerName;
            $('#<%= lblEmploy.ClientID%>')[0].innerText = row.EmployeeId + " - " + row.EmployeeName;
            $('#<%= lblMainCon.ClientID%>')[0].innerText = row.ActivityCode + " - " + row.ActivityDescription;
            $('#<%= lblCustomer.ClientID%>')[0].innerText = row.Cust_Key + " - " + row.CustName;

            $('#<%= lblComment.ClientID%>')[0].innerText = row.Comment;
            $('#<%= txtManagerComment.ClientID%>').val("");
            $('#<%= lblSubjectDescription.ClientID%>')[0].innerText = row.SubjectDescription;
            AgentID = row.AgentId;
            requestId = row.RequestID;
         }
         function DisableWin()
         {            
            $('#dGrid').block({ message: 'עריכה...' });           
         }
         function SetManagerData(Status,ManagerComment)
         {      
            ManagerComment = ManagerComment.replace("undefined","");
            try {
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=SetManagerGridData&RequsetID="+RequsetID+"&Status=" + Status + "&ManagerComment=" + escape(ManagerComment),
                    type: "Get",
                    datatype: "json",
                    data: '',
                    success: function () {
                         UpdatedSuccessfuly();
                    },
                    error: function(requestObject, error, errorThrown) {
                        if(requestObject.status!=200)
                            alert("אראה שגיאה!");
                        else
                           UpdatedSuccessfuly();
                    }
                });
            }
            catch (e) {
            }
         }
         var Hash="";
         function CreatePassword()
         {    
           
            var str = '<%=SessionUserID %>' + $('#txtManualAgent').val() +  $('#<%=ddlMainCon.ClientID %>').val() + $('#txtManualCustomer').val() + $('#txtManualReq').val();
            try {
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=CreatePassword&String=" + str,
                    type: "Get",
                    datatype: "json",
                    data: '',
                    success: function (data) {
                         Hash=data;
                         $('.divPass')[0].innerText = Hash;
                    },
                    error: function(requestObject, error, errorThrown) {                   
                        if(requestObject.status!=200)
                            alert("אראה שגיאה!");                      
                        else
                        {                        
                            Hash=requestObject.responseText;
                            $('.divPass')[0].innerText = Hash;
                        } 
                    }
                });
            }
            catch (e) {
            }
         }
         function CheckSession()
         {               
            try {
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=CheckSession",
                    type: "Get",
                    datatype: "json",
                    data: '',
                    success: function (data) {
                         if(data=="Redirect")
                         {
                            window.location.href = window.location.href;
                         }
                    },
                    error: function(requestObject, error, errorThrown) {                   
                        if(requestObject.status!=200)
                            alert("אראה שגיאה!");                      
                        else
                        {    
                             if(requestObject.responseText=="Redirect")
                             {
                                window.location.href = window.location.href;
                             }                    
                        } 
                    }
                });
            }
            catch (e) {
            }
         }
         function UpdatedSuccessfuly()
         {
             $("#dGrid").unblock();
             Refresh();
             closeWin("ItemEdit");
         }
          function UpdatedSuccessfulyManual()
         {
             $("#dGrid").unblock();
             Refresh();
             closeWin("divManual");
         }
         function ShowManualForm()
         {
            CheckSession();
            DisableWin();
            $('.ManualBox').css("display","block");
            var top =500;  
            $("#divManual").css({top:top})  
            .animate({"top":"100px"}, "slow");
            $('#txtManualAgent').focus();

            $('#txtManualAgent').val("");
            $('#<%=ddlMainCon.ClientID %>').val("");
            $('#txtManualCustomer').val("");
            $('#txtManualReq').val("");
            RemovePass();
         }
         function SetNewPass()
         {
//            $("#dGrid").unblock();
//             Refresh();
//             closeWin("divManual");
            CreatePassword();
         }
         function CheckForEnterAndFocusNextField(evt,nextID)
         {
            if (evt.keyCode == 13) {
                $('#'+nextID).focus();
            }
         }
         function RemovePass()
         {
            $('.divPass').text("");
         }
         GetData();
            $("#jqgh_jQGrid_GridIcon")[0].title="רענן";
           // $(".ui-jqgrid-bdiv").css("height","400px");

            SetFieldOnlyNumbers('txtManualAgent');
           //SetFieldOnlyNumbers('txtManualAction');
            SetFieldOnlyNumbers('txtManualCustomer');
            SetFieldOnlyNumbers('txtManualReq');

             
    </script>
    <script type="text/javascript">
        var socket;
        function Con() {
            //debugger;
            socket = new WebSocket('<%=PushServerURL %>/PushServer?NewWS=true&ManagerID=<%=SessionUserID %>;<%=Comp %>');
            socket.onopen = function () {
                //alert('open');
                //document.getElementById("msg").innerText = 'handshake successfully established. May send data now...';
                //socket.send(document.getElementById("txt").value);
            };
            socket.onmessage = function (evt) {
                try {
                    var db = evt.data;
                    if (db.indexOf("got logged off") == -1) {
                        if (db.indexOf("GET_MANAGER_SYNC_REPLAY") > -1) {
                            //alert("התקבלה בקשה חדשה");
                        }
                        if (db.indexOf("GET_MANAGER_SYNC_REPLAY_MANUAL") > -1) {
                            //alert("התקבלה בקשה ידנית חדשה");
                        }
                        else if (db.indexOf("cancel msg") > -1) {
                            //alert("בקשה בוטלה");
                        }
                        GetData();

                        //setTimeout(ShowRow, 500);
                    }
                }
                catch (e) { 
                
                }
            };
            socket.onclose = function () {
                //document.getElementById("msg").innerText = 'connection closed';
                //alert('close');
            };
        }
        function ShowRow() {
            var row = $('#jQGrid').jqGrid('getRowData', 1);
            if (row.styleicon1 == 0) {
                id = 1;
                RequsetID = row.RequestID;
                DisableWin();
                setData(id);
                $('.ItemEditBox').css("display", "block");
                var top = 500;
                $("#ItemEdit").css({ top: top })
                            .animate({ "top": "100px" }, "slow");

                $('#<%= ddlRequests.ClientID%>').val("0");
                $('#<%= rbToday.ClientID%>')[0].checked = true;
            }
        }
       
        function CheckForEnter(code) {
            if (code == 13) {
                Send();
            }
        }
        var msg="";
        var isToSend = false;
        function SendReplay(val) {
            try
            {
                //debugger;
                var isApproved="true";
                if(val=='3')
                    isApproved = "false";

                msg = "toAgent:" + AgentID + ";RequestId:" + requestId + ";isApproved:" + isApproved + ";ManagerComment:" + $('#<%=txtManagerComment.ClientID %>')[0].innerText;
                if (myWebSocket._ws) 
                {
                    myWebSocket._ws.bufferedAmount = 1024;
                    //alert('send');
                    if(msieversion())
                    {
                        isToSend=true;
                        //myWebSocket.connect();
						myWebSocket._ws.send(msg);
                    }
                    else
                    {
                        myWebSocket._ws.send(msg);
                    }
                   
                }
                //if(socket)
                    //socket.send(msg);
                //else
                    //Con();
            }
            catch (e) {
                //alert('error');
                //alert(e);
                //Con();
                setTimeout('SendReplay('+val+');',500);
            }
        }

        function msieversion() 
        {
            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");

            if (msie > 0) // If Internet Explorer, return version number
            {
                //alert(parseInt(ua.substring(msie + 5, ua.indexOf(".", msie))));
				return true;
            }
            else  // If another browser, return 0
            {
                //alert('otherbrowser');
            }

            return false;
        }
        //Con();

		var isConnected = false;
        var myWebSocket = {
            connect: function () {
                var location = '<%=PushServerURL %>/PushServer?NewWS=true&ManagerID=<%=SessionUserID %>;<%=Comp %>';
                this._ws = new WebSocket(location);
                this._ws.onopen = this._onopen;
                this._ws.onmessage = this._onmessage;
                this._ws.onclose = this._onclose;
                this._ws.onerror = this._onerror;
            },

            _onopen: function () {
				isConnected = true;
                if(msieversion())
                {
                    if(isToSend)
                        this.send(msg);
                    isToSend  =false;
                }
               // alert('open');
                //console.debug("WebSocket Connected");
            },

            _onmessage: function (message) {
                //alert('message');
                //console.debug("Message Recieved: " + message.data);
                try {
                    GetData();
                    var db = evt.data;
                    if (db.indexOf("got logged off") == -1) {
                        if (db.indexOf("GET_MANAGER_SYNC_REPLAY") > -1) {
                            //alert("התקבלה בקשה חדשה");
                        }
                        if (db.indexOf("GET_MANAGER_SYNC_REPLAY_MANUAL") > -1) {
                            //alert("התקבלה בקשה ידנית חדשה");
                        }
                        else if (db.indexOf("cancel msg") > -1) {
                            //alert("בקשה בוטלה");
                        }
                        

                        //setTimeout(ShowRow, 500);
                    }
                }
                catch (e) { 
                
                }
            },

            _onclose: function () 
			{
				alert("השרת נותק, מתחבר מחדש...");
				isConnected = false;
				setTimeout("Reconnect();",5000);
            },

            _onerror: function (e) {
                isConnected = false;
				setTimeout("Reconnect();",5000);
            },

            _send: function (message) {
                //alert("Message Send: " + message);
                //console.debug("Message Send: " + message);
                if (this._ws) this._ws.send(message);
            }
        };
		
		function Reconnect()
		{
		//alert("aa");
			if(!isConnected)
			{
			//alert("cc");
				myWebSocket.connect();
			
				setTimeout("Reconnect();",5000);
			}
		}
        myWebSocket.connect();
       
    </script>
</asp:Content>

