// When you point at a category image two things happen:
// 1. The image changes from (say) t-shirt-nohover.jpg to t-shirt-hover.jpg.
// 2. The other images are made half-opaque.  This is done by setting them to a class of 'unselected' and the CSS makes those have an
//    opacity value.

var add_image_handlers = function() {
  $('#categories img').hover(
    function() {
      $('#categories img').addClass('unselected');
      $(this).removeClass('unselected');
      $(this).attr('src',$(this).attr('src').replace('nohover','hover'));
    },
    function() {
      $('#categories img').removeClass('unselected');
      $(this).attr('src',$(this).attr('src').replace('hover','nohover'));
    }
  );
};
 
jQuery(document).ready(function() {
  add_image_handlers();
});

// The main banner cycles between several images
// Code based on http://jquery-howto.blogspot.com/2009/05/replacing-images-at-time-intervals.html

function change_image(){
  var $active = $('#myGallery .active');
  var $next = ($('#myGallery .active').next().length > 0) ? $('#myGallery .active').next() : $('#myGallery img:first');
  $active.fadeOut(1000, function(){
    $active.removeClass('active');
  });
  $next.fadeIn(1000).addClass('active');
};

jQuery(document).ready(function(){
  // Run our change_image() function every 10 secs
  setInterval('change_image()', 3000);
});
