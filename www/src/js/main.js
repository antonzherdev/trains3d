(function(){
    "use strict";

    $(document).ready(function(){
        loadHash(location.hash);
        $(window).bind('hashchange', function () {
            loadHash(location.hash);
        });
    });

    function loadHash(hash) {
        if(hash === "") {
            hash = "#main";
        }

        if($(hash).length === 0) {
            $('#content-container').append('<div id = "' + hash.substr(1) + '"></div>');
            $(hash).hide();
            $.ajax({
                url : "/pages/" + hash.substr(1) + ".html",
                success : function(data) {
                    $('#content-container').children().hide();
                    $(hash).html(data).show();
                }
            });
        } else {
            $('#content-container').children().hide();
            $(hash).show();
        }
        //$('#content-container').add('div').html(hash)
    }
})();

