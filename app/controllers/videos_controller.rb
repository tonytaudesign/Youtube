class VideosController < ApplicationController
	require 'rubygems'
	require 'openssl'
	require 'digest/sha1'
	require 'base64'
	require 'json'

	respond_to :json

def aws_signature
	@file_name = params[:file_name]
	@mime_type = params[:mimeType]
	 
	render json: {
	  s3Policy: s3_upload_policy,
	  s3Signature: s3_upload_signature,
	  'AWSAccessKeyId' => ENV['S3_KEY'], 
	}
end
 
private

def s3_upload_policy
		Base64.encode64(
		{
		expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
		conditions: [
			[ 'starts-with', '$key', "s3UploadExample/" ],
		  { bucket: ENV["BUCKET"] },
		  { acl: 'public-read' },
		  ['starts-with', '$Content-Type', @mime_type],
		  { success_action_status: '201' }
		]
		}.to_json
		).gsub(/\n|\r/, '')
end
 
def s3_upload_signature
  Base64.encode64(
   OpenSSL::HMAC.digest(
  OpenSSL::Digest::Digest.new('sha1'),
  ENV['S3_SECRET'],
   s3_upload_policy
)
).gsub(/\n/, '')
end








 #  def aws_signature
 #  	expiration = Time.now.utc.strftime('%Y/%m/%d %H:%M:%S+00:00')
 #  	url = signed_url "", expiration
 #  	binding.pry
	# end

	# private

	# def signed_url(path, expire_date)
	# 	bucket = ENV["BUCKET"]
	# 	key = ENV["S3_KEY"]
	# 	secret = ENV["S3_SECRET"]
 #    digest = OpenSSL::Digest::Digest.new('sha1')
 #    can_string = "GET\n\n\n#{expire_date}\n/#{bucket}/#{path}"
	# 	hmac = OpenSSL::HMAC.digest(digest, secret, can_string)
	# 	signature = URI.escape(Base64.encode64(hmac).strip)
	# 	binding.pry
	# 	"https://s3.amazonaws.com/#{bucket}/#{path}?AWSAccessKeyId=#{key}&Expires=#{expire_date}&Signature=#{signature}"
 #  end

	# def encode_signs
	# 	signs = {'+' => "%2B", '=' => "%3D", '?' => '%3F', '@' => '%40',
	# 	'$' => '%24', '&' => '%26', ',' => '%2C', '/' => '%2F', ':' => '%3A',
	# 	';' => '%3B', '?' => '%3F'}
	# 	signs.keys.each do |key|
	# 	self.gsub!(key, signs[key])
	# end
	# 	self
	# end

end
