function submitSearch(clearText = false) {
	$.ajax({
		type: "GET",
		url: 'get.php',
		data: {
			type: "song",
			title: $('#search-text').val()
		},
		success: function(data) {
			//console.log(JSON.parse(data));
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
			//console.log(JSON.parse(data))
			populateConcerts(JSON.parse(data));
		}
	});
}

function getConcertSongs(concertId) {
	$.ajax({
		type: "GET",
		url: 'get.php',
		data: {
			type: "concert_list",
			concert_id: concertId
		},
		success: function(data) {
			//console.log(JSON.parse(data));
			populateConcertSongs( JSON.parse(data), concertId );
		}
	});
}

function populateConcerts(concertData) {
	$('#concerts').empty();
	for (i = 0; i < concertData.length; i++) {
		$('#concerts').append('\
		<div class="jumbotron">\
			<h2>' + concertData[i].name + '</h2>\
				<p>\
				Paikka: ' + concertData[i].location + '<br />\
				Aika: ' + concertData[i].start_time + '&ndash;' + concertData[i].end_time + '\
				</p>\
				<div class="panel-group" id="accordion"></div>\
		</div>'
		);
		getConcertSongs( concertData[i].id );
	}
}

function populateConcertSongs(songData, concertId) {
	$('#accordion').empty();
	var j = 0;
	for (i = 0; i < songData.length; i++) {
		// song counter j
		if (songData[i][0].arrangement_id < 0) {
			$('#accordion').append('\
				<div class="panel special_text_'+Math.abs(songData[i][0].arrangement_id)+'">\
					<div class="panel-heading text-center special_text_'+Math.abs(songData[i][0].arrangement_id)+'">\
						<h4 class="panel-title">' + songData[i][0].line_text + '</h4>\
					</div>\
				</div>\
			');
		} else {
			j++;
			$('#accordion').append('\
				<div class="panel panel-default">\
					<div id="panelHeading-'+ songData[i][0].arrangement_id +'" class="panel-heading text-left jumbotron-panel-heading">\
						<a data-toggle="collapse" data-parent="#accordion" href="#collapse-' + songData[i][0].arrangement_id + '">\
							<h4 class="panel-title">' + j + '. ' + songData[i][0].name + '\
							<span class="panel-title-authors" id="panel-title-authors-' + songData[i][0].arrangement_id +'" style="display: none;"></span>\
							</h4></a>\
					</div>\
					<div id="collapse-'+ songData[i][0].arrangement_id +'" class="panel-collapse collapse">\
						<div class="panel-body text-left">\
							<p class="composer" style="display: none;">Säveltäjä: </p>\
							<p class="songwriter" style="display: none;">Lauluntekijä: </p>\
							<p class="lyricist" style="display: none;">Sanoittaja: </p>\
							<p class="arranger" style="display: none;">Sovittaja: </p>\
							<p class="starting_lyrics" style="display: none;">Alkusanat: </p>\
							<p class="orchestration" style="display: none;">Orkestraatio: </p>\
							<p class="description" style="display: none;">Lisätietoa: </p>\
							<p class="pdf" style="display: none;"></p>\
							<p class="sib" style="display: none;"></p>\
							<p class="mscz" style="display: none;"></p>\
							<p class="mp3" style="display: none;"></p>\
						</div>\
					</div>\
				</div>\
			');
			
			/// show arrangement description, if any
			if (songData[i][0].description) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.description').append(songData[i][0].description).show();
			}
			/// show starting lyrics, if any
			if (songData[i][0].starting_lyrics != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.starting_lyrics').append("<i>"+songData[i][0].starting_lyrics+"</i>").show();
			}
			/// show orchestration, if any
			if (songData[i][0].orchestration != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.orchestration').append(songData[i][0].orchestration).show();
			}
			
			var authors = [];
			var a = "";
			var b = "";
			var c = "";
			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "songwriter"));
			if (authors.length > 0) { 
				authors.sort(function(x,y) {return (x.author_order - y.author_order);});
				var a = "";
				authors.forEach( function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				} );
				
				/// remove the ", " at the end of the string AND remove all family name markers '*' from the shown strings (hence '/<string>/g' format
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.songwriter').append(a).show();
				
				/// create a family name string for the panel-title to come after the song name
				var b = ""; 
				authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
				/// remove the last m-dash and add the author names to panel header h5-tag
				c = "säv. ja san. " + b.substring(0,b.length - 7);
			}
			
			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "composer"));
			if (authors.length > 0) { 
				authors.sort(function(a,b) {return (a.author_order - b.author_order);});
				var a = "";
				authors.forEach( function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				} );
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.composer').append(a).show();
				
				/// create a family name string for the panel-title to come after the song name
				var b = ""; 
				authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
				
				/// append author string, and remove the last  m-dash, and add the closing parenthesis 
				if (c) {
					c = c + ", säv. " + b.substring(0,b.length - 7);
				} else {
					c = "säv. " + b.substring(0,b.length - 7);
				}
			}
			
			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "lyricist"));
			if (authors.length > 0) { 
				authors.sort(function(a,b) {return (a.author_order - b.author_order);});
				var a = "";
				authors.forEach( function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				} );
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.lyricist').append(a).show();
				
				/// create a family name string for the panel-title to come after the song name
				var b = ""; 
				authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
				/// append author string, and remove the last  m-dash, and add the closing parenthesis 
				if (c) {
					c = c + ", san. " + b.substring(0,b.length - 7);
				} else {
					c = "san. " + b.substring(0,b.length - 7);
				}
			}
			
			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "estonian translation"));
			if (authors.length > 0) { 
				authors.sort(function(a,b) {return (a.author_order - b.author_order);});
				var a = "";
				authors.forEach( function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				} );
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.lyricist').append(", eest. " + a).show();
			}
			
			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "adapted"));
			if (authors.length > 0) { 
				authors.sort(function(a,b) {return (a.author_order - b.author_order);});
				var a = "";
				authors.forEach( function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				} );
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.lyricist').append(", muok. " + a).show();
			}

			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "arranger"));
			if (authors.length > 0) { 
				authors.sort(function(a,b) {return (a.author_order - b.author_order);});
				var a = "";
				authors.forEach(function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				} );
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.arranger').append(a).show();
				var b = ""; 
				authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
				/// append author string, and remove the last  m-dash, and add the closing parenthesis 
				if (c) {
					c = c + ", sov. " + b.substring(0,b.length - 7);
				} else {
					c = "sov. " + b.substring(0,b.length - 7);
				}
			}
			authors = songData[i].filter(arrangement => (arrangement.contribution_type === "version"));
			if (authors.length > 0) { 
				authors.sort( function(a,b) {return (a.author_order - b.author_order);} );
				var a = "";
				authors.forEach( function(obj) {
					if(obj.birth_year === null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a>, ";
					} else if (obj.birth_year === null  && obj.death_year !== null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
					} else if (obj.birth_year !== null && obj.death_year === null) {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
					} else {
						return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
					}
				});
				a = a.substring(0,a.length - 2).replace(/\*/g,'');
				$('#collapse-'+ songData[i][0].arrangement_id +' p.arranger').append("vers. " + a).show();
				var b = ""; 
				authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
				/// append author string, and remove the last  m-dash, and add the closing parenthesis 
				if (c) {
					c = c + ", vers. " + b.substring(0,b.length - 7);
				} else {
					c = "vers. " + b.substring(0,b.length - 7);
				}
			}
			
			var file = [];
			file = songData[i].filter(arrangement => (arrangement.file_extension === "pdf"));
			if (file.length > 0) { 
				file.forEach( function(obj) {
					if(obj.description == null && obj.version != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf <span class=\"file_description\">ver. ' + obj.version + '</span></a><br />').show();
					} else if (obj.description != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf <span class=\"file_description\">' + obj.description + '</span></a><br />').show();		  
					} else {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf</a><br />').show();		  
					}
				} );
			}
			
			file = songData[i].filter(arrangement => (arrangement.file_extension === "sib"));
			if (file.length > 0) { 
				file.forEach( function(obj) {
					if(obj.description == null && obj.version != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
					} else if (obj.description != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
					} else {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch</a>').show();		  
					}
				} );
			}
			
			file = songData[i].filter(arrangement => (arrangement.file_extension === "mscz"));
			if (file.length > 0) { 
				file.forEach( function(obj) {
					if(obj.description == null && obj.version != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
					} else if (obj.description != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
					} else {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore</a>').show();		  
					}
				} );
			}
			
			file = songData[i].filter(arrangement => (arrangement.file_extension === "mp3"));
			if (file.length > 0) { 
				file.forEach( function(obj) {
					if(obj.description == null && obj.version != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3 <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
					} else if (obj.description != null) {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3 <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
					} else {
						$('#collapse-'+ songData[i][0].arrangement_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3</a>').show();		  
					}
				} );
			}
			$('#panel-title-authors-'+ songData[i][0].arrangement_id).append(c).show();
		}
	}
}

function populateSongs(songData) {
  $('#accordion').empty();
  for (i = 0; i < songData.length; i++) {
    $('#accordion').append('\
    <div class="panel panel-default">\
      <a data-toggle="collapse" data-parent="#accordion" href="#collapse-' + songData[i][0].arrangement_id + '">\
        <div id="panelHeading-'+ songData[i][0].arrangement_id +'" class="panel-heading text-left">\
          <h4 class="panel-title">' + songData[i][0].name +  '</h4>\
          <h5 class="panel-title" style="display: none;"></h5>\
        </div>\
      </a>\
      <div id="collapse-'+ songData[i][0].arrangement_id +'" class="panel-collapse collapse">\
        <div class="panel-body text-left">\
          <p class="composer" style="display: none;">Säveltäjä: </p>\
          <p class="songwriter" style="display: none;">Lauluntekijä: </p>\
          <p class="lyricist" style="display: none;">Sanoittaja: </p>\
          <p class="arranger" style="display: none;">Sovittaja: </p>\
          <p class="starting_lyrics" style="display: none;">Alkusanat: </p>\
          <p class="orchestration" style="display: none;">Orkestraatio: </p>\
          <p class="description" style="display: none;">Lisätietoa: </p>\
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
		$("#collapse-"+ songData[i][0].arrangement_id).addClass("in");
	}
	
	/// show arrangement description, if any
	if (songData[i][0].description != "") {
		$('#collapse-'+ songData[i][0].arrangement_id +' p.description').append(songData[i][0].description).show();
	}
	/// show starting lyrics, if any
	if (songData[i][0].starting_lyrics != null) {
		$('#collapse-'+ songData[i][0].arrangement_id +' p.starting_lyrics').append("<i>"+songData[i][0].starting_lyrics+"</i>").show();
	}
	/// show orchestration, if any
	if (songData[i][0].orchestration != null) {
		$('#collapse-'+ songData[i][0].arrangement_id +' p.orchestration').append(songData[i][0].orchestration).show();
	}
	
	var authors = [];
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "songwriter"));
	if (authors.length > 0) { 
		authors.sort(function(x,y) {return (x.author_order - y.author_order);});

		var a = "";
		authors.forEach(function(obj) {
			if(obj.birth_year === null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (obj.birth_year === null  && obj.death_year !== null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
			} else if (obj.birth_year !== null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
			}
		});
		
		/// remove the ", " at the end of the string AND remove all family name markers '*' from the shown strings (hence '/<string>/g' format
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arrangement_id +' p.songwriter').append(a).show();
		
		/// create a family name string for the panel-title to come after the song name
		var b = ""; 
		authors.forEach( function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";} );
		/// remove the last m-dash and add the author names to panel header h5-tag
		b = b.substring(0,b.length - 7);
		$('#panelHeading-'+ songData[i][0].arrangement_id +' h5.panel-title').append(b).show();
	}

	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "composer"));
	if (authors.length > 0) { 
		authors.sort( function(a,b) {return (a.author_order - b.author_order);} );

		var a = "";
		authors.forEach( function(obj) {
			if(obj.birth_year === null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (obj.birth_year === null  && obj.death_year !== null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
			} else if (obj.birth_year !== null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arrangement_id +' p.composer').append(a).show();

		/// create a family name string for the panel-title to come after the song name
		var b = ""; 
		authors.forEach(function(obj) {return b += obj.name.substr(obj.name.indexOf("*")+1) + "&mdash;";});
		/// remove the last  m-dash, and add the closing parenthesis 
		b = b.substring(0,b.length - 7);
		$('#panelHeading-'+ songData[i][0].arrangement_id +' h5.panel-title').append(b).show();
	}

	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "lyricist"));
	if (authors.length > 0) {
		authors.sort( function(a,b) {return (a.author_order - b.author_order);} );
		var a = "";
		authors.forEach( function(obj) {
			if(obj.birth_year === null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (obj.birth_year === null  && obj.death_year !== null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
			} else if (obj.birth_year !== null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arrangement_id +' p.lyricist').append(a).show();
	}
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "arranger"));
	if (authors.length > 0) { 
		authors.sort( function(a,b) {return (a.author_order - b.author_order);} );
		var a = "";
		authors.forEach( function(obj) {
			if(obj.birth_year === null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (obj.birth_year === null  && obj.death_year !== null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
			} else if (obj.birth_year !== null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arrangement_id +' p.arranger').append(a).show();
	}
	
	authors = songData[i].filter(arrangement => (arrangement.contribution_type === "version"));
	if (authors.length > 0) { 
		authors.sort( function(a,b) {return (a.author_order - b.author_order);} );
		console.log(authors);
		var a = "";
		authors.forEach( function(obj) {
			if(obj.birth_year === null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a>, ";
			} else if (obj.birth_year === null  && obj.death_year !== null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(\?&ndash;" + obj.death_year + ")</span>, ";
			} else if (obj.birth_year !== null && obj.death_year === null) {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;)</span>, ";
			} else {
				return a += "<a href=\#>"+obj.name + "</a> <span class=\"year_range\">(" + obj.birth_year + "&ndash;" + obj.death_year + ")</span>, ";
			}
		});
		a = a.substring(0,a.length - 2).replace(/\*/g,'');
		$('#collapse-'+ songData[i][0].arrangement_id +' p.arranger').append("vers. " + a).show();
	}
	
	var file = [];
	
	file = songData[i].filter(arrangement => (arrangement.file_extension === "pdf"));
	if (file.length > 0) { 
		file.forEach( function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf <span class=\"file_description\">ver. ' + obj.version + '</span></a><br />').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf <span class=\"file_description\">' + obj.description + '</span></a><br />').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.pdf').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> pdf</a><br />').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "sib"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.sib').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> scorch</a>').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "mscz"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.mscz').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> musescore</a>').show();		  
			}
		});
	}

	file = songData[i].filter(arrangement => (arrangement.file_extension === "mp3"));
	if (file.length > 0) { 
		file.forEach(function(obj) {
			if(obj.description == null && obj.version != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3 <span class=\"file_description\">ver. ' + obj.version + '</span></a>').show();
			} else if (obj.description != null) {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3 <span class=\"file_description\">' + obj.description + '</span></a>').show();		  
			} else {
				$('#collapse-'+ songData[i][0].arrangement_id +' p.mp3').append('<a href="download.php?id=' + obj.file_id + '"><span class="glyphicon glyphicon-download-alt"></span> mp3</a>').show();		  
			}
		});
	}
  }
}