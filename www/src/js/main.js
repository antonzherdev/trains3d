(function(){
    "use strict";

    $(document).ready(function(){
//        $('#social').portamento({gap: 0});
        $("#gallery").gallery({
            width : "860px",
            height : "645px",
            timeout : 10000,
            arrows : 0,
            animation : 2,
            items: [
                '<div class="txt">Build your railway between cities</div><img src="/img/scr0.jpg"/>',
                '<div class="txt">Send trains to corresponding cities using lightnings and switches</div><img src="/img/scr1.jpg"/>',
                '<div class="txt">Prevent train crashes and fix railway damages</div><img src="/img/scr2.jpg"/>'
            ]
        });
    });


})();
