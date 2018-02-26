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
	var firstComposer 	= true, 
		firstSongwriter = true,
		firstLyricist 	= true,
		firstArranger 	= true;
	
    for (var x = 0; x < songData[i].length; x++) {
      if (songData[i][x].contribution_type == "composer") {
		if(firstComposer) {
          $('#collapse-'+ songData[i][0].arr_id +' p.composer').append(' ' + songData[i][x].name).show();
		  firstComposer = false;	
		} else {
          $('#collapse-'+ songData[i][0].arr_id +' p.composer').append(', ' + songData[i][x].name).show();
    	} 		
      }
      if (songData[i][x].contribution_type == "songwriter") {
		if(firstSongwriter) {
          $('#collapse-'+ songData[i][0].arr_id +' p.songwriter').append(' ' + songData[i][x].name).show();
		  firstSongwriter = false;	
		} else {
          $('#collapse-'+ songData[i][0].arr_id +' p.songwriter').append(', ' + songData[i][x].name).show();
    	} 		
      }
      if (songData[i][x].contribution_type == "lyricist") {
		if(firstLyricist) {
		  $('#collapse-'+ songData[i][0].arr_id +' p.lyricist').append(' ' + songData[i][x].name).show();
		  firstLyricist = false;
		} else {
		  $('#collapse-'+ songData[i][0].arr_id +' p.lyricist').append(', ' + songData[i][x].name).show();
		}
	  }
      if (songData[i][x].contribution_type == "arranger") {
		if(firstArranger) {
		  $('#collapse-'+ songData[i][0].arr_id +' p.arranger').append(' ' + songData[i][x].name).show();
		  firstArranger = false;
		} else {
		  $('#collapse-'+ songData[i][0].arr_id +' p.arranger').append(', ' + songData[i][x].name).show();
		}
      }
      if (songData[i][x].file_extension == "pdf") {
		if(songData[i][x].description == null && songData[i][x].version != null) {
          $('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="/download.php?id=' + songData[i][x].file_id + '">Lataa PDF (ver. ' + songData[i][x].version + ')</a>').show();		  
		} else {
          $('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="/download.php?id=' + songData[i][x].file_id + '">Lataa PDF (' + songData[i][x].description + ')</a>').show();		  
		}
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
