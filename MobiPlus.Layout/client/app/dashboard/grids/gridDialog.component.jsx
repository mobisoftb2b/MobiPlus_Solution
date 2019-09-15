import React, {Component} from 'react';
import { connect } from 'react-redux';

class GridDialogContent extends Component{

    constructor(props){
        super(props);

    }                           

    render(){
        return (
             <div>
                <form onSubmit={this.handleSubmit}>
                  <input type="text" />
                  <input type="submit" />
                  //<button onClick = {this.props.closeDialog}>Cancel</button>
                </form>
              </div>
            );
    }

}

const mapStateToProps = (state) => ({
    local: state.local    
});
export default connect(mapStateToProps)(GridDialogContent);
