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
function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}
function SetFieldOnlyNumbers(id) {
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