<%@ Page Title="הוספת מבצע" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="AddDeals.aspx.cs" Inherits="Pages_Usr_AddDeals"
    UICulture="HE" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="../../css/jquery-ui-1.9.2.custom.css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
    <link rel="stylesheet" href="../../css/NewMain.css" />
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <style type="text/css">
        #droppable
        {
            margin: 10px;
        }
        
        .Fragment h3
        {
            text-align: center;
            margin: 0;
        }
        .ui-widget-content .ui-icon
        {
            background-image: url(../../css/images/ui-icons_222222_256x240.png);
            width: 100%;
        }
        
        #tabs ul
        {
            float: right;
            width: 99%;
        }
        #tabs ul li
        {
            float: right;
            border: 1px solid black;
        }
        .srtableM
        {
            background-color: #E2E3E4;
            height: 100%;
        }
        
        
        .highlight
        {
        }
        .divForm
        {
            margin-top: 10px;
            width: 100%;
            border: 2px groove gray;
            float: right;
            text-align: right;
            height: 610px;
        }
        .FragmentDiv
        {
            float: right;
        }
        .FragmentAfteDivr
        {
            float: right;
        }
        .TabShow
        {
            color: White !important;
            background-color: Gray;
        }
        .TabSelected
        {
            color: Orange !important;
            background-color: Gray;
        }
        .TabNotSelected
        {
            color: White !important;
            background-color: Gray;
        }
        .TabContent
        {
        }
        .dContent
        {
            height: 500px;
            width: 510px;
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            margin-right: 10px;
            background-color: gray;
            float: right;
            background-color: #A2A2A2;
            height: 650px;
            overflow-y: auto;
            overflow-x: hidden;
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            border-top: 2px solid #E2E3E4;
        }
        .dHeader
        {
            background-color: #4F81BD;
            color: White;
            -webkit-box-shadow: 0 0 1px 3px #4476B inset;
            -moz-box-shadow: 0 0 1px 3px #4476B inset;
            box-shadow: 0 0 1px 3px #4476B inset;
            font-size: 16px;
            height: 35px;
        }
        .rbl1
        {
            color: White !important;
        }
        .addSaltem
        {
            border-top: 2px solid white;
            padding-top: 5px;
        }
        .addSalHeader
        {
            width: 40%;
            font-weight: 700;
        }
        .MadregotTbl
        {
            font-weight: 700;
            text-align: center;
        }
        
        .dMin
        {
            text-align: center width:350px;
            position: absolute;
            top: 200px;
            left: 42%;
            background-color: #A2A2A2;
            height: 500px;
            overflow-y: auto;
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            margin-right: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <div id="tabs" style="text-align: right; direction: rtl; height: 730px" class="srtableM">
            <ul runat="server" id="tabsUl" style="text-align: right; direction: rtl;">
                <li><a id="Tab_0" class="TabShow" onclick="javascript:onTabClick(this.id,0);">כותרת</a>
                </li>
                <li><a id="Tab_1" class="TabShow" onclick="javascript:onTabClick(this.id,1);">נתונים
                    כלליים</a> </li>
                <li><a id="Tab_2" class="TabShow" onclick="javascript:onTabClick(this.id,2);">לקוחות</a>
                </li>
                <li><a id="Tab_3" class="TabShow" onclick="javascript:onTabClick(this.id,3);">פריטים</a>
                </li>
                <li><a id="Tab_4" class="TabShow" onclick="javascript:onTabClick(this.id,4);">מדרגות</a>
                </li>
            </ul>
            <div style="height: 40px;">
                &nbsp;</div>
            <div id="dContent" class="">
                <br />
                <div id="Con0" class="TabContent dContent">
                    <div class="dHeader">
                        <div class="h3HeaderText" style="margin-right: 220px; font-size: 16px; font-weight: 700;
                            padding-top: 5px;">
                            כותרת</div>
                    </div>
                    <table cellpadding="2" cellspacing="2" style="color: White; padding-top: 10px;">
                        <tr>
                            <td style="vertical-align: top;">
                                תאור מבצע:
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txtTeurMivza" TextMode="MultiLine" Rows="4" Width="400px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: top;">
                                הערה:
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txtComment" TextMode="MultiLine" Rows="3" Width="400px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                מתאריך:
                            </td>
                            <td>
                                <input id="txtDate" type="text" class="dtp txtDate" value="26/02/2014" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                עד תאריך:
                            </td>
                            <td>
                                <input id="txtUntilDate" type="text" class="dtp txtDate" value="26/02/2014" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="Con1" class="TabContent dContent">
                    <div class="dHeader">
                        <div class="h3HeaderText" style="margin-right: 220px; font-size: 16px; font-weight: 700;
                            padding-top: 5px;">
                            נתונים כלליים</div>
                    </div>
                    <div>
                        <table cellpadding="2" cellspacing="2" style="color: White;">
                            <tr>
                                <td>
                                    סוג מבצע:
                                </td>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlSugMivza" onchange="ddlSugMivza_change();">
                                        <asp:ListItem Selected="True" Text="קנה קבל / הנחות" Value="1"></asp:ListItem>
                                        <asp:ListItem Selected="False" Text="סלים" Value="2"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="dKne">
                        <asp:RadioButtonList runat="server" ID="rbl1" CssClass="rbl1">
                            <asp:ListItem Selected="True" Text="ערך כספי" Value="1"></asp:ListItem>
                            <asp:ListItem Selected="False" Text="כמות" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div id="dSalim">
                        <table cellpadding="2" cellspacing="0" style="color: White; padding-top: 10px; padding-right: 10px;"
                            width="80%" id="tblPritim">
                            <tr>
                                <td class="addSalHeader" style="width: 260px;">
                                    קוד פריט
                                </td>
                                <td class="addSalHeader" style="width: 70px; white-space: nowrap;">
                                    כמות &nbsp;&nbsp; <a href="#" onclick="AddParit();" style="font-size: 14px; color: White;">
                                        הוסף פריט</a>
                                </td>
                            </tr>
                            <tr id="trParit">
                                <td class="addSaltem">
                                    <asp:DropDownList runat="server" ID="ddlPritim" Width="90%">
                                    </asp:DropDownList>
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="txt2" style="width: 35%;" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div id="Con2" class="TabContent dContent">
                    <div>
                        <div class="dHeader">
                            <div class="h3HeaderText" style="padding-top: 5px; right: 3px; position: fixed;">
                                <asp:CheckBox runat="server" ID="cbAllCust" Text="כולם" onchange="cbAllCustClick();" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <span style="font-size: 16px; font-weight: 700;">זכאים </span>
                            </div>
                        </div>
                        <div style="color: White;">
                            <table width="100%">
                                <tr>
                                    <td style="vertical-align: top;">
                                        לקוחות:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblCustomers" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblCustomers();" />
                                        <div style="height: 250px; overflow-y: scroll; position: fixed; display: none;" runat="server"
                                            id="cblCustomers">
                                            <asp:CheckBoxList runat="server" ID="cblCustomersI" Width="342px" Style="background-color: White;
                                                color: Black; padding-right: 6px;">
                                            </asp:CheckBoxList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        קבוצות לקוחות:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblCustomersGroups" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblGroups();" />
                                        <asp:CheckBoxList runat="server" ID="cblCustomersGroups" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="קבוצה 1" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 2" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 3" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 4" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        אזור גאוגרפי:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="SelcblGeo" style="width: 350px; margin-right: 7px;
                                            z-index: 1; background-image: url('../../Img/selArrow.png'); background-repeat: no-repeat;"
                                            onclick="ShowcblGeo();" />
                                        <asp:CheckBoxList runat="server" ID="cblGeo" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="צפון" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="דרום" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="מזרח" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="מערב" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        סוג לקוח:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblCustType" style="width: 350px; margin-right: 7px;
                                            z-index: 1; background-image: url('../../Img/selArrow.png'); background-repeat: no-repeat;"
                                            onclick="ShowcblCustType();" />
                                        <asp:CheckBoxList runat="server" ID="cblCustType" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="פרטי" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="מסחרי" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="מנהל" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="סוכן" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <div>
                        <div class="dHeader">
                            <div class="h3HeaderText" style="padding-top: 5px; right: 3px; position: fixed;">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <span style="font-size: 16px; font-weight: 700;">החרגה </span>
                            </div>
                        </div>
                        <div style="color: White;">
                            <table width="100%">
                                <tr>
                                    <td style="vertical-align: top;">
                                        לקוחות:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblHachragaCust" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblHachragaCust();" />
                                        <div style="height: 250px; overflow-y: scroll; position: fixed; display: none;" runat="server"
                                            id="cblHachragaCust">
                                            <asp:CheckBoxList runat="server" ID="cblHachragaCustl" Width="350px" Style="background-color: White;
                                                color: Black; padding-right: 6px;">
                                            </asp:CheckBoxList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        קבוצות לקוחות:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblHachragaGroups" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblHachragaGroups();" />
                                        <asp:CheckBoxList runat="server" ID="cblHachragaGroups" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="קבוצה 1" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 2" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 3" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 4" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        אזור גאוגרפי:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblHargaGeo" style="width: 350px; margin-right: 7px;
                                            z-index: 1; background-image: url('../../Img/selArrow.png'); background-repeat: no-repeat;"
                                            onclick="ShowcblHargaGeo();" />
                                        <asp:CheckBoxList runat="server" ID="cblHargaGeo" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="צפון" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="דרום" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="מזרח" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="מערב" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        סוג לקוח:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblHachragaTypeCust" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblHachragaTypeCust();" />
                                        <asp:CheckBoxList runat="server" ID="cblHachragaTypeCust" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="פרטי" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="מסחרי" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="מנהל" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="סוכן" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="Con3" class="TabContent dContent">
                    <div>
                        <div class="dHeader">
                            <div class="h3HeaderText" style="padding-top: 5px; right: 3px; position: fixed;">
                                <asp:CheckBox runat="server" ID="cbAllPritim" Text="כולם" onchange="cbAllcblItemsClick();" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <span style="font-size: 16px; font-weight: 700;">זכאים </span>
                            </div>
                        </div>
                        <div style="color: White;">
                            <table width="100%">
                                <tr>
                                    <td style="vertical-align: top;">
                                        פריטים:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblItems" style="width: 350px; margin-right: 7px;
                                            z-index: 1; background-image: url('../../Img/selArrow.png'); background-repeat: no-repeat;"
                                            onclick="ShowcblItems();" />
                                            <div style="height: 250px; overflow-y: scroll;position: fixed;display: none; " runat="server" id="cblItems">
                                        <asp:CheckBoxList runat="server" ID="cblItemsl" Width="350px" Style="background-color: White;
                                                color: Black; padding-right: 6px;">
                                        </asp:CheckBoxList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        קבוצת פריט:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblPrGroups" style="width: 350px; margin-right: 7px;
                                            z-index: 1; background-image: url('../../Img/selArrow.png'); background-repeat: no-repeat;"
                                            onclick="ShowcblPrGroups();" />
                                        <asp:CheckBoxList runat="server" ID="cblPrGroups" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="קבוצה 1" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 2" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 3" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 4" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        סוג פריט:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblPrTypes" style="width: 350px; margin-right: 7px;
                                            z-index: 1; background-image: url('../../Img/selArrow.png'); background-repeat: no-repeat;"
                                            onclick="ShowcblPrTypes();" />
                                        <asp:CheckBoxList runat="server" ID="cblPrTypes" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="מאכל" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="שתייה" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="חמוצים" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="חריפים" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <div>
                        <div class="dHeader">
                            <div class="h3HeaderText" style="padding-top: 5px; right: 3px; position: fixed;">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <span style="font-size: 16px; font-weight: 700;">החרגה </span>
                            </div>
                        </div>
                        <div style="color: White;">
                            <table width="100%">
                                <tr>
                                    <td style="vertical-align: top;">
                                        פריטים:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblHachragaPr" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblHachragaPr();" />
                                            <div style="height: 250px; overflow-y: scroll; position: fixed; display: none;" runat="server"
                                            id="cblHachragaPr">
                                        <asp:CheckBoxList runat="server" ID="cblHachragaPrl" Width="350px" Style="background-color: White;
                                                color: Black; padding-right: 6px;">
                                        </asp:CheckBoxList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        קבוצת פריט:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblHachragaGroupsPr" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblHachragaGroupsPr();" />
                                        <asp:CheckBoxList runat="server" ID="cblHachragaGroupsPr" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="קבוצה 1" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 2" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 3" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="קבוצה 4" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        סוג פריט:
                                    </td>
                                    <td>
                                        <input type="text" readonly="readonly" id="selcblSugPrHachraga" style="width: 350px;
                                            margin-right: 7px; z-index: 1; background-image: url('../../Img/selArrow.png');
                                            background-repeat: no-repeat;" onclick="ShowcblSugPrHachraga();" />
                                        <asp:CheckBoxList runat="server" ID="cblSugPrHachraga" Width="350px" Style="display: none;
                                            position: fixed; background-color: White; color: Black; padding-right: 6px; z-index: 9999;">
                                            <asp:ListItem Text="מאכל" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="שתייה" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="חמוצים" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="חריפים" Value="4"></asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="Con4" class="TabContent dContent">
                    <div class="dHeader">
                        <div class="h3HeaderText" style="margin-right: 220px; font-size: 16px; font-weight: 700;
                            padding-top: 5px;">
                            מדרגות <a href="#" onclick="addPrMin();" style="font-size: 14px; padding-right: 65%;
                                color: White;">הוסף </a>
                        </div>
                    </div>
                    <div>
                        <table cellpadding="2" cellspacing="0" style="color: White; padding-top: 10px; padding-right: 10px;"
                            width="99%" id="tblPrr">
                            <tr>
                                <td class="MadregotTbl" style="width: 80px;">
                                    כמות קנה מ-
                                </td>
                                <td class="MadregotTbl" style="width: 70px;">
                                    כמות קנה עד
                                </td>
                                <td class="MadregotTbl" style="width: 70px;">
                                    כמות קבל
                                </td>
                                <td class="MadregotTbl" style="width: 50px;">
                                    % הנחה
                                </td>
                                <td class="MadregotTbl" style="width: 50px;">
                                    מחיר
                                </td>
                                <td class="MadregotTbl" style="width: 70px;">
                                    התניית מינימום
                                </td>
                            </tr>
                            <tr id="trPrMin0" style="display: none;">
                                <td class="addSaltem">
                                    <input type="text" id="Text8" style="width: 80px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text9" style="width: 70px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text10" style="width: 70px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text11" style="width: 50px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text12" style="width: 50px;" />
                                </td>
                                <td class="addSaltem">
                                    <a style="color: Blue;" href="#" onclick="addPrTblMin(this.id,this.innerText);" class="trclsPrMin00"
                                        id="Agg0">0 רשומות</a>
                                </td>
                            </tr>
                            <tr id="trPrMin1">
                                <td class="addSaltem">
                                    <input type="text" id="Text3" style="width: 80px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text1" style="width: 70px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text4" style="width: 70px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text5" style="width: 50px;" />
                                </td>
                                <td class="addSaltem">
                                    <input type="text" id="Text6" style="width: 50px;" />
                                </td>
                                <td class="addSaltem">
                                    <a style="color: Blue;" href="#" onclick="addPrTblMin(this.id,this.innerText);" class="trclsPrMin0"
                                        id="Agg01">0 רשומות</a>
                                </td>
                            </tr>
                        </table>
                        <div id="dMin" style="display: none; vertical-align: bottom; text-align: left;" class="dMin">
                            <div style="height: 460px; overflow-y: auto;">
                                <table cellpadding="2" cellspacing="0" style="color: White; padding-top: 10px; padding-right: 10px;
                                    text-align: right;" width="100%" id="tblMinPrrrr">
                                    <tr>
                                        <td class="addSalHeader" style="width: 260px;">
                                            קוד פריט
                                        </td>
                                        <td class="addSalHeader" style="width: 70px; white-space: nowrap;">
                                            כמות מינימלית &nbsp;&nbsp;&nbsp;&nbsp; <a href="#" onclick="AddMinParit();" style="font-size: 14px;
                                                color: White;">הוסף פריט</a>
                                        </td>
                                    </tr>
                                    <tr id="trMin1" class="trMin">
                                        <td class="addSaltem">
                                            <input type="text" id="Text7" style="width: 95%;" />
                                        </td>
                                        <td class="addSaltem">
                                            <input type="text" id="Text2" style="width: 35%;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <input type="button" value="שמור" onclick="SetRowes();" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                                width: 80px; margin-left: 5px;" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="bottom: 150px; right: 10px; position: fixed;">
        <input type="button" value="שמור" onclick="alert('הנתונים נשמרו בהצלחה');" class="MSBtnGeneral"
            style="background-image: url('../../Img/ok.png'); width: 80px;" />
    </div>
    <asp:HiddenField runat="server" ID="hdnSelectedTabID" />
    <script type="text/javascript">
        //$('#tabs').height($(document).height() - 90 + "px");

        var arrTabIDsTouch = new Array(6);
        arrData = new Array(6);
        arrOuterData = new Array(6);
        arrTabIDs = new Array(6);
        arrTabIDsTouch = new Array(6);

        arrTabIDsTouch[0] = true;

        function DoNow() {

            $(function () {

                $("#tabs").tabs();
                $("#tabs").css("direction", "rtl")
                $("#tabs").css("text-align", "right");
                $('#tabs').click('tabsselect', function (event, ui) {

                    selectedTab = $("#tabs").tabs('option', 'active');
                    $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);
                });
            });
        }
        DoNow();

        var openerID = "";

        var SelectedTab = "1";
        var lastIndex = 0;
        var arrData;
        var arrOuterData;
        var arrTabIDs;
        var arrTabIDsTouch;
        var EmptyObj;
        function onTabClick(tabID, index) {
            arrTabIDsTouch[tabID.replace("Tab_", "")] = true;
            $('#Tab_' + SelectedTab)[0].className = "TabNotSelected";
            var oldTab = SelectedTab;
            SelectedTab = tabID.replace("Tab_", "");

            $('#<%=hdnSelectedTabID.ClientID %>').val(SelectedTab);

            var data = $('#Con' + SelectedTab)[0].innerHTML;
            var dataOuter = $('#Con' + SelectedTab)[0].outerHTML;

            HideAllTabsContent();
            $('#Con' + SelectedTab)[0].style.display = "block";

            $('#' + tabID)[0].className = "TabSelected";

            if (lastIndex > -1) {
                arrData[oldTab] = data;
                arrOuterData[oldTab] = dataOuter;
                arrTabIDs[oldTab] = oldTab;
            }
            lastIndex = index;
        }
        function ObjClick(id) {
            setTimeout(CheckForAddFragment, 200);
            isDragging = true;

            ObjID = id;

            ClosedivAddReport();
        }

        function HideAllTabsContent() {
            for (var i = 0; i < $('.TabContent').length; i++) {
                $('.TabContent')[i].style.display = "none";
            }
        }
        HideAllTabsContent();

        function AddParit() {
            $('#tblPritim').append($('#trParit')[0].outerHTML);
        }

        function ddlSugMivza_change() {
            if ($('#<%=ddlSugMivza.ClientID %>').val() == "1") {//קנה קבל
                $('#dSalim').block({ message: '' });
                $("#dKne").unblock();
            }
            else {
                $('#dKne').block({ message: '' });
                $("#dSalim").unblock();
            }
        }
        function cbAllCustClick() {
            if ($('#<%=cbAllCust.ClientID %>')[0].checked) {
                for (var i = 0; i < $('#<%=cblCustomersI.ClientID %>')[0].childNodes[1].childNodes.length; i++) {
                    $('#<%=cblCustomersI.ClientID %>')[0].childNodes[1].childNodes[i].children[0].children[0].checked = true;
                }
            }
            else {
                for (var i = 0; i < $('#<%=cblCustomersI.ClientID %>')[0].childNodes[1].childNodes.length; i++) {
                    $('#<%=cblCustomersI.ClientID %>')[0].childNodes[1].childNodes[i].children[0].children[0].checked = false;
                }
            }
        }
        function cbAllcblItemsClick() {
            if ($('#<%=cbAllPritim.ClientID %>')[0].checked) {
                for (var i = 0; i < $('#<%=cblItemsl.ClientID %>')[0].childNodes[1].childNodes.length; i++) {
                    $('#<%=cblItemsl.ClientID %>')[0].childNodes[1].childNodes[i].children[0].children[0].checked = true;
                }
            }
            else {
                for (var i = 0; i < $('#<%=cblItemsl.ClientID %>')[0].childNodes[1].childNodes.length; i++) {
                    $('#<%=cblItemsl.ClientID %>')[0].childNodes[1].childNodes[i].children[0].children[0].checked = false;
                }
            }
        }


        function ShowcblCustomers() {
            if ($('#<%=cblCustomers.ClientID %>').css("display") == "none") {
                $('#<%=cblCustomers.ClientID %>').show().slideDown("slow");

            }
            else {
                $('#<%=cblCustomers.ClientID %>').hide().slideUp("slow");
                $('#selcblCustomers').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblCustomersI')).toString() + " לקוחות");
            }
        }
        function ShowcblGroups() {
            if ($('#<%=cblCustomersGroups.ClientID %>').css("display") == "none") {
                $('#<%=cblCustomersGroups.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblCustomersGroups.ClientID %>').hide().slideUp("slow");
                $('#selcblCustomersGroups').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblCustomersGroups')).toString() + " קבוצות ללקוחות");
            }
        }
        function ShowcblGeo() {
            if ($('#<%=cblGeo.ClientID %>').css("display") == "none") {
                $('#<%=cblGeo.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblGeo.ClientID %>').hide().slideUp("slow");
                $('#SelcblGeo').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblGeo')).toString() + " אזורים גאוגרפים");
            }
        }
        function ShowcblCustType() {
            if ($('#<%=cblCustType.ClientID %>').css("display") == "none") {
                $('#<%=cblCustType.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblCustType.ClientID %>').hide().slideUp("slow");
                $('#selcblCustType').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblCustType')).toString() + " סוגיי לקוח");
            }
        }

        function ShowcblHachragaCust() {
            if ($('#<%=cblHachragaCust.ClientID %>').css("display") == "none") {
                $('#<%=cblHachragaCust.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblHachragaCust.ClientID %>').hide().slideUp("slow");
                $('#selcblHachragaCust').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblHachragaCustl')).toString() + " לקוחות");
            }
        }
        function ShowcblHachragaGroups() {
            if ($('#<%=cblHachragaGroups.ClientID %>').css("display") == "none") {
                $('#<%=cblHachragaGroups.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblHachragaGroups.ClientID %>').hide().slideUp("slow");
                $('#selcblHachragaGroups').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblHachragaGroups')).toString() + " קבוצות ללקוחות");
            }
        }
        function ShowcblHargaGeo() {
            if ($('#<%=cblHargaGeo.ClientID %>').css("display") == "none") {
                $('#<%=cblHargaGeo.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblHargaGeo.ClientID %>').hide().slideUp("slow");
                $('#selcblHargaGeo').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblHargaGeo')).toString() + " אזורים גאוגרפים");
            }
        }
        function ShowcblHachragaTypeCust() {
            if ($('#<%=cblHachragaTypeCust.ClientID %>').css("display") == "none") {
                $('#<%=cblHachragaTypeCust.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblHachragaTypeCust.ClientID %>').hide().slideUp("slow");
                $('#selcblHachragaTypeCust').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblHachragaTypeCust')).toString() + " סוגיי לקוח");
            }
        }
        function ShowcblItems() {
            if ($('#<%=cblItems.ClientID %>').css("display") == "none") {
                $('#<%=cblItems.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblItems.ClientID %>').hide().slideUp("slow");
                $('#selcblItems').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblItemsl')).toString() + " פריטים");
            }
        }
        function ShowcblPrGroups() {
            if ($('#<%=cblPrGroups.ClientID %>').css("display") == "none") {
                $('#<%=cblPrGroups.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblPrGroups.ClientID %>').hide().slideUp("slow");
                $('#selcblPrGroups').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblPrGroups')).toString() + " קבוצות פריטים");
            }
        }
        function ShowcblPrTypes() {
            if ($('#<%=cblPrTypes.ClientID %>').css("display") == "none") {
                $('#<%=cblPrTypes.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblPrTypes.ClientID %>').hide().slideUp("slow");
                $('#selcblPrTypes').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblPrTypes')).toString() + " סוגיי פריטים");
            }
        }
        function ShowcblHachragaPr() {
            if ($('#<%=cblHachragaPr.ClientID %>').css("display") == "none") {
                $('#<%=cblHachragaPr.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblHachragaPr.ClientID %>').hide().slideUp("slow");
                $('#selcblHachragaPr').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblHachragaPrl')).toString() + " פריטים");
            }
        }
        function ShowcblHachragaGroupsPr() {
            if ($('#<%=cblHachragaGroupsPr.ClientID %>').css("display") == "none") {
                $('#<%=cblHachragaGroupsPr.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblHachragaGroupsPr.ClientID %>').hide().slideUp("slow");
                $('#selcblHachragaGroupsPr').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblHachragaGroupsPr')).toString() + " קבוצות פריטים");
            }
        }

        function ShowcblSugPrHachraga() {
            if ($('#<%=cblSugPrHachraga.ClientID %>').css("display") == "none") {
                $('#<%=cblSugPrHachraga.ClientID %>').show().slideDown("slow");
            }
            else {
                $('#<%=cblSugPrHachraga.ClientID %>').hide().slideUp("slow");
                $('#selcblSugPrHachraga').val("נבחרו " + GetCountSelected($('#ContentPlaceHolder1_cblSugPrHachraga')).toString() + " סוגיי פריטים");
            }
        }
        function GetCountSelected(obj) {
            var counter = 0;
            for (var i = 0; i < obj[0].childNodes[1].childNodes.length; i++) {
                try {
                    if (obj[0].childNodes[1].childNodes[i].children[0].children[0] && obj[0].childNodes[1].childNodes[i].children[0].children[0].checked)
                        counter++;
                }
                catch (e) {
                }
            }
            return counter;
        }
        var indexPrMin = 0;
        function addPrMin() {
            indexPrMin++;
            $('#trPrMin0').show();
            var htm = $('#trPrMin0')[0].outerHTML;
            $('#trPrMin0').hide();

            htm = htm.replace("Agg0", "Agg" + indexPrMin.toString());
            htm = htm.replace("trclsPrMin0", "trPrMin" + indexPrMin.toString());
            $('#tblPrr').append(htm);
        }
        function AddMinParit() {

            $('#tblMinPrrrr').append($('#trMin1')[0].outerHTML);

        }
        function addPrTblMin(id, counter) {
            counter = counter.replace(" רשומות", "") * 1.0;
            ///alert(counter);
            openerID = $('#' + id)[0].className;
            $('#dMin').show();

            var arr = "";
            for (var i = 1; i < $('.trMin').length; i++) {

                $('.trMin')[i].style.display = "none";
                arr += $('.trMin')[i].id = ";";
            }
            var arrReal = arr.split(";");
            for (var i = 0; i < arrReal.length; i++) {
                $('#' + arrReal[i])[i].outerHTML = "";
            }

        }
        function removeElement(id) {
            //alert(id);
            var myNode = document.getElementById(id);
            myNode.removeChild(myNode);
            //            while (myNode.firstChild) {
            //                myNode.removeChild(myNode.firstChild);
            //            }
        }
        function SetRowes() {
            var size = 0;
            for (var i = 0; i < $(".trMin").length; i++) {
                if ($(".trMin")[i].style.display != "none")
                    size++;
            }
            $('.' + openerID).text(size + " רשומות");
            $('#dMin').hide();
        }

        $(".dtp").datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'dd/mm/yy'
        });

        var d = new Date();

        var month = d.getMonth() + 1;
        var day = d.getDate();

        var output = (day < 10 ? '0' : '') + day + '/' +
                    (month < 10 ? '0' : '') + month + '/' +
                    d.getFullYear();

        $('.txtDate').val(output);
        //$('.txtDate').val("27/11/2014");

        setTimeout('SetMSG("הוספת מבצע")', 100);

        $('#nVer').attr("class", "menuLink Selected");

        onTabClick("Tab_0", 0);

        setTimeout(' SetFotter();', 100);

        $('#dSalim').block({ message: '' });

    </script>
</asp:Content>
