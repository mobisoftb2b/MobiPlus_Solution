import React, {Component} from 'react';
import {Col, Tab, Tabs} from 'react-bootstrap';
import {connect} from 'react-redux';
import {fetchTabs} from '../../redux/actions/tabs';
import LayoutContent from '../layout/layout.container'


class TabsComponent extends Component {
    constructor(props, context) {
        super(props, context);
        let menuData = this.props.menuData[0] || {};
        this.state = {
            filter: this.props.filter,
            key:1
        };
    }

    componentDidMount() {
        let filter = this.props.filter;
        let menuData = this.props.menuData[0] || {};
        filter.FormID = menuData.FormID;
        this.props.dispatch(fetchTabs(filter));
    }

    handleSelect(key) {
        this.setState({
            key: key
        });
    }

    createTabs(tabs) {
        return (
            tabs.map(d =>
                (
                    <Tab key={d.TabID} eventKey={d.TabID} title={d.TabDescription}>
                        {this.renderLayout(d.Layouts)}
                    </Tab>
                )
            ));
    }

    renderLayout(layoutContent) {
        let content = layoutContent || [];
        return (
            <LayoutContent LayoutContent={content}/>
        );

    }

    render() {
        let tabs = this.props.tabsData || [];
        return (
            <Tabs activeKey={this.state.key} onSelect={this.handleSelect.bind(this)} justified id="tabID">
                {this.createTabs(tabs)}
            </Tabs>
        );
    }
}

function mapStateToProps(state, action) {
    return {
        local: state.local,
        layoutData: state.layoutData,
        filter: state.filter,
        tabsData: state.tabsData
    };
}

export default connect(mapStateToProps)(TabsComponent);