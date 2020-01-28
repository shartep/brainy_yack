import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types';

@observer
export default class GroupSelect extends React.Component {
  onChange(event) { this.props.store.params.grouped_by = event.target.value }

  render() {
    return (
      <select onChange={this.onChange.bind(this)}>
        <option value="">Select group by setting</option>
        <option value="story">Story</option>
        <option value="type">Type</option>
        <option value="name">Name</option>
        <option value="created_at">Created</option>
        <option value="updated_at">Updated</option>
      </select>
    );
  }
}

GroupSelect.propTypes = {
  store: PropTypes.object.isRequired,
};
