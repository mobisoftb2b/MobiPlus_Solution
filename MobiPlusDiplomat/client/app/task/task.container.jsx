﻿import React from 'react';
import { connect } from 'react-redux';
import { fetchCountry, fetchDistribution, fetchDrivers } from '../../redux/actions/cascade';
import { fetchAgentListData } from '../../redux/actions/tasks';
import { Grid, Row, Col, Dropdown, MenuItem, Panel } from 'react-bootstrap';
import ContentWrapper from '../../share/components/Layout/ContentWrapper';
import FilterDropdown from '../dashboard/filter.component';
import TasksGrid from './tasks.componemt';
import DriverList from './driverList.component';
import { changeFilter } from '../../redux/actions/filter';

const lgHidden = [
    'Distributions', 'Drivers'
];	


class TaskContainer extends React.Component {
    constructor(props){
        super(props);

    }
    
    componentDidMount() {
        this.props.dispatch(fetchCountry(this.props.filter));
        this.props.dispatch(fetchDistribution(this.props.filter));
    }

    handleRequestChange = (event, index) => {
        let filter = this.props.filter|| {};
        filter.AgentID = index;
        this.props.dispatch(changeFilter(filter));
      
    }

    renderFilter(){
        return (<FilterDropdown HiddenColName={lgHidden}  noCaret initFilterData={this.props.filterData}/>);
        }

    renderGrid(){
        return (
            <TasksGrid  />
            );
    }

    renderDriverList(){
        return (<DriverList handleRequestChange={this.handleRequestChange.bind(this)} />);
    }

    render() {
        return (
                <div>
                    <Grid fluid>
                       <ContentWrapper>
                            <Row>
                                <Col lg={3}>
                                    <Row>
                                        {this.renderFilter()}                                
                                    </Row>
                                </Col>
                                <Col lg={9}>
                                    
                                </Col>
                            </Row>
                            <Row>
                                <Col lg={2}>
                                    <Panel>
                                        {this.renderDriverList()}
                                    </Panel>
                                </Col>
                                <Col lg={10}>
                                    <Row>
                                        {this.renderGrid()}
                                    </Row>    
                                </Col>
                            </Row>
                     </ContentWrapper>
                 </Grid>
            </div>
        );
    }
}

function mapStateToProps(state,action) {
    return {
        local: state.local,
        filterData: state.filterData,
        agentList: state.tasks.agentList,
        filter: state.filter
    };
}

export default connect(mapStateToProps)(TaskContainer);

