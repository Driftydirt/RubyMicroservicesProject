class ApplicationController < ActionController::Base
  add_flash_types :success, :warning, :danger, :info

    protected
    def login_http(loginParams)
        login = HTTParty.post('http://172.17.0.1:3001/api/login', :body => {
              :user => {
              :email => loginParams['email'],
              :password => loginParams['password'] }
      }.to_json,
      :headers => { 'Content-Type' => 'application/json'})
      
      if login.code == 200

        session[:user_id] = login['data']['id']

        session[:jwt_token] = login.header['authorization']

        session[:logged_in] = true

        redirect_to root_path
        
      else
        @login_error = "Email or Password are invalid"
        render 'new', status: :unprocessable_entity
      end
    end

    def auth
      auth = HTTParty.post('http://172.17.0.1:3001/auth', :headers => { 'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]})
      if auth.code != 401
      else 
        session[:logged_in] = false
      end
    end 

    def sign_up_http(sign_up_params)
      sign_up = HTTParty.post('http://172.17.0.1:3001/api/signup', :body => {
              :user => {
              :email => sign_up_params['email'],
              :password => sign_up_params['password']
              }}.to_json,
              :headers => { 'Content-Type' => 'application/json'})

      if sign_up.code == 200

        session[:user_id] = sign_up['data']['id']
        session[:jwt_token] = sign_up.header['authorization']
        session[:logged_in] = true
        redirect_to root_path
        
      else
        @sign_up_error = "Email is already in use"
        render 'new', status: :unprocessable_entity
      end


      
    end

    def log_out
      logout = HTTParty.delete('http://172.17.0.1:3001/api/logout', :headers => { 'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]})
      session[:logged_in] = false
      redirect_to root_path
    end

    def reminder_email(emails, event)
      email = HTTParty.post('http://172.17.0.1:3002/reminder', :body => {
        :emails => emails,
        :event => {
          :title => event["title"],
          :description => event["description"],
          :date_time => event["date_time"]
        }
      })
    end


    def get_emails(user_ids)
      emails = []
      email_request = HTTParty.post('http://172.17.0.1:3001/auth/email', :headers => {
        'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]
      },
      :body => {
        :ids => user_ids
      }.to_json)

      if email_request.code == 404
        emails = nil
      else
        emails = email_request["emails"]
      end
      return emails
    end

    def get_ids(emails)
      ids = []
      email_request = HTTParty.post('http://172.17.0.1:3001/auth/id', :headers => {
        'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]
      },
      :body => {
        :emails => emails
      }.to_json)

      if email_request.code == 404
        ids = nil
      else
        ids = email_request["ids"]
      end
      return ids
    end
    
    def send_reset_email(email)
      reset_token_request = HTTParty.post('http://172.17.0.1:3001/reset_password_token', :body => {
        :email => email
      })
      if reset_token_request.code == 200
        reset_token = reset_token_request["token"]
        reset_email_request = HTTParty.post('http://172.17.0.1:3002/reset_password', :body => {
          :email => email,
          :token => reset_token
        })
      end
      redirect_to root_path
    end

    def send_reset_password(password, token)
      reset_password_request = HTTParty.put('http://172.17.0.1:3001/reset_password', :body => {
        :password => password,
        :reset_password_token => token
      })
      redirect_to login_path
    end

    def send_invite(creator, emails, event)
    invite_request = HTTParty.post('http://172.17.0.1:3002/invite', :body => {
      :emails => emails,
      :creator => creator,
      :event => {
          :title => event["title"],
          :description => event["description"],
          :date_time => event["scheduledAt"],
        }
    })
    end

    def send_update(creator, emails, event)
      invite_request = HTTParty.post('http://172.17.0.1:3002/update', :body => {
        :emails => emails,
        :creator => creator,
        :event => {
            :title => event["title"],
            :description => event["description"],
            :date_time => event["scheduledAt"],
          }
      })
    end

    def send_delete(creator, emails, event)
        invite_request = HTTParty.post('http://172.17.0.1:3002/delete', :body => {
          :emails => emails,
          :creator => creator,
          :event => {
              :title => event.title,
              :description => event.description,
              :date_time => event.scheduledAt,
            }
        })
    end

    def create_event_request(event)
      event_request = HTTParty.post('http://172.17.0.1:3003/events', :body => {
        :event => {
          :title => event.title,
          :description => event.description,
          :active => event.active,
          :scheduledAt => event.scheduledAt,
          :creator => event.creator,
          :invitees => event.invitees
        }
      })
      return event_request
    end

    def update_event_request(event)
      event_request = HTTParty.put('http://172.17.0.1:3003/events', :body => {
        :event => {
          :title => event.title,
          :description => event.description,
          :active => event.active,
          :scheduledAt => event.scheduledAt,
          :creator => event.creator,
          :invitees => event.invitees
        },
        :id => event.id
      })
      return event_request
    
    end

    def delete_event_request(event)
      event_request = HTTParty.delete('http://172.17.0.1:3003/events', :body => {
        :id => event.id
      })
      return event_request
    
    end

    def create_event(event_validation)
      auth
      if session[:logged_in]
        event = create_event_request(event_validation)
        creator = get_emails(event["creator"])
        email_addresses = get_emails(event["invitees"])
        send_invite(creator, email_addresses, event)
      end
      # render created_event
    end    

    def get_my_created_events(id)
      auth
      if session[:logged_in]
        event_request = HTTParty.post('http://172.17.0.1:3003/my_created_events', :body => {
          :id => id
        })
        if event_request.code == 404
          return nil 
        else 
          return event_request
        end
      end
      
    end

    def get_my_events(id)
      auth
      if session[:logged_in]
        event_request = HTTParty.post('http://172.17.0.1:3003/my_events', :body => {
          :id => id
        })
        if event_request.code == 404
          return nil 
        else 
          return event_request
        end
      end
    end

    def update_event(event_validation)
      auth
      if session[:logged_in]
        event = update_event_request(event_validation)
        if event.code == 404
          @update_event_error = "Event not found"

        else
          creator = get_emails(event["creator"])
          email_addresses = get_emails(event["invitees"])
          send_update(creator, email_addresses, event)
        end
      end
      # render created_event
    end

    def delete_event(event)
      auth
      if session[:logged_in]
        request = delete_event_request(event)
        if request.code == 404
          puts request.code, request["error"]
        else
          creator = get_emails(event.creator)
          email_addresses = get_emails(event.invitees)
          send_delete(creator, email_addresses, event)
        end
      end
      # render created_event
    end 
end