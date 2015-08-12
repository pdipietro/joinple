class MailCollectorsController < ApplicationController
  before_action :set_mail_collector, only: [:show, :edit, :update, :destroy]

  # GET /mail_collectors
  # GET /mail_collectors.json
  def index
    @mail_collectors = MailCollector.all
  end

  # GET /mail_collectors/1
  # GET /mail_collectors/1.json
  def show
  end

  # GET /mail_collectors/new
  def new
    @mail_collector = MailCollector.new
  end

  # GET /mail_collectors/1/edit
  def edit
  end

  # POST /mail_collectors
  # POST /mail_collectors.json
  def create
    @mail_collector = MailCollector.new(mail_collector_params)
    @mail_collector.ip_address = caller_ip

    respond_to do |format|
      if @mail_collector.save
        format.js { render :new, object: MailCollector.new, locals: { line: "line_4" } }
      else
        format.js { render :new, object: @mail_collector, locals: { line: "line_3" } }
      end
    end
  end

  # PATCH/PUT /mail_collectors/1
  # PATCH/PUT /mail_collectors/1.json
  def update
    respond_to do |format|
      if @mail_collector.update(mail_collector_params)
        format.html { redirect_to @mail_collector, notice: 'Mail collector was successfully updated.' }
        format.json { render :show, status: :ok, location: @mail_collector }
      else
        format.html { render :edit }
        format.json { render json: @mail_collector.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_collector
      @mail_collector = MailCollector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_collector_params
      params.require(:mail_collector).permit(:email)
    end
end
