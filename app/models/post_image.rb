class PostImage < ApplicationRecord
  
  has_one_attachd :image
  belongs_to :user
end
