import React, { Component } from 'react';
import './Login.css';
import { Link, Redirect } from "react-router-dom";
import logo from '../../imagens/LOGO BRANCA.png';
import background from '../../imagens/background.jpg';
import { data } from 'jquery';


class Login extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: {
        "email": "",
        "password": "",
      },
      redirect: false,
      lembrar: false,
      erro: null,
      loading: false,
    }
  }
  exibeErro() {
    const { erro } = this.state;

    if (erro) {
      return (
        <div className="alert alert-danger" role="alert">
          
        </div>
      );
    }
  }

  htmlLogin() {
    return (
      <div className="row no-gutters" id="content">
          
        <div className="col bg-light p-md-0" id="form-login" style={{backgroundImage: 'url('+ background +')'}}>
            <div className="col-sm-10 col-lg-8 col-xl-4">
                
                    {this.loginform()}
                
            </div>
        </div>
      </div>
    );
  }
  loginform(){
    if(this.state.loading === false){
      return(
        <form onSubmit={this.handleSubmit} class="px-sm-5 pb-sm-5">
              <Link className="d-block mb-3" to="/">
                        <i className="fas fa-long-arrow-alt-left mr-2"></i>
                          Voltar
                    </Link>
                    <div className="form-group">
                        <label for="email" >Email</label>
                        <input type="email" id="email" onChange={this.handleInputChange} className="form-control" name="email" required />
                    </div>
                    <div className="form-group">
                        <label for="password" >Senha</label>
                        <input name="password" type="password" id="password" onChange={this.handleInputChange} className="form-control mb-2" required />
                        
                    </div>
                    <button type="submit" className="btn btn-block btn-primary">Logar</button>
                   
                  </form>
      )
    }else{
      return(
        <form onSubmit={null} class="px-sm-5 pb-sm-5">
        <div className="text-center loading">
                    <div className="spinner-border" role="status">
                        <span className="sr-only">Loading...</span>
                    </div>
          </div>
      </form>
      )
      
    }
  }
  handleSubmit = event => {
    this.setState({loading: true});
    console.log(this.state.data);
    
    fetch("https://anorosa.com.br/api/usuario/login", {
      method: "post",
      body: JSON.stringify(this.state.data),
      headers: {
        "Content-Type": "application/json"
      }
    }).then(async token =>{
        this.setState({loading: false});
        if(token.ok){
        var json = await token.json();
        console.log(json.authenticated);
        if(json.authenticated === false){

          window.confirm('Credenciais inválidas');
          
        }else{
          localStorage.setItem("JWT_token",json.access_token);
          this.setState({ redirect: true });
        }
        }else{
          window.confirm('Erro no banco de dados');
          data.json().then(data => {
            if (data.error) {
              this.setState({ erro: data.error });
            }
          });
        }
      })
      .catch(erro => this.setState({ erro: erro }));
    
    event.preventDefault();
  };
  handleInputChange = event => {
    const target = event.target;
    const name = target.name;
    const value = target.value;
    this.setState(prevState => ({
      data: { ...prevState.data, [name]: value }
    }));
   
  };
  render() {
    const { redirect } = this.state;

    if (redirect) {
      return <Redirect to="/Dashboard" />;
    } else {
      return (
        <div>
          {  this.htmlLogin()}
        </div>
      );
    }
  }
}

export default Login;