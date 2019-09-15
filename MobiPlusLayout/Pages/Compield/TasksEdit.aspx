<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TasksEdit.aspx.cs" Inherits="Pages_Compield_TasksEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TasksEdit</title>
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

    <script src="../../js/tree/jquery.tree.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        .TaskUsersHead {
            background-color: gray;
            color: white;
            text-align: center;
            width: 161px;
            height: 17px;
            padding-top: 3px;
            margin-top: 5px;
        }

        .obj {
            margin-right: 5px;
            z-index: 1;
            width: 100%;
            height: 100%;
        }

        .dRight {
            float: right;
            width: 170px;
        }

        .dLeft {
            float: left;
            height: 100%;
        }

        .dEditTask {
            right: 40%;
            width: 370px;
            height: 480px;
            position: absolute;
            z-index: 999999;
            display: none;
            padding: 2px;
            padding-right: 5px;
            text-align: left;
            white-space: normal;
            background-color: #EDEDED;
            color: #340028;
            border: 1px solid #ccc;
            border: 1px solid rgba(0,0,0,0.2);
            border-radius: 6px;
            -webkit-box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            background-clip: padding-box;
        }

        .task {
            height: 65px;
        }
    </style>
</head>
<body id="dBody" onload="try{setTimeout('parent.CloseLoading();',10);}catch(e){};">
    <form id="form1" runat="server">
       <%-- <div style="height:50px;">
        <img id="tImg" src="" runat="server" style="height:50px;"/>
            </div>--%>
        <div id="dBody1">
            <div class="obj">
                <div class="dRight">
                    <div class="TaskUsersHead">
                        <%=StrSrc("Drivers") %>
                    </div>
                    <div>
                        <asp:ListBox CssClass="LBAgents1" Width="160px" Height="500px" ID="AgentsList" runat="server" onchange="NavGrid();"></asp:ListBox>
                    </div>
                </div>
                <div class="dLeft">
                </div>
            </div>
        </div>
        <div id="dEditTask" class="dEditTask">
            <div class="close cclose" onclick="CloseEditBoxPopup();">
                x
            </div>
            <div class="header_user">
                <%=StrSrc("UpdateTask") %>                
            </div>
            <div align="center">
                <table>
                    <tr>
                        <td class="headData">#
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtNum" class="txtU userInput" readonly="readonly" />
                        </td>
                        <td>
                            <a href="javascript:SetTask('1');"><%=StrSrc("Delete") %></a>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Driver") %>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlDrivers" CssClass="ddlU userInput"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Customer") %>
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtCustomer" class="txtU userInput" />
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Address") %>
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtAddress" class="txtU userInput" />
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("City") %>
                        </td>
                        <td>
                            <input runat="server" type="text" id="txtCity" class="txtU userInput" />
                        </td>
                    </tr>
                     <tr>
                        <td class="headData"><%=StrSrc("DateFrom") %>
                        </td>
                        <td>
                            <input runat="server" type="text" ClientIDMode="Static" id="txtDateFrom" class="txtU userInput" />
                        </td>
                    </tr>
                     <tr>
                        <td class="headData"><%=StrSrc("DateTo") %>
                        </td>
                        <td>
                            <input runat="server" type="text" ClientIDMode="Static" id="txtDateTo" class="txtU userInput" />
                        </td>
                    </tr>
                    

                    <tr>
                        <td class="headData"><%=StrSrc("TaskType") %>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlTaskTypes" class="ddlU userInput"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="headData"><%=StrSrc("Task") %>
                        </td>
                        <td>
                            <textarea runat="server" id="txtTask" rows="5" class="txtU userInput task"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <input type="button" id="btnSave" onclick="SetTask('0');" value="<%=StrSrc("Save") %>" class="btnSave" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        $('.LBAgents1').height(($(window).height() * 1.0 - 27.0) + "px");
        $('.obj').height(($(window).height()) + "px");
        $.datepicker.setDefaults($.datepicker.regional["he"]);

        $(function() {
            $("#txtDateFrom, #txtDateTo").datepicker({
                changeMonth: true,
                changeYear: true,
                dateFormat: 'dd/mm/yy'
            });
        });


        function CloseEditBoxPopup() {
            $("#dEditTask").css({ top: 100 })
                   .animate({ "top": "-600" }, "high");
            unBlockWin();
        }
        function NavGrid() {
            $('.dLeft').width(($(window).width() * 1.0 - 175.0) + "px");
            $('.dLeft').height(($(window).height() * 1.0) + "px");
            $(".dLeft")[0].innerHTML = "<iframe style='' id='if_1' frameborder='0' scrolling='no' src='../RPT/ShowReport.aspx?Name=DriverTasks&WinID=if_1&Width=" + ($(window).width() * 1.0 - 200.0) + "&Height=" + $(window).height() * 1.0 + "&aAgentID=" + $(<%=AgentsList.ClientID%>).val() + "&Date=" + escape('<%=DateTime.Now.Date.ToString("yyyy-MM-dd")%>') + "' class='ifReport' />";
            $('#<%=ddlDrivers.ClientID%>').val($(<%=AgentsList.ClientID%>).val());
        }
        function AddTask() {
            TaskID = "0";
            $('#<%=ddlDrivers.ClientID%>').val($(<%=AgentsList.ClientID%>).val());
            $('#<%=txtCustomer.ClientID%>').val("");
            $('#<%=txtAddress.ClientID%>').val("");
            $('#<%=txtCity.ClientID%>').val("");
            $('#<%=ddlTaskTypes.ClientID%>').val("5");
            $('#<%=txtTask.ClientID%>').val("");
            $('#txtNum').val("חדש");
            BlockWin();

            $('#dEditTask').show();
            $("#dEditTask").css({ top: -600 })
                   .animate({ "top": "100" }, "high");
            return false;
        }
        function EditTask(taskID, AgentId, CustomerCode, Address, City, TaskTypeID, Task) {
            TaskID = taskID;
            $('#<%=ddlDrivers.ClientID%>').val(AgentId);
            $('#<%=txtCustomer.ClientID%>').val(CustomerCode);
            $('#<%=txtAddress.ClientID%>').val(Address);
            $('#<%=txtCity.ClientID%>').val(City);
            $('#<%=ddlTaskTypes.ClientID%>').val(TaskTypeID);
            $('#<%=txtTask.ClientID%>').val(Task);

            $('#txtNum').val(TaskID);

            BlockWin();

            $('#dEditTask').show();
            $("#dEditTask").css({ top: -600 })
                   .animate({ "top": "100" }, "high");
        }
        function BlockWin() {
            $('#dBody1').block({ message: '' });
        }
        function unBlockWin() {
            $('#dBody1').unblock();
        }

        var TaskID = "0";
        function SetTask(IsToDelete) {
            if (IsToDelete == "1") {
                if (!confirm("<%=StrSrc("ConfirmDelete") %>"))
                    return;
            }
            var request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetTask&TaskID="
                    + TaskID + "&AgentId="
                    + $('#<%=ddlDrivers.ClientID%>').val()
                    + "&CustomerCode=" + $('#<%=txtCustomer.ClientID%>').val()
                    + "&Address=" + $('#<%=txtAddress.ClientID%>').val()
                    + "&City=" + $('#<%=txtCity.ClientID%>').val()
                    + "&DateFrom=" + $.datepicker.formatDate('yymmdd', $('#txtDateFrom').datepicker('getDate'))
                    + "&DateTo=" + $.datepicker.formatDate('yymmdd', $('#txtDateTo').datepicker('getDate'))
                    + "&TaskTypeID=" + $('#<%=ddlTaskTypes.ClientID%>').val()
                    + "&Task=" + $('#<%=txtTask.ClientID%>').val()
                    + "&IsToDelete=" + IsToDelete
                    + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "GET",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                if (jqXHR.responseText == "True") {
                    NavGrid();
                    CloseEditBoxPopup();
                }
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {
                    if (jqXHR.responseText == "True") {
                        NavGrid();
                        CloseEditBoxPopup();
                    }
                }
                else {
                    console.log(jqXHR.responseText);
                }
            });
        }
        NavGrid();
    </script>
</body>
</html>
