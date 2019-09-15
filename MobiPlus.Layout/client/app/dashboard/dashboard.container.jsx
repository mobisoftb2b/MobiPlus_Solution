import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import ContentWrapper from '../../share/components/Layout/ContentWrapper';
import TabsComponent from './tabs.component';
import _ from 'lodash';


class DashboardContainer extends Component {
    constructor(props, context) {
        super(props, context);
    }       

    componentDidMount() {
        let filter = this.props.filter;
        let menuData = this.props.menuData[0] || {};
        filter.FormID = menuData.FormID;
        this.props.dispatch(fetchTabs(filter));
    }


    renderTabs(menuData){
        let curRoute = this.props.location.pathname.replace('/','');
        const result = _.filter(menuData, function(a) { 
            return a.RoutePath == curRoute; 
        });
        return <TabsComponent menuData={result}/>;
    }

    render() {
        let menuData = this.props.menuData;
        return (
           <div>
            <ContentWrapper>
                 {this.renderTabs(menuData)}
             </ContentWrapper>
           </div>
        );
    }

}


function mapStateToProps(state,action) {
    return {
        local: state.local,
        menuData: state.menuData.menuData
    };
}

export default connect(mapStateToProps)(DashboardContainer);