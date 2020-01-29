import axios from 'axios'
import cable from '../channels/consumer'

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

  post(article) { this.subscription.send(article) }
}
