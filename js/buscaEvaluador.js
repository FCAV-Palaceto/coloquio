// Variable global con el ID de evaluador
var idEvaluador = 0;

$(function () {
    // Inicializa el plugin
    $("#txtEvaluador").autocomplete({
        // El origen de los datos: request los datos que envía (la búsqueda), response lo que regresa
        source: function (request, response) {
            // Array que va a mostrar las opciones
            var arrayReturn = [];
            $.ajax({
                url: 'invitaciones.aspx/GetEvaluadores',
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ term: request.term }),
                dataType: "json",
                success: function (data) {
                    arrayReturn = JSON.parse(data.d);

                    if (arrayReturn.length > 0){
                        for (var i = 0; i < arrayReturn.length; i++){
                            arrayReturn[i]['label'] = arrayReturn[i].Nombre;
                        }
                    } else {
                        arrayReturn.push({
                            label: "No se encontró ningún evaluador.",
                            Nombre: "",
                            Correo: "Realice otra búsqueda."
                        });
                    }

                    response(arrayReturn);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                }
            });
        },
        appendTo: "#modalEvaluadores",
        // el tiemp oen milisegundos antes de comenzar a buscar una vez que se deja de teclear
        delay: 500,
        // la cantidad mínima de caracteres antes de comenzar a buscar
        minLength: 1,
        // Esto está bonito pero puede jugar en contra
        // focus: function (event, ui) {
        //     $('#txtEvaluador').val(ui.item.label);

        //     return false;
        // },
        // al seleccionar un autor, guarda su orcid, cvu o curp en otro input con data
        select: function (event, ui) {
            if(!ui.item.Nombre){
                event.preventDefault();
            } else {
                idEvaluador = ui.item.ID;
                $('#spanCorreo').html('('+ ui.item.Correo+ ')');
            }
        }
    }).autocomplete( "instance" )._renderItem = function( ul, item ) {
        return $( "<li>" )
          .append( "<div>" + item.label + "<br><span class='fst-italic small-gray'>" + item.Correo + "</span></div>" )
          .appendTo( ul );
    };
});


/* Que limpie los campos cada que se modifique el input */
$("#txtEvaluador").on("input", function() {
    limpiaAutocomplete();
});
/* ******************** */


/* Función para limpiar los campos */
function limpiaAutocomplete(){
    $('#spanCorreo').html('');
    idEvaluador = 0;
}
/* ******************** */


/* Para limpiar el autocomplete cuando se cierre el modal */
const myModalEvaluador = document.getElementById('modalEvaluadores');
myModalEvaluador.addEventListener('hidden.bs.modal', function (event) {
    $("#txtEvaluador").val('');
    limpiaAutocomplete();
})
/* ******************** */


/* Para buscar en cuanto se haga click en el input */
$("#txtEvaluador").click(function() {
    $(this).autocomplete("search");
});
/* ******************** */
