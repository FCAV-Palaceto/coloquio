<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Hoteles.aspx.cs" Inherits="Hoteles" %>

<!DOCTYPE html>

<html lang="es" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <title>1ER. CONGRESO INTERNACIONAL DE EMPRENDIMIENTO SOCIAL, FCA - U A B J O</title>
    <meta content="" name="description">
    <meta content="" name="keywords">

    <%-- <meta http-equiv="Expires" content="0">
    <meta http-equiv="Last-Modified" content="0">
    <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
    <meta http-equiv="Pragma" content="no-cache"> --%>

    <%-- fontawesome --%>
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

    <!-- Favicons -->
    <link href="assets/img/fcav.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <!-- CSS para el Menú en móvil -->
    <link rel="stylesheet" href="assets/css/styleMenu.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Raleway:300,300i,400,400i,500,500i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/animate.css/animate.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">

    <style> 
        @media only screen and (max-width: 600px) {
          .imgs {
            display:none;
          }
        }

        @media screen and (max-width: 991px) {
        #lics, #submenu{
            display:none;
        }
        #menu {
            display:block;
        }
      }
      @media screen and (min-width: 992px) {
        #menu{
            display:none;
        }

      }

      @media screen and (max-width: 500px){
	    .img_logom{
            display:block !important;
         }
        .img_logo{
            display:none !important;
         }

      }
    </style>    
</head>
<body>
    <!-- ======= Top Bar ======= -->    
    <div class="container d-flex justify-content-center justify-content-md-between">        
        <div class="float-end me-5" style="margin-left:auto;">
            <ul class="list-inline">
                <li class="list-inline-item" style="color:#5cb874;font-size:20px;"><i class="fa fa-calendar" aria-hidden="true"></i> 27 al 29 de septiembre de 2023</li>
                <li class="list-inline-item mx-1"></li>
                <%-- <li class="list-inline-item"><a href="/Posgrado/Servicios/Servicios_Docentes.aspx">Docentes Posgrado</a></li> --%>
            </ul>
        </div>                   
    </div>
    <!-- Agregué el margin bottom negativo para reducir el espacio en blanco entre el header y el navbar -->
    <div class="container d-flex justify-content-center justify-content-md-between position-relative" style="margin-bottom:-18px; margin-top: -18px;">
        <img class="img_logo" src="<%= Page.ResolveUrl("~")%>assets/img/header/logos.png" alt="uat-fcav-logos" style="width: 100%;">
        <img class="img_logom" src="<%= Page.ResolveUrl("~")%>assets/img/header/logos.png" alt="uat-fcav-logos" style="width: 100%;display:none;">
    </div>
    
    <!-- End Top Bar -->

    <!-- ======= Header ======= -->
    <header id="header" class="d-flex">
        <div class="container d-flex">
            <!-- Navbar -->
            <nav id="navbar" class="navbar w-100">
                <div id="menuprincipal" class="row w-100 mx-auto">
                    <ul id="navbarm">
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="#inicio">BASES DE PARTICIPACIÓN</a></li>
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="login/login.aspx">REGISTRO</a></li>
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="#lineamientos">DICTAMINACIÓN</a></li>
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="#comite">COMIT&Eacute; ORGANIZADOR</a></li>
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="#fechas">CALENDARIO</a></li>
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="Hoteles.aspx">HOTELES</a></li>
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="#">TURISMO</a></li>
                    </ul>
                </div>
                <i id="clsbtn" class="bi bi-list mobile-nav-toggle"></i>
            </nav>
            <!-- .navbar -->
        </div>
    </header>
    <!-- End Header -->

    <form id="form1" runat="server">            
        <!-- ======= Slider Section ======= -->
        <%--<div class="container">
            <section id="hero">
                <div id="heroCarousel" data-bs-interval="5000" class="carousel slide carousel-fade " data-bs-ride="carousel">
                    <ol class="carousel-indicators" id="hero-carousel-indicators"></ol>
                    <div class="carousel-inner" role="listbox">
                        <!-- Slide 1 -->
                        <div class="carousel-item active" style="background-image: url(assets/img/slide/congreso.jpg); height: auto !important;">
                            <!-- <div class="carousel-container">
                                <div class="container" >
                                    <h2 id="titulo" class="animate__animated animate__fadeInUp" style="padding-bottom:45px; margin-bottom:-10px;">Bienvenidos a <span>División de Estudios de Posgrado e Investigación FCAV</span></h2>                            
                                </div>
                            </div> -->
                        </div>

                        <!-- Slide 2 -->
                        <div class="carousel-item" style="background-image: url(assets/img/slide/DCA.png)"></div>
                        
                    </div>

                    <a class="carousel-control-prev" href="#heroCarousel" role="button" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon bi bi-chevron-left" aria-hidden="true"></span>
                    </a>

                    <a class="carousel-control-next" href="#heroCarousel" role="button" data-bs-slide="next">
                        <span class="carousel-control-next-icon bi bi-chevron-right" aria-hidden="true"></span>
                    </a>

                </div>
            </section>
        </div>
        <!-- End Slider -->
        <br>--%>
        <main id="main">          
        <!-- ======= Contenido ======= -->
            <div class="container" style="text-align:justify;">
                <section id="about" class="about">                            
                    <div class="row no-gutters">                                     
                        <div class="container">
                            <section id="featured-services2" class="featured-services">
                                <div class="container">
                                
                                    <%-- INICIO --%>
                                    <div id="convoca" style="padding-top:15px">
                                        <div class="section-title">
                                            <h2 id="Noticias">Costos Congreso Internacional de Emprendimiento Social </h2>
                                        </div>
                                        <div class="row no-gutters">
                                            <div class="container">
                                                <p>A la comunidad científica, académica y emprendedores a participar en 1.er. Foro Internacional de Emprendimiento Social a celebrarse del 27 al 29 de septiembre de 2023 en la Universidad Autónoma de "Benito Juárez" de Oaxaca, siendo sede, la ciudad de Oaxaca (México).</p>
                                                <p>Objetivo del foro: Propiciar el intercambio de experiencias, información y conocimiento entre investigadores, estudiantes de licenciatura y posgrado, emprendedores/empresarios sociales autoridades gubernamentales, y público en general, mediante la presentación de trabajos de investigación inéditos (ponencias), que sirvan como sustento de mejores prácticas en el desarrollo social regional y nacional. Así mismo, sea un punto de reunión para la conformación de redes de colaboración académica.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
            </div>             
        </main>
    </form>

    <!-- ======= Footer ======= -->
    <div class="container">
        <footer id="footer">
            <div class="container">
                <h5>Asociación Nacional de Facultades y Escuelas de Contaduría y Administración</h5>
                <h5>Universidad Autónoma Benito Juárez de Oaxaca</h5>
                <h5>Universidad Autónoma de Tamaulipas</h5>
                <span>Información:<br /> Dr. José Melchor Medina Quintero<br /> <i class="bi bi-envelope me-2"> jmedinaq@uat.edu.mx</i></span>
                </div>
                <span style="margin-top:20;">© 2023 Universidad Autónoma de Tamauliapas. Todos los derechos reservados</span>
        </footer>
        <!-- End Footer -->
    </div>

    <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

    <!-- Vendor JS Files -->
    <script src="<%= Page.ResolveUrl("~")%>assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/vendor/glightbox/js/glightbox.min.js"></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/vendor/php-email-form/validate.js"></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/vendor/swiper/swiper-bundle.min.js"></script>

    <!-- Template Main JS File -->
    <script src="<%= Page.ResolveUrl("~")%>assets/js/main.js"></script>


<!-- Scripts para el Menú en móvil -->
    <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js'></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/js/scriptMenu.js"></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/js/maestrias.js"></script>
    <script src="<%= Page.ResolveUrl("~")%>assets/js/doctorados.js"></script>

    <script>
        $(document).ready(function () {

            if ($(window).width() <= 991) {
                $("#menuprincipal").removeClass("row");
                $("#menuprincipal").removeClass("w-100");
                $("#menuprincipal").removeClass("mx-auto");
            }
        });

        $(window).resize(function () {
            if ($(window).width() <= 991) {
                $("#menuprincipal").removeClass("row");
                $("#menuprincipal").removeClass("w-100");
                $("#menuprincipal").removeClass("mx-auto");
            }
            else {
                $("#menuprincipal").addClass("row");
                $("#menuprincipal").addClass("w-100");
                $("#menuprincipal").addClass("mx-auto");
            }
        });

    </script>
</body>
</html>
