PRP.Phone.Settings = {};
PRP.Phone.Settings.Background = "default-ProjectRP";
PRP.Phone.Settings.OpenedTab = null;
PRP.Phone.Settings.Backgrounds = {
    'default-ProjectRP': {
        label: "Standard ProjectRP"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        PRP.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        PRP.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        PRP.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        PRP.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        PRP.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", PRP.Phone.Data.AnonymousCall);

        if (!PRP.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = PRP.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        PRP.Phone.Notifications.Add("fas fa-paint-brush", "Settings", PRP.Phone.Settings.Backgrounds[PRP.Phone.Settings.Background].label+" is set!")
        PRP.Phone.Animations.TopSlideUp(".settings-"+PRP.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+PRP.Phone.Settings.Background+".png')"})
    } else {
        PRP.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal background set!")
        PRP.Phone.Animations.TopSlideUp(".settings-"+PRP.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+PRP.Phone.Settings.Background+"')"});
    }

    $.post('https://prp-phone/SetBackground', JSON.stringify({
        background: PRP.Phone.Settings.Background,
    }))
});

PRP.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        PRP.Phone.Settings.Background = MetaData.background;
    } else {
        PRP.Phone.Settings.Background = "default-ProjectRP";
    }

    var hasCustomBackground = PRP.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+PRP.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+PRP.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    PRP.Phone.Animations.TopSlideUp(".settings-"+PRP.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

PRP.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(PRP.Phone.Settings.Backgrounds, function(i, background){
        if (PRP.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            PRP.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            PRP.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    PRP.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    PRP.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    PRP.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = PRP.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        PRP.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Standard avatar set!")
        PRP.Phone.Animations.TopSlideUp(".settings-"+PRP.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        PRP.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal avatar set!")
        PRP.Phone.Animations.TopSlideUp(".settings-"+PRP.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('https://prp-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    PRP.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    PRP.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            PRP.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            PRP.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    PRP.Phone.Animations.TopSlideUp(".settings-"+PRP.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    PRP.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});
