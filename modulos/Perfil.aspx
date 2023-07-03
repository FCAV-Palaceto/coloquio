<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="Perfil.aspx.cs" Inherits="modulos_Perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!---------------------->
<div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="">
        <h3><strong>Mis datos</strong></h3>
        </div>
        <br />        
        <div class="card-body">
        <div class="col-md-12">
                <div class="row">
                    <!-- <span><%=user%></span> -->
                    <%-- <input type="text" id="txtidIns" value="0" />
                    <input type="text" id="txtidDep" value="0" />
                    <input type="text" id="txtidEst" value="0" /> --%>
                    <input type="text" id="txtidUsu" value="0" hidden/>
                    <div class="form-group col-md-6">
                        <label for="txtNombre" class="">Nombre:</label>
                        <input type="text" id="txtNombre" class="form-control" onkeypress="isNumberKey();">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="txtApellidos" class="">Apellidos:</label>
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
                        <label for="txtCurp" class="">CURP:</label>
                        <input type="text" id="txtCurp" maxlength="18" class="form-control">
                    </div>
                    <div class="form-group col-md-6 mt-3">
                        <label for="txtTelefono" class="">Teléfono:</label>
                        <input type="number" id="txtTelefono" class="form-control" maxlength = "10">
                    </div>      
                    <div class="form-group col-md-6 mt-3">
                        <label for="txtContraseña" class="">Contraseña:</label>
                        <input type="password" id="txtContraseña" class="form-control">
                    </div>
                    <div class="form-group col-md-6 mt-3">
                        <label for="txtContraseña" class="">Confirmar contraseña:</label>
                        <input type="password" id="txtContraseñaDos" class="form-control">
                    </div>                    
                    <div class="col-md-12 mt-4">
                        <a type="button" class="btn  btn-secondary" onclick="Redirect();" style="float: right;">Regresar</a>
                        <button type="button" class="btn  btn-primary" onclick="GuardarSeccion();" style="float: right; margin-right: 10px;">Actualizar</button>                        
                    </div>
                </div>            
        </div>        
    </div>

    <script>
    window.onload = function () {
        ModificarUsuario();
        }

        function Redirect() {
            idTipo = <%=tipo%>;
            if (idTipo == 1) {
                window.location = "ponencias/ponencias_listar.aspx";

            } else if (idTipo == 2) {
                window.location = "evaluacion/ponencias_invitacion.aspx";

            } else if (idTipo == 3) {
                window.location = "administrador/invitaciones.aspx";

            } else if (idTipo == 4) {
                window.location = "administrador/invitaciones.aspx";

            } else if (idTipo == 99) {
                window.location = "ponencias/ponencias_listar.aspx";

            }
            else {
                window.location = "../login/logout.aspx";
            }



        }

    function ModificarUsuario() {
            idUsuario = <%=user%>;
            $.ajax({
                type: 'POST',
                url: 'perfil.aspx/modusuario',
                data: "{'id':'" + idUsuario + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#txtidUsu').val(idUsuario);
                    $('#txtNombre').val(jsonD.nom);
                    $('#txtApellidos').val(jsonD.apell);
                    $('#txtTelefono').val(jsonD.tel);
                    $('#txtTipo').val(jsonD.idT);
                    $('#txtEmail').val(jsonD.eml);
                    $('#txtContraseña').val(jsonD.contra);
                    $('#txtCurp').val(jsonD.cp);
                }
            });
        }

        function GuardarSeccion() {
            var idUsu = $('#txtidUsu').val();
            var nombre = $('#txtNombre').val();
            var apellidos = $('#txtApellidos').val();
            var telefono = $('#txtTelefono').val();
            var contrasena = $('#txtContraseña').val();
            var contrasenaDos = $('#txtContraseñaDos').val();
            var curp = $('#txtCurp').val();

            if (nombre == "" || apellidos == "" || telefono == "" || contrasena == "" || curp == "") {
                PNotify.notice({
                    text: 'Porfavor complete los campos.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }

            
            if (telefono.length != 10) {
                PNotify.notice({
                    text: 'El número telefonico no es válido.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }

                if (curp.length != 18) {
                PNotify.notice({
                    text: 'El curp ingresado no es válido.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }

            if (contrasena != contrasenaDos) {
                PNotify.notice({
                    text: 'Las contraseñas no coinciden.',
                    delay: 2500,
                    styling: 'bootstrap3'
                });
                return;
            }
            var obj = {};
            obj.nombre = nombre;
            obj.apellidos = apellidos;
            obj.telefono = telefono;
            obj.contrasena = contrasena;
            obj.id = idUsu;
            obj.curp = curp;
            
            $.ajax({
                type: 'POST',
                url: 'perfil.aspx/ActualizarUsuario',
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
                            text: 'Se han actualizado sus datos correctamente.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                        setTimeout(() => {
                            Redirect();
                        }, 2500);
                    }
                    else if (JsonD.success == 2) {
                        PNotify.success({
                            text: 'El curp ya se encuentra en uso.',
                            delay: 2500,
                            styling: 'bootstrap3'
                        });
                    }
                    }

            });
        }

        ////////////////VALIDACION DE CARACTERES
        //** Caracteres Mayuscula
        $(function () {
            $('#txtCurp').keyup(function(){
                this.value=this.value.toUpperCase();
            }); 
        });

        $(function () {
            $('#txtNombre').keypress(function(e){
                Caracteres(e)
            });
            
            $('#txtApellidos').keypress(function(e){
                Caracteres(e)
            });

            $('#txtCurp').keypress(function(e){
                Curp(e)
            });

            $('#txtTel').keypress(function(e){
                Curp(e)
            });
        });

        function Caracteres(e){
            var regex = new RegExp("^[a-zA-Z\u00E0-\u00FC ]+$"); 
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        }

        function Curp(e){
            var regex = new RegExp("^[a-zA-Z0-9\u00E0-\u00FC ]+$"); 
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        }

        function Telefono(e){
            var regex = new RegExp("^[0-9 ]+$"); 
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        }
    
    </script>
        
</asp:Content>

