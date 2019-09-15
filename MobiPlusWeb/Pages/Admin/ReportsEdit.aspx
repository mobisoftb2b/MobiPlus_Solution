<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportsEdit.aspx.cs" Inherits="Pages_Admin_ReportsEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>עריכת דוחות</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link href="~/css/Main.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <link rel="stylesheet" href="~/css/jquery-ui.css">
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
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

        }
        var IsAdd = true;
        var IsAddMD = true;
    </script>
    <style type="text/css">
        .myfootrow {
            font-weight: 700;
        }

        .EditWinReportBox {
            top: 100px;
            left: 1%;
            position: absolute;
            width: 340px;
            height: 440px;
            border: 2px groove black;
            background-color: #4F81BD;
            color: white;
            font-size: 16px;
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
            border-radius: 10px;
            z-index: 9999;
            display: none;
        }

        #dBody {
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div>
            <div class="EditWinMDX" id="EditWinMDX">
            </div>
            <div id="dBody" style="padding-top: 10px; text-align: right; direction: rtl; vertical-align: top;">
                <table cellpadding="0" cellspacing="0" width="90%" style="vertical-align: top;">
                    <tr style="vertical-align: top;">
                        <td>דוח
                        <br />
                            <asp:DropDownList runat="server" ID="ddlReports" Width="304px" onchange="GetReportData();ShowCols();" ClientIDMode="Static"
                                size="37">
                            </asp:DropDownList>
                            <br />
                            <a href="javascript:DeleteReport();">מחק</a>
                        </td>
                        <td style="vertical-align: top;">
                            <table cellpadding="2" cellspacing="2">
                                <tr>
                                    <td colspan="3" style="text-align: center;">
                                        <asp:Label runat="server" ID="lblMSG" CssClass="MsgError" Width="100%"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinReportTypeID")%>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:DropDownList runat="server" ID="ddlReportTypes" Width="374px" onchange="SetWidjet();">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinName") %>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtName" Width="370px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinPromt") %>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtPromt" Width="370px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinDesc") %>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtDesc" Width="370px"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>

                            <table cellpadding="2" cellspacing="2" id="tblSections" style="display: none;">
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">מקטע:
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:DropDownList runat="server" ID="ddlWebSections" Width="374px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                            <table cellpadding="2" cellspacing="2" id="tbl11">
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item rtDataSources">
                                        <%=StrSrc("EditWinReportDataSources")%>
                                    </td>
                                    <td class="ReportWin val rtDataSources">
                                        <asp:DropDownList runat="server" ID="ddlReportDataSources" Width="349px" onchange="SetParams();">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">*
                                    </td>
                                    <td class="ReportWin item" id="dQueryHead">
                                        <%=StrSrc("EditWinQuery") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ReportWin val leftt" colspan="3">
                                        <asp:TextBox runat="server" ID="txtQuery" Width="410px" TextMode="MultiLine" Rows="10"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="ReportWin item rParams">
                                        <%=StrSrc("EditWinParams") %>
                                    </td>
                                    <td class="ReportWin val rParams">
                                        <asp:TextBox runat="server" ID="txtParams" Width="298px" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td class="Templets">*
                                    </td>
                                    <td style="width: 136px" class="ReportWin item Templets">טמפלטים 
                                    </td>
                                    <td class="ReportWin val Templets">
                                        <input id="btnTemplets" type="button" class="Templets btn" value="Chose Templet" onclick="openTempletsWin();" />
                                        <%--  <TextBox runat="server" ID="txtTemplets" Width="298px" TextMode="MultiLine" Rows="2"></asp:TextBox>--%>
                                        <%--         <asp:UpdatePanel runat="server" ID="UpdatePanel4" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" onchange="changeTemplets();" ID="DDLTemplets" Width="304px">
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>--%>
                                    </td>
                                </tr>
                                <%-- <tr>
                                      <td class="Templets">
                                    </td>
                                    <td class="TempletsExample Templets" colspan="2">
                                        <div id="TempletsExample">
                                              <div class="TempletBox PerG">
                    <div>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>רישוי תוכנה 20%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue1" style="width: 20%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>צוות קומנדו 44%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue2" style="width: 44%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>בדיקת התכנות צעצועים 35%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue3" style="width: 35%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>ספירת מלאי 23%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue4" style="width: 23%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>ניתוח דוח מכירות שבועי 67%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue5" style="width: 67%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                                        </div>
                                    </td>
                                </tr>--%>
                            </table>
                            <table cellpadding="2" cellspacing="2" id="tbl2">
                                <tr>
                                    <td class="TableToEditTr">*
                                    </td>
                                    <td class="ReportWin item TableToEditTr">טבלאות לעריכה 
                                    </td>
                                    <td class="ReportWin val TableToEditTr">
                                        <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" onchange="cbAllowCheck();" ID="DDLTableDefinitions" Width="304px">
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <table>
                                            <tr>
                                                <td class="cbAllow">&nbsp;&nbsp;
                                                </td>
                                                <td class="ReportWin item cbAllow">אפשר הוספה
                                                </td>
                                                <td class="ReportWin cbAllow">
                                                    <asp:CheckBox runat="server" ID="cbAllowAdd" Checked="false" />
                                                </td>
                                                <td class="ReportWin item cbAllow">אפשר עריכה
                                                </td>
                                                <td class="ReportWin cbAllow">
                                                    <asp:CheckBox runat="server" ID="cbAllowEdit" Checked="false" />
                                                </td>
                                                <td class="ReportWin item cbAllow">אפשר מחיקה
                                                </td>
                                                <td class="ReportWin cbAllow">
                                                    <asp:CheckBox runat="server" ID="cbAllowDelete" Checked="false" />
                                                </td>
                                            </tr>


                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">הצג שורות כזברה
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbIsZebra" />
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinFragmentHasCloseButton")%>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbFragmentHasCloseButton" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">שורה אחרונה ככותרת תחתונה
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbIsLastRowFooter" ClientIDMode="Static" />
                                    </td>
                                </tr>
                                <%-- <tr>
                                <td>
                                    *
                                </td>
                                <td class="ReportWin item">
                                    סיכומים ע"פ קבוצות
                                </td>
                                <td class="ReportWin val">
                                    <asp:CheckBox runat="server" ID="cbHasSubTotals" Checked="true"/>
                                </td>
                            </tr>--%>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">לקבץ ע"פ שדה:
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtGroupBy" Width="120"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">הצג סיכום לקבוצה
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbHasSubTotalsOnGroup" Checked="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">הצג סה"כ שורות בכותרת
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbIsToShowRowsNumberOnTitle" />
                                    </td>
                                </tr>
                            </table>
                            <table cellpadding="2" cellspacing="2" id="tbl3">
                                <tr>
                                    <td></td>
                                    <td class="ReportWin item">שורות לעמוד
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtRowsPerPage" Width="60"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinHeaderZoomObjTypeID")%>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:UpdatePanel runat="server" ID="upTabMSG" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" ID="ddlZoomObjTypes" Width="304px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlZoomObjTypes_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinHeaderZoomObjID")%>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:UpdatePanel runat="server" ID="upddlHeaderZoomObjs" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" ID="ddlHeaderZoomObjs" Width="304px">
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>*
                                    </td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinRowReportZoomObjTypeID")%>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" ID="ddlRowReportZoomObjTypes" Width="304px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlRowReportZoomObjTypes_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                 <asp:TextBox runat="server" ID="txtddlHeaderZoomObjs" Width="300px" Visible="false"></asp:TextBox>
                                                <span style="display: none;">
                                                    <asp:Button runat="server" ID="btnddlRowReportZoomObjTypes_SelectedIndexChanged"
                                                        OnClick="ddlRowReportZoomObjTypes_SelectedIndexChanged" />
                                                </span>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="ReportWin item">
                                        <%=StrSrc("EditWinRowReportZoomObjID")%>
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:UpdatePanel runat="server" ID="upddlRowReportZoomObjs" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" ID="ddlRowReportZoomObjs" Width="304px">
                                                </asp:DropDownList>
                                                <asp:TextBox runat="server" ID="txtddlRowReportZoomObjsQuestionnaire" Width="300px" Visible="false"></asp:TextBox>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="ReportWin item">הצג כפתור פעולה בכותרת
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbShowActionBtnOnTitle" onchange="cbShowActionBtnOnTitle_change();" />
                                    </td>
                                </tr>
                                <tr id="trActionBTN1">
                                    <td></td>
                                    <td class="ReportWin item">טקסט לכפתור
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtActionBtnOnTitleText" Width="120"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trActionBTN2">
                                    <td></td>
                                    <td class="ReportWin item">סוג פעולת הכפתור
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" ID="ddlActionBtnOnTitleZoomType" Width="304px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlActionBtnOnTitleZoomType_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <span style="display: none;">
                                                    <asp:Button runat="server" ID="btnddlActionBtnOnTitleZoomType"
                                                        OnClick="ddlActionBtnOnTitleZoomType_SelectedIndexChanged" />
                                                </span>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr id="trActionBTN3">
                                    <td></td>
                                    <td class="ReportWin item">פעולת הכפתור
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:UpdatePanel runat="server" ID="upddlActionBtnOnTitleZoomObj" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList runat="server" ID="ddlActionBtnOnTitleZoomObj" Width="304px">
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr id="trSectionsPerRow">
                                    <td></td>
                                    <td class="ReportWin item">רכיבים בשורה
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtSectionsPerRow" Width="120" Text="1"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trSectionsRowHeight">
                                    <td></td>
                                    <td class="ReportWin item">גובה רכיב
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:TextBox runat="server" ID="txtSectionsRowHeight" Width="120"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trSectionsShowFrame">
                                    <td></td>
                                    <td class="ReportWin item">הצג מסגרת
                                    </td>
                                    <td class="ReportWin val">
                                        <asp:CheckBox runat="server" ID="cbSectionsShowFrame" onchange="cbShowActionBtnOnTitle_change();" />
                                    </td>
                                </tr>
                                <tr id="trSectionsImageRowHeight">
                                    <td></td>
                                    <td class="ReportWin item">גובה תמונה
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">%
                                        <asp:TextBox runat="server" ID="txtSectionsImageRowHeight" Width="105"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trWebWidjetIsInternal">
                                    <td></td>
                                    <td class="ReportWin item">פנימי
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:CheckBox runat="server" ID="cbIsWebInternal" />
                                    </td>
                                </tr>
                                <tr id="trExtra1">
                                    <td></td>
                                    <td class="ReportWin item">אקסטרה 1
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:TextBox runat="server" ID="txtExtra1" Width="105"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trExtra2">
                                    <td></td>
                                    <td class="ReportWin item">אקסטרה 2
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:TextBox runat="server" ID="txtExtra2" Width="105"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trExtra3">
                                    <td></td>
                                    <td class="ReportWin item">אקסטרה 3
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:TextBox runat="server" ID="txtExtra3" Width="105"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trExtra14">
                                    <td></td>
                                    <td class="ReportWin item">אקסטרה 4
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:TextBox runat="server" ID="txtExtra4" Width="105"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trExtra15">
                                    <td></td>
                                    <td class="ReportWin item">אקסטרה 5
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:TextBox runat="server" ID="txtExtra5" Width="105"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr id="rIsScroll" style="visibility: hidden;">
                                    <td></td>
                                    <td class="ReportWin item">סקרול
                                    </td>
                                    <td class="ReportWin val" style="color: Black;">
                                        <asp:CheckBox runat="server" ID="cbIsScroll" />
                                    </td>
                                </tr>
                            </table>
                            <table cellpadding="2" cellspacing="2">
                                <tr>
                                    <td colspan="3" style="text-align: center; padding-top: 10px;">
                                        <input type="button" id="btnSaveReport" value="<%= StrSrc("EditWinRowReportbtn")%>"
                                            class="EditForm btn" onclick="SaveReport();" />
                                        &nbsp;
                                        <input type="button" id="btnShowREport" value="הצג דוח" class="EditForm btn" onclick="ShowReport();" />
                                        <input type="button" id="btnDuplicateReport" value="שכפל דוח" class="EditForm btn" onclick="ShowDuplicateReport();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td style="vertical-align: top;">
                            <div style="max-height: 700px; overflow-y: auto;">
                                <table id="jQGrid">
                                </table>
                                <div id="jQGridPager">
                                </div>
                            </div>
                            <div>
                                <input type="button" id="Button1" value="צור עמודות מהשאילתא" class="EditWin btn"
                                    onclick="AddColdsByQuery();" style="width: 150px" />
                            </div>
                        </td>
                    </tr>
                </table>
                <div style="text-align: left; width: 100%;" id="dClosebtn">
                    <input type="button" id="btnCloseWinRef" value="סגור" class="EditWin btn" onclick="CloseWinAndRefresh();" />
                </div>
            </div>
            <center>
            </center>
            <center>
                <div id="divEditWinReportBox" class="EditWinReportBox">
                    <div class="EditWinMDX">
                        <img alt="סגור" src="../../img/X.png" class="imngX" onclick="UpdatedSuccessfulyMD();" />
                    </div>
                    <div class="EditWinMDHead">
                        <%=StrSrc("EditWinHead") %>
                    </div>
                    <div class="EditWinMDMsg">
                    </div>
                    <div class="EditWinMDTbl">
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td class="EditWinMD item">עמודה
                                </td>
                                <td class="EditWinMD val">
                                    <asp:TextBox runat="server" ID="txtColName" Width="130px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">תצוגה
                                </td>
                                <td class="EditWinMD val">
                                    <asp:TextBox runat="server" ID="txtColCaption" Width="130px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">סדר
                                </td>
                                <td class="EditWinMD val">
                                    <asp:TextBox runat="server" ID="txtColOrder" Width="30px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">רוחב %
                                </td>
                                <td class="EditWinMD val">
                                    <asp:TextBox runat="server" ID="txtColWidthWeight" Width="130px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">סוג
                                </td>
                                <td class="EditWinMD val">
                                    <asp:DropDownList runat="server" ID="ddlColType" Width="134px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">פורמט
                                </td>
                                <td class="EditWinMD val">
                                    <asp:DropDownList runat="server" ID="ddlFormatString" Width="134px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">ישור
                                </td>
                                <td class="EditWinMD val">
                                    <asp:DropDownList runat="server" ID="ddlAlignment" Width="134px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">אורך מקס'
                                </td>
                                <td class="EditWinMD val">
                                    <asp:TextBox runat="server" ID="txtColMaxLength" Width="130px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">סגנון
                                </td>
                                <td class="EditWinMD val">
                                    <asp:DropDownList runat="server" ID="ddlStyleName" Width="134px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">פילטר
                                </td>
                                <td class="EditWinMD val">
                                    <asp:DropDownList runat="server" ID="DDLFilter" Width="134px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="EditWinMD item">לסכם עמודה
                                </td>
                                <td class="EditWinMD val">
                                    <asp:CheckBox runat="server" ID="cbColIsSummary" />
                                </td>
                            </tr>
                        </table>
                        <div class="dBtns">
                            <center>
                                <table cellpadding="2" cellspacing="2">
                                    <tr>
                                        <td>
                                            <input type="button" id="btnCloseWin" value="<%=StrSrc("EditWinMDBtn")%>" class="EditWinMD btn"
                                                onclick="SaveDataMD();" />
                                        </td>
                                    </tr>
                                </table>
                            </center>
                        </div>
                    </div>
                </div>
            </center>
        </div>
        <center>
            <div class="winTemplets">
                <div class="newx">
                    <span onclick="closeWinwinTemplets();">X</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 1</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 2</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 3</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 4</span>
                </div>

                <div class="TempletBox PerG" onclick="choseTemplet('טאמפלט 1');">

                    <div>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>רישוי תוכנה 20%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue1" style="width: 20%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>צוות קומנדו 44%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue2" style="width: 44%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>בדיקת התכנות צעצועים 35%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue3" style="width: 35%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>ספירת מלאי 23%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue4" style="width: 23%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>ניתוח דוח מכירות שבועי 67%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue">
                                        <div class="dValue5" style="width: 67%;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="TempletBox PerG" onclick="choseTemplet('טאמפלט 2');">
                    <div>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>רישוי תוכנה 
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue2">
                                        <div class="dValue12" style="width: 20%;">20%</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>צוות קומנדו 
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue2">
                                        <div class="dValue22" style="width: 44%;">44%</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>בדיקת התכנות צעצועים 
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue2">
                                        <div class="dValue32" style="width: 35%;">35%</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" width="100%" class="tblValues">
                            <tr>
                                <td>ספירת מלאי
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="rowAllvalue2">
                                        <div class="dValue33" style="width: 25%;">25%</div>
                                    </div>
                                </td>
                            </tr>
                        </table>

                    </div>
                </div>
                <div class="TempletBox" onclick="choseTemplet('טאמפלט 3');">
                    <div class="ColordBox">
                        <div class="ColordMainValue">
                            <div class="Colorval1">180</div>
                            <div class="Colorval2">
                                <img alt="" src="../../Img/templets/1.png" />
                            </div>

                        </div>
                        <div class="ColordSecondValue">משתמשים חדשים</div>
                    </div>
                </div>
                <div class="TempletBox" onclick="choseTemplet('טאמפלט 4');">
                    <div class="ColordBox cGreen">
                        <div class="ColordMainValue">
                            <div class="Colorval1">180</div>
                            <div class="Colorval2">
                                <img alt="" src="../../Img/templets/1.png" />
                            </div>

                        </div>
                        <div class="ColordSecondValue">משתמשים חדשים</div>
                    </div>
                </div>

                <div class="TempletHead">
                    <span>טאמפלט 5</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 6</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 7</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 8</span>
                </div>

                <div class="TempletBox" onclick="choseTemplet('טאמפלט 5');">
                    <div class="ColordBox cBlue">
                        <div class="ColordMainValue">
                            <div class="Colorval1">180</div>
                            <div class="Colorval2">
                                <img alt="" src="../../Img/templets/1.png" />
                            </div>

                        </div>
                        <div class="ColordSecondValue">משתמשים חדשים</div>
                    </div>
                </div>
                <div class="TempletBox" onclick="choseTemplet('טאמפלט 6');">
                    <div class="ColordBox cGray">
                        <div class="ColordMainValue">
                            <div class="Colorval1 cGray">180</div>
                            <div class="Colorval2">
                                <img alt="" src="../../Img/templets/1.png" />
                            </div>

                        </div>
                        <div class="ColordSecondValue cGray">משתמשים חדשים</div>
                    </div>
                </div>
                <div class="TempletBox cGreenVis" onclick="choseTemplet('טאמפלט 7');">
                    <div class="Visd">
                        <div class="VisHeader">
                            מבקרים
                        </div>
                        <table cellpadding="0" cellspacing="0" class="tblVis">
                            <tr>
                                <td class="tnlVisHeader">חודשי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">שבועי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">היום
                                </td>
                            </tr>
                            <tr>
                                <td class="tnlVisItem">754,839
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">3,765
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">734
                                </td>
                            </tr>
                        </table>
                        <div class="rowAllvalue3">
                            <div class="dValueVis" style="width: 55%;"></div>
                        </div>
                        <div class="VisFotter">
                            <table cellpadding="1" cellspacing="1">
                                <tr>
                                    <td>▲ 55%+ 
                                        נראה טוב!, גבוה מחודש שעבר
                                    </td>
                                    <%--▼--%>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="TempletBox cRedVis" onclick="choseTemplet('טאמפלט 8');">
                    <div class="Visd">
                        <div class="VisHeader">
                            מבקרים
                        </div>
                        <table cellpadding="0" cellspacing="0" class="tblVis">
                            <tr>
                                <td class="tnlVisHeader">חודשי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">שבועי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">היום
                                </td>
                            </tr>
                            <tr>
                                <td class="tnlVisItem">754,839
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">3,765
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">734
                                </td>
                            </tr>
                        </table>
                        <div class="rowAllvalue3">
                            <div class="dValueVis" style="width: 55%;"></div>
                        </div>
                        <div class="VisFotter">
                            <table cellpadding="1" cellspacing="1">
                                <tr>
                                    <td>▲ 55%+ 
                                        נראה טוב!, גבוה מחודש שעבר
                                    </td>
                                    <%--▼--%>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="TempletHead">
                    <span>טאמפלט 9</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 10</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 11</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 12</span>
                </div>

                <div class="TempletBox cBlue" onclick="choseTemplet('טאמפלט 9');">
                    <div class="Visd">
                        <div class="VisHeader">
                            מבקרים
                        </div>
                        <table cellpadding="0" cellspacing="0" class="tblVis">
                            <tr>
                                <td class="tnlVisHeader">חודשי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">שבועי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">היום
                                </td>
                            </tr>
                            <tr>
                                <td class="tnlVisItem">754,839
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">3,765
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">734
                                </td>
                            </tr>
                        </table>
                        <div class="rowAllvalue3">
                            <div class="dValueVis" style="width: 55%;"></div>
                        </div>
                        <div class="VisFotter">
                            <table cellpadding="1" cellspacing="1">
                                <tr>
                                    <td>▲ 55%+ 
                                        נראה טוב!, גבוה מחודש שעבר
                                    </td>
                                    <%--▼--%>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="TempletBox cGreen" onclick="choseTemplet('טאמפלט 10');">
                    <div class="Visd">
                        <div class="VisHeader">
                            מבקרים
                        </div>
                        <table cellpadding="0" cellspacing="0" class="tblVis">
                            <tr>
                                <td class="tnlVisHeader">חודשי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">שבועי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">היום
                                </td>
                            </tr>
                            <tr>
                                <td class="tnlVisItem">754,839
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">3,765
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">734
                                </td>
                            </tr>
                        </table>
                        <div class="rowAllvalue3">
                            <div class="dValueVis" style="width: 55%;"></div>
                        </div>
                        <div class="VisFotter">
                            <table cellpadding="1" cellspacing="1">
                                <tr>
                                    <td>▲ 55%+ 
                                        נראה טוב!, גבוה מחודש שעבר
                                    </td>
                                    <%--▼--%>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="TempletBox PerG cGray" onclick="choseTemplet('טאמפלט 11');">
                    <div class="Visd">
                        <div class="VisHeader">
                            מבקרים
                        </div>
                        <table cellpadding="0" cellspacing="0" class="tblVis">
                            <tr>
                                <td class="tnlVisHeader">חודשי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">שבועי
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisHeader">היום
                                </td>
                            </tr>
                            <tr>
                                <td class="tnlVisItem">754,839
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">3,765
                                </td>
                                <td class="tblVizBorder">&nbsp;</td>
                                <td class="tnlVisItem">734
                                </td>
                            </tr>
                        </table>
                        <div class="rowAllvalue3">
                            <div class="dValueVis" style="width: 55%;"></div>
                        </div>
                        <div class="VisFotter">
                            <table cellpadding="1" cellspacing="1">
                                <tr>
                                    <td>▲ 55%+ 
                                        נראה טוב!, גבוה מחודש שעבר
                                    </td>
                                    <%--▼--%>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="TempletBox cGray" onclick="choseTemplet('1טאמפלט 2');">
                    <div class="FeedMSGHeader">
                        חדשות אחרונות
                    </div>
                    <div>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/alarm32.png" />
                                </td>
                                <td class="FeedHeader">קובץ חדש
                                </td>
                            </tr>
                            <tr>
                                <td>התקבל קובץ שידורי סוכן חדש
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/calculator32.png" />
                                </td>
                                <td class="FeedHeader">תחשיב סוף שנה
                                </td>
                            </tr>
                            <tr>
                                <td>ניתן לבצע ספירת מלאי ותחשיב סוף שנה
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="TempletHead">
                    <span>טאמפלט 13</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 14</span>
                </div>
                <div class="TempletHead">
                    <span>טאמפלט 15</span>
                </div>
                <div class="TempletHead">
                    <span></span>
                </div>

                <div class="TempletBox cRedVis" onclick="choseTemplet('טאמפלט 13');">
                    <div class="FeedMSGHeader">
                        חדשות אחרונות
                    </div>
                    <div>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/alarm32.png" />
                                </td>
                                <td class="FeedHeader">קובץ חדש
                                </td>
                            </tr>
                            <tr>
                                <td>התקבל קובץ שידורי סוכן חדש
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/calculator32.png" />
                                </td>
                                <td class="FeedHeader">תחשיב סוף שנה
                                </td>
                            </tr>
                            <tr>
                                <td>ניתן לבצע ספירת מלאי ותחשיב סוף שנה
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="TempletBox cBlue" onclick="choseTemplet('טאמפלט 14');">
                    <div class="FeedMSGHeader">
                        חדשות אחרונות
                    </div>
                    <div>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/alarm32.png" />
                                </td>
                                <td class="FeedHeader">קובץ חדש
                                </td>
                            </tr>
                            <tr>
                                <td>התקבל קובץ שידורי סוכן חדש
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/calculator32.png" />
                                </td>
                                <td class="FeedHeader">תחשיב סוף שנה
                                </td>
                            </tr>
                            <tr>
                                <td>ניתן לבצע ספירת מלאי ותחשיב סוף שנה
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="TempletBox cGreen" onclick="choseTemplet('טאמפלט 15');">
                    <div class="FeedMSGHeader">
                        חדשות אחרונות
                    </div>
                    <div>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/alarm32.png" />
                                </td>
                                <td class="FeedHeader">קובץ חדש
                                </td>
                            </tr>
                            <tr>
                                <td>התקבל קובץ שידורי סוכן חדש
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="1" cellspacing="1" class="tblFeed">
                            <tr>
                                <td rowspan="2">
                                    <img alt="" class="FeedImg" src="../../Img/templets/calculator32.png" />
                                </td>
                                <td class="FeedHeader">תחשיב סוף שנה
                                </td>
                            </tr>
                            <tr>
                                <td>ניתן לבצע ספירת מלאי ותחשיב סוף שנה
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </center>
        <span style="display: none;" id="sTemp"></span>
        <div style="" class="DuplicateRep">
            <div class="newx">
                <span onclick="closeWinDuplicateRep();">X</span>
            </div>
            <table cellpadding="2" cellspacing="2">
                <tr>
                    <td>מסד נתונים:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlDBs" Width="173px"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>שם דוח חדש:</td>
                    <td>
                        <input type="text" id="txtReportNameNew" class="txtReportNameNew" />
                    </td>
                </tr>
            </table>
            <div align="center" style="padding-top: 60px;">
                <input type="button" id="btnDup" value="שכפל דוח" class="EditForm btn" onclick="DuplicateReport();" />
            </div>
        </div>
    </form>
    <script language="javascript" type="text/javascript">


        function openTempletsWin() {
            $(".winTemplets").css("display", "block");
        }
        function closeWinwinTemplets() {
            $(".winTemplets").css("display", "none");
        }
        function closeWinDuplicateRep() {
            $(".DuplicateRep").hide('fast');
            $("#dBody").unblock();
        }
        function choseTemplet(chosen) {
            $('#btnTemplets')[0].value = chosen;
            closeWinwinTemplets();
        }









        function SetWidjet() {

            if ($('#<%=ddlReportTypes.ClientID %>').val() == "3")//widjet
            {
                $('#dQueryHead').text("URL");
                $('.rtDataSources').css("visibility", "hidden");
                $('.rParams').css("visibility", "hidden");
            }
            else {
                $('#dQueryHead').text("<%=StrSrc("EditWinQuery") %>");
                $('.rtDataSources').css("visibility", "visible");
                $('.rParams').css("visibility", "visible");
            }

            $('#trSectionsPerRow').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsPerRow').show();

            $('#trSectionsRowHeight').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsRowHeight').show();

            $('#trSectionsShowFrame').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsShowFrame').show();

            $('#trSectionsImageRowHeight').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsImageRowHeight').show();

            if ($('#<%=ddlReportTypes.ClientID %>').val() != "1")
                $('#<%=DDLTableDefinitions.ClientID %>')[0].selectedIndex = '0';

            if ($('#<%=ddlReportTypes.ClientID %>').val() == "16") {
                //$('#tbl11').hide();
                $('#tbl2').hide();
                $('#tbl3').hide();
                $('#tblSections').show();
            }
            else {
                // $('#tbl11').show();
                $('#tbl2').show();
                $('#tbl3').show();
                $('#tblSections').hide();
            }
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")//widjet
            {
                $('#rIsScroll').css("visibility", "visible");
                $('#tbl2').hide();
            }
            else {
                $('#tbl2').show();
                $('#rIsScroll').css("visibility", "hidden");
            }
            SetParams();
        }
        function cbAllowCheck() {
            if ($('#<%=DDLTableDefinitions.ClientID %>').val() != "") {
                $(".cbAllow").css("visibility", "visible");
                $('.cbAllow').prop('checked', true);
            } else {
                $(".cbAllow").css("visibility", "hidden");
                $('.cbAllow').prop('checked', false);
            }
        }
        function SetParams() {
            var ReportTypes = $('#<%=ddlReportTypes.ClientID %>').val();
            if (ReportTypes == "4" || ReportTypes == "11" || ReportTypes == "13" || ReportTypes == "17") {
                $(".Templets").css("display", "inline-block");
            }
            else {
                $(".Templets").css("display", "none");
            }
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "1") {
                $(".TableToEditTr").css("display", "");
                if ($('#<%=DDLTableDefinitions.ClientID %>').val() != "") {
                    $(".cbAllow").css("visibility", "visible");
                    $('.cbAllow').prop('checked', true);
                } else {
                    $(".cbAllow").css("visibility", "hidden");
                    $('.cbAllow').prop('checked', false);

                }

            }
            else {
                $(".TableToEditTr").css("display", "none");
                $(".cbAllow").css("visibility", "hidden");
            }
            if ($('#<%=ddlReportDataSources.ClientID %>').val() == "3")//remote SP
            {
                $('.rParams').css("visibility", "visible");
            }
            else {
                $('.rParams').css("visibility", "hidden");
            }
        }

        function CheckVals() {
            if ($('#<%=txtColName.ClientID %>').val().trim() == "") {
                $('.EditWinMDMsg')[0].innerText = "אנא הזן שם לעמודה";
                return false;
            }

            if ($('#<%=txtColCaption.ClientID %>').val().trim() == "") {
                $('.EditWinMDMsg')[0].innerText = "אנא הזן שם לתצוגה";
                return false;
            }

            if ($('#<%=txtColOrder.ClientID %>').val().trim() == "") {
                $('.EditWinMDMsg')[0].innerText = "אנא הזן סדר";
                return false;
            }

            if ($('#<%=txtColWidthWeight.ClientID %>').val().trim() == "") {
                $('.EditWinMDMsg')[0].innerText = "אנא הזן רוחב";
                return false;
            }

            if ($('#<%=ddlColType.ClientID %>').val() == "-1") {
                $('.EditWinMDMsg')[0].innerText = "אנא בחר סוג עמודה";
                return false;
            }

            if ($('#<%=ddlFormatString.ClientID %>').val() == "-1") {
                $('.EditWinMDMsg')[0].innerText = "אנא בחר פורמט";
                return false;
            }

            if ($('#<%=ddlAlignment.ClientID %>').val() == "-1") {
                $('.EditWinMDMsg')[0].innerText = "אנא בחר ישור";
                return false;
            }

            if ($('#<%=ddlStyleName.ClientID %>').val() == "-1") {
                $('.EditWinMDMsg')[0].innerText = "אנא בחר סגנון לעמודה";
                return false;
            }

            if ($('#<%=ddlStyleName.ClientID %>').val() == "-1") {
                $('.EditWinMDMsg')[0].innerText = "אנא בחר סגנון לעמודה";
                return false;
            }

            return true;
        }
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }
        function DisableWin() {
            $('#dBody').block({ message: '<%=StrSrc("EditWinEditMsg") %>' });
        }
        var ColOrder = 10;
        function setDataMD(id) {

            if (id != "") {
                var row = $('#jQGrid').jqGrid('getRowData', id);
                $('#<%=txtColName.ClientID %>').val(row.ColName);
                $('#<%=txtColCaption.ClientID %>').val(row.ColCaption);
                $('#<%=txtColOrder.ClientID %>').val(row.ColOrder);
                $('#<%=txtColWidthWeight.ClientID %>').val(row.ColWidthWeight);
                $('#<%=ddlColType.ClientID %>').val(row.ColTypeID);
                $('#<%=ddlFormatString.ClientID %>').val(row.FormatID);
                $('#<%=ddlAlignment.ClientID %>').val(row.AlignmentID);
                $('#<%=txtColMaxLength.ClientID %>').val(row.ColMaxLength);
                $('#<%=ddlStyleName.ClientID %>').val(row.StyleID);
                $('#<%=cbColIsSummary.ClientID %>')[0].checked = (row.ColIsSummary == "1" ? true : false);
                var fil;
                switch (row.filterName) {
                    case "ללא":
                        fil = "1";
                        break;
                    case "TextBox":
                        fil = "2";
                        break;
                    case "Spinner":
                        fil = "3";
                        break;
                }
                $('#<%=DDLFilter.ClientID %>').val(fil);
                //gridid = row.gridid;
            }
            else {

                $('#<%=txtColName.ClientID %>').val("");
                $('#<%=txtColCaption.ClientID %>').val("");
                $('#<%=txtColOrder.ClientID %>').val(ColOrder.toString());
                $('#<%=txtColWidthWeight.ClientID %>').val("");
                $('#<%=ddlColType.ClientID %>').val("3");
                $('#<%=ddlFormatString.ClientID %>').val("0");
                $('#<%=ddlAlignment.ClientID %>').val("1");
                $('#<%=txtColMaxLength.ClientID %>').val("");
                $('#<%=ddlStyleName.ClientID %>').val("1");
                $('#<%=cbColIsSummary.ClientID %>')[0].checked = false;
                $('#<%=DDLFilter.ClientID %>').val("1");

                ridmd = "0";
                ColOrder = ColOrder + 10;

            }
        }
        function setData(id) {
            if (id != "") {
                var row = $('#jQGrid').jqGrid('getRowData', id);
                $('#<%= txtName.ClientID%>').val(row.gridname);

                $('#<%= txtPromt.ClientID%>').val(row.gridcaption);
                $('#<%= txtQuery.ClientID%>').val(row.gridquery);
                $('#<%= txtParams.ClientID%>').val(row.gridparameters);

                //$('#<%= ddlReportTypes.ClientID%>').val(row.ddlReportTypes);

                $('.EditWinHead')[0].innerText = "<%=StrSrc("EditWinHead") %>";

                $('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked = false;
                $('#<%=txtActionBtnOnTitleText.ClientID %>').val("");
                $('#<%=ddlActionBtnOnTitleZoomType.ClientID %>').val("");
                $('#<%=ddlActionBtnOnTitleZoomObj.ClientID %>').val("");
                $('#<%= txtExtra1.ClientID%>').val(row.Extra1);
                $('#<%= txtExtra2.ClientID%>').val(row.Extra2);
                $('#<%= txtExtra3.ClientID%>').val(row.Extra3);
                $('#<%= txtExtra4.ClientID%>').val(row.Extra4);
                $('#<%= txtExtra5.ClientID%>').val(row.Extra5);
                cbShowActionBtnOnTitle_change();
            }
            else {
                $('#<%= txtName.ClientID%>').val("");

                $('#<%= txtPromt.ClientID%>').val("");
                $('#<%= txtQuery.ClientID%>').val("");
                $('#<%= txtParams.ClientID%>').val("");

                $('#<%= ddlReportDataSources.ClientID%>').val("");
                $('#<%= ddlReportTypes.ClientID%>').val("");

                $('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked = false;
                $('#<%=txtActionBtnOnTitleText.ClientID %>').val("");
                $('#<%=ddlActionBtnOnTitleZoomType.ClientID %>').val("");
                $('#<%=ddlActionBtnOnTitleZoomObj.ClientID %>').val("");
                cbShowActionBtnOnTitle_change();

                $('.EditWinHead')[0].innerText = "<%=StrSrc("EditWinAddRow") %>";

                $('#<%= txtExtra1.ClientID%>').val(row.Extra1);
                $('#<%= txtExtra2.ClientID%>').val(row.Extra2);
                $('#<%= txtExtra3.ClientID%>').val(row.Extra3);
                $('#<%= txtExtra4.ClientID%>').val(row.Extra4);
                $('#<%= txtExtra5.ClientID%>').val(row.Extra5);
            }
        }
        var gridid = "0";

        function UpdatedSuccessfulyMD() {
            $("#dBody").unblock();
            RefreshMD();
            closeWin("divEditWinReportBox");
        }

        function ShowMSGT() {
            $('#FormError')[0].innerHTML = "<td class='MsgT' colspan='2'><%=StrSrc("EditWinEditMsgSuccess") %></td>";
        }


        $('#nDohot').attr("class", "menuLink Selected");
        $.jgrid.del.msg = "מחק שורה?";

        function initwData(data, objMain) {
            $(".ui-pg-div").click(doNone);
            $("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMD;
            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMD;
            $("#del_jQGrid")[0].children[0].onclick = ShowDeleteFormMD;
            $("#search_jQGrid")[0].children[0].onclick = ShowSearchFormMD;
            $("#refresh_jQGrid")[0].children[0].onclick = RefreshMD;
        }
        var GridID = "";

        var rid = "";
        var ridmd = "";



        function SetGrid(id) {
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetReportCols&ReportID=" + id,
                datatype: "json",
                direction: "rtl",
                colNames: ['#', 'עמודה', 'תצוגה', 'סדר', 'רוחב %', 'סוג עמודה', 'פורמט', 'ישור', 'אורך מקס', 'סגנון', 'פילטר', 'סיכום', 'ColTypeID', 'FormatID', 'AlignmentID', 'StyleID'],
                colModel: [{ name: 'ReportColID', index: 'ReportColID', width: 47.575, sorttype: 'int', align: 'right', editable: true },
                            { name: 'ColName', index: 'ColName', width: 80, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColCaption', index: 'ColCaption', width: 95.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColOrder', index: 'ColOrder', width: 25.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColWidthWeight', index: 'ColWidthWeight', width: 65.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'TypeName', index: 'TypeName', width: 85.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'FormatString', index: 'FormatString', width: 95.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'Alignment', index: 'Alignment', width: 85.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColMaxLength', index: 'ColMaxLength', width: 75.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'StyleName', index: 'StyleName', width: 95.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'filterName', index: 'filterName', width: 59.15, sorttype: 'text', align: 'right', editable: true },
                            { name: 'ColIsSummary', index: 'ColIsSummary', width: 59.15, sorttype: 'text', align: 'right', editable: true },

                            { name: 'ColTypeID', index: 'ColTypeID', width: 0, sorttype: 'int', align: 'right', editable: true, hidden: true },
                            { name: 'FormatID', index: 'FormatID', width: 0, sorttype: 'int', align: 'right', editable: true, hidden: true },
                            { name: 'AlignmentID', index: 'AlignmentID', width: 0, sorttype: 'int', align: 'right', editable: true, hidden: true },
                            { name: 'StyleID', index: 'StyleID', width: 0, sorttype: 'int', align: 'right', editable: true, hidden: true }
                ],
                rowNum: 25,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                footerrow: true, userDataOnFooter: true, altRows: true,
                loadComplete: function (data) {
                    initwData(data, $("#jQGrid"));

                    var $this = $(this),
                        sum = $this.jqGrid("getCol", "ColWidthWeight", false, "sum"),
                        $footerRow = $(this.grid.sDiv).find("tr.footrow"),
                        localData = $this.jqGrid("getGridParam", "data"),
                        totalRows = localData.length,
                        totalSum = 0,
                        $newFooterRow,
                        i;

                    $newFooterRow = $(this.grid.sDiv).find("tr.myfootrow");
                    if ($newFooterRow.length === 0) {
                        // add second row of the footer if it's not exist
                        $newFooterRow = $footerRow.clone();
                        $newFooterRow.removeClass("footrow")
                            .addClass("myfootrow");
                        $newFooterRow.children("td").each(function () {
                            this.style.width = ""; // remove width from inline CSS
                        });
                        //$newFooterRow.insertAfter($footerRow);
                    }


                    // calculate the value for the second footer row
                    for (i = 0; i < totalRows; i++) {
                        totalSum += parseInt(localData[i].ColWidthWeight, 10);
                    }
                    //$newFooterRow.find(">td[aria-describedby=" + this.id + "_invdate]")
                    //    .text("Grand Total:");
                    $newFooterRow.find(">td[aria-describedby=" + this.id + "_ColWidthWeight]")
                        .text($.fmatter.util.NumberFormat(totalSum, $.jgrid.formatter.number));

                    $this.jqGrid("footerData", "set", { ColWidthWeight: sum });

                    // var grid = $("#jQGrid"),
                    //ids = grid.getDataIDs();

                    //                        for (var i = 0; i < ids.length; i++) {
                    //                            grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
                    //                        }

                },
                //                loadComplete: function(data) {
                //                        var grid = $("#jQGrid"),
                //                        ids = grid.getDataIDs();

                //                        for (var i = 0; i < ids.length; i++) {
                //                            grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
                //                        }
                //                        initwData(data,$("#jQGrid"));
                //                    },

                onSelectRow: function (id) {

                    ridmd = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                },
                ondblClickRow: function (id) {

                    ridmd = id;

                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    ShowEditFormMD();
                },
                loadError: function (jqXHR, textStatus, errorThrown) {
                    console.error('HTTP status code: ' + jqXHR.status + '\n' +
                        'textStatus: ' + textStatus + '\n' +
                        'errorThrown: ' + errorThrown);
                    console.log('HTTP message body (jqXHR.responseText): ' + '\n' + jqXHR.responseText);
                },

                editurl: '../../Handlers/MainHandler.ashx?MethodName=AddEditGridWidgets'
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

                                   $("#jQGrid").trigger("reloadGrid", [{ current: true }]);
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
                                   //alert(value);
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





        function ShowEditFormMD() {
            $('.EditWinMDMsg')[0].innerText = "";
            if (ridmd != "") {
                IsAddMD = false;
                //DisableWin();
                setDataMD(ridmd);
                $('.EditWinReportBox').css("display", "block");
                var top = 500;
                $("#divEditWinReportBox").css({ top: top })
                        .animate({ "top": "100px" }, "slow");
            }
            else {
                alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                    }
                    return false;
                }
                function ShowAddFormMD() {
                    $('.EditWinMDMsg')[0].innerText = "";
                    IsAddMD = true;
                    //DisableWin();
                    ridmd = "0";
                    setDataMD("");
                    $('.EditWinReportBox').css("display", "block");
                    var top = 500;
                    $("#divEditWinReportBox").css({ top: top })
                                .animate({ "top": "100px" }, "slow");

                    return false;
                }
                function ShowDeleteFormMD() {
                    $('.EditWinBox').css("display", "none");
                    if (ridmd == "" || ridmd == "0") {
                        alert("<%=StrSrc("EditWinMsgPleaseSelectRow") %>");
                       return false;
                   }
                   if (confirm("<%=StrSrc("EditWinDelConfirm") %>")) {
                       var request;
                       var colid = "0";
                       var row = $('#jQGrid').jqGrid('getRowData', ridmd);
                       colid = row.ReportColID;

                       var cbColIsSummary = $('#<%=cbColIsSummary.ClientID %>')[0].checked ? '1' : '0';

                       request = $.ajax({
                           url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetReportCol&ColID=" + colid + "&ReportID=" + "-7" + "&ColName=" + escape($('#<%=txtColName.ClientID %>').val()) + "&ColCaption=" + escape($('#<%=txtColCaption.ClientID %>').val()) + "&ColOrder=" + $('#<%=txtColOrder.ClientID %>').val()
               + "&ColWidthWeight=" + escape($('#<%=txtColWidthWeight.ClientID %>').val()) + "&ColType=" + $('#<%=ddlColType.ClientID %>').val() + "&FormatString=" + $('#<%=ddlFormatString.ClientID %>').val()
                + "&Alignment=" + $('#<%=ddlAlignment.ClientID %>').val() + "&ColMaxLength=" + escape($('#<%=txtColMaxLength.ClientID %>').val()) + "&ddlStyleName=" + $('#<%=ddlStyleName.ClientID %>').val()
                + "&FilterID=" + $('#<%=DDLFilter.ClientID %>').val() + "&ColIsSummary=" + escape(cbColIsSummary) + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                           type: "get",
                           data: ''
                       });
                       request.done(function (response, textStatus, jqXHR) {
                           ridmd = "";
                           RefreshMD();
                       });
                       request.fail(function (jqXHR, textStatus, errorThrown) {
                           if (jqXHR.status == 200) {
                               ridmd = "";
                               RefreshMD();
                           }
                           else {
                               alert("Error");
                           }
                       });

                   }
                   return false;
               }

               function ShowSearchFormMD() {
                   $("#jQGrid").searchGrid({ closeAfterSearch: false });
               }


               $('#<%=txtColOrder.ClientID %>').keypress(function (event) {

                   if (event.which != 8 && isNaN(String.fromCharCode(event.which))) {
                       event.preventDefault(); //stop character from entering input
                   }
               });
               $('#<%=txtColOrder.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });
        $('#<%=txtRowsPerPage.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });
        $('#<%=txtSectionsPerRow.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });
        $('#<%=txtSectionsRowHeight.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });
        $('#<%=txtSectionsImageRowHeight.ClientID %>').bind('input propertychange', function () {
            if (!isNumber($(this).val()))
                $(this).val("");
        });
        IsAddMD = true;
        function SaveDataMD() {
            if (!CheckVals())
                return;

            var colid = "0";
            var row = $('#jQGrid').jqGrid('getRowData', ridmd);
            if (IsAddMD) {
                ridmd = "0";
            }
            else {
                colid = row.ReportColID;
            }

            var cbColIsSummary = $('#<%=cbColIsSummary.ClientID %>')[0].checked ? '1' : '0';
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetReportCol&ColID=" + colid + "&ReportID=" + ReportID + "&ColName=" + escape($('#<%=txtColName.ClientID %>').val()) + "&ColCaption=" + escape($('#<%=txtColCaption.ClientID %>').val()) + "&ColOrder=" + $('#<%=txtColOrder.ClientID %>').val()
                + "&ColWidthWeight=" + escape($('#<%=txtColWidthWeight.ClientID %>').val()) + "&ColType=" + $('#<%=ddlColType.ClientID %>').val() + "&FormatString=" + $('#<%=ddlFormatString.ClientID %>').val()
                + "&Alignment=" + $('#<%=ddlAlignment.ClientID %>').val() + "&ColMaxLength=" + escape($('#<%=txtColMaxLength.ClientID %>').val()) + "&ddlStyleName=" + $('#<%=ddlStyleName.ClientID %>').val()
                + "&FilterID=" + $('#<%=DDLFilter.ClientID %>').val() + "&ColIsSummary=" + escape(cbColIsSummary) + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                if (jqXHR.responseText == "ret: True") {
                    if (!IsAddMD) {
                        UpdatedSuccessfulyMD();
                    }
                    else {
                        $('.EditWinMDMsg')[0].innerText = "<%=StrSrc("EditWinRowAdded") %>";
                        setDataMD("");
                        RefreshMD();
                    }
                }
                else {
                    $('.EditWinMDMsg')[0].innerText = "אראה שגיאה";
                }
                ridmd = "";
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {

                    if (jqXHR.responseText == "ret: True") {
                        if (!IsAddMD) {
                            UpdatedSuccessfulyMD();
                        }
                        else {
                            $('.EditWinMDMsg')[0].innerText = "<%=StrSrc("EditWinRowAdded") %>";
                            setDataMD("");
                            RefreshMD();
                        }
                    }
                    else {
                        $('.EditWinMDMsg')[0].innerText = "אראה שגיאה";
                    }
                    ridmd = "";
                }
                else {
                    $('.EditWinMDMsg')[0].innerText = "<%=StrSrc("EditWinErrorMsg") %>";
                }
            });
        }
        function SaveReport() {
            $('#<%=lblMSG.ClientID %>').text("");

            if ($('#<%=ddlReports.ClientID %>').val() == "-1") {
                $('#<%=lblMSG.ClientID %>').text("אנא בחר דוח");
                return false;
            }
            if ($('#<%=txtName.ClientID %>').val().trim() == "") {
                $('#<%=lblMSG.ClientID %>').text("אנא הזן שם לדוח");
                return false;
            }

            if ($('#<%=txtPromt.ClientID %>').val().trim() == "") {
                $('#<%=lblMSG.ClientID %>').text("אנא הזן כותרת לדוח");
                return false;
            }

            if ($('#<%=txtQuery.ClientID %>').val().trim() == "") {
                $('#<%=lblMSG.ClientID %>').text("אנא הזן שאילתה לדוח");
                return false;
            }

            if ($('#<%=ddlZoomObjTypes.ClientID %>').val() != "0" && $('#<%=ddlHeaderZoomObjs.ClientID %>').val() == "-1") {
                $('#<%=lblMSG.ClientID %>').text("אנא בחר חלון קופץ מהכותרת");
                return false;
            }

            if ($('#<%=ddlRowReportZoomObjTypes.ClientID %>').val() != "0" && $('#<%=ddlRowReportZoomObjs.ClientID %>').val() == "-1") {
                $('#<%=lblMSG.ClientID %>').text("אנא בחר חלון בלחיצה על שורה");
                return false;
            }
            SetFormReport();
            return true;
        }
        function doNone() {
            return false;
        }
        function ShowCols() {
            $("#jQGrid").jqGrid('GridUnload');
            SetGrid($('#<%=ddlReports.ClientID %>').val());
        }

        function setReportData(data) {
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "16") {
                //$('#tbl11').hide();
                $('#tbl2').hide();
                $('#tbl3').hide();
                $('#tblSections').show();
            }
            else {
                //$('#tbl11').show();
                $('#tbl2').show();
                $('#tbl3').show();
                $('#tblSections').hide();
            }
            //try{
            $('#<%=ddlReportTypes.ClientID %>').val("1");
            $('#<%=txtName.ClientID %>').val("");
            $('#<%=txtPromt.ClientID %>').val("");
            $('#<%=txtDesc.ClientID %>').val("");
            $('#<%=ddlReportDataSources.ClientID %>').val("1");

            $('#<%=txtQuery.ClientID %>').val("");

            $('#<%=cbFragmentHasCloseButton.ClientID %>')[0].checked = false;
            $('#<%=cbIsZebra.ClientID %>')[0].checked = false;

            $('#<%=cbIsLastRowFooter.ClientID %>')[0].checked = false;
            $('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked = false;
            $('#<%=txtGroupBy.ClientID %>').val("");


            $('#<%=cbIsToShowRowsNumberOnTitle.ClientID %>')[0].checked = false;
            $('#<%=txtRowsPerPage.ClientID %>').val("");

            $('#<%=txtParams.ClientID %>').val("");
            $('#<%=ddlZoomObjTypes.ClientID %>').val("0");
            $('#<%=ddlRowReportZoomObjTypes.ClientID %>').val("0");
            $('#<%=txtddlRowReportZoomObjsQuestionnaire.ClientID %>').val("0");


            $('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked = false;
            $('#<%=txtActionBtnOnTitleText.ClientID %>').val("");
            $('#<%=ddlActionBtnOnTitleZoomType.ClientID %>').val("");
            $('#<%=ddlActionBtnOnTitleZoomObj.ClientID %>').val("");

            $('#<%=txtSectionsPerRow.ClientID %>').val("1");
            $('#<%=ddlWebSections.ClientID %>').val("-1");

            $('#<%=txtSectionsRowHeight.ClientID %>').val("100");

            $('#<%=cbSectionsShowFrame.ClientID %>')[0].checked = false;
            $('#<%=cbIsWebInternal.ClientID %>')[0].checked = true;
            $('#<%=cbIsScroll.ClientID %>')[0].checked = false;

            $('#<%=txtExtra1.ClientID %>').val("");
            $('#<%=txtExtra2.ClientID %>').val("");
            $('#<%=txtExtra3.ClientID %>').val("");
            $('#<%=txtExtra4.ClientID %>').val("");
            $('#<%=txtExtra5.ClientID %>').val("");

            cbShowActionBtnOnTitle_change();

            try {
                $('#<%=ddlReportTypes.ClientID %>').val(data.ReportTypeID);
                $('#<%=txtName.ClientID %>').val(data.ReportName);
                $('.txtReportNameNew').val(data.ReportName);
                $('#<%=txtPromt.ClientID %>').val(data.ReportCaption);
                $('#<%=txtDesc.ClientID %>').val(data.FragmentDescription);
                $('#<%=ddlReportDataSources.ClientID %>').val(data.ReportDataSourceID);
                $('#<%=DDLTableDefinitions.ClientID %>').val(data.tableToEdit);

                if (data.tableToEdit == "1") {
                    $('#<%=cbIsScroll.ClientID %>')[0].checked = true;
                }

                $('#<%=ddlWebSections.ClientID %>').val(data.frg_FragmentID);

                $('#btnTemplets')[0].value = data.ChosenTemplet;

            } catch (e) {

                $('#btnTemplets')[0].value = "בחר טאמפלט";

            }


            $('#trSectionsPerRow').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsPerRow').show();

            $('#trSectionsRowHeight').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsRowHeight').show();

            $('#trSectionsShowFrame').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsShowFrame').show();

            $('#trSectionsImageRowHeight').hide();
            if ($('#<%=ddlReportTypes.ClientID %>').val() == "11")
                $('#trSectionsImageRowHeight').show();


            try {
                $('#<%=txtQuery.ClientID %>').val(data.ReportQuery.toString().replace(/gty/gi, "'"));//replace all "gte" to "'"

                if (data.FragmentHasCloseButton == "1")
                    $('#<%=cbFragmentHasCloseButton.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbFragmentHasCloseButton.ClientID %>')[0].checked = false;

                if (data.IsLastRowFooter == "1")
                    $('#<%=cbIsLastRowFooter.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbIsLastRowFooter.ClientID %>')[0].checked = false;

                if (data.HasSubTotalsOnGroup == "1")
                    $('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked = false;

                $('#<%=txtGroupBy.ClientID %>').val(data.GroupBy);

                if (data.IsToShowRowsNumberOnTitle == "1")
                    $('#<%=cbIsToShowRowsNumberOnTitle.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbIsToShowRowsNumberOnTitle.ClientID %>')[0].checked = false;

                $('#<%=txtRowsPerPage.ClientID %>').val(data.RowsPerPage);

                if (data.IsZebra == "1")
                    $('#<%=cbIsZebra.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbIsZebra.ClientID %>')[0].checked = false;

                if (data.AllowAdd == "1")
                    $('#<%=cbAllowAdd.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbAllowAdd.ClientID %>')[0].checked = false;

                if (data.AllowEdit == "1")
                    $('#<%=cbAllowEdit.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbAllowEdit.ClientID %>')[0].checked = false;

                if (data.AllowDelete == "1")
                    $('#<%=cbAllowDelete.ClientID %>')[0].checked = true;
                else
                    $('#<%=cbAllowDelete.ClientID %>')[0].checked = false;

                $('#<%=txtParams.ClientID %>').val(data.Report_SP_Params);
                $('#<%=ddlZoomObjTypes.ClientID %>').val(data.HeaderZoomObjTypeID);
                $('#<%=ddlRowReportZoomObjTypes.ClientID %>').val(data.RowReportZoomObjTypeID);
                $('#btnddlRowReportZoomObjTypes_SelectedIndexChanged').click();

                $('#btnddlActionBtnOnTitleZoomType').click();

                $('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked = data.ShowActionBattonOnTitle == "1" ? true : false;
                $('#<%=txtActionBtnOnTitleText.ClientID %>').val(data.ActionBattonOnTitleText);
                $('#<%=ddlActionBtnOnTitleZoomType.ClientID %>').val(data.ActionBattonOnTitleReportZoomObjTypeID);


                cbShowActionBtnOnTitle_change();

                $('#<%=txtSectionsPerRow.ClientID %>').val(data.SectionsPerRow);
                $('#<%=txtSectionsRowHeight.ClientID %>').val(data.SectionsRowHeight);
                $('#btnddlActionBtnOnTitleZoomType').click();

                $('#<%=cbSectionsShowFrame.ClientID %>')[0].checked = false;
                if (data.IsToShowSectionFrame == "1")
                    $('#<%=cbSectionsShowFrame.ClientID %>')[0].checked = true;

                $('#<%=cbIsWebInternal.ClientID %>')[0].checked = true;
                if (data.IsWebInternal == "0")
                    $('#<%=cbIsWebInternal.ClientID %>')[0].checked = false;

                $('#<%=txtSectionsImageRowHeight.ClientID %>').val(data.SectionImageHeightWeight);
                $('#<%=txtExtra1.ClientID %>').val(data.Extra1);
                $('#<%=txtExtra2.ClientID %>').val(data.Extra2);
                $('#<%=txtExtra3.ClientID %>').val(data.Extra3);
                $('#<%=txtExtra4.ClientID %>').val(data.Extra4);
                $('#<%=txtExtra5.ClientID %>').val(data.Extra5);

                setTimeout('SetUfter(\"' + data.HeaderZoomObjID + '\",\"' + data.RowReportZoomObjID + '\")', 1000);
                setTimeout('SetUfter2(\"' + data.ActionBattonOnTitleReportZoomObjID + '\")', 1100);
            } catch (e) {

            }

            SetParams();


        }
        function SetUfter(d1, d2) {
            $('#<%=ddlHeaderZoomObjs.ClientID %>').val(d1);
            $('#<%=ddlRowReportZoomObjs.ClientID %>').val(d2);
            $('#<%=txtddlRowReportZoomObjsQuestionnaire.ClientID %>').val(d2);
        }
        function SetUfter2(d1) {
            $('#<%=ddlActionBtnOnTitleZoomObj.ClientID %>').val(d1);
        }
        function GetReportData() {

            ReportID = $('#<%=ddlReports.ClientID %>').val();
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_GetReportData&ReportID=" + $('#<%=ddlReports.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });

            request.done(function (response, textStatus, jqXHR) {
                setReportData(response[0]);
                SetWidjet();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    setReportData($.parseJSON(jqXHR.responseText));
                    SetWidjet();
                }
                else {
                    //alert("Error");
                }

            });
        }
        function DeleteReport() {
            if (!(confirm("האם אתה בטוח ברצונך למחוק את הדוח הנבחר?"))) {
                return;
            }
            var LayoutTypeID = "<%=LayoutTypeID %>";

            var IzZebra = "0";
            if ($('#<%=cbIsZebra.ClientID %>')[0].checked)
                IzZebra = "1";

            var IsLastRowFooter = "0";
            if ($('#<%=cbIsLastRowFooter.ClientID %>')[0].checked)
                IsLastRowFooter = "1";

            var HasSubTotals = "0";
         <%--   /*   $('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked = false;

            $('#<%=txtGroupBy.ClientID %>').val(data.GroupBy);*/--%>
            var HasSubTotalsOnGroup = "0";
            if ($('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked)
                HasSubTotalsOnGroup = "1";

            var HasSubTotalsOnGroup = "0";
            if ($('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked)
                HasSubTotalsOnGroup = "1";

            HasSubTotals = "1";

            var IsToShowRowsNumberOnTitle = "0";
            if ($('#<%=cbIsToShowRowsNumberOnTitle.ClientID %>')[0].checked)
                IsToShowRowsNumberOnTitle = "1";

            var iscbShowActionBtnOnTitle = "0";
            if ($('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked)
                iscbShowActionBtnOnTitle = "1";

            var IsToShowSectionFrame = "0";
            if ($('#<%=cbSectionsShowFrame.ClientID %>')[0].checked)
                IsToShowSectionFrame = "1";

            var IsWebInternal = "0";
            if ($('#<%=cbIsWebInternal.ClientID %>')[0].checked)
                IsWebInternal = "1";

            var AllowAdd = "0";
            if ($('#<%=cbAllowAdd.ClientID %>')[0].checked)
                AllowAdd = "1";

            var AllowEdit = "0";
            if ($('#<%=cbAllowEdit.ClientID %>')[0].checked)
                AllowEdit = "1";

            var AllowDelete = "0";
            if ($('#<%=cbAllowDelete.ClientID %>')[0].checked)
                AllowDelete = "1";

            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetFormReport&ReportID=" + $('#<%=ddlReports.ClientID %>').val() + "&ReportName=-7"
                    + "&Report_SP_Params=" + escape($('#<%=txtParams.ClientID %>').val())
                + "&ReportCaption=" + escape($('#<%=txtPromt.ClientID %>').val()) + "&ReportDataSourceID=" + $('#<%=ddlReportDataSources.ClientID %>').val() + "&ReportTypeID=" + $('#<%=ddlReportTypes.ClientID %>').val()
                + "&IsActive=1" + "&FragmentName=" + $('#<%=txtName.ClientID %>').val() + "&FragmentDescription=" + escape($('#<%=txtDesc.ClientID %>').val()) + "&FragmentTypeID=1" + "&FragmentHasCloseButton=" + $('#<%=cbFragmentHasCloseButton.ClientID %>').val()
                + "&HeaderZoomObjTypeID=" + $('#<%=ddlZoomObjTypes.ClientID %>').val() + "&HeaderZoomObjID=" + $('#<%=ddlHeaderZoomObjs.ClientID %>').val() + "&RowReportZoomObjTypeID=" + $('#<%=ddlRowReportZoomObjTypes.ClientID %>').val()
                + "&RowReportZoomObjID=" + $('#<%=ddlRowReportZoomObjs.ClientID %>').val() + "&LayoutTypeID=" + LayoutTypeID + "&IzZebra=" + IzZebra + "&IsLastRowFooter=" + IsLastRowFooter + "&HasSubTotals=" + HasSubTotals + "&IsToShowRowsNumberOnTitle=" + IsToShowRowsNumberOnTitle
                + "&RowsPerPage=" + $('#<%=txtRowsPerPage.ClientID %>').val() + "&GroupBy=" + $('#<%=txtGroupBy.ClientID %>').val() + "&HasSubTotalsOnGroup=" + HasSubTotalsOnGroup
                + "&ShowActionBattonOnTitle=" + iscbShowActionBtnOnTitle + "&ActionBattonOnTitleText=" + $('#<%=txtActionBtnOnTitleText.ClientID %>').val()
                + "&ActionBattonOnTitleReportZoomObjTypeID=" + $('#<%=ddlActionBtnOnTitleZoomType.ClientID %>').val()
                + "&ActionBattonOnTitleReportZoomObjID=" + $('#<%=ddlActionBtnOnTitleZoomObj.ClientID %>').val()
                + "&SectionsPerRow=" + $('#<%=txtSectionsPerRow.ClientID %>').val()
                + "&SectionsRowHeight=" + $('#<%=txtSectionsRowHeight.ClientID %>').val()
                + "&IsToShowSectionFrame=" + IsToShowSectionFrame
                + "&SectionImageHeightWeight=" + $('#<%=txtSectionsImageRowHeight.ClientID %>').val()
                + "&IsWebInternal=" + IsWebInternal
                + "&tableToEdit=" + $('#<%=DDLTableDefinitions.ClientID %>').val()
                + "&AllowAdd=" + AllowAdd
                + "&AllowEdit=" + AllowEdit
                + "&AllowDelete=" + AllowDelete
                + "&ChosenTemplet=" + $('#btnTemplets')[0].value
                + "&FragmentID=" + $('#<%=ddlWebSections.ClientID %>').val()
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: 'ReportQuery=' + escape($('#<%=txtQuery.ClientID %>').val().split('+').join('***'))
            });
            request.done(function (response, textStatus, jqXHR) {
                $('#<%=lblMSG.ClientID %>').text("הדוח נמחק בהצלחה");
                $("#<%=ddlReports.ClientID %> option[value='" + $('#<%=ddlReports.ClientID %>').val() + "']").remove();



            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {
                    $('#<%=lblMSG.ClientID %>').text("הדוח נמחק בהצלחה");
                    $("#<%=ddlReports.ClientID %> option[value='" + $('#<%=ddlReports.ClientID %>').val() + "']").remove();

                }
                else {
                    //alert("Error");
                }
            });
        }
        var ReportID = "0";
        function SetFormReport() {
            var LayoutTypeID = "<%=LayoutTypeID %>";
            if ($('#<%=ddlReports.ClientID %>').val() * 1.0 < 0 || $('#<%=ddlReports.ClientID %>').val() == "") {
                alert("אנא בחר דוח");
                return;
            }
            var IzZebra = "0";
            if ($('#<%=cbIsZebra.ClientID %>')[0].checked)
                IzZebra = "1";

            var IsLastRowFooter = "0";
            if ($('#<%=cbIsLastRowFooter.ClientID %>')[0].checked)
                IsLastRowFooter = "1";

            var HasSubTotalsOnGroup = "0";
            if ($('#<%=cbHasSubTotalsOnGroup.ClientID %>')[0].checked)
                HasSubTotalsOnGroup = "1";

            var HasSubTotals = "0";
            HasSubTotals = "1";

            var IsToShowRowsNumberOnTitle = "0";
            if ($('#<%=cbIsToShowRowsNumberOnTitle.ClientID %>')[0].checked)
                IsToShowRowsNumberOnTitle = "1";

            var iscbShowActionBtnOnTitle = "0";
            if ($('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked)
                iscbShowActionBtnOnTitle = "1";

            var IsToShowSectionFrame = "0";
            if ($('#<%=cbSectionsShowFrame.ClientID %>')[0].checked)
                IsToShowSectionFrame = "1";

            var IsWebInternal = "0";
            if ($('#<%=cbIsWebInternal.ClientID %>')[0].checked)
                IsWebInternal = "1";

            var AllowAdd = "0";
            if ($('#<%=cbAllowAdd.ClientID %>')[0].checked)
                    AllowAdd = "1";

                var AllowEdit = "0";
                if ($('#<%=cbAllowEdit.ClientID %>')[0].checked)
                AllowEdit = "1";

            var AllowDelete = "0";
            if ($('#<%=cbAllowDelete.ClientID %>')[0].checked)
                AllowDelete = "1";

            var tableToEdit = $('#<%=DDLTableDefinitions.ClientID %>').val();
            if (LayoutTypeID != 3) {
                if ($('#<%=cbIsScroll.ClientID %>')[0].checked)
                    tableToEdit = "1";
                else
                    tableToEdit = "0";
            }
            var RowReportZoomObjsVal = $('#<%=ddlRowReportZoomObjs.ClientID %>').val();
            if ($('#<%=ddlRowReportZoomObjTypes.ClientID %>').val() == "4")
                RowReportZoomObjsVal = $('#<%=txtddlRowReportZoomObjsQuestionnaire.ClientID %>').val();
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=Layout_SetFormReport&ReportID=" + $('#<%=ddlReports.ClientID %>').val()
                    + "&ReportName=" + escape($('#<%=txtName.ClientID %>').val()) + "&Report_SP_Params=" + escape($('#<%=txtParams.ClientID %>').val())
                + "&ReportCaption=" + escape($('#<%=txtPromt.ClientID %>').val()) + "&ReportDataSourceID=" + $('#<%=ddlReportDataSources.ClientID %>').val()
                + "&ReportTypeID=" + $('#<%=ddlReportTypes.ClientID %>').val()
                + "&IsActive=1" + "&FragmentName=" + $('#<%=txtName.ClientID %>').val()
                + "&FragmentDescription=" + escape($('#<%=txtDesc.ClientID %>').val()) + "&FragmentTypeID=1"
                + "&FragmentHasCloseButton=" + $('#<%=cbFragmentHasCloseButton.ClientID %>').val()
                + "&HeaderZoomObjTypeID=" + $('#<%=ddlZoomObjTypes.ClientID %>').val() + "&HeaderZoomObjID=" + $('#<%=ddlHeaderZoomObjs.ClientID %>').val()
                + "&RowReportZoomObjTypeID=" + $('#<%=ddlRowReportZoomObjTypes.ClientID %>').val()
                + "&RowReportZoomObjID=" + RowReportZoomObjsVal + "&LayoutTypeID=" + LayoutTypeID + "&IzZebra=" + IzZebra + "&IsLastRowFooter=" + IsLastRowFooter + "&HasSubTotals=" + HasSubTotals
                + "&IsToShowRowsNumberOnTitle=" + IsToShowRowsNumberOnTitle + "&RowsPerPage=" + $('#<%=txtRowsPerPage.ClientID %>').val()
                + "&GroupBy=" + $('#<%=txtGroupBy.ClientID %>').val() + "&HasSubTotalsOnGroup=" + HasSubTotalsOnGroup
                + "&ShowActionBattonOnTitle=" + iscbShowActionBtnOnTitle + "&ActionBattonOnTitleText=" + $('#<%=txtActionBtnOnTitleText.ClientID %>').val()
                + "&ActionBattonOnTitleReportZoomObjTypeID=" + $('#<%=ddlActionBtnOnTitleZoomType.ClientID %>').val()
                + "&ActionBattonOnTitleReportZoomObjID=" + $('#<%=ddlActionBtnOnTitleZoomObj.ClientID %>').val()
                + "&SectionsPerRow=" + $('#<%=txtSectionsPerRow.ClientID %>').val()
                + "&SectionsRowHeight=" + $('#<%=txtSectionsRowHeight.ClientID %>').val()
                + "&IsToShowSectionFrame=" + IsToShowSectionFrame
                + "&SectionImageHeightWeight=" + $('#<%=txtSectionsImageRowHeight.ClientID %>').val()
                + "&IsWebInternal=" + IsWebInternal
                + "&tableToEdit=" + tableToEdit
                + "&AllowAdd=" + AllowAdd
                + "&AllowEdit=" + AllowEdit
                + "&AllowDelete=" + AllowDelete
                + "&ChosenTemplet=" + $('#btnTemplets')[0].value
                + "&FragmentID=" + $('#<%=ddlReports.ClientID %>').val()
                + "&Extra1=" + $('#<%=txtExtra1.ClientID %>').val()
                + "&Extra2=" + $('#<%=txtExtra2.ClientID %>').val()
                + "&Extra3=" + $('#<%=txtExtra3.ClientID %>').val()
                + "&Extra4=" + $('#<%=txtExtra4.ClientID %>').val()
                + "&Extra5=" + $('#<%=txtExtra5.ClientID %>').val()
                + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: 'ReportQuery=' + escape($('#<%=txtQuery.ClientID %>').val().split('+').join('***'))
            });
            request.done(function (response, textStatus, jqXHR) {
                //alert(response[0].NewReportID);
                if (response[0].NewReportID != "") {
                    //$('#<%=lblMSG.ClientID %>').text("הדוח נשמר בהצלחה");
                    alert("הדוח נשמר בהצלחה");
                    if ($('#<%=ddlReports.ClientID %>').val() == "0")
                        window.location.href = window.location.href;
                }
                else
                    $('#<%=lblMSG.ClientID %>').text("אראה שגיאה בשמירת הדוח");

                ReportID = response[0].NewReportID;

                SetGrid(ReportID);
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if (jqXHR.responseText.replace("NewReportID: ", "") != "") {
                        //$('#<%=lblMSG.ClientID %>').text("הדוח נשמר בהצלחה");
                        alert("הדוח נשמר בהצלחה");
                        if ($('#<%=ddlReports.ClientID %>').val() == "0")
                            window.location.href = window.location.href;
                    }
                    else
                        $('#<%=lblMSG.ClientID %>').text("אראה שגיאה בשמירת הדוח");

                    ReportID = jqXHR.responseText.replace("NewReportID: ", "");

                    SetGrid(ReportID);
                }
                else {
                    //alert("Error");
                }
            });
        }
        function CloseWinAndRefresh() {
            parent.window.location.href = parent.window.location.href;
            this.close();
        }
        function ShowReport() {
            var win = window.open("ShowReportSqlLite.aspx?ReportID=" + $('#<%=ddlReports.ClientID %>').val(), "windowShowReport", "height=700,width=540,directories=0,titlebar=0,toolbar=0,location=0,status=0,menubar=0,scrollbars=no,resizable=yes");
            win.focus()
        }
        if ('<%=Request.QueryString["isUpdate"].ToString() %>' == 'True') {
            $('#EditWinMDX').css("display", "none");
            $('#dClosebtn').css("display", "none");
            $("#<%=ddlReports.ClientID %> option[value='-1']").remove();

            GetReportData();
            ShowCols();
        }
        else {
                //$('#<%=ddlReports.ClientID %>').css("display","none");
                //$('#<%=ddlReports.ClientID %>').val("0");
                //$('#tddelReport').css("display","none");
            }
            //$('#<%=ddlReports.ClientID %>').val("0");

        function AddColdsByQuery() {
            var LayoutTypeID = "<%=LayoutTypeID %>";
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=AddColdsByQuery&ReportID=" + $('#<%=ddlReports.ClientID %>').val() + "&LayoutTypeID=" + LayoutTypeID + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {
                RefreshMD();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {

                    RefreshMD();
                }
                else {
                    alert("Error");
                }
            });
        }
        function cbShowActionBtnOnTitle_change() {
            if ($('#<%=cbShowActionBtnOnTitle.ClientID %>')[0].checked) {
                $('#trActionBTN1').show();
                $('#trActionBTN2').show();
                $('#trActionBTN3').show();
            }
            else {
                $('#trActionBTN1').hide();
                $('#trActionBTN2').hide();
                $('#trActionBTN3').hide();
            }
        }

        function DuplicateReport() {
            //DuplicateReport(context, context.Request["ReportID"].ToString(), context.Request["DuplicateToReportName"].ToString());
            var request;
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=DuplicateReport&ReportID=" + $('#<%=ddlReports.ClientID %>').val() + "&DuplicateToReportName=" + $('.txtReportNameNew').val() + "&DB=" + $('#<%=ddlDBs.ClientID %>').val() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "get",
                data: ''
            });
                request.done(function (response, textStatus, jqXHR) {
                    window.location.href = window.location.href;
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {

                    if (jqXHR.status == 200) {

                        window.location.href = window.location.href;
                    }
                    else {
                        alert("Error");
                    }
                });
            }
            function ShowDuplicateReport() {
                DisableWin();
                $(".DuplicateRep").show('fast');
            }
            ReportID = $('#<%=ddlReports.ClientID %>').val();

        $('#trActionBTN1').hide();
        $('#trActionBTN2').hide();
        $('#trActionBTN3').hide();

        $('#dBody').height($(window).height() - 40);
    </script>
</body>
</html>
