class VideosController < ApplicationController
  def aws_signature
 		require 'rubygems'
 		require 'openssl'
 		require 'json'

 		auth_key    = ENV['TRANSLOADIT_KEY']
 		auth_secret = ENV['TRANSLOADIT_SECRET']

		params = JSON.generate({
		  :auth => {
		    :key     => auth_key,
		    :expires => Time.now.utc.strftime('%Y/%m/%d %H:%M:%S+00:00')
		  },
		  :template_id => '3ff06ee0eec011e38d300b3da55cc2f7'
		})
		digest    = OpenSSL::Digest::Digest.new('sha1')
		signature = OpenSSL::HMAC.hexdigest(digest, auth_secret, params)

		response = {signature: signature, template_id: "3ff06ee0eec011e38d300b3da55cc2f7"}
		respond_with response
	end

end
