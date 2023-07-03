<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="ponencias_invitacion.aspx.cs" Inherits="modulos_evaluacion_ponencias_invitacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <!--ESTE ES EL PRINCIPAL CSS del plugin-->
    <link href="../../FileInput/css/fileinput.css" rel="stylesheet" />

    <!--Tema utilizado-->
    <link href="../../FileInput/themes/explorer-fa5/theme.css" rel="stylesheet" />

    <!--Estos son para conversión de archivos-->
    <script src="../../FileInput/js/plugins/buffer.min.js"></script>
    <script src="../../FileInput/js/plugins/filetype.min.js"></script>
    <!--ESTOS SON OPCIONALES, AÑADEN EXTRAS DE ORIENTACIÓN (Deben cargarse antes del fileinput.js-->
    <script src="../../FileInput/js/plugins/piexif.js"></script>
    <script src="../../FileInput/js/plugins/sortable.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- body -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <h3><strong>Mis invitaciones</strong></h3>
        <br>
        <div class="card-body">
            <br>
            <div id="generarTabla" class="table-responsive"></div>
            <br>
            
            <%-- leyendas --%>
            <%-- <div class="row">                
                <div class="col-auto">
                    <ul class="list-unstyled">
                        <li><b>Acciones:</b></li>
                        <li><i class="fa-sharp fa-solid fa-check text-success" style="font-size:1.2em;"></i> = Aceptar</li>
                        <li><i class="fa-sharp fa-solid fa-xmark text-danger" style="font-size:1.2em;"></i> = Rechazar</li>
                    </ul>
                </div>
            </div> --%>
        </div> 
    </div>

    <!--- Modal RECHAZAR --->
    <div id="modaldel" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">Confirmación</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de <b>RECHAZAR</b> la invitación?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary rechazar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!--- Modal ACEPTAR --->
    <div id="modalaccept" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">Confirmación</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de <b>ACEPTAR</b> la invitación?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary aceptar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <%-- Modal ver ponencia --%>
    <div id="modalArchivo" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="labelArchivo" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="labelArchivo">Detalle de la ponencia:</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <%-- tabs --%>
                    <ul class="nav nav-pills mb-3 nav-justified" id="menuPills" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="btnPillData" data-bs-toggle="pill" data-bs-target="#pillData" type="button" role="tab" aria-controls="pillData" aria-selected="true">Datos generales</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="btnPillFile" data-bs-toggle="pill" data-bs-target="#pillFile" type="button" role="tab" aria-controls="pillFile" aria-selected="false">Archivo</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="btnPillComents" data-bs-toggle="pill" data-bs-target="#pillComents" type="button" role="tab" aria-controls="pillComents" aria-selected="false">Comentarios</button>
                        </li>
                    </ul>

                    <br/>

                    <div class="tab-content" id="pillsContenido">
                        <%-- Tab 1 --%>
                        <div class="tab-pane fade show active" id="pillData" role="tabpanel" aria-labelledby="pills-1" tabindex="0">
                            <div class="row mb-3 g-3 align-items-center">
                                <label for="txtTit" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label">Título de la ponencia:</label>
                                <div class="col-xxl-6 col-sm-8">
                                    <input type="text" id="txtTit" class="form-control" disabled>
                                    <%-- <p id="txtTit"></p> --%>
                                </div>
                            </div>
                            <div class="row g-3 mb-3 align-items-center">
                                <label for="selectMod" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-start">Modalidad de la ponencia:</label>
                                <div class="col-xxl-6 col-sm-8">
                                    <asp:DropDownList ID="selectMod" ClientIDMode="Static" CssClass="form-select" runat="server" disabled></asp:DropDownList>
                                    <%-- <p id="selectMod"></p> --%>
                                </div>
                            </div>
                            <div class="row g-3 mb-3 align-items-center">
                                <label for="selectTema" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-start">Tema o área de la ponencia:</label>
                                <div class="col-xxl-6 col-sm-8">
                                    <asp:DropDownList ID="selectTema" ClientIDMode="Static" CssClass="form-select" runat="server" disabled></asp:DropDownList>
                                    <%-- <p id="selectTema"></p> --%>
                                </div>
                            </div>
                            <div class="row g-3 align-items-center">
                                <label for="txtRes" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-start">Resumen de la ponencia:</label>
                                <div class="col-xxl-6 col-sm-8">
                                    <textarea id="txtRes" class="form-control" rows=8 maxlength="500" oninput="contador(this);" disabled></textarea>
                                    <%-- <p id="txtRes"></p> --%>
                                </div>
                            </div>
                            <div class="row g-3 align-items-center">
                                <label for="txtPal" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-start">Palabras clave de la ponencia:</label>
                                <div class="col-xxl-6 col-sm-8 col-12 d-grid d-sm-block">
                                    <input type="text" id="txtPal" class="form-control" disabled/>
                                    <%-- <p id="txtPal"></p> --%>
                                </div>
                            </div>
                            <div class="row g-3 mb-3 mt-3 align-items-center">
                                <div class="text-center">
                                    <button id="btnMuestraArchivo" type="button" class="btn btn-primary btn-block w-auto">Siguiente</button>
                                </div>
                            </div>
                        </div>

                        <%-- Tab 2 --%>
                        <div class="tab-pane fade" id="pillFile" role="tabpanel" aria-labelledby="pills-2" tabindex="0">
                            <!--Para hacer zoom y previsualizar en un modal-->
                            <!-- Está en la master, el conflicto era el jquery repetido -->
                            <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script> -->
                            <!--JS PRINCIPAL DEL PLUGIN-->
                            <script src="../../FileInput/js/fileinput.js"></script>
                            <!--ESTE ES PARA LENGUAJE A ESPAÑOL-->
                            <script src="../../FileInput/js/locales/es.js"></script>
                            <!--Para usar el tema de fontawesome5-->
                            <script src="../../FileInput/themes/explorer-fa5/theme.js"></script>
                            <script src="../../FileInput/themes/fa5/theme.js"></script>

                            <div id="handler"></div>
                            <div class="form-group" id="fileInput">
                                <div class="file-loading" >
                                    <input id="file-input" type="file" multiple data-preview-file-type="any"/>
                                </div>
                            </div>

                            <div class="row g-3 mb-3 mt-3 align-items-center">
                                <div class="text-center">
                                    <button id="btnRegresaDatos" type="button" class="btn btn-secondary btn-block w-auto">Anterior</button>
                                    <button id="btnMuestraComents" type="button" class="btn btn-primary btn-block w-auto">Siguiente</button>                                    
                                </div>
                            </div>
                        </div>

                        <%-- Tab 3 --%>
                        <div class="tab-pane fade" id="pillComents" role="tabpanel" aria-labelledby="pills-3" tabindex="0">
                            <!-- Lista Autores -->
                            <!-- <div id="tablaAutores" class="card-body shadow p-3 mb-5 bg-body rounded"> -->
                            <!-- <h3><strong>Lista de autores</strong></h3> -->
                            <div class="container">
                                <div id="generarTablaComentarios" class="table-responsive"></div>
                                <br/>
                            </div>
                            <div class="row g-3 mb-3 mt-3 align-items-center">
                                <div class="text-center">
                                    <button id="btnRegresaArchivo" type="button" class="btn btn-secondary btn-block w-auto">Anterior</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        window.onload = function(){
            TablaUsu();
        }

        function TablaUsu() {  //aqui se crea la tabla
            $.ajax({
                type: 'POST',
                url: 'ponencias_invitacion.aspx/TablaListarInvitacion',
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

        function modalAceptar(idInvitacion, idPonencia){
            $("#modalaccept").modal("show");
            $(".aceptar").attr("onclick", "AceptarInvitacion(" + idInvitacion + "," + idPonencia + ");");
        }

        function modalRechazar(idInvitacion){
            $("#modaldel").modal("show");
            <%-- $(".rechazar").attr("idInvitacion", "" + idInvitacion + ""); --%>
            $(".rechazar").attr("onclick", "RechazarInvitacion(" + idInvitacion + ");");
        }

        function AceptarInvitacion(idInvitacion, idPonencia) {    

            var obj = {};
            obj.idInvitacion = idInvitacion;
            obj.idPonencia = idPonencia;
            obj.idUsuario = <%=idusuario%>;

            $.ajax({
                type: 'POST',
                url: 'ponencias_invitacion.aspx/AceptarInvitacion',
                data: JSON.stringify(obj),
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
                            text: 'La invitación se aceptó correctamente.',
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

        function RechazarInvitacion(id) {        
            $.ajax({
                type: 'POST',
                url: 'ponencias_invitacion.aspx/RechazarInvitacion',
                data: "{'id':'" + id + "'}",
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
                            text: 'La invitación se rechazó correctamente.',
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

        /* Se inicializa el plugin */
        $('#file-input').fileinput({
            theme: 'fa5',
            language: 'es',
            showClose: false,
            showBrowse: false,
            showCaption: false,
            dropZoneTitle: 'No hay archivos disponibles.',
            maxFileSize: 8192,
            maxFileCount: 2,
            overwriteInitial: false,
            initialPreviewAsData: true, //...
            validateInitialCount: true,
            allowedFileExtensions: ['doc', 'docx']//['pdf']
        });
        /* ******************** */


        function verPonencia(idPonencia, idEvaluador, ronda, idPonente){
            verDatos(idPonencia);
            TablaComents(idPonencia, idEvaluador, ronda);
            $('#modalArchivo').modal('show');

            $.ajax({
                type: "POST",
                url: "../administrador/ver_archivo.ashx",
                data: { idPon: idPonencia, idUsu: idPonente, Ronda: ronda },
                success: function(response) {
                    $('#handler').html(response);
                }
            });
        };


        const myModalArchivo = document.getElementById('modalArchivo');
        myModalArchivo.addEventListener('hidden.bs.modal', function (event) {
            $('#file-input').fileinput('destroy');
            $('#file-input').fileinput({
                theme: 'fa5',
                language: 'es',
                showClose: false,
                showBrowse: false,
                showCaption: false,
                dropZoneTitle: 'No hay archivos disponibles.',
                maxFileSize: 8192,
                maxFileCount: 2,
                overwriteInitial: false,
                initialPreviewAsData: true, //...
                validateInitialCount: true,
                allowedFileExtensions: ['doc', 'docx']//['pdf']
            });
        });


        /* trae datos generales */
        function verDatos(id) {

            $.ajax({
                type: 'POST',
                url: 'ponencias_evaluar.aspx/TraeDatos',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (datos) {
                    var JsonD = $.parseJSON(datos.d);

                    // Trae los datos
                    $('#txtTit').val(JsonD.titulo);
                    $("#selectMod option:selected").remove();
                    $('#selectMod').append($('<option>', {
                        value: 1,
                        text: JsonD.modalidad
                    }));
                    $("#selectTema option:selected").remove();
                    $('#selectTema').append($('<option>', {
                        value: 1,
                        text: JsonD.tema
                    }));
                    $('#txtRes').val(JsonD.resumen);
                    $('#txtPal').val(JsonD.palabrasClave);
                }
            });
        };
        /* ******************** */

        /* Tabla de Comentarios */
        function TablaComents(idPonencia, idUsuario, ronda) {  //aqui se crea la tabla
            var obj = {
                idPonencia: idPonencia,
                idUsuario: idUsuario,
                ronda: ronda
            };

            $.ajax({
                type: 'POST',
                url: 'ponencias_invitacion.aspx/TablaListarComentarios',
                data: JSON.stringify(obj),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#generarTablaComentarios").html(tabla.d); //nombre del id del div de la tabla
                    setTimeout(function myfunction() {
                        let idTable = "tablaComentarios";
                        let orden = [[0, 'asc']];
                        let contexto = "No existen comentarios para esta ponencia.";
                        dataTable(idTable, orden, contexto);
                    }, 100);
                }
            });
        };
        /* ******************** */


        /* Controla las pills */
        $('#btnMuestraArchivo').on('click', function(){
            $('#btnPillFile').trigger('click');
        });

        $('#btnRegresaDatos').on('click', function(){
            $('#btnPillData').trigger('click');
        });

        $('#btnMuestraComents').on('click', function(){
            $('#btnPillComents').trigger('click');
        });

        $('#btnRegresaArchivo').on('click', function(){
            $('#btnPillFile').trigger('click');
        });
        /* ******************** */
        </script>
</asp:Content>

