import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import vodka from '../../../imagens/vodka2.png';
import DataTable from 'react-data-table-component';
import './Medicos.css'


class MedicoIndex extends Component {
    constructor(props) {
        super(props);
        this.state = {
            empresa: [],
            med: [],
            isApiRequested: false,
            selectedItemId: null,
            selectedItem: {},
            status: false,
            loading: false,
            selectedCompanyId: 0,
            title: 0,
        }
    }
    componentDidMount() {

        const requestOptions = {
            method: 'get',
        };
        fetch("http://anorosa.com.br/api/empresa/list", requestOptions)
            .then(data => data.json().then(data => {
                console.log(data);
                this.setState({ status: data.status })
                if (data.status) {
                    this.setState({ empresa: data.data, isApiRequested: true });
                }
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
                    <Link  to={
                     {     
                       pathname: "/dashboard/medico/edit",
                       state: {
                           id: id,
                           company:this.state.empresa,
                           selectedCompanyId: this.state.selectedCompanyId,
                        }
                      }
                    }
                    >Edit</Link>
                <button onClick={() => this.setState({ selectedItemId: id, selectedItem: object })} type="button" className="dropdown-item" data-toggle="modal" data-target="#delete_product_form">Deletar</button>
            </div>
        </div>
    }
    
    dataTable() {

        var data = [];

        var medico = this.state.med;
        if (medico.length !== 0) {
            for (var i = 0; i < medico.length; i++) {
                if (medico[i]['quantavaliacao'] === 0) {
                    medico[i]['avaliacaofinal'] = 0;
                } else {
                    medico[i]['avaliacaofinal'] = medico[i]['avaliacaototal'] / medico[i]['quantavaliacao'];
                }
                medico[i]['acoes'] = this.actionsButtons(medico[i].id, medico[i]);
            }
            data = medico;
        }



        //BOTÕES DE CADASTRP
        const actions = [
            <div class="index-action">
                <select onChange={this.handleSelect} id="inputState" class="form-control ">
                    <option defaultValue="0">Escolha uma empresa</option>
                    {this.empresaMap()}
                </select>
            </div>,
            <Link  to={
                     {     
                       pathname: "/dashboard/medico/create",
                       state: {
                           company:this.state.empresa,
                           selectedCompanyId: this.state.selectedCompanyId
                        }
                      }
                    }className="btn btn-primary table-action"><i className="fas fa-plus mr-2"></i> Novo</Link>];

        //COLUNAS DA TABELA
        const columns = [
            {
                name: 'Nome',
                selector: 'nomemed',
                sortable: true,
            },
            {
                name: 'Avaliação',
                selector: 'avaliacaofinal',
                sortable: true,
            },
            {
                name: 'Quantidade de avaliações',
                selector: 'quantavaliacao',
                sortable: true,
            },
            {
                name: 'Ações',
                selector: 'acoes',
                sortable: false,
            },

        ];

        //ELEMENTO DE EXPANSÃO DA LINHA
        const ExpandableComponent = ({ data }) =>
            <div className="row no-gutters p-3 bg-light">
                <div className="col-sm-auto mr-3">

                </div>
                <div className="col">

                    <div className="product-image-container img-thumbnail">
                        <img className="product-image" src={"http://anorosa.com.br/storage/" + data.fotomed} />
                    </div>
                </div>
            </div>;
        var title;
        if (this.state.title === 1) {
            title = "Médicos cadastrados";
        } else {
            title = "Selecione uma empresa";
        }
        //DATATABLE
        return <DataTable
            title={title}
            pagination={true}
            actions={actions}
            columns={columns}
            data={data}
            expandableRows
            expandableRowsComponent={<ExpandableComponent />} />
    }
    render() {//Aqui acontece a renderização da página
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Médicos</h1>
                    <p className="dashboard-page-title-desc">Cadastre, atualize ou remova as médicos de uma empresa.</p>
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
                {/*   MODAL DELETE */}
                <div className="modal fade" id="delete_product_form" tabIndex="-1">
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
                                            <p className="mb-0">Tem certeza que deseja <strong>deletar o médico {this.state.selectedItem.nomemed}</strong>? Essa operação é irreversível.</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="form-row justify-content-center ">
                                    <div className="col-sm-4 mb-3 mb-sm-0">
                                        <button onClick={() => this.setState({ selectedItemId: null, selectedItem: { nomemed: null } })} type="button" className="btn btn-block btn-outline-secondary btn-lg" data-dismiss="modal">Cancelar</button>

                                    </div>
                                    <div className="col-sm-4">
                                        <button onClick={() => {
                                            const token = localStorage.getItem("JWT_token");
                                            fetch("https://anorosa.com.br/api/medico/delete/" + this.state.selectedItemId, {
                                                method: "delete",
                                                headers: {
                                                    "Content-Type": "application/json",
                                                    "Authorization": "Bearer " + token
                                                }
                                            })
                                                .then(data => data.json().then(data => {
                                                    console.log(data);
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

    empresaMap = () => {
        const status = this.state.status;

        const empresa = this.state.empresa;

        if (status) {

            const Option = empresa.map((item, indice) => (
                <option key={indice} value={item.id}>{item.nomeempresa}</option>
            ))
            return Option
        }
    }

    handleSelect = event => {
        const target = event.target;
        const value = target.value;
        

        console.log(value)
        this.setState({ loading: true });
        const requestOptions = {
            method: 'get',
        };

        fetch("https://anorosa.com.br/api/empresa/medico/list/" + value, requestOptions)
            .then(data => data.json().then(data => {
                console.log(data);
                this.setState({ status: data.status })
                if (data.status) {
                    this.setState({ med: data.data, loading: false, selectedCompanyId: value });
                }
            }))
            .catch(erro => this.setState(erro))
        if (value !== 0) {
            this.setState({ title: 1 });
        } else {
            this.setState({ title: 0 });
        }

    }
}
export default MedicoIndex; //Aqui retorna o componente