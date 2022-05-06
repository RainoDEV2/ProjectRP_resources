const open = (data) => {
  $('#rank').text(data.rank);
  $('#name').text(data.name);
  // $('#signature').text(data.name);

  $('#id-card').css('background', 'url(assets/images/lspd.png)');

  $('#id-card').show();
}

const close = () => {
  $('#rank').text('');
  $('#name').text('');
  $('#height').text('');
  $('#signature').text('');
  $('#sex').text('');
  $('#id-card').hide();
  $('#licenses').html('');
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                open(event.data);
                break;
            case "close":
                close();
                break;
        }
    })
});
