$(document).ready(function(){
    var windowsize = $(window).width();
    if(windowsize<992){
        var link = document.getElementById("doctorados");
        link.setAttribute('href', "/Posgrado/Oferta_Academica/secciones2015/Doctorados.aspx");
    } 
}); 