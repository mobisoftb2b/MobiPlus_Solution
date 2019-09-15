/// <reference path="../Common/jquery-1.5.2.js" />
/// <reference path="../Common/jquery.jstree.js" />

var orgUnit = {};

orgUnit.CreateUnitTree = function () {
    try {
        PQ.Admin.WebService.PQWebService.GetUserMenu(null,
        function (result) {
            if (result) {
                var _theme, _rtl;
                if ($.cookie("lang")) {
                    var _lang = $.cookie("lang");
                    if (_lang == 'he-IL' || _lang == 'ar') {
                        _theme = "default-rtl";
                        _rtl = true;
                    }
                    else {
                        _theme = "default";
                        _rtl = false;
                    }
                }
                try {
                    $('#UnitsTree').jstree(
                    { "xml_data": { "data": result },
                        "plugins": ["themes", "xml_data", "ui", "types", "crrm"],
                        "core": { "rtl": _rtl, "initially_open": ["root2"], "animation": "100" },
                        "themes": { "theme": _theme }
                    }).bind("loaded.jstree", function (e, data) {
                        $(this).jstree("open_all");
                    }).bind("reopen.jstree", function (e, data) {
                        data.inst.open_all();
                        setInterval(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
                    }).bind("create.jstree", function (e, data) {
                        $("#waitplease").css({ 'display': 'block' });
                        var temp = {
                            Unit_ParentID: data.rslt.parent == -1 ? null : data.rslt.parent.attr("id").replace("node_", ""),
                            Unit_Name: data.rslt.name
                        };
                        PQ.Admin.WebService.OrgUnitsService.OrgUnits_CreateUnit(temp,
                        function (r) {
                            if (r) {
                                $(data.rslt.obj).attr("id", r);
                            }
                            else {
                                $.jstree.rollback(data.rlbk);
                            }
                            $("#waitplease").css({ 'display': 'none' });
                        },
                        function (e) {

                        });
                    }).bind("rename.jstree", function (e, data) {
                        $("#waitplease").css({ 'display': 'block' });
                        var temp = {
                            Unit_ID: $(data.rslt.obj).attr("id"),
                            Unit_Name: data.rslt.new_name
                        };
                        PQ.Admin.WebService.OrgUnitsService.OrgUnits_CreateUnit(temp,
                        function (data) {
                            $("#waitplease").css({ 'display': 'none' });
                            orgUnit.CreateUnitTree();
                        },
                        function (e) {
                        });
                    }).bind("select_node.jstree", function (event, data) {
                        if (data.inst._get_children().length > 0) {
                            $("#btnAddOrgUnits, #btnRenameUnit").removeAttr("disabled");
                            $("#btnRemoveOrgUnits").attr("disabled", true);
                        }
                        else {
                            $("#btnAddOrgUnits, #btnRemoveOrgUnits,#btnRenameUnit").removeAttr("disabled");
                        }
                        if (orgUnit.CheckNodesJobsExists(data.rslt.obj.get(0).id)) {
                            $("#btnAddOrgUnits").attr("disabled", true);
                            $("#divDenyAddingNode").show("slow");
                        }
                        else {
                            $("#divDenyAddingNode").hide("slow");
                        }
                    }).bind("remove.jstree", function (e, data) {
                        try {
                            $("#waitplease").css({ 'display': 'block' });
                            var unitID = $(data.rslt.obj).attr("id");
                            PQ.Admin.WebService.OrgUnitsService.OrgUnits_RemoveUnit(unitID,
                                        function (result) {
                                            if (!result) {
                                                RaiseWarningAlert($("#hidOrgUnits_DeleteUnitError").text());
                                                orgUnit.CreateUnitTree();
                                            }
                                            $("#waitplease").css({ 'display': 'none' });
                                            $('#ConfirmDeleteAttachment').dialog('destroy');
                                        }, function (e) {
                                            $.jstree.rollback(data.rlbk);
                                            $("#waitplease").css({ 'display': 'none' });
                                        });
                        } catch (e) {
                            $.jstree.rollback(data.rlbk);
                            $("#waitplease").css({ 'display': 'none' });
                            return false;
                        }

                    }).jstree("refresh");
                } catch (e) { }
            }
        },
        function (e) { });
    } catch (e) {
        alert(e.Description);
    }
};

orgUnit.CheckNodesJobsExists = function (unitID) {
    if (unitID) {
        $("#waitplease").css({ 'display': 'block' });
        var result = new Boolean(false);
        $.ajax({
            type: "POST",
            url: "/opeReady/WebService/OrgUnitsService.asmx/CheckNodesJobsExists",
            data: "{'unitID':'" + unitID + "'}",
            contentType: "application/json; charset=utf-8",
            async: false,
            dataType: "json",
            success: function (msg) {
                if (getMain(msg))
                    result = true;
                else
                    result = false;
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 200);
            },
            error: function (e) {
                result = false;
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 200);
            }
        });
        return result;
    }
    return false;
}