import React from 'react';
import './App.css';



import Login from './component/Login/Login';
import Dashboard from './component/dashboard/Dashboard';


import { Switch, Route } from 'react-router-dom';




function App() {
  return (
    <div className="corpo">
     
      <Switch>
          <Route path="/" exact component={Login} />
          <Route path="/dashboard" exact component={Dashboard} />
          <Route path="/dashboard/empresas" exact component={Dashboard} />
          <Route path="/dashboard/medico/create" exact component={Dashboard} />
          <Route path="/dashboard/medico/edit" exact component={Dashboard} />
          <Route path="/dashboard/medicos" exact component={Dashboard} />

          <Route path="/dashboard/info/create" exact component={Dashboard} />
          <Route path="/dashboard/info/edit" exact component={Dashboard} />
          <Route path="/dashboard/informacoes" exact component={Dashboard}/>

          <Route path="/dashboard/formularios" exact component={Dashboard}/>
          <Route path="/dashboard/formu/create" exact component={Dashboard}/>
          <Route path="/dashboard/formu/edit" exact component={Dashboard}/>

          <Route path="/dashboard/imagensDestaque" exact component={Dashboard} />
          <Route path="/dashboard/imagensDestaque/create" exact component={Dashboard} />
          
      </Switch>
    </div>
  );
}

export default App;
