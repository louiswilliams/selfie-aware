class HomeController < ApplicationController
    require 'net/http'
    require 'json'


  def index
    Instagram.configure do |config|
        config.client_id = "482cefd5879c41b48557442fe6500b01"
        Dir.chdir(File.dirname(__FILE__))
        config.client_secret = File.open("insta.secret").read
    end
  end

  def link
    @link = Link.find_by_link_id params[:link_id]
    if !@link
      redirect_to root_path
      return
    end
    render :layout => "results"
  end

  def show
    if !logged_in?
        redirect_to root_path
        return
    end
    # params = {}
    # Dir.chdir(File.dirname(__FILE__))
    # client_secret = File.open("/home/rails/app/controllers/facebook.secret").read
    # uri = URI("https://graph.facebook.com/oauth/access_token?client_id=290229747798878&client_secret=#{client_secret}&grant_type=client_credentials")
    # http = Net::HTTP.start(uri.host, uri.port, :use_ssl => true)
    # request = Net::HTTP::Get.new uri.request_uri
    # response  = http.request request
    # Rails.logger.info response.body

    @client = Instagram.client(:access_token => session[:access_token])
    begin
        if params[:user_id]
            @user = @client.user(params[:user_id])
        else
            @user = @client.user
        end
        @images = []
        media_items = @client.user_recent_media(params[:user_id], :count => 20)
        media_items.each do |media_item|
            @images << media_item.images.low_resolution.url
        end
    rescue
        return redirect_to (root_path)
    else
        return render :layout => "results"        
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
  end

  def logout

    session.delete(:access_token)
    redirect_to root_path
  end

  def about
    render :layout => "about"
  end

  def logged_in?
    session[:access_token]
  end
end
