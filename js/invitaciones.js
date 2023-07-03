window.onload = function(){
    setTimeout(() => {
        TablaInvitaciones();
    }, 500);
}


function TablaInvitaciones() {  //aqui se crea la tabla
    let idEdicion = $('#selectEd').val();

    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/TablaListarPonencias',
        data: "{'idEdicion':'" + idEdicion + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
        },
        success: function (tabla) {
            $("#generarTabla").html(tabla.d); //nombre del id del div de la tabla
            setTimeout(function myfunction() {
                let idTable = "tabla";
                let orden = [[3, 'asc'], [0, 'asc']];
                let contexto = "No hay ponencias pendientes.";
                dataTable(idTable, orden, contexto);
                // estiloDataTable();
            }, 100);
        }
    });
}


/* Esconde el input para agregar evaluadores si la edición seleccionada no es la activa */
function ocultaBoton(edicionActiva){
    let idEdicion = $('#selectEd').val();

    if (idEdicion == edicionActiva){
        $('#buscaEvaluador').show();
    } else {
        $('#buscaEvaluador').hide();
    }
}
/* ******************** */


/* Actualizar tabla al seleccionar otra edición */
$('#selectEd').change(function(){
    TablaInvitaciones();
});
/* ******************** */


/* Se inicializa el plugin */
$('#file-input').fileinput({
    theme: 'fa5',
    language: 'es',
    showClose: false,
    showBrowse: false,
    showCaption: false,
    dropZoneTitle: 'No hay archivos disponibles.',
    maxFileSize: 8192,
    maxFileCount: 1,
    overwriteInitial: false,
    initialPreviewAsData: true, //...
    validateInitialCount: true,
    allowedFileExtensions: ['doc', 'docx']//['pdf']
});
/* ******************** */


/* Ver el archivo de la ponencia */
function verPonencia(idPonencia, idUsuario, Ronda){
    $('#modalArchivo').modal('show');
    verDatos(idPonencia);
    TablaAut(idPonencia);

    $.ajax({
        type: "POST",
        url: "ver_archivo.ashx",
        data: { idPon: idPonencia, idUsu: idUsuario, Ronda : Ronda },
        success: function(response) {
            $('#handler').html(response);
        }
    });
}
/* ******************** */


/* Para reiniciar el file input cada que se cierra un modal */
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
        maxFileCount: 1,
        overwriteInitial: false,
        initialPreviewAsData: true, //...
        validateInitialCount: true,
        allowedFileExtensions: ['doc', 'docx']//['pdf']
    });
})
/* ******************** */

function TraeTitulo(ctrl) {
    var id = ctrl;
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/TituloPonencia',
        data: "{'idponencia':'" + id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error" + jqXHR.responseText);
        }, success: function (informacion) {
            var jsonD = $.parseJSON(informacion.d);
            $('#spanTituloEv').html(jsonD.titulo);
        }
    });
}

/* Administrar evaluadores de la ponencia */
// guardar el id de la ponencia en una variable global
let globalIdPonencia, globalTitulo;

function editarEvaluador(idPonencia){
    // Guardo estos datos para usarlos al hacer el insert de las invitaciones

    globalIdPonencia = idPonencia;
    //globalTitulo = titulo;
    TraeTitulo(idPonencia);
    let idEdicion = $('#selectEd').val();


    //$('#spanTituloEv').html(titulo);
    $('#modalEvaluadores').modal('show');

    var data = {
        idPonencia: globalIdPonencia,
        idEdicion: idEdicion
    };

    $.ajax({
        type: "POST",
        url: "invitaciones.aspx/ListarEvaluadores",
        data: JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
        },
        success: function(tablaEvaluadores) {
            $('#listaEvaluadores').html(tablaEvaluadores.d);
            let idTable = "tablaEvaluadores";
            let orden = [[0, 'asc'], [1, 'asc']];
            let contexto = "No hay evaluadores asignados.";
            dataTable(idTable, orden, contexto);
        }
    });
}
/* ******************** */


/* Enviar invitaciones */
$("#btnEnviarInvitacion").click(function() {
    var eval = $('#ddleval').val();
    return new Promise(function(resolve, reject) {
        $.confirm({
            escapeKey: true,
            backgroundDismiss: true,
            icon: 'fa fa-circle-question',
            title: '¡Confirmación!',
            content: '¿Desea asignar al evaluador esta ponencia?',
            type: 'blue',
            buttons: {
                Asignar: {
                    btnClass: 'btn-primary text-white',
                    keys: ['enter'],
                    action: function(){
                        if(eval == 0){
                            $.alert({
                                backgroundDismiss: true,
                                icon: 'fa fa-warning',
                                title: '¡Advertencia!',
                                content: 'Por favor, seleccione un evaluador primero',
                                type: 'orange'
                            });
                        } else {
                            var data = {
                                    idPonencia: globalIdPonencia,
                                    idEvaluador: eval
                                 };

                            // Manda invitaciones
                            $.ajax({
                                type: "POST",
                                url: "invitaciones.aspx/EnviaInvitacion",
                                data: JSON.stringify(data),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                beforeSend: function() {
                                    $('#btnEnviarInvitacion').html('<i class="fa fa-spinner fa-spin"></i> Enviando...');
                                    $('#btnEnviarInvitacion').attr('disabled', true);
                                },
                                error: function (jqXHR, textStatus, errorThrown) {
                                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                                },
                                success: function(response) {
                                    var JsonD = $.parseJSON(response.d);

                                    $('#btnEnviarInvitacion').html('Agregar');
                                    $('#btnEnviarInvitacion').attr('disabled', false);

                                    if (JsonD.success == 1) {
                                        $.alert({
                                            backgroundDismiss: true,
                                            icon: 'fa fa-warning',
                                            title: '¡Advertencia!',
                                            content: 'El evaluador ya se encuentra asignado a esta ponencia.',
                                            type: 'orange',
                                            onClose: function(){
                                                $("#txtEvaluador").val('');
                                                limpiaAutocomplete();
                                            }
                                        });
                                    } else if (JsonD.success == 2) {
                                        PNotify.success({
                                            text: 'Invitación enviada.',
                                            delay: 3000,
                                            addClass: 'translucent'
                                        });
                                        editarEvaluador(globalIdPonencia);
                                        //EnviarCorreo(globalIdPonencia,idEvaluador);
                                        $("#txtEvaluador").val('');
                                        limpiaAutocomplete();
                                        
                                    } else if(JsonD.success == 3) {
                                        $.alert({
                                            backgroundDismiss: true,
                                            icon: 'fa fa-warning',
                                            title: '¡Advertencia!',
                                            content: 'No es posible asignarle la ponencia al evaluador porque le pertenece.',
                                            type: 'orange',
                                            onClose: function(){
                                                $("#txtEvaluador").val('');
                                                limpiaAutocomplete();
                                            }
                                        });
                                    } else if(JsonD.success == 4) {
                                        $.alert({
                                            backgroundDismiss: true,
                                            icon: 'fa fa-warning',
                                            title: '¡Advertencia!',
                                            content: 'No es posible asignar la ponencia porque ya se enviaron resultados al ponente o hasta que envíe las correcciones.',
                                            type: 'orange',
                                            onClose: function(){
                                                $("#txtEvaluador").val('');
                                                limpiaAutocomplete();
                                            }
                                        });
                                    }

                                    editarEvaluador(globalIdPonencia);
                                }
                            });
                        }
                    }
                },
                Cancelar: function(){
                }
            }
        });
    });
});
/* ******************** */


/* Esto es para eliminar el confirm (conflicto con moda) - Lo elimina del DOM  */
//ESTO ES IMPORTANTE SI PLANEO REUTILIZAR LOS ALERTS DENTRO DE UN MODAL DE BOOTSTRAP:P
// Si no es dentro de bootstrap funciona bien con las opciones del mismo plugin
$(document).on('keydown', function(event) {
    if (event.keyCode === 27) {
        $('.jconfirm').remove();
    }
});
/* ******************** */

/* Controla las pills */
$('#btnMuestraAutores').on('click', function(){
    $('#btnPillAutor').trigger('click');
});

$('#btnMuestraDatos').on('click', function(){
    $('#btnPillData').trigger('click');
});

$('#btnMuestraArchivo').on('click', function(){
    $('#btnPillFile').trigger('click');
});

$('#btnRegresaAutores').on('click', function(){
    $('#btnPillAutor').trigger('click');
});
/* ******************** */


/* Tabla de Autores */
function TablaAut(id) {  //aqui se crea la tabla
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/TablaListarAutores',
        data: "{'id':'" + id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error" + jqXHR.responseText);
        },
        success: function (tabla) {
            $("#generarTablaAutores").html(tabla.d); //nombre del id del div de la tabla
            setTimeout(function myfunction() {
                let idTable = "tablaAutores";
                let orden = [[0, 'asc']];
                let contexto = "No existen autores para esta ponencia.";
                dataTable('tablaAutores');
            }, 100);
        }
    });
  };
/* ******************** */


/* trae datos generales */
function verDatos(id) {

    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/TraeDatos',
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
}
/* ******************** */


/* Retirar evaluador */
function retirarEvaluador(idPonencia, idUsuario){
    return new Promise(function(resolve, reject) {
        $.confirm({
            escapeKey: true,
            backgroundDismiss: true,
            icon: 'fa fa-circle-question',
            title: '¡Confirmación!',
            content: '¿Desea retirar de esta ponencia al evaluador?',
            type: 'orange',
            buttons: {
                Retirar: {
                    btnClass: 'btn-primary text-white',
                    keys: ['enter'],
                    action: function(){
                        var data = {
                                idPonencia: idPonencia,
                                idEvaluador: idUsuario
                            };

                            // Manda invitaciones
                            $.ajax({
                                type: "POST",
                                url: "invitaciones.aspx/RetiraInvitacion",
                                data: JSON.stringify(data),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                error: function (jqXHR, textStatus, errorThrown) {
                                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                                },
                                success: function(response) {
                                    var JsonD = $.parseJSON(response.d);

                                if (JsonD.success == 1) {
                                    TablaInvitaciones();
                                    PNotify.success({
                                        text: 'Evaluador retirado de la ponencia.',
                                        delay: 3000,
                                        addClass: 'translucent'
                                    });
                                } else if (JsonD.success == 2) {
                                    PNotify.info({
                                        text: 'No se puede retirar un evaluador si ya empezó/terminó una evaluación de esta ponencia.',
                                        delay: 3000,
                                        addClass: 'translucent'
                                    });
                                } else {
                                    PNotify.danger({
                                        text: 'Ocurrió un error, favor de intentar más tarde.',
                                        delay: 3000,
                                        addClass: 'translucent'
                                    });
                                }

                                editarEvaluador(globalIdPonencia);
                            }
                        });
                    }
                },
                Cancelar: function(){
                }
            }
        });
    });
}

function EnviarCorreo(ctrl,ctrl2) {
    var idPonencia = ctrl;
    var idUsuario = ctrl2;
    var obj = {};
    obj.ponencia = idPonencia;
    obj.usuario = idUsuario;
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/EnviarCorreo',
        data: JSON.stringify(obj),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function() {
            $('#loading').show();
          },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error" + jqXHR.responseText);
        },
        success: function (valor) {
            $('#loading').hide();
            var JsonD = $.parseJSON(valor.d)
            if (JsonD.success == 1) {
                PNotify.success({
                    text: 'El correo ha sido enviado correctamente.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                editarEvaluador(idPonencia);
                TablaInvitaciones();
            }
        },
    });
}
/* ******************** */

// function fetchComentario(id) {

//     $.ajax({
//         type: 'POST',
//         url: 'invitaciones.aspx/fetchComentario',
//         data: "{'id':'" + id + "'}",
//         contentType: "application/json; charset=utf-8",
//         dataType: "json",
//         error: function (jqXHR, textStatus, errorThrown) {
//             console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
//         },
//         success: function (datos) {
//             var JsonD = $.parseJSON(datos.d);

//             // Trae el comentario
//             $('#comentarios').val(JsonD.comments);
//             // $(function () {            
//             //     showText(JsonD.comments, 0, 10);
//             // });
//         }
//     });
// }

// function fetchComentarioR(id) {

//     $.ajax({
//         type: 'POST',
//         url: 'invitaciones.aspx/fetchComentario',
//         data: "{'id':'" + id + "'}",
//         contentType: "application/json; charset=utf-8",
//         dataType: "json",
//         error: function (jqXHR, textStatus, errorThrown) {
//             console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
//         },
//         success: function (datos) {
//             var JsonD = $.parseJSON(datos.d);

//             // Trae el comentario
//             $('#comentarios').val(JsonD.comments);
//             // $(function () {            
//             //     showText(JsonD.comments, 0, 10);
//             // });
//         }
//     });
// }

$('#modalRonda').on('hidden.bs.modal', function () {
    $("#comentarios").val("");
});


// function showText(message, index, interval) {   
//     if (index < message.length) {
//       $("#comentarios").append(message[index++]);
//       setTimeout(function () { showText(message, index, interval); }, interval);
//     }    
// }

// function ConfirmarRonda(idPonencia) {
//     if($("#comentarios").val() == ""){
//         PNotify.notice({
//             text: 'Debe elegir un comentario para enviar al ponente.',
//             delay: 2500,
//             styling: 'bootstrap3'
//         });
//     } else {
//         $("#modalRondaC").modal('show');
//         var comentario = $('#comentarios').val();
//         $(".ronda").attr("idPonencia", "" + idPonencia + "");
//         $(".ronda").attr("onclick", "NuevaRonda(" + idPonencia + ",'" + comentario + "');");
//         $("#modalRonda").modal("hide");
//     }    
// };

// function NuevaRonda(idPonencia, comentario) {
//     var obj = {};
//     obj.idPonencia = idPonencia;
//     obj.comentario = comentario;
//     $.ajax({
//         type: 'POST',
//         url: 'invitaciones.aspx/NuevaRonda',
//         data: JSON.stringify(obj),
//         contentType: "application/json; charset=utf-8",
//         dataType: "json",
//         error: function (jqXHR, textStatus, errorThrown) {
//             console.log("Error" + jqXHR.responseText);
//         },
//         success: function (valor) {
//             var JsonD = $.parseJSON(valor.d)
//             if (JsonD.success == 1) {
//                 PNotify.success({
//                     text: 'Se asigno una nueva ronda correctamente.',
//                     delay: 2500,
//                     styling: 'bootstrap3'
//                 });
//                 TablaInvitaciones();
//             } else if (JsonD.success == 2) {
//                 PNotify.notice({
//                     text: 'No se puede asignar una nueva ronda porque no cuenta con evaluaciones.',
//                     delay: 2500,
//                     styling: 'bootstrap3'
//                 });
//             }
//         },
//     });
// }

///////**** MODAL CONFIRMAR ENVIO ****////////

// function enviarResultados(idPonencia, comentario, resultado) {
//     var obj = {};
//     obj.idPonencia = idPonencia;
//     obj.comentario = comentario;
//     obj.resultado = resultado;
//     // console.log("2134");
//     $.ajax({
//         type: 'POST',
//         url: 'invitaciones.aspx/enviarResultados',
//         data: JSON.stringify(obj),
//         contentType: "application/json; charset=utf-8",
//         dataType: "json",
//         error: function (jqXHR, textStatus, errorThrown) {
//             console.log("Error" + jqXHR.responseText);
//         },
//         success: function (valor) {
//             var JsonD = $.parseJSON(valor.d)
//             if (JsonD.success == 1) {
//                 PNotify.success({
//                     text: 'Se han enviado los resultados correctamente.',
//                     delay: 2500,
//                     styling: 'bootstrap3'
//                 });
//                 TablaInvitaciones();
//             } else if (JsonD.success == 2) {
//                 PNotify.notice({
//                     text: 'No se pueden enviar resultados porque no cuenta con evaluaciones.',
//                     delay: 2500,
//                     styling: 'bootstrap3'
//                 });
//             }
//         },
//     });
// }

///////**** MODAL CONFIRMAR ENVIO ****////////
 
function aprobarPonencia(idPonencia){
    var obj = {}
    obj.idPonencia = idPonencia
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/aprobarResultado',
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
                    text: 'Se han enviado los resultados correctamente.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                TablaInvitaciones();
            } else if (JsonD.success == 2) {
                PNotify.notice({
                    text: 'Ha ocurrido un error.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
            }
        },
    });
}

function aprobarCambiosPonencia(idPonencia){
    var obj = {}
    obj.idPonencia = idPonencia
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/aprobarCambiosResultado',
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
                    text: 'Se han enviado los resultados correctamente.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                TablaInvitaciones();
            } else if (JsonD.success == 2) {
                PNotify.notice({
                    text: 'Ha ocurrido un error.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
            }
        },
    });
}

function rechazarPonencia(idPonencia){
    var obj = {}
    obj.idPonencia = idPonencia
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/rechazarResultado',
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
                    text: 'Se han enviado los resultados correctamente.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                TablaInvitaciones();
            } else if (JsonD.success == 2) {
                PNotify.notice({
                    text: 'Ha ocurrido un error.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
            }
        },
    });
}
///////**** MODAL ENVIAR RESULTADOS ****////////

function confirmarResultados(idPonencia, resultado) {
    switch(resultado){
        case '1':
            aprobarPonencia(idPonencia);
            break;
        case '2':
            aprobarCambiosPonencia(idPonencia);
            break;
        case '3':
            rechazarPonencia(idPonencia);
            break;
        default:
            break;
    }
    TablaInvitaciones();
};

function modalConfirmar(){
    var resultado = $('#resultados').val();
    var idPonencia = $('#id').val();
    var res = "";
    switch (resultado){
        case "1":
            res = "Aprobada";
            break;
        case "2":
            res = "Aprobada con cambios";
            break;
        case "3":
            res = "Rechazada";
            break;
    }
    if(resultado!=0){
        $('#modalComentarios').modal('hide');
        $('#modalComentariosC').modal('show');
        $('#spnAccion').html(res);
        $(".result").attr("onclick", "confirmarResultados(" + idPonencia + ",'" + resultado + "');");
    } else {
        notificacionResultados();
    }
}

$('#modalComentarios').on('hidden.bs.modal', function () {
    // $("#comentarios").val("");
    $("#resultados").val(0);
    $("#btnAprobar").prop('checked', false);
    $("#btnRechazar").prop('checked', false);
    $("#btnAprobadaCambios").prop('checked', false);
});

///////**** MODAL ENVIAR RESULTADOS ****////////

$('#btnAprobar').on('click', function () {        
    $('#resultados').val(1);
});

$('#btnAprobadaCambios').on('click', function () {        
    $('#resultados').val(2);
});

$('#btnRechazar').on('click', function () {        
    $('#resultados').val(3);
});

function tablaComentarios(id){
    $.ajax({
        type: 'POST',
        url: 'ediciones.aspx/TablaComentarios',
        data: "{'id':'" + id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
        },
        success: function (tabla) {
            $("#GenerarTablaComentario").html(tabla.d); //nombre del id del div de la tabla
            setTimeout(function myfunction() {
                //estiloDataTable();
            }, 100);
        }
    });
}

function verComentarios(idPonencia) {                      
    $.ajax({
        type: 'POST',
        url: 'invitaciones.aspx/VerComentarios',
        data: "{'id':'" + idPonencia + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
        },
        success: function (datos) {
            // if (datos.d == "") {
            //     PNotify.notice({
            //         text: 'No hay comentarios disponibles.',
            //         delay: 3000,
            //         addClass: 'translucent'
            //     });
            // } else {                        
                $("#comentariosBox").html(datos.d);
                $('#id').val(idPonencia);
                setTimeout(function myfunction() {
                    dataTableComents();
                    $('#modalComentarios').modal('show');
                }, 100);                
            // }                    
        }
    });
};

// function verComentariosRonda(idPonencia) {                      
//     $.ajax({
//         type: 'POST',
//         url: 'invitaciones.aspx/VerComentariosRonda',
//         data: "{'id':'" + idPonencia + "'}",
//         contentType: "application/json; charset=utf-8",
//         dataType: "json",
//         error: function (jqXHR, textStatus, errorThrown) {
//             console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
//         },
//         success: function (datos) {
//             if (datos.d == "") {
//                 PNotify.notice({
//                     text: 'No hay evaluaciones disponibles.',
//                     delay: 3000,
//                     addClass: 'translucent'
//                 });
//             } else {                        
//                 $("#comentariosBoxNR").html(datos.d);
//                 setTimeout(function myfunction() {
//                     dataTableComents2();
//                     $("#modalRonda").modal('show');
//                     $(".nronda").attr("id", "" + idPonencia + "");
//                     $(".nronda").attr("onclick", "ConfirmarRonda(" + idPonencia + ");");
//                 }, 100);
//             }                    
//         }
//     });
// };

// function verComentariosResultado(idPonencia) {                      
//     $.ajax({
//         type: 'POST',
//         url: 'invitaciones.aspx/VerComentariosRonda',
//         data: "{'id':'" + idPonencia + "'}",
//         contentType: "application/json; charset=utf-8",
//         dataType: "json",
//         error: function (jqXHR, textStatus, errorThrown) {
//             console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
//         },
//         success: function (datos) {
//             if (datos.d == "") {
//                 PNotify.notice({
//                     text: 'No hay evaluaciones disponibles.',
//                     delay: 3000,
//                     addClass: 'translucent'
//                 });
//             } else {                        
//                 $("#comentariosBoxR").html(datos.d);
//                 setTimeout(function myfunction() {
//                     dataTableComents2();
//                     $("#modalResultados").modal('show');
//                     $(".nresultados").attr("id", "" + idPonencia + "");
//                     $(".nresultados").attr("onclick", "confirmarResultados(" + idPonencia + ");");
//                 }, 100);
//             }                    
//         }
//     });
// };

// function onlyOne(checkbox) {
//     var checkboxes = document.getElementsByName('check')
//     checkboxes.forEach((item) => {
//         if (item !== checkbox) item.checked = false
//     })
// }

function dataTableComents(page, leng) {
    $('#tablaComentarios').DataTable({
        "lengthMenu": [5, 10, 25, 50, 75, 100],
        "pageLength": leng,
        "info": false,
        pagingType: 'numbers',
        "order": [[0, 'asc']],
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

function dataTableComents2(page, leng) {
    $('#tablaComentarios2').DataTable({
        "lengthMenu": [5, 10, 25, 50, 75, 100],
        "pageLength": leng,
        "info": false,
        pagingType: 'numbers',
        "order": [[0, 'asc']],
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

function dataTableComentas(page, leng) {
    $('#tablaComentas').DataTable({
        "lengthMenu": [5, 10, 25, 50, 75, 100],
        "pageLength": leng,
        "info": false,
        pagingType: 'numbers',
        "order": [[0, 'asc']],
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

// function notificacionRonda(){
//     PNotify.notice({
//         text: 'No es posible pasar a la siguiente ronda si la ponencia no está evaluada.',
//         delay: 3000,
//         addClass: 'translucent'
//     });
// }

function notificacionResultados(){
    PNotify.notice({
        text: 'No se ha seleccionado un resultado.',
        delay: 3000,
        addClass: 'translucent'
    });
}

// function limpiar(){
//     $('#comentariosR').val('')
// }