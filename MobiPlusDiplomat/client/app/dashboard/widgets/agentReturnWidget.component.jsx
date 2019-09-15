import React from 'react';
import { connect } from 'react-redux';
import WidgetRun from './widget.component.run'
import {Grid, Col, Row } from 'react-bootstrap';
import { fetchAgentReturnWidgets } from '../../../redux/actions/widget';
import Classnames from 'classnames';
import ContentWrapper from '../../../share/components/Layout/ContentWrapper';
import * as CONST from '../../../share/components/Common/constants';
import windowSize from 'react-window-size';


class AgentReturnWidget extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchAgentReturnWidgets(this.props.filter));
    }

    componentDidUpdate() {
        let radialSize = CONST.defaultRadialChartSize;
        if (this.props.windowWidth <= 1366)
            radialSize = CONST.radialChartSize;
        let params = this.props.agRetWidget || {};
        params.RadialChartSize = radialSize;
        params.Element = '#easypie5';
        WidgetRun(params);
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchAgentReturnWidgets(nextProps.filter));
           // console.log("AgentReturnWidget componentWillReceiveProps");
            this.setState({filter:nextProps.filter });
        }
    }

    renderWidget() {
        if (this.props.agRetWidget) {
            let wd = this.props.agRetWidget;
            let mainBgColor = Classnames({ [`panel widget ${wd.BGColor}`]: true });
            let subBgColor = Classnames({ [`text-center ${wd.SubBgColor} pv-lg`]: true });
            let percent = `${wd.Percent}%`;           
            return (
                <ContentWrapper>
                    <Grid fluid={true}>
                        <Row>
                            <Col>
                                <div className={mainBgColor}>
                                    <Row className="row-table">
                                        <Col xs={ 7 }>
                                            <Row>
                                                <Col className="pt pl text-left text-sm ">
                                                    {wd.Title}
                                                </Col>
                                            </Row>
                                            <Row>
                                                <Col className="pv text-sm text-center">
                                                    <div className="text-uppercase">{wd.Plan + ' | ' + wd.Done}</div>
                                                </Col>

                                            </Row>

                                        </Col>
                                        <Col xs={ 5 } className={subBgColor}>
                                            <div id="easypie5" data-percent={wd.Percent} className="easypie-chart">
                                                <span className="center-percent">{percent}</span>
                                            </div>
                                        </Col>
                                    </Row>
                                </div>
                            </Col>
                        </Row>
                    </Grid>
                </ContentWrapper>
            );
        } else {
            return '';
        }
    }

    render() {
        return (<div>{this.renderWidget()}</div>);
       
    }
}

function mapStateToProps(state, action) {
    return {
        agRetWidget: state.dashboard.agRetWidget,
        local: state.local,
        filter: state.filter
    };
}

export default windowSize(connect(mapStateToProps)(AgentReturnWidget));


