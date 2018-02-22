$(document).ready(function() {

    $('#search-btn').click(function() {
        submitSearch();
        $('#search-text').val('');
    });

    $('#search-text').on('keyup', function(e) {
        if (e.which === 13) {
            submitSearch();
            $('#search-text').val('');
        } else {
            submitSearch();
        }
    });

});


function submitSearch() {
    $.ajax({
        type: "GET",
        url: 'get.php',
        data: {
            title: $('#search-text').val()
        },
        success: function(data) {
          populateSongs(JSON.parse(data));
        }
    });
}

function populateSongs(songData) {
  $('#accordion').empty();
  for (i = 0; i < songData.length; i++) {
    $('#accordion').prepend('\
    <div class="panel panel-default">\
          <a data-toggle="collapse" data-parent="#accordion" href="#collapse-' + songData[i].id + '">\
            <div class="panel-heading text-left">\
              <h4 class="panel-title">' + songData[i].name +  '</h4>\
            </div>\
          </a>\
          <div id="collapse-'+ songData[i].id +'" class="panel-collapse collapse">\
            <div class="panel-body text-left">test</div>\
          </div>\
        </div>\
    ');
  }
}
