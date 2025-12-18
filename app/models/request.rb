class Request < ApplicationRecord
  enum :request_type, { other: 0, user: 1, apartment: 2, amenities: 3 }
end
