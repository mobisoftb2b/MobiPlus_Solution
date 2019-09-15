var systemConfig = {
    LoadSystemConfig: function () {
        OpSemsService.LoadSystemConfig(
              function (data) {
                  if (data) {
                      $("#txtFilePath").val(data.FilePath);
                      $("#ddlImageFormat").val(data.ImageFormat);
                      $("#txtImageThreatRadius").val(data.ImageThreatRadius);
                      $("#txtImageThreatThickness").val(data.ImageThreaThickness);
                      $("#chkFullAirlineName").attr("checked", data.IsFullAirlineName);
                      $("#txtAlarmInterval").val(data.AlarmInterval);
                      $("#chkIsIATACode").attr("checked", data.IsIATACode);
                      $("#chkIsICAOCode").attr("checked", data.IsICAOCode);
                      $("#txtFilePathBackup").val(data.FilePathBackup);
                      $("#txtEditedFilePath").val(data.EditedFilePath);
                      setInterval(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
                  }
              },
            function (ex) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
    },
    UpdateSystemConfig: function (sysConfig) {
        if (sysConfig) {
            OpSemsService.UpdateSystemConfig(sysConfig,
              function (data) {
                  if (data) {
                      setInterval(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
                  }
              },
            function (ex) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
        }
    },
    RunArchive: function () {
       OpSemsService.RunArchive(function (data) {
            if (data) {
                setInterval(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
                RaiseDialogSuccessMessage($('#hidGS_CompleteMessage').text());
            }
        },
        function (ex) {
            $("#waitplease").css({ 'display': 'none' });
            return false;
        }, null);
    }
};