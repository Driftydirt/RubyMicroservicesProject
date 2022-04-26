class ApplicationController < ActionController::Base


    protected
   
    def login_http(loginParams)
        login = HTTParty.post('http://172.17.0.1:3001/api/login', :body => {
              :user => {
              :email => loginParams['email'],
              :password => loginParams['password'] }
      }.to_json,
      :headers => { 'Content-Type' => 'application/json'})
      
      if login["error"] != nil
        @login_error = "Email or Password are invalid"
        render 'new', status: :unprocessable_entity
      else
        session[:user_id] = login['data']['id']

        session[:jwt_token] = login.header['authorization']

        session[:logged_in] = true

        redirect_to root_path
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

      if sign_up['errors'] != nil
        session[:http_errors] = sign_up['errors']
        redirect_to sign_up_path
      else
        session[:user_id] = sign_up['data']['id']
        session[:jwt_token] = sign_up.header['authorization']
        session[:logged_in] = true

        user = User.new(:auth_id => session[:user_id])
        user.save!
        redirect_to root_path
      end


      
    end

    def log_out
      logout = HTTParty.delete('http://172.17.0.1:3001/api/logout', :headers => { 'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]})
      session[:logged_in] = false
      redirect_to root_path
    end

    def reminder_email(emails, reminder)
      email = HTTParty.post('http://172.17.0.1:3002/reminder', :body => {
        :emails => emails,
        :event => {
          :title => reminder["title"],
          :description => reminder["description"]
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

      if !email_request["error"].nil?
        emails = nil
        session[:logged_in] == false
      else
        emails = email_request["emails"]
      end
      return emails
    end    
  
end