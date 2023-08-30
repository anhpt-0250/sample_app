class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {
                      in: Settings.image_type,
                      message: I18n.t("must_be_img")
                    },
                    size: {
                      less_than: Settings.max_size.megabytes,
                      message: I18n.t("less_5MB")
                    }

  # default_scope -> {order created_at: :desc}
  scope :recent_posts, ->{order created_at: :desc}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant resize_to_limit: [500, 500]
  end
end
