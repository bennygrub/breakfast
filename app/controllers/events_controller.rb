class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :preview]

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
    params[:event][:event_date] = DateTime.strptime(event_params[:event_date], "%m/%d/%Y")
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def update
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
end
