class PayNow < ActiveRecord::Base

  belongs_to :user

  validates_numericality_of :amount, :greater_than => 0
  validates_presence_of :user

end
