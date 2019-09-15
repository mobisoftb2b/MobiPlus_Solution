import React, {Component} from 'react';


class ImageFormatter extends Component {
    constructor(props){
        super(props);
    }

    render() {
        const imageName = this.props.value;
        let src = `../../public/img/${imageName}.png`;
        return (
            <img src={src} width='25px' />
        );
            }
}
export default ImageFormatter;
