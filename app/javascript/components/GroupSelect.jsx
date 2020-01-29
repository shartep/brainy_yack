import React                from 'react'
import { inject, observer } from 'mobx-react'
import { computed }         from 'mobx'

@inject('articlesStore')

@observer
export default class GroupSelect extends React.Component {
  @computed get params() { return this.props.articlesStore.params }

  onChange(event) { this.params.grouped_by = event.target.value }

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

