class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #before_filter :authenticate_user_from_token!

  private
  # For this example, we are simply using token authentication 
  # via parameters. However, anyone could use Rails's token
  # authentication features to get the token from a header.
  def authenticate_user_from_token!
    user_token = params[:auth_token] || request.headers["HTTP_AUTH_TOKEN"]
    user       = user_token && User.find_by_authentication_token(user_token)
    if !user || user.authentication_token != user_token
       render :json => {:success=>false, :message=>"You are not authorized to perform this action"}, :status=>401 if !params[:controller].include?('admin')    
    end
  end
end

#Change the default _id to id
module Mongoid
  module Document
    def as_json(options={})
      attrs = super(options)
      attrs["id"] = attrs["_id"].to_s
      attrs.delete("_id")
      attrs
    end
  end
end