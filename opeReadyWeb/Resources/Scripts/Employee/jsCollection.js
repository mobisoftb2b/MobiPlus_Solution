//This file should be used if you want to debug and develop
function jqGridInclude() {
    var pathtojsfiles = "/opeReady/Resources/Scripts/"; // need to be ajusted
    // set include to false if you do not want some modules to be included
    var modules = [
        { include: true, incfile: 'Common/jquery.tmpl.js' },
        { include: true, incfile: 'Common/jquery.jstree.js' },
        { include: true, incfile: 'Common/jquery.blockUI.js' },
        { include: true, incfile: 'Common/jquery.maskedinput-1.3.js' },
        { include: true, incfile: 'Common/jquery.ajax_upload.0.6.js' },
        { include: true, incfile: 'Common/jquery.waitforimages.js' }, 
        {include: true, incfile: 'Employee/employee.js' }, 
        {include: true, incfile: 'Employee/employmentHistory.js' }, 
        {include: true, incfile: 'Employee/unitsJobs.js' }, 
        {include: true, incfile: 'Employee/administrativeTasks.js' }, 
        {include: true, incfile: 'Employee/personAttachment.js' }, 
        {include: true, incfile: 'Employee/readinessInfo.js' }, 
        {include: true, incfile: 'Employee/perfomanceAnalisys.js' }, 
        {include: true, incfile: 'Employee/eventRecords.js' }
    ];
    var filename;
    for (var i = 0; i < modules.length; i++) {
        if (modules[i].include === true) {
            filename = pathtojsfiles + modules[i].incfile;
            if (jQuery.browser.safari) {
                jQuery.ajax({ url: filename, dataType: 'script', async: false, cache: true });
            } else {
                if (jQuery.browser.msie) {
                    document.write('<script charset="utf-8" type="text/javascript" src="' + filename + '"></script>');
                } else {
                    IncludeJavaScript(filename);
                }
            }
        }
    }
    function IncludeJavaScript(jsFile) {
        var oHead = document.getElementsByTagName('head')[0];
        var oScript = document.createElement('script');
        oScript.setAttribute('type', 'text/javascript');
        oScript.setAttribute('language', 'javascript');
        oScript.setAttribute('src', jsFile);
        oHead.appendChild(oScript);
    }
}
jqGridInclude();

//var pathtojsfiles = "/opeReady/Resources/Scripts/";
//$.include([
//            $.include(pathtojsfiles + 'Common/jquery.blockUI.js'),
//	        $.include(pathtojsfiles + 'Common/jquery.tmpl.js'),
//	        $.include(pathtojsfiles + 'Common/jquery.jstree.min.js'),
//            $.include(pathtojsfiles + 'Common/jquery.tmpl.js'),
//            $.include(pathtojsfiles + 'Common/jquery.maskedinput-1.3.js'),
//            $.include(pathtojsfiles + 'Common/jquery.ajax_upload.0.6.js'),
//            $.include(pathtojsfiles + 'Common/jquery.ajax_upload.0.6.js'),
//            $.include(pathtojsfiles + 'Common/jquery.waitforimages.js'),
//            $.include(pathtojsfiles + 'Employee/employee.js'),
//            $.include(pathtojsfiles + 'Employee/employmentHistory.js'),
//            $.include(pathtojsfiles + 'Employee/unitsJobs.js'),
//            $.include(pathtojsfiles + 'Employee/administrativeTasks.js'),
//            $.include(pathtojsfiles + 'Employee/personAttachment.js'),
//            $.include(pathtojsfiles + 'Employee/readinessInfo.js'),
//            $.include(pathtojsfiles + 'Employee/eventRecords.js'),
//            $.include(pathtojsfiles + 'Employee/perfomanceAnalisys.js')
//	    ]
//	);
