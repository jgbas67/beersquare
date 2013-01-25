class ProfileController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    @beers_like = current_user.likes_beers
    @beers_check = current_user.checks_beers
  end
  
end
