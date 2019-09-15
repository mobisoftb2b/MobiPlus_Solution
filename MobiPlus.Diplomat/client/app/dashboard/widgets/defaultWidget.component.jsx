import React from 'react';
import { connect } from 'react-redux';
import {Grid, Col, Row, Panel, Button, Image } from 'react-bootstrap';
import { fetchDefaultWidgets } from '../../../redux/actions/widget';
import Classnames from 'classnames';
import ContentWrapper from '../../../share/components/Layout/ContentWrapper';




class DefaultWidgets extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchDefaultWidgets(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchDefaultWidgets(this.props.filter));
            this.setState({filter:nextProps.filter });
        }
    }

    renderWidget() {
        if (this.props.widget) {
            let wd = this.props.widget;
            let mainBgColor = Classnames({ [`panel widget ${wd.BGColor}`]: true });
            let subBgColor = Classnames({ [`text-center ${wd.SubBgColor} pv-lg`]: true });
            let iconName = Classnames({ [`${wd.IconName} fa-3x `]: true });
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
                                                    <div className="h2 mt0">{wd.Value}</div>
                                                    <div className="text-uppercase">{wd.LowerText}</div>
                                                </Col>
                                                
                                            </Row>
                                            
                                        </Col>
                                        <Col xs={ 5 } className={subBgColor}>
                                            <em className={iconName}></em>
                                        </Col>
                                    </Row>
                                </div>
                            </Col>
                        </Row>
                    </Grid>
                </ContentWrapper>
            );
    } else
        return '';
   
    }

render() {
        return (<div>{this.renderWidget()}</div>);
    }

}

function mapStateToProps(state,action) {
    return {
        widget: state.dashboard.widget,
        local: state.local,
        filterData: state.filterData,
        filter: state.filter
    };
}

export default (connect(mapStateToProps)(DefaultWidgets));

