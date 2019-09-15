import React, {Component} from 'react';   
import { connect } from 'react-redux';
import { fetchWidget } from '../../../redux/actions/widget';
import DefaultWidgets from './defaultWidget.component';
import RadialWidget from './radialWidget.component';

const COMPONENTS = {
    '1': DefaultWidgets,
    '2': RadialWidget
}


class WidgetContainer extends Component {
    constructor(props, context) {
        super(props, context);
    }

    renderWidget() {
        let rep = this.props.reportsData || {};     
        let widgetName = rep.Report.ReportTemplate;
        let widgetData = this.props.reportsData.Report.Widgets;
        

        switch (widgetName) {
            case "DefaultWidgets":
                return <div><DefaultWidgets key={rep.Report.ReportID} reportsData={widgetData}/></div>;
            case "RadialWidget"  :
                return <div><RadialWidget key={rep.Report.ReportID} reportsData={widgetData} /></div>;
            
            default:
        } 

    }

    render() {
        return <div>{this.renderWidget()}</div>;
        //let Component = COMPONENTS[type];
        //return (
        //    <Component { ...props }>
        //        { children }
        //    </Component>);
        //        }
    }
}   

export default (WidgetContainer)

