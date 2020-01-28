import React        from 'react'
import { observer } from 'mobx-react'
import PropTypes    from 'prop-types'
import ArticleRow   from './ArticleRow'

@observer
export default class ArticlesGroup extends React.Component {
  render() {
    return (
      <>
        <tr><td><h1>{this.props.name}</h1></td></tr>
        {
          this.props.articles.map(article => (
            <ArticleRow key={article.id} article={article} stories={this.props.stories}/>)
          )
        }
      </>
    );
  }
}

ArticlesGroup.propTypes = {
  name: PropTypes.string.isRequired,
  articles: PropTypes.array.isRequired,
  stories: PropTypes.array.isRequired
};
