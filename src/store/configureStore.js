import { createStore, applyMiddleware, compose } from 'redux'
import { createLogger } from 'redux-logger'
import promise from 'redux-promise'
import rootReducer from './reducers'

const loggerMiddleware = createLogger()
const middleware = [promise]

// For Redux Dev Tools
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose

export default function configureStore(preloadedState) {
  return createStore(
    rootReducer,
    preloadedState,
    composeEnhancers(applyMiddleware(...middleware, loggerMiddleware))
  )
}
