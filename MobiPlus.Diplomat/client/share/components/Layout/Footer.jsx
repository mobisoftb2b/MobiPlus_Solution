import React from 'react';

class Footer extends React.Component {

    render() {
        return (
            <footer>
                <span>&copy; {new Date().getFullYear()} - MobiSoft</span>
            </footer>
        );
    }

}

export default Footer;
