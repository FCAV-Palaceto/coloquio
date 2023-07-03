<%@ Page Language="C#" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>1ER. CONGRESO INTERNACIONAL DE EMPRENDIMIENTO SOCIAL, FCA</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href='https://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" type="text/css" href="../css/style2.css">
    <link rel="stylesheet" type="text/css" href="../css/util2.css">
    <link rel="stylesheet" type="text/css" href="../css/main2.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../login/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../login/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../login/fonts/iconic/css/material-design-iconic-font.min.css">
    <link rel="stylesheet" type="text/css" href="../login/vendor/animate/animate.css">
    <link href="../css/PNotifyBrightTheme.css" rel="stylesheet">
    <script src="<%=Page.ResolveClientUrl("~/js/PNotify/PNotify.js")%>"></script>
	<script src="<%=Page.ResolveClientUrl("~/js/PNotify/PNotifyMobile.js")%>"></script>
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico" />

    <style type="text/css">
        body
        {
            font-family: Arial;
            font-size: 10pt;
        }
        .modal
        {
            position: fixed;
            z-index: 999;
            height: 100%;
            width: 100%;
            top: 0;
            left: 0;
            <%-- background-color: black;
            filter: alpha(opacity=0); --%>
            opacity: 0.6;
            -moz-opacity: 0.8;
        }
        .center
        {
            z-index: 1000;
            margin: 300px auto;
            padding: 10px;
            width: 130px;
            <%-- background-color: white;
            border-radius: 10px;
            filter: alpha(opacity=100); --%>
            opacity: 1;
            -moz-opacity: 1;
        }
        .center img
        {
            height: 110px;
            width: 110px;            
        }
    </style>

    
    
    <%-- icons unicode source --%>
    <%-- https://zavoloklom.github.io/material-design-iconic-font/icons.html#application --%>
</head>
<body>
<%-- <button type="button "onclick="loading();">loading modal</button>
    <script>
    function loading(){
        $('#loading').show();
    }        
    </script> --%>
    <form id="form" runat="server">
        <div id="back">
            <canvas id="canvas" class="canvas-back"></canvas>
            <div class="backRight">
            </div>
            <div class="backLeft">
                <div id="dLeyenda">
                    <p id="pLeyenda">
                        Software desarrollado por La Facultad<br />
                        de Comercio y Administraci&oacute;n Victoria.
                    </p>
                </div>
            </div>
        </div>
        <div id="slideBox">
            <div class="topLayer">
                <div class="right">
                    <%-- <div class="contenedor-logo-uat row">
                        <div class="logo-uat col-sm-6 col-md-6 col-lg-6">
                            <img id="loguat" src="../assets/img/UAT22.png" />
                        </div>
                        <div class="logo-fcav col-xs-12 col-sm-12 col-md-12 col-lg-6">
                            <img id="logfcav" src="../assets/img/FCAV22.png" />
                        </div>                          
                    </div>                     --%>
                    <div class="text-center">
                            <img width="100%" id="logoColoquio" src="../assets/img/logos.png" /><br><br>
                        </div>
                    <%-- registro --%>
                    <div class="content" style="margin-top:10px !important">
                    <h2 class="text-center">Registro</h2>
                        <%-- nombre --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Nombre(s)</span>
                            <input type="text" id="inputNom" class="input100" placeholder="Ingrese tu(s) nombre(s)" required>
                            <span class="focus-input100" data-symbol="&#xf207;"></span>                            
                        </div>
                        <%-- apellido --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Apellidos</span>
                            <input type="text" id="inputApe" class="input100" placeholder="Ingrese sus apellidos" required>
                            <span class="focus-input100" data-symbol="&#xf207;"></span>
                        </div>
                        <%-- curp --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">CURP</span>
                            <input type="text" id="inputCurp" class="input100" maxlength="18" placeholder="Ingrese su CURP" required>
                            <span class="focus-input100" data-symbol="&#xf223;"></span>
                        </div>
                        <%-- teléfono --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Teléfono</span>
                            <input type="text" id="inputTel" class="input100" maxlength="10" placeholder="8343181800" onkeypress="return isNumberKey(event)" required>
                            <span class="focus-input100" data-symbol="&#xf2be;"></span>
                        </div>
                        <%-- correo electrónico --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Correo electrónico</span>
                            <input type="text" id="inputEmail" class="input100" placeholder="ejemplo@outlook.com" required>
                            <span class="focus-input100" data-symbol="&#xf15a;"></span>
                        </div>                        
                        <%-- contraseña --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Contraseña</span>
                            <input type="password" id="inputPassword" class="input100" placeholder="Ingrese una contraseña" required>
                            <span class="focus-input100" data-symbol="&#xf191;"></span>
                        </div>
                        <%-- confirmar contraseña --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Confirmar contraseña</span>
                            <input type="password" id="inputPasswordConfirm" class="input100" placeholder="Confirme la contraseña" required>
                            <span class="focus-input100" data-symbol="&#xf191;"></span>
                        </div>                        
                        <%-- grado académico máximo --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Grado académico máximo</span>                            
                            <select class="input100" id="inputGrado">
                                <option value="0">- Seleccionar -</option>
                                <option value="Licenciatura">Licenciatura</option>
                                <option value="Maestría">Maestría</option>
                                <option value="Doctorado">Doctorado</option>
                            </select>
                            <%-- <span class="focus-input100" data-symbol="&#xf174;"></span> --%>
                        </div>
                        <%-- institución --%>                                            
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Institución</span>
                            <select class="input100" id="inputInstitucion" data-live-search="true" onchange="cargarDependencia();">
                                <option value="0">- Seleccionar -</option>
                            </select>
                            <%-- <span class="focus-input100" data-symbol="&#xf11c;"></span> --%>
                        </div>                        

                        <%-- dependencia --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Dependencia</span>
                            <select class="input100" id="inputDependencia" disabled>
                                <option value="0">Seleccione una institución</option>
                            </select>
                            <%-- <span class="focus-input100" data-symbol="&#xf18d;"></span> --%>
                        </div>
                        <%-- estado --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Estado</span>
                            <select class="input100" id="inputEstado" onchange="cargarCiudad();">
                                <option value="0">- Seleccionar -</option>
                            </select>
                            <%-- <span class="focus-input100" data-symbol="&#xf173;"></span> --%>
                        </div>
                        <%-- ciudad --%>
                        <div class="wrap-input100 validate-input m-b-23">
                            <span class="label-input100">Ciudad</span>
                            <select class="input100" id="inputCiudad" disabled>
                                <option value="0">Seleccione un estado</option>
                            </select>
                            <%-- <span class="focus-input100" data-symbol="&#xf133;"></span> --%>
                        </div>
                        <%-- botón de registro --%>
                        <div class="form-element form-submit text-center">                            
                            <button type="button" class="botones" onclick="registrar();">Registrar</button>
                        </div>             
                        <%-- links --%>
                        <div class="form-element form-submit">
                            <a href="login.aspx" style="color:green;">¿Ya tienes cuenta? Iniciar sesión.</a>
                            <a class="float-right" href="password.aspx" style="color:green;">Recuperar contraseña.</a>
                        </div>
                        <br>                        
                    </div>
                </div>
            </div>
        </div>
    </form>
    <div class="modal" id="loading" style="display: none">
        <div class="center">
            <img alt="" src="../assets/img/loading.gif" />
            <%-- <b style="text-align:center;vertical-align:middle;color:white;">Cargando...</b> --%>
        </div>
    </div>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/paper.js/0.11.3/paper-full.min.js'></script>
    <script src="https://kit.fontawesome.com/b858070c46.js" crossorigin="anonymous"></script>
    <%-- <script src="../login/vendor/jquery/jquery-3.2.1.min.js"></script> --%>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="../login/vendor/animsition/js/animsition.min.js"></script>
    <script src="../login/vendor/bootstrap/js/popper.js"></script>
    <script src="../login/vendor/bootstrap/js/bootstrap.min.js"></script>
    <script src="../login/vendor/select2/select2.min.js"></script>
    <script src="../login/vendor/countdowntime/countdowntime.js"></script>
    <script src="../js/mainV2.js"></script>
    <script src="../js/indexV2.js"></script>
    <script src="../js/register.js"></script>    
    
    <script>
        $(document).ready(function() {            
            $('select').select2();
        });

        //** Caracteres Mayuscula
        $(function () {
            $('#inputCurp').keyup(function(){
                this.value=this.value.toUpperCase();
            }); 
        });

        $(function () {
            $('#inputNom').keypress(function(e){
                Caracteres(e)
            });
            
            $('#inputApe').keypress(function(e){
                Caracteres(e)
            });

            $('#inputCurp').keypress(function(e){
                Curp(e)
            });

            $('#inputTel').keypress(function(e){
                Curp(e)
            });

            <%-- $('#inputEmail').keypress(function(e){
                Mail(e)
            }); --%>
        });

        

        <%-- function Mail(e){
            var regex = new RegExp("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"); 
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        } --%>

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
</body>
</html>