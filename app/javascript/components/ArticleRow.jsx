import React               from 'react'
import { observer }        from 'mobx-react'
import PropTypes           from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import axios               from 'axios'

@observer
export default class ArticleRow extends React.Component {
  destroyHandler(event) {
    event.preventDefault();
    axios.delete(`/api/v1/articles/${this.props.article.id}`)
  }

  render() {
    const article = this.props.article;
    return (
      <tr>
        <td>{article.story_name}</td>
        <td>{article.type}</td>
        <td>{article.name}</td>
        <td>{article.text}</td>
        <td>{article.created_at}</td>
        <td>{article.updated_at}</td>
        <td>
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
