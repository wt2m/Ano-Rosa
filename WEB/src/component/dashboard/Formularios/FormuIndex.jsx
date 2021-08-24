import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import DataTable from 'react-data-table-component';
import './Formu.css'


class FormulariosIndex extends Component {
    constructor(props) {
        super(props);
        this.state = {
            formulario: [],

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
        fetch("http://anorosa.com.br/api/formulario/showall", requestOptions)
            .then(data => data.json().then(data => {
                console.log(data);
                this.setState({ status: data.status })
                if (data.status) {
                    this.setState({ formulario: data.data, isApiRequested: true });

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
                <Link to={
                    {
                        pathname: "/dashboard/formu/edit",
                        state: {
                            id: id
                        }
                    }
                }
                ><button onClick="" type="button" className="dropdown-item" >Edit</button></Link>
                <button onClick={() => this.setState({ selectedItemId: id, selectedItem: object })} type="button" className="dropdown-item" data-toggle="modal" data-target="#delete_product_form">Deletar</button>
            </div>
        </div>
    }

    dataTable() {

        var data = [];

        var formu = this.state.formulario;

        if (formu.length !== 0) {
            for (var i = 0; i < formu.length; i++) {
                if (formu[i]['pergunta'] !== null) {
                    formu[i]['pergunta'] = formu[i]['pergunta'].substring(0, 20) + "...";
                }
                formu[i]['created_at'] = formu[i]['created_at'].substring(0, 10);
                formu[i]['acoes'] = this.actionsButtons(formu[i].id, formu[i]);
            }

            data = formu;
        }

        /*
         "id": 1,
            "explicacaoprotocolo": "Em uma escala de 0 a 3 defina o quanto os seus seios doeram nos ultimos dias",
            "imagemexplicativa": "autoexame.jpg",
            "pergunta": null,
            "alternativa1": "3",
            "indicea1": 1,
            "alternativa2": "2",
            "indicea2": 0.59999999999999997779553950749686919152736663818359375,
            "alternativa3": "1",
            "indicea3": 0.299999999999999988897769753748434595763683319091796875,
            "alternativa4": "0",
            "indicea4": 0,
            "created_at": "2020-08-18T17:28:00.000000Z",
            "updated_at": "2020-08-18T17:28:00.000000Z"
         */

        //BOTÕES DE CADASTRP
        const actions = [

            <Link to={
                {
                    pathname: "/dashboard/formu/create",

                }
            } className="btn btn-primary table-action"><i className="fas fa-plus mr-2"></i> Novo</Link>];

        //COLUNAS DA TABELA
        const columns = [
            {
                name: 'Pergunta',
                selector: 'pergunta',
                sortable: true,
            },

            {
                name: 'Criado em',
                selector: 'created_at',
                sortable: false,
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
                <div className="col-lg-3">

                    <div className="formu-image-container img-thumbnail">
                        <img className="formu-image" src={"http://anorosa.com.br/storage/" + data.imagemexplicativa} />
                    </div>

                </div>
                <div className="col-lg-8">
                    <div className="input-group">
                        <textarea readonly disabled value={data.explicacaoprotocolo.substring(0, 100) + "..."} rows="2" class="form-control"></textarea>
                    </div>
                    <div className="input-group">
                        <label>Alternativa 1</label>

                    </div>
                    <div className="input-group">
                        <label className="alternativa">{data.alternativa1}</label>

                    </div>
                    <div className="input-group">
                        <label>Alternativa 2</label>

                    </div>
                    <div className="input-group">
                        <label className="alternativa">{data.alternativa2}</label>

                    </div>
                    {data.alternativa3
                        ? <div className="input-group">
                            <label>Alternativa 3</label>

                        </div>
                        : null}
                    {data.alternativa3
                        ? <div className="input-group">
                            <label className="alternativa">{data.alternativa3}</label>

                        </div>
                        : null}
                    {data.alternativa4
                        ? <div className="input-group">
                            <label>Alternativa 4</label>

                        </div>
                        : null}
                    {data.alternativa4
                        ? <div className="input-group">
                            <label className="alternativa">{data.alternativa4}</label>

                        </div>
                        : null}
                </div>

            </div>;
        var title = "Genciar itens do formulário";

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
                    <h1 className="dashboard-page-title-header">Formulário</h1>
                    <p className="dashboard-page-title-desc">Cadastre, atualize ou remova itens do formulário exibido no app.</p>
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
                                            <p className="mb-0">Tem certeza que deseja <strong>deletar o item "{this.state.selectedItem.pergunta}"</strong>? Essa operação é irreversível.</p>
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
                                            fetch("https://anorosa.com.br/api/formulario/delete/" + this.state.selectedItemId, {
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
export default FormulariosIndex; //Aqui retorna o componente