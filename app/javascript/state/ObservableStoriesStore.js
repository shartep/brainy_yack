import axios from 'axios'
import { observable, computed, action, reaction, autorun, toJS } from 'mobx'
import _ from 'lodash'

export default class ObservableStoriesStore {
  @observable data = [];

  @action fetchStories() {
    axios
      .get('/api/v1/stories')
      .then(response => this.data = response.data)
      .catch(error => console.log(error));
  }
}
