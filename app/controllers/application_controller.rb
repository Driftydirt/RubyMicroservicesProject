class ApplicationController < ActionController::Base


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
      if auth["message"] == "User Authenticated." 
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

        user = User.new(:auth_id => session[:user_id])
        user.save!
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

      if email_request.code == 401
        emails = nil
        session[:logged_in] == false
      else
        emails = email_request["emails"]
      end
      return emails
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

    def send_invite(emails, event)
    invite_request = HTTParty.post('http://172.17.0.1:3002/invite', :body => {
      :emails => emails,
      :event => {
          :title => event["title"],
          :description => event["description"],
          :date_time => event["date_time"],
        }
    })
    end

  
end