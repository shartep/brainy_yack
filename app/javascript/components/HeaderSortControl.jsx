import React               from 'react'
import { observer }        from 'mobx-react'
import PropTypes           from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'


@observer
export default class HeaderSortControl extends React.Component {
  get order() { return this.props.params.order }
  set order(data) { this.props.params.order = data }

  sortIcon() {
    if (this.order.field != this.props.orderKey) { return 'sort' }
    if (this.order.direction === 'desc') { return 'sort-down' }
    return 'sort-up'
  }

  onClick(event) {
    event.preventDefault();

    let field = this.props.orderKey;
    let direction = null;

    if (this.order.field === null || this.order.field != field) { direction = 'asc' }
    else if (this.order.direction === 'asc') { direction = 'desc' }
    else { field = null }

    this.order = {field: field, direction: direction};
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
  params: PropTypes.object.isRequired,
  orderKey: PropTypes.string.isRequired
};
