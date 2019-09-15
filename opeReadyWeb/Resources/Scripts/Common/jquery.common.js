(function ($) {
    $.fn.dropDownBlock = function (block, options) {
        var defaults = {
            speed: 'fast',
            top: $(this).height(),
            left: 0
        },
		opts = $.extend(defaults, options),
		toggler = $(this),
		block = $(block);
        toggler.css({ 'outline': 'none' })

        toggler.click(function (e) {
            e.preventDefault();
            $(block).css({
                'position': 'absolute',
                'top': (toggler.offset().top + opts['top']) + 'px',
                'left': (toggler.offset().left + opts['left']) + 'px'
            });
            if ($(block).is(':visible')) $(block).fadeOut(opts['speed']);
            else $(block).fadeIn(opts['speed']);
            this.focus();
        });
        toggler.blur(function () {
            $(block).fadeOut(opts['speed']);
        });
    };
})(jQuery);
//------------------------------------------------------------------------------------------------
// openCloseBlocks plugin 
(function ($) {
    $.fn.openCloseBlocks = function (blocks, options) {
        var defaults = {
            speed: 'normal'
        },
		opts = $.extend(defaults, options),
		togglers = $(this),
		bls = $(blocks); if (!bls) return;

        togglers.each(function (index) {
            $(this).click(function (e) {
                e.preventDefault();
                $(bls[index]).slideToggle(opts['speed']);
            });
        });
    };
})(jQuery);
//------------------------------------------------------------------------------------------------
//plugin AddXbutton textbox with X
(function ($) {
    $.fn.addXbutton = function (options) {
        var defaults = {
            img: '/Ruka2/resourses/images/x.gif'
        };
        var opts = $.extend(defaults, options);
        $obj = $(this);
        $(this).each(
		 function (i) {
		     $(this).after(
				 $('<input type="image" id="xButton' + i + '" src="' + opts['img'] + '" />')
					 .css({ 'display': 'none', 'cursor': 'pointer', 'marginLeft': '-15px', 'width': '10px', 'height': '10px', 'border': '0' })
					 .click(function () {
					     $obj.val('').focus();
					     $("#xButton" + i).hide();
					     return false;
					 }))
			 .keyup(function () {
			     if ($(this).val().length > 0) {
			         $("#xButton" + i).show();
			     } else {
			         $("#xButton" + i).hide();
			     }
			     if ($(this).val() != '') $("#xButton" + i).show();
			 });
		 });
    };
})(jQuery);
//--------------------------------------------------------------------------------------------------
//plugin AddDDLbutton textbox with triangle
(function ($) {
    $.fn.AddDDLbutton = function (options) {
        var defaults = {
            img: '/opeReady/Resources/images/ddl.png'
        };
        var opts = $.extend(defaults, options);
        $obj = $(this);
        $(this).each(function () {
            $(this).after(
				 $('<input type="image" style="cursor:pointer" id="xButton" src="' + opts['img'] + '" />')
					 .addClass('input-ddl'))
        });
    };
})(jQuery);

//-------------------------------------------------------------------------------------------------
//plugin QueryStringParser 
(function ($) {
    function QueryStringParser() {
        this.Values = new Object();
        this.load();
    }

    $.extend(QueryStringParser.prototype, {
        load: function () {
            if (window.location.search.length <= 1) {
                return;
            }

            var queryString = window.location.search.substring(1);
            var pairs = queryString.split('&');
            for (var i = 0; i < pairs.length; i++) {
                this.Values[pairs[i].split('=')[0].toLowerCase()] = decodeURIComponent(pairs[i].split('=')[1]);
            }
        },
        get: function (key) {
            return (this.Values[key.toLowerCase()]) ? this.Values[key.toLowerCase()] : '';
        },
        set: function (key, value) {
            this.Values[key.toLowerCase()] = value;
            return this;
        }
    });

    QueryStringParser.prototype.toString = function () {
        var params = [];

        for (var prop in this.Values) {
            params.push(prop + "=" + encodeURIComponent(this.Values[prop]));
        }

        return '?' + params.join('&');
    };
    $.Params = new QueryStringParser();
})(jQuery);

//plugin autocomplete - combobox 
//$.widget("ui.combobox", {
//    _create: function () {
//        var self = this;
//        var select = this.element.hide(),
//   selected = select.children(":selected"),
//   value = selected.val() ? selected.text() : "";
//        var input = $("<input />")
//   .insertAfter(select)
//   .val(value)
//   .autocomplete({
//       delay: 0,
//       minLength: 0,
//       source: function (request, response) {
//           var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
//           response(select.children("option").map(function () {
//               var text = $(this).text();
//               if (this.value && (!request.term || matcher.test(text)))
//                   return {
//                       label: text.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + $.ui.autocomplete.escapeRegex(request.term) + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>"),
//                       value: text,
//                       option: this
//                   };
//           }));
//       },
//       select: function (event, ui) {
//           ui.item.option.selected = true;
//           self._trigger("selected", event, {
//               item: ui.item.option
//           });
//       },
//       change: function (event, ui) {
//           if (!ui.item) {
//               var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex($(this).val()) + "$", "i"),
//               valid = false;
//               select.children("option").each(function () {
//                   if (this.value.match(matcher)) {
//                       this.selected = valid = true;
//                       return false;
//                   }
//               });
//               if (!valid) {
//                   // remove invalid value, as it didn't match anything
//                   $(this).val("");
//                   select.val("");
//                   return false;
//               }
//           }
//       }
//   })
//   .addClass("ui-widget ui-widget-content ui-corner-left");
//        input.data("autocomplete")._renderItem = function (ul, item) {
//            return $("<li></li>")
//  .data("item.autocomplete", item)
//  .append("<a>" + item.label + "</a>")
//  .appendTo(ul);
//        };
//        $("<button> </button>")
// .attr("tabIndex", -1)
// .attr("title", "Show All Items")
// .insertAfter(input)
// .button({
//     icons: {
//         primary: "ui-icon-triangle-1-s"
//     },
//     text: false
// })
// .removeClass("ui-corner-all")
// .addClass("ui-corner-right ui-button-icon")
// .click(function () {
//     // close if already visible
//     if (input.autocomplete("widget").is(":visible")) {
//         input.autocomplete("close");
//         return;
//     }
//     // pass empty string as value to search for, displaying all results
//     input.autocomplete("search", "");
//     input.focus();
// });
//    }
//});

function getArgs() {
    var args = new Object();
    var query = location.search.substring(1);
    var pairs = query.split("&");
    for (var i = 0; i < pairs.length; i++) {
        var pos = pairs[i].indexOf('=');
        if (pos == -1) continue;
        var argname = pairs[i].substring(0, pos);
        var value = pairs[i].substring(pos + 1);
        args[argname] = unescape(value);
    }
    return args;
}

function setTextContent(element, text) {
    while (element.firstChild !== null)
        element.removeChild(element.firstChild); // remove all existing content
    element.appendChild(document.createTextNode(text));
}

function checkRegexp(o, regexp, n) {

    if (!(regexp.test(o.val()))) {
        o.addClass('ui-state-error');
        updateTips(n);
        return false;
    } else {
        return true;
    }

}

function checkLength(o, n, min, max) {

    if (o.val().length > max || o.val().length < min) {
        o.addClass('ui-state-error');
        updateTips("Length of " + n + " must be between " + min + " and " + max + ".");
        return false;
    } else {
        return true;
    }

}
function updateTips(t) {
    tips.text(t)
		.addClass('ui-state-error');
    setTimeout(function () {
        tips.removeClass('ui-state-error', 1500);
    }, 500);
}

function GetTrainingEventTypeSelectRequiredField(selectedValue) {
    if (!selectedValue) return 0;
    var res = 0;
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectRequiredField(selectedValue,
	function (result) {
	    if (!isNaN(result)) {
	        return result;
	    }
	},
	function (e) { res = 0; });
}

function SetVisibilityText(selectedValue, isUpdate) {
    RaiseLoader(true);
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectRequiredField(selectedValue,
	   function (result) {
	       if (!isNaN(result)) {
	           $('#hidEventTypeID').val(result);
	           switch (parseInt(result)) {
	               case 1:
	                   $('.divPerfomanceLevel').removeClass('no-display').addClass('selecting');
	                   $('.divTotalScore').addClass('no-display').removeClass('selecting');
	                   $('.divQuality').addClass('no-display').removeClass('selecting');
	                   $('#txtQuality').val('');
	                   $('#txtTotalScore').val('');
	                   $('#divCumulativeQuantity').addClass('noDisplay');
	                   break;
	               case 2:
	                   $('.divTotalScore').removeClass('no-display').addClass('selecting');
	                   $('.divPerfomanceLevel').addClass('no-display');
	                   $('.divQuality').addClass('no-display').removeClass('selecting');
	                   $('#ddlPerfomanceLevel').val('0'); $('#txtQuality').val('');
	                   $('#divCumulativeQuantity').addClass('noDisplay');
	                   $('.divPerfomanceLevel').removeClass('selecting');
	                   break;
	               case 3:
	                   $('.divQuality').removeClass('no-display').addClass('selecting');
	                   $('#divCumulativeQuantity').removeClass('noDisplay');
	                   $('.divPerfomanceLevel').addClass('no-display').removeClass('selecting');
	                   $('.divTotalScore').addClass('no-display').removeClass('selecting');
	                   $('#ddlPerfomanceLevel').val('0'); $('#txtTotalScore').val('');
	                   break;
	               default:
	                   $('.divPerfomanceLevel').addClass('no-display').removeClass('selecting');
	                   $('.divTotalScore').addClass('no-display').removeClass('selecting');
	                   $('.divQuality').addClass('no-display').removeClass('selecting');
	                   $('#txtQuality').val('');
	                   $('#txtTotalScore').val('');
	                   $('#divCumulativeQuantity').addClass('noDisplay');
	                   break;
	           }
	           if (selectedValue == "10002" || selectedValue == "10003")
	               $('#divMinTipImages').removeClass('noDisplay', 250);
	           else
	               $('#divMinTipImages').addClass('noDisplay', 250);
	       }
	   }, function (e) { });
    $("#waitplease").css({ 'display': 'none' });
};

function getMain(dObj) {
    if (dObj.hasOwnProperty('d'))
        return dObj.d;
    else
        return dObj;
}

function scoutEditor(controlID) {
    $('#' + controlID).wysiwyg({
        controls: {
            strikeThrough: { visible: true },
            underline: { visible: true },

            separator00: { visible: true },

            justifyLeft: { visible: true },
            justifyCenter: { visible: true },
            justifyRight: { visible: true },
            justifyFull: { visible: true },

            separator01: { visible: true },

            indent: { visible: true },
            outdent: { visible: true },

            separator02: { visible: true },

            subscript: { visible: true },
            superscript: { visible: true },

            separator03: { visible: true },

            undo: { visible: true },
            redo: { visible: true },

            separator04: { visible: true },

            insertOrderedList: { visible: true },
            insertUnorderedList: { visible: true },
            insertHorizontalRule: { visible: true },

            separator07: { visible: true },

            cut: { visible: true },
            copy: { visible: true },
            paste: { visible: true }
        }
    });
};

function XmlParser(xml_string) {
    var xmlDoc;
    if (window.DOMParser) {
        parser = new DOMParser();
        xmlDoc = parser.parseFromString(xml_string, "text/xml");
    }
    else // Internet Explorer
    {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = "false";
        xmlDoc.loadXML(xml_string);
    }
    return xmlDoc;
}
Date.prototype.toMSJSON = function (value) {
    var d = new Date(value);
    var date = '/Date(' + d.getDate() + ')/';
    return date;
};
function editFormatter() {
    var img = new Image(32, 32);
    $(img).attr("src", "/opeReady/Resources/icons/edit.png");
    $(img).attr("style", "cursor:pointer");
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}

function deleteFormatter() {
    var img = new Image(32, 32);
    $(img).attr("src", "/opeReady/Resources/icons/trash.png");
    $(img).attr("style", "cursor:pointer");
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}
function attachFormatter() {
    var img = new Image(32, 32);
    $(img).attr("src", "/opeReady/Resources/icons/copydoc.png");
    $(img).attr("style", "cursor:pointer");
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}
function checkboxPic(cellvalue, options, rowObject) {
    var img = new Image(32, 32);
    if (cellvalue) {
        $(img).attr("src", "/opeReady/Resources/images/24_tick.png");
    }
    else {
        $(img).attr("src", "/opeReady/Resources/images/empty.png");
    }
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}
function maintAlertFormatter(cellvalue, options, rowObject) {
    var img = new Image(30, 30);
    if (cellvalue)
        $(img).attr("src", "/opeReady/Resources/images/24_alert.png");
    else
        $(img).attr("src", "/opeReady/Resources/images/empty.png");
    $(img).attr("style", "cursor:pointer");
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}
function faultAlertFormatter(cellvalue) {
    var img = new Image(32, 30);
    if (cellvalue)
        $(img).attr("src", "/opeReady/Resources/images/error32.png");
    else
        $(img).attr("src", "/opeReady/Resources/images/empty.png");
    $(img).attr("style", "cursor:pointer");
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}
function dateFormatter(value) {
    if (value) {
        var re = /-?\d+/;
        var m = re.exec(value);
        var date = new Date(parseInt(m[0]));
        return date.format("dd/MM/yyyy");
    }
    return '';
}
function utcDateFormatter(cellvalue, options, rowObject) {
    if (cellvalue) {
        return moment(cellvalue).format("DD/MM/YYYY");
    } else {
        return '';
    }
}
function RaiseWarningAlert(text) {
    $("#divErrorMessageAlert").dialog({ autoOpen: true, resizable: false, closeOnEscape: true, modal: true,
        open: function (type, data) {
            $("#lblErrorMessageAlert").text(text);
        },
        buttons: {
            Ok: function () {
                $(this).dialog("destroy");
            }
        }
    });
}


function RaiseDialogSuccessMessage(text) {
    $("#dialogSuccessMessage").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, modal: true, height: 150,
        open: function (type, data) {
            $("#lblSuccessMessage").text(text);
        },
        buttons: {
            Ok: function () {
                $(this).dialog("destroy");
            }
        }
    });
}

function ConfirmDelete() {
    var result = new Boolean();
    $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
        open: function (type, data) {
            $(this).parent().appendTo("form");
        },
        buttons: {
            Ok: function (e) {
                result = true;
            },
            Cancel: function (e) {
                $(this).dialog('destroy');
                result = false;
            }
        }
    });
    return result;
}
function resizeWindow() {
    var containerElement = document.getElementById('<%=grdHeader.ClientID%>');
    window.resizeTo(containerElement.offsetWidth, containerElement.offsetHeight);
}

function RaiseLoader(parameters) {
    if (parameters) $("#waitplease").css({ 'display': 'block' });
    else $("#waitplease").css({ 'display': 'none' });

}
function htmlPopUp(path, message, buttonCaption, h, w) {
    var args = new Array();
    args[0] = message;
    args[1] = buttonCaption;
    retVal = window.showModalDialog(path, args, 'dialogHeight:' + h + 'px;unadorned:0;dialogWidth:' + w + 'px;edge:Raised;center:Yes;help:No;resizable:No;status:No;scroll:No;');
    if (retVal == 1 || retVal == '1') { return true; }
    if (retVal == -1 || retVal == '-1') { return false; }
    else { return false; }
}

function htmlResizablePopUp(path, message, buttonCaption, h, w) {
    var args = new Array();
    args[0] = message;
    args[1] = buttonCaption;
    retVal = window.showModalDialog(path, args, 'dialogHeight:' + h + 'px;unadorned:0;dialogWidth:' + w + 'px;edge:Raised;center:Yes;help:No;resizable:Yes;status:No;scroll:No;');
    return false;
};

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
};


$.fn.ForceNumericOnly =
function () {
    return this.each(function () {
        $(this).keydown(function (e) {
            var key = e.charCode || e.keyCode || 0;
            // allow backspace, tab, delete, arrows, numbers and keypad numbers ONLY
            return (
				key == 8 ||
				key == 9 ||
				key == 46 ||
				(key >= 37 && key <= 40) ||
				(key >= 48 && key <= 57) ||
				(key >= 96 && key <= 105) ||
				(key == 110 || key == 190));
        })
    })
};

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;

    return true;
};

function ColorAreaSelector(readinessID) {
    var result;
    switch (readinessID) {
        case 1:
            result = 80;
            break;
        case 2:
            result = 50;
            break;
        case 3:
            result = 20;
            break;
    }
    return result;
};

String.prototype.bool = function () {
    return (/^true$/i).test(this);
};

function getAge(birthDate) {
    var now = new Date();

    function isLeap(year) {
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
    }
    var days = Math.floor((now.getTime() - birthDate.getTime()) / 1000 / 60 / 60 / 24);
    var age = 0;

    for (var y = birthDate.getFullYear(); y <= now.getFullYear(); y++) {
        var daysInYear = isLeap(y) ? 366 : 365;
        if (days >= daysInYear) {
            days -= daysInYear;
            age++;
        }
    }
    return age;
};

function GetArrayTreeIDs(xmlD, level) {
    var array = new Array();
    var root;
    var xmlDoc = XmlParser(xmlD);
    switch (level) {
        case 0:
            $(xmlDoc).find("item").each(function () {
                array.push('#' + $(this).attr('id'));
            });
            break;
        case 1:
            $(xmlDoc).find("item").each(function () {
                if ($(this).attr('parent_id') == "") {
                    var n = $(this).attr('id');
                    array.push('#' + n);
                }
            });
            break;
        case 2:
            root = $(xmlDoc).find('item:[parent_id=""]').attr("id");
            for (var i = 0; i < root.length; i++) {
                $(xmlDoc).find("item").each(function () {
                    if ($(this).attr('parent_id') == root[i]) {
                        var n = $(this).attr('id');
                        array.push('#' + n);
                    }
                });
            }
            break;
        default:
            $(xmlDoc).find("item").each(function () {
                array.push('#' + $(this).attr('id'));
            });
            break;
    }
    return array;
}

function checkFileExtension(elem, extention) {
    var validExtensions = new Array();
    if (elem != null) {
        var filePath = elem.value;

        if (filePath.indexOf('.') == -1)
            return false;
        var ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();
    } else {
        var ext = extention.toLowerCase();
    }

    validExtensions[0] = 'jpg';
    validExtensions[1] = 'jpeg';
    validExtensions[2] = 'bmp';
    validExtensions[3] = 'png';
    validExtensions[4] = 'gif';
    validExtensions[5] = 'tif';
    validExtensions[6] = 'tiff';

    for (var i = 0; i < validExtensions.length; i++) {
        if (ext == validExtensions[i])
            return true;
    }

    RaiseWarningAlert('The file extension ' + ext.toUpperCase() + ' is not allowed!');
    return false;
}

function checkNotAllowedFileExtension(elem, extention) {
    var validExtensions = new Array();
    if (elem != null) {
        var filePath = elem.value;
        if (filePath.indexOf('.') == -1)
            return false;
        var ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();
    } else {
        var ext = extention.toLowerCase();
    }

    validExtensions[0] = 'exe';
    validExtensions[1] = 'com';
    validExtensions[2] = 'bat';
    validExtensions[3] = 'js';
    validExtensions[4] = 'sys';
    validExtensions[5] = 'vb';
    validExtensions[6] = 'vbs';
    validExtensions[7] = 'dll';
    validExtensions[8] = 'zip';
    validExtensions[9] = 'vbe';
    validExtensions[10] = 'rar';
    validExtensions[11] = 'cmd';
    validExtensions[12] = 'drv';
    validExtensions[13] = 'jse';
    validExtensions[14] = 'msi';
    validExtensions[15] = 'obj';
    validExtensions[16] = 'ocx';
    validExtensions[17] = 'reg';

    for (var i = 0; i < validExtensions.length; i++) {
        if (ext == validExtensions[i]) {
            RaiseWarningAlert('The file extension ' + ext.toUpperCase() + ' is not allowed!');
            return false;
        }
    }

    return true;
}

function arrayToCSV(arr) {
    var columnNames = [];
    var rows = [];
    for (var i = 0, len = arr.length; i < len; i++) {
        // Each obj represents a row in the table
        var obj = arr[i];
        // row will collect data from obj
        var row = [];
        for (var key in obj) {
            // Don't iterate through prototype stuff
            if (!obj.hasOwnProperty(key)) continue;
            // Collect the column names only once
            if (i === 0) columnNames.push(prepareValueForCSV(key));
            // Collect the data
            row.push(prepareValueForCSV(obj[key]));
        }
        // Push each row to the main collection as csv string
        rows.push(row.join(','));
    }
    // Put the columnNames at the beginning of all the rows
    rows.unshift(columnNames.join(','));
    // Return the csv string
    return rows.join('\n');
}

// This function allows us to have commas, line breaks, and double 
// quotes in our value without breaking CSV format.
function prepareValueForCSV(val) {
    val = '' + val;
    // Escape quotes to avoid ending the value prematurely.
    val = val.replace(/"/g, '""');
    return '"' + val + '"';
};
function colourNameToHex(colour) {
    var colours = { "aliceblue": "f0f8ff", "antiquewhite": "faebd7", "aqua": "00ffff", "aquamarine": "7fffd4", "azure": "f0ffff",
        "beige": "f5f5dc", "bisque": "ffe4c4", "black": "000000", "blanchedalmond": "ffebcd", "blue": "0000ff", "blueviolet": "8a2be2", "brown": "a52a2a", "burlywood": "deb887",
        "cadetblue": "5f9ea0", "chartreuse": "7fff00", "chocolate": "d2691e", "coral": "ff7f50", "cornflowerblue": "6495ed", "cornsilk": "fff8dc", "crimson": "dc143c", "cyan": "00ffff",
        "darkblue": "00008b", "darkcyan": "008b8b", "darkgoldenrod": "b8860b", "darkgray": "a9a9a9", "darkgreen": "006400", "darkkhaki": "bdb76b", "darkmagenta": "8b008b", "darkolivegreen": "556b2f",
        "darkorange": "ff8c00", "darkorchid": "9932cc", "darkred": "8b0000", "darksalmon": "e9967a", "darkseagreen": "8fbc8f", "darkslateblue": "483d8b", "darkslategray": "2f4f4f", "darkturquoise": "00ced1",
        "darkviolet": "9400d3", "deeppink": "ff1493", "deepskyblue": "00bfff", "dimgray": "696969", "dodgerblue": "1e90ff",
        "firebrick": "b22222", "floralwhite": "fffaf0", "forestgreen": "228b22", "fuchsia": "ff00ff",
        "gainsboro": "dcdcdc", "ghostwhite": "f8f8ff", "gold": "ffd700", "goldenrod": "daa520", "gray": "808080", "green": "008000", "greenyellow": "adff2f",
        "honeydew": "f0fff0", "hotpink": "ff69b4",
        "indianred ": "cd5c5c", "indigo ": "4b0082", "ivory": "fffff0", "khaki": "f0e68c",
        "lavender": "e6e6fa", "lavenderblush": "fff0f5", "lawngreen": "7cfc00", "lemonchiffon": "fffacd", "lightblue": "add8e6", "lightcoral": "f08080", "lightcyan": "e0ffff", "lightgoldenrodyellow": "fafad2",
        "lightgrey": "d3d3d3", "lightgreen": "90ee90", "lightpink": "ffb6c1", "lightsalmon": "ffa07a", "lightseagreen": "20b2aa", "lightskyblue": "87cefa", "lightslategray": "778899", "lightsteelblue": "b0c4de",
        "lightyellow": "ffffe0", "lime": "00ff00", "limegreen": "32cd32", "linen": "faf0e6",
        "magenta": "ff00ff", "maroon": "800000", "mediumaquamarine": "66cdaa", "mediumblue": "0000cd", "mediumorchid": "ba55d3", "mediumpurple": "9370d8", "mediumseagreen": "3cb371", "mediumslateblue": "7b68ee",
        "mediumspringgreen": "00fa9a", "mediumturquoise": "48d1cc", "mediumvioletred": "c71585", "midnightblue": "191970", "mintcream": "f5fffa", "mistyrose": "ffe4e1", "moccasin": "ffe4b5",
        "navajowhite": "ffdead", "navy": "000080",
        "oldlace": "fdf5e6", "olive": "808000", "olivedrab": "6b8e23", "orange": "ffa500", "orangered": "ff4500", "orchid": "da70d6",
        "palegoldenrod": "eee8aa", "palegreen": "98fb98", "paleturquoise": "afeeee", "palevioletred": "d87093", "papayawhip": "ffefd5", "peachpuff": "ffdab9", "peru": "cd853f", "pink": "ffc0cb", "plum": "dda0dd", "powderblue": "b0e0e6", "purple": "800080",
        "red": "ff0000", "rosybrown": "bc8f8f", "royalblue": "4169e1",
        "saddlebrown": "8b4513", "salmon": "fa8072", "sandybrown": "f4a460", "seagreen": "2e8b57", "seashell": "fff5ee", "sienna": "a0522d", "silver": "c0c0c0", "skyblue": "87ceeb", "slateblue": "6a5acd", "slategray": "708090", "snow": "fffafa", "springgreen": "00ff7f", "steelblue": "4682b4",
        "tan": "d2b48c", "teal": "008080", "thistle": "d8bfd8", "tomato": "ff6347", "turquoise": "40e0d0",
        "violet": "ee82ee",
        "wheat": "f5deb3", "white": "ffffff", "whitesmoke": "f5f5f5",
        "yellow": "ffff00", "yellowgreen": "9acd32"
    };
    if (colour != undefined) {
        if (typeof colours[colour.toLowerCase()] != 'undefined')
            return colours[colour.toLowerCase()];
    }
    return false;
}
function hexInvert(hex) {
    //    var r = hex.substr(0, 2);
    //    var g = hex.substr(2, 2);
    //    var b = hex.substr(4, 2);

    //return (0.212671 * parseInt(r) + 0.715160 * parseInt(g) + 0.072169 * parseInt(b)) <= 0.5 ? '000000' : 'ffffff'
    if (hex.toLowerCase() == 'ffffff' || hex.toLowerCase() == '00ffff' || hex.toLowerCase() == 'ffff00') return '000000';
    else return 'ffffff';
};


