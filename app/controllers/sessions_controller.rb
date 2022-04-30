class SessionsController < ApplicationController
    def new
        @login_validation = LoginValidation.new
        @login_error = ""
    end

    def login
        @login_validation = LoginValidation.new(params["login_validation"].permit(:email, :password, :authenticity_token, :commit))
        if @login_validation.valid?
            login_params = {"email" => @login_validation.email, "password" => @login_validation.password}
            login_http(login_params)
        else
            puts @login_validation.errors.full_messages
            render 'new', status: :unprocessable_entity
        end
    end
end