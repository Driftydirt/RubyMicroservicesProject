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
      puts auth["message"]
      if auth["message"] == "User Authenticated." 
        puts "authenticated" 
      else 
        session[:logged_in] = false
      end
      
      redirect_to root_path
    end 

    def sign_up_http(sign_up_params)
      sign_up = HTTParty.post('http://172.17.0.1:3001/api/signup', :body => {
              :user => {
              :email => sign_up_params['email'],
              :password => sign_up_params['password']
              }}.to_json,
              :headers => { 'Content-Type' => 'application/json'})

      puts sign_up
      if sign_up['errors'] != nil
        session[:http_errors] = sign_up['errors']
        redirect_to sign_up_path
      else
        session[:user_id] = sign_up['data']['id']
        session[:jwt_token] = sign_up.header['authorization']
        session[:logged_in] = true

        user = User.new(:auth_id => session[:user_id])
        user.save!
        puts "kill"
        redirect_to root_path
      end


      
    end

    def log_out
      logout = HTTParty.delete('http://172.17.0.1:3001/api/logout', :headers => { 'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]})
      session[:logged_in] = false
      render "home"
    end

end
