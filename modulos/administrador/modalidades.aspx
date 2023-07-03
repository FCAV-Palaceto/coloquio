<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="modalidades.aspx.cs" Inherits="modalidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <!-- Modal -->
 <div class="modal fade" id="modalModalidad" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title h4" id="modalidad"></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
            </div>
            <div class="modal-body">
                <div class="col-md-12">
                        <div class="row">
                            <input type="text" id="txtidMod" value="0" hidden />
                        <div class="form-group col-md-6">
                            <label for="txtModalidad">Modalidad:</label>
                            <input type="text" class="form-control" id="txtModalidad">
                        </div>
                        <div class="form-group col-md-6">
                                <label for="ddledicion">Edición:</label>
                                <asp:DropDownList ID="ddledicion" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:DropDownList>
                            </div>
                            <br /><br />
                        <br /><br />
                        <div class="col-md-12 modal-footer">
                            <button type="button" class="btn  btn-primary" onclick="GuardarModalidad();" style="float: right; margin-left: 10px;">Guardar</button>
                            <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <!-- Modal Eliminar modalidad -->
    <div class="modal fade" id="modaldel" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4">Eliminar Modalidad</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de eliminar la modalidad?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary eliminar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>



    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
        <h3><strong>Lista de modalidades</strong></h3>
        </div>
        <div>
            <button type="button" class="btn  btn-primary" onclick="AgregarModalidad(); Limpia();" style="float:left;" >Agregar Nueva Modalidad</a>
        </div>
        <br />        
        <div class="card-body">
        
            <%-- se genera la tabla --%>
            <div id="generarTabla" class="table-responsive "></div>            
            
            
            <%-- leyendas --%>
            <div class="row">
                <div class="col-auto">                
                    <ul class="list-unstyled">
                        <li><b>Estados:</b></li>
                        <li><i class="fa-sharp fa-solid fa-check text-success" style="font-size:1.2em;"></i> = Activa</li>
                        <li><i class="fa-sharp fa-solid fa-ban" style="font-size:1.2em;color: var(--bs-gray-600);"></i> = Inactiva</li>
                    </ul>
                </div>
                <div class="col-auto">
                    <ul class="list-unstyled">
                        <li><b>Acciones:</b></li>
                        <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size:1.2em;"></i> = Editar modalidad</li>
                        <li><i class="fa-sharp fa-solid fa fa-trash text-danger" style="font-size:1.2em;"></i> = Eliminar modalidad</li>
                    </ul>
                </div>
            </div>
        </div>        
    </div>
        
        
        <script>
            window.onload = function () {
                TablaModalidades();
            }

            function TablaModalidades() {  //aqui se crea la tabla
                $.ajax({
                    type: 'POST',
                    url: 'modalidades.aspx/TablaListarModalidades',
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

            function AgregarModalidad() {
            $('#modalModalidad').modal('show');
        }

            function GuardarModalidad() {
            var idMod = $('#txtidMod').val();
            var Modalidad = $('#txtModalidad').val();
            var Edicion = $('#ddledicion').val();

                if (Modalidad == "" || Edicion == 0) {
                    PNotify.notice({
                        text: 'Porfavor complete los campos.',
                        delay: 2500,
                        styling: 'bootstrap3'
                    });
                    return;
                }

            var obj = {};
            obj.Modalidad = Modalidad;
            obj.Edicion = Edicion;
            obj.id = idMod;

            if (idMod == 0) {
                var url = 'modalidades.aspx/GuardarModalidad';
            }
            else {
                var url = 'modalidades.aspx/ActualizarModalidad';
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
                            text: 'La modalidad se guardo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        $('#modalModalidad').modal('hide');
                        TablaModalidades();
                        Limpia();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.notice({
                            text: 'La Modalidad ya existe, intente con otro nombre.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    }
                }
            });
        };

        function alternarActivo(id) {
            $.ajax({
                type: 'POST',
                url: 'modalidades.aspx/alternarActivo',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    console.log(JsonD);
                    if (JsonD.success == 1) {
                        PNotify.success({
                            text: 'La modalidad se activo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaModalidades();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.success({
                            text: 'La modalidad se desactivo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaModalidades();
                    }
                }
            });
        };

        //Trae los datos para modificar las modalidades
        function ModificarModalidad(ctrl) {
            var id = ctrl;
            $.ajax({
                type: 'POST',
                url: 'modalidades.aspx/ModModalidad',
                data: "{'idModalidad':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#txtidMod').val(id);
                    $('#modalidad').html('Editar Modalidad');
                    $('#txtModalidad').val(jsonD.modalidad);
                    $('#modalModalidad').modal('show');
                }
            });
        }

// BOTON DE ELIMINAR
        function ConfirmarEliminar(ctrl) {
            $("#modaldel").modal('show');
            var id = ctrl;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "borrarModalidad(" + id + ");");
        }

        function borrarModalidad(id) {
        var idModalidad = id;
            $.ajax({
                type: 'POST',
                url: 'modalidades.aspx/borrarModalidad',
                data: "{'id':'" + idModalidad + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                },
                success: function (valor) {
                    var JsonD = $.parseJSON(valor.d)
                    if (JsonD.success == 1) {
                        $('#modaldel').modal('hide');
                        TablaModalidades();
                        PNotify.success({
                            text: 'La modalidad se elimino correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    } else
                        if (JsonD.success == 2) {
                            $('#modaldel').modal('hide');
                            PNotify.notice({
                                text: 'No se puede eliminar la modalidad porque existe una ponencia ligada.',
                                delay: 2500,
                                styling: 'bootstrap3'
                            });
                        }
                }
            });
        }

        function Limpia() {
            $('#txtidMod').val(0);
            $('#txtModalidad').val('');
            $('#modalidad').html('Agregar Nueva Modalidad');
        }

        </script>
</asp:Content>