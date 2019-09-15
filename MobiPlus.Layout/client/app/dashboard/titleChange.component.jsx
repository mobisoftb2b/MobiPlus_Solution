import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { changeTitle } from '../../redux/actions/dashboard';

class TitleChanger extends Component{

    constructor(props){
        super(props);

        this.state = {
            title: ''
        };
    }

    handleTextChange(e){
        this.setState({
            title: e.target.value
        });
    }

    handleClick(){
        this.props.dispatch(changeTitle(this.state.title));
    }

    render(){
        return (
            <div>
                <input type="text" value={this.state.title} onChange={this.handleTextChange.bind(this)} />
                    <input type="button" value="Change Title To Testing" onClick={this.handleClick.bind(this)} />
                </div>
        );
   }
}


export default connect()(TitleChanger);