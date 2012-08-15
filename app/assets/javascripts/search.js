var search = function(t){


    t.init = function(){
        t.listProducts = $(".box-category");
        t.listProducts.html("");
        t.queryRes = $.extend(t.prod, t.queryRes);

        if(w.utils.sizeObj(t.prod) == 0) {
            t.listProducts.html("<div class='box sorting-box ta-c'><span class='sorting-title'>Ничего не найдено</span></div>");
        } else {
            for(var id in t.prod){
                drawBlock(id);
            }
        }

        $(".filter-values .btn").click(function(){
            t.chooseF($(this));
        });
    };

    t.searchByName = function(el){
        var str = el.val();

        t.listProducts.html("");

        var countItems = 0;
        t.queryRes = {};
        for(var id in t.prod){
            if( str.length == 0 || new RegExp(str, "i").test(t.prod[id].title)){
                drawBlock(id);
                countItems += 1;
                t.queryRes[id] = t.prod[id];
            }
        }
        if(countItems == 0) {t.listProducts.html("<div class='box sorting-box ta-c'><span class='sorting-title'>Ничего не найдено</span></div>");}

    };

    t.chooseF = function(el){
        var choiceObj = {};
        el.toggleClass("btn-green");
        $(".filter-values").each(function(){
            var t = $(this),
                    id_fil = t.attr("rel");
            if($(".btn-green", t).length > 0){
                choiceObj[id_fil] = [];
                $(".btn-green", t).each(function(){
                    choiceObj[id_fil].push($(this).attr("rel"))
                });
            }
        });
        t.filter(choiceObj);
    };

    t.filter = function(obj){
        t.listProducts.html("");
        var countItems = 0;
        t.queryRes = {};

        for (var i in t.prod){

            var filters = t.prod[i].filter;
            var flag = true;

            for(var id in obj){

                if(!in_array(filters[id], obj[id])){flag = false; break;}

            }

            if(flag){
                drawBlock(i);
                countItems += 1;
                t.queryRes[i] = t.prod[i];
            }
        }
        if(countItems == 0) {t.listProducts.html("<div class='box sorting-box ta-c'><span class='sorting-title'>Ничего не найдено</span></div>");}
    };

    t.searchByParams = function(params){
        var defaultP = {
            priceFrom: 0,
            priceTo: 0,
            categoryId: 0,
            brand: '',
            user: 0
        };

        t.queryRes = {};

        params = $.extend(defaultP, params)

        t.listProducts.html("");

        var countItems = 0;

        for(var id in t.prod){
            if((params.priceFrom == 0 ? true: t.prod[id].price >= params.priceFrom) &&
               (params.priceTo == 0 ? true: t.prod[id].price <= params.priceTo) &&
               (params.categoryId == 0 ? true : t.prod[id].categoryId == params.categoryId) &&
               (params.user == 0 ? true : t.prod[id].user == params.user) &&
               (params.brand == '' ? true : new RegExp(params.brand, "i").test(t.prod[id].brand))
            ){
                drawBlock(id);
                countItems += 1;
                t.queryRes[id] = t.prod[id];
            }
        }

        if(countItems == 0) {t.listProducts.html("<div class='box sorting-box ta-c'><span class='sorting-title'>Ничего не найдено</span></div>");}

    };

    t.sort = function(pony, isInt, withTitles){
        var a = [], prod = t.queryRes;

        if (w.utils.sizeObj(prod) == 0) {
            t.listProducts.html("<div class='box sorting-box ta-c'><span class='sorting-title'>Ничего не найдено</span></div>");
        } else {
            for (var i in prod) a.push({id: i, s: isInt ? parseFloat(prod[i][pony]) : prod[i][pony]});
            a.sort(function(a, b){
                return (a.s < b.s ? -1 : (a.s > b.s ? 1 : 0));
            });

            t.listProducts.html("");
            var bufferTitle = "";
            for(var id in a){
                var id_prod = a[id]["id"];
                if(withTitles && t.prod[id_prod][pony] != bufferTitle) {
                    bufferTitle = t.prod[id_prod][pony];
                }
                drawBlock(id_prod);
            }
        }
    };

    var drawBlock = function(id){
        t.listProducts.append("<div class='box box-product'>"+
                            "<div class='box-product-info'>"+
                                "<div class='box-product-price'>" + t.prod[id].price + "руб.-</div>"+
                                (t.prod[id].status != 1 ? "<div class='added-block'>"+
                                    "<span class='added-block-title'>Кол-во</span>"+
                                    "<input type='1' onkeydown='return w.utils.checkNum(event)' value='1' id='product_" + id + "' class='added-block-input'>"+
                                    "<a class='btn-add add-to-order' onclick='card.addToCard($(this))' href='javascript:' data-user='" + t.prod[id].user+ "' data-id=" + id + " data-name='" + t.prod[id].title + "' data-price=" + t.prod[id].price + " data-discount=" + ( t.prod[id].discount == 0 ? "0" :  t.prod[id].discount ) + "><span>+</span>В корзину</a>"+
                                "</div>" : "<div class='added-block'>Товар отсутствует</div>")+
                                "<div class='box-product-title'>"+
                                    "<a href='/products/" + id + "'>" +
                                        "<span class='box-product-img' style='background-image: url(" + t.prod[id].img + ")'></span>"+
                                        t.prod[id].title +
                                    "</a>"+
                                "</div>"+
                                "<div class='product-info-item'>"+
                                    "<div class='product-info-label'>Товар категории:</div>"+
                                    "<div class='product-info-data'>" + t.prod[id].category + "</div>"+
                                "</div>"+
                                "<div class='product-info-item'>"+
                                    "<div class='product-info-label'>Производитель:</div>"+
                                    "<div class='product-info-data'>" + t.prod[id].brand + "</div>"+
                                "</div>"+
                                t.prod[id].filter_html +
                                "<div class='product-info-desc'>" + (t.prod[id].desc.length > 150 ? t.prod[id].desc.substring(0, 150) + " <span class='jslink' onclick='$(this).hide(); $(this).parent().find(\".h\").slideToggle()'>...</span><span class='h'>" + t.prod[id].desc.substring(150, t.prod[id].desc.length) + "</span>" : t.prod[id].desc) + "</div>"+
                            "</div>"+
                      "</div>");
    };

    return t;
}({});