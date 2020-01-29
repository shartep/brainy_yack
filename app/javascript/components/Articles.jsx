import React                from 'react'
import { computed, toJS }   from 'mobx'
import _                    from 'lodash'
import { observer, inject } from 'mobx-react'

import ArticlesGroup from './ArticlesGroup'
import ArticleRow    from './ArticleRow'
import GroupSelect   from './GroupSelect'
import HeaderCell    from './HeaderCell'
import NewArticle    from './NewArticle'
import StoryGroup    from './StoryGroup'
import SearchInput   from './SearchInput'

@inject('articlesStore', 'storiesStore')

@observer
export default class Articles extends React.Component {
  componentDidMount() {
    this.props.articlesStore.fetchArticles();
    this.props.storiesStore.fetchStories();
  }

  @computed get groupBy()    { return this.props.articlesStore.groupBy }
  @computed get collection() { return this.props.articlesStore.collection }
  @computed get params()     { return this.props.articlesStore.params }

  renderData() {
    if (this.groupBy === null) {
      return this.collection.map(
        article => (<ArticleRow key={article.id} article={article}/>)
      )
    } else if (this.groupBy === 'story') {
      return _.map(
        toJS(this.collection),
        (storyData, story) => (<StoryGroup key={story} name={story} storyData={storyData}/>)
      )
    } else {
      return _.map(
        toJS(this.collection),
        (articles, group) => (<ArticlesGroup key={group} name={group} articles={articles}/>)
      )
    }
  }

  render() {
    return (
      <div>
        <NewArticle />
        <br/>
        <SearchInput />
        <GroupSelect />
        <br/>
        <br/>
        <table>
          <thead>
            <tr>
              <HeaderCell name='Story'   orderKey='story_name' />
              <HeaderCell name='Type'    orderKey='type' />
              <HeaderCell name='Name'    orderKey='name' />
              <HeaderCell name='Text'    orderKey='text' />
              <HeaderCell name='Created' orderKey='created_at' />
              <HeaderCell name='Updated' orderKey='updated_at' />
              <td>Actions</td>
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
