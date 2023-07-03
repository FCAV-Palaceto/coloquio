<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="ediciones.aspx.cs" Inherits="ediciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>

        .contain{
            display: flex;
            justify-content:center;
            align-items:center;
        }

        .radio-tile-group{
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .input-container{
            position: relative;
            height: 14rem;
            width: 14rem;
            margin: 0.5rem;
        }

        .input-container input{
            position: absolute;
            height: 100%;
            width: 100%;
            margin: 0;
            cursor: pointer;
            z-index: 2;
            opacity: 0;
        }

        .input-container .radio-tile{
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            border: 2px solid #858585;
            border-radius: 8px;
            transition: all 300ms ease;
        }

        /*.input-container label{
            font-size: 0.80rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }*/

        .radio-tile label{
            position: relative;
            bottom: 40px;
            left: -10px;
        }

        input:checked + .radio-tile{
            /*background-color: #217cb188;*/
            box-shadow: 0 0 16px #217cb188;
            border: 2px solid #217cb188;
        }

        input:hover + .radio-tile{
            border: 2px solid #217cb188;
            box-shadow: 0 0 16px #217cb188;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%-- ---- modal ------- --%>
    <!--- Modal --->
    <div id="modaldel" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">Eliminar Edición</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de eliminar la edición <strong>COMPLETA?</strong><small>(Se eliminaran temas, modalidades, secciones, parametros y ponencias con sus respectivas evaluaciones)</small></h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary eliminar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
    <%-- ------------------ --%>

    <%-- ---- modal ediciones ------- --%>
    <!--- Modal --->
    <div id="modaledit" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">Editar Edición</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label nowrap="nowrap" align="center">Edición:</label>
                        <input type="text" id="idEdicion" name="edicion" value="" size="30" hidden="hidden">
                        <input class="form-control" type="text" id="nombreEdicion" name="edicion" value="" size="30">
                        <br>
                    </div>
                    <%-- <select name="activo">
                        <option value="1">Activado</option>
                        <option value="0" selected="">Desactivado</option>
                    </select> --%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary confirmar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
    <%-- ------------------ --%>

    <%-----------ModalNuevaEdicion-----------%>
    <div id="modalNuevaEdi" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <!---Modal content--->
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Agregar Nueva Edicion:</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <br>
                    <div class="row justify-content-md-center">
                        <label class="col-md-3 col-form-label" nowrap="nowrap">Nombre de la Edicion: </label>
                        <div class="col-md-4">
                            <input  id="nombreEdi" class="form-control" type="text" name="edicion" value="" size="30">
                        </div>
                        <br>
                    </div>
                    <div class="col-auto text-center alert alert-danger mt-2" style="display:none;" role="alert" id="alerta"></div>
                    <br>
                    <hr>
                    <label>Elija una de las opciones para crear la nueva edicion:</label>
                    <br>
                    <br>
                    <!------------------------------------------->
                    <!------------------------------------------->
                    <div class="row contain">
                        <div id="opcion1" class="radio-tile-group" style="padding-right: 35px;">
                            <div class="form-check input-container">
                                <input class="form-check-input" type="radio" name="radio" id="walk" value="1">
                                <div class="radio-tile">
                                    <label for="walk">Plantilla con Parametros: </label>
                                    <img name="walk" src="google-docs.png" class="img-thumbnail" style="width: 100px; border: 0cm;" alt="">
                                </div>
                            </div>

                            <div class="form-check input-container">
                                <input class="form-check-input" type="radio" name="radio" id="run" value="2">
                                <div class="radio-tile">
                                    <label for="run">Plantilla sin Parametros: </label>
                                    <img name="run" src="expediente2.png" class="img-thumbnail" style="width: 100px; border: 0cm;" alt="">
                                </div>
                            </div>

                            <!--<div class="form-check input-container">
                                <input class="form-check-input" type="radio" name="radio" id="fly" value="3">
                                <div class="radio-tile">
                                    <label for="fly">Plantilla Anterior: </label>
                                    <img name="fly" src="expediente.png" class="img-thumbnail" style="width: 100px;" alt="">
                                </div>
                            </div>-->
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary" style="float: right; margin-left: 5px;" onclick="Plantilla();">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;" onclick="Limpia();">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
    <%-------------%>

    <%-----------ModalEdicion-----------%>
    <div id="ModalEdicion" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <!---Modal content--->
            <div class="modal-content">
                <div class="modal-header">
                    <h3><b>Previsualizacion </b></h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <br>
                    <!--Se genera tabla-->
                    <div id="DatosEdicion" class="table-responsive"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary" data-bs-dismiss="modal" style="float: right; margin-left: 5px;" onclick="GuardarEdicion();">Continuar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;" onclick="ModalNuevaEdicion();">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
    

    <%----------------------%>
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
        <h3><strong>Lista de ediciones</strong></h3>
        </div>
        <div>
            <button type="button" class="btn  btn-primary" onclick="ModalNuevaEdicion();" style="float:left;" >Agregar Nueva Edicion</a>
        </div>
        <br />
        <div class="card-body">
        <%-- se genera la tabla --%>
            <div id="generarTabla" class="table-responsive "></div>
            <%-- leyendas --%>
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
                        <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size:1.2em;"></i> = Editar edición</li>
                        <li><i class="fa-sharp fa-solid fa fa-trash text-danger" style="font-size:1.2em;"></i> = Eliminar edición</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
        <script>

        window.onload = function(){
            TablaUsu();
        }

        ///////////////////*** TABLA EDICIONES ***/////////////////////

        function TablaUsu() {  //aqui se crea la tabla
            $.ajax({
                type: 'POST',
                url: 'ediciones.aspx/TablaListarEdiciones',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#generarTabla").html(tabla.d); //nombre del id del div de la tabla
                    setTimeout(function myfunction() {
                        estiloDataTable();
                    }, 100);
                }
            });
        }

        function estiloDataTable(page, leng) {
            $('#tabla').DataTable({
                "lengthMenu": [5, 10, 25, 50, 75, 100],
                "pageLength": leng,
                "info": false,
                pagingType: 'numbers',
                "order": [[4, 'asc'], [1, 'asc']],
                language: {
                    "decimal": ".",
                    "emptyTable": "",
                    "info": "Mostrando del _START_ al _END_ de un total de _TOTAL_ registros",
                    "infoEmpty": "",
                    "infoFiltered": "<br/>(Filtrado de _MAX_ registros en total)",
                    "infoPostFix": "",
                    "thousands": ",",
                    "lengthMenu": "Mostrando _MENU_ registros",
                    "loadingRecords": "Cargando...",
                    "processing": "Procesando...",
                    "search": "B&uacute;squeda:",
                    "zeroRecords": "No hay registros",
                }
            });
        };

        ////////////////////*** TABLA EDICIONES ***///////////////////////////

        //** Muestra El Modal Para Agregar Una Nueva Edición
        function ModalNuevaEdicion(){
            $("#modalNuevaEdi").modal('show');
        }

        //** Muestra El Modal Para Editar El Nombre De La Edición
        function ModalEditar(idEdicion) {
            $("#modaledit").modal('show');

            $.ajax({
                type: 'POST',
                url: 'ediciones.aspx/traeEdicion',
                data: "{'id':'" + idEdicion + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (data) {
                    var JsonD = $.parseJSON(data.d);

                    $("#idEdicion").val(JsonD.id);
                    $("#nombreEdicion").val(JsonD.edicion);
                }
            });
        };

        function ActualizarEdicion(id){
            var UpEdicion=$("#nombreEdicion").val();

            var obj = {};
            obj.newEdicion = UpEdicion;
            obj.id = id;

            $.ajax({
                type: 'POST',
                url: 'ediciones.aspx/ModificarEdicion',
                data: JSON.stringify(obj),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function () {
                    TablaUsu();
                    console.log("Se actualizo");
                    PNotify.success({
                        text: 'La edicion se actualizo correctamente.',
                        delay: 3000,
                        addClass: 'translucent'
                    });
                }
            });
        };


        $('.confirmar').on('click', function(){
        let idParaEditar = $("#idEdicion").val();
            ActualizarEdicion(idParaEditar);
        })

        //** Muestra El Modal Para Eliminar La Edicion Completa
        function ConfirmarEliminar(idEdicion) {
            $("#modaldel").modal('show');
            var id = idEdicion;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "borrarEdicion(" + id + ");");
        };

        //** Función Para Borrar La Edición
        function borrarEdicion(id) {
        var idEdicion = id;
            $.ajax({
                type: 'POST',
                url: 'ediciones.aspx/borrarEdicion',
                data: "{'id':'" + idEdicion + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    if (JsonD.success == 1) {
                        TablaUsu();
                        PNotify.success({
                            text: 'La edicion se eliminó correctamente.',
                            delay: 3000,
                            addClass: 'translucent'
                        });
                    }else if (JsonD.success == 0) {
                        PNotify.notice({
                            text: 'No puede ser eliminada una edición si se encuentra activa.',
                            delay: 3000,
                            addClass: 'translucent'
                        });
                    } else if (JsonD.success == 2) {
                        PNotify.notice({
                            text: 'Algo salió mal.',
                            delay: 3000,
                            addClass: 'translucent'
                        });
                    }
                }
            });
        };

        //** Función Para Alternar Entre Edición Activada y Desactivada
        function alternarActivo(id){
            $.ajax({
                type: 'POST',
                url: 'ediciones.aspx/alternarActivo',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    console.log(JsonD);
                    if(JsonD.success == 1){
                        TablaUsu();
                    }
                }
            });
        };

        //** Función Para Limitar Caracteres Que Se Pueden Usar Como Nombre De La Edición
        $('#nombreEdi').keypress(function (e) {
            Caracteres(e); 		        
        });

        function Caracteres(e){
            var regex = new RegExp("^[a-zA-Z0-9-()¡!\u00E0-\u00FC ]+$"); 
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        }

        //** Función Para Seleccionar Plantilla
        function Plantilla(){
            var nombreEdi=$("#nombreEdi").val();

            if(nombreEdi==""){
                PNotify.notice({
                        text: 'Porfavor complete los campos.',
                        delay: 2500,
                        styling: 'bootstrap3'
                    });
                return;
            }

            $("#modalNuevaEdi").modal("hide");
            
            if($("#walk").is(":checked")){
                $("#ModalEdicion").modal('show');
                console.log(nombreEdi + "Plantilla predeterminada, Abre Pagina");
                EdicionPredeterminada();
            }else if($("#run").is(":checked")){
                console.log(nombreEdi + "Plantilla Nueva Seleccionada, Abre Pagina");
                GuardarEdicion();
            }/*else if($("#fly").is(":checked")){
                $("#ModalEdicion").modal('show');
                console.log(nombreEdi + "Plantilla Anterior Seleccionada, Abre Pagina");
                EdicionAnterior();
            }*/
        }

        //////////////////*** TABLA EDICION PREDETERMINADA ***////////////////////////////
        
        function EdicionPredeterminada() {  //aqui se crea la tabla
            $.ajax({
                type: 'POST',
                url: 'ediciones.aspx/EdicionPredeterminada',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#DatosEdicion").html(tabla.d); //nombre del id del div de la tabla
                    setTimeout(function myfunction() {
                        EstiloEdicionPredeterminada();
                    }, 100);
                }
            });
        }

        function EstiloEdicionPredeterminada(page, leng) {
            $('#EdicionPre').DataTable({
                "lengthMenu": [5, 10, 25, 50, 75, 100],
                "pageLength": leng,
                "info": false,
                pagingType: 'numbers',
                "order": [[1, 'asc']],
                language: {
                    "decimal": ".",
                    "emptyTable": "",
                    "info": "Mostrando del _START_ al _END_ de un total de _TOTAL_ registros",
                    "infoEmpty": "",
                    "infoFiltered": "<br/>(Filtrado de _MAX_ registros en total)",
                    "infoPostFix": "",
                    "thousands": ",",
                    "lengthMenu": "Mostrando _MENU_ registros",
                    "loadingRecords": "Cargando...",
                    "processing": "Procesando...",
                    "search": "B&uacute;squeda:",
                    "zeroRecords": "No hay registros",
                }
            });
        };

        ///////////////////*** TABLA EDICION PREDETERMINADA ***////////////////////////////
        
        //** Función Para Guardar La Nueva Edición
        function GuardarEdicion(){
            var nombreEdi=$("#nombreEdi").val();
            var opcion;
            if($("#walk").is(":checked")){
                opcion=1;
                $.ajax({
                    type: 'POST',
                    url: 'ediciones.aspx/GuardarEdicion',
                    data: "{'nombre':'" + nombreEdi + "','opcion':'"+ opcion +"'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                    },
                    success: function (valor){
                        var JsonD = $.parseJSON(valor.d)
                        if (JsonD.success == 1) {
                            TablaUsu();
                            PNotify.success({
                                text: 'Edicion guardada correctamente.',
                                delay: 3000,
                                addClass: 'translucent'
                            });
                            Limpia();
                        } else if (JsonD.success == 0) {
                            PNotify.notice({
                                text: 'Algo salió mal.',
                                delay: 3000,
                                addClass: 'translucent'
                            });
                        }
                    }
                });

            }else if($("#run").is(":checked")){
                opcion=2;
                $.ajax({
                    type: 'POST',
                    url: 'ediciones.aspx/GuardarEdicion',
                    data: "{'nombre':'" + nombreEdi + "','opcion':'"+ opcion +"'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                    },
                    success: function (valor){
                        var JsonD = $.parseJSON(valor.d)
                        if (JsonD.success == 1) {
                            TablaUsu();
                            PNotify.success({
                                text: 'Edicion guardada correctamente.',
                                delay: 3000,
                                addClass: 'translucent'
                            });
                            Limpia();
                        } else if (JsonD.success == 0) {
                            PNotify.notice({
                                text: 'Algo salió mal.',
                                delay: 3000,
                                addClass: 'translucent'
                            });
                        }
                    }
                });

            }
            console.log(opcion);
        }

        //** Vacia Inputs
        function Limpia() {
            $('#nombreEdi').val('');
            $('#walk').prop('checked',false);
            $('#run').prop('checked',false);
        }

        </script>
</asp:Content>
