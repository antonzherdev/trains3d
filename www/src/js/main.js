(function(){
    "use strict";

    $(document).ready(function(){
//        $('#social').portamento({gap: 0});
        $("#gallery").gallery({
            width : "860px",
            height : "645px",
            timeout : 5000,
            arrows : 0,
            animation : 2,
            items: [
                '<div class="txt">Build your railway between cities</div><img src="/img/scr0.jpg?2" alt="Build your railway between cities"/>',
                '<div class="txt">Send trains to corresponding cities using lightnings and switches</div><img src="/img/scr1.jpg?2" alt="Send trains to corresponding cities using lightnings and switches"/>',
                '<div class="txt">Prevent train crashes and fix railway damages</div><img src="/img/scr2.jpg?2" alt="Prevent train crashes and fix railway damages"/>',
                '<div class="txt">Beware of very fast express trains</div><img src="/img/scr4.jpg?2" alt="Express trains are extremely fast"/>',
                '<div class="txt">Different locations</div><img src="/img/scr5.jpg?2" alt="Different locations"/>',
                '<div class="txt">Different weather</div><img src="/img/scr3.jpg?2" alt="Different weather"/>'
            ]
        });
    });


})();

