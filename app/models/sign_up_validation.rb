class SignUpValidation
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :email, :password, :password_confirmation, :authenticity_token, :commit


    validates :email, :password, :password_confirmation, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, password: true
    validates_confirmation_of :password



end