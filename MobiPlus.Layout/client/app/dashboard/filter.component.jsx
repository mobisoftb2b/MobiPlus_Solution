import React, { Component, PropTypes } from 'react';
import { Grid, Row, Col, ButtonGroup } from 'react-bootstrap';
import SelectField from 'material-ui/SelectField';
import MenuItem from 'material-ui/MenuItem';
import AutoComplete from 'material-ui/AutoComplete';
import { connect } from 'react-redux';
import DatePickerInline from '../../share/components/Common/dateTimeField.component';
import { fetchDistribution, fetchDrivers } from '../../redux/actions/cascade';
import { changeFilter } from '../../redux/actions/filter';

const styles = {
    customWidth: {
        width: 300
    },
    customMargin: {
        'marginTop': '15px',
        'padding': '10px'
    }
};
const dataSourceConfig = {
    text: 'textKey',
    value: 'valueKey',
};

class FilterDropdown extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    CountrySelectHandler(event, index, value) {
        const countries = this.props.initFilterData.countryData || [];
        let cData = countries.filter(el => el.CountryID == value);
        let filter = this.props.filter || {};
        filter.CountryID = value;
        filter.DistrID = null;
        filter.AgentID = null;
        filter.CountryLanLng = cData[0].LatLng;
        filter.LanguageID = this.props.local.langSettings.langID;
        this.props.dispatch(changeFilter(filter));
        this.props.dispatch(fetchDistribution(filter));
        this.props.dispatch(fetchDrivers(filter));
    }

    DistributionSelectHandler(event, index, value) {
        let filter = this.props.filter || {};
        filter.DistrID = value;
        filter.AgentID = filter.AgentID;
        filter.LanguageID = this.props.local.langSettings.langID;
        this.props.dispatch(changeFilter(filter));
        this.props.dispatch(fetchDrivers(filter));
    }

    DriverSelectHandler(event, index, value) {
        if(event==""){
            let filter = this.props.filter || {};
            filter.AgentID = 0;
            filter.LanguageID = this.props.local.langSettings.langID;
            this.props.dispatch(changeFilter(filter));
        }
    }
    handleNewRequest(chosenRequest, idx) {
        let filter = this.props.filter || {};
        filter.AgentID = chosenRequest.valueKey;
        filter.LanguageID = this.props.local.langSettings.langID;
        this.props.dispatch(changeFilter(filter));

    }
    handleOnClose(chosenRequest, idx) {
        let refs = this.refs[`autocomplete`].state.searchText;
        if(refs==""){
            let filter = this.props.filter || {};
            filter.AgentID = 0;
            filter.LanguageID = this.props.local.langSettings.langID;
            this.props.dispatch(changeFilter(filter));
        }
    }

    renderCountry() {
        const countries = this.props.initFilterData.countryData || [];
        return (
            countries.map(c =>
                <MenuItem key={c.CountryID} data={c.LatLng} value={c.CountryID} primaryText={c.CountryName} />

            ));
                }

    renderDistribution() {
        const distrData = this.props.filterData.distrData || [];
        return (
            distrData.map(d =>
                <MenuItem key={d.DistrID} value={d.DistrID} primaryText={d.DistributionCenterDesc} />
            ));
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


    renderDatePicker() {
        return (
            <DatePickerInline container="inline" autoOk={true} floatingLabelText={this.props.local.filter.DATE} filter={this.props.filter} mode='portrait' />
        );
    }

    render() {
        let Distributions = false, Countries = false, Drivers = false, Calendar = false;
        const hiddenCol = this.props.HiddenColName || [];
        for (let i = 0; i < hiddenCol.length; i++) {
            switch (hiddenCol[i]) {
                case 'Distributions':
                    Distributions = true;
                    break;
                case 'Countries':
                    Countries = true;
                    break;
                case 'Drivers':
                    Drivers = true;
                    break;
                case 'Calendar':
                    Calendar = true;
                    break;
            }
        }

        return (
            <div>
                <div className="form-group mb">
                    <Grid>
                        <Row>
                            <Col lg={3} sm={6} lgHidden={Countries}>
                                <SelectField id='ddlCountries'
                                    ref={`countrySelect`}
                                    floatingLabelText={this.props.local.filter.COUNTRY}
                                    value={this.props.filter.CountryID}
                                    onChange={this.CountrySelectHandler.bind(this)}>
                                    {this.renderCountry()}
                                </SelectField>
                            </Col>
                            <Col lg={3} sm={6} lgHidden={Distributions}>
                                <SelectField id='ddlDistributions' onChange={this.DistributionSelectHandler.bind(this)}
                                    floatingLabelText={this.props.local.filter.DISTRIBUTION}
                                    value={this.props.filter.DistrID} >
                                    {this.renderDistribution()}
                                </SelectField>
                            </Col>
                            <Col lg={3} sm={6} lgHidden={Drivers}>
                                <AutoComplete
                                    ref={`autocomplete`}
                                    menuStyle = {{maxHeight:"500px",overflowY:'auto'}}
                                    floatingLabelText={this.props.local.filter.DRIVER}
                                    filter={AutoComplete.fuzzyFilter}
                                    style={styles.customWidth}
                                    openOnFocus={true}
                                    dataSource={this.renderDriver()}
                                    onNewRequest={this.handleNewRequest.bind(this)}
                                    dataSourceConfig={dataSourceConfig}
                                    onClose={this.handleOnClose.bind(this)}
                                />
                            </Col>
                            <Col lg={2} sm={6} style={styles.customMargin} lgHidden={Calendar}>
                                {this.renderDatePicker()}
                            </Col>
                            <Col lg={1}>
                            </Col>
                        </Row>
                    </Grid>
                </div>
            </div>);
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

export default connect(mapStateToProps)(FilterDropdown);
