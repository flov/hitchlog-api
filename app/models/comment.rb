class Comment < ActiveRecord::Base
  belongs_to :trip, counter_cache: true
  belongs_to :user

  validates :body, presence: true

  def to_s
    body
  end
end
