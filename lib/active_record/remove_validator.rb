ActiveRecord::Base.class_eval do
  def self.remove_validator(kind, attribute)
    found = false
    Array.wrap(_validators[attribute]).each do |validator|
      if validator.kind == kind
        validator.attributes.delete(attribute)
        found = true
      end
    end
    raise "not found" unless found
  end
end
