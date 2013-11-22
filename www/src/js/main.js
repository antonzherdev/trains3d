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
                '<div class="txt">Build your railway between cities</div><img src="/img/scr0.jpg" alt="Build your railway between cities"/>',
                '<div class="txt">Send trains to corresponding cities using lightnings and switches</div><img src="/img/scr1.jpg?1" alt="Send trains to corresponding cities using lightnings and switches"/>',
                '<div class="txt">Prevent train crashes and fix railway damages</div><img src="/img/scr2.jpg" alt="Prevent train crashes and fix railway damages"/>',
                '<div class="txt">Different locations and weather</div><img src="/img/scr3.jpg" alt="Different locations and weather"/>',
                '<div class="txt">Express trains are extremely fast</div><img src="/img/scr4.jpg" alt="Express trains are extremely fast"/>',
                '<div class="txt">Use special interface for limited iPhone screen</div>' +
                    '<div class="iptxt" id="ip0">Zoom using pinch gesture</div>' +
                    '<img class="ipimg" id="ipi0" src="/img/iPhone0.jpg" alt="Zoom using pinch gesture"/>' +
                    '<div class="iptxt" id="ip1">Build railway using one finger</div>' +
                    '<img class="ipimg" id="ipi1" src="/img/iPhone1.jpg" alt="Build railway using one finger"/>' +
                    '<div class="iptxt" id="ip3">Scroll using two fingers</div>' +
                    '<img class="ipimg" id="ipi2" src="/img/iPhone2.jpg" alt="Scroll using two fingers"/>' +
                    '<img class="ipimg" id="ipi3" src="/img/iPhone3.jpg" alt="Scroll using two fingers"/>'
            ]
        });
    });


})();

