import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types';
import _ from 'lodash'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

@observer
export default class HeaderSortControl extends React.Component {
  sortIcon() {
    const order = this.props.store.params.order;
    if (_.isNil(order) || _.isNil(order.field) || order.field != this.props.orderKey) { return 'sort' }

    if (order.direction === 'desc') { return 'sort-up' }
    else { return 'sort-down' }
  }

  onClick(event) {
    event.preventDefault();

    let order = {field: this.props.orderKey};
    if (_.isNil(this.props.store.params.order)) { order.direction = 'desc' }
    else if (this.props.store.params.order.direction === 'desc') { order.direction = 'asc' }
    else { order = null }

    this.props.store.params = {order: order};
  }

  render() {
    return (
      <a href="#" onClick={this.onClick.bind(this)}>
        <FontAwesomeIcon icon={this.sortIcon()} />
      </a>
    );
  }
}

HeaderSortControl.propTypes = {
  store: PropTypes.object.isRequired,
  orderKey: PropTypes.string.isRequired
};
