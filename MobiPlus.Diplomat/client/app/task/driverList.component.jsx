import React, { Component } from 'react';
import { connect } from 'react-redux';
import { List, ListItem, makeSelectable } from 'material-ui/List';
import { fetchAgentListData } from '../../redux/actions/tasks';
import {changeFilter} from '../../redux/actions/filter';

let SelectableList = makeSelectable(List);

const style = {
    height: '600px',
    overflow: 'auto'
}
class DriverList extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter,
            selectedIndex:1 
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchAgentListData(this.props.filter));
    }

    handleChange = (event, index) => {
        let filter = this.props.filter || {};
        filter.AgentID = index;
        filter.AgentName = event.target.textContent;
        this.setState({
            filter: filter,
            selectedIndex: index,
        });
        
        this.props.handleRequestChange(event, index);
        this.props.dispatch(changeFilter(filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchAgentListData(nextProps.filter));            
            this.setState({ 
                filter: nextProps.filter,
                selectedIndex:this.props.filter.AgentID
            });
        }
    }

    renderAgentLst() {
        const agentList = this.props.agentList || [];
        return (
            agentList.map(a =>
                <ListItem key={a.DriverID} value={a.DriverID} primaryText={a.DriverName} />
            ));
    }

    render() {
        return (
            <SelectableList value={this.state.selectedIndex} style={style} onChange={this.handleChange}>
                {this.renderAgentLst()}
            </SelectableList>
        );
    }
}

const mapStateToProps = (state) => ({
    local: state.local,
    filter: state.filter,
    agentList: state.tasks.agentList,
    user: state.auth.user
});

export default connect(mapStateToProps)(DriverList);

