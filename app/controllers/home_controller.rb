require "uri"
require "net/http"
require "cgi"

class HomeController < ApplicationController
    def home
        @invited_events = get_my_events(session[:user_id])
        @created_events = get_my_created_events(session[:user_id])
    end

    def log_out_button
        log_out
    end

end