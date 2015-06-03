$(document).ready(function() {

  $('a#urlSubmit').click(function() {

    $('.loading').removeClass('hidden');

    $.post('/api/images', {url: $('input#url').val()})
    .done(function(data) {
      data = JSON.parse(data);
      $('#emptyImage img').attr('src', data.url);
      $('#emptyImage ul').html('');
      $.each(data.predictions, function(prediction) {
        var percent = parseInt(this.prob * 100);

        var style = 'success';

        if(percent < 60) {
          style='warning';
        }

        if(percent < 25) {
          style = 'danger';
        }

        var predictionHtml = '<div class="row"><div class="col-lg-4"><div class="progress">';
        predictionHtml += '<div class="progress-bar progress-bar-' + style + '" role="progressbar" ';
        predictionHtml += 'aria-valuenow="' + percent + '" aria-valuemin="0" aria-valuemax="100" ';
        predictionHtml += 'style="width: ' + percent + '%;">' + percent + '%</div></div></div>';
        predictionHtml += '<div class="col-lg-8"><a href="#">' + this.name + '</a></div></div>';
        $('#emptyImage .predictions').append(predictionHtml);
      });

      $('#imageList').prepend('<hr>');
      $('#imageList').prepend($('#emptyImage').clone().attr('id', '').removeClass('hidden'));
      $('.loading').addClass('hidden');

      $('input#url').val('');
    });

  });

  $('input#url').val('');
});
