import axios from 'axios'
import { observable, computed, action, reaction, autorun } from 'mobx'
import ObservableArticle from "./ObservableArticle";


export default class ObservableArticlesStore {
  @observable list = [];

  @action fetchArticles() {
    axios
      .get('/api/v1/articles')
      .then(
        response =>
          this.list = response.data.articles.map(
            article => new ObservableArticle(this, article)
          )
      );
  }
}
