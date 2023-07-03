<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="parametros.aspx.cs" Inherits="modulos_administrador_parametros" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!-- Modal -->
    <div class="modal fade" id="modalparametro" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="parametro"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <input type="text" id="txtidparam" value="0" hidden />
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtparametro">Parámetro:</label>
                                <input type="text" class="form-control" id="txtparametro">
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="ddlseccion">Sección:</label>
                                <asp:DropDownList ID="ddlseccion" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:DropDownList>
                            </div>
                             <div class="form-group col-md-6 mt-3">
                                <label for="ddlmaximo">Puntaje Máximo:</label>
                                <select class="form-control" id="ddlmaximo">
                                    <option value="0">- Seleccione un puntaje máximo -</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                </select>
                            </div> 
                            <%--<div class="form-group col-md-6 mt-3">
                                <label for="ddledicion">Edición:</label>
                                <asp:DropDownList ID="ddledicion" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:DropDownList>
                            </div>--%>
                            <div class="col-md-12 modal-footer mt-5">
                                <button type="button" class="btn  btn-primary" onclick="GuardarSeccion();" style="float: right; margin-left: 10px;">Guardar</button>
                                <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Eliminar -->
    <div class="modal fade" id="modaldel" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4">Eliminar Parámetro</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h3>¿Está seguro de eliminar el parámetro?</h3>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary eliminar" data-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!---------------------->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
        <h3><strong>Lista de parametros</strong></h3>
        </div>
        <div>
            <button type="button" class="btn btn-primary" onclick="AgregarParametro();Limpia();" style="float:left;" >Agregar Nuevo Parámetro</button>
        </div>
        <br />        
        <div class="card-body">
        <!-- Tabla de secciones -->
            <div id="tabparametros" class="table-responsive "></div>            
            <!-- Leyenda de los botones -->
            <div class="row">
            <div class="col-auto">                
                    <ul class="list-unstyled">
                        <li><b>Estados:</b></li>
                        <li><i class="fa-sharp fa-solid fa-check text-success" style="font-size:1.2em;"></i> = Activa</li>
                        <li><i class="fa-sharp fa-solid fa-ban" style="font-size:1.2em;color: var(--bs-gray-600);"></i> = Inactiva</li>
                    </ul>
                </div>
                <div class="col-auto">
                    <ul class="list-unstyled">
                        <li><b>Acciones:</b></li>
                        <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size:1.2em;"></i> = Editar parámetro</li>
                        <li><i class="fa-sharp fa-solid fa fa-trash text-danger" style="font-size:1.2em;"></i> = Eliminar parámetro</li>
                    </ul>
                </div>
            </div>
        </div>        
    </div>

    <script>

    window.onload = function () {
            TablaParametros();
        }

        //Se crea la tabla
        function TablaParametros() {  
            $.ajax({
                type: 'POST',
                url: 'parametros.aspx/TablaListarParametros',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#tabparametros").html(tabla.d); //id del div de la tabla
                    setTimeout(function myfunction() {
                        estiloDataTable();
                    }, 100);
                }
            });
        }

        function AgregarParametro() {
            $('#modalparametro').modal('show');
        }

        function GuardarSeccion() {
            var idParam = $('#txtidparam').val();
            var parametro = $('#txtparametro').val();
            var seccion = $('#ddlseccion').val();
            var puntaje = $('#ddlmaximo').val();

            if (parametro == "" || seccion == 0 || puntaje == "") {
                PNotify.notice({
                    text: 'Porfavor complete los campos.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }

            var obj = {};
            obj.parametro = parametro;
            obj.seccion = seccion;
            obj.puntaje = puntaje;
            obj.id = idParam;

            if (idParam == 0) {
                var url = 'parametros.aspx/GuardarParametro';
            }
            else {
                var url = 'parametros.aspx/ActualizarParametro';
            }
            $.ajax({
                type: 'POST',
                url: url,
                data: JSON.stringify(obj),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    if (JsonD.success == 1) {
                        PNotify.success({
                            text: 'El parámetro se guardo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        $('#modalparametro').modal('hide');
                        TablaParametros();
                        Limpia();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.notice({
                            text: 'El parámetro ya existe, intente con otro nombre.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    } else if (JsonD.success == 3) {
                        PNotify.notice({
                            text: 'El parámetro no se puede actualizar porque existe una evaluación ligada a el.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    }
                }
            });
        }

        //Trae los datos para modificar las secciones
        function ModificarParametro(ctrl) {
            var id = ctrl;
            $.ajax({
                type: 'POST',
                url: 'parametros.aspx/ModParametro',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#txtidparam').val(id);
                    $('#parametro').html('Editar Parámetro');
                    $('#ddlseccion').val(jsonD.seccion);
                    $('#txtparametro').val(jsonD.parametro);
                    $('#ddlmaximo').val(jsonD.puntaje);
                    $('#modalparametro').modal('show');
                }
            });
        }

        function ConfirmarEliminar(ctrl) {
            $("#modaldel").modal('show');
            var id = ctrl;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "EliminarParametro(" + id + ");");
        }

        function EliminarParametro(id) {
            var id2 = id;
            $.ajax({
                type: 'POST',
                url: 'parametros.aspx/EliminarParametro',
                data: "{'id':'" + id2 + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    if (JsonD.success == 1) {
                        $('#modaldel').modal('hide');
                        TablaParametros();
                        PNotify.success({
                            text: 'El parámetro se elimino correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    } else
                        if (JsonD.success == 2) {
                            $('#modaldel').modal('hide');
                            PNotify.notice({
                                text: 'No se puede eliminar el parámetro porque existe una evaluación ligada a el.',
                                delay: 2500,
                                styling: 'bootstrap3'
                            });
                        }
                }
            });
        }

        function alternarActivo(id) {
            $.ajax({
                type: 'POST',
                url: 'parametros.aspx/alternarActivo',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    console.log(JsonD);
                    if (JsonD.success == 1) {
                        PNotify.success({
                            text: 'El parámetro se activo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaParametros();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.success({
                            text: 'El parámetro se desactivo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaParametros();
                    }
                }
            });
        };

        function Limpia() {
            $('#txtidparam').val(0);
            $('#txtparametro').val('');
            $('#ddlseccion').val(0);
            $('#ddlmaximo').val(0);
            $('#parametro').html('Agregar Nueva Parámetro');
        }

    </script>
</asp:Content>