import React         from 'react'
import { observer }  from 'mobx-react'
import { toJS }      from 'mobx'
import PropTypes     from 'prop-types'
import _             from 'lodash'

import ArticlesGroup from './ArticlesGroup'
import ArticleRow    from './ArticleRow'
import GroupSelect   from './GroupSelect'
import HeaderCell    from './HeaderCell'
import NewArticle    from './NewArticle'
import StoryGroup    from './StoryGroup'
import SearchInput   from './SearchInput'

@observer
export default class Articles extends React.Component {
  componentDidMount() {
    this.props.store.fetchArticles();
    this.props.storiesStore.fetchStories();
  }

  get stories() { return this.props.storiesStore.data }
  get data()    { return this.props.store.data }
  get params()  { return this.props.store.params }

  renderData() {
    if (this.data.group_by === null) {
      return this.data.collection.map(
        article => (<ArticleRow key={article.id} article={article} stories={this.stories}/>)
      )
    } else if (this.data.group_by === 'story') {
      return _.map(
        toJS(this.data.collection),
        (storyData, story) => (<StoryGroup key={story} name={story} storyData={storyData} stories={this.stories}/>)
      )
    } else {
      return _.map(
        toJS(this.data.collection),
        (articles, group) => (<ArticlesGroup key={group} name={group} articles={articles} stories={this.stories}/>)
      )
    }
  }

  render() {
    let params = this.params;
    return (
      <div>
        <SearchInput params={params} />
        <GroupSelect params={params} />
        <br/>
        <br/>
        <table>
          <thead>
            <tr>
              <HeaderCell params={params} name='Story' orderKey='story_name' />
              <HeaderCell params={params} name='Type' orderKey='type' />
              <HeaderCell params={params} name='Name' orderKey='name' />
              <HeaderCell params={params} name='Text' orderKey='text' />
              <HeaderCell params={params} name='Created' orderKey='created_at' />
              <HeaderCell params={params} name='Updated' orderKey='updated_at' />
              <td>Actions</td>
            </tr>
          </thead>
          <tbody>
            <NewArticle stories={this.stories}/>
            {this.renderData()}
          </tbody>
        </table>
      </div>
    );
  }
}

Articles.propTypes = {
  store: PropTypes.object.isRequired,
  storiesStore: PropTypes.object.isRequired
};
