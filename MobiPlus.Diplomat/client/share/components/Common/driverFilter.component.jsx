import React, {Component} from 'react';
import { Grid, Row, Col } from 'react-bootstrap';
import AutoComplete from 'material-ui/AutoComplete';
import FlatButton from 'material-ui/FlatButton';
import {ListItem} from 'material-ui/List';
import { connect } from 'react-redux';
import { fetchDrivers } from '../../../redux/actions/cascade';
import { changeFilter } from '../../../redux/actions/filter';
import ClearButton from 'material-ui/svg-icons/Content/clear';
import SvgIcon from 'material-ui/SvgIcon'
import moment from 'moment';
import {blue500, red500, greenA200} from 'material-ui/styles/colors';


const styles = { 
    customWidth: {
        width: 250
    }
};
const ClearIcon = (props) => (
  <SvgIcon {...props}>
    <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
  </SvgIcon>
);

const dataSourceConfig = {
    text: 'textKey',
    value: 'valueKey',
};

const iconStyles = {
    marginRight: 30    
};


const icon = <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"></svg>;

class DriverFilter extends Component{
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter,
            searchText: this.props.filter.AgentName,
            iconDisplay: 'none'
        };
    }

    componentDidMount(){
        if(this.state.searchText!="") this.refs[`autocomplete`].state.searchText = this.state.searchText
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
    
    handleNewRequest(chosenRequest, idx) {
        let filter = this.props.filter || {};
        filter.AgentID = chosenRequest.valueKey;
        filter.LanguageID = this.props.local.langSettings.langID;
        filter.AgentName = this.refs[`autocomplete`].state.searchText;
        this.setState({
            iconDisplay: 'block'
        })
        this.props.dispatch(changeFilter(filter));

    }

    handleOnClose(chosenRequest, idx) {
        let refs = this.refs[`autocomplete`].state.searchText;
        if(refs==""){
            let filter = this.props.filter || {};
            filter.AgentID = 0;
            filter.LanguageID = this.props.local.langSettings.langID;
            this.setState({ 
                searchText: this.refs[`autocomplete`].requestsList[0].text,
                iconDisplay: 'none'
            });
            this.props.dispatch(changeFilter(filter));
        }
    } 

    handleUpdateInput(text) {
        this.setState({ searchText: text,iconDisplay: 'block' });
    }

    handleClearClick(e) {
        let driverData = this.props.filterData.driverData || [];    
        let filter = this.props.filter || {};
        filter.AgentID = 0;
        filter.AgentName = '';
        this.setState({
            searchText: '',
            iconDisplay: 'none'
        });
        this.refs[`autocomplete`].state.searchText = '';
        this.props.dispatch(changeFilter(filter));
    }
  
    DriverSelectHandler(event, index, value) {
        if(event==""){
            let filter = this.props.filter || {};
            filter.AgentID = 0;
            filter.LanguageID = this.props.local.langSettings.langID;
            this.props.dispatch(changeFilter(filter));
        }
    }

    _filterFiles(searchText, key) {
        const compareString = key.toLowerCase()
        searchText = searchText.toLowerCase()

        let searchTextIndex = 0
        for (let index = 0; index < key.length; index++) {
            if (compareString[index] === searchText[searchTextIndex]) {
                searchTextIndex += 1
            }
        }        
        return searchTextIndex === searchText.length
    }

    filterResults = (searchText, key) => {                  
        const compareString = key.toLowerCase();
        searchText = searchText.toLowerCase();

        const subMatchKey = key.substring(0, searchText.length);
        const distance = AutoComplete.levenshteinDistance(searchText.toLowerCase(), subMatchKey.toLowerCase());
        let searchTextIndex = 0;
        for (let index = 0; index < key.length; index++) {
            if (compareString[index] === searchText[searchTextIndex]) {
                searchTextIndex += 1;
            }
        }

        return searchText.length > 3 ? distance < 2 : distance === 0;
        return searchTextIndex === searchText.length;
    }

    render(){
        const iconStyles={marginRight:'-35px', marginTop:'40px' };
        return  <Grid fluid>
                    <Row>
                         <Col lg={10}>
                            <AutoComplete
                                    ref={`autocomplete`}
                                    menuStyle = {{maxHeight:"500px",overflowY:'auto'}}
                                    floatingLabelText={this.props.floatingLabelText}
                                    filter={this.filterResults.bind(this)}
                                    style={styles.customWidth}
                                    openOnFocus={true}
                                    dataSource={this.renderDriver()}
                                    onNewRequest={this.handleNewRequest.bind(this)}
                                    dataSourceConfig={dataSourceConfig}
                                    onClose={this.handleOnClose.bind(this)}
                                    onUpdateInput={this.handleUpdateInput.bind(this)}> 
                                </AutoComplete>
                       </Col>
                       <Col lg={2}>
                           <ClearIcon onClick={this.handleClearClick.bind(this)} hoverColor={greenA200} style={iconStyles} viewBox="0 0 24 24"/>
                       </Col>
                   </Row>
                </Grid>
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

export default connect(mapStateToProps)(DriverFilter);
