import React               from 'react'
import { observer }        from 'mobx-react'
import PropTypes           from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import axios               from 'axios'

@observer
export default class NewArticle extends React.Component {
  initialState = {
    changed: false,
    story_id: '',
    type: '',
    name: '',
    text: ''
  };

  constructor(props) {
    super(props);
    this.state = this.initialState;
  }

  cleanState() { this.setState(this.initialState) }

  onStoryChange(event) { this.setState({story_id: event.target.value, changed: true}) }

  onTypeChange(event) { this.setState({type: event.target.value, changed: true}) }

  onNameChange(event) { this.setState({name: event.target.value, changed: true}) }

  onTextChange(event) { this.setState({text: event.target.value, changed: true}) }

  errorHandler(error) {
    console.log(error);
    alert(error.response.data.errors);
  }

  saveHandler(event) {
    event.preventDefault();

    if (this.state.changed !== true ) { return }

    const params = {
      article: {
        story_id: this.state.story_id,
        type: this.state.type,
        name: this.state.name,
        text: this.state.text
      }
    };
    axios
      .post(`/api/v1/articles`, params)
      .then(this.cleanState.bind(this))
      .catch(this.errorHandler);
  }

  renderStories() {
    return this.props.stories.map(story => (<option key={story.id} value={story.id}>{story.name}</option>))
  }

  render() {
    return (
      <>
        <tr><td><h3>New article:</h3></td></tr>
        <tr>
          <td>
            <select name="story_id" value={this.state.story_id} onChange={this.onStoryChange.bind(this)}>
              <option value="" disabled>Select story</option>
              {this.renderStories()}
            </select>
          </td>
          <td>
            <select name="type" defaultValue={this.state.type} onChange={this.onTypeChange.bind(this)}>
              <option value="" disabled>Select type</option>
              <option>blog_post</option>
              <option>facebook</option>
              <option>tweet</option>
            </select>
          </td>
          <td><input type="text" name="name" value={this.state.name} onChange={this.onNameChange.bind(this)}/></td>
          <td><input type="text" name="text" value={this.state.text} onChange={this.onTextChange.bind(this)}/></td>
          <td></td>
          <td></td>
          <td>
            <a href="#" onClick={this.saveHandler.bind(this)}>
              <FontAwesomeIcon icon="save" />
            </a>
          </td>
        </tr>
        <tr><td><h3></h3></td></tr>
      </>
    );
  }
}

NewArticle.propTypes = {
  stories: PropTypes.array.isRequired
};
