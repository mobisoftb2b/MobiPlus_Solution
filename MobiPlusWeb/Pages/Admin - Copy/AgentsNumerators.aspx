<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="AgentsNumerators.aspx.cs" Inherits="Pages_Admin_AgentsNumerators" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <div style="padding-top:10px;padding-right:30%;">
            <div class="dNAghents">
                <div class="nAgentsHead">
                    סוכנים
                </div>
                <div class="nAgentsHeadFilter">
                    חיפוש:
                    <asp:TextBox runat="server" ID="txtFilter" Width="206px" onkeyup="filterAgents(this.value);"></asp:TextBox>
                </div>
                <asp:DropDownList runat="server" CssClass="select" ID="ddlAgents" size="35" Width="250px" onchange="GetNumeratorsForAgent(this.value);">
                </asp:DropDownList>
            </div>
            <div class="dNNumertors">
                <div class="dNumertorsTblAll" >
                    <table cellspacing="2" cellpadding="2" class="tdNAll" width="100%">
                        <tr >
                            <td >
                                ערך לכולם:
                            </td>
                            <td class="tdNTxtAll">
                                <asp:TextBox runat="server" ID="txtAllNumertorsValue" Width="80px"></asp:TextBox>
                            </td>
                            <td>
                                <input type="button" id="btnSaveToAll" class="btnMove" value="החל" onclick="SetAll();"/>
                            </td>
                        </tr>
                    </table>
                    <div id="dTblNtmertors" runat="server">
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
                url: "../../Handlers/MainHandler.ashx?MethodName=SetNumerator&AgentID=" + $('#<%= ddlAgents.ClientID%>').val() + "&NumeratorGroup=" + NumeratorGroup + "&NumeratorValue=" + NumeratorValue + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
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

            var yourDate = new Date();  // for example

            // the number of .net ticks at the unix epoch
            var epochTicks = 621355968000000000;

            // there are 10000 .net ticks per millisecond
            var ticksPerMillisecond = 10000;

            // calculate the total number of .net ticks for your date
            var yourTicks = epochTicks + (yourDate.getTime() * ticksPerMillisecond);

            $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=GetNumeratorsForAgent&AgentID=" + AgentID + "&Tiks=" + yourTicks,
                type: "Get",
                data: '',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    for (var i = 0; i < $('.txtNum').length; i++) {
                        $('.txtNum')[i].value = "";
                    }
                    for (var i = 0; i < data.length; i++) {
                        $('#ContentPlaceHolder1_txt1' + data[i]["NumeratorGroup"]).val(data[i]["NumeratorValue"].toString());
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
            if (($('#ContentPlaceHolder1_ddlAgents').val()) == null || $('#<%= ddlAgents.ClientID%>').val() == "") {
                alert("אנא בחר סוכן");
                return;
            }
            if ($('#<%= txtAllNumertorsValue.ClientID%>').val() == "") {
                alert("אנא הזן ערך");
                return;
            }

            if (confirm("האם ברצונך להחיל את הערך הכללי עבור כל קבוצות הנומרטורים?")) {
                $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=SetNumeratorToAllByAgent&AgentID=" + $('#<%= ddlAgents.ClientID%>').val() + "&NumeratorValue=" + $('#<%= txtAllNumertorsValue.ClientID%>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
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
        
    </script>
</asp:Content>
