class Participant < ActiveRecord::Base
  validates_presence_of :name, :email, :division, :biography
  belongs_to :event
  #validates :biography, length: {minimum: 75, maximum: 150}

  has_attached_file :avatar, source_file_options:{all:"-auto-orient"}, styles: { original: "800x800", large: "500x500", medium: "300x300#", thumb: "100x100#", :cropped => '200x200#' }, default_url: "/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_presence_of :avatar, message: "An image is required. Please upload a portait."
  crop_attached_file :avatar
  
end
