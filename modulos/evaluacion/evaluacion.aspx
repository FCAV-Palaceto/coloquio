<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="evaluacion.aspx.cs" Inherits="modulos_evaluacion_evaluacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .d-flex button {
            width: 200px !important; /* set the width based on the longest button */
        }
        
        div.Listcontainer {
            text-align: center;
        }

        ul.myUL {
            display: inline-block;
            text-align: left;
        }    
    </style>    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div class="card shadow p-3 mb-5 bg-body rounded">
    <div class="text-left">
        <a href="#" onclick="window.location=document.referrer;"><button id="btnRegresar" type="button" class="btn btn-primary btn-block w-auto">Regresar</button></a>
    </div>
    <br>
    <h3><strong>Evaluación de ponencia</strong></h3>
    <br>
    <div class="card-body">
        <h4><b>Título de la ponencia: </b><span id="spnTitulo"></span></h4>
        <%-- <h4><b>Evaluador: </b><span id="lblEvaluador"></span></h4> --%>
        <br>
        <div id="generarTabla" class="table-responsive"></div>
        <br>
        <div class="row">                
            <div class="col-auto">
                Le pedimos ofrezca al autor ideas constructivas que le ayuden a mejorar su trabajo. Le recordamos que uno de los principios básicos de los congresos es el de mejorar en la labor investigadora mediante los valiosos comentarios de los evaluadores, por lo que le rogamos sea constructivo. Trate de identificar los puntos fuertes del trabajo y después indíquele todo aquello susceptible de mejorar. Finalmente, le sugerimos que elabore un breve informe (no más de 500 caracteres) en las que comunique de manera formal sus comentarios en los términos antes mencionados.
            </div>
        </div>        
        <br>
        <div class="row">
            <div class="col-12 col-sm-10 offset-sm-1 ">
                <label for="txtObservaciones" class="col-form-label">Observaciones para el ponente:</label>
                <textarea id="txtObservaciones" class="form-control" rows=5 maxlength="500" oninput="contador(this);"></textarea>
                <span id="conttxtObservaciones" class="float-end text-muted">(0/500)</span>
            </div>                    
        </div>
        <div class="row">
            <div class="col-12 col-sm-10 offset-sm-1 ">
            <label for="txtRecomendaciones" class="col-form-label">Comentarios para el administrador/editor:</label>
            <textarea id="txtRecomendaciones" class="form-control" rows=5 maxlength="500" oninput="contador(this);"></textarea>
            <span id="conttxtRecomendaciones" class="float-end text-muted">(0/500)</span>
            </div>                    
        </div>
        <br>        
        <!--<div>
            <select class="form-select">
                <option selected>Open this select menu</option>
                <option id="btnAprobar">Aprobada sin cambios</option>
                <option id="btnAprobarCambios">Aprobada con cambios</option>
                <option id="btnRechazar" >Rechazada</option>
            </select>
        </div>-->

        <%-- <div class="d-flex justify-content-center">                    
            <div class="form-check m-1">
                <input class="form-check-input" id="btnAprobar" type="radio" name="flexRadioDefault" id="flexRadioDefault1">
                <label class="form-check-label" for="flexRadioDefault1">
                    Aprobada sin cambios
                </label>
            </div>
            <div class="form-check m-1">
                <input class="form-check-input" id="btnAprobarCambios" type="radio" name="flexRadioDefault" id="flexRadioDefault1">
                <label class="form-check-label" for="flexRadioDefault1">
                    Aprobada con cambios
                </label>
            </div>
            <div class="form-check m-1">
                <input class="form-check-input" id="btnRechazar" type="radio" name="flexRadioDefault" id="flexRadioDefault1">
                <label class="form-check-label" for="flexRadioDefault1">
                    Rechazada
                </label>
            </div>
        </div> --%>

        <div class="Listcontainer">
            <ul class="myUL" style="list-style-type:none">
                <li class="list-item">
                    <div class="form-check m-1">
                        <input class="form-check-input" id="btnAprobar" type="radio" name="flexRadioDefault">
                        <label class="form-check-label" for="btnAprobar">
                            Aprobada
                        </label>
                    </div>
                </li>
                <li class="list-item">
                    <div class="form-check m-1">
                        <input class="form-check-input" id="btnAprobarCambios" type="radio" name="flexRadioDefault">
                        <label class="form-check-label" for="btnAprobarCambios">
                            Aprobada con cambios
                        </label>
                    </div>
                </li>
                <li class="list-item">
                    <div class="form-check m-1">
                        <input class="form-check-input" id="btnRechazar" type="radio" name="flexRadioDefault">
                        <label class="form-check-label" for="btnRechazar">
                            Rechazada
                        </label>
                    </div>
                </li>  
            </ul>
        </div> 
        <br>
        <div class="text-center">
            <button id="btnPonencia" type="button" class="btn btn-primary btn-block w-auto" onclick="Guardar()">Guardar</button>
        </div>        
        <input type="hidden" id="estadoEvaluacion" value="0">
        <input type="hidden" id="completo" value="">
        <%-- <div class="row mt-5 gy-3">
            <div class="offset-xxl-2 col-xxl-2 offset-md-2 col-md-4 offset-sm-2 col-sm-8">
                <button id="btnAprobar" type="button" class="btn btn-primary w-100" style="height: 100%;">Aprobar</button>
            </div>            
            <div class="offset-xxl-1 col-xxl-2 offset-md-0 col-md-4 offset-sm-2 col-sm-8">
                <button id="btnAprobarCambios" type="button" class="btn btn-warning text-white w-100">Aprobar con cambios</button>
            </div>
            <div class="offset-xxl-1 col-xxl-2 offset-md-4 col-md-4 offset-sm-2 col-sm-8">
                <button id="btnRechazar" type="button" class="btn btn-danger w-100" style="height: 100%;">Rechazar</button>
            </div>            
        </div> --%>        
    </div> 
</div> 
    
<script>
    window.onload = function(){
        TablaUsu();
        <%-- $('#lblEvaluador').html($('#nomUsu').html()); --%>
    }    

    function TablaUsu() {  //aqui se crea la tabla
        $.ajax({
            type: 'POST',
            url: 'evaluacion.aspx/TablaListarPonencias',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error: function (jqXHR, textStatus, errorThrown) {
                console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
            },
            success: function (tabla) {
                $("#generarTabla").html(tabla.d); //nombre del id del div de la tabla
                setTimeout(function myfunction() {
                    estiloDataTable2();
                }, 100);
            }
        });
    }    

    function estiloDataTable2(page, leng) {
        $('#tabla').DataTable({            
            "bPaginate": false,
            "ordering": false,
            "searching": false,
            "info": false,
            language: {
                "decimal": ".",
                "emptyTable": "",                
                "infoEmpty": "",
                "infoFiltered": "<br/>(Filtrado de _MAX_ parámetros en total)",
                "infoPostFix": "",
                "thousands": ",",
                "lengthMenu": "Mostrando _MENU_ parámetros",                
                "loadingRecords": "Cargando...",
                "processing": "Procesando...",
                "search": "B&uacute;squeda:",
                "zeroRecords": "No hay parámetros disponibles.",
            }
        });
    };


    function sumatoria() {
        var temp, sumatoria = 0;
        var numReg = parseInt($('#regTot').val());
        if (numReg != 0 && numReg != NaN) {
            for (var i = 0; i < numReg; i++) {
                temp = $('#sel' + i).val();
                if (temp != "") {
                    sumatoria += parseInt(temp);
                }
            }
            if(sumatoria!=1)
            $('#pts').html('<b>' + sumatoria + ' Puntos</b>');
            else
            $('#pts').html('<b>' + sumatoria + ' Punto</b>');
        }
    }


    // variable para saber que opcion se clickeó
    var opcion;
    var estadoEvaluacion;

    $('#btnAprobar').on('click', function () {        
        <%-- showModal(1); --%>
        $('#estadoEvaluacion').val(1);
    });


    $('#btnRechazar').on('click', function () {        
        <%-- showModal(2); --%>
        $('#estadoEvaluacion').val(2);
    });


    $('#btnAprobarCambios').on('click', function () {        
        <%-- showModal(3); --%>
        $('#estadoEvaluacion').val(3);
    });


    <%-- // Crea el modal y lo muestra
    function showModal() {
        let parameter = $('#estadoEvaluacion').val();
        let titulo = $('#lblTitulo').text();
        let total = $('#tdPuntos').text();
        let puntos = $('#pts').text();
        let opcionElegida;

        switch (parameter) {
            case 1:
                opcionElegida = "Aprobar";
                break;
            case 2:
                opcionElegida = "Rechazar";
                break;
            case 3:
                opcionElegida = "Aprobar con cambios";
                break;
        }

        $('#spnTitulo').html(titulo);
        $('#spnTotal').html(total);
        $('#spnPuntos').html(puntos);
        $('#spnAccion').html(opcionElegida);
        
        opcion = parameter

        $('#modalConfirm').modal('show');
    }


    $('#btnConfirm').on('click', function () {
        $('#modalConfirm').modal('hide');
        <%-- $('#estadoEvaluacion').val() = opcion; 
        enviarPonencia();
    }); --%>

    function Guardar(){
        $('#completo').val(1);
        var numReg = parseInt($('#regTot').val());
        var estado = $('#estadoEvaluacion').val();
        var calif = [];
        var idParametro = [];
        var observaciones = $('#txtObservaciones').val();
        var recomendaciones = $('#txtRecomendaciones').val();
        for(var i = 0; i < numReg; i++) {
            calif[i] = parseInt($('#sel' + i).val());
            if(calif[i] == 0) $('#completo').val(0);
            <%-- idParametro[i] = parseInt($('#idPar' + i).val()); --%>
        }
        if(estado == 0) $('#completo').val(0);
        var completo = $('#completo').val();

        var table = $('#tabla');
        table.find('tbody > tr').each(function () { 
        ids = $(this).find("td").eq(2).html(); 
        idParametro.push(ids);
        }); 
        

        if (calif == "" && idParametro == "") { 
            var acalif = "";
            var apar = ""; 
        } else { 
            var acalif = calif.toString();
            var apar = idParametro.toString(); 
        }
         

        var obj = {};
        obj.calif = acalif;
        obj.idParametro = apar;
        obj.observaciones = observaciones;
        obj.recomendaciones = recomendaciones;
        obj.estado = estado;
        obj.completo = completo;

        //console.log(obj)
        //console.log(calif)

        if ($('form')[0].checkValidity()){
            $.ajax({
                type: 'POST',
                url: 'evaluacion.aspx/Guardar',
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
                            text: 'La información se guardó correctamente. Redireccionando a ponencias asignadas...',
                            delay: 3000,
                            addClass: 'translucent'
                        });
                        setTimeout(function () {
                            window.location.href = "ponencias_evaluar.aspx";
                        }, 3001);                   
                    } else if (JsonD.success == 2) {
                        PNotify.error({
                            text: 'Algo salió mal.',
                            delay: 3000,
                            addClass: 'translucent'
                        });
                    }
                }
            });
        } else {
            $('form')[0].reportValidity();
            return;
        }            
    }
</script>
</asp:Content>

