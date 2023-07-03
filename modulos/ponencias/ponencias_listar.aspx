<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="ponencias_listar.aspx.cs" Inherits="ponencias_listar" %>

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

    <%-- Scripts de confirmación más bonitos --%>
    <link href="//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css" rel="stylesheet" type="text/css" />
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

    <style>
        .blinking {
            border: 4px solid #0dcaf0;
            animation-name: blinking;
            animation-duration: 1s;
            animation-iteration-count: infinite;
        }
        @keyframes blinking {
            50% {
                border-color: #fb233a;
            }
        }

        .btn-pulse {
          box-shadow: 0px 0px 0px rgba(13, 202, 240, 0.30);
          transition: all 0.2s ease-in-out;
        }

        .pulsing {
          animation: pulse 2s infinite;
        }

        @keyframes pulse {
          0% {
            transform: scale(1);
            box-shadow: 0px 0px 0px rgba(13, 202, 240, 0.30);
          }
          25% {
            transform: scale(1.1);
            box-shadow: 0px 0px 15px rgba(13, 202, 240, 0.30);
          }
          50% {
            transform: scale(1);
            box-shadow: 0px 0px 0px rgba(13, 202, 240, 0.30);
          }
          75% {
            transform: scale(1.1);
            box-shadow: 0px 0px 15px rgba(13, 202, 240, 0.30);
          }
          100% {
            transform: scale(1);
            box-shadow: 0px 0px 0px rgba(13, 202, 240, 0.30);
          }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!-- Mis Ponencias -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
            <h3><strong>Mis ponencias</strong></h3>
        </div>
        <div class="card-body">
            <br>
            <div id="generarTabla" class="table-responsive"></div>
            <br />
            <p><b>Notas:</b></p>
            <li style="font-size:10px;">Las ponencias que se encuentran en estado <span class="badge bg-warning text-dark" style="font-size:11px;">Envío Pendiente</span> cumplen con todos los requistos para ser enviadas y posteriormente evaluadas, sin embargo, una vez enviadas ya no podrán ser modificadas.</li>
            <br />
            <li style="font-size:10px;">Las ponencias que se encuentran en estado <span class="badge bg-warning text-dark" style="font-size:11px;">Requiere Cambios</span> es necesario correguir y volver a enviar el archivo (ya con las correciones) y anexar un segundo documento con el listado de correciones que se realizaron.</li>
            <%-- leyendas --%>
            <div class="row">
                <%--<div class="col-auto">                
                    <ul class="list-unstyled">
                        <li><b>Estados:</b></li>                        
                        <li><i class="fa-solid fa-file-circle-question" style="font-size:1.2em;"></i> = Registro incompleto</li>                        
                        <li><i class="fa-solid fa-file-circle-check" style="font-size:1.2em;"></i> = Registro completo</li>
                        <li><i class="fa-solid fa-clipboard-user" style="font-size:1.2em;"></i> = Asignada</li>
                        <li><i class="fa-solid fa-triangle-exclamation text-warning" style="font-size:1.2em;"></i> = Requiere correcciones</li>
                        <li><i class="fa-sharp fa-solid fa-check text-success" style="font-size:1.2em;"></i> = Aprobada</li>
                        <li><i class="fa-sharp fa-solid fa-xmark text-danger" style="font-size:1.2em;"></i> = Rechazada</li>
                    </ul>
                </div>--%>
                <%-- <div class="col-auto">
                    <ul class="list-unstyled">
                        <li><b>Acciones:</b></li>
                        <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size:1.2em;"></i> = Editar ponencia</li>
                        <li><i class="fa-sharp fa-solid fa-trash text-danger" style="font-size:1.2em;"></i> = Eliminar ponencia</li>
                        <li><i class="fa-sharp fa-solid fa-comment text-success" style="font-size:1.2em;"></i> = Ver comentarios</li>
                        <li><i class="fa-solid fa-square text-black-50" style="font-size:1.2em;"></i> = Acción deshabilitada</li>
                        <%-- <li><i class="fa-sharp fa-solid fa fa-download" style="font-size:1.2em;color: var(--bs-gray-600);"></i> = Descargar ponencia</li>
                    </ul>
                </div> --%>
            </div>
        </div>
    </div>

    <!--- Modal eliminar --->
    <div id="modaldel" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">Eliminar Ponencia</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de eliminar la ponencia?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary eliminar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

     <!--- Modal enviar --->
    <div id="modalenv" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">Enviar Ponencia</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de enviar la ponencia? <br><b>No se podrá modificar una vez enviada.</b></h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary enviar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal comentarios -->
    <div class="modal fade" id="modalcom" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4">Comentarios</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <div id="generarTablaC" class="table-responsive"></div>
                        </div>                        
                    </div>
                </div>
                <div class="col-md-12 modal-footer">
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cerrar</button>
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
                    <h4 class="modal-title" id="labelArchivo">Subir Archivo:</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">                                                                               
                    <%-- Tab 3 --%>                    
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
                    <div class="row g-3 mt-4 mb-3 align-items-center">
                            <div class="col-12 text-danger justificar">
                                <p>
                                    <u>Los trabajos deberán ser cargados en formato <b>DOC/DOCX</b>, el archivo deberá tener un tamaño máximo de <b>8mb</b> y se pueden cargar <b>2</b> archivos por ponencia en caso de requerir subir correcciones en un documento aparte.</u>
                                </p>
                            </div>
                        </div>                                                          
                </div>
                
                <div class="col-md-12 modal-footer">
                    <button id="btnGuardar" type="button" class="btn  btn-primary" data-bs-dismiss="modal" style="float: right;">Cerrar</button>
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
                url: 'ponencias_listar.aspx/TablaListarPonencias',
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

        function estiloDataTableC(page, leng) {
            $('#tablaC').DataTable({
                "lengthMenu": [5, 10, 25, 50, 75, 100],
                "pageLength": leng,
                "info": false,
                <%-- pagingType: 'numbers',
                "order": [[4, 'asc'], [1, 'asc']], --%>
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
                    "zeroRecords": "No hay comentarios disponibles.",
                    'paginate': {
                        "previous": "Anterior",
                        "next": "Siguiente"
                    }                    
                }
            });
        };

        function editarPonencia(idPonencia, ronda){
            var obj = {};
            obj.idPonencia = idPonencia;
            obj.ronda = ronda;
            $.ajax({
                type: 'POST',
                url: 'ponencias_listar.aspx/actualizarVar',
                data: JSON.stringify(obj),
                contentType: "application/json; charset=utf-8",
                dataType: "json",                
                error: function (jqXHR, textStatus, errorThrown) {                    
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var jsonD = $.parseJSON(valor.d);
                    if (jsonD.Success == 1) {
                        // Para comprobar si se va a editar o no
                        localStorage.setItem('activePillId', 'pills-1');
                        localStorage.setItem('idActual', idPonencia);
                        <%-- localStorage.setItem('rondaActual', ronda); --%>
                        localStorage.setItem('estadoRegistro', 1);
                        window.location.href = "ponencias_registrar.aspx";
                    }
                }
            });
        };

        function ConfirmarEliminar(idPonencia) {
            $("#modaldel").modal('show');
            var id = idPonencia;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "borrarPonencia(" + id + ");");
        };

        function confirmarEnvio(idPonencia) {
            $("#modalenv").modal('show');
            var id = idPonencia;
            $(".enviar").attr("id", "" + id + "");
            $(".enviar").attr("onclick", "enviarPonencia(" + id + ");");
        };

        function borrarPonencia(id) {        
            $.ajax({
                type: 'POST',
                url: 'ponencias_listar.aspx/borrarPonencia',
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
                            text: 'La ponencia se eliminó correctamente.',
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

        function notificacionEditar(){
            PNotify.notice({
                text: 'No es posible editar la ponencia una vez enviada a menos que requiera correcciones para una nueva ronda.',
                delay: 3000,
                addClass: 'translucent'
            });
        }

        function notificacionBorrar(){
            PNotify.notice({
                text: 'No es posible eliminar la ponencia una vez enviada.',
                delay: 3000,
                addClass: 'translucent'
            });
        }

        function notificacionComentarios(){
            PNotify.notice({
                text: 'La ponencia no se ha evaluado.',
                delay: 3000,
                addClass: 'translucent'
            });
        }

        function notificacionEnviar(){
            PNotify.notice({
                text: 'No es posible enviar la ponencia si no está completa.',
                delay: 3000,
                addClass: 'translucent'
            });
        }

        function notificacionEnviar2(){
            PNotify.notice({
                text: 'La ponencia ya ha sido enviada.',
                delay: 3000,
                addClass: 'translucent'
            });
        }

        function VerComentarios(id) {  //aqui se crea la tabla
            $.ajax({
                type: 'POST',
                url: 'ponencias_listar.aspx/TablaListarComentarios',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $('#modalcom').modal('show');
                    $("#generarTablaC").html(tabla.d); //nombre del id del div de la tabla
                    setTimeout(function myfunction() {
                        estiloDataTableC();
                    }, 100);
                }
            });
        }

        function enviarPonencia(id) {  //aqui se envía la Ponencia
            $.ajax({
                type: 'POST',                
                url: 'ponencias_listar.aspx/enviarPonencia',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    TablaUsu();
                    PNotify.success({
                        text: 'Ponencia enviada correctamente.',
                        delay: 3000,
                        addClass: 'translucent'
                    });
                }
            });
        }

        /* Se inicializa el plugin */
        $('#file-input').fileinput({
            theme: 'fa5',
            language: 'es',
            uploadUrl: 'subir_archivo.ashx',
            //deleteUrl: "/site/file-delete",
            maxFileSize: 8192,
            maxFileCount: 2,
            overwriteInitial: false,
            initialPreviewAsData: true, //...
            browseOnZoneClick: true,
            validateInitialCount: true,
            previewFileIconSettings: {
                'doc': '<i class = "fas fa-file-word text-primary"></i>'
            },
            previewFileExtSettings: {
                'doc': function(ext) { 
                return ext.match(/(doc|docx)$/i); 
                } 
            },      
            // fileActionSettings: {
            //   showZoom: false
            // },
            allowedFileExtensions: ['doc', 'docx']//['pdf']
        }).on('fileuploaded', function() {
            $('#btnGuardar').removeClass('btn-secondary');
            $('#btnGuardar').addClass('btn-primary');
            PNotify.success({
                text: 'Archivo cargado correctamente.',
                delay: 3000,
                addClass: 'translucent'
            });
            TablaUsu();
        }).on('filebeforedelete', function() {
            return new Promise(function(resolve, reject) {
                $.confirm({
                    escapeKey: true,
                    backgroundDismiss: true,
                    icon: 'fa fa-warning',
                    title: '¡Confirmación!',
                    content: '¿Está seguro que desea eliminar este archivo?',
                    type: 'orange',
                    buttons: {   
                        Eliminar: {
                            btnClass: 'btn-primary text-white',
                            keys: ['enter'],
                            // text: 'Eliminar',
                            action: function(){
                                resolve();
                            }                        
                        },
                        Cancelar: function(){       
                        }
                    }
                });
            });
        }).on('filedeleted', function() {
            PNotify.success({
                text: 'Archivo eliminado correctamente.',
                delay: 3000,
                addClass: 'translucent'
            });
            $('#btnGuardar').addClass('btn-secondary');
            $('#btnGuardar').removeClass('btn-primary');
            TablaUsu();
        });
        /* ******************** */

        const myModalArchivo = document.getElementById('modalArchivo');
        myModalArchivo.addEventListener('hidden.bs.modal', function (event) {
            window.location.href = "ponencias_listar.aspx";
            $('#file-input').fileinput('destroy');            
            $('#file-input').fileinput({
                theme: 'fa5',
                language: 'es',
                uploadUrl: 'subir_archivo.ashx',
                //deleteUrl: "/site/file-delete",
                maxFileSize: 8192,
                maxFileCount: 2,
                overwriteInitial: false,
                initialPreviewAsData: true, //...
                browseOnZoneClick: true,
                validateInitialCount: true,
                previewFileIconSettings: {
                    'doc': '<i class = "fas fa-file-word text-primary"></i>'
                },
                previewFileExtSettings: {
                    'doc': function(ext) { 
                    return ext.match(/(doc|docx)$/i); 
                    } 
                },   
                // fileActionSettings: {
                //   showZoom: false
                // },
                allowedFileExtensions: ['doc', 'docx']//['pdf']
            }).on('fileuploaded', function() {
                $('#btnGuardar').removeClass('btn-secondary');
                $('#btnGuardar').addClass('btn-primary');
            }).on('filebeforedelete', function() {
            return new Promise(function(resolve, reject) {
                $.confirm({
                    escapeKey: true,
                    backgroundDismiss: true,
                    icon: 'fa fa-warning',
                    title: '¡Confirmación!',
                    content: '¿Está seguro que desea eliminar este archivo?',
                    type: 'orange',
                    buttons: {   
                        Eliminar: {
                            btnClass: 'btn-primary text-white',
                            keys: ['enter'],
                            // text: 'Eliminar',
                            action: function(){
                                
                                $('#btnGuardar').addClass('btn-secondary');
                                $('#btnGuardar').removeClass('btn-primary');
                                <%-- PNotify.success({
                                    text: 'Ponencia eliminada correctamente.',
                                    delay: 3000,
                                    addClass: 'translucent'
                                });
                                TablaUsu(); --%>
                            }
                        },
                        Cancelar: function(){       
                        }
                    }
                });
            });
            });
        });

        function subirArchivo(idPonencia, ronda){            
            $.ajax({
                type: 'POST',
                url: 'ponencias_listar.aspx/actualizarVar',
                data: "{'idPonencia':'" + idPonencia + "','ronda' : '" + ronda + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {                    
                    $('#modalArchivo').modal('show');
                    /* Comprueba si existe una ponencia cargada o no */
                    setTimeout(function myfunction() {
                    $.get('buscar_archivo.ashx', function(data) {
                        $('#handler').html(data);
                    });
                    }, 1000);
                }
            });            
        }     
        
    </script>

</asp:Content>

