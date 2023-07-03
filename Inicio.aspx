<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Inicio.aspx.cs" Inherits="Inicio" %>

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
                        <li class="col d-flex justify-content-center"><a class="nav-link scrollto logo" href="#costo">COSTOS</a></li>
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
        <div class="container">
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
                        <%-- <div class="carousel-item" style="background-image: url(assets/img/slide/DCA.png)"></div> --%>
                        
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
        <br>
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
                                            <h1 id="Noticias"><b>1ER. CONGRESO INTERNACIONAL DE EMPRENDIMIENTO SOCIAL</b></h1><br>
                                            <h2 id="Noticias">Convocan</h2>
                                        </div>
                                        <div class="row no-gutters">
                                            <div class="container">
                                                <p>A la comunidad científica, académica y emprendedores a participar en el 1er. Congreso Internacional de Emprendimiento Social a celebrarse del 27 al 29 de septiembre de 2023 en la Universidad Autónoma “Benito Juárez” de Oaxaca, siendo sede, la ciudad de Oaxaca (México).</p>                                                    
                                                <p>Objetivo del Congreso: Propiciar el intercambio de experiencias, información y conocimiento entre investigadores, estudiantes de licenciatura y posgrado, emprendedores/empresarios sociales, autoridades gubernamentales, y público en general, mediante la presentación de trabajos de investigación inéditos (ponencias), que sirvan como sustento de mejores prácticas en el desarrollo social regional y nacional. Así mismo, sea un punto de reunión para la conformación de redes de colaboración académica.</p>
                                            </div>
                                        </div>
                                        <div class="text-center mt-4">
                                            <a class="btn btn-xl bg-success text-white" href="https://fcav-app.uat.edu.mx/cieanfeca/assets/doc/Convocatoria.pdf" target="_blank" id="convocatoriabtn">
                                                <i class="fas fa-download me-2"></i>
                                                Descargar Convocatoria
                                            </a>
                                        </div>
                                        <h3>Mesas temáticas:</h3>
                                            <ul>
                                                <li>Emprendimiento social y modelos de negocio.</li>
                                                <li>Estudios de caso de emprendimientos sociales exitosos.</li>
                                                <li>Innovación social.</li>
                                                <li>Desarrollo territorial a partir del emprendiento social.</li>
                                                <li>El papel de las universidades en el emprendimiento social.</li>
                                                <li>Organización y empresa.</li>
                                                <li>Incubadoras sociales.</li>
                                            </ul>                               
                                        <br>
                                        <br>
                                    </div>

                                    <div id="inicio" style="padding-top:15px">
                                        <div class="section-title">
                                            <h2 id="Noticias">Bases de participación</h2>
                                        </div>
                                        <div class="row no-gutters">
                                            <div class="container">
                                                <p>Podrán participar como ponentes o asistentes: investigadores, académicos y estudiantes de Instituciones de Educación Superior Nacionales y Extranjeras, así como también son bienvenidos empresarios y funcionarios públicos encargados de diseñar y aplicar políticas públicas.</p>
                                                <p>La ponencia debe ser original, no publicada o en revisión en otro medio de difusión científica y producto de investigación básica o aplicada que realice una aportación al conocimiento teórico o práctico.</p>
                                                <p>Las ponencias son aceptadas de manera individual o colegiada no superando los tres integrantes.</p>
                                                <p>La recepción de ponencias es a partir de la publicación de la presente Convocatoria y con fecha límite el 18 de junio de 2023, y serán enviados a la plataforma del 1er. Congreso Internacional de Emprendimiento Social: https://fcav-app.uat.edu.mx/cieanfeca </p>
                                            </div>
                                            <div class="text-center mt-4">
                                            <a class="btn btn-xl bg-success text-white" href="https://fcav-app.uat.edu.mx/cieanfeca/assets/doc/Manual_Registro.pdf" target="_blank" id="convocatoriabtn">
                                                <i class="fas fa-download me-2"></i>
                                                Manual para crear una cuenta
                                            </a>
                                        </div>
                                        </div>                                
                                        <br>
                                        <br>
                                    </div>

                                    <%-- LINEAMIENTOS --%>
                                    <div id="lineamientos" style="padding-top:17px">
                                        <div class="section-title">
                                            <h2 id="Noticias">Dictaminación</h2>
                                        </div>
                                        <div class="container">
                                            <p>Las ponencias serán sometidas para su aceptación a un arbitraje con evaluación anónima (doble ciego).</p>
                                            <p>El dictamen, con carácter de inapelable, podrá ser consultado en la misma plataforma electrónica; además, el Comité Organizador enviará la Carta de Aceptación o Rechazo según sea el caso.</p>
                                            <p>El autor o autores de las ponencias aceptadas, deberán enviar firmada la carta de Cesión de Derechos vía correo electrónico, adjuntando copia de una identificación oficial (INE o pasaporte) por cada autor del trabajo, al correo electrónico:es.anfeca@uat.edu.mx.</p>
                                            <p>Los trabajos aceptados, deberán ser presentados acorde a los lineamientos del Comité Editorial de la Universidad.</p>
                                            <br />
                                            <h2>Requisitos formales de los trabajos de investigación</h2>
                                            <p>El trabajo deberá ser escrito en Microsoft Word, con un máximo de 20 cuartillas numeradas (incluyendo tablas, cuadros, figuras, imágenes y anexos), que deberán contener: nombre, numeración ascendente y su fuente de referencia, en hoja tamaño carta con 2.5 cm. en todos los márgenes, evitando las abreviaturas poco comunes, a espacio y medio, y tipo de letra Times New Roman a 12 puntos y alineación justificada.</p>
                                            <p>En caso de imágenes digitalizadas, deben contar con una resolución por lo menos 300 puntos por pulgada (dpi).</p>
                                            <p>Las referencias bibliográficas deben ser completas y ordenadas de acuerdo al estilo APA versión 7.</p>
                                            <br />
                                            <h4>Datos de identificación</h4>
                                            <p>La portada contendrá la siguiente información:</p>
                                            <ul>                                                
                                                <li>1er. Congreso Internacional de Emprendimiento Social</li>
                                                <li>Nombre de la ponencia</li>
                                                <li>Mesa temática en la que participará</li>
                                                <li>Nombre completo del autor(es) sin abreviaturas y su(s) correo(s) electrónicos</li>
                                                <li>Institución de procedencia</li>
                                                <li>Domicilio de la institución</li>
                                                <li>Teléfono</li>
                                                <li>Lugar y fecha (Oaxaca, Oax. Del 27 al 29 de septiembre de 2023)</li>
                                            </ul>
                                            <br />
                                            <h4>Contenido del trabajo</h4>
                                            <ul>
                                                <li>Resumen de la investigación con un máximo de 200 palabras y tres palabras clave</li>
                                                <li>Introducción</li>
                                                <li>Revisión de la literatura</li>
                                                <li>Método</li>
                                                <li>Resultados y discusión</li>
                                                <li>Conclusiones y líneas futuras de investigación</li>
                                                <li>Bibliografía </li>
                                            </ul>
                                            <h4>Acerca de las Ponencias</h4>
                                            <p>Los participantes en cada una de las mesas temáticas podrán debatir/comentar/cuestionar al expositor el contenido de los trabajos, quienes deberán presentar un panorama general del estado del arte de su investigación, el método utilizado y las principales aportaciones al conocimiento.</p>
                                            <p>Cada expositor dispondrá de 12 minutos para su presentación y 5 minutos para comentarios, preguntas y respuestas.</p>
                                        </div>
                                        <!-- Botón de lineamientos-->
                                        <div class="text-center mt-4">
                                            <a class="btn btn-xl bg-success text-white" href="https://fcav-app.uat.edu.mx/cieanfeca/assets/doc/Manual_Ponencia.pdf" target="_blank" id="convocatoriabtn">
                                                <i class="fas fa-download me-2"></i>
                                                Manual para subir ponencia
                                            </a>
                                        </div>
                                        <br>
                                        <br>
                                    </div>

                                    <%-- COMITÉ --%>
                                    <div id="comite">
                                        <div class="section-title" id="comite" style="padding-top:20px">                                    
                                            <h2 id="Noticias">Comité organizador</h2>
                                        </div>
                                        <div class="container" style="text-align:center">
                                            <h3>Coordinadores Generales</h3>
                                            <!-- <ul style="display:inline-block;text-align:left;font-size:18px;font-family:'Tenor', sans-serif;"></ul> -->
                                            <ul style="display:inline-block;text-align:left;">
                                                <li>Mtro. Mauro Francisco Pérez Carrasco. Director de la Facultad de Contaduría y Administración de la Universidad Autónoma Benito Juárez de Oaxaca</li>
                                                <li>Dr. Gerardo Delgado Rivas. Coordinador Nacional de Emprendimiento Social de la ANFECA</li>
                                            </ul>
                                            <h3>Coordinadores por la Universidad Autónoma Benito Juárez de Oaxaca</h3>
                                            <ul style="display:inline-block;text-align:left;">
                                                <li>Dr. Rosendo Martínez Jiménez</li>                                        
                                                <li>Mtra. Martha Maira Mendoza Solano</li>
                                                <li>Mtra. Brenda García Carazo</li>
                                                <li>Dr. Rodrigo Marcial Nava</li>
                                                <li>Dr. José Mario Ruiz Medrano</li>
                                                <li>Dr. Julio César Bravo Cruz</li>
                                                <li>Dra. Edith Dolores Hernández Pérez</li>
                                                <li>Mtra. Linda Patricia Carrasco Morgan</li>
                                                <li>Dr. Lenin Francisco Martínez Ramírez</li>
                                                <li>Dr. Luis Alberto Carranza Hernández</li>
                                                <li>Lic. Bernardito Martínez Amaya</li>     
                                                <li>Lic. Daniel Jiménez Arango</li>  
                                                <li>Mtro. Rafael Velazco Pérez</li>  
                                                <li>Dra. Ana Luz Ramos Soto</li>  
                                                <li>Dra. Xóchitl Edith Bautista García</li>  
                                                <li>Dr. Miguel Ángel López Velazco</li>
                                                <li>Ing. Mauro Francisco Pérez Morales</li> 
                                                <li>Lic. Santiago Gaytán Victoria Beleguí</li> 
                                                <li>Lic. Jazmín García</li>         
                                            </ul>
                                            <h3>Coordinadores por la Universidad Autónoma de Tamaulipas</h3>
                                            <ul style="display:inline-block;text-align:left;">
                                                <li>Dra. Mónica Lorena Sánchez Limón</li>
                                                <li>Dra. Yesenia Sánchez Tovar</li>
                                                <li>Dr. Demian Abrego Almazán</li>
                                                <li>Dr. José Melchor Medina Quintero</li>                
                                            </ul>
                                        </div>
                                    </div>
                                </div>                  
                            </section>
                        </div>

                        <%-- FECHAS --%>
                        <div class="container" id="fechas">
                            <section id="featured-services2" class="featured-services section-bg">

                                <%-- titulo --%>
                                <div class="section-title">
                                    <h2 id="Noticias">Calendario</h2>
                                </div>

                                <%-- eventos --%>
                                <div class="row no-gutters">    

                                    <%-- evento 1 --%>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">15</span> Marzo</h1>
                                            </div>
                                            
                                            <h4 class="title"><a href="#">Publicación de la Convocatoria.</a></h4>
                                            <ul class="list-inline" style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Miércoles</li>
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2023</li>
                                            </ul>                                                                  
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">15</span> Marzo</h1>
                                            </div>
                                            
                                            <h4 class="title"><a href="#">Recepción de contribuciones hasta el 18 de junio de 2023.</a></h4>
                                            <ul class="list-inline" style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Miércoles</li>
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2023</li>
                                            </ul>                                                                  
                                        </div>
                                    </div>

                                    <div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">19</span> Junio</h1>
                                            </div>
                                            
                                            <h4 class="title"><a href="#">Periodo de dictaminación hasta el 14 de julio de 2023.</a></h4>
                                            <ul class="list-inline" style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Lunes</li>
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2023</li>
                                            </ul>                                                                  
                                        </div>
                                    </div>

                                    <div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">15</span> Julio</h1>
                                            </div>
                                            
                                            <h4 class="title"><a href="#">Comunicación de resultados.</a></h4>
                                            <ul class="list-inline" style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Sábado</li>
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2023</li>
                                            </ul>                                                                  
                                        </div>
                                    </div>

                                    <div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">27</span> Septiembre</h1>
                                            </div>
                                            
                                            <h4 class="title"><a href="#">Evento hasta el 29 de septiembre de 2023.</a></h4>
                                            <ul class="list-inline" style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Miércoles</li>
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2023</li>
                                            </ul>                                                                  
                                        </div>
                                    </div>

                                    <%-- evento 2 --%>
                                    <%--<div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">11</span> Octubre</h1>
                                            </div>

                                            <h4 class="title"><a href="#p">Mesas de investigaci&oacute;n.</a></h4>                        
                                            <ul class="list-inline"  style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Martes</li>
                                                <li class="list-inline-item"><i class="bi bi-clock" aria-hidden="true"></i> 12:00 P.M. a 14:00 P.M.</li>
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2022</li>
                                            </ul>
                                            <p class="description">
                                                <b>Organizado por:</b> Divisi&oacute;n de Estudios de Posgrado e Investigaci&oacute;n.
                                            </p>
                                            <p class="description">
                                                <b>Lugar:</b> Posgrado.
                                            </p>               
                                        </div>
                                    </div>--%>


                                    <%-- evento 3 --%>
                                    <%--<div class="col-lg-4 col-md-6">
                                        <div class="icon-box">
                                            <div class="icon">
                                                <h1><span class="badge badge-secondary" style="background-color:#6c757d !important">12</span> Octubre</h1>
                                            </div>

                                            <h4 class="title"><a href="#p">Mesas de investigaci&oacute;n.</a></h4>                        
                                            <ul class="list-inline"  style="justify-content:left;">
                                                <li class="list-inline-item"><i class="bi bi-calendar4-week" aria-hidden="true"></i> Mi&eacute;rcoles</li>
                                                <li class="list-inline-item"><i class="bi bi-clock" aria-hidden="true"></i> 10:00 A.M. a 12:00 P.M.</li>                                                
                                                <li class="list-inline-item"><i class="bi bi-bookmark-check" aria-hidden="true"></i> 2022</li>
                                            </ul>
                                            <p class="description">
                                                <b>Organizado por:</b> Divisi&oacute;n de Estudios de Posgrado e Investigaci&oacute;n.
                                            </p>                                            
                                            <p class="description">
                                                <b>Lugar:</b> Auditorio FCAV.
                                            </p>               
                                        </div>
                                    </div>  --%>                                                                      
                                </div>
                            </section>
                        </div>                                                                          
                    </div>                                                 
                </section>
            </div>  
             <%-- COSTOS--%>
                        <div class="container" id="costo">
                            <section id="featured-services2" class="">

                                <%-- titulo --%>
                                <div class="section-title">
                                    <h2 id="Noticias">Costos</h2>
                                </div>

                                <%-- eventos --%>
                                <div class="container table-responsive">    

                                    <table class="table table-bordered" style="font-size: larger;">
                                        <thead>
                                            <tr style="text-align: center;">
                                                <th>Paquete</th>
                                                <th>Incluye</th>
                                                <th>Fecha</th>
                                                <th>Costo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td colspan="4" style="background-color: #206e4a;"></td>
                                            </tr>
                                        <tr>
                                            <td rowspan="9" style="vertical-align: middle;text-align: center;">Ponente y/o Asistente</td>
                                            <td>Kit de bienvenida</td>
                                            <td rowspan="4" style="vertical-align: middle;text-align: center;">27 de septiembre</td>
                                            <td rowspan="9" style="vertical-align: middle;">$4,950</td>
                                        </tr>
                                        <tr>
                                            <td>Recepción de invitados</td>
                                            
                                        </tr>
                                        <tr>
                                            <td>Muestra gastronómica (comida bufete)</td>
                                        </tr>
                                        <tr>
                                            <td>Calenda (del centro histórico de la Cd. Ciudad a instalaciones de la Universidad)</td>
                                        </tr>
                                        <tr>
                                            <td>Expo-artesanal</td>
                                            <td rowspan="4" style="vertical-align: middle;text-align: center;">28 de septiembre</td>
                                        </tr>
                                        <tr>
                                            <td>Nieve y dulces regionales</td>
                                        </tr>
                                        <tr>
                                            <td>Recorrido con guía a Mitla o Monte Alban</td>
                                        </tr>
                                        <tr>
                                            <td>Cena de gala a tres tiempos y Guelaguetza</td>
                                        </tr>
                                        <tr>
                                            <td>Constancia de participación</td>
                                            <td style="vertical-align: middle;text-align: center;">29 de septiembre</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="background-color: #206e4a;"></td>
                                        </tr>
                                        <tr>
                                            <td rowspan="8" style="vertical-align: middle;text-align: center;">Acompañante</td>
                                            <td>Recepción de invitados</td>
                                            <td rowspan="3" style="vertical-align: middle;text-align: center;">27 de septiembre</td>
                                            <td rowspan="8" style="vertical-align: middle;">$3,700</td>
                                        </tr>
                                        <tr>
                                            <td>Muestra gastronómica (comida bufete)</td>
                                        </tr>
                                        <tr>
                                            <td>Calenda (del centro histórico de la Cd. Ciudad a instalaciones de la Universidad)</td>
                                        </tr>
                                        <tr>
                                            <td>Expo-artesanal</td>
                                            <td rowspan="4" style="vertical-align: middle;text-align: center;">28 de septiembre</td>
                                        </tr>
                                        <tr>
                                            <td>Nieve y dulces regionales</td>
                                        </tr>
                                        <tr>
                                            <td>Recorrido con guía a Mitla o Monte Alban</td>
                                        </tr>
                                        <tr>
                                            <td>Cena de gala a tres tiempos y Guelaguetza</td>
                                        </tr>
                                        <tr>
                                            <td>Clausura</td>
                                            <td style="vertical-align: middle;text-align: center;">29 de septiembre</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="background-color: #206e4a;"></td>
                                        </tr>
                                    </tbody>
                                    </table>
                                                                  
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
