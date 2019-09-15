function CloseEditBoxPopup() {
    $(".cssEditBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
    $("#dBodyr").unblock();
    setTimeout('refreshHight();', 1);
}

function CloseErrorBox() {
    $(".cssErrorBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
    setTimeout('refreshHight();', 1);
}

function CloseApprovalBox() {
    $(".cssApprovalBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
    $("#dBodyr").unblock();
    setTimeout('refreshHight();', 1);
}

function doApproval() {
    CloseApprovalBox();
    SetPopData('2');
}

function openPop(obj) {

    if (event.which == 13) {

        event.preventDefault();
        var currBox = $(event.target);
        var indexNum = parseFloat(currBox.attr('data-index'));
        $('[data-index="' + (indexNum + 1).toString() + '"]').focus();
    }
    var prm = $("#prm" + obj.id.toString().substr(3, obj.id.toString().length - 3))[0].value;
    var arr = prm.split(';')
    var txtToVld = "";
    var FVSuccess = false;
    var TVSuccess = false;
    var DPSuccess = false;
    var MLSuccess = false;
    var IMSuccess = false;
    var DDLSuccess = false;
    var DateSuccess = false;

    if (obj.name != "ReadOnly") {
        if (obj.name == "Date") {
            if (obj.value.length == 10) {
                if (obj.value[2] != '/' || obj.value[5] != '/') {
                    txtToVld += "הפורמט שהשתמשת בו לא נכון \nהפורמט הנכון (dd/MM/yyyy)";
                    DateSuccess = true;
                }
            }
            else {
                if (obj.value.length == 21) {
                    if (obj.value[2] != ':' || obj.value[5] != ':' || obj.value[12] != '/' || obj.value[15] != '/') {
                        txtToVld += "הפורמט שהשתמשת בו לא נכון \nהפורמט הנכון (dd/MM/yyyy)";
                        DateSuccess = true;
                    }
                }
                else {
                    if (obj.value != "") {
                        txtToVld += "הפורמט שהשתמשת בו לא נכון \nהפורמט הנכון (yyyy/MM/dd)";
                        DateSuccess = true;
                    }
                }
            }
        }
        if (obj.id.toString().substr(0, 3) == "DDL") {
            if (obj.value == "-1" || obj.value == "") {
                txtToVld += "נא לבחור ערך \n";
                DDLSuccess = true;
            }
        }
        else {
            for (var i = 0; i < arr.length; i++) {
                var spl = arr[i].split(':')
                switch (spl[0]) {
                    case "Type":
                        if (obj.value != "") {
                            switch (spl[1]) {
                                case "int":
                                    var Dec = obj.value.split('.')
                                    if (Dec[1]) {
                                        if (Dec[1].length > 0) {
                                            txtToVld += "נא להזין מספרים שלמים בלבד\n";
                                            DPSuccess = true;
                                        }
                                    }
                                case "float":
                                    if (isNaN(obj.value)) {
                                        txtToVld += "נא להזין ערך מספרי בלבד\n";
                                        FVSuccess = true;
                                    }
                                    break;
                            }
                        }

                        break;
                    case "FromValue":
                        if (spl[1] != "") {

                            if (isNaN(obj.value) || obj.value * 1.0 < spl[1] * 1.0) {
                                txtToVld += " נא להזין מספר גבוה מ-" + spl[1] + " \n";
                                FVSuccess = true;
                            }
                        }
                        break;
                    case "ToValue":
                        if (spl[1] != "") {

                            if (isNaN(obj.value) || obj.value * 1.0 > spl[1] * 1.0) {
                                txtToVld += " נא להזין מספר נמוך מ-" + spl[1] + " \n";
                                TVSuccess = true;
                            }
                        }
                        break;
                    case "DecimalPoint":
                        if (spl[1] != "") {
                            var Dec = obj.value.split('.')
                            if (Dec[1]) {
                                if (Dec[1].length > spl[1]) {
                                    txtToVld += " ניתן להזין עד " + spl[1] + " ספרות לאחר הנקודה \n";
                                    DPSuccess = true;
                                }
                            }
                        }
                        break;
                    case "MaxLength":
                        if (spl[1] != "") {
                            if (obj.value.length > spl[1]) {
                                txtToVld += " ניתן להזין עד " + spl[1] + " תווים \n";
                                MLSuccess = true;
                            }

                        }
                        break;
                    case "IsMust":

                        if (spl[1] == 1) {
                            if (obj.value == "") {

                                txtToVld = "נא להזין ערך";
                                IMSuccess = true;
                            }
                        }
                        break;

                    default:
                        break;

                }
            }
        }
    }

    if (FVSuccess || TVSuccess || DPSuccess || MLSuccess || IMSuccess || DDLSuccess || DateSuccess) {
        $("#divContent" + obj.id.toString().substr(3, obj.id.toString().length - 3))[0].innerText = txtToVld;
        $("#divPop_" + obj.id.toString().substr(3, obj.id.toString().length - 3)).show();
        $("#divPop_" + obj.id.toString().substr(3, obj.id.toString().length - 3)).css("top", $('#' + obj.id)[0].parentElement.offsetTop + 67);
    }
    else {
        $("#divPop_" + obj.id.toString().substr(3, obj.id.toString().length - 3)).hide();
    }
    checkVldSucuess();
}

function checkVldSucuess() {
    var sucuess = true;
    for (var i = 0; i < $('.popover').length; i++) {
        if ($('.popover')[i].style.display == "block") {
            sucuess = false;
            break;
        }
    }

    if (sucuess) {
        $('#btn-success').prop('disabled', false);
        $('#btn-success').attr('class', 'btn-success');
    }
    else {
        $('#btn-success').prop('disabled', true);
        $('#btn-success').attr('class', 'btn-success-disabled');
    }
}

function ShowAddFormMD() {

    CloseErrorBox();
    var onFocus = "";

    for (var i = 0; i < $('.popover').length; i++) {
        $('.popover')[i].style.display = "none";
    }
    $('.btn-success').attr('onclick', 'SetPopData("0")');
    $('.btn-success-disabled').attr('onclick', 'SetPopData("0")');
    var arr = $('#' + hdnParamsClientID)[0].value.split(';');
    var boxHeight = 190;

    for (var i = 0; i < arr.length; i++) {
        if ($("#txt" + arr[i].toLowerCase() + i).length > 0) {
            $("#txt" + arr[i].toLowerCase() + i).val("");
            $("#txt" + arr[i].toLowerCase() + i).attr('ReadOnly', false);
            if (i == 0) {
                onFocus = "#txt" + arr[i].toLowerCase() + i;
            }

            boxHeight += 42;

        }
        if ($("#DDL" + arr[i].toLowerCase() + i).length > 0) {
            if (i == 0) {
                onFocus = "#DDL" + arr[i].toLowerCase() + i;
            }
            boxHeight += 42;

        }
        if ($("#cxx" + arr[i].toLowerCase() + i).length > 0) {
            if (i == 0) {
                onFocus = "#cxx" + arr[i].toLowerCase() + i;
            }
            boxHeight += 42;

        }
    }
    ridmd = "0";
    IsAddMD = true;
    $('.cssEditBox').css("display", "block");
    if (boxHeight > 610) {
        boxHeight = 610;
        $('.cssEditBox').css("overflow-y", "scroll");
        $('.cssEditBox').css(" overflow-x", "hidden");
    }
    $('.cssEditBox').css("height", boxHeight + "px");
    var top = 500;
    $(".cssEditBox").css({ top: top })
               .animate({ "top": "100px" }, "high");
    $('#dBodyr').block({ message: '' });
    $(onFocus).trigger("focus");

    for (var i = 0; i < $('.select1').length; i++) {
        if ($('.select1')[i].value == "-1") {
            $("#divContent" + $('.select1')[i].id.toString().substr(3, $('.select1')[i].id.toString().length - 3))[0].innerText = "נא לבחור ערך \n";
            $("#divPop_" + $('.select1')[i].id.toString().substr(3, $('.select1')[i].id.toString().length - 3)).show();
            $("#divPop_" + $('.select1')[i].id.toString().substr(3, $('.select1')[i].id.toString().length - 3)).css("top", $('#' + $('.select1')[i].id)[0].parentElement.offsetTop + 67);
            checkVldSucuess();
        }
    }
}

function ShowEditFormMD() {
    CloseErrorBox();

    var onFocus = "";
    var strHdn = $('#' + hdnParamsTypeClientID)[0].value;
    var strHdnsplit = strHdn.split(':');
    for (var i = 0; i < $('.popover').length; i++) {
        $('.popover')[i].style.display = "none";
    }
    $('.btn-success').attr('onclick', 'SetPopData("1")');
    $('.btn-success-disabled').attr('onclick', 'SetPopData("1")');
    try {

        if (ridmd == "0" || ridmd == "") {
            txtError.innerText = "אנא בחר ערך מן הגריד תחילה.";
            $('.cssErrorBox').css("display", "block");
            $(".cssErrorBox").css({ top: top })
             .animate({ "top": "100px" }, "high");
          
            return;
        }

        if (ridmd != "") {
            var boxHeight = 190;
            var arr = $('#' + hdnParamsClientID)[0].value.toLowerCase().split(';');
            var arrUpCase = $('#' + hdnParamsClientID)[0].value.split(';');
            var Unique = "";
            var firstUnique = true;
            var arrPrimary = $('#' + hdnPrimaryClientID)[0].value.split(';');
            var resParams;

            for (var i = 0; i < arr.length; i++) {
                for (var j = 0; j < arrPrimary.length; j++) {
                    if (arr[i] == arrPrimary[j].toLowerCase()) {
                        if (firstUnique) {
                            firstUnique = false;
                            Unique += arrPrimary[j] + ";" + escape(Row[arrUpCase[i]]);
                        } else {
                            Unique += ";" + arrPrimary[j] + ";" + escape(Row[arrUpCase[i]]);
                        }
                    }
                }
            }

            var url = OrgURL.replace('MPLayout_GetReportDataJSON', 'MPLayout_GetSelectedParameter');
            url = url.substr(0, OrgURL.indexOf("&Params")) + "&Unique=" + Unique + "&Params=" + $('#' + hdnParamsClientID)[0].value + "&Tiks=" + Ticks;



            request = $.ajax({
                url: url,
                type: "GET",
                data: ''
            });
            request.done(function (response, textStatus, jqXHR) {

                resParams = jqXHR.responseText;
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

                if (jqXHR.status == 200) {

                    resParams = jqXHR.responseText;
                    var arrResponse = resParams.split(';');
                    for (var i = 0; i < arr.length; i++) {
                        if ($("#txt" + arr[i] + i).length > 0) {
                            if ("IsReadOnly" == strHdnsplit[i].substr(strHdnsplit[i].length - 10, strHdnsplit[i].length)) {
                                $("#txt" + arr[i] + i).attr('ReadOnly', true);
                                $("#txt" + arr[i] + i).attr('class', 'txtPopup check');
                                $("#txt" + arr[i] + i).attr('name', '');
                                $("#ui-datepicker-div").datepicker("option", "disabled", true);
                            }
                            $("#txt" + arr[i] + i).val(arrResponse[i]);
                            if (i == 0) {
                                onFocus = "#txt" + arr[i] + i;
                            }
                            boxHeight += 42;
                        }
                        if ($("#DDL" + arr[i] + i).length > 0) {
                            $("#DDL" + arr[i] + i).val(arrResponse[i]);
                            if (i == 0) {
                                onFocus = "#DDL" + arr[i] + i;
                            }
                            boxHeight += 42;
                        }
                        if ($("#cxx" + arr[i] + i).length > 0) {
                            if (arrResponse[i] == "1") {
                                $("#cxx" + arr[i] + i)[0].checked = true;
                            } else {
                                $("#cxx" + arr[i] + i)[0].checked = false;
                            }
                            if (i == 0) {
                                onFocus = "#cxx" + arr[i] + i;
                            }
                            boxHeight += 42;
                        }
                    }

                    IsAddMD = false;
                    $('.cssEditBox').css("display", "block");
                    if (boxHeight > 610) {
                        boxHeight = 610;
                        $('.cssEditBox').css("overflow-y", "scroll");
                        $('.cssEditBox').css(" overflow-x", "hidden");
                    }
                    $('.cssEditBox').css("height", boxHeight + "px");
                    var top = 500;
                    $(".cssEditBox").css({ top: top })
                            .animate({ "top": "100px" }, "high");

                    $('#dBodyr').block({ message: '' });
                    $(onFocus).trigger("focus");
                    for (var i = 0; i < $('.select1').length; i++) {
                        if ($('.select1')[i].value == "-1") {
                            $("#divContent" + $('.select1')[i].id.toString().substr(3, $('.select1')[i].id.toString().length - 3))[0].innerText = "נא לבחור ערך \n";
                            $("#divPop_" + $('.select1')[i].id.toString().substr(3, $('.select1')[i].id.toString().length - 3)).show();
                            $("#divPop_" + $('.select1')[i].id.toString().substr(3, $('.select1')[i].id.toString().length - 3)).css("top", $('#' + $('.select1')[i].id)[0].parentElement.offsetTop + 67);
                            checkVldSucuess();
                        }
                    }
                }
                else {
                    txtError.innerText = "אראה שגיאה בשליפת הנתונים";
                }
            });


        }
        else {
            txtError.innerText = "אנא בחר ערך מן הגריד תחילה.";
            $('.cssErrorBox').css("display", "block");
            $(".cssErrorBox").css({ top: top })
          .animate({ "top": "100px" }, "high");
            //alert("אנא בחר ערך");
        }
        return false;
    } catch (e) {
        txtError.innerText = "אנא בחר ערך מן הגריד תחילה.";
        $('.cssErrorBox').css("display", "block");
        $(".cssErrorBox").css({ top: top })
          .animate({ "top": "100px" }, "high");
      
    }

}

function ShowDeleteFormMD() {
    CloseErrorBox();
    try {

        if (ridmd == "0" || ridmd == "") {
            return;
        }
        $('#dBodyr').block({ message: '' });
        $('.cssApprovalBox').css("display", "block");
        $(".cssApprovalBox").css({ top: top })
          .animate({ "top": "100px" }, "high");


    } catch (e) {
        txtError.innerText = "אנא בחר ערך מן הגריד תחילה.";
        $('.cssErrorBox').css("display", "block");
        $(".cssErrorBox").css({ top: top })
         .animate({ "top": "100px" }, "high");

        //alert("אנא בחר ערך מן הגריד תחילה.");
    }

}

function ShowSearchFormMD1() {
    try{
        $("#jQGrid").searchGrid({ closeAfterSearch: false });
        setTimeout('refreshHight();', 1);
        return true;
    }
    catch(e)
    {

    }
}

function SetPopData(setOp) {

    var arr = $('#' + hdnParamsClientID)[0].value.split(';');
    var TableName = $('#' + hdnTableNameClientID)[0].value;
    var txtUrl = "../../Handlers/MainHandler.ashx?MethodName=";
    var dataPost = "";
    var Prams = "";
    var OldPrams = "";
    var strHdnn1 = $('#' + hdnParamsTypeClientID)[0].value.replace('IsReadOnly', '');
    var strHdnn = strHdnn1.split(':');

    switch (setOp) {
        case "0"://add
            txtUrl += "MPLayout_AddParametersTableDefinitions";
            dataPost += "TableName=" + TableName;

            for (var i = 0; i < arr.length; i++) {
                if (i == 0) {
                    switch (strHdnn[i]) {
                        case "text":
                        case "int":
                        case "float":
                        case "Dateyyyymmdd":
                        case "DateTime":
                            Prams += arr[i] + ";" + escape($("#txt" + arr[i].toLowerCase() + i)[0].value);
                            break;
                        case "boolean":
                            var bool = 0;
                            if ($("#cxx" + arr[i].toLowerCase() + i)[0].checked) {
                                bool = 1;
                            }
                            Prams += arr[i] + ";" + bool;
                            break;
                        case "LOV":
                            Prams += arr[i] + ";" + escape($("#DDL" + arr[i].toLowerCase() + i)[0].value);
                            break;
                    }

                }
                else {
                    switch (strHdnn[i]) {
                        case "text":
                        case "int":
                        case "float":
                        case "Dateyyyymmdd":
                        case "DateTime":
                            Prams += ";" + arr[i] + ";" + escape($("#txt" + arr[i].toLowerCase() + i)[0].value);
                            break;
                        case "boolean":
                            var bool = 0;
                            if ($("#cxx" + arr[i].toLowerCase() + i)[0].checked) {
                                bool = 1;
                            }
                            Prams += ";" + arr[i] + ";" + bool;
                            break;
                        case "LOV":
                            Prams += ";" + arr[i] + ";" + escape($("#DDL" + arr[i].toLowerCase() + i)[0].value);
                            break;
                    }

                }
            }
            dataPost += "&Prams=" + Prams;
            break;
        case "1"://edit
            txtUrl += "MPLayout_EditParametersTableDefinitions";
            dataPost += "TableName=" + TableName;
            for (var i = 0; i < arr.length; i++) {
                if (i == 0) {
                    switch (strHdnn[i]) {
                        case "text":
                        case "int":
                        case "float":
                        case "Dateyyyymmdd":
                        case "DateTime":

                            Prams += arr[i] + ";" + escape($("#txt" + arr[i].toLowerCase() + i)[0].value);
                            break;
                        case "boolean":
                            var bool = 0;
                            if ($("#cxx" + arr[i].toLowerCase() + i)[0].checked) {
                                bool = 1;
                            }
                            Prams += arr[i] + ";" + bool;
                            break;
                        case "LOV":
                            Prams += arr[i] + ";" + escape($("#DDL" + arr[i].toLowerCase() + i)[0].value);
                            break;
                    }
                }
                else {
                    switch (strHdnn[i]) {
                        case "text":
                        case "int":
                        case "float":
                        case "Dateyyyymmdd":
                        case "DateTime":

                            Prams += ";" + arr[i] + ";" + escape($("#txt" + arr[i].toLowerCase() + i)[0].value);
                            break;
                        case "boolean":
                            var bool = 0;
                            if ($("#cxx" + arr[i].toLowerCase() + i)[0].checked) {
                                bool = 1;
                            }
                            Prams += ";" + arr[i] + ";" + bool;
                            break;
                        case "LOV":
                            Prams += ";" + arr[i] + ";" + escape($("#DDL" + arr[i].toLowerCase() + i)[0].value);
                            break;
                    }
                }
            }
            dataPost += "&Prams=" + Prams;

            for (var i = 0; i < arr.length; i++) {
                if (i == 0) {

                    if (Row[arr[i]].indexOf("<") > -1) {
                        try {

                            var $html = $(Row[arr[i]]);
                            OldPrams += arr[i] + ";" + escape($html.prop('innerText'));
                        }

                        catch (e) { }
                    } else {
                        OldPrams += arr[i] + ";" + escape(Row[arr[i]]);
                    }
                }
                else {
                    if (Row[arr[i]].indexOf("<") > -1) {
                        try {

                            var $html = $(Row[arr[i]]);
                            OldPrams += ";" + arr[i] + ";" + escape($html.prop('innerText'));
                        }

                        catch (e) { }
                    } else {
                        OldPrams += ";" + arr[i] + ";" + escape(Row[arr[i]]);
                    }
                }
            }
            dataPost += "&OldPrams=" + OldPrams;
            break;
        case "2"://del
            txtUrl += "MPLayout_DelParametersTableDefinitions";
            dataPost += "TableName=" + TableName;
            for (var i = 0; i < arr.length; i++) {
                if (i == 0) {

                    if (Row[arr[i]].indexOf("<") > -1) {
                        try {

                            var $html = $(Row[arr[i]]);
                            OldPrams += arr[i] + ";" + escape($html.prop('innerText'));
                        }

                        catch (e) { }
                    } else {
                        OldPrams += arr[i] + ";" + escape(Row[arr[i]]);
                    }
                }
                else {
                    if (Row[arr[i]].indexOf("<") > -1) {
                        try {

                            var $html = $(Row[arr[i]]);
                            OldPrams += ";" + arr[i] + ";" + escape($html.prop('innerText'));
                        }

                        catch (e) { }
                    } else {
                        OldPrams += ";" + arr[i] + ";" + escape(Row[arr[i]]);
                    }
                }
            }
            dataPost += "&Prams=" + OldPrams;
            break;
    }
    var hdnType = $('#' + hdnParamsTypeClientID)[0].value.toLowerCase();
    var hdnPrimary = $('#' + hdnPrimaryClientID)[0].value;
    hdnType.replace("IsReadOnly", "");
    dataPost += "&Type=" + hdnType;
    dataPost += "&IsPrimary=" + hdnPrimary;
    dataPost += "&Tiks=" + Ticks;
    var request;
    request = $.ajax({
        url: txtUrl,
        type: "POST",
        data: dataPost
    });
    request.done(function (response, textStatus, jqXHR) {

        CloseEditBoxPopup();
       
       
        ridmd = "0";
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

        if (jqXHR.status == 200) {
            if (jqXHR.responseText == "True") {
                CloseEditBoxPopup();
                RefreshMD();
               // setTimeout('RefreshMDBuURL();', 500);
                ridmd = "0";
            }
            else {
                txtError.innerText = jqXHR.responseText;
                $('.cssErrorBox').css("display", "block");
                $(".cssErrorBox").css({ top: top }).animate({ "top": "100px" }, "high");
            }
        }
        else {
            txtError.innerText = "אראה שגיאה בשמירת הנתונים";
            $('.cssErrorBox').css("display", "block");
            $(".cssErrorBox").css({ top: top })
          .animate({ "top": "100px" }, "high");
         
        }
    });

}

function GetColID(data, ColName) {
    var ColID = 0;
    var RetColID = 0;
    $.each(data[0], function (key, value) {
        if (key == ColName) {
            RetColID = ColID;
        }
        ColID++;
    });
    return RetColID;
}

function initwData(data) {

    $(".ui-pg-div").click(doNone);

    try {
        $("#edit_" + GridID)[0].children[0].onclick = ShowEditFormMD;

        $("#add_" + GridID)[0].children[0].onclick = ShowAddFormMD;

        $("#del_" + GridID)[0].children[0].onclick = ShowDeleteFormMD;

    } catch (e) { }
    //alert($("#gview_" + GridID)[0].children[0].children[0].children[0].innerHTML);
   // $("#gview_" + GridID)[0].children[0].children[1].onclick = HideSearchRow;
    //$("#gview_" + GridID)[0].children[0].children[0].children[0].parentElement.parentElement.onclick = HideSearchRow


    $("#last_" + GridID + "Pager")[0].children[0].onclick = refreshHight;

    $("#next_" + GridID + "Pager")[0].children[0].onclick = refreshHight;

    $("#prev_" + GridID + "Pager")[0].children[0].onclick = refreshHight;

    $("#first_" + GridID + "Pager")[0].children[0].onclick = refreshHight;

    //$("#search_" + GridID)[0].children[0].onclick = ShowSearchFormMD1;

    $("#refresh_" + GridID)[0].children[0].onclick = RefreshMD;

    //$('.ui-icon-circle-triangle-n')[0].children[0].onclick  = alert;
   // debugger;
    try {

        //$(".ui-icon-circle-triangle-n").click(ShowSearchFormMD1);
    }
    catch(e)
    {
        alert(e);
    }
    //ui-iconms ui-icon-circle-triangle-n
}

function doNone() {
    //alert('doNone');
    return false;
}


function RefreshMD() {
  
    scrollPosition = jQuery("#jQGrid").closest(".ui-jqgrid-bdiv").scrollTop();
    pagePosition = $('#jQGrid').getGridParam('page');
    ColName = "";
    FilterValue = "";
   
    for (var i = 0; i < $('.SearchOnTop').length; i++) {
        if ($('.SearchOnTop')[i].id != "") {
            if (i == 0) {
                ColName += $('.SearchOnTop')[i].id.substr(6, $('.SearchOnTop')[i].id.lenght);
                FilterValue += escape($('.SearchOnTop')[i].value.toString());
            }
            else {
                ColName += ";" + $('.SearchOnTop')[i].id.substr(6, $('.SearchOnTop')[i].id.lenght);
                FilterValue += ";" + escape($('.SearchOnTop')[i].value.toString());
            }
        }
    }
  

    $('#jQGrid').setGridParam({ datatype: "json" }).trigger('reloadGrid');
    setTimeout(function () {
        $('#jQGrid').trigger("reloadGrid", [{ page: pagePosition }]);
    },150);
    var url = OrgURL.substr(0, OrgURL.indexOf("&ColumnName")) + "&ColumnName=" + ColName + "&Value=" + FilterValue;
    setTimeout('LoadGrid("'+url+'");', 500);
}

function RefreshMDBuURL(url) {
    scrollPosition = jQuery("#jQGrid").closest(".ui-jqgrid-bdiv").scrollTop();
    pagePosition = $('#jQGrid').getGridParam('page');
    $('#jQGrid').setGridParam({ current: true, datatype: "json" }).trigger('reloadGrid');
}


function RefreshMDBuData(data) {
    pagePosition = $('#jQGrid').getGridParam('page');
    $('#jQGrid').setGridParam({ current: true, datatype: "jsonstring", datastr: data }).trigger('reloadGrid');

    $('#jQGrid').setGridParam({ datatype: "jsonstring", datastr: data }).trigger('reloadGrid');
    setTimeout(function () {
        $('#jQGrid').trigger("reloadGrid", [{ page: pagePosition }]);
    }, 150);
}
function HideSearchRow() {
    if ($('.ui-jqgrid-txt').css("display") == "none") {
        $('.ui-jqgrid-txt').css("display", "");
    } else {
        $('.ui-jqgrid-txt').css("display", "none");
    }
    refreshHight();
}

function SearchBytxt(obj) {
   
    ColName = "";
    FilterValue = "";
    for (var i = 0; i < $('.SearchOnTop').length; i++) {
        if ($('.SearchOnTop')[i].id != "") {
            if (i == 0) {
                ColName += $('.SearchOnTop')[i].id.substr(6, $('.SearchOnTop')[i].id.lenght);
                FilterValue += escape($('.SearchOnTop')[i].value.toString());
            }
            else {
                ColName += ";" + $('.SearchOnTop')[i].id.substr(6, $('.SearchOnTop')[i].id.lenght);
                FilterValue += ";" + escape($('.SearchOnTop')[i].value.toString());
            }
        }
    }

    var url = OrgURL.substr(0, OrgURL.indexOf("&ColumnName")) + "&ColumnName=" + ColName + "&Value=" + FilterValue;
    // RefreshMDBuURL(url);
    LoadGrid(url);
}

function LoadGrid(url) {
    
    var request;
    request = $.ajax({
        url: url,
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
        ColName = "";
        FilterValue = "";
        for (var i = 0; i < $('.SearchOnTop').length; i++) {
            if ($('.SearchOnTop')[i].id != "") {
                ColName = $('.SearchOnTop')[i].id;
               
                var obj = jQuery.parseJSON(jqXHR.responseText);
                if (obj.length > 0) {
                    try {
                        if (obj[i].id.substr(0, 6) == "DDLSel") {
                            var str = decodeURIComponent(obj[i].htmSelect).split("+").join(" ");
                            $('.divSearchContralByCol_' + obj[i].ColName.toLowerCase()).html(str);
                        }
                    } catch (e) { }
                }
            }
        }

        //if ($('.txtSearch').length < 0 && $('.selectSearch').length < 0) {
        //    $('.ui-jqgrid-txt').css("display", "none");
        //} else {
        //    $('.ui-jqgrid-txt').css("display", "block");
        //}

        var jsonToGrid = decodeURIComponent(decodeURIComponent(obj[obj.length - 1].htmSelect).split("+").join("%2b")).split("+").join(" ");
        
        RefreshMDBuData(jsonToGrid);
      
        refreshHight();
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

        if (jqXHR.status == 200) {
        }
        else {
            txtError.innerText = "אראה שגיאה בשליפת הנתונים";
            $('.cssErrorBox').css("display", "block");
            $(".cssErrorBox").css({ top: top })
          .animate({ "top": "100px" }, "high");
         
        }
    });
}

function refreshHight() {
    //alert($('.ui-jqgrid-txt')[0].style["display"]);
    if ($('.ui-jqgrid-txt')[0].style["display"] == "none") {
        $('.ui-jqgrid-view').css("height", ($('#gridDiv').height() - 27));
        $('.ui-jqgrid-bdiv').css("height", ($('#gridDiv').height() - 57 - ($('.ui-jqgrid-labels').height())));
    } else {
        $('.ui-jqgrid-view').css("height", ($('#gridDiv').height() - 27));
        $('.ui-jqgrid-bdiv').css("height", ($('#gridDiv').height() - 83 - ($('.ui-jqgrid-labels').height())));
    }
}
