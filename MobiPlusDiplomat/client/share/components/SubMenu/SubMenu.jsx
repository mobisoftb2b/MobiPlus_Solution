var React = require('react');
import ContentWrapper from '../Layout/ContentWrapper';
import { Grid, Row, Col, Dropdown, MenuItem } from 'react-bootstrap';
import TabBar from '../Layout/TabBar';

var SubMenu = React.createClass({

    render: function() {
        return (
            <ContentWrapper>
             <TabBar/>
                <Row>
                   <Col lg={12}>
                      <p>A row with content</p>
                   </Col>
                </Row>
            </ContentWrapper>
        );
    }

});

module.exports = SubMenu;