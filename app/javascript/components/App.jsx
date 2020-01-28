import React                   from 'react'
import { Route, Switch }       from 'react-router-dom'
import { library }             from '@fortawesome/fontawesome-svg-core'
import {
  faTrash, faSort, faSortUp, faSortDown, faEdit, faSave
} from '@fortawesome/free-solid-svg-icons'

import Articles                from './Articles'
import Home                    from './Home'
import ObservableArticlesStore from '../state/ObservableArticlesStore'
import Stories                 from './Stories'

library.add(faTrash, faSort, faSortUp, faSortDown, faEdit, faSave);

const App = props => (
  <div>
    <Switch>
      <Route exact path="/" component={Home} />
      <Route exact path="/articles" render={() => <Articles store={new ObservableArticlesStore()}/>} />
      <Route exact path="/stories" component={Stories} />
    </Switch>
  </div>
);

export default App
