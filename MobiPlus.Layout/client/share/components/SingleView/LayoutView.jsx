import React from 'react';
import { Grid, Row, Col, Dropdown, MenuItem } from 'react-bootstrap';
import DashboardContainer from '../../../app/dashboard/dashboard.container';
import TaskContainer from '../../../app/task/task.container';
import HardwareContainer from '../../../app/hardware/hardware.container';
import SubMenu from '../SubMenu/SubMenu';


class LayoutView extends React.Component {

    render() {
        const spec = this.props.route.path; 
        switch (spec) {
            case 'dashboard':
                return <DashboardContainer />
            case 'hardware':
                return <HardwareContainer />
            case 'layout':
                return <SubMenu />
            case 'tasks':
                return <TaskContainer />
            default:
                return <DashboardContainer />
        }
    }
}
export default LayoutView;
