import React, { Component } from 'react';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import DriverReportComponent from './driverReport.component';
import DriverReportNoTarget from './driverReportNoTarget.component';


export default class DriverReportContainer extends Component {
    constructor(props) {
        super(props);
    }


    render() {
        return (
            <Grid fluid>
                <Row>
                    <Col lg={7}>
                        <DriverReportComponent />
                    </Col>
                    <Col lg={5}>
                        <DriverReportNoTarget />
                    </Col>
                </Row>
            </Grid>
        )

    }

};