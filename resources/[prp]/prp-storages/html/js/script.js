PRP = {}
PRP.Storages = {}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "open":
            $(".keypad-container").fadeIn(250);
        break;
        case "close":
            PRP.Storages.Close()
        break;
    }
});

$(document).on('click', '.submit', function(e){
    e.preventDefault();
    PRP.Storages.Submit();
    PRP.Storages.Close();
});

PRP.Storages.Open = function() {
    $('#pass').val('');
    $(".keypad-container").fadeIn(250);
}

PRP.Storages.Close = function() {
    $(".keypad-container").fadeOut(250);
    $.post(`https://${GetParentResourceName()}/Close`);
}

PRP.Storages.Submit = function() {
    $.post(`https://${GetParentResourceName()}/CheckPincode`, JSON.stringify({
        pincode: $('#pass').val(),
    }));
}


document.onkeyup = function (data) {
    if (data.code == 'Enter' ) {
        PRP.Storages.Submit();
        PRP.Storages.Close();
    } else if (data.code == 'Escape' ) {
        PRP.Storages.Close();
    }
}



















PRP.Container = {}

PRP.Container.Open = function() {
    $('#pass').val('');
    $(".container").fadeIn(250);
}


document.onkeyup = function (data) {
    if (data.code == 'Enter' ) {
        PRP.Container.Submit();
        PRP.Container.Close();
    } else if (data.code == 'Escape' ) {
        PRP.Container.Close();
    }
}



window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "openContainer":
            // p
            $("#container").find("p").html("" +event.data.Main)
            $(".container").fadeIn(250);
        break;
        case "close":
            PRP.Container.Close()
        break;
    }
});

$(document).on('click', '.submits', function(e){
    e.preventDefault();
    PRP.Container.Submit();
    // PRP.Container.Close();
});

PRP.Container.Open = function() {
    $('#password').val('');
    $(".container").fadeIn(250);
}

PRP.Container.Close = function() {
    $(".container").fadeOut(250);
    $.post(`https://${GetParentResourceName()}/cancels`);
}

PRP.Container.Submit = function() {
    $(".container").fadeOut(250);
    $.post(`https://${GetParentResourceName()}/dataPosts`, JSON.stringify({
        data: $('#password').val(),
    }));
}
