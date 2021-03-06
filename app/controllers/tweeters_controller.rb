class TweetersController < ApplicationController
  before_filter :get_client, only: :authentication
  before_filter :check_admin, only: [:admin_credentials, :save_admin_credentials]

  def admin_credentials
    @tweeter = current_user.tweeter
  end

  def save_admin_credentials
    current_user.tweeter.update_attributes! params[:tweeter]
    redirect_to logout_path
  end

  def authentication
    access_token = @client.authorize(
      session[:r_token].token,
      session[:r_token].secret,
      :oauth_verifier => params[:oauth_verifier]
    )
    current_user.tweeter.update_attributes! token: access_token.token, secret: access_token.secret
    redirect_to tweets_path
  end

  def twitter_credentials
    request_token = get_client.request_token(oauth_callback: authentication_url)
    session[:r_token] = request_token
    redirect_to request_token.authorize_url
  end
end
