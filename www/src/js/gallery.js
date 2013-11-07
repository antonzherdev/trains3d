(function(){
    "use strict";
    $.fn.gallery = function(options) {
        if(!this.length) return this;

        return this.each(function() {
            createGallery(this, options);
        });
    };

    function createGallery(elem, options) {
        var arrows = options.arrows === undefined ? 1 : 0;
        var div = arrows === 1 ? $('<table class="b-gallery"></table>') : $('<div class="b-gallery"></div>');
        $(elem).append(div);

        var content = $('<div class="content"></div>');
        var points =  arrows === 1 ? $('<td colspan="3" class="points"></td>') : $('<div class="points"></div>');
        if(arrows === 1) {
            var top = $('<tr></tr>');
            div.append(top);
            div.append($('<tr></tr>').append(points));

            var left = $('<div class="left-arrow"></div>');
            top.append($('<td></td>').append(left));
            top.append($('<td></td>').append(content));
            var right = $('<div class="right-arrow"></div>');
            top.append($('<td></td>').append(right));
            left.bind('click', function () {
                d.timerRunning = false;
                setCurrentItem(d, d.currentItem - 1);
            });
            right.bind('click', function () {
                d.timerRunning = false;
                setCurrentItem(d, d.currentItem + 1);
            });
        } else {
            div.append(content);
            div.append(points);
        }

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
            timeout: options.timeout === undefined ? 10000 : options.timeout,
            animation: options.animation === undefined ? 1 : options.animation
        };
        $(div).data("gallery", d);
        points.children().first().addClass("current");

        setTimeout(function() {galleryTimer(d);}, d.timeout);


        div.hammer().on("swipeleft", function(event) {
//            alert("left");
            setCurrentItem(d, d.currentItem + 1);
        });

        div.hammer().on("swiperight", function(event) {
//            alert("swiperight");
            setCurrentItem(d, d.currentItem - 1);
        });
        div.bind('click', function () {
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

        oPoint.removeClass("current");
        nPoint.addClass("current");
        if(d.animation === 1) {
            $(o).css("left", "0px");
            $(n).css("left", d.width).show();
            $(o).add(n).animate({"left" : "-=" + d.width}, function() {
                $(o).hide();
                d.animate = false;
            });
        } else {
            $(o).css("z-index", 0).show();
            $(n).css("opacity", 0).css("z-index", 1).show();
            $(n).animate({"opacity" : 1.0}, 600, function() {
                $(o).hide();
                d.animate = false;
            });
        }
    }
})();