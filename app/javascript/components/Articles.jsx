import React from 'react'
import { observer } from 'mobx-react'
import { toJS } from 'mobx'
import PropTypes from 'prop-types'
import _ from 'lodash'

import ArticleRow from './ArticleRow'
import HeaderCell from './HeaderCell'
import GroupSelect from './GroupSelect'
import ArticlesGroup from './ArticlesGroup'
import StoryGroup from './StoryGroup'

@observer
export default class Articles extends React.Component {
  componentDidMount() { this.props.store.fetchArticles() }

  renderData() {
    if (this.props.store.data.group_by === null) {
      return this.props.store.data.collection.map(article => (
        <ArticleRow key={article.id} article={article}/>))
    } else if (this.props.store.data.group_by === 'story') {
      return _.map(toJS(this.props.store.data.collection), (storyData, story) => (<StoryGroup key={story} name={story} storyData={storyData} />))
    } else {
      return _.map(toJS(this.props.store.data.collection), (articles, group) => (<ArticlesGroup key={group} name={group} articles={articles} />))
    }
  }

  render() {
    const store = this.props.store;
    return (
      <div>
        <GroupSelect store={store}/>
        <br/>
        <br/>
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
            {this.renderData()}
          </tbody>
        </table>
      </div>
    );
  }
}

Articles.propTypes = {
  store: PropTypes.object.isRequired
};
