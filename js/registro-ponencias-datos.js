/* Agregar palabras */
var idPalabra = 0;
var arrayPalabras = [];
var contadorPal = 0;

$('#btnPalabras').on('click', function() {
    if(arrayPalabras.length < 5){
        if($('#txtPal').val() != ''){
            arrayPalabras.push($('#txtPal').val());

            idPalabra++;

            if (idPalabra == 1) {
                $('#divPal').after('<div id="divPal' + idPalabra + '"  class="row mb-3 g-3"><div class="offset-xxl-4 col-xxl-4 offset-sm-3 col-sm-6 col-12"><div class="row g-3" id="rowPal' + idPalabra + '" ></div></div></div>');
            } else {
                $('#divPal'+(idPalabra-1)).after('<div id="divPal' + idPalabra + '"  class="row mb-3 g-3"><div class="offset-xxl-4 col-xxl-4 offset-sm-3 col-sm-6 col-12"><div class="row g-3" id="rowPal' + idPalabra + '" ></div></div></div>');
            }
            $('#rowPal' + idPalabra).append('<div id="inputPal' + idPalabra + '" class="col-xxl-10 col-sm-10 col-10  d-sm-block"></div>');
            $('#rowPal' + idPalabra).append('<div id="delPal' + idPalabra + '" class="col-xxl-2 col-sm-2 col-2 d-grid d-grid d-block ms-0"></div>');

            $('<input/>').attr({ type: 'text', class: 'form-control', value: $("#txtPal").val(), id: 'txtPal' + idPalabra, disabled: 'disabled' }).appendTo('#inputPal'+idPalabra);
            $('#txtPal').val('');
            $('#txtPal').focus();

            $('<button>').attr({ type: 'button', class: 'btn btn-danger eliminar icon-trash-o h-100', value: '', onclick: '', id: 'btnPalabras' + idPalabra }).appendTo('#delPal' + idPalabra);

            contadorPal++;
            if (contadorPal >= 3){
              $('#numPalabras').css("color", "");
            } else {
              $('#numPalabras').css("color", "red");
            }
            $('#numPalabras').html("(" + contadorPal + "/5)");
        } else {
          PNotify.notice({
            //title: false,
            text: 'Favor de ingresar una palabra válida.',
            delay: 3000,
              addClass: 'translucent'
          });
          $('#txtPal').focus();
        }
    } else {
      PNotify.notice({
        //title: false,
        text: 'Límite de 5 palabras alcanzado.',
        delay: 3000,
          addClass: 'translucent'
      });
    }
});

$(document).on("click", '.eliminar', function() {
    // Esto es para obtener solo los numeros del id
    var id = $(this).attr('id').replace(/\D/g,'');
    if (id != '') {
        var pos = arrayPalabras.indexOf($('#txtPal'+id).val());
        arrayPalabras.splice(pos, 1);

        $('#txtPal'+id).remove();
        $('#btnPalabras' + id).remove();
        $('#divPal' + id).hide(); //......

        contadorPal--;
        if (contadorPal >= 3){
          $('#numPalabras').css("color", "");
        } else {
          $('#numPalabras').css("color", "red");
        }
        $('#numPalabras').html("(" + contadorPal + "/5)");
    }
});
/* ******************** */


/* Guardar ponencia */
function guardarPonencia(id){
    var titulo = "", modalidad="", tema="", resumen="", palabras="";

    if ($('#txtTit')[0].checkValidity() && $('#selectMod')[0].checkValidity() && $('#selectTema')[0].checkValidity() && $('#txtRes')[0].checkValidity()) {
      if (arrayPalabras.length > 2 && arrayPalabras.length < 6) {
        palabras = arrayPalabras.join(', ');
      } else {
        $('#txtPal').focus();
        PNotify.notice({
          //title: false,
          text: 'Favor de introducir al menos 3 palabras clave.',
          delay: 3000,
            addClass: 'translucent'
        });

        return;
      }

      id = $('#idPonencia').val();
      titulo = $('#txtTit').val();
      modalidad = $('#selectMod').val();
      tema = $('#selectTema').val();
      resumen = $('#txtRes').val();

      var obj = {};
      obj.id = id;
      obj.titulo = titulo;
      obj.modalidad = modalidad;
      obj.tema = tema;
      obj.resumen = resumen;
      obj.palabras = palabras;

      $.ajax({
        type: 'POST',
        url: 'ponencias_registrar.aspx/GuardaPonencia',
        data: JSON.stringify(obj),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error" + jqXHR.responseText);
        },
        success: function (valor) {
          var JsonD = $.parseJSON(valor.d)
          if (JsonD.success == 1){
            PNotify.success({
              //title: false,
              text: 'Datos guardados correctamente.',
              delay: 3000,
                addClass: 'translucent'
            });
          } else {
            PNotify.notice({
              //title: false,
              text: 'Datos actualizados correctamente',
              delay: 3000,
                addClass: 'translucent'
            });
          }

          localStorage.setItem('idActual', JsonD.id);
          $('#idPonencia').val(JsonD.id);

          $("#pills-2").removeAttr('disabled');
          $("#pills-3").removeAttr('disabled');
          $('#pills-2').trigger('click');

          if (JsonD.titulo != '') {
            $('#lblTit').html('Editar ponencia: ' + JsonD.titulo);
          }
        }
      });
    } else {
      $('#txtRes')[0].reportValidity();
      $('#selectTema')[0].reportValidity();
      $('#selectMod')[0].reportValidity();
      $('#txtTit')[0].reportValidity();
    }
  }


$('#btnPonencia').on('click',  function() {
  var id = $('#idPonencia').val();
  guardarPonencia(id);
});
/* ******************** */


/* modificarPonencia */
function modificarPonencia(id) {

  $.ajax({
      type: 'POST',
      url: 'ponencias_registrar.aspx/ModificaPonencia',
      data: "{'id':'" + id + "'}",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      error: function (jqXHR, textStatus, errorThrown) {
          console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
      },
      success: function (datos) {
          var JsonD = $.parseJSON(datos.d);

          // Trae los datos a los inputs
          $('#idPonencia').val(JsonD.idPonencia);
          $('#txtTit').val(JsonD.titulo);
          $('#selectMod option[value="' + JsonD.idModalidad + '"]').attr("selected", "selected");
          $('#selectTema option[value="' + JsonD.idTema + '"]').attr("selected", "selected");
          $('#txtRes').val(JsonD.resumen);
          // // Dividir el campo según sus registros y por ", "
          var arrayPalabrasClave = (JsonD.palabrasClave).split(", ");
          // //verificar si son uno o más registros
          if (arrayPalabrasClave.length > 0 && arrayPalabrasClave[0] != '') {
               //Recorrer el array y generar tantos inputs como registros haya
               arrayPalabrasClave.forEach(function (palabra) {
                   //Se agrega valor al array que se usa para grabar
                   arrayPalabras.push(palabra);

                   idPalabra++;
                   // se genera la estructura
                   if (idPalabra == 1) {
                       $('#divPal').after('<div id="divPal' + idPalabra + '"  class="row mb-3 g-3"><div class="offset-xxl-4 col-xxl-4 offset-sm-3 col-sm-6 col-12"><div class="row g-3" id="rowPal' + idPalabra + '" ></div></div></div>');
                   } else {
                       $('#divPal' + (idPalabra - 1)).after('<div id="divPal' + idPalabra + '"  class="row mb-3 g-3"><div class="offset-xxl-4 col-xxl-4 offset-sm-3 col-sm-6 col-12"><div class="row g-3" id="rowPal' + idPalabra + '" ></div></div></div>');
                   }
                   $('#rowPal' + idPalabra).append('<div id="inputPal' + idPalabra + '" class="col-10"></div>');
                   $('#rowPal' + idPalabra).append('<div id="delPal' + idPalabra + '" class="col-2 d-grid d-block"></div>');

                   $('<input/>').attr({ type: 'text', class: 'form-control', value: $("#txtPal").val(), id: 'txtPal' + idPalabra, disabled: 'disabled' }).appendTo('#inputPal' + idPalabra);
                   $('#txtPal').val('');
                   $('#txtPal').focus();

                   $('<button>').attr({ type: 'button', class: 'btn btn-danger eliminar icon-trash-o h-100', value: '', onclick: '', id: 'btnPalabras' + idPalabra }).appendTo('#delPal' + idPalabra);

                   //se asigna cada palabra a cada campo generado
                   $('#txtPal' + idPalabra).val(palabra);

                   contadorPal++;
                   if (contadorPal >= 3) {
                       $('#numPalabras').css("color", "");
                   } else {
                       $('#numPalabras').css("color", "red");
                   }
                   $('#numPalabras').html("(" + contadorPal + "/5)");
               });
          }

          // activa resumen para contar sus caracteres y las palabras clave y desbloquea las pestañas. Cambiar el título de la página.
          $('#txtRes').trigger("input");
          $("#pills-2").removeAttr('disabled');
          $("#pills-3").removeAttr('disabled');

          $('#lblTit').html('Editar ponencia: ' + JsonD.titulo);
      }
  });
  }

  /* ******************** */
  
  
/* Agregar palabras al presionar Enter cuando está focused el input de las palabras */
$('#txtPal').on("keydown", function (event) {
    // el código de "Enter" es el 13
    if (event.which === 13) {
        event.preventDefault(); // Esta línea es para que no se ejecute lo de colapsar el menú
        $('#btnPalabras').trigger('click');
    }
});
/* ******************** */
