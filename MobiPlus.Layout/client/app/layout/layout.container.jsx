import React, { Component, PropTypes } from 'react';
import { Grid, Row, Col, Dropdown, MenuItem, Panel, Tab, Tabs  } from 'react-bootstrap';
import { connect } from 'react-redux';
import {Responsive, WidthProvider} from 'react-grid-layout';
import { fetchLayout } from '../../redux/actions/layout';
import PureRenderMixin from 'react-addons-pure-render-mixin';
import _ from 'lodash';
import BaseReportContainer from './baseReports.container'; 



const ResponsiveReactGridLayout = WidthProvider(Responsive);
import ContentWrapper from '../../share/components/Layout/ContentWrapper';


class LayoutContainer extends Component {
    constructor(props, context){
        super(props, context);
        this.shouldComponentUpdate = PureRenderMixin.shouldComponentUpdate.bind(this);
        this.state = {
            currentBreakpoint: 'lg',
            mounted: false,
            layouts: {lg: this.props.initialLayout}
        };
      
    }
    
    createElement(el) {
        let style = {
        };

        return (
            <div key={el.i} data-grid={el} style={style} >
                {<span><BaseReportContainer key={el.i} reportsData={el}/></span>}
            </div>
        );
            }

    onBreakpointChange(breakpoint, cols) {
        this.setState({
            breakpoint: breakpoint,
            cols: cols
        });
    }

    onLayoutChange(layout) {
        this.setState({layout: layout});
    }

    mountLayout() {
        const locale = this.props.local.langSettings.shortLang; 
        let layoutData =  this.props.LayoutContent || [];
        return layoutData.map((i, key, list)=> {
            return {
                i: i.Report.ReportName,
                x: locale == 'he'? Math.trunc(12-i.StartPos_X):i.StartPos_X,
                y: i.StartPos_Y,
                w: i.ContentDimension_X,
                h: i.ContentDimension_Y,
                minW: i.ContentDim_MinWidth,
                maxW: i.ContentDim_MaxWidth,
                minH: i.ContentDim_MinHeight,
                maxH: i.ContentDim_MaxHeight,
                static: i.IsStatic,
                isDraggable: i.isDraggable,
                isResizable: i.isResizable,
                data:i
            }
        });
    }
    
    render() {
        let items = this.mountLayout();
        return (
            <div>
                <ContentWrapper>
                    <ResponsiveReactGridLayout
                        breakpoints={{ lg: 1200, md: 996, sm: 768, xs: 480, xxs: 0 }}
                        onLayoutChange={this.onLayoutChange.bind(this)} {...this.props}>
                        { _.map(items, this.createElement) }
                    </ResponsiveReactGridLayout>
                </ContentWrapper>
            </div>);
    }

}


LayoutContainer.propTypes = {
    onLayoutChange: PropTypes.func.isRequired
};

LayoutContainer.defaultProps  = {
    className: "layout directionGrid",
    rowHeight: 30,
    onLayoutChange: function() {},
    cols: {lg: 12, md: 12, sm: 6, xs: 4, xxs: 2}
};
function mapStateToProps(state,action) {
    return {
        local: state.local,
        layoutData: state.layoutData
    };
}

export default connect(mapStateToProps)(LayoutContainer);