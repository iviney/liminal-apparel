namespace :data do
  desc "Export development database to #{SERVER_ADDRESS}. Specify either production or staging (default)."
  task :upload, :target do |t, args|
    target = args[:target] || "staging"
    puts "Copying db/development.sqlite3 to #{target} at #{SERVER_ADDRESS} ..."
    command = "scp -q db/development.sqlite3 rails@#{SERVER_ADDRESS}:rails/liminal-apparel/#{target}/shared/databases/#{target}.sqlite3"
    puts command
    system(command)
  end
  
  desc "Import production database from #{SERVER_ADDRESS}. Specify either production (default) or staging."
  task :download, :target do |t, args|
    target = args[:target] || "production"
    puts "Copying #{target} database from #{SERVER_ADDRESS} to db/development.sqlite3 ..."
    command = "scp -q rails@#{SERVER_ADDRESS}:rails/liminal-apparel/#{target}/shared/databases/#{target}.sqlite3 db/development.sqlite3"
    puts command
    system(command)
  end
end
