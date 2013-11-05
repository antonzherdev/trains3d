(function(){
    "use strict";
    $.fn.gallery = function(options) {
        if(!this.length) return this;

        return this.each(function() {
            createGallery(this, options);
        });
    };

    function createGallery(elem, options) {
        var div = $('<table class="b-gallery"></table>');
        $(elem).append(div);

        var top = $('<tr></tr>');
        div.append(top);
        var points = $('<td colspan="3" class="points"></td>');
        div.append($('<tr></tr>').append(points));

        var left = $('<div class="left-arrow"></div>');
        top.append($('<td></td>').append(left));
        var content = $('<div class="content"></div>');
        top.append($('<td></td>').append(content));
        var right = $('<div class="right-arrow"></div>');
        top.append($('<td></td>').append(right));

        content.css("width", options.width);
        content.css("height", options.height);
        options.items.forEach(function(item) {
            var i = $('<div class="item"></div>');
            content.append(i);
            i.css("width", options.width);
            i.css("height", options.height);
            i.hide();
            i.html(item);

            var point = $('<div class="point"><div class="inner"></div></div>');
            points.append(point);
            var n = content.children().length - 1;
            point.bind("click", function() {
                d.timerRunning = false;
                setCurrentItem(d, n);
            });
        });

        content.children(":first").show();
        var d = {
            currentItem: 0,
            itemsCount: options.items.length,
            content: content,
            points: points,
            timerRunning : true,
            width : options.width,
            animate : false,
            timeout: options.timeout === undefined ? 10000 : options.timeout
        };
        $(div).data("gallery", d);
        points.children().first().addClass("current");

        setTimeout(function() {galleryTimer(d);}, d.timeout);

        left.bind('click', function () {
            d.timerRunning = false;
            setCurrentItem(d, d.currentItem - 1);
        });
        right.bind('click', function () {
            d.timerRunning = false;
            setCurrentItem(d, d.currentItem + 1);
        });
    }

    function galleryTimer(d) {
        if(!d.timerRunning) return;

        setCurrentItem(d, d.currentItem + 1);
        setTimeout(function() {galleryTimer(d);}, d.timeout);
    }

    function setCurrentItem(d, i) {
        if(i === d.currentItem || d.animate) return;

        d.animate = true;
        var o = d.content.children().get(d.currentItem);
        var oPoint = $(d.points.children().get(d.currentItem));

        d.currentItem = i;
        if(d.currentItem >= d.itemsCount) d.currentItem = 0;
        if(d.currentItem < 0) d.currentItem = d.itemsCount - 1;

        var n = d.content.children().get(d.currentItem);
        var nPoint = $(d.points.children().get(d.currentItem));

        $(o).css("left", "0px");
        $(n).css("left", d.width).show();
        oPoint.removeClass("current");
        nPoint.addClass("current");
        $(o).add(n).animate({"left" : "-=" + d.width}, function() {
            $(o).hide();
            d.animate = false;
        });
    }
})();