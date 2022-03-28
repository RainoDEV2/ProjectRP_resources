var selectedChar = null;
var WelcomePercentage = "30vh"
qbMultiCharacters = {}
var Loaded = false;

$(document).ready(function (){
    window.addEventListener('message', function (event) {
        var data = event.data;

        if (data.action == "ui") {
            if (data.toggle) {
                $('.container').show();
                $(".welcomescreen").fadeIn(150);
                qbMultiCharacters.resetAll();

                var originalText = "Retrieving player data";
                var loadingProgress = 0;
                var loadingDots = 0;
                $("#loading-text").html(originalText);
                var DotsInterval = setInterval(function() {
                    $("#loading-text").append(".");
                    loadingDots++;
                    loadingProgress++;
                    if (loadingProgress == 3) {
                        originalText = "Validating player data"
                        $("#loading-text").html(originalText);
                    }
                    if (loadingProgress == 4) {
                        originalText = "Retrieving characters"
                        $("#loading-text").html(originalText);
                    }
                    if (loadingProgress == 6) {
                        originalText = "Validating characters"
                        $("#loading-text").html(originalText);
                    }
                    if(loadingDots == 4) {
                        $("#loading-text").html(originalText);
                        loadingDots = 0;
                    }
                }, 500);
            
                setTimeout(function(){
                    $.post('https://prp-multicharacter/setupCharacters');
                    setTimeout(function(){
                        clearInterval(DotsInterval);
                        loadingProgress = 0;
                        originalText = "Retrieving data";
                        $(".welcomescreen").fadeOut(150);
                        $('.character-info').show();
                        $('.characters-list').show();
                        $.post('https://prp-multicharacter/removeBlur');
                    }, 2000);
                }, 2000);
            } else {
                // $('.container').fadeOut(250);
                qbMultiCharacters.resetAll();
            }
        }

        if (data.action == "setupCharacters") {
            setupCharacters(event.data.characters)
        }

        if (data.action == "setupCharInfo") {
            setupCharInfo(event.data.chardata)
        }
    });

    $('.datepicker').datepicker();
});

$('.continue-btn').click(function(e){
    e.preventDefault();
});

$('.disconnect-btn').click(function(e){
    e.preventDefault();

    $.post('https://prp-multicharacter/closeUI');
    $.post('https://prp-multicharacter/disconnectButton');
});

function setupCharInfo(cData) {
    if (cData == 'empty') {
        $('.character-info-valid').html('<div class="in_chi_empty">Select a character slot to see all information about your character</div>  ');
    } else {
        var gender = "Man"
        if (cData.charinfo.gender == 1) { gender = "Woman" }
        $('.character-info-valid').html(
            '<div class="in_chi_in"><i class="fas fa-address-card"></i> NAME: <span class="in_chi_in_v">'+cData.charinfo.firstname+' '+cData.charinfo.lastname+'</span></div>' +
            '<div class="in_chi_in clr"><i class="fas fa-calendar-alt"></i> BIRTHDAY: <span class="in_chi_in_v">'+cData.charinfo.birthdate+'</span></div>' +
            '<div class="in_chi_in"><i class="fas fa-venus-mars"></i> GENDER: <span class="in_chi_in_v">'+gender+'</span></div>' +
            '<div class="in_chi_in clr"><i class="fas fa-globe"></i> NATIONALITY: <span class="in_chi_in_v">'+cData.charinfo.nationality+'</span></div>' +
            '<div class="in_chi_in"><i class="fas fa-briefcase"></i> JOB: <span class="in_chi_in_v">'+cData.job.label+'</span></div>' +
            '<div class="in_chi_in clr"><i class="fas fa-wallet"></i> CASH: <span class="in_chi_in_v">'+cData.money.cash+'</span></div>' +
            '<div class="in_chi_in"><i class="fas fa-university"></i> BANK: <span class="in_chi_in_v">'+cData.money.bank+'</span></div>' +
            '<div class="in_chi_in clr"><i class="fas fa-phone"></i> PHONE NUMBER: <span class="in_chi_in_v">'+cData.charinfo.phone+'</span></div>');      
    }
}

function setupCharacters(characters) {
    $.each(characters, function(index, char){
        $('#char-'+char.cid).html("");
        $('#char-'+char.cid).data("citizenid", char.citizenid);
        setTimeout(function(){
            $('#char-'+char.cid).html('<span id="slot-name">'+char.charinfo.firstname+' '+char.charinfo.lastname+'<span id="cid">' + char.citizenid + '</span></span>');
            $('#char-'+char.cid).data('cData', char)
            $('#char-'+char.cid).data('cid', char.cid)
        }, 100)
    })
}

$(document).on('click', '#close-log', function(e){
    e.preventDefault();
    selectedLog = null;
    $('.welcomescreen').css("filter", "none");
    $('.server-log').css("filter", "none");
    $('.server-log-info').fadeOut(250);
    logOpen = false;
});

$(document).on('click', '.character', function(e) {
    var cDataPed = $(this).data('cData');
    e.preventDefault();
    if (selectedChar === null) {
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("char-selected");
            setupCharInfo('empty')
            $("#play").html("CREATE CHARACTER");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"none"});
            $.post('https://prp-multicharacter/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        } else {
            $(selectedChar).addClass("char-selected");
            setupCharInfo($(this).data('cData'))
            $("#play").text("JOIN THE CITY");
            $("#delete").text("DELETE CHARACTER");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"block"});
            $.post('https://prp-multicharacter/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        }
    } else if ($(selectedChar).attr('id') !== $(this).attr('id')) {
        $(selectedChar).removeClass("char-selected");
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("char-selected");
            setupCharInfo('empty')
            $("#play").text("CREATE CHARACTER");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"none"});
            $.post('https://prp-multicharacter/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        } else {
            $(selectedChar).addClass("char-selected");
            setupCharInfo($(this).data('cData'))
            $("#play").text("JOIN THE CITY");
            $("#delete").text("DELETE CHARACTER");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"block"});
            $.post('https://prp-multicharacter/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        }
    }
});

var entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '': '&#x60;',
    '=': '&#x3D;'
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'=/]/g, function (s) {
        return entityMap[s];
    });
}
function hasWhiteSpace(s) {
    return /\s/g.test(s);
  }
$(document).on('click', '#create', function (e) {
    e.preventDefault();
   
        let firstname= escapeHtml($('#first_name').val())
        let lastname= escapeHtml($('#last_name').val())
        let nationality= escapeHtml($('#nationality').val())
        let birthdate= escapeHtml($('#birthdate').val())
        let gender= escapeHtml($('select[name=gender]').val())
        let cid = escapeHtml($(selectedChar).attr('id').replace('char-', ''))
        
    //An Ugly check of null objects

    if (!firstname || !lastname || !nationality || !birthdate || hasWhiteSpace(firstname) || hasWhiteSpace(lastname)|| hasWhiteSpace(nationality) ){
    console.log("FIELDS REQUIRED")
    }else{
        $.post('https://prp-multicharacter/createNewCharacter', JSON.stringify({
            firstname: firstname,
            lastname: lastname,
            nationality: nationality,
            birthdate: birthdate,
            gender: gender,
            cid: cid,
        }));
        //$(".container").fadeOut(150);
        $('.characters-list').css("filter", "none");
        $('.character-info').css("filter", "none");
        //qbMultiCharacters.fadeOutDown('.character-register', '125%', 400);
        refreshCharacters()
    }
});

$(document).on('click', '#accept-delete', function(e){
    $.post('https://prp-multicharacter/removeCharacter', JSON.stringify({
        citizenid: $(selectedChar).data("citizenid"),
    }));
    $('.character-delete').hide();
    refreshCharacters();
});

$(document).on('click', '#cancel-delete', function(e){
    e.preventDefault();
    // $('.characters-block').css("filter", "none");
    // $('.character-delete').fadeOut(150);
    $('.character-delete').hide();
});

function refreshCharacters() {
    $('.characters-list').html(
        '<div id="in_head"><div id="in_head_image"></div></div><div id="in_mid"><div id="in_mid_cont"><div class="character" id="char-1" data-cid=""><span id="slot-name">Create New Character<span id="cid"></span></span></div><div class="character clr" id="char-2" data-cid=""><span id="slot-name">Create New Character<span id="cid"></span></span></div><div class="character" id="char-3" data-cid=""><span id="slot-name">Create New Character<span id="cid"></span></span></div><div class="character clr" id="char-4" data-cid=""><span id="slot-name">Create New Character<span id="cid"></span></span></div><div class="character" id="char-5" data-cid=""><span id="slot-name">Create New Character<span id="cid"></span></span></div></div></div><div id="in_end"><div id="in_end_cont"><button class="in_button green" id="play">JOIN THE CITY</button><hr class="in_space"><button class="in_button red" id="delete">DELETE CHARACTER</button></div></div>'
    )
    setTimeout(function(){
        $(selectedChar).removeClass("char-selected");
        selectedChar = null;
        $.post('https://prp-multicharacter/setupCharacters');
        $("#delete").css({"display":"none"});
        $("#play").css({"display":"none"});
        qbMultiCharacters.resetAll();
    }, 100)
}

$("#close-reg").click(function (e) {
    e.preventDefault();
    $('.character-register').hide();
    $('.character-info').show();
})

$("#close-del").click(function (e) {
    e.preventDefault();
    // $('.characters-block').css("filter", "none");
    // $('.character-delete').fadeOut(150);
    $('.character-delete').hide();
})

$(document).on('click', '#play', function(e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $.post('https://prp-multicharacter/selectCharacter', JSON.stringify({
                cData: $(selectedChar).data('cData')
            }));
            setTimeout(function(){
                $('.character-info').hide();
                $('.characters-list').hide();
                qbMultiCharacters.resetAll();
            }, 1500);
        } else {
            // $('.characters-list').css("filter", "blur(2px)") // HkHaythem
            // $('.character-info').css("filter", "blur(2px)")
            // qbMultiCharacters.fadeInDown('.character-register', '25%', 400);
            $('.character-info').hide();
            $('.character-register').show();
        }
    }
});

$(document).on('click', '#delete', function(e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            //$('.characters-block').css("filter", "blur(2px)")
            //$('.character-delete').fadeIn(250);
            $('.character-delete').show();
        }
    }
});

qbMultiCharacters.fadeOutUp = function(element, time) {
    $(element).css({"display":"block"}).animate({top: "-80.5%",}, time, function(){
        $(element).css({"display":"none"});
    });
}

qbMultiCharacters.fadeOutDown = function(element, percent, time) {
    if (percent !== undefined) {
        $(element).css({"display":"block"}).animate({top: percent,}, time, function(){
            $(element).css({"display":"none"});
        });
    } else {
        $(element).css({"display":"block"}).animate({top: "103.5%",}, time, function(){
            $(element).css({"display":"none"});
        });
    }
}

qbMultiCharacters.fadeInDown = function(element, percent, time) {
    $(element).css({"display":"block"}).animate({top: percent,}, time);
}

qbMultiCharacters.resetAll = function() {
    $('.characters-list').hide();
    $('.character-info').hide();
    $('.character-register').hide();
    $('.character-delete').hide();
    $('.welcomescreen').css("top", WelcomePercentage);
    // $('.server-log').show();
    // $('.server-log').css("top", "25%");
}
