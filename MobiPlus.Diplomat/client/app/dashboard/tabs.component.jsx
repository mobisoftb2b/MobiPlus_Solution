import React, { Component } from 'react';
import { Grid, Row, Col, Tab, Tabs  } from 'react-bootstrap';
import { connect } from 'react-redux';


class TabsComponent extends Component{
    constructor(props, context){
        super(props, context);
    }

    renderTabs(){
        return (
           <Col md={12}>
               <Row>
                   <Tabs activeKey={ this.state.key } onSelect={this.handleSelect.bind(this)} justified id="tabID">
               { this.createTabs() }
                   </Tabs>
                   </Row>
               </Col>
         );
               }
    createTabs(){
        let layout = this.props.layoutData|| [];
        if(layout.length>0){
            return (
               layout.map(d=>  
                   <Tab eventKey={ d.layoutData.Tabs.TabID} title={d.layoutData.Tabs.TabDescription} ></Tab>
             ));
    }else{
        return '';
    }
    }

    componentDidMount(){
        this.props.dispatch(fetchLayout(this.state.filter));
    }

    render(){
        return (
    <div>
    </div>
    );
    }

}

TabsComponent.propTypes = {};

function mapStateToProps(state,action) {
    return {
        local: state.local,
        layoutData: state.layoutData
    };
}

export default connect(mapStateToProps)(TabsComponent);