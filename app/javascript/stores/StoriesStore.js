import axios from 'axios'
import { observable, action } from 'mobx'

class StoriesStore {
  @observable data = [];

  @action fetchStories() {
    axios
      .get('/api/v1/stories')
      .then(response => this.data = response.data)
      .catch(error => console.log(error));
  }
}

export default new StoriesStore()
