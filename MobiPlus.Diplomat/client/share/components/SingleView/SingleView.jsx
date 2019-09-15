import React from 'react';
import ContentWrapper from '../Layout/ContentWrapper';
import { Grid, Row, Col, Dropdown, MenuItem } from 'react-bootstrap';
import TabBar from '../Layout/TabBar';

class SingleView extends React.Component {

    render() {
        return (
            <ContentWrapper>
                <TabBar/>
                <Row>
                </Row>
            </ContentWrapper>
        );
    }
}

export default SingleView;
