PRP = {}
PRP.Phone = {}
PRP.Screen = {}
PRP.Phone.Functions = {}
PRP.Phone.Animations = {}
PRP.Phone.Notifications = {}
PRP.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

PRP.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
}

PRP.Phone.Data.MaxSlots = 16;

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;
var up = false

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob && PRP.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}

PRP.Phone.Functions.SetupApplications = function(data) {
    PRP.Phone.Data.Applications = data.applications;

    var i;
    for (i = 1; i <= PRP.Phone.Data.MaxSlots; i++) {
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+i+'"]');
        $(applicationSlot).html("");
        $(applicationSlot).css({
            "background-color":"transparent"
        });
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');
        $(applicationSlot).removeData('placement')
    }

    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, PRP.Phone.Data.PlayerJob.name)

        if ((!app.job || app.job === PRP.Phone.Data.PlayerJob.name) && !blockedapp) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="police-icon">';
            }
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
            $(applicationSlot).prop('title', app.tooltipText);
            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos)
            }
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}

PRP.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

PRP.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (PRP.Phone.Data.currentApplication == null) {
                PRP.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                PRP.Phone.Functions.ToggleApp(PressedApplication, "block");

                if (PRP.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    PRP.Phone.Functions.HeaderTextColor("black", 300);
                }

                PRP.Phone.Data.currentApplication = PressedApplication;

                if (PressedApplication == "settings") {
                    $("#myPhoneNumber").text(PRP.Phone.Data.PlayerData.charinfo.phone);
                    $("#mySerialNumber").text("prp-" + PRP.Phone.Data.PlayerData.metadata["phonedata"].SerialNumber);
                } else if (PressedApplication == "twitter") {
                    $.post('https://prp-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        PRP.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('https://prp-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        PRP.Phone.Notifications.LoadHashtags(Hashtags)
                    })
                    if (PRP.Phone.Data.IsOpen) {
                        $.post('https://prp-phone/GetTweets', JSON.stringify({}), function(Tweets){
                            PRP.Phone.Notifications.LoadTweets(Tweets);
                        });
                    }
                } else if (PressedApplication == "bank") {
                    PRP.Phone.Functions.DoBankOpen();
                    $.post('https://prp-phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        PRP.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('https://prp-phone/GetInvoices', JSON.stringify({}), function(invoices){
                        PRP.Phone.Functions.LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('https://prp-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        PRP.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('https://prp-phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        PRP.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('https://prp-phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        PRP.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('https://prp-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('https://prp-phone/GetMails', JSON.stringify({}), function(mails){
                        PRP.Phone.Functions.SetupMails(mails);
                    });
                    $.post('https://prp-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('https://prp-phone/LoadAdverts', JSON.stringify({}), function(Adverts){
                        PRP.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('https://prp-phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('https://prp-phone/GetCryptoData', JSON.stringify({
                        crypto: "qbit",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('https://prp-phone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "racing") {
                    $.post('https://prp-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('https://prp-phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('https://prp-phone/GetPlayerKeys', JSON.stringify({}), function(Keys){
                        $(".house-app-mykeys-container").html("");
                        if (Keys.length > 0) {
                            $.each(Keys, function(i, key){
                                var elem = '<div class="mykeys-key" id="keyid-'+i+'"><span class="mykeys-key-label">' + key.HouseData.adress + '</span> <span class="mykeys-key-sub">Click to set GPS</span> </div>';
                                $(".house-app-mykeys-container").append(elem);
                                $("#keyid-"+i).data('KeyData', key);
                            });
                        }
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "lawyers") {
                    $.post('https://prp-phone/GetCurrentLawyers', JSON.stringify({}), function(data){
                        SetupLawyers(data);
                    });
                } else if (PressedApplication == "store") {
                    $.post('https://prp-phone/SetupStoreApps', JSON.stringify({}), function(data){
                        SetupAppstore(data);
                    });
                } else if (PressedApplication == "trucker") {
                    $.post('https://prp-phone/GetTruckerData', JSON.stringify({}), function(data){
                        SetupTruckerInfo(data);
                    });
                }
                else if (PressedApplication == "gallery") {
                    $.post('https://prp-phone/GetGalleryData', JSON.stringify({}), function(data){
                        setUpGalleryData(data);
                    });
                }
                else if (PressedApplication == "camera") {
                    $.post('https://prp-phone/TakePhoto', JSON.stringify({}),function(url){
                        setUpCameraApp(url)
                    })
                    PRP.Phone.Functions.Close();
                }

                
            }
        }
    } else {
        if (PressedApplication != null){
            PRP.Phone.Notifications.Add("fas fa-exclamation-circle", "System", PRP.Phone.Data.Applications[PressedApplication].tooltipText+" is not available!")
        }
    }
});

$(document).on('click', '.mykeys-key', function(e){
    e.preventDefault();

    var KeyData = $(this).data('KeyData');

    $.post('https://prp-phone/SetHouseLocation', JSON.stringify({
        HouseData: KeyData
    }))
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (PRP.Phone.Data.currentApplication === null) {
        PRP.Phone.Functions.Close();
    } else {
        PRP.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        PRP.Phone.Animations.TopSlideUp('.'+PRP.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            PRP.Phone.Functions.ToggleApp(PRP.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
        }, 400)
        PRP.Phone.Functions.HeaderTextColor("white", 300);

        if (PRP.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (PRP.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});

                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');

                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');

                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (PRP.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"});
            }, 400)
        }

        PRP.Phone.Data.currentApplication = null;
    }
});

PRP.Phone.Functions.Open = function(data) {
    PRP.Phone.Animations.BottomSlideUp('.container', 300, 0);
    PRP.Phone.Notifications.LoadTweets(data.Tweets);
    PRP.Phone.Data.IsOpen = true;
}

PRP.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

PRP.Phone.Functions.Close = function() {

    if (PRP.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            PRP.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            PRP.Phone.Animations.TopSlideUp('.'+PRP.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            PRP.Phone.Functions.HeaderTextColor("white", 300);

            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            PRP.Phone.Data.currentApplication = null;
        }, 500)
    } else if (PRP.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"});
    }

    PRP.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('https://prp-phone/Close');
    PRP.Phone.Data.IsOpen = false;
}

PRP.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

PRP.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

PRP.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

PRP.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

PRP.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

PRP.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    $.post('https://prp-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (PRP.Phone.Notifications.Timeout == undefined || PRP.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!PRP.Phone.Data.IsOpen) {
                    PRP.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                PRP.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                if (icon !== "politie") {
                    $(".notification-icon").html('<i class="'+icon+'"></i>');
                } else {
                    $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
                }
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (PRP.Phone.Notifications.Timeout !== undefined || PRP.Phone.Notifications.Timeout !== null) {
                    clearTimeout(PRP.Phone.Notifications.Timeout);
                }
                PRP.Phone.Notifications.Timeout = setTimeout(function(){
                    PRP.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!PRP.Phone.Data.IsOpen) {
                        PRP.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    PRP.Phone.Notifications.Timeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!PRP.Phone.Data.IsOpen) {
                    PRP.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (PRP.Phone.Notifications.Timeout !== undefined || PRP.Phone.Notifications.Timeout !== null) {
                    clearTimeout(PRP.Phone.Notifications.Timeout);
                }
                PRP.Phone.Notifications.Timeout = setTimeout(function(){
                    PRP.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!PRP.Phone.Data.IsOpen) {
                        PRP.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    PRP.Phone.Notifications.Timeout = null;
                }, timeout);
            }
        }
    });
}

PRP.Phone.Functions.LoadPhoneData = function(data) {
    PRP.Phone.Data.PlayerData = data.PlayerData;
    PRP.Phone.Data.PlayerJob = data.PlayerJob;
    PRP.Phone.Data.MetaData = data.PhoneData.MetaData;
    PRP.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    PRP.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    PRP.Phone.Functions.SetupApplications(data);
}

PRP.Phone.Functions.UpdateTime = function(data) {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").html("<span>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
}

var NotificationTimeout = null;

PRP.Screen.Notification = function(title, content, icon, timeout, color) {
    $.post('https://prp-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (color != null && color != undefined) {
                $(".screen-notifications-container").css({"background-color":color});
            }
            $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
            $(".screen-notification-title").text(title);
            $(".screen-notification-content").text(content);
            $(".screen-notifications-container").css({'display':'block'}).animate({
                right: 5+"vh",
            }, 200);

            if (NotificationTimeout != null) {
                clearTimeout(NotificationTimeout);
            }

            NotificationTimeout = setTimeout(function(){
                $(".screen-notifications-container").animate({
                    right: -35+"vh",
                }, 200, function(){
                    $(".screen-notifications-container").css({'display':'none'});
                });
                NotificationTimeout = null;
            }, timeout);
        }
    });
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
        if (up){
            $('#popup').fadeOut('slow');
            $('.popupclass').fadeOut('slow');
            $('.popupclass').html("");
            up = false
        } else {
            PRP.Phone.Functions.Close();
            break;
        }
    }
});

PRP.Screen.popUp = function(source){
    if(!up){
        $('#popup').fadeIn('slow');
        $('.popupclass').fadeIn('slow');
        $('<img  src='+source+' style = "width:100%; height: 100%;">').appendTo('.popupclass')
        up = true
    }
}

PRP.Screen.popDown = function(){
    if(up){
        $('#popup').fadeOut('slow');
        $('.popupclass').fadeOut('slow');
        $('.popupclass').html("");
        up = false
    }
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                PRP.Phone.Functions.Open(event.data);
                PRP.Phone.Functions.SetupAppWarnings(event.data.AppData);
                PRP.Phone.Functions.SetupCurrentCall(event.data.CallData);
                PRP.Phone.Data.IsOpen = true;
                PRP.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            case "LoadPhoneData":
                PRP.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                PRP.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                PRP.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                PRP.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                PRP.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
            case "UpdateMentionedTweets":
                PRP.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&#36; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (PRP.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        PRP.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                        PRP.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                PRP.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                PRP.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('https://prp-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('https://prp-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                PRP.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                PRP.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);
                if (!PRP.Phone.Data.IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("In conversation ("+timeString+")");
                    $(".call-notifications-content").html("Calling with "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }
                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In conversation ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                PRP.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    PRP.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                PRP.Phone.Functions.HeaderTextColor("white", 300);

                PRP.Phone.Data.CallActive = false;
                PRP.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                PRP.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                PRP.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (PRP.Phone.Data.currentApplication == "advert") {
                    PRP.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "UpdateTweets":
                if (PRP.Phone.Data.currentApplication == "twitter") {
                    PRP.Phone.Notifications.LoadTweets(event.data.Tweets);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateApplications":
                PRP.Phone.Data.PlayerJob = event.data.JobData;
                PRP.Phone.Functions.SetupApplications(event.data);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('https://prp-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "RefreshAlerts":
                PRP.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
        }
    })
});