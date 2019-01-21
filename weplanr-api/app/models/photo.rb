class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true, touch: true

  has_attached_file :image
  validates_attachment_content_type :image,
    content_type: /\Aimage\/.*\z/,
    adapter_options: { hash_digest: Digest::SHA256 }

  def url
    image.url
  end
end
