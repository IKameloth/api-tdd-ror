class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # model association
  has_many :todos, foreign_key: :created_by

  #validation
  validates_presence_of :name, :email, :password_digest
end
