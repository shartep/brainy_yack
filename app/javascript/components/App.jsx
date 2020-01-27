import React from 'react'
import { Route, Switch } from 'react-router-dom'

import Home from './Home'
import Articles from './Articles'
import Stories from './Stories'
import ObservableArticlesStore from "../state/ObservableArticlesStore";

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
