class Retailer < ActiveRecord::Base
  validates_format_of :country, :with => /\A(Australia|New Zealand)\z/, :message=>'must be Australia or New Zealand'
  validates_format_of :url, :with => /\Ahttp|\A\z/, :message => 'should start with a protocol such as http://'
  # TBD Use a list of acceptable countries from the database rather than being hard-wired.

  def self.retailers_for(country) # returns hash grouped by category and region
    Retailer.all(:conditions => {:country => country}).group_by(&:category).inject({}) { |h, (k, v)| h[k] = v.group_by(&:region); h }
  end

  def self.make_data # sample data
    Retailer.destroy_all

    # Australia
    Retailer.create! :name=>'Empower Shop, 188 Main Street, Bairnsdale', :url=>'http://www.empower.org.au/ourshop.html', :country=>'Australia', :region=>'Victoria', :category=>''
    Retailer.create! :name=>'Under The Juniper Tree, 2/2456 Warburton Hwy, Yarra Junction, Melbourne', :country=>'Australia', :region=>'Victoria', :category=>''
    Retailer.create! :name=>'Folkart, 232 Yarra Street, Warrandyte, Melbourne', :url=>'http://www.folkart.net.au/', :country=>'Australia', :region=>'Victoria', :category=>''
    Retailer.create! :name=>'Threads of Nature, 30 McAdam Square, Croydon, Melbourne', :url=>'http://www.threadsofnature.com.au/', :country=>'Australia', :region=>'Victoria', :category=>''
    Retailer.create! :name=>'Morris Brown, 192 Canterbury Road, Heathmont, Melbourne', :url=>'http://morrisbrown.com.au/', :country=>'Australia', :region=>'Victoria', :category=>''
    Retailer.create! :name=>'Fair Trade Downunder', :country=>'Australia', :region=>'NSW', :category=>''
    Retailer.create! :name=>'Nourish Store', :url=>'http://www.nourishstore.com.au', :country=>'Australia', :region=>'NSW', :category=>''
    Retailer.create! :name=>'One Village Shop, 59a Tambourine Bay Road, Riverview, Sydney', :url=>'http://onevillageshop.com.au/', :country=>'Australia', :region=>'NSW', :category=>''

    # New Zealand
    Retailer.create! :name=>'Black Bird, Heathcote Valley', :url=>'http://blackbirdgifts.co.nz/', :country=>'New Zealand', :category=>'Bags', :region=>'Christchurch'
    Retailer.create! :name=>'Opawaho Organics, Beckenham Shops', :url=>'http://www.opawaorganics.co.nz/', :country=>'New Zealand', :category=>'Bags', :region=>'Christchurch'
    Retailer.create! :name=>'Lyttel Piko, 12 London Street, Lyttelton', :url=>'http://www.pikowholefoods.co.nz/lyttel-piko', :country=>'New Zealand', :category=>'Bags', :region=>'Christchurch'
    Retailer.create! :name=>'Whare, Beckenham', :url=>'http://www.whare.net.nz', :country=>'New Zealand', :category=>'Bags', :region=>'Christchurch'
    Retailer.create! :name=>'Presence gift shop, 290 Main road, Redwood', :url=>'http://www.infoguidenewzealand.com/canterbury/gift-shopssuppliers/presence-gift-shop.html', :country=>'New Zealand', :category=>'Bags', :region=>'Christchurch'
    Retailer.create! :name=>'Global Hope Shop, Nelson', :url=>'http://www.citychurch.org.nz/globalhope.html', :country=>'New Zealand', :category=>'Bags', :region=>'Nelson'
    Retailer.create! :name=>'Nelson Escapes, Nelson', :url=>'http://www.nelsonescapes.co.nz/', :country=>'New Zealand', :category=>'Bags', :region=>'Nelson'
    Retailer.create! :name=>'Floral Affaire, Motueka', :url=>'http://floralaffaire.co.nz/', :country=>'New Zealand', :category=>'Bags', :region=>'Nelson'
    Retailer.create! :name=>'Step in Thyme, Invercargill', :url=>'http://www.menumania.co.nz/restaurants/step-in-thyme', :country=>'New Zealand', :category=>'Bags', :region=>'Rest of South Island'
    Retailer.create! :name=>'Things Design Store, Dunedin', :url=>'http://yellow.co.nz/y/Gift+Shops+%26+Suppliers/Things+Design+Store/101861192_906.html', :country=>'New Zealand', :category=>'Bags', :region=>'Rest of South Island'
    Retailer.create! :name=>'Interlude, Timaru', :url=>'http://yellow.co.nz/y/Gift+Baskets/Interlude+Gifts+%26+Gourmet+Foods/102214291_905.html', :country=>'New Zealand', :category=>'Bags', :region=>'Rest of South Island'
    Retailer.create! :name=>'French Polish, Invercargill', :country=>'New Zealand', :category=>'Bags', :region=>'Rest of South Island'
    Retailer.create! :name=>'Fern Grove Souvenirs, Franz Joseph', :url=>'http://www.glaciercountry.co.nz/directory.asp?DiningCatID=6&DiningID=20', :country=>'New Zealand', :category=>'Bags', :region=>'Rest of South Island'
    Retailer.create! :name=>'Lyttel Piko, Lyttelton', :url=>'http://www.pikowholefoods.co.nz/lyttel-piko', :country=>'New Zealand', :category=>'T-Shirts'
    Retailer.create! :name=>'Addington Coffee Co-op, Christchurch', :url=>'http://www.addingtoncoffee.org.nz', :country=>'New Zealand', :category=>'T-Shirts'
    Retailer.create! :name=>'Safe', :url=>'http://www.choosecrueltyfree.org.nz/', :country=>'New Zealand', :category=>'T-Shirts'
    Retailer.create! :name=>'Tony Cribb', :url=>'http://tonycribb.co.nz/index.php/index/node/41/Shop', :country=>'New Zealand', :category=>'T-Shirts'
  end
end
