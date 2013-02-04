class BeersController < ApplicationController
  # GET /beers
  # GET /beers.json

  def index
    @beers = Beer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @beers }
    end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @beer = Beer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @beer }
    end
  end

  # GET /beers/new
  # GET /beers/new.json
  def new
    @beer = Beer.new
    @user_id = current_user.id if user_signed_in?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @beer }
    end
  end

  # GET /beers/1/edit
  def edit
    @beer = Beer.find(params[:id])
    @user_id = @beer.user_id
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(params[:beer])

    UserMailer.new_beer().deliver

    respond_to do |format|
      if @beer.save
        format.html { redirect_to @beer, :notice => 'Beer was successfully created.' }
        format.json { render :json => @beer, :status => :created, :location => @beer }
      else
        format.html { render :action => "new" }
        format.json { render :json => @beer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /beers/1
  # PUT /beers/1.json
  def update
    @beer = Beer.find(params[:id])

    respond_to do |format|
      if @beer.update_attributes(params[:beer])
        format.html { redirect_to @beer, :notice => 'Beer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @beer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer = Beer.find(params[:id])
    @beer.destroy

    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :ok }
    end
  end
  
  def like
    if user_signed_in?
      @beer = Beer.find(params[:id])
      current_user.likes_beers << @beer unless current_user.likes_beers.exists?(@beer.id)
      redirect_to :action => "show", :id => @beer.id
    else
      redirect_to :controller => 'devise/sessions', :action => "new"
    end
  end
  
  def unlike
    if user_signed_in?
      @beer = Beer.find(params[:id])
      current_user.likes_beers.delete(@beer) if current_user.likes_beers.exists?(@beer.id)
      redirect_to :action => "show", :id => @beer.id
    else
      redirect_to :controller => 'devise/sessions', :action => "new"
    end
  end
  
  def check
    if user_signed_in?
      @beer = Beer.find(params[:id])
      current_user.checks_beers << @beer unless current_user.checks_beers.exists?(@beer.id)
      flash[:notice] = 'Beer was successfully created.'
      redirect_to :action => "show", :id => @beer.id
    else
      redirect_to :controller => 'devise/sessions', :action => "new"
    end
  end

  def uncheck
    if user_signed_in?
      @beer = Beer.find(params[:id])
      current_user.checks_beers.delete(@beer) if current_user.checks_beers.exists?(@beer.id)
      redirect_to :action => "show", :id => @beer.id
    else
      redirect_to :controller => 'devise/sessions', :action => "new"
    end
  end
  
end
