import React from 'react';
import { connect } from 'react-redux';
import {Grid, Col, Row } from 'react-bootstrap';
import { fetchNonVisitWidgets } from '../../../redux/actions/widget';
import Classnames from 'classnames';
import WidgetWrapper from '../../../share/components/Layout/WidgetWrapper';
import windowSize from 'react-window-size';


class NotVisitedWidget extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchNonVisitWidgets(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchNonVisitWidgets(this.props.filter));
            this.setState({filter:nextProps.filter });
        }
    }

    renderWidget() {
        let local = this.props.local.widget.titles;
        let wd = this.props.nonvisitWidget || {};
        let mainBgColor = Classnames({ [`panel widget ${wd.BGColor == undefined?'bg-gray-light':wd.BGColor }`]: true });
        let subBgColor = Classnames({ [`text-center ${wd.SubBgColor == undefined? 'bg-gray': wd.SubBgColor} pv-lg`]: true });
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
                                                <Col className="pv text-sm text-center">
                                                    {local.Unvisited}
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
    }

    render() {
        return (<div>{this.renderWidget()}</div>);
       
    }
}

function mapStateToProps(state, action) {
    return {
        nonvisitWidget: state.dashboard.nonvisitWidget,
        local: state.local,
        filter: state.filter
    };
}

export default windowSize(connect(mapStateToProps)(NotVisitedWidget));


