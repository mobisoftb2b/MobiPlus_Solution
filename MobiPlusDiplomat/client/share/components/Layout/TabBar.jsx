import React from 'react';
import { connect } from 'react-redux';
import { Dropdown, MenuItem } from 'react-bootstrap';
import { fetchLocal } from '../../../redux/actions/local';

class TabBar extends React.Component {

    handleSelect(key) {
        this.props.dispatch(fetchLocal(key)); 
    }
  
    render() {
        return (
             <div className="content-heading">
                    { /* START Language list */ }
                    <div className="pull-right">
                        <Dropdown id="dropdown-local"  onSelect={ this.handleSelect.bind(this) } >
                            <Dropdown.Toggle>
                                עברית
                            </Dropdown.Toggle>
                            <Dropdown.Menu className="animated fadeInUpShort">
                                <MenuItem eventKey="he">עברית</MenuItem>
                                <MenuItem eventKey="en">English</MenuItem>
                            </Dropdown.Menu>
                        </Dropdown>
                    </div>
                    { /* END Language list */ }
               <small data-localize="dashboard.WELCOME">Welcome to MobiPlus Layout!</small>
        </div>
            );
    }
}

function mapStateToProps(state,action) {
    return {
        widget: state.dashboard.widget,
        local: state.local
    }
}
export default  connect(mapStateToProps)(TabBar); ;