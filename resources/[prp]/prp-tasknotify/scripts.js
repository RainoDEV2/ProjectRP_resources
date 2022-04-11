$(document).ready(function(){

  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []

  // function closeModal(){
  //   $(".mask").removeClass("active");
  // }

  $("#confirmModal").on("click", function(){
    $(".confirm").css("display","none");
    $.post('http://prp-tasknotify/callback', JSON.stringify({Val:true}));
  });
  $("#cancelModal").on("click", function(){
    $(".confirm").css("display","none");
    $.post('http://prp-tasknotify/callback', JSON.stringify({Val:false}));
  });

  window.addEventListener('message', function(event){

    var item = event.data;
    if (item.runProgress === true) {

      var message = item.textsent
      var fadetimer = item.fadesent
      var element
      $('#colorsent' + item.colorsent).css('display', 'none');
      if (item.colorsent == 2) {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg red" style="display:none">' + message + '</div>');
      } else if (item.colorsent == 69) {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg taxi" style="display:none">' + message + '</div>');
      } else if (item.colorsent == 155) {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg medical" style="display:none">' + message + '</div>');
      } else {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg normal" style="display:none">' + message + '</div>');
      }

      $('.notify-wrap').prepend(element);
      $(element).fadeIn(500);
      setTimeout(function(){
         $(element).fadeOut(fadetimer-(fadetimer / 2));
      }, fadetimer / 2);

      setTimeout(function(){
        $(element).css('display', 'none');
      }, fadetimer);
    } 

    if (item.Toast === true) {
      var msg = item.text
      var time = item.time
      var sos = item.sos
      var title = item.title

      if (sos === true) {
        var element = $(`<div><div class='title'><span class="alert">10-13</span>Officer / Emergency Downed</div><div class='text'><i class="fas fa-location-arrow"></i> ${msg}</div></div>`)
        M.toast({html: element, classes: 'officer-down', displayLength: time})
      }
      else {
        if (title.length > 40) {
          var element = $(`<div><div class='smalltitle'><span class="alert">ALERT</span>${title}</div><div class='text'><i class="fas fa-location-arrow"></i> ${msg}</div></div>`)
        }
        else {
          var element = $(`<div><div class='title'><span class="alert">ALERT</span>${title}</div><div class='text'><i class="fas fa-location-arrow"></i> ${msg}</div></div>`)
        }
        M.toast({html: element, classes: 'police', displayLength: time})
      }
    }

    if (item.Notify === true)
    {
      var msg = item.text;
      var fadetimer = item.time;
      var newelement = "<h5 style='text-shadow: 0px 0px 10px #000;'>"+msg+"</h5>";
      $('#notifytext').html(newelement);
      $('#notifytext').fadeIn(500);

      setTimeout(function(){
        $('#notifytext').fadeOut(fadetimer-(fadetimer / 2));
      }, fadetimer / 2);

      setTimeout(function(){
        $('#notifytext').css('display', 'none');
      }, fadetimer);
    }

    if (item.Modal === true)

    {

        $(".confirm").css("display","block");



        var title = item.title;

        var msg = item.text;



        $("#modalTitle").html(title);

        $("#modalText").html(msg);

    }

    if (item.State === true)
    {
      var msg = item.text;
      var fadetimer = item.time;
      var newelement = "<h5 style='text-shadow: 0px 0px 10px #000;'>"+msg+"</h5>";
      $('#Statetext').html(newelement);
      $('#Statetext').fadeIn(500);

      setTimeout(function(){
        $('#Statetext').fadeOut(fadetimer-(fadetimer / 2));
      }, fadetimer / 2);

      setTimeout(function(){
        $('#Statetext').css('display', 'none');
      }, fadetimer);
    }

    if (item.Modal === true)

    {

        $(".confirm").css("display","block");



        var title = item.title;

        var msg = item.text;



        $("#modalTitle").html(title);

        $("#modalText").html(msg);

    }



    if (item.JobInfo === true)

    {

        $(".jobInformation").css("display","block");



        var title = item.title;

        var msg = item.text;



        $("#jobTitle").html(title);

        $("#jobDescription").html(msg);

    }


    if (item.Bag === true)

    {

      if (item.Display === true)

      {

        $(".bagOverlay").css("display","block");

      }

      else 

      {

        $(".bagOverlay").css("display","none");

      }

    }

    if (item.bugReport === true)

    {

        $(".bugReport").css("display","block");



        var scriptName = item.resource;

        var scriptError = item.error;



        $(".bugErrorBox").html(scriptError);

        $("#bugReportResource").html(scriptName);

        $("#jobDescription").html(msg);

    }
  });

});


$("#confirmButton").on("click", function(){

  $(".jobInformation").css("display","none");

  $.post('http://prp-tasknotify/closeJob', JSON.stringify({}));

});



$("#sendReport").on("click", function(){

  $(".bugReport").css("display","none");

  $.post('http://prp-tasknotify/closeReport', JSON.stringify({

    msg: true,

    msgData: $("#additionalBug").val(),

    msgError: $(".bugErrorBox").text(),

    resource: $("#bugReportResource").text()

  }));

});



$("#abortReport").on("click", function(){

  $(".bugReport").css("display","none");

  $.post('http://prp-tasknotify/closeReport', JSON.stringify({

    msg: false,

  }));

  

});