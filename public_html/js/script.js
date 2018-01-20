$(document).ready(function() {

    submitSearch();

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
          $('#accordion').html(data);
        }
    });
}
