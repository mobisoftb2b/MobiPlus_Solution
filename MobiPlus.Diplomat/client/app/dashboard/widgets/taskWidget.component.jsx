import React from 'react';
import { connect } from 'react-redux';
import WidgetRun from './widget.component.run'
import {Grid, Col, Row } from 'react-bootstrap';
import { fetchTaskWidgets } from '../../../redux/actions/widget';
import Classnames from 'classnames';
import ContentWrapper from '../../../share/components/Layout/ContentWrapper';
import * as CONST from '../../../share/components/Common/constants';
import windowSize from 'react-window-size';


class TaskWidget extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchTaskWidgets(this.props.filter));
    }
    componentDidUpdate() {
        let radialSize = CONST.defaultRadialChartSize;
        if (this.props.windowWidth <= 1366)
            radialSize = CONST.radialChartSize;
        let params = this.props.taskWidget || {};
        params.RadialChartSize = radialSize;
        params.Element = '#easypie6';
        WidgetRun(params);
    }
    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchTaskWidgets(this.props.filter));
            //console.log("TaskWidget componentWillReceiveProps");
            this.setState({filter:nextProps.filter });
        }
    }

    renderWidget() {
        let local = this.props.local.widget.titles;
        let wd = this.props.taskWidget || {};
        let mainBgColor = Classnames({ [`panel widget ${wd.BGColor == undefined?'bg-gray-light':wd.BGColor }`]: true });
        let subBgColor = Classnames({ [`text-center ${wd.SubBgColor == undefined? 'bg-gray': wd.SubBgColor} pv-lg`]: true }); 
        let percent = `${wd.Percent == undefined? 0: wd.Percent}%`;
        let percentNum = wd.Percent == undefined? 0: wd.Percent;
        let title = local.Tasks; // wd.Title == undefined? '' : wd.Title;
        let plan = wd.Plan == undefined? 0 : wd.Plan;
        let done = wd.Done == undefined? 0 : wd.Done;
        let planDone = wd.PlanDone;
        let dirStyle = Classnames({ [`text-uppercase ${this.props.local.langSettings.shortLang=='he'?'widgetDirR':'widgetDirL'}`]: true });
        return (
            <ContentWrapper>
                <Grid fluid={true}>
                        <Row>
                            <Col>
                                <div className={mainBgColor}>
                                    <Row className="row-table">
                                        <Col xs={ 8 }>
                                            <Row>
                                                <Col className="pt pl text-left text-sm">
                                                    {title}
                                                </Col>
                                            </Row>
                                            <Row>
                                                <Col className="pv text-sm text-center">
                                                    <div className={dirStyle}>{planDone}</div>
                                                </Col>
                                            </Row> 
                                        </Col>
                                        <Col xs={ 5 } className={subBgColor}>
                                            <div id="easypie6" data-percent={percentNum} className="easypie-chart text-center">
                                                <span className="center-percent text-center">{percent}</span>
                                            </div>
                                        </Col>
                                    </Row>
                                </div>
                            </Col>
                        </Row>
                    </Grid>
                </ContentWrapper>);
                        }

    render() {
        return (<div>{this.renderWidget()}</div>);
       
    }
}

function mapStateToProps(state, action) {
    return {
        taskWidget: state.dashboard.taskWidget,
        local: state.local,
        filter: state.filter
    };
}

export default windowSize(connect(mapStateToProps)(TaskWidget));


