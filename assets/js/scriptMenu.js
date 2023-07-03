$(document).ready(function() {
  /* $("#menu div.vertical-menu").hide();
  alert("hola"); */

  $("#menu .handle .handle-table .handle-table-cell .handle-group").on("click", function() {      
    var $menu = $(this).parents("#menu");
    var left = $menu.offset().left < 0 ? 0 : -($menu.width());    
    $menu.animate({
      left: left
    });    
    /* $("#content").animate({
      "margin-left": -$menu.offset().left
    }) */
    $(this).find(".handle-collapse").toggleClass("active");
    /* $("#menu div.vertical-menu").show(); */
    $(this).find(".handle-expand").toggleClass("active");
  });
  
  setTimeout(function() { 
    $("#menu .handle .handle-group").trigger("click");
  }, 500);
});

$(function() {
  $("#menu nav ul li").click(function() {
        if (typeof $(this).data("menu") != 'undefined') {
          var menu = $(this).data("menu");
          if (typeof menu != 'undefined') {
            var $menu = $("#menu nav div[data-menu='" + menu + "']").first();
            if (typeof $menu != 'undefined') {
              if ($menu.is(":hidden")) {
                $.each($(this).siblings(), function() {
                  $(this).removeClass("open");
                });
                $.each($("#menu nav:not(.menu-1) div"), function() {
                  $(this).slideUp(300);
                });
                $menu.stop(true, true).slideDown(300);
                $(this).addClass("open");
              }
            }
          }
        }
      });
  
/*    $("#menu nav ul li a")
    .click(function() {
      $(this).parent("li").addClass("active");
      $(this).parent("li").siblings().removeClass("active");
      if($(this).parent("nav:not(.menu-1)")) {
        $(this).parent("div").data("menu")
      }
    }); */
/*
  $("#menu")
    .mouseleave(
      function() {
        $.each($(this).find(".open"), function() {
          $(this).removeClass("open");
        });
        $.each($("#menu nav:not(.menu-1) div"), function() {
          $(this).slideUp(300);
        });
        var $activeMenu = $(this).find("nav ul li.active");
        if (typeof $activeMenu != 'undefined') {
          var activeMenu = $activeMenu.data("menu");
  
          if (typeof activeMenu != 'undefined') {
            $(this).find("nav:not(.menu-1) div[data-menu='" + activeMenu + "']").first().stop().slideDown(300);
          }
        }
      }); */

      /*$("#menu .handle .handle-group").click(function() {
        var $menu = $(this).parents("#menu");
        var left = $menu.offset().left < 0 ? 0 : -($menu.width());    
        $menu.animate({
          left: left
        });    
        /* $("#content").animate({
          "margin-left": -$menu.offset().left
        }) 
        $(this).find(".handle-collapse").toggleClass("active");
        /* $("#menu div.vertical-menu").show(); 
        $(this).find(".handle-expand").toggleClass("active");
      }); */

});