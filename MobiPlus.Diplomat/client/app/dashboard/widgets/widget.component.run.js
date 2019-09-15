/// <reference path="" />
import * as CONST from '../../../share/components/Common/constants';
import PanelTools from '../../../share/components/Common/panel-tools';


export default (chartParams) => {

    if (!$.fn.easyPieChart) return;
    if (!$.fn.knob) return;
    var pieOptions4 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: chartParams.ChartColor == undefined? CONST.APP_COLORS['primary']:CONST.APP_COLORS[chartParams.ChartColor],
        trackColor: chartParams.TrackColor == undefined? CONST.APP_COLORS['primary-light'] : CONST.APP_COLORS[chartParams.TrackColor],
        scaleColor: false,
        lineWidth: 9,
        size:chartParams.RadialChartSize || 55,
        lineCap: 'circle'
    };
    $('#easypie3, #easypie4, #easypie5, #easypie6, #easypieAgentReturn').easyPieChart(pieOptions4);
    try {
        if(chartParams.Element)
            $(chartParams.Element).data('easyPieChart').update(chartParams.Percent);
    } catch (e) {
        console.log(e.message);
    }


    ///===================== Panel settings =====================

    $('.panel.panel-demo')
      .on('panel.refresh', function(e, panel) {
          setTimeout(function() {
              panel.removeSpinner();             
          }, 1000);

      })
      .on('hide.bs.collapse', function(event) {
          console.log('Panel Collapse Hide');
      })
      .on('show.bs.collapse', function(event) {
          console.log('Panel Collapse Show');
      })
      .on('panel.remove', function(event, panel, deferred) {
          console.log('Removing panel');
          deferred.resolve();
      })
      .on('panel.removed', function(event, panel) {

          console.log('Removed panel');

      });

   

}
