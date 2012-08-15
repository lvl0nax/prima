// Cookie
ck = function(key, value, options) {

    if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(value)) || value === null || value === undefined)) {
        options = $.extend({}, options);

        if (value === null || value === undefined) {
            options.expires = -1;
        }

        if (typeof options.expires === 'number') {
            var days = options.expires, t = options.expires = new Date();
            t.setDate(t.getDate() + days);
        }

        value = String(value);

        return (document.cookie = [
            encodeURIComponent(key), '=', options.raw ? value : encodeURIComponent(value),
            options.expires ? '; expires=' + options.expires.toUTCString() : '',
            options.path ? '; path=' + options.path : '',
            options.domain ? '; domain=' + options.domain : '',
            options.secure ? '; secure' : ''
        ].join(''));
    }

    options = value || {};
    var decode = options.raw ? function(s) { return s; } : decodeURIComponent;

    var pairs = document.cookie.split('; ');
    for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
        if (decode(pair[0]) === key) return decode(pair[1] || '');
    }

    return null;
};

// global obj app
var w = (function(){
    var t = {};
    t.O = {};
    t.P = {};

    t.init = function(){
        // objects
        t.O.body = $("body");
        t.O.window = $("window");
        t.O.html = $("html");
        t.O.container = $("#container");
        //params
        t.P.hDoc = t.O.container.height();
        t.P.wDoc = t.O.container.width();

        $("#logout").click(function(){
            w.popup.confirm("Вы уверены, что хотите выйти?", w.session.logout, w.popup.hide, w.popup.hide)
            return false;
        });

    };

    t.resize = function(){
        t.P.hDoc = t.O.container.height();
        t.P.wDoc = t.O.container.width();
        w.popup.align();
    };

    $(t.init);
    return t;
}());

// popup
w.popup = (function(){
    var t = {},
        init = false,
        onCloseF = null,
        openFlag = false;

    t.init = function () {
        if (!init) {
            w.O.popupCover = $('#popup-wrap');
            w.O.popupContent = $('.popup-content', w.O.popupCover);
            w.O.popupTopPart = $('.popup-top', w.O.popupCover);
            w.O.overlay = $('#overlay');
            w.O.popupCloseBtn = $('.popup-close', w.O.overlay);
            w.O.overlay.click(function(){t.hide()});
            w.O.popupCloseBtn.click(function(){t.hide()});
            init = true;
        }
    };
    t.show = function (data, params, closeF, callback) {
        t.init();

        openFlag && t.hide();

        onCloseF = closeF;
        openFlag = true;

        params = params || {};
        params.width = params.width || 0;
        params.topPart = params.topPart || false;

        /*Construct container*/
        w.O.popupContent.append(data);
        if(params.title){
            params.topPart = true;
            w.O.popupTopPart.addClass('enable').prepend(params.title);
        }

        /*container styles*/
        t.align(params.width);

        if (typeof callback == 'function') callback();
    };
    t.hide = function () {
        openFlag = false;

        w.O.popupContent.empty();
        w.O.popupTopPart.removeClass('enable').empty();
        w.O.overlay.css({
            'width':0,
            'height':0
        });
        w.O.popupCover.css({
            'width':'auto',
            'top':'100%'
        });

        if ($.isFunction(onCloseF)) {
            onCloseF();
            onCloseF = null;
        }
    };
    t.alert = function(message, callback){
        t.show(message,{title: 'Внимание', topPart: true, width: 300}, callback, null);
        w.O.popupContent.append(
            $('<div>', {'class': 'clear popup-buttons'})
            .append($('<a>', {'class': 'btn btn-blue fl-r', href: 'javascript:void(0)', click: w.popup.hide, text: 'Ok'}))
        );
    };
    t.confirm = function(message, callbackYes, callbackNo, callbackCancel){
        t.show(message,{title: 'Вопрос', topPart: true, width: 300}, callbackCancel, null);
        w.O.popupContent.append(
            $('<div>', {'class': 'clear popup-buttons'})
            .append($('<a>', {'class': 'btn btn-blue fl-r yes', href: 'javascript:void(0)', text: 'Нет', click: function (){
                if($.isFunction(callbackNo)) {
                    onCloseF = null;
                    callbackNo();
                }
                t.hide();
            }}))
            .append($('<a>', {'class': 'btn btn-blue fl-r no', href: 'javascript:void(0)', text: 'Да', click: function (){
                if($.isFunction(callbackYes)) {
                    onCloseF = null;
                    callbackYes();
                }
                t.hide();
            }}))
        );
    };
    t.align = function (width) {
        if (openFlag) {
            w.O.popupCover.stop();
            var hPopup = w.O.popupCover.height();
            w.O.overlay.css({
                width: w.P.wDoc,
                height: w.P.hDoc
            });
            if(width != 0){
                w.O.popupCover.css({'margin-left':-width/2,'width':width})
            }else{
                w.O.popupCover.css({'margin-left':-w.O.popupCover.width()/2})
            }
            w.O.popupCover.animate({
                top: (w.O.body.height() - hPopup)/2
            },100);
        }
    };
	t.imagePreview = function (url) {
		var img = $(new Image());
		img.load(function () {
			img
				.css('display','none')
				.click(t.hide);
			img.fadeIn();
			img.css({'maxHeight': w.O.window.height() - 50 + 'px'})
			t.show(img);
		}).error(function () {
			alert('Ошибка при загрузке фотографии');
		}).attr('src', url);
	};

    return t;
}());

// session ajax
w.session = (function(){
    var t = {};

    t.popup = function(){
        $.post('/sessions/template_login', {ajax: true}, function(data){
            w.popup.show(data, {title: "Войти", width: 400, topPart:true})
        });
    };

    t.popupRecover = function(){
        $.post('/sessions/template_recover', {ajax: true}, function(data){
            w.popup.show(data, {title: "Восстановление пароля", width: 400, topPart:true})
        });
    };

    t.login = function(params){

        if(params.email.length == 0 || params.password.length == 0){
            alert("Переданы неверные параметры");
        }
        $("#form-login .btn").addClass("btn-disab").unbind('click');
        $.post('/sessions/create_session', {ajax:1, email: params.email, password: params.password}, function(resp){
            if(resp.res == 1){
                location.href = "/";
            } else {
                if(resp.error.length > 0){
                    alert(resp.error)
                }
                $("#form-login .btn").removeClass("btn-disab").click(function(){
                    $("#form-login").submit();
                });
                return false;
            }
        });
    };

    t.logout = function(){
        $.post('/sessions/destroy_session', {ajax:1}, function(resp){
            if(resp.res = 1){
                location.reload();
            } else {
                if(resp.mess.length > 0){
                    w.popup.alert(resp.mess)
                }
            }
        });
        return false;
    };
    return t;
}());

// utils
w.utils = (function(){
    var t = {};

    t.truncate = function(str, size){
        if(str.length > size && typeof(size) == "number" && size > 0 && typeof(str) == "string") {
            return str.slice(0, (size - 1));
        } else {
            return str;
        }
    };

    t.sizeObj = function(obj){
        var count = 0;
        if(typeof(obj) == "object"){
            for(i in obj){
                count += 1;
            }
        } else if(typeof(obj) == "string"){
            count = obj.length;
        }
        return count;
    };

    t.plural = function (c, form1, form2, form3, nullForm, printNumber) {
        printNumber = printNumber || true;
        if (!c && nullForm) {
            return nullForm;
        } else {
            return (printNumber ? c+' ' : '') + (c%10==1&&c%100!=11?form1:(c%10>=2&&c%10<=4&&(c%100<10||c%100>=20)?form2:form3))
        }
    };

    t.checkNum = function(e){
        if((e.keyCode < 48 || ( e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105) && !in_array(e.keyCode, [8, 17, 45, 46, 37, 39])){
            return false;
        }
    };

    t.validMail = function(str){
        return (/^([a-z0-9_\-]+\.)*[a-z0-9_\-]+@([a-z0-9][a-z0-9\-]*[a-z0-9]\.)+[a-z]{2,4}$/i).test(str);
    };

    t.validPhone = function(str){
        return (/\+\d\s\d{3}\s\d{7}/i).test(str);
    };

    t.htmlDecode = function(input){
      var e = document.createElement('div');
      e.innerHTML = input;
      return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
    };

    t.nToBr = function (str) {
        return str.replace( /\n/g, '<br>');
    };

    t.brToN = function (str) {
        return str.replace( /<br>/g, '\n');
    };

    t.random = function (m, n) {
        return Math.floor(Math.random() * (n - m + 1)) + m;
    };

    t.mouse = (function(){
        var T = {},
            curCoord = {x:0, y:0};

        T.init = function () {
            document.onmousemove = function(event) {
                var event = event || window.event;
                curCoord = T.getXYFromEvent(event);
            }
        };

        T.getXYFromEvent = function (e) {
            var x, y;
            if(e.pageX || e.pageY) {
                x = e.pageX;
                y = e.pageY;
            } else if (e.clientX || e.clientY) {
                x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
            }
            return {x:x, y:y};
        };

        T.getXY = function () {
            return curCoord;
        };

        T.init();
        return T;
    }());

    return t;
}());

w.notify = (function () {
    var t = {},
        isInit = false,
        notifyO,
        enable = false;

    t.init = function () {
        if (!isInit) {
            notifyO = $('<div>', {
                'id': 'notify',
                'class': 'all-rnd-5'
            }).appendTo(w.O.container);
            isInit = true;
            w.O.window.mousemove(t.move);
        }
    };

    t.show = function (text, duration) {
        t.init();
        enable = true;
        t.move();
        notifyO.html(text);
        notifyO.stop().fadeTo(100, 1);
        setTimeout(function () {
            t.hide()
        }, duration || 1000);
    };

    t.hide = function () {
        notifyO.stop().fadeTo(200, 0 ,function () {
            notifyO.empty();
            enable = false;
        });
    };

    t.move = function () {
        var mouse = w.utils.mouse.getXY();
        enable && notifyO.css({top: mouse.y + 10, left: mouse.x + 15});
    };
    return t;
}());

// order card
var card = (function(){

    var t={};
        t.cardLi = null,
        t.cardWrap = null,
        t.cardObj = {},
        t.cardTotalPrice = null;

    t.init = function(params){

        var cookieCard = ck("card");

        params = $.extend({
            el: $(".add-to-order"),
            card: $(".card"),
            cardCheck: $("#card-chekout"),
            cardWrap: $("#card-wrapper")
                 }, params);

        t.card = params.card;
        t.cardLi = params.el;
        t.cardCheck = params.cardCheck;
        t.cardWrap = params.cardWrap;

        t.card.fadeIn(200);

        t.card.unbind('click').click(function(event){
            if(t.card.hasClass("empty")) return false;
            if(!t.card.hasClass("open")){
                t.showCard();
            } else {
                event.stopPropagation();
            }
        });

        if(cookieCard == null || (cookieCard != null && cookieCard.length < 3)){
            t.cardObj = {};
            ck("card", JSON.stringify(t.cardObj),{path : "/"});
            t.cardCheck.html("Корзина пуста");
        } else {
            t.cardObj = JSON.parse(cookieCard);
            t.card.removeClass("empty");
            t.writeToCard();
        }

        params.el.click(function(){
            t.addToCard($(this));
        })

    };

    t.showCard = function(){
        t.card.addClass("open");
        t.card.stop().animate({
            "min-width": 250
        }, 300, function(){
            //t.cardWrap.stop().slideDown(300, function(){});
            $('.links').show();
        });

        $("body").unbind("click");
        t.card.mouseout(function(){
            $("body").bind("click", t.hideCard);
        })
    };

    t.hideCard = function(tO){
        t.card.removeClass("open");
        $('.links').hide();
        //t.cardWrap.stop().slideUp(300, function(){});
        t.card.stop().animate({
            "min-width": 100}, 300, function(){
        });
    };

    t.addToCard = function(el){

        var id = parseInt(el.attr("data-id")),
            product = null, countPlus = 1;

        if(id == undefined) {alert("Не указан data-id"); return false;}

        var productCount = $("#product_"+ id);

        if(productCount.length != 0 ){

            if(productCount.val().length = 0 || parseInt(productCount.val()) <= 0 || isNaN(parseInt(productCount.val()))){
                w.notify.show("Заполните количество добавляемого товара");
                productCount.focus();
                return false;
            } else{
                countPlus = parseInt(productCount.val());
            }
        }

        if(t.cardObj != null && t.cardObj[id]){

            t.cardObj[id].count = parseInt(t.cardObj[id].count) + countPlus;

        } else {
            if (t.cardObj == null) t.cardObj = {};

            var discountPar = el.attr("data-discount") != 0 ? el.attr("data-discount").split("&") : 0, discount = {};

            if(discountPar != 0){
                for (var i = 0; i < discountPar.length; i ++){
                    discount[discountPar[i].split(")*")[0]] = discountPar[i].split(")*")[1]
                }
            }
            product = {
                name : el.attr("data-name"),
                price : parseFloat(el.attr("data-price")).toFixed(2),
                user : el.attr("data-user"),
                count : countPlus,
                discount : discount
            };

            t.cardObj[id] = product;

        }

        t.writeToCard();

        w.notify.show("Товар добавлен в корзину");
    };

    t.deleteItem = function(id){
        delete t.cardObj[id];
        t.writeToCard();
    };

    t.minusOne = function(id){
        if(t.cardObj[id].count < 2){
            delete t.cardObj[id];
        } else {
            t.cardObj[id].count = t.cardObj[id].count - 1;
        }
        t.writeToCard();

        return false;
    };

    t.plusOne = function(id){
        t.cardObj[id].count = t.cardObj[id].count + 1;
        t.writeToCard();
        return false;
    };

    t.emptyCard = function(){
        t.cardObj = {};
        t.writeToCard();
    };

    t.totalSumm = function(){
        var total = 0;

        for(k in t.cardObj){
            total += parseInt(t.cardObj[k].count) * parseFloat(t.cardObj[k].price);
        }

        return total.toFixed(2);
    };

    t.writeToCard = function(){

        ck("card", JSON.stringify(t.cardObj),{path : "/"});

        t.card.removeClass("empty");
        t.cardWrap.html("");
        t.cardTotalPrice = 0;
        t.cardTotalCount = 0;

        for(i in t.cardObj){

            /*t.cardWrap.append('<div class="nclear">'+
                                '<div class="fl-r">'+
                                '<a class="counters counters-minus" href="javascript: void(0)" onclick="card.minusOne(' + i + '); event.stopPropagation()"><b>-</b></a>'+
                                ' <span class="count-item">' + t.cardObj[i].count + '</span>'+
                                ' <a href="javascript: void(0)" class="counters counters-plus" onclick="card.plusOne(' + i + '); event.stopPropagation()"><b>+</b></a>'+
                                ' = ' + (t.cardObj[i].count * t.cardObj[i].price ).toFixed(2) +
                                //'&nbsp; <a href="javascript:" onclick="card.deleteItem('+i+')">del</a>'+
                                '</div>'+
                                t.cardObj[i].name +
                              '</div>');
            */
            if(t.cardObj[i].discount != 0) {
                var act_disc = 0;
                for (var num in t.cardObj[i].discount ){
                    if (num <= parseInt(t.cardObj[i].count)) act_disc = t.cardObj[i].discount[num]
                }
                t.cardTotalPrice += parseInt(t.cardObj[i].count) * (parseFloat(t.cardObj[i].price) - parseFloat(t.cardObj[i].price) * (parseFloat(act_disc) / 100));
            } else {
                t.cardTotalPrice += parseInt(t.cardObj[i].count) * parseFloat(t.cardObj[i].price);
            }
            t.cardTotalCount += parseInt(t.cardObj[i].count);

        }

        t.cardTotalPrice = t.cardTotalPrice.toFixed(2);
        t.cardCheck.html("<a href='javascript: void(0)'>" + t.cardTotalCount + "</a> товаров, на сумму: <a href='javascript: void(0)'>" + t.cardTotalPrice + " р.</a>");

        if(w.utils.sizeObj(t.cardObj) == 0) {
            t.cardCheck.html("Корзина пуста");
            t.card.addClass("empty").removeClass("open");
            t.hideCard();
        }

    };

    $(t.init);

    return t;
}());

var check = (function(el){
  var t = {};
  t.getNextStep = function(el){
    var fioO = $("#fio"),
        mobileNumberO = $("#mobile-number"),
        emailO = $("#email_order"),
        addressO = $("#address"),
        dateO = $("input[name = 'time']:checked");
    if (t.flagError) {
          w.popup.alert("Один из ваших заказов не соответствует минимальной сумме заказов поставщика.");
          return false;
    }
    if(fioO.val().length == 0){
        alert("Введите Ваше ФИО");
        fioO.focus();
        return false;
    } else if(mobileNumberO.val().length == 0){
        alert("Введите Ваш мобильный телефон");
        mobileNumberO.focus();
        return false;
    } else if(emailO.val().length == 0){
        alert("Введите Email дл связи");
        emailO.focus();
        return false;
    } else if(! /\+\d\s\d{3}\s\d{7}/.test(mobileNumberO.val()) || mobileNumberO.val().length > 15){
        alert("Проверьте правильность введённого номера");
        mobileNumberO.focus();
        return false;
    }
    el.unbind('click').addClass("btn-disab");
    $.post("/orders/create_order", {ajax: true, fio: fioO.val(), phone: mobileNumberO.val(), date: dateO.val(), email : emailO.val(), address: addressO.val()}, function(resp){
        if(resp.status == 1){
            w.popup.show("<div>Ваш заказ принят, и направлен поставщикам. Количество поставщиков: "
                            + resp.count +
                            ". Они свяжуться с вами по контактным данным указанным при оформлении заказа </div>"+
                            "<div class='ta-r'><a class='btn btn-blue' href='javascript: void(0)' onclick='w.popup.hide()'>Хорошо</a></div>", {width: 500, title: "Спасибо вам!", topPart: true}, function(){ location.href = current_user != false ? "/profile" : "/"});
        } else {
            el.removeClass("btn-disab").click(function(){
                check.getNextStep(el);
            });
        }
    });
  };

  t.addOneToCard = function(el, id){

      card.plusOne(id);

      t.writeFromCard();
  };

  t.minusOneFromCard = function(el, id){

      card.minusOne(id);

      t.writeFromCard();
  };

  t.withDisc = function(id){
    var price = 0;
    if(card.cardObj[id].discount != 0) {
        var act_disc = 0;
        for (var num in card.cardObj[id].discount ){
            if (num <= parseInt(card.cardObj[id].count)) act_disc = card.cardObj[id].discount[num]
        }
        price = parseFloat(card.cardObj[id].price) - parseFloat(card.cardObj[i].price) * (parseFloat(act_disc) / 100)
    } else {
        price = parseFloat(card.cardObj[id].price);
    }
    return price;
  };

  t.writeFromCard = function(){

    t.table.html("");

    t.tableInner = "<tr class='tr-top'><td>Наименование товара</td><td>Количество</td><td>Цена</td><td class='td-last'>Сумма</td></tr>";
    t.objForUsers = {};
    for(var i = 0; i < t.users.length; i++){
        var id_u = t.users[i];
        t.objForUsers[id_u] = {inner : "", price: 0, checkFlag: false}
        t.objForUsers[id_u]["inner"] = t.tableInner
    }
    for(i in card.cardObj){
        t.objForUsers[card.cardObj[i].user]["inner"] += "<tr>"+
                    "<td>" + card.cardObj[i].name + "</td>"+
                    "<td>"+
                        "<a class='btn btn-blue btn-counter' onclick='check.minusOneFromCard($(this), " + i + ")' href='javascript: void(0)'><b>-</b></a>"+
                        " <span class='count'>" + card.cardObj[i].count + "</span>"+
                        " <a class='btn btn-blue btn-counter' onclick='check.addOneToCard($(this), " + i + ")' href='javascript: void(0)'><b>+</b></a>"+
                    "</td>"+
                    "<td>" + t.withDisc(i) + "</td>"+
                    "<td class='td-last'>" +(card.cardObj[i].count * t.withDisc(i)).toFixed(2) + "</td>"+
                "</tr>";
        t.objForUsers[card.cardObj[i].user]["price"] += card.cardObj[i].count * t.withDisc(i);
        t.objForUsers[card.cardObj[i].user]["checkFlag"] = true;
    }

    for(var i = 0; i < t.users.length; i++){
        var id_u = t.users[i];

        t.flagError = parseInt(t.objForUsers[id_u]["price"]) < parseInt(t.minimal_price[id_u]) ? true : false;

        t.objForUsers[id_u]["inner"] += "<tr " + (t.flagError ? 'style=\'color: red\'' : '') + " class='tr-bottom'><td class='td-last' colspan='4'>Итог: " + t.objForUsers[id_u]["price"].toFixed(2) + "</td></tr>"
        $("#for_user_"+ id_u).html(t.objForUsers[id_u]["inner"]);
        if(t.objForUsers[id_u]["checkFlag"] == false){
            $("#order_user_"+ id_u).remove();
        }
    }

    if(w.utils.sizeObj(card.cardObj) == null) {
        t.table.html("Корзина пуста, <a href='/'>выберите товар</a> и возвращайтесь!");
        $(".form, .btn-check").remove();
    }

  };

  t.init = function(){
    t.table = $('.list-products-card');

    t.writeFromCard();
  };
  return t;

}());

w.banner = function(t){
    t.timerLong = 10000;
    t.init = function(){
        if(! t.flagInit){
            t.banners = $(".banner-top");
            t.countBanners = t.banners.length;
            t.currentBanner = 0;
            
            t.banners.hover(function(){
                $(".banner-desc", t.banners).stop().fadeTo(200, 1);
            }, function(){
                $(".banner-desc", t.banners).stop().fadeTo(200, 0);
            });
            
            t.banners.css({
                "z-index" : 1
            });
            
            $(t.banners[0]).css({
                "z-index": 2
            });
            
            /*if(t.countBanners > 1){
                setTimeout(function(){
                    t.showNext()
                }, t.timerLong);                
            }*/

            t.flagInit = true;
        }
    };

    t.showNext = function(){
        $(t.banners[t.currentBanner]).fadeOut(500, function(){
            $(t.banners[t.currentBanner]).css({
                "z-index" : 1
            });
            if(t.currentBanner == t.countBanners - 1){
                $(t.banners[0]).css({
                    "z-index" : 2
                })
            } else {
                $(t.banners[t.currentBanner + 1]).css({
                    "z-index" : 2
                })                
            }
        });

        if(t.currentBanner == t.countBanners - 1){
            t.currentBanner = 0;
        } else {
            t.currentBanner += 1;
        }
        $(t.banners[t.currentBanner]).css({"display":"block"});

        setTimeout(function(){
            t.showNext()
        }, t.timerLong);
    };

    $(t.init);
    
    return t;
}({});

// Расширения

var in_array = function(num, arr){
    for(var i = 0; i < arr.length; i++){
        if(num == arr[i]) return true;
    }
    return false;
}

var checkInput = function(str, el){
    if(el.val() == str || el.val().length == 0){
        el.val(str).addClass("input-empty");
    }
}

var focusInput = function(str, el){
    if (el.val() == str){
        el.removeClass("input-empty");
        el.val("");
    }
}