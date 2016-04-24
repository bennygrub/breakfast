class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :preview]
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
    params[:event][:event_date] = DateTime.strptime(event_date, "%Y-%m-%d %I:%M:%S %p")
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def update
    event_date = "#{params[:event][:event_date_date]} #{params[:event][:event_date_hour]}:#{params[:event][:event_date_min]}:00 #{params[:event][:event_date_time].upcase}"
    params[:event][:event_date] = DateTime.strptime(event_date, "%Y-%m-%d %I:%M:%S %p")
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

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :description, :event_date)
    end

    def admin_only
      redirect_to root_path, flash: {error: "You are not authorized to use this page"} unless current_user
    end
end
