import React, {Component} from 'react';


class PercentCompleteFormatter extends Component {
    constructor(props){
        super(props);
    }

    render() {
        const percentComplete = this.props.value + '%';
        return (
          <div className="progress" style={{marginTop: '20px'}}>
             <div className="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style={{width: percentComplete}}>{percentComplete}</div>
         </div>);
}
}
export default PercentCompleteFormatter;