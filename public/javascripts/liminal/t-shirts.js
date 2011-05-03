// The swatch selection drives the main image selection and its thumbnails.

var gender;
// Thumbnail images are the full-size image just displayed small.  When you point at a thumbnail the main image changes to the
// thumbnail image.  When you point away it changes back to what it was.  When you click on a thumbnail the main image permanently
// changes to that thumbnail image.
// 
var add_image_handlers = function() {
  $('#main-image').data('image_src', $('#main-image > img').attr('src'));  // set selection to initial image name
  $('#main-image').data('caption', $('#main-image .caption span').text()); // save current caption
//  $('img.thumbnail').eq(0).addClass('selected'); // this is for highlighting
  $('img.thumbnail').click(function() {
    $('#main-image').data('image_src', $(this).attr('src'));
//  $('ul.thumbnail li').removeClass('selected');
//  $(this).parent('li').addClass('selected');
    return false;
  })
  .hover(
    function() {
      $('#main-image > img').attr('src', $(this).attr('src')); // change main image to this thumbnail
    },
    function() {
      $('#main-image > img').attr('src', $('#main-image').data('image_src')); // restore main image
    });
  
  $('img.swatch').hover(
    function() {
      var color = $(this).attr('src').match(/-(.+)\./)[1];
      $('#main-image > img').attr('src', '/images/' + gender + '-' + color + '-1.jpg'); // change main image to womens-color-1.jpg
      $('#main-image .caption span').text(color.toUpperCase()); // change color description in caption under main photo
      $('img.swatch').addClass('unselected'); // style other swatches as unselected
      $(this).removeClass('unselected');
    },
    function() {
      $('#main-image > img').attr('src', $('#main-image').data('image_src')); // restore main image
      $('#main-image .caption span').text($('#main-image').data('caption')); // and its caption
      $('img.swatch').removeClass('unselected');
    })
  .click(
    function() {
      var color = $(this).attr('src').match(/-(.+)\./)[1];
      $('#main-image').data('image_src', $('#main-image > img').attr('src'));  // make src image stick
      $('#main-image').data('caption', color.toUpperCase()); // and also caption
      $('img.thumbnail').each(function(i) {$(this).attr('src','/images/' + gender + '-' + color + '-' + (i+1) + '.jpg');})
    });
  };
 
jQuery(document).ready(function() {
  add_image_handlers();
  gender = $('#main-image > img').attr('src').match(/images\/(.+)-.+-/)[1];
});
