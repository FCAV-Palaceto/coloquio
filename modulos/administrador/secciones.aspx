<%@ page title="" language="C#" masterpagefile="~/modulos/MasterPage.master" autoeventwireup="true" codefile="secciones.aspx.cs" inherits="modulos_administrador_secciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <!-- Modal -->
    <div class="modal fade" id="modalseccion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="seccion"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <input type="text" id="txtidSec" value="0" hidden />
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtseccion">Sección:</label>
                                <input type="text" class="form-control" id="txtseccion">
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="ddledicion">Edición:</label>
                                <asp:DropDownList ID="ddledicion" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:DropDownList>
                            </div>
                            <br />
                            <br />
                            <div class="col-md-12 modal-footer mt-5">
                                <button type="button" class="btn  btn-primary" onclick="GuardarSeccion();" style="float: right; margin-left: 10px;">Guardar</button>
                                <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- Eliminar -->
    <div class="modal fade" id="modaldel" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4">Eliminar Sección</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de eliminar la sección?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary eliminar" data-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>


    <!---------------------->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
            <h3><strong>Lista de secciones</strong></h3>
        </div>
        <div>
            <button type="button" class="btn btn-primary" onclick="AgregarSeccion();Limpia();" style="float: left;">Agregar Nueva Sección</button>
        </div>
        <br />
        <div class="card-body">
            <!-- Tabla de secciones -->
            <div id="tabsecciones" class="table-responsive "></div>
            <!-- Leyenda de los botones -->
            <div class="row">
                <div class="col-auto">
                    <ul class="list-unstyled">
                        <li><b>Acciones:</b></li>
                        <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size: 1.2em;"></i> = Editar sección</li>
                        <li><i class="fa-sharp fa-solid fa fa-trash text-danger" style="font-size: 1.2em;"></i> = Eliminar sección</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>



    <script>

        window.onload = function () {
            TablaSecciones();
        }

        //Se crea la tabla
        function TablaSecciones() {
            $.ajax({
                type: 'POST',
                url: 'secciones.aspx/TablaListarSecciones',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#tabsecciones").html(tabla.d); //id del div de la tabla
                    setTimeout(function myfunction() {
                        estiloDataTable();
                    }, 100);
                }
            });
        }

        function AgregarSeccion() {
            $('#modalseccion').modal('show');
        }

        function GuardarSeccion() {
            var idSec = $('#txtidSec').val();
            var seccion = $('#txtseccion').val();
            var edicion = $('#ddledicion').val();

            if (seccion == "" || edicion == 0) {
                PNotify.notice({
                    text: 'Porfavor complete los campos.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }

            var obj = {};
            obj.seccion = seccion;
            obj.edicion = edicion;
            obj.id = idSec;

            if (idSec == 0) {
                var url = 'secciones.aspx/GuardarSeccion';
            }
            else {
                var url = 'secciones.aspx/ActualizarSeccion';
            }
            $.ajax({
                type: 'POST',
                url: url,
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
                            text: 'La sección se guardo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        $('#modalseccion').modal('hide');
                        TablaSecciones();
                        Limpia();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.notice({
                            text: 'La sección ya existe, intente con otro nombre.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    }
                }
            });
        }

        //Trae los datos para modificar las secciones
        function ModificarSeccion(ctrl) {
            var id = ctrl;
            $.ajax({
                type: 'POST',
                url: 'secciones.aspx/ModSeccion',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#seccion').html('Editar Sección');
                    $('#txtidSec').val(id);
                    $('#txtseccion').val(jsonD.seccion);
                    $('#ddledicion').val(jsonD.edicion);
                    $('#modalseccion').modal('show');
                }
            });
        }

        function ConfirmarEliminar(ctrl) {
            $("#modaldel").modal('show');
            var id = ctrl;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "EliminarSeccion(" + id + ");");
        }

        function EliminarSeccion(id) {
            var id2 = id;
            $.ajax({
                type: 'POST',
                url: 'secciones.aspx/EliminarSeccion',
                data: "{'id':'" + id2 + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    if (JsonD.success == 1) {
                        $('#modaldel').modal('hide');
                        TablaSecciones();
                        PNotify.success({
                            text: 'La sección se elimino correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    } else
                        if (JsonD.success == 2) {
                            $('#modaldel').modal('hide');
                            PNotify.notice({
                                text: 'No se puede eliminar la sección porque tiene parametros asignados.',
                                delay: 2500,
                                styling: 'bootstrap3'
                            });
                        }
                }
            });
        }

        function Limpia() {
            $('#txtidSec').val(0);
            $('#txtseccion').val('');
            $('#seccion').html('Agregar Nueva Sección');
            //$('#ddledicion').val(0);
        }
    </script>
</asp:Content>

