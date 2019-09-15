﻿import { createStore, applyMiddleware, compose } from 'redux'
import thunk from 'redux-thunk';
import { routerMiddleware } from 'react-router-redux'
import rootReducer from '../reducers/rootReducer';
import DevTools from '../../dev/DevTools';

const configureStore = (preloadedState, history) => {
    const store = createStore(
      rootReducer,
      preloadedState,
      compose(
        applyMiddleware(thunk),
        applyMiddleware(routerMiddleware(history)),
        DevTools.instrument()
      )
    );

    if (module.hot) {
        // Enable Webpack hot module replacement for reducers
        module.hot.accept('../reducers/rootReducer', () => {
            const nextRootReducer = require('../reducers/rootReducer').default;
            store.replaceReducer(nextRootReducer);
        });
    }

    return store;
};
export default configureStore;