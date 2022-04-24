class RegistrationsController < ApplicationController
    def new
        @sign_up_validation = SignUpValidation.new

    end


    def sign_up
        @sign_up_validation = SignUpValidation.new(params["sign_up_validation"].permit(:email, :password, :password_confirmation, :authenticity_token, :commit))
        if @sign_up_validation.valid?
            puts "valid"
            sign_up_params = {"email" => @sign_up_validation.email, "password" => @sign_up_validation.password}
            sign_up_http(sign_up_params)
        else
            puts @sign_up_validation.errors.full_messages
            render 'new', status: :unprocessable_entity
        end
    end
end
