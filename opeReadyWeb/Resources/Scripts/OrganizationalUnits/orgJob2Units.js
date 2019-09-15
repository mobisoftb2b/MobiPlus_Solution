/// <reference path="../Common/jquery-1.6.4.min.js" />

var job2unit = {};

job2unit.CreateUnitTree = function () {
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
                                        "plugins": ["themes", "xml_data", "ui", "types"],
                                        "core": { "rtl": _rtl, "initially_open": ["root2"], "animation": "100" },
                                        "themes": { "theme": _theme }
                                    }).bind("loaded.jstree", function (e, data) {
                                        $(this).jstree("open_all");
                                    }).bind("select_node.jstree", function (event, data) {
                                        if (data.inst._get_children().length > 0) {
                                            $("#divDenyAttachToParentNode").show("slow");
                                            $("#cblJobsList input[type=checkbox]").each(function () {
                                                $(this).attr('disabled', true).attr("checked", false);
                                            });
                                            $("#btnAddJob2Unit").attr("disabled", true);                                            
                                            return false;
                                        } else {
                                            $("#hidUnitID").val(data.rslt.obj.get(0).id);
                                            doPostBackToJobsList(data.rslt.obj.get(0).id);
                                            $("#btnAddJob2Unit").removeAttr("disabled");
                                            $("#divDenyAttachToParentNode").hide("slow");
                                        }
                                    });
                } catch (e) { }
            }
        },
        function (e) {

        });
};

job2unit.SaveJobID2Unit = function (arrJobID, unitID) {
    PQ.Admin.WebService.OrgUnitsService.JobID2Unit_Save(arrJobID, unitID,
        function (result) {
            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 1000);
        },
        function (e) { });
};
