import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types'

import ArticleRow from './ArticleRow'

@observer
export default class Articles extends React.Component {
  componentDidMount() { this.props.store.fetchArticles() }

  renderArticles() {
    return this.props.store.list.map(article => (<ArticleRow key={article.id} article={article} />))
  }

  render() {
    return (
      <div>
        <table>
          <thead>
            <tr>
              <td>Story</td>
              <td>Type</td>
              <td>Name</td>
              <td>Text</td>
              <td>Created</td>
              <td>Updated</td>
              <td>Actions</td>
            </tr>
          </thead>
          <tbody>
            {this.renderArticles()}
          </tbody>
        </table>
      </div>
    );
  }
}

Articles.propTypes = {
  store: PropTypes.object.isRequired,
};
