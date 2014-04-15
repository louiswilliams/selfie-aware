require 'digest/md5'

class AjaxController < ApplicationController
  def get_user_data
  end

  def get_follows
    results = []
    if params[:user_id]
      cursor = 0
      client = Instagram.client(:access_token => session[:access_token])
      found = true
      while found
        found = false
        users = client.user_follows :cursor => cursor
        Rails.logger.info users
        for user in users
          found = true
          results << user
        end
        cursor += 1
      end
    end
    render :json => {"results" => results}
  end

  def get_images
    
  end 

  def search
    results = []
    if params[:query]
        client = Instagram.client(:access_token => session[:access_token])
        for user in client.user_search(params[:query], count: 10)
            results << user
        end
    end
    render :json => {"results" => results}
  end

  def process_images
    client = Instagram.client(:access_token => session[:access_token])
    selfies = 0
    link_url = "http://selfieaware.com/link/"
    if params[:user_id]
        user = client.user params[:user_id]
        link = Link.find_by_user_id(user.id)
        if !link
          images = []
          captions = []
          media_items = client.user_recent_media(user.id)
          media_items.each_with_index do |media_item, i|
              images << media_item.images.thumbnail.url 
              if media_item.caption 
                  captions << media_item.caption.text 
              end 
          end

          if images
            user_id = Digest::MD5.hexdigest(session[:access_token])
            facial = FacialRecognition.new user_id
            selfies = facial.addPics (images)
            
            link_id = Digest::MD5.hexdigest(params[:user_id])
            link = Link.new
            link.link_id = link_id
            link.user_id = user.id
            link.propic = user.profile_picture
            link.full_name = user.full_name
            link.username = user.username
            link.score = selfies
            link.save
          end
        end
        # render :json => {"images" => images, "captions" => captions}
    end
    render :json => {"selfies" => link.score, "link" => "#{link_url}#{link.link_id}"}
  end

  def process_captions
  end
end
