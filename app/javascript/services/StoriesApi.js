import axios from 'axios'
import cable from '../channels/consumer'

export default class StoriesApi {
  modelPath = '/api/v1/stories';

  constructor(callback) {
    this.subscription = cable.subscriptions.create('StoriesChannel', {received: callback});
  }

  fetchStories() {
    return axios
            .get(this.modelPath)
            .then(response => response.data)
            .catch(error => console.log(error));
  }

  post(story) { this.subscription.send(story) }
}
