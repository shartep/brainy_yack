import axios from 'axios'
import { observable, action } from 'mobx'


export default class ObservableArticle {
  @observable article = null;

  constructor(store, article) {
    this.store = store;
    this.article = article;
  }

  get id() { return this.article.id }
  get story_name() { return this.article.story_name }
  get type() { return this.article.type }
  get name() { return this.article.name }
  get text() { return this.article.text }
  get created_at() { return this.article.created_at }
  get updated_at() { return this.article.updated_at }

  @action
  destroy() {
    axios.delete(`/api/v1/articles/${this.article.id}`).then(() => this.store.fetchArticles())
  }
}
