import React from 'react';
import ReactCssTransitionGroup from 'react-addons-css-transition-group';

import Header from './Header'
import Sidebar from './Sidebar'
import Offsidebar from './Offsidebar'
import Footer from './Footer'


class Base extends React.Component {

    render() {

        // Animations supported
        //      'rag-fadeIn'
        //      'rag-fadeInUp'
        //      'rag-fadeInDown'
        //      'rag-fadeInRight'
        //      'rag-fadeInLeft'
        //      'rag-fadeInUpBig'
        //      'rag-fadeInDownBig'
        //      'rag-fadeInRightBig'
        //      'rag-fadeInLeftBig'
        //      'rag-zoomBackDown'

        const animationName = 'rag-fadeIn';
        return (
            <div className="wrapper">
                <Header />
            
                    <Sidebar />

                    <Offsidebar />

                    <ReactCssTransitionGroup
                        component="section"
                        transitionName={animationName}
                        transitionEnterTimeout={500}
                        transitionLeaveTimeout={500}>
                        {React.cloneElement(this.props.children, {
                            key: this.props.location.pathname
                        })}
                   </ReactCssTransitionGroup>

            <Footer />
            </div>
        );
    }

}

export default Base;
