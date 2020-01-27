import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types'

import ArticleRow from './ArticleRow'
import HeaderCell from './HeaderCell'

@observer
export default class Articles extends React.Component {
  componentDidMount() { this.props.store.fetchArticles() }

  renderArticles() {
    return this.props.store.list.map(article => (<ArticleRow key={article.id} article={article} />))
  }

  render() {
    const store = this.props.store;
    return (
      <div>
        <table>
          <thead>
            <tr>
              <HeaderCell store={store} name='Story' orderKey='story_name' />
              <HeaderCell store={store} name='Type' orderKey='type' />
              <HeaderCell store={store} name='Name' orderKey='name' />
              <HeaderCell store={store} name='Text' orderKey='text' />
              <HeaderCell store={store} name='Created' orderKey='created_at' />
              <HeaderCell store={store} name='Updated' orderKey='updated_at' />
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
  store: PropTypes.object.isRequired
};
