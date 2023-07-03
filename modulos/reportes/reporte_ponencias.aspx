<%@ Page Title="" Language="C#" MasterPageFile="~/modulos/MasterPage.master" AutoEventWireup="true" CodeFile="reporte_ponencias.aspx.cs" Inherits="reporte_ponencias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!-- Ponencias section -->
    <div class="card shadow p-3 mb-5 bg-body rounded">
        <h3><strong>Reporte: </strong></h3>
        <br>
        <div id="TablaReporte" class="table-responsive"></div>
        <div class="text-left">
            <button id="btnExportar" class="btn btn-primary w-auto btn-block" onclick="htmlExcel('tabla', 'Reporte_Puntos_Canjeados')">Exportar</button>
        </div>

        <p style="color: red;"><strong>* En este reporte solo se contemplan las evaluaciones de la primera ronda.</strong></p>
    </div>
    <script src="https://unpkg.com/xlsx@latest/dist/xlsx.full.min.js"></script>
    <script src="https://unpkg.com/file-saverjs@latest/FileSaver.min.js"></script>
    <script src="https://unpkg.com/tableexport@latest/dist/js/tableexport.min.js"></script>
    <script>
        
        window.onload = function (){
            TablaReportePonencia();
        }

        function TablaReportePonencia (){
            $.ajax({
                type: 'POST',
                url: 'reporte_ponencias.aspx/reportePonencias',
                contentType: "application/json; charset=u tf-8",
                dataType: "json",
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("Error- Status: " + "jqXHR Status: " + jqXHR.Status + "jqXHR Response Text:" + jqXHR.responseText);
                },
                success: function (tabla) {
                    $("#TablaReporte").html(tabla.d); //nombre del id del div de la tabla
                    setTimeout(function myfunction() {
                        estiloDataTableR();
                    }, 100);
                }
            });
        }
///////////////////

const $btnExportar = document.querySelector("#btnExportar"),
    $tabla = document.querySelector("#tabla");

    $btnExportar.addEventListener("click", function() {
        let tableExport = new TableExport($tabla, {
        exportButtons: false,
        filename: "Puntos Canjeados",
        sheetname: "Puntos Canjeados",
        });
        let datos = tableExport.getExportData();
        let preferenciasDocumento = datos.tabla.xlsx;
        tableExport.export2file(preferenciasDocumento.data, preferenciasDocumento.mimeType, preferenciasDocumento.filename, preferenciasDocumento.fileExtension, preferenciasDocumento.merges, preferenciasDocumento.RTL, preferenciasDocumento.sheetname);
    });

function htmlExcel(idTabla, nombreArchivo = '') {
  let linkDescarga;
  let tipoDatos = 'application/vnd.ms-excel';
  let tablaDatos = document.getElementById(idTabla);
  let tablaHTML = tablaDatos.outerHTML.replace(/ /g, '%20');

  // Nombre del archivo
  nombreArchivo = nombreArchivo ? nombreArchivo + '.xlsx' : 'Reporte_Puntos_Canjeados.xlsx';

  // Crear el link de descarga
  linkDescarga = document.createElement("a");

  document.body.appendChild(linkDescarga);

  if (navigator.msSaveOrOpenBlob) {
    let blob = new Blob(['\ufeff', tablaHTML], {
      type: tipoDatos
    });
    navigator.msSaveOrOpenBlob(blob, nombreArchivo);
  } else {
    // Crear el link al archivo
    linkDescarga.href = 'data:' + tipoDatos + ', ' + tablaHTML;

    // Setear el nombre de archivo
    linkDescarga.download = nombreArchivo;

    //Ejecutar la función
    linkDescarga.click();
  }
}
  //////////////////

        function estiloDataTableR(page, leng) {
            $('#tabla').DataTable({
                "lengthMenu": [5, 10, 25, 50, 75, 100],
                "pageLength": leng,
                "info": false,            
                pagingType: 'numbers',
                order: [[1, 'desc']],
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
    </script>
</asp:Content>

