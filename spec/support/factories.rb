FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    login { email }
    password 'secret'
    password_confirmation 'secret'
  end
  
  factory :country do
    iso_name 'NEW ZEALAND'
    name 'New Zealand'
    iso 'NZ'
    iso3 'NZL'
    numcode 554
  end
  
  factory :address do
    firstname 'John'
    lastname 'Doe'
    address1 '10 Lovely Street'
    address2 'Addington'
    city 'Christchurch'
    zipcode '8024'
    phone '021 1234567'

    association(:country)
  end
    
  factory :order do
    association(:user, :factory => :user)
    association(:bill_address, :factory => :address)
    completed_at nil
    bill_address_id nil
    ship_address_id nil
    email 'foo@example.com'
  end
  
  factory :order_with_totals, :parent => :order do
    after_create { |order| Factory(:line_item, :order => order) }
  end
end
