class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :preview, :invite_list, :invited, :send_invites, :generate_csv]
  before_action :admin_only
  
  respond_to :html

  def index
    @events = Event.all
    respond_with(@events)
  end

  def show
    @participants = @event.participants
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
  end

  def create
    event_date = "#{params[:event][:event_date_date]} #{params[:event][:event_date_hour]}:#{params[:event][:event_date_min]}:00 #{params[:event][:event_date_time].upcase}"
    begin
      params[:event][:event_date] = DateTime.strptime(event_date, "%m/%d/%Y %I:%M:%S %p")
    rescue
      params[:event][:event_date] = DateTime.strptime(event_date, "%Y-%m-%d %I:%M:%S %p")
    end
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def update
    event_date = "#{params[:event][:event_date_date]} #{params[:event][:event_date_hour]}:#{params[:event][:event_date_min]}:00 #{params[:event][:event_date_time].upcase}"
    begin
      params[:event][:event_date] = DateTime.strptime(event_date, "%m/%d/%Y %I:%M:%S %p")
    rescue
      params[:event][:event_date] = DateTime.strptime(event_date, "%Y-%m-%d %I:%M:%S %p")
    end
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    @event.destroy
    respond_with(@event)
  end

  def preview
    
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@event.name}/#{@event.id}.pdf",
        layout: 'layouts/application.pdf.haml',
        show_as_html: params[:debug].present?,
        :page_size  => "Letter",
        :dpi => '300',
        margin: { top: 10, bottom: 0, right: 8, left: 8 },
        :save_to_file => Rails.root.join('public', "#{@event.name}#{@event.id}.pdf")
      end
    end
  end

  def invite_list
    @unsent = @event.invites.where(sent: false)
    @sent = @event.invites.where(sent: true)
    @invites = []
    
    if @sent.count > 0
      5.times do
        @invites << Invite.new
      end
    else
      30.times do
        @invites << Invite.new
      end
    end
  end

  def send_invites
    params[:invites].each do |invite|
      unless invite[:name].blank? || invite[:email].blank?
        Invite.create(event_id: @event.id, name: invite[:name], email: invite[:email], sent: true)
        InviteMailer.send_invite(invite[:name], invite[:email], @event.id).deliver
      end
    end
    flash[:notice] = "Email have been sent"
    redirect_to invited_event_path(@event)
  end

  def generate_csv
    require 'csv'
    respond_to do |format|
      format.csv do
        @participants = @event.participants
        headers = ["Event Name", "Name", "Email", "Title", "Division", "Biography"]
        
        @downloadable = CSV.generate(headers: true) do |csv|
          csv << headers
          @participants.each do |participant|
            csv << [@event.name, participant.name, participant.email, participant.title, participant.division, participant.biography]
          end
        end
        send_data @downloadable, filename: "participants-#{Date.today}.csv"
      end
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :description, :event_date, :venue, :focus_area)
    end

    def admin_only
      redirect_to root_path, flash: {error: "You are not authorized to use this page"} unless current_user
    end
end
