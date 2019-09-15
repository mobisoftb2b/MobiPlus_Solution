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

    componentDidMount() {
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

    renderWidget() {
        if (this.props.radwidget) {
            let wd = this.props.radwidget;

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
                                            <div id="easypie4" data-percent={wd.Percent} className="easypie-chart text-center">
                                                <span className="center-percent text-center">{percent}</span>
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
        radwidget: state.dashboard.radwidget,
        local: state.local,
        filter: state.filter
    };
}

export default windowSize(connect(mapStateToProps)(RadialWidget));


