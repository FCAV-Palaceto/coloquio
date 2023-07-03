/* Validar ponencia */
function validarPonencia(id){
    var titulo = "", modalidad="", tema="", resumen="", palabras="";

    if ($('#txtTit')[0].checkValidity() && $('#selectMod')[0].checkValidity() && $('#selectTema')[0].checkValidity() && $('#txtRes')[0].checkValidity()) {
      if (arrayPalabras.length > 2 && arrayPalabras.length < 6) {
        palabras = arrayPalabras.join(', ');
      } else {
        $('#pills-1').trigger('click');
        $('#txtPal').focus();
        PNotify.notice({
          //title: false,
          text: 'Favor de introducir al menos 3 palabras clave.',
          delay: 3000,
            addClass: 'translucent'
        });

        return;
      }

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
        url: 'ponencias_registrar.aspx/ValidaPonencia',
        data: JSON.stringify(obj),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Error" + jqXHR.responseText);
        },
        success: function (valor) {
          var JsonD = $.parseJSON(valor.d)
          if($('#btnAutorClick').val() == 0){
            if (JsonD.success == 1){
              PNotify.notice({
                //title: false,
                text: 'Favor de subir un archivo en formato .DOC/.DOCX y posteriormente haga click en Subir archivo',
                delay: 4000,
                addClass: 'translucent'
              });
            } else if (JsonD.success == 2) {
              $('#pills-2').trigger('click');
              PNotify.notice({
                //title: false,
                text: 'Favor de agregar al menos 1 autor.',
                delay: 3000,
                  addClass: 'translucent'
              });
            } else if (JsonD.success == 3 || JsonD.success == 5){
              let mensaje, ruta;
              if (localStorage.getItem('estadoRegistro') == 0 ){
                mensaje = 'Ponencia guardada correctamente.';
              } else {
                mensaje = 'Ponencia actualizada correctamente.'
              }
              if (JsonD.success == 3) {
                ruta = "ponencias_listar.aspx";
              } else{
                ruta = "../administrador/invitaciones.aspx";
              }
              PNotify.success({
                //title: false,
                text: mensaje,
                delay: 3000,
                addClass: 'translucent'
              });
              setTimeout(() => {
                window.location.href = ruta;
              }, 3001);
            } else {
              PNotify.error({
                //title: false,
                text: 'Su sesión ha caducado por inactividad, vuelva a ingresar al sistema, por favor.',
                delay: 3000,
                addClass: 'translucent'
              });
            }
          } else $('#btnAutorClick').val(0);          
        }
      });
    } else {
      $('#pills-1').trigger('click');
      setTimeout(() => {
        $('#txtRes')[0].reportValidity();
        $('#selectTema')[0].reportValidity();
        $('#selectMod')[0].reportValidity();
        $('#txtTit')[0].reportValidity();
      }, 500);
    }
  }


$('#btnGuardar').on('click',  function() {
  var id = $('#idPonencia').val();
  validarPonencia(id);
});
/* ******************** */