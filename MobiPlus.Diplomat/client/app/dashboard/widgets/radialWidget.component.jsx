import React from 'react';
import { connect } from 'react-redux';
import WidgetRun, {Update} from './widget.component.run'
import {Grid, Col, Row, Panel } from 'react-bootstrap';
import { fetchRadialWidgets } from '../../../redux/actions/widget';
import Classnames from 'classnames';
import * as CONST from '../../../share/components/Common/constants';
import ContentWrapper from '../../../share/components/Layout/ContentWrapper';
import windowSize from 'react-window-size';


class RadialWidget extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentWillMount() {
        this.props.dispatch(fetchRadialWidgets(this.props.filter));
    }

    componentDidUpdate(prevProps, prevState) {
        let radialSize = CONST.defaultRadialChartSize;
        if (this.props.windowWidth <= 1366)
            radialSize = CONST.radialChartSize;
        if(this.props.radwidget){
            let params = this.props.radwidget || {};
            params.RadialChartSize = radialSize;
            params.Element = '#easypie4';
            WidgetRun(params);
        }
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchRadialWidgets(this.props.filter));
            this.setState({filter:nextProps.filter });
        }
    }

    render() {
        let local = this.props.local.widget.titles;
        let wd = this.props.radwidget || {};
        let mainBgColor = Classnames({ [`panel widget ${wd.BGColor == undefined?'bg-gray-light':wd.BGColor }`]: true });
        let subBgColor = Classnames({ [`text-center ${wd.SubBgColor == undefined? 'bg-gray': wd.SubBgColor} pv-lg`]: true });
        let percent = `${wd.Percent == undefined? 0: wd.Percent}%`;
        let percentNum = wd.Percent == undefined? 0: wd.Percent;
        let title = local.Customers; //wd.Title == undefined? '' : wd.Title;
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
                                                <Col className="pt pl text-left text-sm ">
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
                                            <div id="easypie4" data-percent={percentNum} className="easypie-chart text-center">
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
}

function mapStateToProps(state, action) {
    return {
        radwidget: state.dashboard.radwidget,
        local: state.local,
        filter: state.filter
    };
}

export default windowSize(connect(mapStateToProps)(RadialWidget));


