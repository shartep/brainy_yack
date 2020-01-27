import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types';

import HeaderSortControl from './HeaderSortControl'

@observer
export default class HeaderCell extends React.Component {
  render() {
    return (
      <td>
        {this.props.name}
        <HeaderSortControl orderKey={this.props.orderKey} store={this.props.store} />
      </td>
    );
  }
}

HeaderCell.propTypes = {
  store: PropTypes.object.isRequired,
  name: PropTypes.string.isRequired,
  orderKey: PropTypes.string.isRequired
};
