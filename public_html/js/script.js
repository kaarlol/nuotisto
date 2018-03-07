function submitSearch(clearText = false) {
    $.ajax({
        type: "GET",
        url: 'get.php',
        data: {
			type: "song",
            title: $('#search-text').val()
        },
        success: function(data) {
			populateSongs(JSON.parse(data));
			if(clearText) {
				$('#search-text').val('');
			}
        }
    });
}

function getConcerts() {
	$.ajax({
        type: "GET",
        url: 'get.php',
        data: {
			type: "concert"
        },
        success: function(data) {
			console.log(JSON.parse(data))
			populateConcerts(JSON.parse(data));
        }
    });
}

function populateConcerts(concertData) {
	$('#concerts').empty();
	for (i = 0; i < concertData.length; i++) {
		$('#concerts').append('\
		<div class="jumbotron" data-id="' + concertData[i].id + '">\
			<h2>' + concertData[i].name + '</h2>\
				<p>\
				Paikka: ' + concertData[i].location + '<br />\
				' + concertData[i].start_time + ' - ' + concertData[i].end_time + '\
				</p>\
		</div>'
		);
	}
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
          <p class="starting_lyrics" style="display: none;">Alkusanat: </p>\
          <p class="orchestration" style="display: none;">Orkestraatio: </p>\
          <p class="description" style="display: none;">Sovitus: </p>\
          <p class="pdf" style="display: none;"></p>\
          <p class="sib" style="display: none;"></p>\
          <p class="mscz" style="display: none;"></p>\
          <p class="mp3" style="display: none;"></p>\
        </div>\
      </div>\
    </div>\
    ');

	/// If only one song is fetched, auto-open the single panel by adding class "in"
	if (songData.length == 1) {
		$("#collapse-"+ songData[i][0].arr_id).addClass("in");
	}
	
	/// show arrangement description, if any
	if (songData[i][0].description != "") {
		$('#collapse-'+ songData[i][0].arr_id +' p.description').append(songData[i][0].description).show();
	}
	/// show starting lyrics, if any
	if (songData[i][0].starting_lyrics != null) {
		$('#collapse-'+ songData[i][0].arr_id +' p.starting_lyrics').append("<i>"+songData[i][0].starting_lyrics+"</i>").show();
	}
	/// show orchestration, if any
	if (songData[i][0].orchestration != null) {
		$('#collapse-'+ songData[i][0].arr_id +' p.orchestration').append(songData[i][0].orchestration).show();
	}
	
	var authors = [];
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "songwriter"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});

		var a = "";
		authors.forEach(function(obj) {
			
			// deal with dates -- invalid dates e.g. '0000-00-00' or '2018-14-14' also create NaN values
			if (obj.birth_date != null) {
				birthDate = new Date(obj.birth_date);
			} else birthDate = NaN;
			if (obj.death_date != null) {
				deathDate = new Date(obj.death_date);
			} else deathDate = NaN;

			if(isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (isNaN(birthDate) && !isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + deathDate.getFullYear() + ")</span>, ";
			} else if (!isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;" + deathDate.getFullYear() + ")</span>, ";
			}
		});
		
		/// remove the ", " at the end of the string AND remove all family name markers '*' from the shown strings (hence '/<string>/g' format
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.songwriter').append(a).show();
		
		/// create a family name string for the panel-title to come after the song name
		var b = ""; 
		authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
		/// remove the last m-dash and add the author names to panel header h5-tag
		b = b.substring(0,b.length - 7);
		$('#panelHeading-'+ songData[i][0].arr_id +' h5.panel-title').append(b).show();
	}

	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "composer"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});

		var a = "";
		authors.forEach(function(obj) {
			
			// deal with dates -- invalid dates e.g. '0000-00-00' or '2018-14-14' also create NaN values
			if (obj.birth_date != null) {
				birthDate = new Date(obj.birth_date);
			} else birthDate = NaN;
			if (obj.death_date != null) {
				deathDate = new Date(obj.death_date);
			} else deathDate = NaN;

			if(isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (isNaN(birthDate) && !isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + deathDate.getFullYear() + ")</span>, ";
			} else if (!isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;" + deathDate.getFullYear() + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.composer').append(a).show();

		/// create a family name string for the panel-title to come after the song name
		var b = ""; 
		authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
		/// remove the last  m-dash, and add the closing parenthesis 
		b = b.substring(0,b.length - 7);
		$('#panelHeading-'+ songData[i][0].arr_id +' h5.panel-title').append(b).show();
	}

	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "lyricist"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});
		var a = "";
		authors.forEach(function(obj) {
			
			// deal with dates -- invalid dates e.g. '0000-00-00' or '2018-14-14' also create NaN values
			if (obj.birth_date != null) {
				birthDate = new Date(obj.birth_date);
			} else birthDate = NaN;
			if (obj.death_date != null) {
				deathDate = new Date(obj.death_date);
			} else deathDate = NaN;

			if(isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (isNaN(birthDate) && !isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + deathDate.getFullYear() + ")</span>, ";
			} else if (!isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;" + deathDate.getFullYear() + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.lyricist').append(a).show();
	}
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "arranger"));
	if (authors.length > 0) { 
		authors.sort(function(a,b) {return (a.author_order - b.author_order);});
		var a = "";
		authors.forEach(function(obj) {
			
			// deal with dates -- invalid dates e.g. '0000-00-00' or '2018-14-14' also create NaN values
			if (obj.birth_date != null) {
				birthDate = new Date(obj.birth_date);
			} else birthDate = NaN;
			if (obj.death_date != null) {
				deathDate = new Date(obj.death_date);
			} else deathDate = NaN;

			if(isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (isNaN(birthDate) && !isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + deathDate.getFullYear() + ")</span>, ";
			} else if (!isNaN(birthDate) && isNaN(deathDate)) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + birthDate.getFullYear() + "&ndash;" + deathDate.getFullYear() + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arr_id +' p.arranger').append(a).show();
	}

	var file = [];
	
	file = songData[i].filter(arrangement => (arrangement.file_extension === "pdf"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf <span class=\"file_description\">ver. ' + obj.version + '</span></a><br />').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf <span class=\"file_description\">' + obj.description + '</span></a><br />').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf</a><br />').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "sib"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch</a>').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "mscz"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore</a>').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "mp3"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3 <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arr_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3 <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arr_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3</a>').show();		  
			}
		});
	}
  }
}