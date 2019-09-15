/// <reference path="" />
import * as CONST from '../../../share/components/Common/constants';
import PanelTools from '../../../share/components/Common/panel-tools';


export default (chartParams) => {

    if (!$.fn.easyPieChart) return;
    if (!$.fn.knob) return;
    

    // Knob
    var knobLoaderOptions1 = {
        width: '50%', // responsive
        displayInput: true,
        fgColor: CONST.APP_COLORS['info']
    };
    $('#knob-chart1').knob(knobLoaderOptions1);

    var knobLoaderOptions2 = {
        width: '50%', // responsive
        displayInput: true,
        fgColor: CONST.APP_COLORS['info'],
        readOnly: true
    };
    $('.knobChart').knob(knobLoaderOptions2);

    var knobLoaderOptions3 = {
        width: '50%', // responsive
        displayInput: true,
        fgColor: CONST.APP_COLORS['info'],
        bgColor: CONST.APP_COLORS['gray'],
        angleOffset: -125,
        angleArc: 250
    };
    $('#knob-chart3').knob(knobLoaderOptions3);

    var knobLoaderOptions4 = {
        width: '50%', // responsive
        displayInput: true,
        fgColor: CONST.APP_COLORS['pink'],
        displayPrevious: true,
        thickness: 0.1,
        lineCap: 'round'
    };
    $('#knob-chart4').knob(knobLoaderOptions4);

    // Easy pie
    var pieOptions1 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: CONST.APP_COLORS['success'],
        trackColor: CONST.APP_COLORS['green-light'],
        scaleColor: false,
        lineWidth: 15,
        lineCap: 'circle',
        size:75
    };
    $('#easypie1').easyPieChart(pieOptions1);

    var pieOptions2 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: CONST.APP_COLORS['warning'],
        trackColor: false,
        scaleColor: false,
        lineWidth: 4,
        lineCap: 'circle'
    };
    $('#easypie2').easyPieChart(pieOptions2);

    var pieOptions3 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: CONST.APP_COLORS['success'],
        trackColor: CONST.APP_COLORS['green'],
        scaleColor: false,
        thickness: 0.1,
        lineWidth: 15,
        lineCap: 'circle'
    };
    $('#easypie3').easyPieChart(pieOptions3);

    var pieOptions4 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: CONST.APP_COLORS[chartParams.ChartColor],
        trackColor: CONST.APP_COLORS[chartParams.TrackColor],
        scaleColor: false,
        lineWidth: 9,
        size:60,
        lineCap: 'circle'
    };
    $('#easypie4').easyPieChart(pieOptions4);

    // Classyloader

    $('[data-classyloader]').each(function() {
        $(this).ClassyLoader($(this).data());
    });



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