class LoginValidation
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :email, :password, :authenticity_token, :commit

    validates :email, :password, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

end