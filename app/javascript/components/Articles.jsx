import React         from 'react'
import { observer }  from 'mobx-react'
import { toJS }      from 'mobx'
import PropTypes     from 'prop-types'
import _             from 'lodash'

import ArticlesGroup from './ArticlesGroup'
import ArticleRow    from './ArticleRow'
import GroupSelect   from './GroupSelect'
import HeaderCell    from './HeaderCell'
import StoryGroup    from './StoryGroup'
import SearchInput   from './SearchInput'

@observer
export default class Articles extends React.Component {
  componentDidMount() { this.props.store.fetchArticles() }

  get data()   { return this.props.store.data }
  get params() { return this.props.store.params }

  renderData() {
    if (this.data.group_by === null) {
      return this.data.collection.map(
        article => (<ArticleRow key={article.id} article={article}/>)
      )
    } else if (this.data.group_by === 'story') {
      return _.map(
        toJS(this.data.collection),
        (storyData, story) => (<StoryGroup key={story} name={story} storyData={storyData} />)
      )
    } else {
      return _.map(
        toJS(this.data.collection),
        (articles, group) => (<ArticlesGroup key={group} name={group} articles={articles} />)
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
