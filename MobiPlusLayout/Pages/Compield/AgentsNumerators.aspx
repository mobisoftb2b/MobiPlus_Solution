﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AgentsNumerators.aspx.cs"
    Inherits="Pages_Compield_AgentsNumerators" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ניהול נומרטורים</title>
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/json2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link id="WebMainStyleSheet" href="../../css/WebMain.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
            var hrefMain;
            var hrefWebMain;
            switch (lang) {
                case 'He':
                    hrefMain = "../../css/Main.css?Ver=<%=ClientVersion %>";
                    hrefWebMain = "../../css/WebMain.css?Ver=<%=ClientVersion %>";
                    break;
                case 'En':
                    hrefMain = "../../css/MainLTR.css?Ver=<%=ClientVersion %>";
                    hrefWebMain = "../../css/WebMainLTR.css?Ver=<%=ClientVersion %>";
                    break;
                default:
                    href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>";
                    hrefWebMain = "../../css/WebMain.css?Ver=<%=ClientVersion %>";
                    break;
            } default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
             document.getElementById('MainStyleSheet').href = hrefMain;
             document.getElementById('WebMainStyleSheet').href = hrefWebMain;
        }
        styler();
    </script>
    <script src="../../js/Main.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <style type="text/css">
        option {
            font-weight: 700;
        }

        .nAgentsHead {
            width: 250px;
            text-align: center;
            font-size: 14px;
            background-color: Gray;
            color: White;
            -moz-border-top-right-radius: 7px;
            -webkit-border-top-right-radius: 7px;
            border-border-top-right-radius: 7px;
            -moz-border-top-left-radius: 7px;
            -webkit-border-top-left-radius: 7px;
            border-border-top-left-radius: 7px;
        }
    </style>
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <div>
            <div class="divNumerators">
                <div class="dNAghents" style="-webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65); -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65); box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);">
                    <div class="nAgentsHead">
                        <%=StrSrc("SalesRep")%>
                    </div>
                    <div class="nAgentsHeadFilter">
                        <%=StrSrc("Search")%>:
                    <asp:TextBox runat="server" ID="txtFilter" onkeyup="filterAgents(this.value);" CssClass="RowndTxt txtFilterNumerators"></asp:TextBox>
                    </div>
                    <asp:DropDownList runat="server" CssClass="select" ID="ddlAgents" size="28" Width="250px"
                        onchange="GetNumeratorsForAgent(this.value);">
                    </asp:DropDownList>
                </div>
                <div class="dNNumertors">
                    <div class="dNumertorsTblAll" style="-webkit-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65); -moz-box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65); box-shadow: 1px 1px 9px 0px rgba(0,0,0,0.65);">
                        <table cellspacing="2" cellpadding="2" class="tdNAll" width="100%">
                            <tr>
                                <td style="font-weight: 700;">
                                    <%=StrSrc("ValueForAll")%>:
                                </td>
                                <td class="tdNTxtAll">
                                    <asp:TextBox runat="server" ID="txtAllNumertorsValue" Width="80px" CssClass="RowndTxt"></asp:TextBox>
                                </td>
                                <td>
                                    <input type="button" id="btnSaveToAll" class="MSBtn" value="<%=StrSrc("Apply")%>" onclick="SetAll();" />
                                </td>
                            </tr>
                        </table>
                        <div id="dTblNtmertors" runat="server" style="font-weight: 700; overflow-y: auto; overflow-x: hidden; height: 462px;">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">

            function filterAgents(val) {
                $('#<%=ddlAgents.ClientID %>').val($('#<%=ddlAgents.ClientID %> option').filter(function () { return $(this).html().indexOf(val) > -1; }).val());
                GetNumeratorsForAgent($('#<%=ddlAgents.ClientID %>').val());

                //setTimeout(SetFocusOnDDL, 500);
            }
            function SetFocusOnDDL() {
                //$('#<%=txtFilter.ClientID %>')[0].focus();
        }

            function SetNumerator(NumeratorGroup, NumeratorValue) {
                $.ajax({
                    url: "../../Handlers/WebMainHandler.ashx?MethodName=SetNumerator&AgentID=" + $('#<%= ddlAgents.ClientID%>').val() + "&NumeratorGroup=" + NumeratorGroup + "&NumeratorValue=" + NumeratorValue + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "Get",
                    data: '',
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        //alert('2');
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status == 200) {
                            //alert('1');
                        }
                        else {
                            alert("error: failure");
                        }
                    }
                });
            }
            function GetNumeratorsForAgent(AgentID) {
                $('#<%= txtAllNumertorsValue.ClientID%>').val("");

            $.ajax({
                url: "../../Handlers/WebMainHandler.ashx?MethodName=GetNumeratorsForAgent&AgentID=" + AgentID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "Get",
                data: '',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    for (var i = 0; i < $('.RowndTxt').length; i++) {
                        $('.RowndTxt')[i].value = "";
                    }
                    for (var i = 0; i < data.length; i++) {
                        $('#txt1' + data[i]["NumeratorGroup"]).val(data[i]["NumeratorValue"].toString());
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                    }
                    else {
                        alert("error: failure");
                    }
                }
            });

        }
        function SetAll() {
            if (($('#ddlAgents').val()) == null || $('#<%= ddlAgents.ClientID%>').val() == "") {
                alert("<%=StrSrc("SelectSalesRep ")%>");
                return;
            }
            if ($('#<%= txtAllNumertorsValue.ClientID%>').val() == "") {
                alert("<%=StrSrc("EnterValue")%>");
                return;
            }

            if (confirm("<%=StrSrc("ApplyGeneralValue")%>?")) {
                $.ajax({
                    url: "../../Handlers/WebMainHandler.ashx?MethodName=SetNumeratorToAllByAgent&AgentID=" + $('#<%= ddlAgents.ClientID%>').val() + "&NumeratorValue=" + $('#<%= txtAllNumertorsValue.ClientID%>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "Get",
                    data: '',
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        GetNumeratorsForAgent($('#<%= ddlAgents.ClientID%>').val());
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status == 200) {
                            GetNumeratorsForAgent($('#<%= ddlAgents.ClientID%>').val());
                        }
                        else {
                            alert("error: failure");
                        }
                    }
                });
            }
        }
        $('#<%=txtFilter.ClientID %>')[0].select();
            $('#<%=txtFilter.ClientID %>')[0].focus();

            SetFieldOnlyNumbers('<%= txtAllNumertorsValue.ClientID%>');

            $('#<%= dTblNtmertors.ClientID%>').height($(window).height()/2*1.7);
        </script>
    </form>
</body>
</html>
