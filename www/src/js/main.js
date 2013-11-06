(function(){
    "use strict";

    $(document).ready(function(){
//        $('#social').portamento({gap: 0});
        $("#gallery").gallery({
            width : "1024px",
            height : "768px",
            timeout : 5000,
            items: [
                '<div class="txt">Build your railway between cities</div><img src="/img/scr0.jpg"/>',
                '<div class="txt">Sent trains to corresponding cities using lightnings and switches</div><img src="/img/scr1.jpg"/>',
                '<div class="txt">Prevent train crashes and fix railway damages</div><img src="/img/scr2.jpg"/>'
            ]
        });
    });


})();

