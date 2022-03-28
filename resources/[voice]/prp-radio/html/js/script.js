$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            PRPRadio.SlideUp()
        }

        if (event.data.type == "close") {
            PRPRadio.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('https://prp-radio/escape', JSON.stringify({}));
            PRPRadio.SlideDown()
        } else if (data.which == 13) { // Enter key
            $.post('https://prp-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

PRPRadio = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('https://prp-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('https://prp-radio/leaveRadio');
});

PRPRadio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

PRPRadio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}