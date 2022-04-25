require "uri"
require "net/http"
require "cgi"

class HomeController < ApplicationController
    def home
    end

    # TODO: move bellow code into sessions controller

    def test
        login_params = {"email" => "test@surrey.ac.uk", "password" => "123456"}
        login(login_params)
        puts session[:jwt_token]
        puts session[:user_id]
        puts true
    end

    def test_sign_up
        sign_up_params = {"email" => "test3@surrey.ac.uk", "password" => "1234567"}
        sign_up_test(sign_up_params)
    end

    def test_log_out
        log_out
    end

    def test_auth
        auth
    end

    def reminder_email_test
        email = ["rtreadwaynest@gmail.com", "ross@alantreadway.net"]
        reminder = {"title" => "this is a test", "description" => "this is a test description"}
        reminder_email(email, reminder)
    end

    

end