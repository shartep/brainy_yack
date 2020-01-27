import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

@observer
export default class HeaderSortControl extends React.Component {
  sortIcon() {
    const order_field = this.props.store.params.order_field;
    const order_direction = this.props.store.params.order_direction;
    if (order_field != this.props.orderKey) { return 'sort' }

    if (order_direction === 'desc') { return 'sort-down' }
    else { return 'sort-up' }
  }

  onClick(event) {
    event.preventDefault();

    let order_field = this.props.orderKey;
    let order_direction = null;

    if (this.props.store.params.order_field === null) { order_direction = 'desc' }
    else if (this.props.store.params.order_direction === 'desc') { order_direction = 'asc' }
    else { order_field = null }

    this.props.store.params = {order_field: order_field, order_direction: order_direction};
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
