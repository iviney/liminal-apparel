require "resolv"

namespace :data do
  def server_address
    Resolv.getaddress("liminal.org.nz")
  end
  
  desc "Export development database to remote server. Specify either production or staging (default)."
  task :upload, :target do |t, args|
    target = args[:target] || "staging"
    puts "Copying db/development.sqlite3 to #{target} at #{server_address} ..."
    command = "scp -q db/development.sqlite3 rails@#{server_address}:rails/liminal-apparel/#{target}/shared/databases/#{target}.sqlite3"
    puts command
    system(command)
  end
  
  desc "Import database from remote server. Specify either production (default) or staging."
  task :download, :target do |t, args|
    target = args[:target] || "production"
    puts "Copying #{target} database from #{server_address} to db/development.sqlite3 ..."
    command = "scp -q rails@#{server_address}:rails/liminal-apparel/#{target}/shared/databases/#{target}.sqlite3 db/development.sqlite3"
    puts command
    system(command)
  end
end
