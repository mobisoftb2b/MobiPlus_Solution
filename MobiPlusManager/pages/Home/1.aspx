<%@ Page Title="MobiPlus Manager - בקשות להרשאות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="1.aspx.cs" Inherits="pages_1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <link href="~/css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <link href="~/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    
    <script type="text/javascript">
        var socket;
        function Con() {
            //debugger;
            socket = new WebSocket('<%=PushServerURL %>/PushServer?NewWS=true&ManagerID=<%=DateTime.Now.Ticks.ToString() %>;<%=Comp %>');
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
                        //GetData();

                        //setTimeout(ShowRow, 500);
                    }
                }
                catch (e) { 
                
                }
            };
            socket.onclose = function () {
                //document.getElementById("msg").innerText = 'connection closed';
                //alert('close');
                Con();
            };
        }
        
        function SendReplay(val) {
            try
            {
                var isApproved="true";
                if(val=='3')
                    isApproved = "false";

                var msg = "toAgent:" + AgentID + ";RequestId:" + requestId + ";isApproved:" + isApproved + ";ManagerComment:" + "gg";
                socket.send(msg);
            }
            catch (e) {
                Con();
                setTimeout('SendReplay('+val+');',500);
            }
        }

       
        Con();
       
    </script>
</asp:Content>

