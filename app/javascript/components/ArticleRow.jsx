import React                from 'react'
import { observer, inject } from 'mobx-react'
import PropTypes            from 'prop-types'
import { FontAwesomeIcon }  from '@fortawesome/react-fontawesome'
import { computed }         from 'mobx'

@inject('articlesStore', 'storiesStore')

@observer
export default class ArticleRow extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      editMode: false,
      changed: false,
      story_id: this.props.article.story_id,
      story_name: this.props.article.story_name,
      type: this.props.article.type,
      name: this.props.article.name,
      text: this.props.article.text
    };
  }

  @computed get store()   { return this.props.articlesStore }
  @computed get stories() { return this.props.storiesStore.data }

  onStoryChange(event) {
    const select = event.target;
    const params = {
      story_id: select.value,
      story_name: select.options[select.selectedIndex].text,
      changed: true
    };
    this.setState(params);
  }

  onTypeChange(event) { this.setState({type: event.target.value, changed: true}) }

  onNameChange(event) { this.setState({name: event.target.value, changed: true}) }

  onTextChange(event) { this.setState({text: event.target.value, changed: true}) }

  saveChanges() {
    if (this.state.changed !== true ) { return this.toggleEditMode() }

    this.store.updateArticle({
      id: this.props.article.id,
      story_id: this.state.story_id,
      type: this.state.type,
      name: this.state.name,
      text: this.state.text
    }).then(this.toggleEditMode.bind(this));
  }

  editHandler(event) {
    event.preventDefault();

    if (this.isEditMode()) { this.saveChanges() }
    else { this.toggleEditMode() }
  }

  destroyHandler(event) {
    event.preventDefault();
    this.store.deleteArticle(this.props.article.id);
  }

  updateIcon() {
    if (this.isEditMode()) { return 'save' }
    else { return 'edit' }
  }

  toggleEditMode() { this.setState(state => ({editMode: !state.editMode, changed: false})) }

  isEditMode() { return this.state.editMode === true }

  renderStories() {
    return this.stories.map(story => (<option key={story.id} value={story.id}>{story.name}</option>))
  }

  renderEditableFields() {
    if (this.isEditMode()) { return this.renderEditMode() }
    else { return this.renderStaticMode() }
  }

  renderEditMode() {
    return(
      <>
        <td>
          <select name="story_id" value={this.state.story_id} onChange={this.onStoryChange.bind(this)}>
            {this.renderStories()}
          </select>
        </td>
        <td>
          <select name="type" defaultValue={this.state.type} onChange={this.onTypeChange.bind(this)}>
            <option>blog_post</option>
            <option>facebook</option>
            <option>tweet</option>
          </select>
        </td>
        <td><input type="text" name="name" defaultValue={this.state.name} onChange={this.onNameChange.bind(this)}/></td>
        <td><input type="text" name="text" defaultValue={this.state.text} onChange={this.onTextChange.bind(this)}/></td>
      </>
    )
  }

  renderStaticMode() {
    return(
      <>
        <td>{this.state.story_name}</td>
        <td>{this.state.type}</td>
        <td>{this.state.name}</td>
        <td>{this.state.text}</td>
      </>
    )
  }

  render() {
    const article = this.props.article;
    return (
      <tr>
        {this.renderEditableFields(article)}
        <td>{article.created_at}</td>
        <td>{article.updated_at}</td>
        <td>
          <a href="#" onClick={this.editHandler.bind(this)}>
            <FontAwesomeIcon icon={this.updateIcon()} />
          </a>
          <a href="#" onClick={this.destroyHandler.bind(this)}>
            <FontAwesomeIcon icon="trash" />
          </a>
        </td>
      </tr>
    );
  }
}

ArticleRow.propTypes = {
  article: PropTypes.object.isRequired,
};
