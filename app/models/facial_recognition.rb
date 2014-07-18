require 'net/http'

class FacialRecognition

	def initialize( user )
		@api_key = 'a2WyuNWtIHug62b7'
		@api_secret = 'xOGopx3hecNEgQVh'
		@user_id = user
	end

	def addPics( pics ) # pics is an array of pics
		images = [] # images contains an array of processes images from Rekognition
		for i in 0..pics.length
			images << addFaces( pics[i] )
		end 
		faces = countFaces(images)
		maxCluster = clusterFaces()
		Rails.logger.info "Faces: #{faces}"
		Rails.logger.info "maxCluster: #{maxCluster}" 
		# score = ((maxCluster*3 + faces)/pics.length)*100 + 1
		score = (maxCluster.to_f / pics.length) * 100
		Rails.logger.info "SCORE: #{score}"
		deleteFaces()
		return score
	end

	def addFaces( pic )
		uri = URI('http://rekognition.com/func/api/')
		res = Net::HTTP.post_form(
					uri,
					'api_key' => @api_key,
					'api_secret' => @api_secret,
					'user_id' => @user_id,
					'jobs' => 'face_add_aggressive',
					'urls' => pic)
		return JSON.parse(res.body)
	end

	def countFaces(images)
		count = 0
		images.each do |image|
			if image["face_detection"]
				count += image["face_detection"].length
			end
		end
		return count
	end

	def clusterFaces()
		uri = URI('http://rekognition.com/func/api/')
		res = Net::HTTP.post_form(
					uri,
					'api_key' => @api_key,
					'api_secret' => @api_secret,
					'user_id' => @user_id,
					'aggressiveness' => 100,
					'jobs' => 'face_cluster')

		#figure out the size of the largest cluster
		clusters = JSON.parse(res.body)["clusters"]
		Rails.logger.info "CLusters: #{clusters}"
		totalClusterLength = 0;
		maxClusterLength = 0
		clusters.each do |cluster|
			clusterLength = cluster["img_index"].length
			totalClusterLength += clusterLength
			if( clusterLength > maxClusterLength )
				maxClusterLength = clusterLength
			end
		end
		return maxClusterLength;
	end

	def deleteFaces() #delete faces from server that are associated with this user
		uri = URI('http://rekognition.com/func/api/')
		res = Net::HTTP.post_form(
					uri,
					'api_key' => @api_key,
					'api_secret' => @api_secret,
					'user_id' => @user_id,
					'jobs' => 'face_delete')
		puts res.body
	end
end