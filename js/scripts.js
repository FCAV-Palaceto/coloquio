// Scripts del sistema
//

window.addEventListener('DOMContentLoaded', event => {

  // Toggle the side navigation
  const sidebarToggle = document.body.querySelector('#sidebarToggle');
  if (sidebarToggle) {
      // Uncomment Below to persist sidebar toggle between refreshes
      // if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
      //     document.body.classList.toggle('sb-sidenav-toggled');
      // }
      sidebarToggle.addEventListener('click', event => {
          event.preventDefault();
          document.body.classList.toggle('sb-sidenav-toggled');
          localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
      });
  }

  // Para setear el estado del collapse
  if ($('.nav-link').hasClass('collapsed')) {
    $('div.collapse').collapse('hide');
  }

});

/* Contador de caracteres */
function contador(obj){
  var textTam=obj.value.length;
  var maxlen = obj.maxLength;
  var idspan = "cont" + obj.id;

  if(textTam == maxlen || textTam == 0){
    document.getElementById(idspan).innerHTML='<span style="color: red;">('+textTam + '/' + maxlen + ')</span>';
  }else{
    document.getElementById(idspan).innerHTML='('+textTam + '/' + maxlen + ')';
  }
}
/* ******************** */

/* Estilos de la DataTable */
function dataTable(idTabla, orden, contexto) {
$('#' + idTabla).DataTable({
    "lengthMenu": [5, 10, 25, 50, 75, 100],
    "pageLength": 10,
    "info": false,
    pagingType: 'numbers',
    "order": orden,
    language: {
        "decimal": ".",
        "emptyTable": "",
        "info": "Mostrando del _START_ al _END_ de un total de _TOTAL_ registros",
        "infoEmpty": "",
        "infoFiltered": "<br/>(Filtrado de <b>_MAX_</b> registros en total)",
        "infoPostFix": "",
        "thousands": ",",
        "lengthMenu": "Mostrando _MENU_ registros",
        "loadingRecords": "Cargando...",
        "processing": "Procesando...",
        "search": "B&uacute;squeda:",
        "zeroRecords": contexto
    }
});
};
/* ******************** */


/* Colapsar submenú al abrir otro */
$('.nav-link').not('.no-toggle').on('click', function () {
  $('.navlink').removeClass('collapsed');
  $('div.collapse').collapse('hide');
  $(this).next('div.collapse').collapse('show');
});
/* ******************** */
