Twoweekapp::Application.routes.draw do
  
  
        match 'api/s3policy', :to => 'videos#aws_signature', via: [:get, :post]
  
end
