class JdebugsController < ApplicationController
  before_action :set_jdebug, only: [:show, :edit, :update, :destroy]

  DEBUGGER = :true
  DEBU_INIT = :false
  DEBUG_COUNT = 0

  def init
    if DEBUGGER && !DEBU_INIT
      jdebug.init
      DEBU_INIT = true
    end
    query = "match (from:Jdebug)-[call:is_called_by|returns_to]->(to:Jdebug) delete call;"  
    @result = Neo4j::Session.query.delete(query)
  end

  def add(caller, callee)
    init unless DEBU_INIT
  end

  def remove

  end

  # GET /jdebugs
  # GET /jdebugs.json
  def index
    @jdebugs = Jdebug.all
  end

  # GET /jdebugs/1
  # GET /jdebugs/1.json
  def show
  end

  # GET /jdebugs/new
  def new
    @jdebug = Jdebug.new
  end

  # GET /jdebugs/1/edit
  def edit
  end

  # POST /jdebugs
  # POST /jdebugs.json
  def create
    @jdebug = Jdebug.new(jdebug_params)

    respond_to do |format|
      if @jdebug.save
        format.html { redirect_to @jdebug, notice: 'Jdebug was successfully created.' }
        format.json { render :show, status: :created, location: @jdebug }
      else
        format.html { render :new }
        format.json { render json: @jdebug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jdebugs/1
  # PATCH/PUT /jdebugs/1.json
  def update
    respond_to do |format|
      if @jdebug.update(jdebug_params)
        format.html { redirect_to @jdebug, notice: 'Jdebug was successfully updated.' }
        format.json { render :show, status: :ok, location: @jdebug }
      else
        format.html { render :edit }
        format.json { render json: @jdebug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jdebugs/1
  # DELETE /jdebugs/1.json
  def destroy
    @jdebug.destroy
    respond_to do |format|
      format.html { redirect_to jdebugs_url, notice: 'Jdebug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jdebug
      @jdebug = Jdebug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jdebug_params
      params[:jdebug]
    end
end
