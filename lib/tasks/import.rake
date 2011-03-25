namespace :import do
  desc "Import production database from #{SERVER_ADDRESS}"
  task :production do
    puts "Copying production database from #{SERVER_ADDRESS} to db/development.sqlite3 ..."
    system("scp -q rails@#{SERVER_ADDRESS}:rails/liminal-apparel/shared/databases/production.sqlite3 db/development.sqlite3")
  end
end
