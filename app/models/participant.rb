class Participant < ActiveRecord::Base
  validates_presence_of :name, :email, :division, :biography, :avatar
  belongs_to :event
  validates :biography, length: {minimum: 75, maximum: 150}

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  
end
