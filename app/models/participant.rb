class Participant < ActiveRecord::Base
  validates_presence_of :name, :email, :division, :biography
  belongs_to :event
end
