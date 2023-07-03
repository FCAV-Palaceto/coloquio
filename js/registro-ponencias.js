window.onload = function(){
  //$.get('Handler2.ashx', function(data) {
  //    $('#handler').html(data);
  //});
  //$('#tablaAutores').hide();

  let idpon = localStorage.getItem('idActual');
  $('#idPonencia').val(idpon);
  // let ronda = localStorage.getItem('rondaActual');
  // $('#ronda').val(ronda);

  setTimeout(function myfunction() {
    //verifica que se haya hecho click desde un botón de modificar
    if (idpon != 0) {
      //Trae los registros
      modificarPonencia(idpon);
    }
  }, 500);
};


/* Cargar la última tab activa */
const pillsTab = document.querySelector('#pills-tab');
const pills = pillsTab.querySelectorAll('button[data-bs-toggle="pill"]');

pills.forEach(pill => {
  pill.addEventListener('shown.bs.tab', (event) => {
    const { target } = event;
    const { id: targetId } = target;

    savePillId(targetId);

    // Ocultar / mostrar la lista de autores según la pestaña activa
    if (targetId == 'pills-2') {
      setTimeout(() => {
        let id = $('#idPonencia').val();
        TablaAut(id);
      }, 500);
    }
  });
});

const savePillId = (selector) => {
  localStorage.setItem('activePillId', selector);
};

const getPillId = () => {
  const activePillId = localStorage.getItem('activePillId');

  // if local storage item is null, show default tab <- Al hacer click en registrar ponencia se le da a la variable "pills-1", el id de la primera pill
  if (!activePillId) return;

  // call 'show' function
  const someTabTriggerEl = document.querySelector(`#${activePillId}`)
  const tab = new bootstrap.Tab(someTabTriggerEl);

  tab.show();

  // setTimeout(() => {
  //   $('#'+activePillId).trigger('click');
  // }, 600);
};

// get pill id on load
getPillId();
/* ******************** */


/* Comprueba si existe una ponencia cargada o no */
setTimeout(function myfunction() {
  $.get('buscar_archivo.ashx', function(data) {
    $('#handler').html(data);
  });
}, 1000);
/* ********************* */


/* Se inicializa el plugin */
$('#file-input').fileinput({
  theme: 'fa5',
  language: 'es',
  uploadUrl: 'subir_archivo.ashx',
  //deleteUrl: "/site/file-delete",
  maxFileSize: 8192,
  maxFileCount: 1,
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
  $('#btnAutorClick').val(1);
  validarPonencia($('#idPonencia').val());
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
                      $('#btnGuardar').addClass('btn-secondary');
                      $('#btnGuardar').removeClass('btn-primary');
                      PNotify.success({
                        text: 'Archivo eliminado correctamente.',
                        delay: 3000,
                        addClass: 'translucent'
                      });
                  }
              },
              Cancelar: function(){
              }
          }
      });
  });
});
/* ******************** */
