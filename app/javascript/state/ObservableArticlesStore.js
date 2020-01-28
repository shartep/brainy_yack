import axios from 'axios'
import { observable, computed, action, reaction, autorun, toJS } from 'mobx'
import _ from 'lodash'

export default class ObservableArticlesStore {
  @observable data = {
    group_by: null,
    collection: []
  };
  @observable params = {
    order_field: null,
    order_direction: null,
    grouped_by: null
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
    return _.pickBy(toJS(this.params), (v) => !_.isNil(v) && v !== '')
  }

  @action fetchArticles() {
    axios
      .get('/api/v1/articles', {params: this.requestParams})
      .then(response => this.data = response.data)
      .catch(error => console.log(error));
  }
}
