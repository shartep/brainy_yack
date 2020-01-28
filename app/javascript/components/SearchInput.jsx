import React        from 'react'
import { observer } from 'mobx-react'
import PropTypes    from 'prop-types'

@observer
export default class SearchInput extends React.Component {
  get search() { return this.props.params.search }
  set search(term) { this.props.params.search = term }

  onChange(event) {
    const value = event.target.value;
    if (value.length < 4) { this.search = null }
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

SearchInput.propTypes = {
  params: PropTypes.object.isRequired,
};
