$(document).ready(function() {

  $('a#urlSubmit').click(function() {

    $('.loading').removeClass('hidden');

    $.post('/api/images', {url: $('input#url').val()})
    .done(function(data) {
      data = JSON.parse(data);
      $('#emptyImage img').attr('src', data.url);
      $('#emptyImage ul').html('');
      $.each(data.predictions, function(prediction) {
        $('#emptyImage ul').append(
          '<li><a href="#">' + this.name + '</a> - ' + (this.prob * 100).toFixed(1) + '%</li>'
        );
      });

      $('#imageList').prepend('<hr>');
      $('#imageList').prepend($('#emptyImage').clone().attr('id', '').removeClass('hidden'));
      $('.loading').addClass('hidden');

      $('input#url').val('');
    });

  });

  $('input#url').val('');
});
