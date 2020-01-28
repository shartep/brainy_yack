import React from 'react'
import { observer } from "mobx-react"
import PropTypes from "prop-types";
import ArticleRow from "./ArticleRow";

@observer
export default class StoryGroup extends React.Component {
  render() {
    const storyData = this.props.storyData;
    return (
      <>
        <tr>
          <td><h2>{this.props.name}</h2></td>
          <td>Articles count: {storyData.article_count}</td>
          <td>Articles types count: {storyData.article_type_count}</td>
        </tr>
        <ArticleRow key={storyData.article.id} article={storyData.article}/>
      </>
    );
  }
}

StoryGroup.propTypes = {
  name: PropTypes.string.isRequired,
  storyData: PropTypes.object.isRequired
};
