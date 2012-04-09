# borrowed from spree extension spree_product_options

ProductsController.class_eval do
  before_filter :define_2d_option_matrix, :only => :show

  def define_2d_option_matrix

    return if object.permalink != 'freeset-t-shirt' # there are other T-shirts we want to treat differently
    
    logger.debug "define_2d_option_matrix"
    variants = Spree::Config[:show_zero_stock_products] ?
      object.variants.active.select { |a| !a.option_values.empty? } :
      object.variants.active.select { |a| !a.option_values.empty? && a.in_stock }
    return if variants.empty? ||
      object.option_types.select { |a| a.presentation == 'Size' }.empty? ||
      object.option_types.select { |a| a.presentation == 'Colour' }.empty?
    gender = params[:gender]=='Male' ? 'Male' : 'Female' # default to female if not explicitly set to male
    variant_ids = {}
    sizes = []
    colors = []
    variants.each do |variant|
      if variant.option_values.detect{|a| a.option_type.presentation == 'Gender'}.presentation == gender then # limit to desired gender
        active_size = variant.option_values.select { |a| a.option_type.presentation == 'Size' }.first
        active_color = variant.option_values.select { |a| a.option_type.presentation == 'Colour' }.first
        variant_ids[active_size.id.to_s + '_' + active_color.id.to_s] = variant.id unless !variant.available
        sizes << active_size
        colors << active_color
      end
    end
    size_sort = Hash['XS', 0, 'S', 1, 'M', 2, 'L', 3, 'XL', 4, 'XXL', 5]
    @sc_matrix = { 'sizes' => sizes.sort_by { |s| size_sort[s.presentation] || 0 }.uniq,
        'colors' => colors.uniq,
        'variant_ids' => variant_ids,
        'gender' => gender}
  end
end
