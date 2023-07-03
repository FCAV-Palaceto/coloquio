<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="temas.aspx.cs" Inherits="temas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <!-- Modal -->
    <div class="modal fade" id="modalNuevoTema" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="tema"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <input type="text" id="idTema" value="0" hidden />
                            <div class="form-group col-md-6">
                                <label for="nombreTema">Tema:</label>
                                <input type="text" class="form-control" id="nombreTema">
                            </div>
                            <div class="form-group col-md-6">
                                <label for="edicion">Edición:</label>
                                <asp:DropDownList ID="edicion" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:DropDownList>
                            </div>
                            <br /><br />
                        <br /><br />
                            <div class="col-md-12 modal-footer">
                                <button type="button" class="btn  btn-primary" onclick="GuardarTema();" style="float: right; margin-left: 10px;">Guardar</button>
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
                    <h5 class="modal-title h4">Eliminar Tema</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de eliminar el tema?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary eliminar" data-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabla Principal -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
            <h3><strong>Lista de temas</strong></h3>
        </div>
        <div>
            <button type="button" class="btn btn-primary" onclick="AgregarTema();Limpia();" style="float: left;">Agregar Nuevo Tema</button>
        </div>
        <br />
        <div class="card-body">
            <!-- Tabla de temas -->
            <div id="tabtemas" class="table-responsive "></div>
            <!-- Leyenda de los botones -->
            <div class="row">
                <div class="col-auto">
                    <ul class="list-unstyled">
                            <ul class="list-unstyled">
                                <li><b>Estados:</b></li>
                                <li><i class="fa-sharp fa-solid fa-check text-success" style="font-size:1.2em;"></i> = Activo</li>
                                <li><i class="fa-sharp fa-solid fa-ban" style="font-size:1.2em;color: var(--bs-gray-600);"></i> = Inactivo</li>
                            </ul>
                        </div>
                        <div class="col-auto">
                            <ul class="list-unstyled">
                                <li><b>Acciones:</b></li>
                                <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size:1.2em;"></i> = Editar tema</li>
                                <li><i class="fa-sharp fa-solid fa fa-trash text-danger" style="font-size:1.2em;"></i> = Eliminar tema</li>
                            </ul>                    
                        </ul>
                </div>
            </div>
        </div>
    </div>
    <script>
        window.onload = function () {
            TablaTemas();
        }

        //Se crea la tabla
        function TablaTemas() {
            $.ajax({
                type: 'POST',
                url: 'temas.aspx/TablaListarTemas',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#tabtemas").html(tabla.d); //id del div de la tabla
                    setTimeout(function myfunction() {
                        estiloDataTable();
                    }, 100);
                }
            });
        }

        function AgregarTema() {
            $('#modalNuevoTema').modal('show');
        }

        function GuardarTema() {
            var id = $('#idTema').val();
            var tema = $('#nombreTema').val();
            var edicion = $('#edicion').val();

            if (tema == "" || edicion == 0) {
                PNotify.notice({
                    text: 'Porfavor complete los campos.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }

            var obj = {};
            obj.tema = tema;
            obj.edicion = edicion;
            obj.id = id;

            if (id == 0) {
                var url = 'temas.aspx/GuardarTema';
            }
            else {
                var url = 'temas.aspx/updateTema';
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
                            text: 'El tema se guardo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        $('#modalNuevoTema').modal('hide');
                        TablaTemas();
                        Limpia();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.notice({
                            text: 'El tema ya existe, intente con otro nombre.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    }
                }
            });
        }
        
        function ModificarTema(ctrl) {
            var id = ctrl;
            $.ajax({
                type: 'POST',
                url: 'temas.aspx/editarTema',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#idTema').val(id);
                    $('#tema').html('Editar Tema');
                    $('#nombreTema').val(jsonD.tema);
                    $('#edicion').val(jsonD.edicion);
                    $('#modalNuevoTema').modal('show');
                }
            });
        }

        function ConfirmarEliminar(ctrl) {
            $("#modaldel").modal('show');
            var id = ctrl;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "borrarTema(" + id + ");");
        }

        function borrarTema(id) {
            var id2 = id;
            $.ajax({
                type: 'POST',
                url: 'temas.aspx/borrarTema',
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
                        TablaTemas();
                        PNotify.success({
                            text: 'El tema se elimino correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    } else
                        if (JsonD.success == 2) {
                            $('#modaldel').modal('hide');
                            PNotify.notice({
                                text: 'No se puede eliminar el tema porque ha sido asignado a una o más ponencias.',
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
                url: 'temas.aspx/alternarActivo',
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
                            text: 'El tema se activo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaTemas();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.success({
                            text: 'El tema se desactivo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaTemas();
                    }
                }
            });
        };

        function Limpia() {
            $('#idTema').val(0);
            $('#nombreTema').val('');
            $('#tema').html('Agregar Nuevo Tema');             
        }
    </script>
</asp:Content>

