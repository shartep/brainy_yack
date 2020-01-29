import React                from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes            from 'prop-types'
import { FontAwesomeIcon }  from '@fortawesome/react-fontawesome'

@inject('articlesStore')

@observer
export default class HeaderSortControl extends React.Component {
  get store()           { return this.props.articlesStore }
  get order_field()     { return this.store.params.order_field }
  get order_direction() { return this.store.params.order_direction }

  sortIcon() {
    if (this.order_field != this.props.orderKey) { return 'sort' }
    if (this.order_direction === 'desc') { return 'sort-down' }
    return 'sort-up'
  }

  onClick(event) {
    event.preventDefault();

    let field = this.props.orderKey;
    let direction = null;

    if (this.order_field === null || this.order_field != field) { direction = 'asc' }
    else if (this.order_direction === 'asc') { direction = 'desc' }
    else { field = null }

    this.store.setOrder(field, direction);
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
  orderKey: PropTypes.string.isRequired
};
