import React, { Component, PropTypes } from 'react';
import { Grid, Row, Col, Dropdown, MenuItem, Panel, Tab, Tabs  } from 'react-bootstrap';
import { connect } from 'react-redux';
import { fetchWidget } from '../../redux/actions/widget';
import { fetchCountry, fetchDistribution, fetchDrivers } from '../../redux/actions/cascade';


import Widget from 'widgets/widget.component';
import JqGrid from './grids/grid.component';
import ContentWrapper from '../../share/components/Layout/ContentWrapper';
import FilterDropdown from './filter.component';


class DashboardContainer extends Component {
    constructor(props, context) {
        super(props, context);
        this.state = {
            key: 1
           
        };
    }
    handleSelect(key) {
        this.setState({
            key
        });
    }
    
    //componentWillReceiveProps(nextProps){
    //    console.log(this.props);
    //    console.log(nextProps);
    //}

    componentDidMount(){
        this.props.dispatch(fetchCountry());
        this.props.dispatch(fetchWidget()); 
      
    }
    
    renderFilter(){
        return (<div><FilterDropdown noCaret filterDataSet={this.props.filterData}/></div>);
        }

    renderGrid(){
        return (<div><JqGrid/></div>);
        }
  
    renderWidgets() {
        let widget = this.props.widget;
        let widg = [];
        if(widget) {
            for (var i = 0; i < Math.min(widget.length, 4); i++) 
                widg.push(<Widget key={i} widgetID={widget[i].WidgetID} title={widget[i].WidgetTitle} plan={widget[i].Plan} done={widget[i].Done} percent={widget[i].Percent} color={widget[i].ChartColor}/>);
        return (
          <div>{widg }</div>
        );
    } else {
        return '';
    }
    }

    render() {
        let local = this.props.local;
        return (
           <div>
            <ContentWrapper>
              <Tabs activeKey={ this.state.key } onSelect={ this.handleSelect.bind(this) } justified id="tabID">
                 <Tab eventKey={ 1 } title={ local.dashboard.tabs.MAIN }>
                     <Row>
                      <Col lg={ 4 }>{this.renderFilter() }</Col>                           
                     </Row>
                        <Row >
                            { this.renderWidgets() }
                        </Row>
                         <Row >
                             <Col md={ 9 } >{ this.renderGrid() }</Col>
                             <Col md={ 3 }></Col>
                        </Row>
                </Tab>
                 <Tab eventKey={ 2 } title={ local.dashboard.tabs.DRIVERACTION }>
                    <fieldset>
                        <div className="form-group">
                            <label className="col-md-2 control-label">Title</label>
                            <div className="col-md-10">
                                <input type="text" placeholder="Brief description.." className="form-control" />
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <div className="form-group">
                            <label className="col-md-2 control-label">Description</label>
                            <div className="col-md-10">
                                <textarea rows="5" placeholder="Max 255 characters..." className="form-control"></textarea>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <div className="form-group">
                            <label className="col-md-2 control-label">Keywords</label>
                            <div className="col-md-10">
                                <textarea rows="5" placeholder="Max 1000 characters..." className="form-control"></textarea>
                            </div>
                        </div>
                    </fieldset>
                </Tab>
                <Tab eventKey={ 3 } title={ local.dashboard.tabs.DRIVERSTATUS }>
                           
                </Tab>
                <Tab eventKey={ 4 } title={ local.dashboard.tabs.DRIVERSTATUS }>
                    <fieldset>
                        <div className="form-group">
                            <label className="col-md-2 control-label">Title</label>
                            <div className="col-md-10">
                                <input type="text" placeholder="Brief description.." className="form-control" />
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <div className="form-group">
                            <label className="col-md-2 control-label">Description</label>
                            <div className="col-md-10">
                                <textarea rows="5" placeholder="Max 255 characters..." className="form-control"></textarea>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <div className="form-group">
                            <label className="col-md-2 control-label">Keywords</label>
                            <div className="col-md-10">
                                <textarea rows="5" placeholder="Max 1000 characters..." className="form-control"></textarea>
                            </div>
                        </div>
                    </fieldset>   
                </Tab>
                <Tab eventKey={ 5 } title={ local.dashboard.tabs.ENDDAY }>
                
                </Tab>
             </Tabs>
             </ContentWrapper>
           </div>
        );
              }

}

DashboardContainer.propTypes = {
};

function mapStateToProps(state,action) {
    return {
        widget: state.dashboard.widget,
        local: state.local, 
        filterData: state.filterData 
    };
}

export default connect(mapStateToProps)(DashboardContainer);