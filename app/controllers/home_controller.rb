class HomeController < ApplicationController
    require 'net/http'
    require 'json'


  def index
    if logged_in?
        redirect_to :action => "show"
    end
    Instagram.configure do |config|
        config.client_id = "482cefd5879c41b48557442fe6500b01"
        config.client_secret = "685dafb12115456a943911431616b383"
    end
  end

  def show
    if !logged_in?
        redirect_to root_path
    end
  end

  def callback
    http = Net::HTTP.new("instagram.com", 443)
    http.use_ssl = true
    data = {
        :grant_type => "authorization_code",
        :redirect_uri => "http://selfieaware.com/callback",
        :client_id => "482cefd5879c41b48557442fe6500b01",
        :client_secret => "685dafb12115456a943911431616b383",
        :code => params[:code]
    }
    response = Net::HTTP::post_form(URI.parse("https://instagram.com/oauth/access_token"), data)
    session[:access_token] = JSON.parse(response.body)["access_token"]
    Rails.logger.info session[:access_token]
    redirect_to :action => "show"
    # BUGGY INSTAGRAM API!!!!!!
    # response = Instagram.get_access_token(params[:code], :redirect_uri => "http://selfieaware.com/callback")
    # session[:access_token] = response.access_token
    # redirect show
    # options = {
    #     :grant_type => "authorization_code",
    #     :redirect_uri => "http://selfieaware.com/callback",
    #     :client_id => "482cefd5879c41b48557442fe6500b01",
    #     :client_secret => "685dafb12115456a943911431616b383",
    #     :code => params[:code]
    # }
    # Instagram.post("/oauth/access_token/", params, raw=false, unformatted=true, no_response_wrapper=true)
  end

  def logout
    session.delete(:access_token)
    redirect_to root_path
  end

  def logged_in?
    session[:access_token]
  end
end
