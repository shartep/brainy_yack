import React        from 'react'
import { observer } from 'mobx-react'
import PropTypes    from 'prop-types'

import HeaderSortControl from './HeaderSortControl'

@observer
export default class HeaderCell extends React.Component {
  render() {
    return (
      <td>
        {this.props.name}
        <HeaderSortControl orderKey={this.props.orderKey} params={this.props.params} />
      </td>
    );
  }
}

HeaderCell.propTypes = {
  params: PropTypes.object.isRequired,
  name: PropTypes.string.isRequired,
  orderKey: PropTypes.string.isRequired
};
