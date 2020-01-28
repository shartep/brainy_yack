import axios from 'axios'
import { observable, computed, action, reaction, toJS } from 'mobx'
import _ from 'lodash'

class ArticlesStore {
  @observable data = {
    group_by: null,
    collection: []
  };
  @observable params = {
    search: null,
    order: {
      field: null,
      direction: null
    },
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
    let params = toJS(this.params);
    params.order_field = params.order.field;
    params.order_direction = params.order.direction;

    return _.pickBy(params, (v, k) => !_.isNil(v) && v !== '' && k !== 'order')
  }

  @action fetchArticles() {
    axios
      .get('/api/v1/articles', {params: this.requestParams})
      .then(response => this.data = response.data)
      .catch(error => console.log(error));
  }
}

export default new ArticlesStore()
