require "resolv"

namespace :data do
  def server_address
    Resolv.getaddress("liminal.org.nz")
  end

  def do_command(command)
    puts command
    system(command)
  end

  desc "Export development database to remote server. Specify either production or staging (default)."
  task :upload, :target do |t, args|
    target = args[:target] || "staging"
    puts "Copying db/development.sqlite3 to #{target} at #{server_address} ..."
    do_command "scp -q db/development.sqlite3 rails@#{server_address}:rails/liminal-apparel/#{target}/shared/databases/#{target}.sqlite3"
    do_command "scp -q -r public/assets/products rails@#{server_address}:rails/liminal-apparel/#{target}/current/public/assets/"
  end
  
  desc "Import database from remote server. Specify either production (default) or staging."
  task :download, :target do |t, args|
    target = args[:target] || "production"
    puts "Copying #{target} database from #{server_address} to db/development.sqlite3 ..."
    do_command "scp -q rails@#{server_address}:rails/liminal-apparel/#{target}/shared/databases/#{target}.sqlite3 db/development.sqlite3"
    do_command "scp -q -r rails@#{server_address}:rails/liminal-apparel/#{target}/current/public/assets/products public/assets/"
  end
end
