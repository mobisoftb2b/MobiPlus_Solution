function Nav(url) {
    window.location.href = url;
}
function CheckForEnter(evt,btn) {
    if (evt.keyCode == 13) {
        btn.click();
    }
}
function logOut() {
    Nav("../../Login.aspx");
}
function ShowLogOut() {

    if ($('.dLo2').css("display") == "none")
        $('.dLo2').css("display", "block");
    else
        $('.dLo2').css("display", "none");

}
function slideSwitch(isNext) {
    var $active = $('#slideshow div.active');
    if ($active.length == 0) $active = $('#slideshow div:last');

    var $next;
    if (isNext) {
        $next = $active.next().length ? $active.next()
                : $('#slideshow div:first');
    }
    else {
        $next = $active.prev().length ? $active.prev()
                : $('#slideshow div:last');
    }
    $active.addClass('last-active');

    $next.css({ opacity: 0.0 })
        .addClass('active')
        .animate({ opacity: 1.0 }, 1000, function () {
            $active.removeClass('active last-active');
        });
}
function GoBack() {
    interval = window.clearInterval(interval);
    interval = setInterval('slideSwitch(true)', 5000);
    slideSwitch(false);
}
function GoNext() {
    interval = window.clearInterval(interval);
    interval = setInterval('slideSwitch(true)', 5000);
    slideSwitch(true);
}
function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}
function setLeft(obj, child) {
    if (obj.css("width").replace("px", "") * 1.0 + 5.0 < obj[0].scrollWidth)
        obj.css("width", obj[0].scrollWidth);
    else {
        var Max = 0;
        for (var i = 0; i < child.length; i++) {
            if (child[i].offsetWidth > Max)
                Max = child[i].offsetWidth + 5;
        }
        obj.css("width", Max);
    }
}
function StrSrc(keyWord, isLocal,host) {
    var url = window.location.href.toLocaleString().replace("http://"+host+"/MobiPlusWeb/", "");
    $.ajax({
        url: "http://" + host + "/MobiPlusWeb/Handlers/MainHandler.ashx?MethodName=StrSrc&keyWord=" + keyWord + "&isLocal=" + isLocal + "&url=" + url,
        type: "Get",
        data: '',
        success: function (data) {
            return data;
        },
        error: function () {
            alert("failure");
        }
    });
}
function formatMoney(data, c, d, t) {
    
    var n = data,
    c = isNaN(c = Math.abs(c)) ? 2 : c,
    d = d == undefined ? "." : d,
    t = t == undefined ? "," : t,
    s = n < 0 ? "-" : "",
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
    j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}
function SetFieldOnlyNumbers(id) {
    alert(id);
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
function SetFieldOnlyNumbers(id, isClass) {
    
    var obj = '#' + id;
    if (isClass)
        obj = '.' + id;
    $(obj).keypress(function (event) {
        if (event.which != 8 && isNaN(String.fromCharCode(event.which))) {
            event.preventDefault();
        }
    });
    $(obj).bind('input propertychange', function () {
        if (!isNumber($(this).val()))
            $(this).val("");
    });
}
String.prototype.trim = function () { return this.replace(/^\s+|\s+$/g, ''); };

String.prototype.ltrim = function () { return this.replace(/^\s+/, ''); };

String.prototype.rtrim = function () { return this.replace(/\s+$/, ''); };

String.prototype.fulltrim = function () { return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g, '').replace(/\s+/g, ' '); };

function setDt(id) {
    $("#" + id).datetimepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: 'dd/mm/yy',
        timeFormat: "HH:mm"
    });

    var d = new Date();

    var month = d.getMonth() + 1;
    var day = d.getDate();
    var hours = d.getHours();
    var minutes = d.getMinutes();

    var output = (day < 10 ? '0' : '') + day + '/' +
                    (month < 10 ? '0' : '') + month + '/' +
                    d.getFullYear() + " " + hours + ":" + minutes;

    $('#' + id).val(output);
}
function setDtNoTime(id) {
    $("#" + id).datepicker({
        onSelect: function (dateText) {
            //SetDateNow("1");
        },
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

    $('#' + id).val(output);
}
function GetDictionary(key) {
    return JSON.parse(sessionStorage.getItem(key));
};

function SetDictionary(key, value) {
    sessionStorage.setItem(key, JSON.stringify(value));
};
function ClearDictionary(key) {
    sessionStorage.removeItem(key);
};