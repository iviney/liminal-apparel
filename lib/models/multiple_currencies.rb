module Models::MultipleCurrencies
  extend ActiveSupport::Concern
  
  included do
    # This should be a string like "NZD:25 AUD:20"
    validates :currency_prices, :presence => true, :if => :validate_currency_columns?
    
    validate :validate_required_currencies_present, :if => :validate_currency_columns?
  end
  
  module InstanceMethods
    # The currency_prices column should be populated with data like "NZD:30 AUD:25"
    def currency_prices_hash
      currency_prices.to_s.split(" ").inject({}) do |hash, s|
        k, v = s.split(":", 2)
        hash[k] = BigDecimal(v) if k && v
        hash
      end
    end
    
    def price_using_active_currency
      currency_prices_hash[Site.active_currency]
    end
    
    private
      def validate_required_currencies_present
        Spree::Config[:required_currencies].to_s.split.each do |currency|
          unless currency_prices_hash.include?(currency)
            errors.add :base, "Price missing for #{currency}"
          end
        end
      end
      
      def validate_currency_columns?
        true
      end
  end
end
