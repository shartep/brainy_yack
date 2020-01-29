import StoriesApi from '../services/StoriesApi'
import { observable, action } from 'mobx'

class StoriesStore {
  @observable data = [];

  constructor() {
    this.storiesApi = new StoriesApi(this.fetchStories.bind(this))
  }

  fetchStories() {
    this.storiesApi.fetchStories().then(this.replaceData.bind(this))
  }

  replaceData(resp) {
    this.data = [];
    this.setData(resp);
  }

  @action setData(collection) { this.data = collection }
}

export default new StoriesStore()
