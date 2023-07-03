
    $(document).on("click", function(event){
    if(!$(event.target).closest("#navbarm").length){
        // Showing the hint message
        alert("Click fuera de ul");
    }
});