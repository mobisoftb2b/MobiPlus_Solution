import React from 'react';
import { connect } from 'react-redux';
import { Dropdown, MenuItem, Tabs, Tab } from 'react-bootstrap';
import OffsidebarRun from './Offsidebar.run';
import { fetchLocal } from '../../../redux/actions/local';
import SelectLanguage from './selectLanguage.component';

class Offsidebar extends React.Component {

    constructor(props, context) {
        super(props, context);
        this.state = {
            key: 1
        };
    }

    componentDidMount() {
        OffsidebarRun();
    }

    handleLanguage(key){
        this.props.dispatch(fetchLocal(key));
    }
  

    handleSelect(key) {        
        this.setState({
            key
        });
    }

    render() {
        let local = this.props.local;
        const tabIconA = <em className="icon-equalizer fa-lg"></em>;
        const tabIconB = <em className="icon-user fa-lg"></em>;
        return (
            <aside className="offsidebar hide">
                { /* START Off Sidebar (right) */ }
                <Tabs activeKey={ this.state.key } onSelect={ this.handleSelect.bind(this) } justified id="tabId">
                    <Tab eventKey={ 1 } title={ tabIconA }>
                        <h3 className="text-center text-thin"><span>{ local.offsidebar.SETTINGS }</span></h3>
                        <div className="p">
                            <div className="clearfix">
                               <SelectLanguage/>
                            </div>
                         </div>
                        
                        <div className="p">
                            <h4 className="text-muted text-thin">Themes</h4>
                            <div className="table-grid mb">
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="A">
                                            <input type="radio" name="setting-theme" id="rdbThemeA" data-theme-state="layout-theme"  />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-info"></span>
                                            <span className="color bg-info-light"></span>
                                            </span>
                                            <span className="color bg-white"></span>
                                        </label>
                                    </div>
                                </div>
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="B">
                                            <input type="radio" name="setting-theme" id="rdbThemeB"  data-theme-state="layout-theme" />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-green"></span>
                                            <span className="color bg-green-light"></span>
                                            </span>
                                            <span className="color bg-white"></span>
                                        </label>
                                    </div>
                                </div>
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="C">
                                            <input type="radio" name="setting-theme" id="rdbThemeC" data-theme-state="layout-theme" />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-purple"></span>
                                            <span className="color bg-purple-light"></span>
                                            </span>
                                            <span className="color bg-white"></span>
                                        </label>
                                    </div>
                                </div>
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="D">
                                            <input type="radio" name="setting-theme" id="rdbThemeD" data-theme-state="layout-theme"  />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-danger"></span>
                                            <span className="color bg-danger-light"></span>
                                            </span>
                                            <span className="color bg-white"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div className="table-grid mb">
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="E">
                                            <input type="radio" name="setting-theme" id="rdbThemeE" data-theme-state="layout-theme" />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-info-dark"></span>
                                            <span className="color bg-info"></span>
                                            </span>
                                            <span className="color bg-gray-dark"></span>
                                        </label>
                                    </div>
                                </div>
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="F">
                                            <input type="radio" name="setting-theme" id="rdbThemeF" data-theme-state="layout-theme" />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-green-dark"></span>
                                            <span className="color bg-green"></span>
                                            </span>
                                            <span className="color bg-gray-dark"></span>
                                        </label>
                                    </div>
                                </div>
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="G">
                                            <input type="radio" name="setting-theme" id="rdbThemeG" data-theme-state="layout-theme" />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-purple-dark"></span>
                                            <span className="color bg-purple"></span>
                                            </span>
                                            <span className="color bg-gray-dark"></span>
                                        </label>
                                    </div>
                                </div>
                                <div className="col mb">
                                    <div className="setting-color">
                                        <label data-load-theme="H">
                                            <input type="radio" name="setting-theme" id="rdbThemeH" data-theme-state="layout-theme" />
                                            <span className="icon-check"></span>
                                            <span className="split">
                                                           <span className="color bg-danger-dark"></span>
                                            <span className="color bg-danger"></span>
                                            </span>
                                            <span className="color bg-gray-dark"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="p">
                            <h4 className="text-muted text-thin">Layout</h4>
                            <div className="clearfix">
                                <p className="pull-left">Fixed</p>
                                <div className="pull-right">
                                    <label className="switch">
                                        <input id="chk-fixed" type="checkbox" data-toggle-state="layout-fixed" />
                                        <em></em>
                                    </label>
                                </div>
                            </div>
                            <div className="clearfix">
                                <p className="pull-left">Boxed</p>
                                <div className="pull-right">
                                    <label className="switch">
                                        <input id="chk-boxed" type="checkbox" data-toggle-state="layout-boxed" />
                                        <em></em>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </Tab>
                    <Tab eventKey={ 2 } title={ tabIconB }>
                        <h3 className="text-center text-thin">Tab 2</h3>
                    </Tab>
                </Tabs>
                { /* END Off Sidebar (right) */ }
            </aside>
            );
    }

}

function mapStateToProps(state,action) {
    return {
        local: state.local
    }
}

export default connect(mapStateToProps)(Offsidebar);
