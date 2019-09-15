export function FilterComponentRun(colums, data) {
}

export  function activateDropdown(elem) {
    var menu = $(elem).parents('.dropdown-menu');
    if (menu.length) {
        var toggle = menu.prev('button, a');
        toggle.text($(elem).text());
    }
}
export function resetDropdown(elem, text) {
    elem.text(text);
}