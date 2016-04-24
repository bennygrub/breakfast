class Event < ActiveRecord::Base
  validates_uniqueness_of :name, :event_date
  validates_presence_of :name, :event_date
  has_many :participants
  extend TimeSplitter::Accessors
  split_accessor :event_date
end
