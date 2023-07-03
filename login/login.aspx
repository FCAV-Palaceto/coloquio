<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>


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
    <link rel="stylesheet" type="text/css" href="../login/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../login/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../login/fonts/iconic/css/material-design-iconic-font.min.css">
    <link rel="stylesheet" type="text/css" href="../login/vendor/animate/animate.css">
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico" />
    <style>
        #inicio:hover{
            background-color:#51a97f;
        }

        h6:hover {
            text-decoration:underline;
        }

        @media only screen and (max-width: 1450px) {
            #centrarlink {
                text-align:center;                
            }

            a {                
                <%-- width:100%; --%>
                display:inline-block;
            }
        }

        @media only screen and (min-width: 1451px) {
            #link-r {
                float:right;
            }

            h6 {                                
                display:inline-block;
            }
        }   
    </style>
</head>
<body>
    <form id="form1" runat="server">
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
                     <div class="contenedor-logo-uat row">
                        <%--<div class="logo-uat col-sm-12 col-md-6 col-lg-6">
                            <img id="loguat" src="../assets/img/UAT22.png" />
                        </div>
                        <div class="logo-fcav col-xs-12 col-sm-12 col-md-12 col-lg-6">
                            <img id="logfcav" src="../assets/img/FCAV22.png" />
                        </div> --%> 
                         <div class="text-center">
                            <img width="100%" id="logoColoquio" src="../assets/img/logos.png" /><br><br>
                        </div>  
                    </div>
                    <div class="content" style="margin-top:100px !important">


                        <h2 class="text-center mb-5">1er. Congreso Internacional de Emprendimiento Social</h2>
                        <div class="wrap-input100 validate-input m-b-23" data-validate="Se requiere un correo electrónico">
                            <span class="label-input100">Correo electrónico</span>

                            <asp:TextBox ID="inputEmail" runat="server" class="input100" name="Correo"></asp:TextBox>
                            <span class="focus-input100" data-symbol="&#xf207;"></span>
                        </div>
                        <div class="wrap-input100 validate-input" data-validate="Se requiere contraseña">
                            <span class="label-input100">Contraseña</span>

                            <asp:TextBox ID="inputPassword" runat="server" class="input100" type="password"></asp:TextBox>
                            <span class="focus-input100" data-symbol="&#xf191;"></span>
                        </div>
                        <div class="form-element form-submit" id="centrarlink">
                            <a href="register.aspx" style="color:green;float:left;">¿No tienes cuenta? Ir al registro.</a>
                            <a id="link-r" href="password.aspx" style="color:green;float:right;">Recuperar contraseña.</a>
                        </div>                         
                        <asp:Label runat="server" ID="lblTxt" style="color:red;text-align:center;margin-top:10px;" /> 
                        <div class="form-element form-submit text-center">
                            <asp:Button class="login" ID="inicio" runat="server" Text="Iniciar sesion" OnClick="login_Click" />
                        </div>                    
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/paper.js/0.11.3/paper-full.min.js'></script>
    <script src="../login/vendor/jquery/jquery-3.2.1.min.js"></script>
    <script src="../login/vendor/animsition/js/animsition.min.js"></script>
    <script src="../login/vendor/bootstrap/js/popper.js"></script>
    <script src="../login/vendor/bootstrap/js/bootstrap.min.js"></script>
    <script src="../login/vendor/select2/select2.min.js"></script>
    <script src="../login/vendor/countdowntime/countdowntime.js"></script>
    <script src="../js/mainV2.js"></script>
    <script src="../js/indexV2.js"></script>
</body>
</html>
