import React from 'react'
import { observer } from "mobx-react"
import PropTypes from "prop-types";

@observer
export default class ArticleRow extends React.Component {
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
          <a href="#" onClick={article.destroy}>Delete</a>
        </td>
      </tr>
    );
  }
}

ArticleRow.propTypes = {
  article: PropTypes.object.isRequired,
};
