import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import { routerMiddleware } from 'react-router-redux';
import rootReducer from '../reducers/rootReducer';

const configureStore = (preloadedState, history) => createStore(
  rootReducer,
  preloadedState,
  compose(
    applyMiddleware(thunk),
    applyMiddleware(routerMiddleware(history))
  )
);

export default configureStore;