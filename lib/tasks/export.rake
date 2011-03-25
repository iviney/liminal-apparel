namespace :export do
  desc "Export development database to #{SERVER_ADDRESS}"
  task :development do
    puts "Copying db/development.sqlite3 to #{SERVER_ADDRESS} ..."
    system("scp -q db/development.sqlite3 rails@#{SERVER_ADDRESS}:rails/liminal-apparel/shared/databases/production.sqlite3")
  end
end
