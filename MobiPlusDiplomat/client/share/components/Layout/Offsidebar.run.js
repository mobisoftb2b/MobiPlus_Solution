import initThemeState from '../Common/theme-state';
import * as LangTypes from '../Common/constants';
import Cookies from 'universal-cookie';

export default () => {

    initThemeState();

    var $body = $('body');
    $body.addClass('layout-fixed') ;
    // enable settings toggle
    $('#chk-fixed').prop('checked', $body.hasClass('layout-fixed') );
    $('#chk-collapsed').prop('checked', $body.hasClass('aside-collapsed') );
    $('#chk-collapsed-text').prop('checked', $body.hasClass('aside-collapsed-text') );
    $('#chk-boxed').prop('checked', $body.hasClass('layout-boxed') );
    $('#chk-float').prop('checked', $body.hasClass('aside-float') );
    $('#chk-hover').prop('checked', $body.hasClass('aside-hover') );

    // When ready display the offsidebar
    $('.offsidebar.hide').removeClass('hide');

   

}


