class KnotsController < ApplicationController
  before_filter :authenticate
  before_filter :find_and_require_owner, :only => [:edit, :update, :destroy, :skip, :read, :trash, :replay]
  
  # GET /knots
  # GET /knots.xml
  def index
    @knots = current_user.knots
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @knots }
    end
  end

  # GET /knots/1
  # GET /knots/1.xml
  def show
    @knot = Knot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @knot }
    end
  end

  # GET /knots/new
  # GET /knots/new.xml
  def new
    @knot = Knot.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @knot }
    end
  end

  # GET /knots/1/edit
  def edit
  end

  # POST /knots
  # POST /knots.xml
  def create
    @knot = Knot.new(params[:knot])
    @knot.user = current_user

    respond_to do |format|
      if @knot.save
        flash[:notice] = 'Knot was successfully created.'
        format.html { redirect_to(knots_path) }
        format.xml  { render :xml => @knot, :status => :created, :location => @knot }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @knot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /knots/1
  # PUT /knots/1.xml
  def update

    respond_to do |format|
      if @knot.update_attributes(params[:knot])
        flash[:notice] = 'Knot was successfully updated.'
        format.html { redirect_to(knots_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @knot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /knots/1
  # DELETE /knots/1.xml
  def destroy
    @knot.destroy
    flash[:notice] = I18n.t('controllers.knots.destroy.success')
    respond_to do |format|
      format.html { redirect_to(knots_url) }
      format.xml  { head :ok }
    end
  end
  
  # Custom workflow actions
  
  # GET /knots/1/skip
  def skip
    @knot.read!
    flash[:notice] = I18n.t('controllers.knots.skip.success')
    respond_to do |format|
      format.html { redirect_to(knots_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /knots/1/replay
  def replay
    @knot.unread!
    flash[:notice] = I18n.t('controllers.knots.replay.success')
    respond_to do |format|
      format.html { redirect_to(knots_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /knots/1/trash
  def trash
    @knot.trash!
    flash[:notice] = I18n.t('controllers.knots.trash.success')
    respond_to do |format|
      format.html { redirect_to(knots_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /knots/1/read
  def read
    @knot.read!
    redirect_to @knot.url
  end
  
protected
  def find_and_require_owner
    @knot = current_user.knots.find(params[:id])
    deny_access(I18n.t("controllers.knots.require_owner.denied")) unless @knot
  end
end