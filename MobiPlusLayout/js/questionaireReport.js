const questRep = {
    rowCount: 0,
    Init: function () {
        questRep.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";
        let recordpos = (langDir == 'rtl' ? 'right' : 'left');
        $('#divQuestionaire').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
    
        let params = {
            CountryID: $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"],
            DistrID: $.QueryString["DistrID"] == undefined ? "-1" : $.QueryString["DistrID"],
            AgentId: $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"],
            FromDate: $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"],
            ToDate: $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"],
            QuestionnaireID: $.QueryString["QuestionnaireID"] == undefined ? 1 : $.QueryString["QuestionnaireID"]
        };

        HardwareWebService.Layout_POD_WEB_REPORT_TITLE_QUESTIONNAIRE(params.QuestionnaireID, (headers, headerStatus) => {
            const ttHeades = JSON.parse(headers);
            let arrHeaders = [];
            HardwareWebService.Layout_POD_WEB_REPORT_QUESTIONNAIRE(params, (data, dataStatus) => {
                let arrKeys = [], colModelData = [], headerTop = [], headerMid = [], headerLow = [], mainTree = [];
                let low = [], tlow = [], md = [], tmd = [], top = [], ttop = [], res = [], tres = [], results = [];
                let jsonData = JSON.parse(data);
                for (let i in jsonData) {
                    let key = i;
                    let val = jsonData[i];
                    for (let j in val) {
                        let sub_key = j;
                        let sub_val = val[j];
                        arrKeys.push(sub_key);
                    }
                }

                mainTree = questRep.TransformToTree(ttHeades);
                for (var a = 0; a < mainTree.length - 1; a++) {
                    let headerText = mainTree[a].ObjectName;
                    let arrTopTmp = [];
                    if (mainTree[a].children) {
                        let tmp = mainTree[a].children;
                        for (var b = 0; b < tmp.length; b++) {
                            if (tmp[b].children.length > 0) {
                                let tmp1 = tmp[b].children;
                                for (var c = 0; c < tmp1.length; c++) {
                                    arrTopTmp.push(tmp1[c].idObject);
                                }
                            }
                            else {
                                arrTopTmp.push(tmp[b].idObject)
                            }
                        }
                        headerTop.push({ startColumnName: arrTopTmp[0], numberOfColumns: arrTopTmp.length, titleText: headerText });
                    }
                }

                md.push(_.filter(ttHeades, { 'idLevel': 1 }));
                for (let i = 0; i < md[0].length; i++) {
                    tmd.push(_.filter(ttHeades, { 'idLevel': 2, 'idParentObject': md[0][i].idObject }));
                }

                let isEmpty = a => Array.isArray(a) && a.every(isEmpty);
                if (!isEmpty(tmd)) {
                    for (var i = 0; i < tmd.length; i++) {
                        headerMid.push({ startColumnName: _.head(tmd[i]).idObject, numberOfColumns: tmd[i].length, titleText: _.head(tmd[i]).HeaderName });
                    }

                    low.push(_.filter(ttHeades, { 'idLevel': 2 }));
                    for (let i = 0; i < low[0].length; i++) {
                        arrHeaders.push(low[0][i].ObjectName);
                        colModelData.push({ name: low[0][i].idObject, index: low[0][i].idObject, stype: 'text', sorttype: 'text', align: 'center' });
                    }
                }
                else {
                    low.push(_.filter(ttHeades, { 'idLevel': 1 }));
                    for (let i = 0; i < low[0].length; i++) {
                        arrHeaders.push(low[0][i].ObjectName);
                        colModelData.push({ name: low[0][i].idObject, index: low[0][i].idObject, stype: 'text', sorttype: 'text', align: 'center' });
                    }
                }

              

                var tatGrid = $("#grdQuestionaire").jqGrid({
                    direction: langDir,
                    datatype: function (pdata) { questRep.GetConcActivityData(pdata, jsonData); },
                    colNames: arrHeaders,
                    colModel: colModelData,
                    viewrecords: true,
                    sortorder: "asc",
                    autoencode: false,
                    loadonce: false,
                    pginput: false,
                    altRows: false,
                    resizable: false,
                    shrinkToFit: true,
                    rowNum: 20000,
                    toolbar: [true, "top"],
                    height: 'auto',
                    ignoreCase: true,
                    hoverrows: true,
                    recordpos: (langDir == 'rtl' ? 'left' : 'right'),
                    pager: '#grdQuestionairePager',
                    pgbuttons: false,
                    gridComplete: function () {
                        $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                        if (questRep.rowCount == $(this).getGridParam('records')) {
                            $('#divQuestionaire').unblock();
                        }
                    }
                });
                tatGrid.toolbarButtonAdd("#t_grdQuestionaire", {
                    caption: "Excel",
                    position: (langDir == 'rtl' ? 'left' : 'right'),
                    align: (langDir == 'rtl' ? 'right' : 'left'),
                    buttonicon: 'ui-icon-contact',
                    onClickButton: function () {
                        $("#grdQuestionaire").jqGrid("exportToExcel", {
                            includeLabels: true,
                            includeGroupHeader: true,
                            includeFooter: true,
                            fileName: "jqGridExport.xlsx",
                            mimetype: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            onBeforeExport: null,
                            replaceStr: null,
                            maxlength: 40
                        })
                    }
                });

                tatGrid.jqGrid('setGroupHeaders', {
                    useColSpanStyle: true,
                    groupHeaders: headerTop
                });
                tatGrid.jqGrid('setGroupHeaders', {
                    useColSpanStyle: true,
                    groupHeaders: headerMid
                });

            }, function (data, textStatus) {
                debugger;
                console.log(data.message);
                return false;
            });
        }, function (headers, textStatus) {
            console.log(headers.message);
            return false;
        });



    },
    GetConcActivityData: function (pdata, records) {
        if (records) {
            questRep.ReceivedConcActivityData(records)
        }
        return false;
    },
    ReceivedConcActivityData: function (data) {
        var thegrid = $("#grdQuestionaire");
        thegrid.clearGridData();
        questRep.rowCount = data.length;
        if (!questRep.rowCount) $('#divQuestionaire').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    TransformToTree: function (arr) {
        var nodes = {};
        return arr.filter(function (obj) {
            var id = obj["idObject"],
                parentId = obj["idParentObject"];

            try {
                nodes[id] = _.defaults(obj, nodes[id], { children: [] });
                parentId && (nodes[parentId] = (nodes[parentId]))["children"].push(obj);
            } catch (e) {
                console.log(e.message);
            }

            return !parentId;
        });
    }

}

$(function () {
    window.parent.CloseLoading();
    questRep.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});