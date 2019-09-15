import moment from 'moment';
import localHe from '../../server/i18n/site-he.json';
import localEn from '../../server/i18n/site-en.json';
import localGr from '../../server/i18n/site-gr.json';
import Cookies from 'universal-cookie';
import * as LangTypes from './constants';


export function GetLanguage (initFilter ){
    let localBase;
    if (!initFilter) initFilter = {};
    const cookies = new Cookies();
    let lang = cookies.get(LangTypes.language);
    initFilter.FromDate = moment().format('YYYYMMDD');
    switch (lang) {
        case 'he':
            initFilter.LanguageID = 1;
            localBase = localHe;
            break;
        case 'en':
            initFilter.LanguageID = 2;
            localBase = localEn;
            break;
        case 'gr':
            initFilter.LanguageID = 3;
            localBase = localGr;
            break;
        default :
            initFilter.LanguageID = 1;
            localBase = localHe;
            break;
    }
    return localBase;
};