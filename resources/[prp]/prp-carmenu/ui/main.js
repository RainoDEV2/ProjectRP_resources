let open = false;
let windowDown = false;
let driver = true;
let engineOn;

addEventListener("message",(e)=>{
    let data = e.data
    if(data.action){
        $("#main-container").fadeIn();
        $("#car-name").text(`Name: ${data.vehName}`);
        $("#car-plate").text(`Plate: ${data.vehPlate}`);
        $("#car-health").text(`Health: ${data.vehHealth}%`);
        $("#car-fuel").text(`Fuel: ${data.vehFuel}%`);
        $("#car-fuel-bar").css("width",`${data.vehFuel}%`);
        $("#car-health-bar").css("width", `${data.vehHealth}%`);
    }
    if(data.action == "engineOn"){
        engineOn = true
        $("#btn-main").css("background-color", "rgba(0, 0, 0, 0.61)");
    }else if(data.action == "engineOff"){
        engineOn = false
        $("#btn-main").css("background-color", "rgba(0, 0, 0, 0.00)");
    }
    if(data.driver){
        driver = true;
    }else{
        driver = false;
    }
})

// let targetTimer = false;
$(".seat").on("click", function() {
    let seat = $(this).data("seat");
    // let door = $(this).data("door");
    // let name = $(this).data("name");
    let element = $(this);

    // if (targetTimer) {
    //     if(!open){
    //         open = true
    //         $("#"+name).css("border","2px solid #6364e7")
    //         $.post("http://prp-carmenu/openDoor",JSON.stringify({door}));
    //     }else{
    //         open = false
    //         $("#"+name).css("border","2px solid #353572")
    //         $.post("http://prp-carmenu/closeDoor",JSON.stringify({door}));
    //     }
    //     targetTimer = false;
    // } else {
    //     targetTimer = setTimeout(function() {
            // if (targetTimer) {
                if(seat == undefined){
                }else{
                    $.post("http://prp-carmenu/changeSeat",JSON.stringify({seat}));
                }
            //     targetTimer = false;
            // }
        // }, 300)
    // }
});

$(".door").on("click", function() {
    let door = $(this).data("door");
    let name = $(this).data("name");
    let element = $(this);

    if(!open){
        open = true
        $("#"+name).css("border","2px solid #6364e7")
        $.post("http://prp-carmenu/openDoor",JSON.stringify({door}));
    }else{
        open = false
        $("#"+name).css("border","2px solid #353572")
        $.post("http://prp-carmenu/closeDoor",JSON.stringify({door}));
    }
});

$(".window").click(function() {
    let window = $(this).data("window");
    let name = $(this).data("name");
    if(! windowDown){
        windowDown = true
        $("#"+name).css("border","2px solid #6364e7")
        $.post("http://prp-carmenu/windowDown",JSON.stringify({window}));
    }else{
        windowDown = false
        $("#"+name).css("border","2px solid #353572")
        $.post("http://prp-carmenu/windowUp",JSON.stringify({window}));
    }
})

$("#btn-main").click(function() {
    // if(driver){
        if(engineOn){
            $("#btn-main").css("background-color", "rgba(0, 0, 0, 0.00)");
            $.post("http://prp-carmenu/engineOff",JSON.stringify({}));
            engineOn = false
        }else{
            $("#btn-main").css("background-color", "rgba(0, 0, 0, 0.61)");
            $.post("http://prp-carmenu/engineOn",JSON.stringify({}));
            engineOn = true
        }
    // }
})

document.onkeyup = (e) =>{
    const key = e.key;
    if (key == "Escape"){
        $('#main-container').fadeOut();
        $.post("http://prp-carmenu/close",JSON.stringify({}));
    }
};