class PasswordsController < ApplicationController
    def new
        @reset_password_email_errors = ""
        @reset_password_email_validation = ResetPasswordEmailValidation.new
    end 

    def reset_password_email_setup
        @reset_password_email_validation = ResetPasswordEmailValidation.new(params["reset_password_email_validation"].permit(:email, :authenticity_token, :commit))
        if @reset_password_email_validation.valid?
            send_reset_email(@reset_password_email_validation.email)
        else
            puts @reset_password_email_validation.errors.full_messages
            render 'new', status: :unprocessable_entity
        end
    end

    def edit
        @reset_password_validation = ResetPasswordValidation.new
    end

    def reset_password_setup
        @reset_password_validation = ResetPasswordValidation.new(params["reset_password_validation"].permit(:password, :password_confirmation, :token, :authenticity_token, :commit))
        if @reset_password_validation.valid?
            password = @reset_password_validation.password
            token = @reset_password_validation.token
            send_reset_password(password, token)
        else
            puts @reset_password_validation.errors.full_messages
            render 'edit', status: :unprocessable_entity
        end

    end

end