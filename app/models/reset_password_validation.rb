class ResetPasswordValidation
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :password, :password_confirmation, :token, :authenticity_token, :commit


    validates :password, :password_confirmation, presence: true
    validates :password, password: true
    validates_confirmation_of :password
end