<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ctlPopulations.ascx.cs"
    Inherits="Controls_ctlPopulations" %>
<script type="text/javascript">    
var selectedTab = "tabAgents";
    function CloseEditctlPopulationsBox() {

        $(".ctlPopulations").css({ top: 100 })
                            .animate({ "top": "-900" }, "high");
        setTimeout('ClosePop();',1000);
        //        $("#dBody").unblock();
    }
    function ClosePop() {
        //$(".ctlPopulations").hide();
    }
    function HideByName(name) {
        switch (name) {
            case "Agents":
                $(".tabAgents").hide();
                break;
            case "Customers":
                $(".tabCustomers").hide();
                break;
            case "Items":
                $(".tabItems").hide();
                break;
            case "Categories":
                $(".tabCategories").hide();
                break;
        }
    }  
</script>
<style type="text/css">
    #tabs ul
    {
        text-align: right;
        direction: rtl;
        width: 99%;
    }
    #tabs ul li
    {
        float: right;
        text-align: right;
        direction: rtl;
        padding: 0.2em;
        margin: 2px;
        font-size: 14px;
    }
    .til
    {
        background-color: Gray;
        border: 1px solid black;
    }
    .newul
    {
        float: none;
        clear: both;
        vertical-align: middle;
    }
    .srtableM
    {
        height: 100%;
    }
    .tabUI
    {
        height: 520px;
        overflow-y: auto;
        overflow-x: hidden;
        clear: both;
        
    }
</style>
<asp:ScriptManager runat="server"></asp:ScriptManager>
<asp:UpdatePanel runat="server" ID="UPALL">
    <ContentTemplate>
    
    
<div style="background-color: #A2A2A2; color: White;" id="dPopulations" runat="server"
    class="ctlPopulations">
    <div class="JumpWiX" style="padding-right:3px;padding-top:2px;">
        <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseEditctlPopulationsBox();" />
    </div>
    <div style="padding-top: 3px; background-color: #244062;">
        <center>
            <div id="sHeadEdit">
                אוכלוסיות
            </div>
        </center>
    </div>
    <div id="tabs" class="srtableM" style="text-align: right; direction: rtl; width: 99.2%;">
        <ul id="tabsUl" style="text-align: right; direction: rtl; background-color: #3E3647;"
            class="til">
            <li onclick="onTabClick('tabAgents');" id="tabAgentsServer" runat="server" class="til tabAgents">סוכנים</li>
            <li onclick="onTabClick('tabCustomers');" id="tabCustomersServer" runat="server" class="til tabCustomers">לקוחות</li>
            <li onclick="onTabClick('tabItems');" id="tabItemsServer" runat="server" class="til tabItems">פריטים</li>
            <li onclick="onTabClick('tabCategories');" id="tabCategoriesServer" runat="server" class="til tabCategories">קטגוריות</li>
        </ul>
    </div>
    <div style="clear: both;">
    </div>
    <div id="tabAgents" class="tabUI">
        <ul id="ulMain" runat="server" >
        </ul>
    </div>
    <div id="tabCustomers" class="tabUI"> 
        <ul id="ulcustomers" runat="server">
        </ul>
    </div>
    <div id="tabItems" class="tabUI">
        <ul id="ulItems" runat="server">
        </ul>
    </div>
    <div id="tabCategories" class="tabUI">
        <ul id="ulCategories" runat="server">
        </ul>
    </div>
    <div style="padding-top: 5px;">
        <center>
            <input type="button" value="ביטול" class="MSBtnGeneral" style="background-image: url('../../Img/cancel16.png');
                width: 90px;" onclick="CloseEditctlPopulationsBox();" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="אישור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 90px;" onclick="SaveData();" />
        </center>
    </div>
</div>
<asp:HiddenField runat="server" ID="hdnPops" />
<asp:HiddenField runat="server" ID="hdnPopsValuesItemsInit" />
<asp:HiddenField runat="server" ID="hdnParentsPopulation" />
<asp:HiddenField runat="server" ID="hdnItemsPopulation" />
<asp:HiddenField runat="server" ID="hdnUnCheckedPopulation" />
<asp:HiddenField runat="server" ID="hdnSelectedTabID" />
<asp:HiddenField runat="server" ID="hdnTskID" />
<asp:HiddenField runat="server" ID="hdnTreePopulation" Value=""/>
<asp:Button runat="server" ID="btnInit" OnClick="btnInit_Click" style="display:none;"/>
</ContentTemplate>
</asp:UpdatePanel>
<script type="text/javascript">
   
    
    function DoNow() {
        $(function () {

            $("#tabs").tabs();
            //$('#tabs').tabs().tabs('rotate', 2000, 'true');
            $("#tabs").css("direction", "rtl")
            $("#tabs").css("text-align", "right");

            $('#tabs').height("30px");
            $('#tabs').width("98.5%");

            $('#tabs').click('tabsselect', function (event, ui) {

                $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);
            });

            $('#tabAgents').tree({
                collapseUiIcon: 'ui-icon-plus',
                expandUiIcon: 'ui-icon-minus',
                //leafUiIcon: 'ui-icon-bullet',

                onCheck: {
                    ancestors: 'checkIfFull',
                    descendants: 'check'
                },
                onUncheck: {
                    ancestors: 'uncheck'
                }
            });

            

            $('#tabCustomers').tree({
                collapseUiIcon: 'ui-icon-plus',
                expandUiIcon: 'ui-icon-minus',
                //leafUiIcon: 'ui-icon-bullet',

                onCheck: {
                    ancestors: 'checkIfFull',
                    descendants: 'check'
                },
                onUncheck: {
                    ancestors: 'uncheck'
                }
            });
            

            $('#tabItems').tree({
                collapseUiIcon: 'ui-icon-plus',
                expandUiIcon: 'ui-icon-minus',
                //leafUiIcon: 'ui-icon-bullet',

                onCheck: {
                    ancestors: 'checkIfFull',
                    descendants: 'check'
                },
                onUncheck: {
                    ancestors: 'uncheck'
                }
            });
            

            $('#tabCategories').tree({
                collapseUiIcon: 'ui-icon-plus',
                expandUiIcon: 'ui-icon-minus',
                //leafUiIcon: 'ui-icon-bullet',

                onCheck: {
                    ancestors: 'checkIfFull',
                    descendants: 'check'
                },
                onUncheck: {
                    ancestors: 'uncheck'
                }
            });
            
        });
    }
    DoNow();

    function onTabClick(tabID) {
        $('#tabAgents').hide();
        $('#tabCustomers').hide();
        $('#tabItems').hide();
        $('#tabCategories').hide();
        
        $('.' + selectedTab)[0].style.color = "white";

        $('#' + tabID).show();
        $('.' + tabID)[0].style.color = "orange";

        selectedTab = tabID;
    }
    //onTabClick(selectedTab);

   
    function SaveData() {
        var parentRes = "";
        var ItemsRes = "";
        var ItemsResUnchecked = "";

        //var  
        counterr = 0;
        for (var i = 0; i < $('.cbtreeParent').length; i++) {
            if ($('.cbtreeParent')[i].checked) {
                parentRes += $('.cbtreeParent')[i].id.replace("ctlPopulationsR_cb_", "").replace(",", "") + ',';
                counterr++;
            }
        }
        if (parentRes.length > 1)
            parentRes = parentRes.substr(0, parentRes.length - 1);
        //debugger;
        for (var i = 0; i < $('.cbtree').length; i++) {
            if ($('.cbtree')[i].checked) {
                ItemsRes += $('.cbtree')[i].id.replace("ctlPopulationsR_cb_", "").replace(",", "") + ',';
                counterr++;
            }
            else {
                ItemsResUnchecked += $('.cbtree')[i].id.replace("ctlPopulationsR_cb_", "").replace(",","") + ',';
            }
        }
        if (ItemsRes.length > 1)
            ItemsRes = ItemsRes.substr(0, ItemsRes.length - 1);


        $('#<%=hdnPops.ClientID %>').val("נבחרו " + counterr + " פריטים");
        $('#<%=hdnParentsPopulation.ClientID %>').val(parentRes);
        $('#<%=hdnItemsPopulation.ClientID %>').val(ItemsRes);

        $('#<%=hdnUnCheckedPopulation.ClientID %>').val(ItemsResUnchecked);

        CloseEditctlPopulationsBox();

        SavePops();


    }
    
    function initData() {
        $('#<%=btnInit.ClientID %>')[0].click();
    }
    setTimeout("initData();", 1000);
</script>
