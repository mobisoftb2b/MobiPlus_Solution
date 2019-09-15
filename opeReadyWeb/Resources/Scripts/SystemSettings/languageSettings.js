var language = {};

language.UpdateSystemSetting = function (params) {
    PQ.Admin.WebService.SystemSettingsService.UpdateSystemSetting(params,
            function (data) {
                $.cookie("dateFormat", params.DateCode, { expires: 365, path: '/' });
            }, function (ex) {
                return false;
            });
    setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
    return false;
};