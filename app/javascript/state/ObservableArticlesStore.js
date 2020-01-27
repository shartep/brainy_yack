import axios from 'axios'
import { observable, computed, action, reaction, autorun, toJS } from 'mobx'
import _ from 'lodash'
import ObservableArticle from "./ObservableArticle";


export default class ObservableArticlesStore {
  @observable list = [];
  @observable params = {
    order_field: null,
    order_direction: null
  };

  constructor() {
    this.subscribeParamsChanged();
  }

  subscribeParamsChanged() {
    reaction(
      () => this.requestParams,
      () => this.fetchArticles()
    );
  }

  @computed get requestParams() {
    return _.pickBy(toJS(this.params), (v) => !_.isNil(v))
  }

  @action fetchArticles() {
    axios
      .get('/api/v1/articles', {params: this.requestParams})
      .then(
        response =>
          this.list = response.data.articles.map(
            article => new ObservableArticle(this, article)
          )
      );
  }
}
