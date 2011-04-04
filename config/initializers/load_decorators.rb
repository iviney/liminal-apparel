Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
  Rails.env == "production" ? require(c) : load(c)
end
