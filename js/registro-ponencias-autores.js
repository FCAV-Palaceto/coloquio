/* Generales */
$("#btnAutorSig").on("click", function () {
  var id = $("#idPonencia").val();
  verificaAutor(id);
});

var myModalEl = document.getElementById("modaladd");
myModalEl.addEventListener("hidden.bs.modal", function (event) {
  limpiaAutor();
});

function limpiaAutor() {
  let valSelect = $("#selectAut").val();

  $("#idAutor").val("0");
  $("#selectAut").prop("selectedIndex", 0);
  $("#inputEstado").prop("selectedIndex", 0);
  cargarInstitucion();
  $("#inputSex").prop("selectedIndex", 0);
  $("#txtAut").val("");
  $("#txtCor").val("");
}
/* ******************** */

/* Agregar autores */
function agregarAutor(idPonencia) {  
  var 
    idAutor = $("#idAutor").val(),
    autor = $("#txtAut").val(),
    tipo = $("#selectAut").val(),
    email = $("#txtCor").val(),
    institucion = $("#inputInstitucion").val(),
    txtInst = $("#inputInstitucion option:selected").text(),
    estado = $("#inputEstado").val(),
    //sexo = $("#inputSex").val(),
    regex = /^[-\w.%+]{1,64}@(?:[A-Z0-9-]{1,63}\.){1,125}[A-Z]{2,63}$/i;

  if(autor == ""){
    $('#txtAut').addClass("is-invalid");
    $("#txtAut").focus();
    PNotify.notice({
      text: 'Por favor, ingrese el nombre completo del autor.',
      delay: 2500,
      addClass: 'translucent'
    });
    return;
  }

  if(email == "") {
    $('#inputEmail').addClass("is-invalid");
    $("#inputEmail").focus();
    PNotify.notice({
        text: 'Por favor, ingrese el correo electrónico del autor.',
        delay: 2500,
        addClass: 'translucent'
    });
    return;
  } else if (!regex.test(email)) {
      $("#inputEmail").focus();
      PNotify.notice({
          text: 'El correo no es válido.',
          delay: 2500,
          addClass: 'translucent'
      });
      return;
  }

  // if(sexo == "0"){
  //   $('#inputSex').addClass("is-invalid");
  //   $("#inputSex").focus();
  //   PNotify.notice({
  //     text: 'Por favor, seleccione el género del autor.',
  //     delay: 2500,
  //     addClass: 'translucent'
  //   });
  //   return;
  // }

  if(estado == "0"){
    $('#inputEstado').addClass("is-invalid");
    $("#inputEstado").focus();
    PNotify.notice({
      text: 'Por favor, seleccione el estado de la institución del autor.',
      delay: 2500,
      addClass: 'translucent'
    });
    return;
  }

  if(institucion == "0"){
    $('#inputInstitucion').addClass("is-invalid");
    $("#inputInstitucion").focus();
    PNotify.notice({
      text: 'Por favor, seleccione la institución del autor.',
      delay: 2500,
      addClass: 'translucent'
    });
    return;
  }

  if(autor == "0"){
    $('#selectAut').addClass("is-invalid");
    $("#selectAut").focus();
    PNotify.notice({
      text: 'Por favor, seleccione el tipo de autor.',
      delay: 2500,
      addClass: 'translucent'
    });
    return;
  }

  sexo = "";

  var obj = {};
  obj.idPonencia = idPonencia;
  obj.idAutor = idAutor;
  obj.autor = autor;
  obj.institucion = institucion;
  obj.tipo = tipo;
  obj.sexo = sexo;
  obj.correo = email;
  obj.estado = estado;
  obj.txtInst = txtInst;

  $.ajax({
    type: "POST",
    url: "ponencias_registrar.aspx/AgregaAutor",
    data: JSON.stringify(obj),
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    error: function (jqXHR, textStatus, errorThrown) {
      console.log("Error" + jqXHR.responseText);
    },
    success: function (valor) {
      var JsonD = $.parseJSON(valor.d);
      var texto = "";
      if (JsonD.success == 1) {
        texto = "Autor agregado correctamente.";
        $('#btnAutorClick').val(1);
        validarPonencia($('#idPonencia').val());
      } else if (JsonD.success == 2) {
        texto =
          "Su sesión ha caducado por inactividad, vuelva a ingresar al sistema, por favor.";
          setTimeout(function myfunction() {
            window.location.href = "../../login/login.aspx";
          }, 3000);
      } else if (JsonD.success == 3) {
        texto = "Autor actualizado correctamente.";
      }

      if (JsonD.success == 2) {
        PNotify.notice({
          text: texto,
          delay: 3000,
          addClass: "translucent",
        });
      } else {
        PNotify.success({
          text: texto,
          delay: 3000,
          addClass: "translucent",
        });
      }

      $("#modaladd").modal("hide");
      TablaAut(idPonencia);
    },
  });
}

$("#btnAutor").on("click", function () {
  var id = $("#idPonencia").val();
  agregarAutor(id);
});
/* ******************** */

/* Tabla de Autores */
function TablaAut(id) {
  //aqui se crea la tabla
  var obj = {};
  obj.id = id;
  $.ajax({
    type: "POST",
    url: "ponencias_registrar.aspx/TablaListarAutores",
    data: JSON.stringify(obj),
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    error: function (jqXHR, textStatus, errorThrown) {
      console.log("Error" + jqXHR.responseText);
    },
    success: function (tabla) {
      $("#generarTabla").html(tabla.d); //nombre del id del div de la tabla
      setTimeout(function myfunction() {
        estiloDataTable();
      }, 100);
    },
  });
}

// function estiloDataTable(page, leng) {
//   $('#tabla').DataTable({
//       "lengthMenu": [5, 10, 25, 50, 75, 100],
//       "pageLength": leng,
//       pagingType: 'numbers',
//       "order": [[4, 'asc'], [1, 'asc']],
//       language: {
//           "decimal": ".",
//           "emptyTable": "",
//           "info": "Mostrando del _START_ al _END_ de un total de _TOTAL_ registros",
//           "infoEmpty": "",
//           "infoFiltered": "<br/>(Filtrado de _MAX_ registros en total)",
//           "infoPostFix": "",
//           "thousands": ",",
//           "lengthMenu": "Mostrando _MENU_ registros",
//           "loadingRecords": "Cargando...",
//           "processing": "Procesando...",
//           "search": "B&uacute;squeda:",
//           "zeroRecords": "No hay registros",
//       }
//   });
// };
/* ******************** */

/* editar Autor */
function editarAutor(id) {
  $.ajax({
    type: "POST",
    url: "ponencias_registrar.aspx/ModificaAutor",
    data: "{'id':'" + id + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    error: function (jqXHR, textStatus, errorThrown) {
      console.log(
        "Error- Status: " +
          "jqXHR Status: " +
          jqXHR.Status +
          "jqXHR Response Text:" +
          jqXHR.responseText
      );
    },
    success: function (datos) {
      var JsonD = $.parseJSON(datos.d);

      // Trae los datos a los inputs      
      $("#idAutor").val(JsonD.idAutor);
      $("#txtAut").val(JsonD.autor);
      $("#txtCor").val(JsonD.correo);
      // $("#inputEstado").append("<option value=\""+ JsonD.estadoInstitucion +"\">" + JsonD.estadoInstitucion + "</option>");
      $("#inputEstado").val(JsonD.estadoInstitucion);
      cargarInstitucion();
      // $("#inputInstitucion").append("<option value=\""+ JsonD.institucion +"\">" + JsonD.institucion + "</option>");
      // $("#inputInstitucion").removeAttr('disabled');
      setTimeout(function myfunction() {
        $("#inputInstitucion").val(JsonD.institucion);
      }, 200);      
      // alert(JsonD.institucion);
      $("#selectAut").val(JsonD.idTipoAutor);
      //$("#inputSex").val(JsonD.sexo);
      $("#modaladd").modal("show");
    },
  });
}
/* ******************** */

/* Eliminar autor */
function eliminarAutor(id) {
  var idPonencia = $("#idPonencia").val();
  $.ajax({
    type: "POST",
    url: "ponencias_registrar.aspx/EliminarAutor",
    data: "{'idAutor':'" + id + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    error: function (jqXHR, textStatus, errorThrown) {
      console.log("Error" + jqXHR.responseText);
    },
    success: function (valor) {
      var JsonD = $.parseJSON(valor.d);
      if (JsonD.success == 1) {        
        TablaAut(idPonencia);
        $('#btnAutorClick').val(1);
        validarPonencia(idPonencia);
        PNotify.success({
          text: "El autor se eliminó correctamente.",
          delay: 3000,
          addClass: "translucent",
        });        
      } else if (JsonD.success == 2) {
        PNotify.notice({
          text: "Algo salió mal.",
          delay: 3000,
          addClass: "translucent",
        });
      }
    },
  });
}

function ConfirmarEliminar(idAutor) {
  $("#modaldel").modal("show");
  //$(".eliminar").attr("id", "" + idAutor + "");
  $("#btnEliminar").attr("onclick", "eliminarAutor(" + idAutor + ");");
}
/* ******************** */

/* Verificar autores */
function verificaAutor(idPonencia) {
  $.ajax({
    type: "POST",
    url: "ponencias_registrar.aspx/VerificarAutor",
    data: "{'idPonencia':'" + idPonencia + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    error: function (jqXHR, textStatus, errorThrown) {
      console.log("Error" + jqXHR.responseText);
    },
    success: function (valor) {
      var JsonD = $.parseJSON(valor.d);
      if (JsonD.success == 1) {
        $("#pills-3").trigger("click");
      } else if (JsonD.success == 2) {
        PNotify.notice({
          text: "Favor de agregar al menos 𝟭 autor.",
          delay: 3000,
          addClass: "translucent",
        });
      }
    },
  });
}
/* ******************** */
