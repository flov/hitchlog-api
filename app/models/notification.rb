class Notification < ApplicationRecord
  belongs_to :issued_by, optional: true, class_name: "User", foreign_key: "user_id"
  validates :mailer, presence: true
  validates :mailer_method, presence: true
  validates :to, presence: true
  validates :subject, presence: true
  validates :body, presence: true
end
