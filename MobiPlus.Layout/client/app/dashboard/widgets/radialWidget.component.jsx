import React from 'react';
import {createStore } from 'redux';
import WidgetRun from './widget.component.run'
import {Grid, Col, Row, Panel, Button } from 'react-bootstrap';
import Classnames from 'classnames';



class RadialWidget extends React.Component {

    constructor(props) {
        super(props);
    }

    componentDidMount() {
        WidgetRun(this.props.reportsData);
    }
   
    render() {
        let wd = this.props.reportsData;
        let mainBgColor = Classnames({ [`panel widget ${wd.BGColor}`]: true });
        let subBgColor = Classnames({ [`text-center ${wd.SubBgColor} pv-lg`]: true });
        let percent = `${wd.Percent}%`;
        let classString = Classnames({[`radial-bar radial-bar-${wd.Percent} radial-bar ${wd.ChartColor} radial-bar-sm`]: true });
        return (
            <Grid fluid={true}>
                <Row>
                    <Col>
                        <div className={mainBgColor}>
                            <Row className="row-table">
                                <Col xs={ 4 } className={subBgColor}>
                                        <div id="easypie4" data-percent={wd.Percent} className="easypie-chart">
                                            <span className="center-percent">{percent}</span>
                                        </div>
                                </Col>
                                <Col xs={ 8 } className="pv-lg pb-xl text-center">
                                    <div className="h2 mt0">{wd.Value}</div>
                                    <div className="text-uppercase">{wd.LowerText}</div>
                                </Col>
                            </Row>
                        </div>
                    </Col>
                </Row>
            </Grid>

        );
                }
}


export default RadialWidget;
