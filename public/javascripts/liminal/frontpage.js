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
