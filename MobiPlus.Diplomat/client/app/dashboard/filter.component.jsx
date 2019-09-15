import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {Grid, Row, Col, ButtonGroup} from 'react-bootstrap';
import SelectField from 'material-ui/SelectField';
import MenuItem from 'material-ui/MenuItem';
import AutoComplete from 'material-ui/AutoComplete';
import {connect} from 'react-redux';
import DatePickerInline from '../../share/components/Common/dateTimeField.component';
import ToDatePicker from '../../share/components/Common/toDateTimeField.component';
import DriverFilter from '../../share/components/Common/driverFilter.component';
//import DriverFilter from '../../share/components/Common/superselectfield.component';
import {fetchDistribution, fetchDrivers} from '../../redux/actions/cascade';
import {changeFilter} from '../../redux/actions/filter';
import SvgIcon from 'material-ui/SvgIcon'
import {blue500, red500, greenA200} from 'material-ui/styles/colors';
import { injectTapEventPlugin } from "react-tap-event-plugin";
//injectTapEventPlugin();

const styles = {
    customWidth: {
        width: 200
    },
    distrWidth: {
        width: 250
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

const ClearIcon = (props) => (
    <SvgIcon {...props}>
        <path
            d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
    </SvgIcon>
);
const iconStyles = {marginTop: '40px'};

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
        filter.DistrID = cData[0].DistributionCenter.DistrID;
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


    renderCountry() {
        const countries = this.props.initFilterData.countryData || [];
        return (
            countries.map(c =>
                <MenuItem key={c.CountryID} data={c.LatLng} value={c.CountryID} primaryText={c.CountryName}/>
            ));
    }

    renderDistribution() {
        const distrData = this.props.filterData.distrData || [];
        return (
            distrData.map(d =>
                <MenuItem key={d.DistrID} value={d.DistrID} primaryText={d.DistributionCenterDesc}/>
            ));
    }

    handleClearClick(e) {
        const distrData = this.props.filterData.distrData || [];
        let filter = this.props.filter || {};
        filter.DistrID = null;
        this.props.dispatch(changeFilter(filter));
    }

    renderDriver() {
        return (
            <DriverFilter floatingLabelText={this.props.local.filter.DRIVER} filter={this.props.filter}/>
        );
    }

    renderFromDatePicker() {
        return (
            <DatePickerInline container="inline" autoOk={true} floatingLabelText={this.props.local.filter.DATE}
                              filter={this.props.filter} mode='portrait'/>
        );
    }

    renderToDatePicker() {
        return (
            <ToDatePicker container="inline" autoOk={true} floatingLabelText={this.props.local.filter.TODATE}
                              filter={this.props.filter} mode='portrait'/>
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
                            <Col md={2} sm={6} lgHidden={Countries}>
                                <SelectField id='ddlCountries'
                                             ref={`countrySelect`}
                                             floatingLabelText={this.props.local.filter.COUNTRY}
                                             value={this.props.filter.CountryID}
                                             onChange={this.CountrySelectHandler.bind(this)}
                                                 style={styles.customWidth}>
                                    {this.renderCountry()}
                                </SelectField>
                            </Col>
                            <Col lg={3} sm={6} lgHidden={Distributions}>
                                <Row>
                                    <Col lg={10}>
                                        <SelectField id='ddlDistributions' style={styles.distrWidth}
                                                     onChange={this.DistributionSelectHandler.bind(this)}
                                                     floatingLabelText={this.props.local.filter.DISTRIBUTION}
                                                     value={this.props.filter.DistrID}>
                                            {this.renderDistribution()}
                                        </SelectField>
                                    </Col>
                                    <Col lg={2}>
                                        <ClearIcon onClick={this.handleClearClick.bind(this)} hoverColor={greenA200}
                                                   style={iconStyles} viewBox="0 0 24 24"/>
                                    </Col>
                                </Row>
                            </Col>
                            <Col lg={3} sm={6} lgHidden={Drivers}>
                                {this.renderDriver()}
                            </Col>
                            <Col lg={2} sm={6} style={styles.customMargin} lgHidden={Calendar}>
                                {this.renderFromDatePicker()}
                            </Col>
                            <Col lg={2} sm={6} style={styles.customMargin} lgHidden={Calendar}>
                                {this.renderToDatePicker()}
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
