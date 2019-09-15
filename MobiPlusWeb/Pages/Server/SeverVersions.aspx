<%@ Page Title="MobiPlus - ניהול גרסאות" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="SeverVersions.aspx.cs" Inherits="Pages_Server_SeverVersions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="~/css/jquery-ui.css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        function closeWin(id) {
            var top = 100;
            $("#" + id).css({ top: top })
                    .animate({ "top": "-500" }, "slow");
            rid = "";
        }
        var IsAdd = false;
        var rid = "";
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <div id="dBody" style="padding-top: 10px; text-align: right; direction: rtl; width: 775px;">
        <center>
            <div style="background-color: #4F81BD; color: White; font-weight: 700;">
                גרסאות תוכנה למסופונים
            </div>
            <div style="text-align: right; padding-top: 5px; padding-bottom: 5px;display:none;">
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td style="font-weight: 700;">
                            טען גרסת אנדרואיד:
                        </td>
                        <td>
                            <asp:FileUpload runat="server" ID="upAndroidVersion" />
                        </td>
                        <td>
                            <asp:Button runat="server" ID="btnAploadAndroidVersion" Text="העלה" OnClick="btnAploadAndroidVersion_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <table id="jQGrid" style="width: 100%;">
            </table>
            <div id="jQGridPager">
            </div>
            <br />
            <br />
            <br />
            <br />
            <br />
            <div style="background-color: #4F81BD; color: White; font-weight: 700;">
                גרסאות עיצוב למסופונים
            </div>
            <table id="jQGridLayout" style="width: 100%;">
            </table>
            <div id="jQGridPagerLayout">
            </div>
        </center>
    </div>
    <div>
        <center>
            <div id="divEditWin" class="EditWinBoxVersions">
                <div class="EditWinX">
                    <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfuly();" />
                </div>
                <div class="EditWinHead">
                    <%=StrSrc("EditWinHead") %>
                </div>
                <div class="EditWinTbl">
                    <table cellpadding="4" cellspacing="4">
                        <tr>
                            <td class="EditWin item">
                                <%--<%=StrSrc("EditWinProjectType") %>--%>
                                אוכלוסייה
                            </td>
                            <td class="EditWin val">
                                <asp:DropDownList runat="server" ID="ddlProjectTypes" Width="180px" onchange="SetPrjByType(this.value);">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="trAgents">
                            <td class="EditWin item">
                                <%=StrSrc("EditWinAgent") %>
                            </td>
                            <td class="EditWin val">
                                <asp:DropDownList runat="server" ID="ddlAgents" Width="180px" Onchange="Set2Others('ddlAgents');">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="trProfiles" style="display: none;">
                            <td class="EditWin item">
                                פרופיל
                            </td>
                            <td class="EditWin val">
                                <asp:TextBox runat="server" ID="txtProfileID" Width="180px" onkeyup="Set2Others('txtProfileID');"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinGroup") %>
                            </td>
                            <td class="EditWin val">
                                <asp:DropDownList runat="server" ID="ddlGroups" Width="180px" Onchange="Set2Others('ddlGroups');">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinFromVersion") %>
                            </td>
                            <td class="EditWin val">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Always">
                                    <ContentTemplate>
                                        <asp:DropDownList runat="server" ID="ddlFromVersion" Width="180px" Onchange="Set2Others('ddlFromVersion');">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel runat="server" ID="upa" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="imgRefreshAgents" runat="server" ImageUrl="~/Img/refresh.png"
                                            Width="16px" OnClick="RefreshAgents_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinToVersion") %>
                            </td>
                            <td class="EditWin val">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Always">
                                    <ContentTemplate>
                                        <asp:DropDownList runat="server" ID="ddlToVersion" Width="180px">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel runat="server" ID="upm" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="imgRefreshManagers" runat="server" ImageUrl="~/Img/refresh.png"
                                            Width="16px" OnClick="RefreshManagers_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                    <div class="dBtns">
                        <center>
                            <table cellpadding="2" cellspacing="2">
                                <tr>
                                    <td>
                                        <input type="button" id="btnEditWinCreatePass" value="<%=StrSrc("EditWinOKBtn") %>"
                                            class="EditWin btn" onclick="SaveData();" />
                                    </td>
                                </tr>
                            </table>
                        </center>
                    </div>
                </div>
            </div>
            <div id="EditWinBoxLayoutVersions" class="EditWinBoxLayoutVersions">
                <div class="EditWinX">
                    <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfulyLayout();" />
                </div>
                <div class="EditWinHeadLayout">
                    חוק קשר לגרסת עיצוב
                </div>
                <div class="EditWinTbl">
                    <table cellpadding="4" cellspacing="4">
                        <tr>
                            <td class="EditWin item">
                                <%--<%=StrSrc("EditWinProjectType") %>--%>
                                אוכלוסייה
                            </td>
                            <td class="EditWin val">
                                <asp:DropDownList runat="server" ID="ddlProjectTypesLayout" Width="180px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinAgent") %>
                            </td>
                            <td class="EditWin val">
                                <asp:DropDownList runat="server" ID="ddlAgentsLayout" Width="180px" Onchange="Set2Others('ddlAgents');">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinGroup") %>
                            </td>
                            <td class="EditWin val">
                                <asp:DropDownList runat="server" ID="ddlGroupsLayout" Width="180px" Onchange="Set2Others('ddlGroups');">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinFromVersion") %>
                            </td>
                            <td class="EditWin val">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Always">
                                    <ContentTemplate>
                                        <asp:DropDownList runat="server" ID="ddlFromVersionLayout" Width="180px" Onchange="Set2Others('ddlFromVersion');">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel runat="server" ID="UpdatePanel4" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="btnLayoutRef1" runat="server" ImageUrl="~/Img/refresh.png" Width="16px"
                                            OnClick="RefreshAgentsLayout_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="EditWin item">
                                <%=StrSrc("EditWinToVersion") %>
                            </td>
                            <td class="EditWin val">
                                <asp:UpdatePanel runat="server" ID="UpdatePanel5" UpdateMode="Always">
                                    <ContentTemplate>
                                        <asp:DropDownList runat="server" ID="ddlToVersionLayout" Width="180px">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel runat="server" ID="UpdatePanel6" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="btnLayoutRef2" runat="server" ImageUrl="~/Img/refresh.png" Width="16px"
                                            OnClick="RefreshManagersLayout_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                    <div class="dBtns">
                        <center>
                            <table cellpadding="2" cellspacing="2">
                                <tr>
                                    <td>
                                        <input type="button" id="Button1" value="<%=StrSrc("EditWinOKBtn") %>" class="EditWin btn"
                                            onclick="SaveDataLayout();" />
                                    </td>
                                </tr>
                            </table>
                        </center>
                    </div>
                </div>
            </div>
        </center>
    </div>
    <script language="javascript" type="text/javascript">
        var Groups = "";
        var ProjectTypes = "";
        var Command = "Edit";
       
        function UpdatedSuccessfulyLayout()
         {
         $('.EditWinHeadLayout').css("font-size","20px");
             $("#dBody").unblock();             
             RefreshLayout();
             closeWin("EditWinBoxLayoutVersions");
             $('.EditWinHeadLayout')[0].innerText="";
         }

         function UpdatedUnSuccessfulyLayout(msg)
         {           
            $('.EditWinBoxLayoutVersions').height("300");
            msg="<span class='msgRed'><%=StrSrc("UpdatedUnSuccessfuly") %></span><br/>" + msg;
            $('.EditWinHeadLayout').css("font-size","12px");
            $('.EditWinHeadLayout')[0].innerHTML = msg;
            $('.EditWinBoxLayoutVersions').css("height",$('.EditWinBoxLayoutVersions').height()+50);
         }
         function UpdatedSuccessfuly()
         {
         $('.EditWinHead').css("font-size","20px");
             $("#dBody").unblock();             
             Refresh();
             closeWin("divEditWin");
             $('.EditWinHead')[0].innerText="";
         }

         function UpdatedUnSuccessfuly(msg)
         {           
            $('.EditWinBoxVersions').height("300");
            msg="<span class='msgRed'><%=StrSrc("UpdatedUnSuccessfuly") %></span><br/>" + msg;
            $('.EditWinHead').css("font-size","12px");
            $('.EditWinHead')[0].innerHTML = msg;
            $('.EditWinBoxVersions').css("height",$('.EditWinBoxVersions').height()+50);
         }
        $.getJSON("../../Handlers/MainHandler.ashx?MethodName=GetServerGroups", null, function (data) {
            if (data != null) {
                var Str = "";
                for (var i = 0; i < data.length; i++) {
                    if (i > 0)
                        Str += ";" + data[i].ServerGroupID + ":" + unescape(data[i].ServerGroupName);
                    else
                        Str += data[i].ServerGroupID + ":" + unescape(data[i].ServerGroupName);
                }
                Groups = Str;
                
                OnStart();
            }
        });
        
        function OnStart()
        {
             $.getJSON("../../Handlers/MainHandler.ashx?MethodName=GetProjectTypes", null, function (data) {
                if (data != null) {
                    var Str = "";
                   
                    for (var i = 0; i < data.length; i++) {
                        if (i > 0)
                            Str += ";" + data[i].ProjectType + ":" + unescape(data[i].ProjectTypeName);
                        else
                            Str += data[i].ProjectType + ":" + unescape(data[i].ProjectTypeName);
                    }
                    ProjectTypes = Str;
                    ShowGrid();
                    ShowGridLayout();
                }
            });
        }
        function getGroupsNumbers() {
            return Groups;
        }
        function getProjectTypes() {
            return ProjectTypes;
        }
        function GetVerID() {
            var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
            var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
            Command = "Edit";
            return value;
        }
        function getCellServerGroupNameValue() {
            return $('#ServerGroupName').val();
        }
        function getCellProjectTypeValue() {
            return $('#ProjectTypeName').val();
        }
        function doNone() {
            return false;
        }
        function DisableWin()
         {            
            $('#dBody').block({ message: '<%=StrSrc("EditWinEditMsg") %>' });           
         }

         function ShowEditFormLayout() {
            $('.EditWinBoxLayoutVersions').height("300");
            if (rid != "") {
                
                IsAdd = false;
                DisableWin();
                setDataLayout(rid);
                $('.EditWinBoxLayoutVersions').css("display", "block");
                var top = 500;
                $("#EditWinBoxLayoutVersions").css({ top: top })
                        .animate({ "top": "100px" }, "slow");
                
            }
            else {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
            }
            return false;
        }
        function ShowAddFormLayout() {
            $('.EditWinBoxLayoutVersions').height("300");
            IsAdd = true;
            DisableWin();
            setDataLayout("");
            $('.EditWinBoxLayoutVersions').css("display", "block");
            var top = 500;
            $("#EditWinBoxLayoutVersions").css({ top: top })
                        .animate({ "top": "100px" }, "slow");

            return false;
        }
        function ShowDeleteFormLayout() {
            $('.EditWinBoxLayoutVersions').css("display", "none");
            if (rid == "" || rid == "0") {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                return false;
            }
            if (confirm("<%=StrSrc("EditWinDelConfirm") %>")){
                var request;
                var row = $('#jQGridLayout').jqGrid('getRowData', rid);
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=AddEditServerLayoutVersion&id=" + rid + "&verid=" + row.VerID + "&Command=Delete&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "get",
                    data: ''
                });
                request.done(function (response, textStatus, jqXHR) {
                    RefreshLayout();
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        RefreshLayout();
                    }
                    else {
                        alert("Error");
                    }
                });
            }
            return false;
        }
         function ShowSearchFormLayout()
        {
            $("#jQGridLayout").searchGrid({ closeAfterSearch: false });
        }
        function RefreshLayout()
         {
            $('#jQGridLayout').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
         }



        function ShowEditForm() {
            $('.EditWinBoxVersions').height("300");
            if (rid != "") {
                
                IsAdd = false;
                DisableWin();
                setData(rid);
                $('.EditWinBoxVersions').css("display", "block");
                var top = 500;
                $("#divEditWin").css({ top: top })
                        .animate({ "top": "100px" }, "slow");
                
            }
            else {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
            }
            return false;
        }

        function ShowAddForm() {
            $('.EditWinBoxVersions').height("300");
            IsAdd = true;
            DisableWin();
            setData("");
            $('.EditWinBoxVersions').css("display", "block");
            var top = 500;
            $("#divEditWin").css({ top: top })
                        .animate({ "top": "100px" }, "slow");

            return false;
        }

        function ShowDeleteForm() {
            $('.EditWinBoxVersions').css("display", "none");
            if (rid == "" || rid == "0") {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                return false;
            }
            if (confirm("<%=StrSrc("EditWinDelConfirm") %>")){
                var request;
                var row = $('#jQGrid').jqGrid('getRowData', rid);
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGridServerVersions&id=" + rid + "&verid=" + row.VerID + "&Command=Delete&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "get",
                    data: ''
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
                    }
                });
            }
            return false;
        }
        function ShowSearchForm()
        {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function Refresh()
         {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
         }
         function Set2Others(name)
         {
            switch(name)
            {
                case "ddlAgents":
                     $("#<%=ddlFromVersion.ClientID %>").val("NULL");     
                     $("#<%=ddlGroups.ClientID %>").val("0"); 
                     $('#<%=txtProfileID.ClientID %>').val("");
                break;
                case "ddlGroups":
                    $('#<%=ddlAgents.ClientID %>').val("0"); 
                    $("#<%=ddlFromVersion.ClientID %>").val("NULL"); 
                    $('#<%=txtProfileID.ClientID %>').val("");    
                break;
                case "ddlFromVersion":
                    $('#<%=ddlAgents.ClientID %>').val("0"); 
                    $("#<%=ddlGroups.ClientID %>").val("0"); 
                    $('#<%=txtProfileID.ClientID %>').val(""); 
                break;
                 case "txtProfileID":
                     $('#<%=ddlAgents.ClientID %>').val("0"); 
                     $("#<%=ddlFromVersion.ClientID %>").val("NULL");     
                     $("#<%=ddlGroups.ClientID %>").val("0"); 
                break;
            }                  
         }
         function SaveData()
         {
        
            if(((!($('#<%= ddlAgents.ClientID%>').val()) || ($('#<%= ddlAgents.ClientID%>').val()=="0") && $('#<%= txtProfileID.ClientID%>').val()=="" ) && $('#<%= ddlGroups.ClientID%>').val() =="0" && $('#<%= ddlFromVersion.ClientID%>').val()=="NULL") || $('#<%= ddlToVersion.ClientID%>').val()=="NULL")
            {
                alert('<%=StrSrc("MSGCantEdit") %>');
                return;
            }
                      
            if((($('#<%= ddlAgents.ClientID%>').val()!="0" && $('#<%= ddlAgents.ClientID%>').val()!=null) && $('#<%= ddlGroups.ClientID%>').val() !="0") ||
            (($('#<%= ddlAgents.ClientID%>').val()!="0" && $('#<%= ddlAgents.ClientID%>').val()!=null) && ($('#<%= ddlFromVersion.ClientID%>').val()!="NULL" && $('#<%= ddlFromVersion.ClientID%>').val()!=null)) || 
            (($('#<%= txtProfileID.ClientID%>').val()!="" && $('#<%= txtProfileID.ClientID%>').val()!=null) && ($('#<%= ddlFromVersion.ClientID%>').val()!="NULL" && $('#<%= ddlFromVersion.ClientID%>').val()!=null)) || 
            (($('#<%= ddlGroups.ClientID%>').val()!="0" && $('#<%= ddlGroups.ClientID%>').val()!=null) && ($('#<%= ddlFromVersion.ClientID%>').val()!="NULL" && $('#<%= ddlFromVersion.ClientID%>').val()!=null)))
            {
                alert('<%=StrSrc("MSGMastBeOnlyOne") %>');
                return;
            }

            if($("#<%=ddlFromVersion.ClientID %>").val() == $('#<%= ddlToVersion.ClientID%>').val())
            {
                alert('<%=StrSrc("MSGFromTheSameAsTo") %>');
                return;
            }
            var t=CheckRecursive($('#<%= ddlFromVersion.ClientID%>').val(),$('#<%= ddlToVersion.ClientID%>').val(),$("#<%= ddlProjectTypes.ClientID%> option:selected").text());
         }
         function SaveCont(val)
         {
            if(!val)
            {
                alert('<%=StrSrc("MSGRecursive") %>');
                return;
            }

            var AgentOrProfileID = escape($('#<%= ddlAgents.ClientID%>').val()) ;
            if(!IsAgents)
            {
                AgentOrProfileID = escape($('#<%= txtProfileID.ClientID%>').val()) ;;
            }

            if (IsAdd)
                rid = "0";
            var request;
            var row = $('#jQGrid').jqGrid('getRowData', rid);
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddEditGridServerVersions&id=" + rid + "&verid=" + row.VerID + "&Command=" + Command + "&AgentID=" + AgentOrProfileID +
            "&ServerGroupName=" + escape($('#<%= ddlGroups.ClientID%>').val()) + "&FromVersion=" + escape($('#<%= ddlFromVersion.ClientID%>').val()) + "&ToVersion=" + escape($('#<%= ddlToVersion.ClientID%>').val()) + "&ProjectType=" + $('#<%= ddlProjectTypes.ClientID%>').val() +
            "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                UpdatedSuccessfuly();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="")
                        UpdatedSuccessfuly();
                    else
                        UpdatedUnSuccessfuly(jqXHR.responseText);
                }
                else {
                    alert("Error");
                }
            });
         }
         function CheckRecursive(val1,val2,projectType)
         {
         
            var request;
            var row = $('#jQGrid').jqGrid('getRowData', rid);
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=CheckRecursive&ProjectType=" + escape(projectType) + "&val1=" + val1 + "&val2=" + val2 + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                return SaveCont(response);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    return SaveCont(jqXHR.responseText);
                }
                else {
                    alert("Error");
                }
            });
         }



         function SaveDataLayout()
         {
        
            if(((!($('#<%= ddlAgentsLayout.ClientID%>').val()) || $('#<%= ddlAgentsLayout.ClientID%>').val()=="0") && $('#<%= ddlGroupsLayout.ClientID%>').val() =="0" && $('#<%= ddlFromVersionLayout.ClientID%>').val()=="NULL") || $('#<%= ddlToVersionLayout.ClientID%>').val()=="NULL")
            {
                alert('<%=StrSrc("MSGCantEdit") %>');
                return;
            }
                      
            if((($('#<%= ddlAgentsLayout.ClientID%>').val()!="0" && $('#<%= ddlAgentsLayout.ClientID%>').val()!=null) && $('#<%= ddlGroupsLayout.ClientID%>').val() !="0") ||
            (($('#<%= ddlAgentsLayout.ClientID%>').val()!="0" && $('#<%= ddlAgentsLayout.ClientID%>').val()!=null) && ($('#<%= ddlFromVersionLayout.ClientID%>').val()!="NULL" && $('#<%= ddlFromVersionLayout.ClientID%>').val()!=null)) || 
            (($('#<%= ddlGroupsLayout.ClientID%>').val()!="0" && $('#<%= ddlGroupsLayout.ClientID%>').val()!=null) && ($('#<%= ddlFromVersionLayout.ClientID%>').val()!="NULL" && $('#<%= ddlFromVersionLayout.ClientID%>').val()!=null)))
            {
                alert('<%=StrSrc("MSGMastBeOnlyOne") %>');
                return;
            }

            if($("#<%=ddlFromVersionLayout.ClientID %>").val() == $('#<%= ddlToVersionLayout.ClientID%>').val())
            {
                alert('<%=StrSrc("MSGFromTheSameAsTo") %>');
                return;
            }
            var t=CheckRecursiveLayout($('#<%= ddlFromVersionLayout.ClientID%>').val(),$('#<%= ddlToVersionLayout.ClientID%>').val(),$("#<%= ddlProjectTypesLayout.ClientID%> option:selected").text());
         }
         function SaveContLayout(val)
         {
            if(!val)
            {
                alert('<%=StrSrc("MSGRecursive") %>');
                return;
            }

            if (IsAdd)
                rid = "0";
            var request;
            var row = $('#jQGridLayout').jqGrid('getRowData', rid);
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddEditServerLayoutVersion&id=" + rid + "&verid=" + row.VerID + "&Command=" + Command + "&AgentID=" + escape($('#<%= ddlAgentsLayout.ClientID%>').val()) +
            "&ServerGroupName=" + escape($('#<%= ddlGroupsLayout.ClientID%>').val()) + "&FromVersion=" + escape($('#<%= ddlFromVersionLayout.ClientID%>').val()) + "&ToVersion=" + escape($('#<%= ddlToVersionLayout.ClientID%>').val()) + "&ProjectType=" + $('#<%= ddlProjectTypesLayout.ClientID%>').val() +
            "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                UpdatedSuccessfulyLayout();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="")
                        UpdatedSuccessfulyLayout();
                    else
                        UpdatedUnSuccessfulyLayout(jqXHR.responseText);
                }
                else {
                    alert("Error");
                }
            });
         }
         function CheckRecursiveLayout(val1,val2,projectType)
         {
         
            var request;
            var row = $('#jQGrid').jqGrid('getRowData', rid);
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=CheckRecursiveLayout&ProjectType=" + escape(projectType) + "&val1=" + val1 + "&val2=" + val2 + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                return SaveContLayout(response);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    return SaveContLayout(jqXHR.responseText);
                }
                else {
                    alert("Error");
                }
            });
         }


         function setData(id)
         {
         
            if(id != "")
            {
                var row = $('#jQGrid').jqGrid('getRowData', id);
            
                $("#<%=ddlProjectTypes.ClientID %> option").filter(function() {
                    return $(this).text() == row.ProjectTypeName; 
                }).prop('selected', true);

                $('#<%=ddlAgents.ClientID %>').val(row.AgentID.toString().trim() * 1.0); 
                $('#<%=txtProfileID.ClientID %>').val(row.AgentID.toString().trim() * 1.0); 

                SetPrjByType($("#<%=ddlProjectTypes.ClientID %>").val());
               
                var txt=row.ServerGroupName;
                if(txt.length==0)
                    txt=" ";
                $("#<%=ddlGroups.ClientID %> option").filter(function() {
                    return $(this).text() == txt; 
                }).prop('selected', true);

                $("#<%=ddlFromVersion.ClientID %>").val(row.FromVersion);
                $("#<%=ddlToVersion.ClientID %>").val(row.ToVersion);  
            }
            else
            {
            
                $("#<%=ddlProjectTypes.ClientID %>").val("1");  
                $('#<%=ddlAgents.ClientID %>').val("0"); 
                $("#<%=ddlGroups.ClientID %>").val("0"); 
                $("#<%=ddlFromVersion.ClientID %>").val("NULL");              
                $("#<%=ddlToVersion.ClientID %>").val("NULL");     
                SetPrjByType($("#<%=ddlProjectTypes.ClientID %>").val());     
            }
         }
         function setDataLayout(id)
         {
         
            if(id != "")
            {
                var row = $('#jQGridLayout').jqGrid('getRowData', id);
            
                $("#<%=ddlProjectTypesLayout.ClientID %> option").filter(function() {
                    return $(this).text() == row.ProjectTypeName; 
                }).prop('selected', true);

                $('#<%=ddlAgentsLayout.ClientID %>').val(row.AgentID); 
               
                var txt=row.ServerGroupName;
                if(txt.length==0)
                    txt=" ";
                $("#<%=ddlGroupsLayout.ClientID %> option").filter(function() {
                    return $(this).text() == txt; 
                }).prop('selected', true);

                $("#<%=ddlFromVersionLayout.ClientID %>").val(row.FromVersion);
                $("#<%=ddlToVersionLayout.ClientID %>").val(row.ToVersion);    
            }
            else
            {
            
                $("#<%=ddlProjectTypesLayout.ClientID %>").val("1");  
                $('#<%=ddlAgentsLayout.ClientID %>').val("0"); 
                $("#<%=ddlGroupsLayout.ClientID %>").val("0"); 
                $("#<%=ddlFromVersionLayout.ClientID %>").val("NULL");              
                $("#<%=ddlToVersionLayout.ClientID %>").val("NULL");          
            }
         }
        function ShowGrid() {
            jQuery("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GridServerVersions",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','אוכלוסייה','# <%=StrSrc("EditWinAgent") %>', '<%=StrSrc("EditWinGroup") %>', '<%=StrSrc("EditWinFromVersion") %>', '<%=StrSrc("EditWinToVersion") %>','',''],//"<%=StrSrc("EditWinProjectType") %>"
                colModel: [
                            { name: 'VerID', index: 'VerID', width: 0, sorttype: 'int', editable: true, align: 'right', hidden: true },
                            { name: 'ProjectTypeName', index: 'ProjectTypeName', width: 150, sorttype: 'text', editable: true, align: 'right', edittype: "select", editoptions:
                               { value: getProjectTypes() }, editrules: { required: true }
                            },                            
                            { name: 'AgentName', index: 'AgentName', width: 150, sorttype: 'text', editable: true, align: 'right' },
                            { name: 'ServerGroupName', index: 'ServerGroupName', width: 150, sorttype: 'text', align: 'right', editable: true, edittype: "select", editoptions:
                               { value: getGroupsNumbers() }, editrules: { required: true }
                            },
                            { name: 'FromVersion', index: 'FromVersion', width: 150, editable: true, sorttype: 'text', align: 'right' },
                            { name: 'ToVersion', index: 'ToVersion', width: 150, editable: true, sorttype: 'text', align: 'right' },
                            { name: 'VerID', index: 'VerID', width: 0, editable: true, sorttype: 'int', align: 'right',hidden:true },
                            { name: 'AgentID', index: 'AgentID', width: 150, sorttype: 'int', editable: true, align: 'right' ,hidden:true}
                          ],
                rowNum: 10,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: 'VerID',
                viewrecords: true,
                sortorder: 'desc',

                caption: "רשימת גרסאות להורדה",
                onSelectRow: function (id) {
                    rid=id;
                    if ($("#sData").length > 0) {
                        $("#sData")[0].style.display = "block";
                        $("#sData")[0].style.width = "70px";
                    }
                },
               loadComplete: function(data) {
                    $(".ui-pg-div").click(doNone);
                    $("#edit_jQGrid")[0].children[0].onclick = ShowEditForm;
                    $("#add_jQGrid")[0].children[0].onclick = ShowAddForm;
                    $("#del_jQGrid")[0].children[0].onclick = ShowDeleteForm;
                    $("#search_jQGrid")[0].children[0].onclick = ShowSearchForm;
                    $("#refresh_jQGrid")[0].children[0].onclick = Refresh;
               },
               
                editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGridServerVersions&Command=' + Command
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
                           deltext: "מחק"
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
                               //setTimeout(Reload, 500);
                               if ($("#sData").length > 0) {

                                   $("#sData")[0].style.display = "none";
                               }
                               if (response.responseText == "") {

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [true, '']
                               }
                               else {
                                   //debugger;
                                   if (response.responseText.toLowerCase().indexOf('error') == -1 && response.responseText.toLowerCase().indexOf('cannot') == -1)
                                       $('#FormError')[0].innerHTML = "<td class='MsgT' colspan='2'>" + response.responseText + "</td>";
                                   else
                                       $('#FormError')[0].innerHTML = "<td class='MsgError' colspan='2'>" + response.responseText + "</td>";

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [false, response.responseText]//Captures and displays the response text on th Edit window
                               }

                           },
                           editData: {
                               VerID: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },

                               ServerGroupName: function () {

                                   $("#cData")[0].innerText = "Close";
                                   return getCellServerGroupNameValue();
                               },
                               Command: function () {
                                   var value = "Edit";
                                   return value;
                               },
                               ProjectTypeName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellProjectTypeValue();
                               }
                           },
                           addData: {
                               VerID: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },

                               ServerGroupName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellServerGroupNameValue();
                               },
                               Command: function () {
                                   var value = "Add";
                                   return value;
                               },
                               ProjectTypeName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellProjectTypeValue();
                               }
                           }
                       },
                       {
                           closeAfterAdd: true, //Closes the add window after add
                           afterSubmit: function (response, postdata) {
                               if ($("#sData").length > 0) {
                                   $("#sData")[0].style.display = "none";
                               }
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
                               if ($("#sData").length > 0) {
                                   $("#sData")[0].style.display = "none";                                  
                               }
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
                               VerID: function () {

                                   Command = "Delete";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },
                               Command: function () {
                                   var value = "Delete";
                                   return value;
                               }
                           }
                       },

                       {//SEARCH
                           closeOnEscape: true

                       }
                );
        }


        function ShowGridLayout() {
            jQuery("#jQGridLayout").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=GridServerLayoutVersions",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','אוכלוסייה','# <%=StrSrc("EditWinAgent") %>', '<%=StrSrc("EditWinGroup") %>', '<%=StrSrc("EditWinFromVersion") %>', '<%=StrSrc("EditWinToVersion") %>','',''],//"<%=StrSrc("EditWinProjectType") %>"
                colModel: [
                            { name: 'VerID', index: 'VerID', width: 0, sorttype: 'int', editable: true, align: 'right', hidden: true },
                            { name: 'ProjectTypeName', index: 'ProjectTypeName', width: 150, sorttype: 'text', editable: true, align: 'right', edittype: "select", editoptions:
                               { value: getProjectTypes() }, editrules: { required: true }
                            },                            
                            { name: 'AgentName', index: 'AgentName', width: 150, sorttype: 'text', editable: true, align: 'right' },
                            { name: 'ServerGroupName', index: 'ServerGroupName', width: 150, sorttype: 'text', align: 'right', editable: true, edittype: "select", editoptions:
                               { value: getGroupsNumbers() }, editrules: { required: true }
                            },
                            { name: 'FromVersion', index: 'FromVersion', width: 150, editable: true, sorttype: 'text', align: 'right' },
                            { name: 'ToVersion', index: 'ToVersion', width: 150, editable: true, sorttype: 'text', align: 'right' },
                            { name: 'VerID', index: 'VerID', width: 0, editable: true, sorttype: 'int', align: 'right',hidden:true },
                            { name: 'AgentID', index: 'AgentID', width: 150, sorttype: 'int', editable: true, align: 'right' ,hidden:true}
                          ],
                rowNum: 10,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPagerLayout',
                sortname: 'VerID',
                viewrecords: true,
                sortorder: 'desc',

                caption: "גרסאות עיצוב להורדה",
                onSelectRow: function (id) {
                    rid=id;
                    if ($("#sData").length > 0) {
                        $("#sData")[0].style.display = "block";
                        $("#sData")[0].style.width = "70px";
                    }
                },
               loadComplete: function(data) {
                    //$(".ui-pg-div").click(doNone);
                    $("#<%=btnLayoutRef1.ClientID %>").click();
                    $("#<%=btnLayoutRef2.ClientID %>").click();
                    $("#edit_jQGridLayout")[0].children[0].onclick = ShowEditFormLayout;
                    $("#add_jQGridLayout")[0].children[0].onclick = ShowAddFormLayout;
                    $("#del_jQGridLayout")[0].children[0].onclick = ShowDeleteFormLayout;
                    $("#search_jQGridLayout")[0].children[0].onclick = ShowSearchFormLayout;
                    $("#refresh_jQGridLayout")[0].children[0].onclick = RefreshLayout;
               },
               
                editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGridServerVersions&Command=' + Command
            });

            $('#jQGridLayout').jqGrid('navGrid', '#jQGridPagerLayout',
                       {
                           edit: true,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "חיפוש",
                           addtext: "הוסף",
                           edittext: "ערוך",
                           deltext: "מחק"
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
                               //setTimeout(Reload, 500);
                               if ($("#sData").length > 0) {

                                   $("#sData")[0].style.display = "none";
                               }
                               if (response.responseText == "") {

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [true, '']
                               }
                               else {
                      
                                   //debugger;
                                   if (response.responseText.toLowerCase().indexOf('error') == -1 && response.responseText.toLowerCase().indexOf('cannot') == -1)
                                       $('#FormError')[0].innerHTML = "<td class='MsgT' colspan='2'>" + response.responseText + "</td>";
                                   else
                                       $('#FormError')[0].innerHTML = "<td class='MsgError' colspan='2'>" + response.responseText + "</td>";

                                   $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                                   return [false, response.responseText]//Captures and displays the response text on th Edit window
                               }

                           },
                           editData: {
                               VerID: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },

                               ServerGroupName: function () {

                                   $("#cData")[0].innerText = "Close";
                                   return getCellServerGroupNameValue();
                               },
                               Command: function () {
                                   var value = "Edit";
                                   return value;
                               },
                               ProjectTypeName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellProjectTypeValue();
                               }
                           },
                           addData: {
                               VerID: function () {
                                   $("#cData")[0].innerText = "Close";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },

                               ServerGroupName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellServerGroupNameValue();
                               },
                               Command: function () {
                                   var value = "Add";
                                   return value;
                               },
                               ProjectTypeName: function () {
                                   $("#cData")[0].innerText = "Close";
                                   return getCellProjectTypeValue();
                               }
                           }
                       },
                       {
                           closeAfterAdd: true, //Closes the add window after add
                           afterSubmit: function (response, postdata) {
                               if ($("#sData").length > 0) {
                                   $("#sData")[0].style.display = "none";
                               }
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
                               if ($("#sData").length > 0) {
                                   $("#sData")[0].style.display = "none";                                  
                               }
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
                               VerID: function () {

                                   Command = "Delete";
                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'VerID');
                                   return value;
                               },
                               Command: function () {
                                   var value = "Delete";
                                   return value;
                               }
                           }
                       },

                       {//SEARCH
                           closeOnEscape: true

                       }
                );
        }
        //debugger;
        $('#dBody').height($('#dBody').parent().parent().parent().parent().parent().height() - 95.0 + "px");

        function initEditWin() {
            $('#AgentID').on('focus', function () {
                $('#ServerGroupName').val('');
                $('#FromVersion').val('');
            });
            $('#ServerGroupName').on('focus', function () {
                $('#AgentID').val('');
                $('#FromVersion').val('');
            });
            $('#FromVersion').on('focus', function () {
                $('#AgentID').val('');
                $('#ServerGroupName').val('');
            });
        }

        function initGrid() {
            $('.ui-pg-div').on('click', function () {
                setTimeout(initEditWin, 500);
            });
        }
        function Reload(){
            window.location.href = window.location.href;
        }
        
        var IsAgents = true;
        function SetPrjByType(val)
        {
            if(val=="1" || val=="2")//סוכנים או מנהלים
            {
                $('#trAgents').show();
                $('#trProfiles').hide();
                IsAgents = true;
            }
            else if(val=="3")//פרופילים
            {
                $('#trAgents').hide();
                $('#trProfiles').show();
                IsAgents = false;
            }
        }

        function SetFieldOnlyNumbersLocal(id) {
            $('#' + id).keypress(function (event) {

                if (event.which != 8 && isNaN(String.fromCharCode(event.which))) {
                    event.preventDefault(); 
                }
            });
            $('#' + id).bind('input propertychange', function () {
                if (!isNumber($(this).val()))
                    $(this).val("");
            });
        }

        SetFieldOnlyNumbersLocal('<%= txtProfileID.ClientID%>');

        setTimeout(initGrid, 1000);

        $('#nVer').attr("class", "menuLink Selected");
    </script>
</asp:Content>
