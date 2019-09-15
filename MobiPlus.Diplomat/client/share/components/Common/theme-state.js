// Theme STATE
// -----------------------------------

const STORAGE_KEY_NAME = 'jq-themeState';
const STORAGE_ELEM_NAME = 'jq-elemState';
const SELECTED_THEME = 'defaultChecked';

// Helper object to check for words in a phrase //
class WordChecker {
    static hasWord(phrase, word) {
        return new RegExp('(^|\\s)' + word + '(\\s|$)').test(phrase);
    }
    static addWord(phrase, word) {
        if (!this.hasWord(phrase, word)) {
            return (phrase + (phrase ? ' ' : '') + word);
        }
    }
    static removeWord(phrase, word) {
        if (this.hasWord(phrase, word)) {
            return phrase.replace(new RegExp('(^|\\s)*' + word + '(\\s|$)*', 'g'), '');
        }
    }
};

// Handle states to/from localstorage
class ThemeStateSaver {

    // Add a state to the browser storage to be restored later
    addState(elem, classname) {
        var data = $.localStorage.get(STORAGE_KEY_NAME);
        if (!data) {
            data = classname;
        }
        let id = $(elem).prop('id');
        $.localStorage.set(STORAGE_KEY_NAME, data);
        $.localStorage.set(STORAGE_ELEM_NAME, id);
    }

    // Remove a state from the browser storage
    removeState(classname) {
        var data = $.localStorage.get(STORAGE_KEY_NAME);
        // nothing to remove
        if (!data) return; 
        data = WordChecker.removeWord(data, classname);
        $.localStorage.set(STORAGE_KEY_NAME, data);
    }

    restoreState($elem) {
        var data = $.localStorage.get(STORAGE_KEY_NAME);
        var id = $.localStorage.get(STORAGE_ELEM_NAME);
        if (!data) return;
        $elem.addClass(data);
        if ($($elem).prop('id') == id)
            $elem.prop("checked", true);
    }
}

function initThemeState() {
    var element = $(this);
    var $body = $('body');
    var toggle = new ThemeStateSaver();
    toggle.restoreState(element);

    element
        .on('click', function(e) {
            // e.stopPropagation();
            if (this.tagName === 'A') e.preventDefault();
            
            var element = $(this); 

            if (element.attr(SELECTED_THEME)!=undefined) {
                element.removeAttr(SELECTED_THEME);
                toggle.removeState(element);
            } else {
                element.addClass(SELECTED_THEME);
                toggle.addState(element,SELECTED_THEME);
            }

            $(window).resize();

        });

}

export default () => {

    $('[data-theme-state]').each(initThemeState);

}