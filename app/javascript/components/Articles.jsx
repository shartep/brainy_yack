import React                 from 'react'
import { observer, inject }  from 'mobx-react'
import { toJS }              from 'mobx'
import _                     from 'lodash'

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

  get data()    { return this.props.articlesStore.data }
  get params()  { return this.props.articlesStore.params }

  renderData() {
    if (this.data.group_by === null) {
      return this.data.collection.map(
        article => (<ArticleRow key={article.id} article={article}/>)
      )
    } else if (this.data.group_by === 'story') {
      return _.map(
        toJS(this.data.collection),
        (storyData, story) => (<StoryGroup key={story} name={story} storyData={storyData}/>)
      )
    } else {
      return _.map(
        toJS(this.data.collection),
        (articles, group) => (<ArticlesGroup key={group} name={group} articles={articles}/>)
      )
    }
  }

  render() {
    return (
      <>
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
      </>
    );
  }
}
