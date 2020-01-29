import axios from 'axios'
import cable from '../channels/consumer'

export default class ArticlesApi {
  modelPath = '/api/v1/articles';

  constructor(callback) {
    this.subscription = cable.subscriptions.create('ArticlesChannel', {received: callback});
  }

  fetchArticles(params) {
    return axios
            .get(this.modelPath, {params: params})
            .then(response => response.data)
            .catch(error => console.log(error));
  }

  create(article) {
    return axios.post(this.modelPath, article)
                .then(response => response.data)
                .catch(this.errorHandler);
  }

  update(article) {
    return axios.patch(`${this.modelPath}/${article.id}`, article)
                .then(response => response.data)
                .catch(this.errorHandler);
  }

  destroy(articleId) {
    return axios.delete(`${this.modelPath}/${articleId}`)
                .then(response => response.data)
                .catch(this.errorHandler);
  }

  errorHandler(error) {
    console.log(error);
    alert(error.response.data.errors);
  }
}
