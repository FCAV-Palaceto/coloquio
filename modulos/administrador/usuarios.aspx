<%@ page title="" language="C#" masterpagefile="~/modulos/MasterPage.master" autoeventwireup="true" codefile="usuarios.aspx.cs" inherits="usuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <!-- Modal -->
    <div class="modal fade" id="modalusuario" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="usuario"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <%-- <input type="text" id="txtidIns" value="0" />
                            <input type="text" id="txtidDep" value="0" />
                            <input type="text" id="txtidEst" value="0" /> --%>
                            <input type="text" id="txtidUsu" value="0" hidden/>
                            <div class="form-group col-md-6">
                                <label for="txtAutor" class="">Nombre:</label>
                                <input type="text" id="txtNombre" class="form-control" onkeypress="isNumberKey();">
                            </div>
                            <div class="form-group col-md-6">
                                <label for="txtInstitucion" class="">Apellidos:</label>
                                <input type="text" id="txtApellidos" class="form-control">
                            </div>
                            <%-- <div class="form-group col-md-6 mt-3">
                                <label for="txtTipo" class="">Institución:</label>
                                <select class="form-select" id="inputInstitucion" onchange="cargarDependencia();">
                                    <option value="0">- Seleccionar -</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtAutor" class="">Dependencia:</label>
                                <select class="form-select" id="inputDependencia">
                                    <option value="0">Seleccione una institución</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtTipo" class="">Estado:</label>
                                <select class="form-select" id="inputEstado" onchange="cargarCiudad();">
                                    <option value="0">- Seleccionar -</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtAutor" class="">Ciudad:</label>
                                <select class="form-select" id="inputCiudad">
                                    <option value="0">Seleccione un estado</option>
                                </select>
                            </div> --%>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtAutor" class="">CURP:</label>
                                <input type="text" id="txtCurp" class="form-control">
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtTipo" class="">Tipo:</label>
                                <asp:DropDownList class="form-select" ID="txtTipo" ClientIDMode="Static" runat="server" onchange="changetipo();"></asp:DropDownList>
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtAutor" class="">Email:</label>
                                <input type="text" id="txtEmail" class="form-control">
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtAutor" class="">Contraseña:</label>
                                <input type="password" id="txtContraseña" class="form-control">
                            </div>
                            <div class="form-group col-md-6 mt-3">
                                <label for="txtAutor" class="">Teléfono:</label>
                                <input type="number" id="txtTelefono" class="form-control" maxlength = "10">
                            </div>
                            <div class="form-group col-md-6 mt-3" id="mesa">
                                <label for="inputMesa" class="">Mesa temática:</label>
                                <asp:DropDownList ID="inputMesa" ClientIDMode="Static" CssClass="form-select" runat="server"></asp:DropDownList>
                            </div>
                            <div class="form-group col-md-6 mt-3" id="respmesa">
                                <label for="checkaux" class="">Responsable de mesa temática:</label>
                                <input class="form-check-input" type="checkbox" id="checkaux" style="width:25px;height:25px;">
                            </div>                       
                            <div class="col-md-12 modal-footer mt-5">
                                <button type="button" class="btn  btn-primary" onclick="GuardarUsu();" style="float: right; margin-left: 10px;">Guardar</button>
                                <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--- Modal --->
    <div id="modaldel" class="modal fade bd-modal-del" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="myLargeModalLabel21">ELIMINAR</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" ></button>
                </div>
                <div class="modal-body">
                    <h4>¿Está seguro de eliminar el usuario?</h4>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn  btn-primary eliminar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Ponencias section -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
        <h3><strong>Lista de usuarios:</strong></h3>
        </div>
    <div>
        <button type="button" class="btn btn-primary" onclick="AgregarUsuario();" style="float: left;">Agregar Nuevo Usuario</button>
        </div>

        <br />
        <div class="card-body">
        <div id="generarTabla" class="table-responsive"></div>
         <!-- Leyenda de los botones -->
            <div class="row">
                <div class="col-auto">
                    <ul class="list-unstyled">
                            <ul class="list-unstyled">
                                    <li><b>Estados:</b></li>
                                    <li><i class="fa-sharp fa-solid fa-check text-success" style="font-size:1.2em;"></i> = Activo</li>
                                    <li><i class="fa-sharp fa-solid fa-ban" style="font-size:1.2em;color: var(--bs-gray-600);"></i> = Inactivo</li>
                                </ul>
                            </div>
                            <div class="col-auto">
                                <ul class="list-unstyled">
                                    <li><b>Acciones:</b></li>
                                    <li><i class="fa-sharp fa-solid fa-pencil text-info" style="font-size:1.2em;"></i> = Editar usuario</li>
                                    <li><i class="fa-sharp fa-solid fa fa-trash text-danger" style="font-size:1.2em;"></i> = Eliminar usuario</li>
                                </ul>                    
                    </ul>
                </div>
            </div>

    </div>
    </div>    


    <script>
        window.onload = function () {
            TablaUsu();
            <%-- fetchApi(); --%>
        }

        document.getElementById("mesa").style.display = "none";
        document.getElementById("respmesa").style.display = "none";

        function changetipo() {
            var x = document.getElementById("txtTipo").value;

            if (x == 2 || x == 5) {
                document.getElementById("mesa").style.display = "block";
                document.getElementById("respmesa").style.display = "block";
            } else {
                document.getElementById("mesa").style.display = "none";
                document.getElementById("respmesa").style.display = "none";
                }
        }
        function AgregarUsuario() {
            $('#modalusuario').modal('show');
            Limpia();
        }

        function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        return true;
    };

        function GuardarUsu() {
            var idUsu = $('#txtidUsu').val();
            var nombre = $('#txtNombre').val();
            var apellidos = $('#txtApellidos').val();
            var telefono = $('#txtTelefono').val();
            var tipo = $('#txtTipo').val();
            var email = $('#txtEmail').val();
            var contrasena = $('#txtContraseña').val();
            var curp = $('#txtCurp').val();
            var mesa = $('#inputMesa').val();
            if ($('#checkaux').is(':checked')) {
                var responsable = 1;
            } else {
                var responsable = 0;
            }
            if (nombre == "" || apellidos == "" || telefono == "" || tipo == 0 || email == "" || contrasena == "" || curp == "") {
                PNotify.notice({
                    text: 'Porfavor complete los campos.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
            return;
            }
            var regex = /^[-\w.%+]{1,64}@(?:[A-Z0-9-]{1,63}\.){1,125}[A-Z]{2,63}$/i;

            if (!regex.test(email)) {
        PNotify.notice({
            text: 'El correo no es válido.',
            delay: 2500,
            styling: 'bootstrap3'
        });
        return;
    }
            if (telefono.length != 10) {
        PNotify.notice({
            text: 'El numero telefonico no es valido.',
            delay: 2500,
            styling: 'bootstrap3'
        });
        return;
    }
            var obj = {};
            obj.nombre = nombre;
            obj.apellidos = apellidos;
            obj.telefono = telefono;
            obj.tipo = tipo;
            obj.email = email;
            obj.contrasena = contrasena;
            obj.id = idUsu;
            obj.curp = curp;
            obj.mesa = mesa;
            obj.resp = responsable;

            if (idUsu == 0) {
                var url = 'usuarios.aspx/GuardarUsuario';
            }
            else {
                var url = 'usuarios.aspx/ActualizarUsuario';
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
                            text: 'El usuario se guardó correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        $('#modalusuario').modal('hide');
                        TablaUsu();
                        Limpia();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.notice({
                            text: 'El correo ya está en uso, intente con otro.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    }
                }
            });
        }

        function TablaUsu() {  //aqui se crea la tabla
            $.ajax({
                type: 'POST',
                url: 'usuarios.aspx/TablaListarUsuarios',
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

        function estiloDataTable(page, leng) {
            $('#tabla').DataTable({
                "lengthMenu": [5, 10, 25, 50, 75, 100],
                "pageLength": leng,
                "info": false,
                pagingType: 'numbers',
                "order": [[4, 'asc'], [1, 'asc']],
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

        function ConfirmarEliminar(idUsuario) {
            $("#modaldel").modal('show');
            var id = idUsuario;
            $(".eliminar").attr("id", "" + id + "");
            $(".eliminar").attr("onclick", "EliminarUsuario(" + id + ");");
        };

        function alternarActivo(id) {
            $.ajax({
                type: 'POST',
                url: 'usuarios.aspx/alternarActivo',
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
                            text: 'El usuario se activo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaUsu();
                    }
                    else if (JsonD.success == 2) {
                        PNotify.success({
                            text: 'El usuario se desactivo correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        TablaUsu();
                    }
                }
            });
        };

        function ModificarUsuario(id) {
            $.ajax({
                type: 'POST',
                url: 'usuarios.aspx/modusuario',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#txtidUsu').val(id);
                    $('#usuario').html('Editar Usuario'); 
                    $('#txtNombre').val(jsonD.nom);
                    $('#txtApellidos').val(jsonD.apell);
                    <%-- $('#txtidIns').val(jsonD.inst);
                    $("#inputInstitucion option[value=" + $("#txtidIns").val() + "]").attr('selected', 'selected');
                    cargarDependencia();
                    $('#txtidDep').val(jsonD.depen);
                    $("#inputDependencia option[value=" + $("#txtidDep").val() + "]").attr('selected', 'selected');
                    $('#txtidEst').val(jsonD.estado);
                    $("#inputEstado option[value=" + $("#txtidEst").val() + "]").attr('selected', 'selected');
                    cargarCiudad();
                    $('#txtidCiu').val(jsonD.ciud);
                    $("#inputCiudad option[value=" + $("#txtidCiu").val() + "]").attr('selected', 'selected'); --%>
                    $('#txtTelefono').val(jsonD.tel);
                    $('#txtTipo').val(jsonD.idT);
                    $('#txtEmail').val(jsonD.eml);
                    $('#txtContraseña').val(jsonD.contra);
                    $('#txtCurp').val(jsonD.cp);
                        if ($('#checkaux').is(':checked') || jsonD.resp == 1) {
                            $('#checkaux').click();
                        }
                    $('#inputMesa').val(jsonD.mesa);
                    changetipo();
                    $('#modalusuario').modal('show');
                    
                    

                }
            });
        }
        function EliminarUsuario(id) {
            var id2 = id;
            $.ajax({
                type: 'POST',
                url: 'usuarios.aspx/borrarUsuario',
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
                        TablaUsu();
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

        $(document).ready(function () {
            $('#modalusuario').on('hidden', function () {
                clear();
            });
        });

        //------------------------[Selects con apis]---------------------------------

        //Api de instituciones
        function fetchApi() {
            const batchTrack = document.getElementById("inputInstitucion");
            const getPost = async () => {
                const response = await fetch("https://api.datamexico.org/tesseract/data.jsonrecords?cube=anuies_enrollment&drilldowns=Institution&locale=es&measures=Students");
                const data = response.json();
                return data;
            };

            const displayOption = async () => {
                const options = await getPost();
                options.data.forEach(option => {
                    const newOption = document.createElement("option");
                    newOption.value = option["Institution ID"];
                    newOption.text = option.Institution;
                    batchTrack.appendChild(newOption);

                });
                sortear("#inputInstitucion");
                $("#inputInstitucion option[value=0]").attr('selected', 'selected');
            };
            displayOption();

            //Api de estados
        const batchTrack2 = document.getElementById("inputEstado");
        const getPost2 = async () => {
            const response = await fetch("https://api.datamexico.org/tesseract/data.jsonrecords?cube=inegi_population_total&drilldowns=State&locale=es&measures=Population");
            const data = response.json();
            return data;
        };

        const displayOption2 = async () => {
            const options = await getPost2();
            options.data.forEach(option => {
                const newOption = document.createElement("option");
                newOption.value = option["State ID"];
                newOption.text = option.State;
                batchTrack2.appendChild(newOption);

            });
            sortear("#inputEstado");
            $("#inputEstado option[value=0]").attr('selected', 'selected');
        };
        displayOption2();
        }


        //funcion para la api de dependencias
        function cargarDependencia() {
            $("#inputDependencia option").each(function () {
                $(this).remove();
            });
            var id = $('#inputInstitucion').val();
            if (id == 0) {
                const batchTrack = document.getElementById("inputDependencia");
                const newOption = document.createElement("option");
                newOption.value = 0;
                newOption.text = "Seleccione una institución";
                batchTrack.appendChild(newOption);
                $("#inputDependencia").attr('disabled', true);
            } else {
                const batchTrack = document.getElementById("inputDependencia");
                const getPost = async () => {
                    const response = await fetch("https://api.datamexico.org/tesseract/data.jsonrecords?Institution=" + id + "&cube=anuies_enrollment&drilldowns=Institution%2CCampus&locale=es&measures=Students");
                    const data = response.json();
                    return data;
                };

                const displayOption = async () => {
                    const options = await getPost();
                    const newOption = document.createElement("option");
                    newOption.value = "0"
                    newOption.text = "- Seleccionar -"
                    batchTrack.appendChild(newOption);
                    options.data.forEach(option => {
                        const newOption = document.createElement("option");
                        newOption.value = option["Campus ID"];
                        newOption.text = option.Campus;
                        batchTrack.appendChild(newOption);
                        $("#inputDependencia").removeAttr('disabled');
                    });
                    sortear("#inputDependencia");
                    <%-- $("#inputDependencia option[value=0]").attr('selected', 'selected'); --%>
                };
                displayOption();
            }
        }

        

        //funcion para la api de ciudades
        function cargarCiudad() {
            $("#inputCiudad option").each(function () {
                $(this).remove();
            });
            var id = $('#inputEstado').val();
            if (id == 0) {
                const batchTrack2 = document.getElementById("inputCiudad");
                const newOption = document.createElement("option");
                newOption.value = 0;
                newOption.text = "Seleccione un estado";
                batchTrack2.appendChild(newOption);
                $("#inputCiudad").attr('disabled', true);
            } else {
                const batchTrack2 = document.getElementById("inputCiudad");
                const getPost2 = async () => {
                    const response = await fetch("https://api.datamexico.org/tesseract/data.jsonrecords?State=" + id + "&cube=inegi_population_total&drilldowns=State%2CMunicipality&locale=es&measures=Population");
                    const data = response.json();
                    return data;
                };

                const displayOption2 = async () => {
                    const options = await getPost2();
                    const newOption = document.createElement("option");
                    newOption.value = "0"
                    newOption.text = "- Seleccionar -"
                    batchTrack2.appendChild(newOption);
                    options.data.forEach(option => {
                        const newOption = document.createElement("option");
                        newOption.value = option["Municipality ID"];
                        newOption.text = option.Municipality;
                        batchTrack2.appendChild(newOption);
                        $("#inputCiudad").removeAttr('disabled');
                    });
                    sortear("#inputCiudad");
                    <%-- $("#inputCiudad option[value=0]").attr('selected', 'selected'); --%>                    
                };
                displayOption2();
            }
        }

        //función para sortear alfabéticamente las opciones de un select mandando el id del select
        function sortear(id) {
            $(id).append($(id + " option").remove().sort(function (a, b) {
                var at = $(a).text(),
                    bt = $(b).text();
                return (at > bt) ? 1 : ((at < bt) ? -1 : 0);
            }));
        }

        function Limpia() {
            $('#txtidUsu').val(0);
            $('#txtNombre').val('');
            $('#txtApellidos').val('');
            $('#inputInstitucion').val(0);
            $('#inputDependencia').val(0);
            $('#inputEstado').val(0);
            $('#inputCiudad').val(0);
            $('#txtTelefono').val('');
            $('#txtTipo').val(0);
            $('#txtEmail').val('');
            $('#txtContraseña').val('');
            $('#txtCurp').val('');
            if ($('#checkaux').is(':checked')) {
                $('#checkaux').click();
            }
            $('#inputMesa').val(0);
            $('#usuario').html('Agregar Nuevo Usuario'); 
        }

    </script>

</asp:Content>


