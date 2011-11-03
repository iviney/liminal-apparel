module Spree::BaseHelper

# Override the product_image helper created in spree core \app\helpers\spree\base_helper.rb, so we can
# use the original image instead of the resized :product image

 #Image.attachment_definitions[:attachment][:styles].each do |style, v|
    def product_image (product, *options)
      options = options.first || {}
      if product.images.empty?
        image_tag "noimage/product.jpg", options
      else
        image = product.images.first
        options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
        image_tag image.attachment.url(:original), options
      end
    end
end
