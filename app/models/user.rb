class User < ActiveRecord::Base
  attr_accessor :require_password, :require_password_confirmation

  has_many :oauths, dependent: :destroy

  has_secure_password

  validates :password, length: { minimum: 6 }
  validates :password, confirmation: { if: ->{ require_password_confirmation }}, if: ->{ require_password || require_password_confirmation }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: true }

  scope :find_by_lower_email, -> email {
    where('lower(email) = lower(?)', email)
  }

  before_create do |doc|
    doc.api_key = doc.generate_api_key
  end


  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  def to_json(opts={})
    opts.merge!(only: [:id, :email, :api_key ])
    super(opts)
  end

end
