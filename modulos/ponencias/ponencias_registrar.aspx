<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="ponencias_registrar.aspx.cs" Inherits="ponencias_registrar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <!--ESTE ES EL PRINCIPAL CSS del plugin-->
    <link href="../../FileInput/css/fileinput.css" rel="stylesheet" />

    <!--Tema utilizado-->
    <link href="../../FileInput/themes/explorer-fa5/theme.css" rel="stylesheet" />

    <%-- Selects con búsqueda --%>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <!--Estos son para conversión de archivos-->
    <script src="../../FileInput/js/plugins/buffer.min.js"></script>
    <script src="../../FileInput/js/plugins/filetype.min.js"></script>
    <!--ESTOS SON OPCIONALES, AÑADEN EXTRAS DE ORIENTACIÓN (Deben cargarse antes del fileinput.js-->
    <script src="../../FileInput/js/plugins/piexif.js"></script>
    <script src="../../FileInput/js/plugins/sortable.js"></script>

    <%-- Scripts de confirmación más bonitos --%>
    <link href="//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css" rel="stylesheet" type="text/css" />
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!-- Ponencias registrar -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <div class="text-left">
            <a href="#" onclick="window.location=document.referrer;"><button id="btnRegresar" type="button" class="btn btn-primary btn-block w-auto">Regresar</button></a>
        </div>
        <br>
        <h3><strong><span id="lblTit">Agregar una ponencia</span></strong></h3>
        <br/>

        <div class="card-body">
            <div class="container">
                <%-- tabs --%>
                <ul class="nav nav-pills mb-3 nav-justified" id="pills-tab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="pills-1" data-bs-toggle="pill" data-bs-target="#pills-datos" type="button" role="tab" aria-controls="pills-datos" aria-selected="true">Datos generales</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pills-2" data-bs-toggle="pill" data-bs-target="#pills-autor" type="button" role="tab" aria-controls="pills-autor" aria-selected="false" disabled>Autores</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pills-3" data-bs-toggle="pill" data-bs-target="#pills-archivo" type="button" role="tab" aria-controls="pills-autor" aria-selected="false" disabled>Archivo</button>
                    </li>
                </ul>
                <br/>
                <div class="tab-content" id="pills-tabContent">
                    <%-- Tab 1 --%>
                    <%-- <asp:TextBox ID="idPonencia" Text="0" runat="server"/> --%>
                    <input id="idPonencia" type="text" hidden="hidden"/>
                    <input id="ronda" type="text" hidden="hidden"/>
                    <div class="tab-pane fade show active" id="pills-datos" role="tabpanel" aria-labelledby="pills-1" tabindex="0">
                        <div class="row mb-3 g-3 align-items-center">
                            <label for="txtTit" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-sm-end text-start">Título de la ponencia:</label>
                            <div class="col-xxl-4 col-sm-6">
                                <input type="text" id="txtTit" class="form-control" required>
                            </div>
                        </div>
                        <div class="row g-3 mb-3 align-items-center" hidden>
                            <label for="selectMod" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-sm-end text-start">Modalidad:</label>
                            <div class="col-xxl-4 col-sm-6">
                                <asp:DropDownList ID="selectMod" ClientIDMode="Static" CssClass="form-select" runat="server" required></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row g-3 mb-3 align-items-center">
                            <label for="selectTema" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-sm-end text-start">Mesa Temática:</label>
                            <div class="col-xxl-4 col-sm-6">
                                <asp:DropDownList ID="selectTema" ClientIDMode="Static" CssClass="form-select" runat="server" required></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row g-3 align-items-center">
                            <label for="txtRes" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-sm-end text-start">Resumen :</label>
                            <div class="col-xxl-4 col-sm-6">
                                <textarea id="txtRes" class="form-control" rows=8 maxlength="1500" oninput="countWords();" required></textarea>
                            </div>
                        </div>
                        <div class="row g-3 mb-3 align-items-center">
                            <div class="offset-xxl-4 offset-sm-3 col-xxl-4 col-sm-6">
                                <small class="form-text text-muted"><span id="conttxtRes" class="float-end">(0/200) palabras.</span></small>
                            </div>
                        </div>
                        <%-- <div class="row g-3 mb-3 align-items-center">
                            <label for="fileArch" class="offset-3 col-xxl-1 col-form-label text-end">Archivo:</label>
                            <div class="col-4">
                                <input class="form-control" type="file" id="fileArch">
                            </div>
                        </div> --%>
                        <%-- Así era antes de achicar el input con las palabras --%>
                        <%-- <div class="row g-3 align-items-center">
                            <label for="txtPal" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-sm-end text-start">Palabras clave:</label>
                            <div class="col-xxl-4 col-sm-6 col-8 d-grid d-sm-block">
                                <input type="text" id="txtPal" class="form-control"/>
                            </div>
                            <div class="col-sm-3 col-4 d-grid d-sm-block">
                                <button id="btnPalabras" class="btn btn-light border" type="button">Agregar</button>
                            </div>
                        </div> --%>
                        <div class="row g-3 align-items-center">
                            <label for="txtPal" class="offset-xxl-2 col-xxl-2 col-sm-3  col-form-label text-sm-end text-start">Palabras clave:</label>
                            <div class="col-xxl-3 col-sm-4 col-8 d-grid d-sm-block">
                                <input type="text" id="txtPal" class="form-control"/>
                            </div>
                            <div class="col-xxl-1 col-sm-2 col-4 d-grid d-block">
                                <button id="btnPalabras" class="btn btn-light border" type="button">Agregar</button>
                            </div>
                        </div>
                        <div class="row g-3 mb-3 align-items-center" id="divPal">
                            <div class="offset-xxl-4 offset-sm-3 col-xxl-3 col-sm-4 col-8">
                                <div class="row">
                                    <div class="col-xxl-10 col-sm-9 col-10 d-grid d-sm-block">
                                        <p class="text-danger">*Agregue las palabras de una por una.</p>
                                    </div>
                                    <div class="col-xxl-2 col-sm-3 col-2">
                                        <span id="numPalabras" class="float-end text-muted">(0/5)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row g-3 mb-3 mt-3 align-items-center">
                            <div class="text-center">
                                <button id="btnPonencia" type="button" class="btn btn-primary btn-block w-auto">Siguiente</button>
                            </div>
                        </div>
                    </div>

                    <%-- Tab 3 --%>
                    <div class="tab-pane fade" id="pills-archivo" role="tabpanel" aria-labelledby="pills-2" tabindex="0">
                        <!--Para hacer zoom y previsualizar en un modal-->
                        <!-- Está en la master, el conflicto era el jquery repetido -->
                        <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script> -->
                        <!--JS PRINCIPAL DEL PLUGIN-->
                        <script src="../../FileInput/js/fileinput.js"></script>
                        <!--ESTE ES PARA LENGUAJE A ESPAÑOL-->
                        <script src="../../FileInput/js/locales/es.js"></script>
                        <!--Para usar el tema de fontawesome5-->
                        <script src="../../FileInput/themes/explorer-fa5/theme.js"></script>
                        <script src="../../FileInput/themes/fa5/theme.js"></script>

                        <div id="handler"></div>
                        <div class="form-group" id="fileInput">
                            <div class="file-loading" >
                                <input id="file-input" type="file" multiple data-preview-file-type="any"/>
                            </div>
                        </div>
                        <div class="row g-3 mt-4 mb-3 align-items-center">
                            <div class="col-12 text-danger justificar">
                                <p>
                                    <u>Los trabajos deberán ser cargados en formato <b>DOC/DOCX</b>, el archivo deberá tener un tamaño máximo de <b>8mb</b> y se deberá cargar <b>1</b> archivo por ponencia.</u>
                                </p>
                            </div>
                        </div>
                        <div class="row g-3 mb-3 mt-4 align-items-center">
                            <div class="text-center">
                                <button type="button" id="btnGuardar" class="btn btn-secondary btn-block w-auto">Guardar</button>
                            </div>
                        </div>
                    </div>

                    <%-- Tab 2 --%>
                    <div class="tab-pane fade" id="pills-autor" role="tabpanel" aria-labelledby="pills-3" tabindex="0">
                        <!-- Lista Autores -->
                        <!-- <div id="tablaAutores" class="card-body shadow p-3 mb-5 bg-body rounded"> -->
                            <!-- <h3><strong>Lista de autores</strong></h3> -->
                            <div class="container">
                                <button id="btnAutorModal" type="button" class="btn btn-primary btn-block w-auto mb-4" data-bs-toggle="modal" data-bs-target="#modaladd" role="button">Agregar nuevo autor</button>
                                <br/>
                                <div id="generarTabla" class="table-responsive"></div>
                                <br/>
                            </div>
                            <div class="container">
                                <div class="row g-3 mb-3 align-items-center">
                                    <div class="text-center">
                                        <button id="btnAutorSig" type="button" class="btn btn-primary btn-block w-auto">Siguiente</button>
                                    </div>
                                </div>
                            </div>
                        <!-- </div> -->

                        <%-- ---- Modal agregar/editar autor ------- --%>
                        <div class="modal fade bd-modal-del" id="modaladd" tabindex="-1" role="dialog" aria-labelledby="titulomodal" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title h4" id="titulomodal">Agregar autor</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="text" id="idAutor" value="0" hidden="hidden">
                                        <div class="row mb-3 g-3 align-items-center">
                                            <label for="txtAut" class="offset-xxl-1 col-xxl-3 col-sm-3  col-form-label text-sm-end text-start">Nombre del autor:</label>
                                            <div class="col-xxl-4 col-sm-6">
                                                <input type="text" id="txtAut" class="form-control" required="required"/>
                                            </div>
                                        </div>
                                        <div class="row mb-3 g-3 align-items-center">
                                            <label for="txtCor" class="offset-xxl-1 col-xxl-3 col-sm-3  col-form-label text-sm-end text-start">Correo del autor:</label>
                                            <div class="col-xxl-4 col-sm-6">
                                                <input type="text" id="txtCor" class="form-control" required="required"/>
                                            </div>
                                        </div>
                                        <%-- <div class="row mb-3 g-3 align-items-center">
                                            <label for="inputSex" class="offset-xxl-1 col-xxl-3 col-sm-3  col-form-label text-sm-end text-start">Sexo del autor:</label>
                                            <div class="col-xxl-4 col-sm-6">
                                                <select id="inputSex" class="form-select" required>
                                                    <option value="0">- Seleccionar -</option>
                                                    <option value="Hombre">Hombre</option>
                                                    <option value="Mujer">Mujer</option>
                                                    <option value="Otro">Otro</option>
                                                </select>
                                            </div>
                                        </div> --%>
                                        <div class="row mb-3 g-3 align-items-center">
                                            <label for="inputEstado" class="offset-xxl-1 col-xxl-3 col-sm-3  col-form-label text-sm-end text-start">Estado de la institución del autor:</label>
                                            <div class="col-xxl-4 col-sm-6">
                                                <%-- <input type="text" id="txtIns" class="form-control" required="required"/> --%>
                                                <select id="inputEstado" class="form-select" onchange="cargarInstitucion()" required>
                                                    <option value="0">- Seleccionar -</option>
                                                </select>
                                            </div>
                                        </div>                                        
                                        <div class="row mb-3 g-3 align-items-center">
                                            <label for="inputInstitucion" class="offset-xxl-1 col-xxl-3 col-sm-3  col-form-label text-sm-end text-start">Institución del autor:</label>
                                            <div class="col-xxl-4 col-sm-6">
                                                <%-- <input type="text" id="txtIns" class="form-control" required="required"/> --%>
                                                <select id="inputInstitucion" class="form-select" disabled required>
                                                    <option value="0">Seleccione un estado</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row g-3 mb-3 align-items-center">
                                            <label for="selectAut" class="offset-xxl-1 col-xxl-3 col-sm-3  col-form-label text-sm-end text-start">Tipo de autor:</label>
                                            <div class="col-xxl-4 col-sm-6">
                                                <asp:DropDownList ID="selectAut" ClientIDMode="Static" CssClass="form-select" runat="server" required="required"></asp:DropDownList>
                                            </div>
                                        </div>
                                        <%-- <div class="row g-3 align-items-center">
                                            <div class="col-xxl-4 offset-xxl-4 col-sm-8 offset-sm-2 justificar">
                                                <p>
                                                    Nota: Introduzca el nombre de un autor y la institución, despues debe dar clic en agregar autor.
                                                </p>
                                            </div>
                                        </div> --%>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" id="btnAutor" class="btn btn-primary" style="float: right; margin-left: 5px;">Guardar</button>
                                        <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                                    </div>
                                    <input type="hidden" id="btnAutorClick" value="0">
                                </div>
                            </div>
                        </div>
                        <%-- ------------------ --%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- ---- Modal eliminar autor ------- --%>
    <div class="modal fade bd-modal-del" id="modaldel" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="myLargeModalLabel21">ELIMINAR</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h2>¿Está seguro de eliminar al autor?</h2>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnEliminar" class="btn  btn-primary eliminar" data-bs-dismiss="modal" style="float: right; margin-left: 5px;">Confirmar</button>
                    <button type="button" class="btn  btn-secondary" data-bs-dismiss="modal" style="float: right;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
    <%-- ------------------ --%>

    <script src="../../js/registro-ponencias.js"></script>
    <script src="../../js/registro-ponencias-datos.js"></script>
    <script src="../../js/registro-ponencias-autores.js"></script>
    <script src="../../js/registro-ponencias-validacion.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            $('.customsel').select2();            
        });

        function countWords() {
            let textarea = document.getElementById("txtRes");
            let wordCount = document.getElementById("conttxtRes");

            // Eliminar espacios en blanco al inicio y al final del texto
            let text = textarea.value.trim();

            // Dividir el texto en palabras usando espacios en blanco (o líneas nuevas) como separadores
            let words = text.split(/\s+/);

            // Contar el número de palabras y actualizar el contador
            let count = words.length;
                       
            if (count > 200) {
                // Nuevo arreglo recortando las palabras sobrantes
                var palabrasTot = words.slice(0, 200);                
                textarea.value = palabrasTot.join(' ');
                
                // Actualizar el contador de palabras
                count = textarea.value.trim().split(/\s+/).length;                
            }

            if (text == "") {
                wordCount.textContent = "(0/200) palabras.";
            } else {
                wordCount.textContent = "(" + count + "/200) palabras.";
            }  
        }


        <%-- var myModalEl = document.getElementById('modaladd');
        myModalEl.addEventListener('shown.bs.modal', function (event) {
            if ($('#inputEstado option').length == 1) {
                displayOption();
            }
        }) --%>

        //Api de estados
        const batchTrack = document.getElementById("inputEstado");
        const getPost = async () => {
            const response = await fetch("https://api.datamexico.org/tesseract/data.jsonrecords?cube=inegi_population_total&drilldowns=State&locale=es&measures=Population");
            const data = response.json();
            return data;
        };

        const displayOption = async () => {
        const options = await getPost();
        options.data.forEach(option => {
            const newOption = document.createElement("option");
            newOption.value = option["State ID"];
            newOption.text = option.State;
            batchTrack.appendChild(newOption);

        });
        sortear("#inputEstado");
        $("#inputEstado").append("<option value='9999' selected>Otro</option>");
        $("#inputEstado option[value=0]").attr('selected', 'selected');
        };
        displayOption();

        //funcion para la api de instituciones
        function cargarInstitucion(){
            $("#inputInstitucion option").each(function() {
                $(this).remove();
            });
            var id = $('#inputEstado').val();
            if(id == "0"){
                const batchTrack = document.getElementById("inputInstitucion");
                const newOption = document.createElement("option");
                newOption.value = 0;
                newOption.text = "Seleccione un estado";
                batchTrack.appendChild(newOption);
                $("#inputInstitucion").attr('disabled',true);
            }else if(id == 9999){
                const batchTrack = document.getElementById("inputInstitucion");
                const newOption = document.createElement("option");
                newOption.value = 9999;
                newOption.text = "No aplica";
                batchTrack.appendChild(newOption);
                $("#inputInstitucion").attr('disabled',true);
            } else {
            const batchTrack = document.getElementById("inputInstitucion");
            const getPost = async () => {
                const response = await fetch("https://api.datamexico.org/tesseract/data.jsonrecords?State="+id+"&cube=anuies_enrollment&drilldowns=Institution&locale=es&measures=Students");
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
                newOption.value = option["Institution ID"];
                newOption.text = option.Institution;
                batchTrack.appendChild(newOption);
                $("#inputInstitucion").removeAttr('disabled');
            });
            sortear("#inputInstitucion");
            $("#inputInstitucion option[value=0]").attr('selected', 'selected');
            };
            displayOption();
            }
        }

        //función para sortear alfabéticamente las opciones de un select mandando el id del select
        function sortear(id) {
            $(id).append($(id+" option").remove().sort(function(a, b) {
                var at = $(a).text(),
                    bt = $(b).text();
                return (at > bt) ? 1 : ((at < bt) ? -1 : 0);
            }));
        }

        function notificacionSalir() {

        }
    </script>
</asp:Content>