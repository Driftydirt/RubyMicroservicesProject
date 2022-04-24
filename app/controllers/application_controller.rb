class ApplicationController < ActionController::Base


    protected
   
    def login(loginParams)
        login = HTTParty.post('http://172.17.0.1:3001/api/login', :body => {
              :user => {
              :email => loginParams['email'],
              :password => loginParams['password'] }
      }.to_json,
      :headers => { 'Content-Type' => 'application/json'})

      session[:user_id] = login['data']['id']

      session[:jwt_token] = login.header['authorization']

      session[:logged_in] = true
      
      render "home"
    end

    def auth
      auth = HTTParty.post('http://172.17.0.1:3001/auth', :headers => { 'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]})
      puts auth["message"]
      if auth["message"] == "User Authenticated." 
        puts "authenticated" 
      else 
        session[:logged_in] = false
      end
      
      render "home"
    end 

    def sign_up_test(sign_up_params)
      sign_up = HTTParty.post('http://172.17.0.1:3001/api/signup', :body => {
              :user => {
              :email => sign_up_params['email'],
              :password => sign_up_params['password']
              }}.to_json,
              :headers => { 'Content-Type' => 'application/json'})

      session[:user_id] = sign_up.body['id']
      session[:jwt_token] = sign_up.header['authorization']
      session[:logged_in] = true
      puts sign_up

      render "home"
    end

    def log_out
      logout = HTTParty.delete('http://172.17.0.1:3001/api/logout', :headers => { 'Content-Type' => 'application/json', 'Authorization' => session[:jwt_token]})
      session[:logged_in] = false
      render "home"
    end

end
