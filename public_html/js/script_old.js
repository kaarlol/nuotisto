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
///          console.log(JSON.parse(data));
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
        <div id="panelHeading-'+ songData[i][0].arr_id +'" class="panel-heading text-left">\
          <h4 class="panel-title">' + songData[i][0].name +  '</h4>\
          <h5 class="panel-title" style="display: none;"></h5>\
        </div>\
      </a>\
      <div id="collapse-'+ songData[i][0].arr_id +'" class="panel-collapse collapse">\
        <div class="panel-body text-left">\
          <p class="composer" style="display: none;">Säveltäjä: </p>\
          <p class="songwriter" style="display: none;">Lauluntekijä: </p>\
          <p class="lyricist" style="display: none;">Sanoittaja: </p>\
          <p class="arranger" style="display: none;">Sovittaja: </p>\
          <p class="pdf" style="display: none;"></p>\
          <p class="sib" style="display: none;"></p>\
          <p class="mscz" style="display: none;"></p>\
        </div>\
      </div>\
    </div>\
    ');

	var authors = [];
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "songwriter"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});
		var a = "";
		authors.forEach(function(obj) {return a += "<a href=\#>"+obj.name + "</a>, ";});
		/// remove the ", " at the end of the string AND remove all family name markers '¤' from the shown strings (hence '/<string>/g' format
		a = a.substring(0,a.length - 2).replace(/¤/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.songwriter').append(a).show();
		
		/// create a family name string for the panel-title to come after the song name
		var b = ""; 
		authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("¤")+1) + "&mdash;";});
		/// remove the last  m-dash, and add the closing parenthesis 
		b = b.substring(0,b.length - 7);
		$('#panelHeading-'+ songData[i][0].arr_id +' h5.panel-title').append(b).show();
		/// $('a.collapsed > h5.panel-title').show();
		/// $(".accordion-toggle.collapsed").css({"display" : "none"});
	}

	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "composer"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});
		var a = "";
		authors.forEach(function(obj) {return a += "<a href=\#>"+obj.name + "</a>, ";});
		a = a.substring(0,a.length - 2).replace(/¤/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.composer').append(a).show();

		/// create a family name string for the panel-title to come after the song name
		var b = ""; 
		authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("¤")+1) + "&mdash;";});
		/// remove the last  m-dash, and add the closing parenthesis 
		b = b.substring(0,b.length - 7);
		$('#panelHeading-'+ songData[i][0].arr_id +' h5.panel-title').append(b).show();
	}

	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "lyricist"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});
		var a = "";
		authors.forEach(function(obj) {return a += "<a href=\#>"+obj.name + "</a>, ";});
		a = a.substring(0,a.length - 2).replace(/¤/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.lyricist').append(a).show();
	}
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "arranger"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});
		var a = "";
		authors.forEach(function(obj) {return a += "<a href=\#>"+obj.name + "</a>, ";});
		a = a.substring(0,a.length - 2).replace(/¤/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.arranger').append(a).show();
	}

	var file = [];
	
	file = songData[i].filter(arrangement => (arrangement.file_extension === "pdf"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="/download.php?id=' + obj.file_id + '">Lataa PDF (ver. ' + obj.version + ')</a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="/download.php?id=' + obj.file_id + '">Lataa PDF (' + obj.description + ')</a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="/download.php?id=' + obj.file_id + '">Lataa PDF</a>').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "sib"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="/download.php?id=' + obj.file_id + '">Lataa Scorch (ver. ' + obj.version + ')</a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="/download.php?id=' + obj.file_id + '">Lataa Scorch (' + obj.description + ')</a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="/download.php?id=' + obj.file_id + '">Lataa Scorch</a>').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "mscz"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="/download.php?id=' + obj.file_id + '">Lataa Musescore (ver. ' + obj.version + ')</a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="/download.php?id=' + obj.file_id + '">Lataa Musescore (' + obj.description + ')</a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="/download.php?id=' + obj.file_id + '">Lataa Musescore</a>').show();		  
			}
		});
	}

  }
}
