import React from 'react';
import {Grid, Col, Row, Panel, Button, Image } from 'react-bootstrap';
import Classnames from 'classnames';



class DefaultWidgets extends React.Component {

    constructor(props) {
        super(props);
    }
  

    renderWidget() {
        if (this.props.reportsData) {  
            let wd = this.props.reportsData.length > 0 ? this.props.reportsData[0] : this.props.reportsData;
            let mainBgColor = Classnames({ [`panel widget ${wd.BGColor}`]: true });
            let subBgColor = Classnames({ [`text-center ${wd.SubBgColor} pv-lg`]: true });
            let iconName = Classnames({ [`${wd.IconName} fa-3x `]: true });
            let percent = `${wd.Value}%`;
            return (
                <Grid fluid={true}>
                    <Row>
                        <Col>
                            <div className={mainBgColor}>
                                <Row className="row-table">
                                    <Col xs={ 4 } className={subBgColor}>
                                        <em className={iconName}></em>
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
    } else
        return '';
   
    }

render() {
        return (<div>{this.renderWidget()}</div>);
    }

}


export default (DefaultWidgets);
