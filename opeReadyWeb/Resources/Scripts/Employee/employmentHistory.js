﻿function RequaredAddEmploymentHistoryFields(t) { return "0" == $("#ddlEmployeeStatus").val() ? ($("#ddlEmployeeStatus").addClass("ui-state-error").focus(), !1) : ($("#ddlEmployeeStatus").removeClass("ui-state-error", 500), "" == $("#txtFromDateEmploymentHistory").val().trim() ? ($("#txtFromDateEmploymentHistory").addClass("ui-state-error").focus(), !1) : ($("#txtFromDateEmploymentHistory").removeClass("ui-state-error", 500), void btnAddEmploymentHistory_Click(t))) } function btnAddEmploymentHistory_Click(t) { var e = getArgs(); if (e.eid) { $("#waitplease").css({ display: "block" }); var o = { PersonEmploymentHistory_ID: $("#hidPersonEmploymentHistory_ID").val(), Person_ID: e.eid, PersonEmploymentHistory_FromDateStr: $("#txtFromDateEmploymentHistory").val(), PersonEmploymentHistory_ToDateStr: $("#txtToDateEmploymentHistory").val(), PersonEmploymentHistory_Remarks: $("#txtEmploymentHistoryRemarks").val(), EmploymentHistoryType_ID: $("#ddlEmployeeStatus").val() }; employmentHistory.PersonEmploymentHistory_Save(o) } return !1 } function imgEditEmpHis_click(t) { var e = t.PersonEmploymentHistory_ID, o = unescape(t.PersonEmploymentHistory_Remarks); try { $("#txtFromDateEmploymentHistory").val(t.PersonEmploymentHistory_FromDateStr), $("#txtToDateEmploymentHistory").val(t.PersonEmploymentHistory_ToDateStr), $("#ddlEmployeeStatus").val(t.EmploymentHistoryType_ID), $("#txtEmploymentHistoryRemarks").val(o), $("#hidPersonEmploymentHistory_ID").val(e) } catch (t) { } return divEmploymentHistoryEdit_Open(), $("#ppEmploymentHistoryEdit").block({ css: { border: "0px" }, timeout: 200, overlayCSS: { backgroundColor: "#ffffff", opacity: .7 }, message: "" }), !1 } function btnAddNewEmploymentHistory_Click() { $("#divEmploymentHistoryEdit input:text").each(function () { $(this).val("") }), $("select").val("0"), $("#btnAddEmploymentHistory").val($("#hidAdd").text()), $("#hidPersonEmploymentHistory_ID").val(""), $("#txtEmploymentHistoryRemarks").val(""), divEmploymentHistoryEdit_Open() } function PopulationHightligthFields(t) { if (t) { var e = t.getRowData(t.length); $("#txtEmployeeStatus").val(e.EmploymentHistoryType_Name), $("#txtFromDate").val(e.PersonEmploymentHistory_FromDateStr) } } function ReceivedClientData(t) { var e = $("#gvEmlpoymentHistory"); e.clearGridData(), rowCount = t.length; for (var o = 0; o < t.length; o++) e.addRowData(o + 1, t[o]) } var rowCount, employmentHistory = { rowCount: 0, CreateAndPopulateEmploymentHistoryGrid: function () { var t, e = !1; $("#waitplease").css({ display: "block" }), $.cookie("lang") && (t = "he-IL" == $.cookie("lang") || "ar" == $.cookie("lang") ? "rtl" : "ltr"), $.cookie("userRole") && "6" == $.cookie("userRole") && (e = !0), $("#divEmploymentHistory").block({ css: { border: "0px" }, overlayCSS: { backgroundColor: "#ffffff", opacity: .7 }, message: "" }), $("#gvEmlpoymentHistory").jqGrid({ direction: t, datatype: function (t) { employmentHistory.getData(t) }, height: 300, width: "100%", autowidth: !1, colNames: [$("div span[id=hidlblEmployeeStatus]").text(), $("div span[id=hidlblFromDate]").text(), $("div span[id=hidEH_Grid_lblToDate]").text(), $("div span[id=lbllblPersonEmploymentHistoryRemarks]").text(), $("div span[id=hidbtnEdit]").text(), $("#hidbtnDelete").text(), "PersonEmploymentHistory_ID", "PersonEmploymentHistory_ToDate", "EmploymentHistoryType_ID"], colModel: [{ name: "EmploymentHistoryType_Name", index: "EmploymentHistoryType_Name", sortable: !0, sorttype: "text", width: 125 }, { name: "PersonEmploymentHistory_FromDateStr", index: "PersonEmploymentHistory_FromDateStr", formatter: "date", sortable: !0, width: 125 }, { name: "PersonEmploymentHistory_ToDateStr", index: "PersonEmploymentHistory_ToDateStr", formatter: "date", sortable: !0, width: 125 }, { name: "PersonEmploymentHistory_Remarks", index: "PersonEmploymentHistory_Remarks", sortable: !0, sorttype: "text", width: 350 }, { name: "Edit", index: "Edit", sortable: !1, edittype: "image", formatter: editFormatter, width: 32, align: "center" }, { name: "del", index: "del", sortable: !1, edittype: "image", hidden: e, formatter: deleteFormatter, width: 45, align: "center" }, { name: "PersonEmploymentHistory_ID", hidden: "true" }, { name: "PersonEmploymentHistory_ToDateStr", hidden: "true" }, { name: "EmploymentHistoryType_ID", hidden: "true"}], imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>', viewrecords: !0, sortorder: "desc", sortname: "PersonEmploymentHistory_FromDateStr", loadonce: !0, autoencode: !1, pginput: !0, toolbar: [!0, "top"], recordpos: "rtl" == t ? "left" : "right", hoverrows: !1, altRows: !0, pager: "#pagerEmlpoymentHistory", pgbuttons: !1, pginput: !1, gridComplete: function () { rowCount == $(this).getGridParam("records") && ($("#waitplease").css({ display: "none" }), $(this).setGridParam({ datatype: "local", selarrrow: "false" }), $("#divEmploymentHistory").unblock()) }, onCellSelect: function (t, e, o, r) { switch (e) { case 4: imgEditEmpHis_click($(this).getRowData(t)), $("#btnAddEmploymentHistory").val($("#hidUpdate").text()); break; case 5: return employmentHistory.DeleteEmploymentHistory($(this).getRowData(t).PersonEmploymentHistory_ID) } return !1 }, ondblClickRow: function (t, e, o, r) { imgEditEmpHis_click($(this).getRowData(t)), $("#btnAddEmploymentHistory").val($("#hidUpdate").text()) } }), $("#gvEmlpoymentHistory").jqGrid("gridResize", { minWidth: 674, minHeight: 300 }), "6" != $.cookie("userRole") && $("#gvEmlpoymentHistory").toolbarButtonAdd("#t_gvEmlpoymentHistory", { caption: $("#hidEH_btnAddEdit").text(), position: "first", align: "rtl" == t ? "right" : "left", buttonicon: "ui-icon-circle-plus", onClickButton: function () { btnAddNewEmploymentHistory_Click() } }), $("#gvEmlpoymentHistory").jqGrid("sortGrid", "PersonEmploymentHistory_FromDateStr", !0) }, getData: function (t) { var e = getArgs(); e.eid && PQ.Admin.WebService.PQWebService.CreatePersonEmploymentHistoryList(e.eid, function (t, e) { t ? ReceivedClientData(JSON.parse(getMain(t)).rows) : $("#divEmploymentHistory").unblock() }, function (t, e) { }) }, PopulateEmploymentHistoryCombo: function () { return $("#ddlEmployeeStatus>option").remove(), PQ.Admin.WebService.PQWebService.GetEmploymentHistoryType($("#hidEH_grtEmployeeStatus").text(), function (t) { $(t).each(function () { $("#ddlEmployeeStatus").append($("<option></option>").val(this.EmploymentHistoryType_ID).html(this.EmploymentHistoryType_Name)) }) }, function (t) { }), $("#waitplease").css({ display: "none" }), !1 }, PopulateEmploymentHistoryHightlightFields: function () { var t = getArgs(); return t.eid && PQ.Admin.WebService.PQWebService.PersonEmploymentHistoryHightlight(t.eid, function (t) { $(t).each(function () { $("#txtEmployeeStatus").val(t.EmploymentHistoryType_Name), $("#txtFromDate").val(t.PersonEmploymentHistory_FromDateStr) }) }, function (t) { }), !1 }, PersonEmploymentHistory_Save: function (t) { try { PQ.Admin.WebService.PQWebService.PersonEmploymentHistory_Save(t, function (t) { t && ($("#gvEmlpoymentHistory").GridUnload(), employmentHistory.CreateAndPopulateEmploymentHistoryGrid(), $("#txtEmployeeStatus").val(t.EmploymentHistoryType_Name), $("#txtFromDate").val(t.PersonEmploymentHistory_FromDateStr), $("#divEmploymentHistoryEdit").dialog("destroy")), $("#waitplease").css({ display: "none" }) }, function (t) { return !1 }) } catch (t) { return !1 } return !1 }, DeleteEmploymentHistory: function (t) { return void 0 != t && $("#ConfirmDeleteAttachment").dialog({ autoOpen: !0, modal: !0, resizable: !1, closeOnEscape: !0, height: 150, open: function (t, e) { $(this).parent().appendTo("form") }, buttons: { Ok: function (e) { e.preventDefault(), $("#waitplease").css({ display: "block" }); try { PQ.Admin.WebService.PQWebService.PersonEmploymentHistory_Delete(t, function (t) { try { $("#gvEmlpoymentHistory").GridUnload(), employmentHistory.CreateAndPopulateEmploymentHistoryGrid(), $("#txtEmployeeStatus").val(null == t ? "" : t.EmploymentHistoryType_Name), $("#txtFromDate").val(null == t ? "" : t.PersonEmploymentHistory_FromDateStr), $("#ConfirmDeleteAttachment").dialog("close"), $("#waitplease").css({ display: "none" }) } catch (t) { $("#waitplease").css({ display: "none" }), $("#ConfirmDeleteAttachment").dialog("destroy") } }, this.ExecuteFailResult) } catch (e) { return $("#ConfirmDeleteAttachment").dialog("destroy"), $("#waitplease").css({ display: "none" }), !1 } return !1 }, Cancel: function (t) { return t.preventDefault(), $(this).dialog("destroy"), !1 } } }), !1 } };