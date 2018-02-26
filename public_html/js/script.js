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
          console.log(JSON.parse(data));
          populateSongs(JSON.parse(data));
        }
    });
}

function parseSongData(data) {
  songData = [];

  for (var i = 0; i < data.length; i++) {
    songData.push( {
      "arr_id": data[i][0].arr_id,
      "name": data[i][0].name,
      "contributors": [],
      "files": []
    });
    for (var x = 0; x < data[i].length; x++) {
      if (data[i][x].contribution_type) {

        if (data[i][x].contribution_type == "composer") {
          songData[i].contributors.push( {
            "contribution_type": "composer",
            "name": data[i][x].name,
            "person_id": data[i][x].person_id
          })
        }

        if (data[i][x].contribution_type == "songwriter") {
          songData[i].contributors.push( {
            "contribution_type": "songwriter",
            "name": data[i][x].name,
            "person_id": data[i][x].person_id
          })
        }



      }
    }
  }
}

function populateSongs(songData) {
  $('#accordion').empty();
  for (i = 0; i < songData.length; i++) {
    $('#accordion').append('\
    <div class="panel panel-default">\
      <a data-toggle="collapse" data-parent="#accordion" href="#collapse-' + songData[i][0].arr_id + '">\
        <div class="panel-heading text-left">\
          <h4 class="panel-title">' + songData[i][0].name +  '</h4>\
        </div>\
      </a>\
      <div id="collapse-'+ songData[i][0].arr_id +'" class="panel-collapse collapse">\
        <div class="panel-body text-left">\
          <p class="composer" style="display: none;">Säveltäjä:</p>\
          <p class="songwriter" style="display: none;">Lauluntekijä:</p>\
          <p class="lyricist" style="display: none;">Sanoittaja:</p>\
          <p class="arranger" style="display: none;">Sovittaja:</p>\
          <p class="pdf" style="display: none;"></p>\
          <p class="sib" style="display: none;"></p>\
          <p class="mscz" style="display: none;"></p>\
        </div>\
      </div>\
    </div>\
    ');
    for (var x = 0; x < songData[i].length; x++) {
      if (songData[i][x].contribution_type == "composer") {
        $('#collapse-'+ songData[i][0].arr_id +' p.composer').append(' ' + songData[i][x].name).show();
      }
      if (songData[i][x].contribution_type == "songwriter") {
        $('#collapse-'+ songData[i][0].arr_id +' p.songwriter').append(' ' + songData[i][x].name).show();
      }
      if (songData[i][x].contribution_type == "lyricist") {
        $('#collapse-'+ songData[i][0].arr_id +' p.lyricist').append(' ' + songData[i][x].name).show();
      }
      if (songData[i][x].contribution_type == "arranger") {
        $('#collapse-'+ songData[i][0].arr_id +' p.arranger').append(' ' + songData[i][x].name).show();
      }
      if (songData[i][x].file_extension == "pdf") {
        $('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="/download.php?id=' + songData[i][x].file_id + '">Lataa PDF (' + songData[i][x].description + ')</a>').show();
      }
      if (songData[i][x].file_extension == "sib") {
        $('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="/download.php?id=' + songData[i][x].file_id + '">Lataa Scorch</a>').show();
      }
      if (songData[i][x].file_extension == "mscz") {
        $('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="/download.php?id=' + songData[i][x].file_id + '">Lataa Musescore</a>').show();
      }
    }
  }
}
