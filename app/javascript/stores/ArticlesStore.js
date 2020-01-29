import _ from 'lodash'
import ArticlesApi from '../services/ArticlesApi'
import { observable, computed, action, reaction, toJS } from 'mobx'

class ArticlesStore {
  @observable groupBy = null;
  @observable collection = [];
  @observable params = {
    search: null,
    order_field: null,
    order_direction: null,
    grouped_by: null
  };

  constructor() {
    this.subscribeParamsChanged();
    this.articlesApi = new ArticlesApi(this.fetchArticles.bind(this));
  }

  subscribeParamsChanged() {
    reaction(
      () => this.requestParams,
      () => this.fetchArticles()
    );
  }

  @computed get requestParams() {
    return _.pickBy(toJS(this.params), (v, k) => !_.isNil(v) && v !== '')
  }

  @action setOrder(field, direction) {
    this.params.order_field = field;
    this.params.order_direction = direction;
  }

  fetchArticles() {
    this.articlesApi.fetchArticles(this.requestParams).then(this.replaceData.bind(this))
  }

  replaceData(resp) {
    this.collection = [];
    this.setData(resp.group_by, resp.collection);
  }

  @action setData(groupBy, collection) {
    this.groupBy = groupBy;
    this.collection = collection;
  }

  addArticle(article) {
    this.articlesApi.post({action: 'create', ...article})
  }

  updateArticle(article) {
    this.articlesApi.post({action: 'update', ...article})
  }

  deleteArticle(articleId) {
    this.articlesApi.post({action: 'destroy', id: articleId})
  }
}

export default new ArticlesStore()
