class PipposController < ApplicationController
  before_action :set_pippo, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pippos = Pippo.all
    respond_with(@pippos)
  end

  def show
    respond_with(@pippo)
  end

  def new
    @pippo = Pippo.new
    respond_with(@pippo)
  end

  def edit
  end

  def create
    @pippo = Pippo.new(pippo_params)
    @pippo.save
    respond_with(@pippo)
  end

  def update
    @pippo.update(pippo_params)
    respond_with(@pippo)
  end

  def destroy
    @pippo.destroy
    respond_with(@pippo)
  end

  private
    def set_pippo
      @pippo = Pippo.find(params[:id])
    end

    def pippo_params
      params.require(:pippo).permit(:pluto)
    end
end
