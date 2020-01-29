import React                from 'react'
import { inject, observer } from 'mobx-react'
import { computed }         from 'mobx'

@inject('articlesStore')

@observer
export default class SearchInput extends React.Component {
  @computed get params() { return this.props.articlesStore.params }
  @computed get search() { return this.params.search }
  set search(term) { this.params.search = term }

  onChange(event) {
    const value = event.target.value;
    if (value.length < 3) { this.search = null }
    else { this.search = value }
  }

  render() {
    return (
      <>
        <label>Search: </label>
        <input type="text" prompt="Search" onChange={this.onChange.bind(this)}/>
      </>
    );
  }
}
