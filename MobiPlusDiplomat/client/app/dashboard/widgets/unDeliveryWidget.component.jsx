import React from 'react';
import { connect } from 'react-redux';
import WidgetRun from './widget.component.run'
import {Grid, Col, Row } from 'react-bootstrap';
import { fetchDefaultWidgets } from '../../../redux/actions/widget';
import Classnames from 'classnames';
import WidgetWrapper from '../../../share/components/Layout/WidgetWrapper';
import * as CONST from '../../../share/components/Common/constants';
import windowSize from 'react-window-size';


class NotFullDeliveryWidget extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchDefaultWidgets(this.props.filter));
    }

    componentDidUpdate() {
        let radialSize = CONST.defaultRadialChartSize;
        if (this.props.windowWidth <= 1366)
            radialSize = CONST.radialChartSize;
        let params = this.props.notFullDelivery || {};
        params.RadialChartSize = radialSize;
        WidgetRun(params);
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchDefaultWidgets(this.props.filter));
            //console.log("NotFullDeliveryWidget componentWillReceiveProps");
            this.setState({filter:nextProps.filter });
        }
    }

    renderWidget() {
        if (this.props.notFullDelivery) {
            let wd = this.props.notFullDelivery;
            let mainBgColor = Classnames({ [`panel widget ${wd.BGColor}`]: true });
            let subBgColor = Classnames({ [`text-center ${wd.SubBgColor} pv-lg`]: true });
            let iconName = Classnames({ [`${wd.IconName} fa-3x `]: true });
            return (
                <WidgetWrapper>
                    <Grid fluid={true}>
                        <Row>
                            <Col>
                                <div className={mainBgColor}>
                                    <Row className="row-table">
                                        <Col>
                                            <Row>
                                                <Col className="pv pl text-sm text-center">
                                                    {wd.UpperText}
                                                </Col>
                                            </Row>
                                            <Row>
                                                <Col className="pv-sm text-sm text-center">
                                                    <div className="text-uppercase">{wd.Title}</div>
                                                </Col>
                                            </Row>
                                        </Col>
                                    </Row>
                                </div>
                            </Col>
                        </Row>
                    </Grid>
                </WidgetWrapper>
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
        notFullDelivery: state.dashboard.widget,
        local: state.local,
        filter: state.filter
    };
}

export default windowSize(connect(mapStateToProps)(NotFullDeliveryWidget));


