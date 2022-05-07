require "uri"
require "net/http"
require "cgi"

class HomeController < ApplicationController
    def home
        @invited_events = get_my_events(session[:user_id])
        @created_events = get_my_created_events(session[:user_id])
    end

    def test
        login_params = {"email" => "test@surrey.ac.uk", "password" => "123456"}
        login(login_params)
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
        redirect_to root_path
    end

    def reminder_email_test
        email_request = [session[:user_id]]
        email = get_emails(email_request)
        if email == nil
        else
            reminder = {"title" => "this is a test", "description" => "this is a test description", "date_time" => Time.now + 4.hours}
            reminder_email(email, reminder)
        end

        redirect_to root_path
        
    end

    def reset_email_test
        email = "ross@alantreadway.net"

        send_reset_email(email)
    end

    def event_test
        create_event(generate_event)
        redirect_to root_path
    end

    def created_event_test
        id = "2"
        get_my_created_events(id)
        redirect_to root_path
    end

    def generate_event
        event = EventValidation.new(:id => "2", :title => "this is a test title", :description => "this is a test description", :active => true, :scheduledAt => (Time.now + 1.hours), :creator => session[:user_id], :invitees => [session[:user_id], 3])
    end

    def events_test
        id = "2"
        get_my_events(id)
        redirect_to root_path
    end

    def update_event_test
        update_event(generate_event)
        redirect_to root_path
    end

    def delete_event_setup
        event = EventValidation.new(:id => params["id"], :title => params["title"], :description => params["description"], :active => params["active"], :scheduledAt => params["scheduledAt"], :creator => params["creator"], :invitees => params["invitees"])
        delete_event(event)
        redirect_to root_path
    end






end