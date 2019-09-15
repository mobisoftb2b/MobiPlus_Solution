<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LittleGauge.aspx.cs" Inherits="PQ.Admin.Presentation.Gauge.LittleGauge" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <title></title>
    <script src="/opeReady/Resources/Scripts/Common/jquery-1.5.2.js" type="text/javascript"></script>
    <script src="/opeReady/Resources/Scripts/Common/jquery.common.js" type="text/javascript"></script>
    <script src="/opeReady/Resources/Scripts/Common/jquery.gauges.js" type="text/javascript"></script>
    <script src="/opeReady/Resources/Scripts/Common/jquery.blockUI.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="content">
            <div class="div_wrapper">
                <div id="waitplease" style="display: none">
                    <img src="<%= this.ResolveClientUrl("~/Resources/images/waitPlease.gif") %>" alt="" />
                    <asp:Label ID="lblWaitPls" Style="vertical-align: super;" runat="server" Text="<%$ Resources:Employee, lblWaitPls %>"></asp:Label>
                </div>
                <div id="gaugeDiv" style="width: 120px; height: 120px; vertical-align: middle">
                </div>
            </div>
        </div>
        <div id="divBg">
        </div>
        <script type="text/javascript" language="javascript">
            var speedGauge;
            var grades = 0;
            var time = 0;
            var intervalID;
            $("#waitplease").css({ 'display': 'block' });
            $(document).ready(function (e) {
                var qParam = getArgs();
                if (qParam.gg) {
                    grades = parseInt(qParam.gg);
                    speedGauge = bindows.loadGaugeIntoDiv('<%= this.ResolveClientUrl("~/Resources/XSLT/LittleReadinessLevel.xml") %>', "gaugeDiv");
                    setTimeout(SetGauge, 50);
                }
            });

            function SetGauge() {
                var ts = [0, 3, 0.8, 4, 1, 5, 1, 5, 1, 10];
                var rs = [0, 1500, 1200, 2500, 2000, 3000, 2500, 3500, 3000, 2200];
                var vs = [0, grades, grades - 5, grades + 5, grades - 3, grades + 3, grades - 2, grades + 2, grades - 1, grades];

                var i = 0;
                var t, t_ms = 0;
                var interval = 100;
                var dt = interval / 1000;
                var speed = 0;
                var rpm = 0;
                var gas = 100;
                var next_t = 0;

                var intId;
                function update() {
                    if (gas <= 0)
                        return;

                    t_ms += interval;
                    t = t_ms / 1000;

                    if (t > next_t) {
                        i++;
                        next_t += ts[i];
                    }

                    if (i < ts.length) {
                        var t0 = ts[i];
                        var dr = rs[i] - rs[i - 1];
                        var tt = t - (next_t - ts[i]);

                        var k0 = t0 / 2;
                        var k1 = 3 * dr / 2 / t0;
                        var rv = k1 * (1 - (tt - k0) * (tt - k0) / k0 / k0);

                        rpm += rv * dt;

                        var dv = vs[i] - vs[i - 1];
                        speed += dv / t0 * dt;

                    } else {
                        clearInterval(intId);
                        return;

                        rpm = speed = i = t_ms = next_t = 0;
                    }
                    gas -= 100 * dt / 90;

                    speedGauge.needle.setValue(speed);
                    speedGauge.label.setText(" " + Math.round(grades));
                }
                intId = setInterval(update, interval);
                $("#waitplease").css({ 'display': 'none' });
            };
        </script>
    </div>
    </form>
</body>
</html>
