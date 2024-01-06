import React from 'react';
import ReactDOM from 'react-dom';

import MyFirstComponent from './components/MyFirstComponent';

export default function renderApp(element) {
  ReactDOM.render(<MyFirstComponent />, element);
}
