const tat = {
    rowCount: 0,
    Init: function () {
        tat.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";
        let recordpos = (langDir == 'rtl' ? 'right' : 'left');
        $('#divTrucksAndTrailors').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
        let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
        let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];

        HardwareWebService.POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR_HEADERS((headers, headerStatus) => {
            const ttHeades = JSON.parse(headers).rows;
            let arrHeaders = [];
            HardwareWebService.POD_WEB_REPORT_TRUCK_AND_TRAILOR_DATA(cid, did, driverID, date, toDate, (data, dataStatus) => {
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

                mainTree = tat.TransformToTree(ttHeades);
                for (var a = 0; a < mainTree.length-1; a++) {
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
                for (var i = 0; i < tmd.length; i++) {
                    headerMid.push({ startColumnName: _.head(tmd[i]).idObject, numberOfColumns: tmd[i].length, titleText: _.head(tmd[i]).HeaderName });
                }


                low.push(_.filter(ttHeades, { 'idLevel': 2 }));
                for (let i = 0; i < low[0].length; i++) {
                    arrHeaders.push(low[0][i].ObjectName);
                    colModelData.push({ name: low[0][i].idObject, index: low[0][i].idObject,stype:'text', sorttype: 'text', align: 'center' });
                }

                var tatGrid = $("#grdTrucksAndTrailors").jqGrid({
                    direction: langDir,
                    datatype: function (pdata) { tat.GetConcActivityData(pdata, jsonData); },
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
                    pager: '#grdTrucksAndTrailorsPager',
                    pgbuttons: false,
                    gridComplete: function () {
                        $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                        if (tat.rowCount == $(this).getGridParam('records')) {
                            $('#divTrucksAndTrailors').unblock();
                        }
                    }
                });
                tatGrid.toolbarButtonAdd("#t_grdTrucksAndTrailors", {
                    caption: "Excel",
                    position: (langDir == 'rtl' ? 'left' : 'right'),
                    align: (langDir == 'rtl' ? 'right' : 'left'),
                    buttonicon: 'ui-icon-contact',
                    onClickButton: function () {
                        $("#grdTrucksAndTrailors").jqGrid("exportToExcel", {
                           includeLabels: true,
                            includeGroupHeader: true,
                            includeFooter: true,                            			  
                            fileName: "jqGridExport.xlsx",
			    mimetype : "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
			    onBeforeExport : null,
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
            tat.ReceivedConcActivityData(records)
        }
        return false;
    },
    ReceivedConcActivityData: function (data) {
        var thegrid = $("#grdTrucksAndTrailors");
        thegrid.clearGridData();
        tat.rowCount = data.length;
        if (!tat.rowCount) $('#divTrucksAndTrailors').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    TransformToTree: function (arr) {
        var nodes = {};
        return arr.filter(function (obj) {
            var id = obj["idObject"],
                parentId = obj["idParentObject"];

            nodes[id] = _.defaults(obj, nodes[id], { children: [] });
            parentId && (nodes[parentId] = (nodes[parentId]))["children"].push(obj);

            return !parentId;
        });
    }

}

$(function () {
    window.parent.CloseLoading();
    tat.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});