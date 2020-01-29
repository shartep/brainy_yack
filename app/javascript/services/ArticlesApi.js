import axios from 'axios'
// import _     from 'lodash'
import cable from '../channels/consumer'
// import { observable, computed, action, reaction, toJS } from 'mobx'

export default class ArticlesApi {
  constructor(callback) {
    this.subscription = cable.subscriptions.create('ArticlesChannel', {received: callback});
  }

  fetchArticles(params) {
    return axios
            .get('/api/v1/articles', {params: params})
            .then(response => response.data)
            .catch(error => console.log(error));
  }

  post(article) {
    this.subscription.send(article)
  }
}
