class OrderListing < ApplicationRecord
  belongs_to :listing
  belongs_to :order
end
