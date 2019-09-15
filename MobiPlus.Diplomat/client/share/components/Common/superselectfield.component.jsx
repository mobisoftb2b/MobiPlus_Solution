import React, {Component} from 'react';
import {connect} from 'react-redux';
import {Grid, Row, Col} from 'react-bootstrap';
import SuperSelectField from './SuperSelectField';
import Chip from 'material-ui/Chip/Chip';
import { fetchDrivers } from '../../../redux/actions/cascade';
import { changeFilter } from '../../../redux/actions/filter';


const containerStyle = {
    padding: 40,
    paddingBottom: 0,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    flex: 1
}
const menuItemStyle = {
    whiteSpace: 'normal',
    display: 'flex',
    justifyContent: 'space-between',
    lineHeight: 'normal'
}

const displayState = state => state.length
    ? [...state].map(({value, label}) => label || value).join(', ')
    : 'empty state'

const dataSourceConfig = {
    text: 'textKey',
    value: 'valueKey',
};


class DriverSelectFilter extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter,
            searchText: this.props.filter.AgentName
        };
    }

    componentDidMount() {
        if (this.state.searchText != "") this.refs[`autocomplete`].state.searchText = this.state.searchText
        this.props.dispatch(fetchDrivers(this.props.filter));
    }


    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.refs[`autocomplete`].state.searchText = nextProps.filter.AgentName;
            this.setState({
                searchText: nextProps.AgentName,
                filter: nextProps.filter
            });
        }
    }

    renderDriver() {
        let driverData = this.props.filterData.driverData || [];
        return driverData.map(d => {
            return {
                textKey: d.DriverName,
                valueKey: d.DriverID
            }
        });
    }

    handleSelection = (values, name) => this.setState({searchText: values});

    onRequestDelete = (key, name) => event => {
        this.setState({[name]: this.state[name].filter((v, i) => i !== key)})
    }

    render() {
        let driverData = this.props.filterData.driverData || [];
        const { searchText } = this.state;
        const driversList = driverData.map((drivers, index) => {
            const driverID = drivers.DriverID
            const driverName = drivers.DriverName
            return (
                <div key={index} value={driverID} label={driverName} style={menuItemStyle}>
                    <div style={{marginRight: 10}}>
                        <span style={{fontWeight: 'bold'}}>{driverName}</span>
                    </div>
                </div>
            )
        });

        return  <div>
                        <SuperSelectField
                            name='driverList'
                            floatingLabel={this.props.floatingLabelText}
                            hintText={this.props.floatingLabelText}
                            onChange={this.handleSelection.bind(this)}
                            value={searchText}
                            elementHeight={100}
                            selectionsRenderer={this.handleCustomDisplaySelections('state31').bind(this)}
                            >
                            {driversList}
                        </SuperSelectField>
                    </div>
               
    }
}

function mapStateToProps(state, action) {
    return {
        local: state.local,
        user: state.auth.user,
        filter: state.filter,
        filterData: state.filterData
    };
}

export default connect(mapStateToProps)(DriverSelectFilter);
