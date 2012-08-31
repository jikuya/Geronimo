// Facebookログインリダイレクト対応
if (window.location.hash == '#_=_')window.location.hash = '';

// Google Analytics設定
var _gaq = _gaq || [];
//_gaq.push(['_setAccount', '自分のトラッキングコード']);

$(document).bind('mobileinit', function(){
    // 日本語化
    $.mobile.loadingMessage = '読込み中';
    $.mobile.pageLoadErrorMessage = '読込みに失敗しました';
    $.mobile.page.prototype.options.backBtnText = '戻る';
    $.mobile.dialog.prototype.options.closeBtnText = '閉じる';
    $.mobile.selectmenu.prototype.options.closeText= '閉じる';
    $.mobile.listview.prototype.options.filterPlaceholder = '検索文字列...';

    // 戻るボタンの自動表示
    $.mobile.page.prototype.options.addBackBtn = true;              

    // ページトラッキング
    $(':jqmData(role="page")').live('pageshow', function (event, ui) {
        _gaq.push(['_trackPageview', $.mobile.activePage.jqmData('url')]);
    });
});

$(document).ready(function(){
    // 最初のページ以外の全ページにホームボタンを追加
    $(':jqmData(role=page)').live("pagebeforecreate", function(evt){
        var page = $(this),
            home = $.mobile.firstPage;
            if ( page.attr('id') != home.attr('id') ) {
                page.find(':jqmData(role="header")').append(
                    $('<a href="#' + home.attr('id') + '" data-transition="slideup" data-role="button" data-icon="home" data-iconpos="notext" class="ui-btn-right">ホームへ</a>')
            );
        }
    });
    
    // 地図ページ
    $('#menu4').bind('pageshow', function(){
        var TITLE = '東京',
        LAT = 35.681178,
        LNG = 139.767240,
        MAP_ID = 'map';

        //地図作成
        var infowindow = new google.maps.InfoWindow(),
        latLng = new google.maps.LatLng(LAT, LNG),
        map = new google.maps.Map(document.getElementById(MAP_ID), {
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }),
        marker = new google.maps.Marker({
            title: TITLE,
            position: latLng,
            map: map
        });

        //地図表示
        map.setCenter(latLng);
        infowindow.open(map);
    });

    // Google Analytics読み込み
    var ga = document.createElement('script'); ga.type = 'text/javascript';
    ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(ga, s);
});
