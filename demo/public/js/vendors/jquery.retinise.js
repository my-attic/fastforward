/*  RETINISE.JS --------------------------------------------------*

  Author:         Simon Sturgess
                  @dahliacreative
                  simon@dahliacreative.com
                  http://www.dahliacreative.com
          
  Thanks to:      Pedro Piedade
                  @iampedropiedade
                  http://pedropiedade.com/
          
  Documentation:  http://www.dahliacreative.com/retinisejs
  
  Release date:   27/09/2012
  Version:        v.1.0
  Licensing:      © Copyright 2012 DahliaCreative.
                  Free to use under the GPLv2 license.
                  http://www.gnu.org/licenses/gpl-2.0.html
                  
*--------------------------------------------------------------------*/

(function($){
  $.fn.extend({

  retinise: function(options) {

    var defaults = {
      suffix: "@2x",
      srcattr: "data-src",
      retattr: "data-ret",
      altattr: "data-alt"
    };
    
    var options =  $.extend(defaults, options);
    var $p = window.devicePixelRatio;
    var $r = ($p > 1) ? true : false;
  
    $(this).each(function() {
      var $t = $(this);
      $t.css('display', 'none');
      if($t.attr(options.srcattr)!==null) {
        var $s = $t.attr(options.srcattr),
            $a = $t.attr(options.altattr),
            $x = $t.attr(options.retattr);
        if ($r === true) {
          if($t.attr(options.retattr)!==null) {
            $t.attr({'src': $x, 'alt':$a});
          } else {
            $t.attr({'src': $s.replace(/\.\w+$/, function(match) { return options.suffix + match; }), 'alt':$a});
          }
          $t.load(function () {
            var $h = $t.height()/$p;
            var $w = $t.width()/$p;
            $t.attr({'height':$h , 'width':$w}).css('display', 'block');
          });
        } else {
          $t.attr({'src': $s, 'alt':$a}).css('display', 'block');
        }
      }
    });
  }
});
     
})(jQuery);
