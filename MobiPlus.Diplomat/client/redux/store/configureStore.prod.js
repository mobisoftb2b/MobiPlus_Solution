import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import rootReducer from '../reducers/rootReducer';
import { loadingBarMiddleware } from 'react-redux-loading-bar'

//const configureStore = preloadedState => createStore(
//  rootReducer,
//  preloadedState,
//  applyMiddleware(thunk)
//);

const configureStore = preloadedState => {
    const store = createStore(
      rootReducer,
      preloadedState,      
      applyMiddleware(thunk, loadingBarMiddleware())
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