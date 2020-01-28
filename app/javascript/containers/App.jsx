import React             from 'react'
import { Route, Switch } from 'react-router-dom'
import { Provider }      from 'mobx-react';
import { library }       from '@fortawesome/fontawesome-svg-core'
import {
  faTrash, faSort, faSortUp, faSortDown, faEdit, faSave
} from '@fortawesome/free-solid-svg-icons'

import Home              from '../components/Home'
import Articles          from '../components/Articles'
import Stories           from '../components/Stories'

import articlesStore     from '../stores/ArticlesStore'
import storiesStore      from '../stores/StoriesStore'

library.add(faTrash, faSort, faSortUp, faSortDown, faEdit, faSave);

const App = props => (
  <Provider articlesStore={articlesStore} storiesStore={storiesStore}>
    <Switch>
      <Route exact path="/" component={Home} />
      <Route exact path="/articles" component={Articles} />
      <Route exact path="/stories" component={Stories} />
    </Switch>
  </Provider>
);

export default App
