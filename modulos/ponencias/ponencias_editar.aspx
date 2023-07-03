<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="ponencias_editar.aspx.cs" Inherits="ponencias_editar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!-- Editar Ponencias -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        
        <h3><strong>Editar la ponencia: <span id="titulolbl"></span></strong></h3>
        <br>

        <div class="tab-pane fade show active" id="pills-datos" role="tabpanel" aria-labelledby="pills-1" tabindex="0">
                <div class="row mb-3 g-3 align-items-center">
                    <label for="txtTit" class="offset-3 col-sm-1 col-form-label text-end">Título:</label>                    
                    <div class="col-4">
                        <input type="text" id="txttitulo" class="form-control">
                    </div>
                </div>
                <div class="row g-3 mb-3 align-items-center">                    
                    <label for="selectMod" class="offset-3 col-sm-1 col-form-label text-end">Modalidad:</label>     
                    <div class="col-4">
                        <asp:DropDownList class="form-select" ID="txtmodalidad" ClientIDMode="Static" runat="server"></asp:DropDownList>
                    </div>                    
                </div>
                <div class="row g-3 mb-3 align-items-center">                    
                    <label for="selectTema" class="offset-3 col-sm-1 col-form-label text-end">Tema:</label>                    
                    <div class="col-4">
                        <asp:DropDownList class="form-select" ID="txttema" ClientIDMode="Static" runat="server"></asp:DropDownList>
                    </div>                    
                </div>
                <div class="row g-3 mb-3 align-items-center">                    
                    <label for="txtRes" class="offset-3 col-sm-1 col-form-label text-end">Resumen:</label>
                    <div class="col-4">
                        <textarea id="txtresumen" class="form-control" rows=8> </textarea>
                    </div>                    
                </div>                
                <div class="row g-3 mb-5 align-items-center">                    
                    <label for="txtPal" class="offset-2 col-sm-2 col-form-label text-end">Palabras clave:</label>                    
                    <div class="col-4">
                        <input type="text" id="txtpalclave" class="form-control">
                    </div>
                    <div class="col-1">
                        <button id="btnPalabras" class="btn btn-light border btn-block w-100" type="button">Agregar</button>
                    </div>         
                </div>
                <div class="text-center"><a class="btn btn-primary btn-block" onclick="ModDatos();" style="width: 25%;">Guardar cambios</a></div>
                
            </div>
        <br>
    </div>
    <script>
        window.onload=function(){
            ModificarPonencia();
        }

        function ModificarPonencia() {
            var id = <%=idponencia%>;
            $.ajax({
                type: 'POST',
                url: 'ponencias_editar.aspx/ModificarPonencia',
                data: "{'id':'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error" + jqXHR.responseText);
                }, success: function (informacion) {
                    var jsonD = $.parseJSON(informacion.d);
                    $('#txttitulo').val(jsonD.titulo);
                    $('#txtmodalidad').val(jsonD.modalidad);
                    $('#txttema').val(jsonD.tema);
                    $('#txtresumen').val(jsonD.resumen);
                    $('#txtpalclave').val(jsonD.palabrasClave);
                    $('#titulolbl').html(jsonD.titulo);                    
                }
            });
        }  

        function ModDatos(){
            var idponencia = <%=idponencia%>;
            var titulo = $('#txttitulo').val();
            var modalidad = $('#txtmodalidad').val();
            var tema = $('#txttema').val();
            var resumen = $('#txtresumen').val();
            var palabClave = $('#txtpalclave').val();
            

            if(titulo == "" || modalidad == 0 || tema == 0 || resumen == "" || palabClave == "") {
                PNotify.notice({
                    text: 'Por favor complete los campos.',
                    delay: 2500,
                    addClass: 'translucent'
                });                
                return;
            }

            var obj = {};
            obj.idPonencia = idponencia;
            obj.titulo = titulo;
            obj.modalidad = modalidad;
            obj.tema = tema;
            obj.resumen = resumen;
            obj.palabClave = palabClave;                      

            $.ajax({
                type: 'POST',
                url: 'ponencias_editar.aspx/ModificarDatos',
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
                            text: 'La información se actualizó correctamente.',
                            delay: 2500,
                            addClass: 'translucent'
                        });
                        setTimeout(function myfunction() {
                            window.location.href = "ponencias_listar.aspx";
                        }, 2500);
                        
                    }
                }
            });
        }
    </script>
</asp:Content>

