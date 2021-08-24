import React, { Component } from 'react'; //Importa o método componente e react
import './Categorias.css';
import teste from '../../../imagens/teste.jpeg';

import DataTable from 'react-data-table-component';

class EmpresaIndex extends Component {
    constructor(props) {
        super(props);
        this.state = {
            empresa: [],
            isApiRequested: false,
            type: null,
            selectedItemId: null,
            selectedItem: {
                nomeempresa: null,
                cnpj: null
            },
            editEmpresa: {

            },
            addEmpresa: {},
            addInputError: {
                nomeempresa: null,
                cnpj: null
            },
            editInputError: {
                nomeempresa: null,
                cnpj: null
            },
        }
    }
    componentDidMount() {

        const requestOptions = {
            method: 'get',
        };
        fetch("http://anorosa.com.br/api/empresa/list", requestOptions)
            .then(data => data.json().then(data => {
                console.log(data);
                this.setState({ empresa: data.data, isApiRequested: true });
            }))
            .catch(erro => this.setState(erro))
    }

    //BOTÕES DE AÇÕES DA LINHA
    actionsButtons(id, object) {
        return <div className="btn-group dropleft">
            <button type="button" className="btn dropdown-toggle no-arrow" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i className="fas fa-ellipsis-v"></i>
            </button>
            <div className="dropdown-menu shadow-sm">
                <button onClick={() => { this.setState({ selectedItem: object }) }} type="button" className="dropdown-item" data-toggle="modal" data-target="#update_category_form">Editar</button>
                <button onClick={() => { this.setState({ selectedItemId: id, selectedItem: object }) }} type="button" className="dropdown-item" data-toggle="modal" data-target="#delete_category_form">Deletar</button>
            </div>
        </div>
    }
    dataTable() {
        var data = [];
        if (this.state.isApiRequested) {
            var empresa = this.state.empresa;
            for (var i = 0; i < empresa.length; i++) {
                empresa[i]['acoes'] = this.actionsButtons(empresa[i].id, empresa[i]);
            }
            data = empresa;
        }
        const columns = [
            {
                name: 'Nome',
                selector: 'nomeempresa',
                sortable: true,
            },
            {
                name: 'CNPJ',
                selector: 'cnpj',
                sortable: true,
            },
            {
                name: 'Data de cadastro',
                selector: 'created_at',
                sortable: true,
            },
            {
                name: 'Ações',
                selector: 'acoes',
            },
        ];
        //BOTÕES DE AÇÃO DO CABEÇALHO
        const actions = <button type="button" className="btn btn-primary my-3 my-sm-0" data-toggle="modal" data-target="#add_category_form"><i className="fas fa-plus mr-2"></i> Novo</button>


        //ELEMENTO DE EXPANSÃO DA LINHA
        /* const ExpandableComponent = ({ data }) =>
             <div className="p-3 bg-light">
                 <label className="small d-block mb-2">Icone</label>
                 <img className="category-icon img-thumbnail" src={"http://anorosa.com.br/Emporio037/storage/" + data.img} />
             </div>;*/

        return <DataTable
            title="Empresas cadastradas"
            pagination={true}
            actions={actions}
            columns={columns}
            data={data}
        /* expandableRows
         expandableRowsComponent={<ExpandableComponent />} */
        />
    }


    render() {//Aqui acontece a renderização da página

        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Empresas</h1>
                    <p className="dashboard-page-title-desc">Cadastre, atualiza ou remova as empresas de consultoria médica.</p>
                </div>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body">
                                    {this.dataTable()}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {/*   MODAL DE CADASTRO */}
                <div className="modal fade" id="add_category_form" tabIndex="-1" >
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-body">
                                <h5 className="modal-title mb-4">Cadastrar empresa</h5>
                                <form action="">
                                    <div className="form-group row">
                                        <label htmlFor="add_nome" className="col-sm-2 col-form-label">Nome da Empresa</label>
                                        <div className="col-sm-10">
                                            <input type="text" onChange={this.cadastrarInputChange} name="nomeempresa" className="form-control" id="add_nome" />
                                            <span className="error">{this.state.addInputError.nomeempresa}</span>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="add_nome" className="col-sm-2 col-form-label">Cnpj</label>
                                        <div className="col-sm-10">
                                            <input type="text" onChange={this.cadastrarInputChange} name="cnpj" className="form-control" id="add_nome" />
                                            <span className="error">{this.state.addInputError.cnpj}</span>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div className="modal-footer">
                                <button onClick={() => this.setState({ addInputError: { nomeempresa: null, cnpj: null } })} type="button" className="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                                <button type="button" onClick={this.cadastrarEmpresa} className="btn btn-primary">Cadastrar</button>
                            </div>
                        </div>
                    </div>
                </div>


                {/*   MODAL DE ATUALIZAÇÃO */}
                <div className="modal fade" id="update_category_form" tabIndex="-1" >
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-body">
                                <h5 className="modal-title mb-4">Atualizar Empresa</h5>
                                <form action="">
                                    <div className="form-group row">
                                        <label htmlFor="update_nome" className="col-sm-2 col-form-label">Nome</label>
                                        <div className="col-sm-10">
                                            <input type="text" onChange={this.editarInputChange} id="update_nome" name="nomeempresa" placeholder={this.state.selectedItem.nomeempresa} className="form-control" />
                                            <span className="error">{this.state.editInputError.nomeempresa}</span>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="update_nome" className="col-sm-2 col-form-label">cnpj</label>
                                        <div className="col-sm-10">
                                            <input type="text" onChange={this.editarInputChange} id="update_nome" name="cnpj" placeholder={this.state.selectedItem.cnpj} className="form-control" />
                                            <span className="error">{this.state.editInputError.cnpj}</span>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div className="modal-footer">
                                <button onClick={() => {
                                    this.setState({
                                        selectedItem: {
                                            nomecategoria: null,
                                            img: null
                                        },
                                        editEmpresa: {
                                            nomeempresa: null,
                                            cnpj: null
                                        }
                                    })
                                }} type="button" className="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                                <button onClick={this.editarEmpresa} type="button" className="btn btn-primary">Editar</button>
                            </div>
                        </div>
                    </div>
                </div>

                {/*   MODAL DELETE */}
                <div className="modal fade" id="delete_category_form" tabIndex="-1">
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-body  p-5">
                                <div className="d-flex align-items-center flex-column">
                                    <div className="row mb-4 mb-sm-5">
                                        <div className="col-sm-auto">
                                            <div className="modal-icon mb-3 mb-sm-0">
                                                <i className="fas fa-exclamation"></i>
                                            </div>
                                        </div>
                                        <div className="col">
                                            <h5 className="modal-title mb-2">Atenção</h5>
                                            <p className="mb-2">Tem certeza que deseja <strong>deletar a empresa {this.state.selectedItem.nomeempresa}</strong>? Essa operação é irreversível.</p>
                                            <span className="text-muted small">Todos médicos pertencentes a essa empresa também serão deletados.</span>
                                        </div>
                                    </div>
                                </div>
                                <div className="form-row justify-content-center ">
                                    <div className="col-sm-4 mb-3 mb-sm-0">
                                        <button onClick={() => this.setState({
                                            selectedItemId: null, selectedItem: {
                                                nomeempresa: null,
                                                cnpj: null
                                            }
                                        })} type="button" className="btn btn-block btn-outline-secondary btn-lg" data-dismiss="modal">Cancelar</button>
                                    </div>
                                    <div className="col-sm-4">
                                        <button onClick={() => {
                                            const token = localStorage.getItem("JWT_token");
                                            fetch("https://anorosa.com.br/api/empresa/delete/" + this.state.selectedItemId, {
                                                method: "delete",
                                                headers: {
                                                    "Content-Type": "application/json",
                                                    "Authorization": "Bearer " + token
                                                }
                                            })
                                                .then(data => data.json().then(data => {
                                                    console.log(data);
                                                    alert("Deletado com sucesso");
                                                    window.location.reload();
                                                }))
                                                .catch(erro => this.setState(erro));
                                        }} type="button" className="btn btn-block btn-danger btn-lg">Deletar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    cadastrarInputChange = event => {
        const target = event.target;
        const name = target.name;
        const value = target.value;
        this.setState(prevState => ({
            addEmpresa: { ...prevState.addEmpresa, [name]: value }
        }));
    };
    cadastrarEmpresa = event => {
        const token = localStorage.getItem("JWT_token")
        console.log(token);
        console.log(JSON.stringify(this.state.addEmpresa));
        fetch("http://anorosa.com.br/api/empresa/add", {
            method: "post",
            body: JSON.stringify(this.state.addEmpresa),
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            }
        }).then(data => data.json().then(data => {
            if (data.status !== true) {
                if (data.error === 1) {//Input error code
                    this.setState({ addInputError: data.errors })
                } else {
                    alert(data.error)
                }
            } else {
                this.setState({
                    addInputError: {
                        nomeempresa: null,
                        cnpj: null
                    }
                })
                window.location.reload();
            }
        })).catch(erro => this.setState({ erro: erro }));
        event.preventDefault();
    }


    editarInputChange = event => {
        const target = event.target;
        const name = target.name;
        const value = target.value;
        this.setState(prevState => ({
            editEmpresa: { ...prevState.editEmpresa, [name]: value }
        }));
    };

    editarEmpresa = event => {
        const token = localStorage.getItem("JWT_token");
        var json = this.state.editEmpresa;

        console.log(json);
        fetch("https://anorosa.com.br/api/empresa/update/" + this.state.selectedItem.id, {
            method: "put",
            body: JSON.stringify(json),
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            }
        })
            .then(data => data.json().then(data => {
                if (data.status !== true) {
                    if (data.error === 1) {//Input error code
                        this.setState({ editInputError: data.errors })
                    } else {
                        alert(data.error)
                    }
                } else {
                    this.setState({
                        editInputError: {
                            nomecategoria: null,
                            img: null
                        }

                    });
                    window.location.reload();
                }
            })).catch(erro => this.setState({ erro: erro }));
        event.preventDefault();
    };
}
export default EmpresaIndex; //Aqui retorna o componente