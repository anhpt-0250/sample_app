class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.degit.length_name}
  validates :email, presence: true,
                    length: {maximum: Settings.degit.length_email},
                    format: {with: Settings.regex.email},
                    uniqueness: true

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
