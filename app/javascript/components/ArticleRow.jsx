import React               from 'react'
import { observer }        from 'mobx-react'
import PropTypes           from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import axios               from 'axios'

@observer
export default class ArticleRow extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      editMode: false,
      changed: false,
      type: props.article.type,
      name: props.article.name,
      text: props.article.text
    };
  }

  onTypeChange(event) { this.setState({type: event.target.value, changed: true}) }

  onNameChange(event) { this.setState({name: event.target.value, changed: true}) }

  onTextChange(event) { this.setState({text: event.target.value, changed: true}) }

  saveChanges() {
    if (this.state.changed !== true ) { return }

    const params = {
      article: {
        type: this.state.type,
        name: this.state.name,
        text: this.state.text
      }
    };
    axios
      .put(`/api/v1/articles/${this.props.article.id}`, params)
      .catch(error => console.log(error));
  }

  editHandler(event) {
    event.preventDefault();

    if (this.isEditMode()) { this.saveChanges() }
    this.toggleEditMode();
  }

  destroyHandler(event) {
    event.preventDefault();
    axios.delete(`/api/v1/articles/${this.props.article.id}`)
  }

  updateIcon() {
    if (this.isEditMode()) { return 'save' }
    else { return 'edit' }
  }

  toggleEditMode() { this.setState(state => ({editMode: !state.editMode })) }

  isEditMode() { return this.state.editMode === true }

  renderEditableFields() {
    if (this.isEditMode()) { return this.renderEditMode() }
    else { return this.renderStaticMode() }
  }

  renderEditMode() {
    return(
      <>
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
        <td>{article.story_name}</td>
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
