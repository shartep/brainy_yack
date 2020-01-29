import React                from 'react'
import { observer, inject } from 'mobx-react'
import { FontAwesomeIcon }  from '@fortawesome/react-fontawesome'
import { computed }         from 'mobx'

@inject('storiesStore')

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

  @computed get stories() { return this.props.storiesStore.data }

  cleanState() { this.setState(this.initialState) }

  onStoryChange(event) { this.setState({story_id: event.target.value, changed: true}) }

  onTypeChange(event) { this.setState({type: event.target.value, changed: true}) }

  onNameChange(event) { this.setState({name: event.target.value, changed: true}) }

  onTextChange(event) { this.setState({text: event.target.value, changed: true}) }

  errorHandler(error) {
    console.log(error);
    alert(error.response.data.errors);
  }

  submitHandler(event) {
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
    return this.stories.map(story => (<option key={story.id} value={story.id}>{story.name}</option>))
  }

  render() {
    return (
      <form onSubmit={this.submitHandler.bind(this)}>
        <h3>New article:</h3>

        <span>
          <label htmlFor="story_id">Story:</label>
          <select name="story_id" value={this.state.story_id} onChange={this.onStoryChange.bind(this)}>
            <option value="" disabled>Select story</option>
            {this.renderStories()}
          </select>
        </span>

        <span>
          <label htmlFor="type">Type:</label>
          <select name="type" defaultValue={this.state.type} onChange={this.onTypeChange.bind(this)}>
            <option value="" disabled>Select type</option>
            <option>blog_post</option>
            <option>facebook</option>
            <option>tweet</option>
          </select>
        </span>

        <span>
          <label htmlFor="name">Name:</label>
          <input type="text" name="name" value={this.state.name} onChange={this.onNameChange.bind(this)}/>
        </span>

        <span>
          <label htmlFor="text">Text:</label>
          <textarea name="text" value={this.state.text} onChange={this.onTextChange.bind(this)}/>
        </span>

        <button type="submit">
          <FontAwesomeIcon icon="save" />
        </button>
      </form>
    );
  }
}
