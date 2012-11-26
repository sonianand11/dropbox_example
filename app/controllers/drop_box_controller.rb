require 'dropbox_sdk'

class DropBoxController < ApplicationController
 def index

    d_session = DropboxSession.new( 'mg1ywuu598hjzdf', '38j7f18t2pnofix')
    session[:d_session] = d_session
    d_session.get_request_token

    authorize_url = d_session.get_authorize_url("http://localhost:3000/authorized_callback")
    redirect_to authorize_url

 end

 def authorized_callback

   d_session =  session[:d_session]

   d_session.get_access_token

   @client = DropboxClient.new(d_session, :app_folder)
   file = open("#{Rails.root}/README.rdoc")
   response = @client.put_file("/README.rdoc", file)
   @share = @client.shares("README.rdoc")
   @file_metadata = @client.metadata('/')

   @file_metadata["contents"].each do |file|
     contents, @metadata = @client.get_file_and_metadata("#{file["path"]}")
     open("#{Rails.root}/#{file["path"]}", 'w') {|f| f.puts contents }
   end


   respond_to do |format|
     format.html
   end

 end

end
