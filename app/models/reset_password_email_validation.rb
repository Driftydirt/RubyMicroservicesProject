class ResetPasswordEmailValidation
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :email, :authenticity_token, :commit


    validates :email, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end