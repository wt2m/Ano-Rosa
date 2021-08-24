import React, { Component } from 'react'; //Importa o método componente e react

import ImagensCreate from './ImagensDestaque/ImagensCreate';
import ImagensIndex from './ImagensDestaque/ImagensIndex';
import './Dashboard.css';
import { Switch, Route, Redirect } from 'react-router-dom';
import { Link } from 'react-router-dom';

import logo from '../../imagens/LOGO BRANCA.png';
import MedicoIndex from './Medicos/MedicoIndex';
import MedicoCreate from './Medicos/MedicoCreate';
import MedicoUpdate from './Medicos/MedicoUpdate';
import EmpresaIndex from './Empresas/EmpresaIndex';
import InformacoesIndex from './Informacoes/InformacoesIndex';
import InformacoesCreate from './Informacoes/InfoCreate';
import InformacoesUpdate from './Informacoes/InfoUpdate';
import FormularioIndex from './Formularios/FormuIndex';
import FormularioCreate from './Formularios/FormuCreate';
import FormularioEdit from './Formularios/FormuEdit';

class Dashboard extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isApiRequested: false,
            type: null,
            admin: null,
            menulateral: "active",
        }
    }
    componentDidMount() {
        const token = localStorage.getItem("JWT_token");
        console.log(token);
        if (token !== null) {
            const requestOptions = {
                method: 'POST',
                headers: { 'Authorization': 'Bearer ' + token },
            };
            fetch("https://anorosa.com.br/api/usuario/logado", requestOptions)
                .then(data => data.json().then(data => {
                    this.setState({ type: data.type, admin: data, isApiRequested: true });
                }))
                .catch(erro => this.setState(erro))
        } else {
            this.setState({ type: 0, isApiRequested: true });
        }
    }//
    validateAccType() {
        if (this.state.isApiRequested) {
            if (this.state.type === 1) {
                return (
                    <div>
                        <div id="sidebar" className={this.state.menulateral}>
                            <div className="row justify-content-center">
                                <div className="col-sm-8 col-md-12">
                                    <img src={logo} id="sidebar-logo" alt="Logo Ano Rosa" />
                                    <span className="nav-link section-link mb-4">
                                        <i className="fas fa-tachometer-alt mr-3"></i>
                                        Painel de controle
                                    </span>
                                    <p className="sidebar-section-title">GERENCIAR</p>
                                    <ul className="nav flex-column mb-4">
                                        <li className="nav-item">
                                            <Link to={`/dashboard/empresas`} className="nav-link section-link">
                                                <i className="fas fa-building mr-3"></i>
                                                Empresas
                                            </Link>
                                        </li>
                                        <li className="nav-item">
                                            <Link to={`/dashboard/medicos`} className="nav-link section-link">
                                                <i className="fas fa-user-md mr-3"></i>
                                                Médicos
                                            </Link>
                                        </li>
                                        <p className="sidebar-section-title">ADMINISTRAR</p>
                                        <li className="nav-item">
                                            <Link to={`/dashboard/formularios`} className="nav-link section-link">
                                                <i className="fas fa-list mr-3"></i>
                                            Formulários
                                            </Link>

                                        </li>
                                        <li className="nav-item">
                                            <Link to={`/dashboard/informacoes`} className="nav-link section-link">
                                                <i class="far fa-newspaper mr-3"></i>
                                                Informações
                                            </Link>
                                        </li>

                                        {/*   
                                    </ul>
                                    <p className="sidebar-section-title">ADMINISTRAR</p>
                                    <ul className="nav flex-column mb-0">
                                        <li className="nav-item">
                                            <a href="#" className="nav-link section-link">
                                                <i className="fas fa-tags mr-3"></i>
                                                Promoções
                                            </a>
                                        </li>
                                        <li className="nav-item">
                                            <a href="#" className="nav-link section-link">
                                                <i className="fas fa-eye mr-3"></i>
                                                Destaques
                                            </a>
                                        </li>
                                        <li className="nav-item">
                                            <Link to={`/dashboard/imagensDestaque`} className="nav-link section-link">
                                                <i className="fas fa-images mr-3"></i>
                                        Imagens em destaque
                                    </Link>
                                    </li*/}
                                    </ul>
                                    <button onClick={() => this.setState({ menulateral: null })} id="sidebarCollapse2" type="button" className="center-button dashboard-collapse-button d-md-none">
                                        <i className="fas fa-chevron-left"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div id="dashboard-content">
                            <div id="dashboard-topbar" className="px-md-5">
                                <div className="flex-between justify-content-md-end">
                                    <button onClick={() => this.setState({ menulateral: "active" })} id="sidebarCollapse" type="button" className="dashboard-collapse-button d-md-none">
                                        <i className="fa fa-bars"></i>
                                    </button>
                                    {this.state.admin !== null
                                        ? <div className="dropdown">
                                            <button className="btn dropdown-toggle" type="button" id="user-menu" data-toggle="dropdown">
                                                {this.state.admin.nome}
                                            </button>
                                            <div className="dropdown-menu" aria-labelledby="user-menu">
                                                <a className="dropdown-item" href="#">Minha conta</a>
                                                <a className="dropdown-item" href="#">Configurações</a>
                                                <div className="dropdown-divider"></div>
                                                <a className="dropdown-item" href="#">Sair</a>
                                            </div>
                                        </div>
                                        : null
                                    }
                                </div>
                            </div>

                            <Switch>
                                <Route path="/dashboard/empresas" exact component={EmpresaIndex} />
                                <Route path="/dashboard/medico/create" exact component={MedicoCreate} />
                                <Route path="/dashboard/medico/edit" exact component={MedicoUpdate} />
                                <Route path="/dashboard/medicos" exact component={MedicoIndex} />

                                <Route path="/dashboard/informacoes" exact component={InformacoesIndex} />
                                <Route path="/dashboard/info/create" exact component={InformacoesCreate} />
                                <Route path="/dashboard/info/edit" exact component={InformacoesUpdate} />

                                <Route path="/dashboard/formularios" exact component={FormularioIndex} />
                                <Route path="/dashboard/formu/create" exact component={FormularioCreate} />
                                <Route path="/dashboard/formu/edit" exact component={FormularioEdit} />

                                <Route path="/dashboard/imagensDestaque" exact component={ImagensIndex} />
                                <Route path="/dashboard/imagensDestaque/create" exact component={ImagensCreate} />
                            </Switch>
                        </div>
                    </div>
                );
            } else {
                var confirm = window.confirm("Acesse como administrador para ter acesso a esta página.")
                if (confirm) {
                    return <Redirect to="/" />;
                }
                /* return (
                     <p>Você não tem acesso a essa página :(</p>
                 )*/
            }
        } else {
            return (
                <div>
                    <div className="text-center">
                        <div className="spinner-border" role="status">
                            <span className="sr-only">Loading...</span>
                        </div>
                    </div>
                </div>
            );
        }
    }
    render() {//Aqui acontece a renderização da página
        return (
            <div>
                {this.validateAccType()}
            </div>
        );
    }
}
export default Dashboard; //Aqui retorna o componente
