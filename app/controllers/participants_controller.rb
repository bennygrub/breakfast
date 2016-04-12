class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    #@participants = Participant.all
    @event = Event.find(params[:event_id])
    respond_with(@event)
  end

  def show
    respond_with(@participant)
  end

  def new
    @event = Event.find(params[:event_id])
    @participant = Participant.new(event_id: @event, email: params[:invite_email], name: params[:invite_name] )
    respond_with(@participant)
  end

  def edit
  end

  def create
    @participant = Participant.new(participant_params)
    @participant.save
    @event = Event.find(@participant.event_id)
    redirect_to event_participant_path(@event, @participant)
  end

  def update
    @participant.update(participant_params)
    respond_with(@participant)
  end

  def destroy
    @event = Event.find(params[:event_id])
    @participant.destroy
    redirect_to event_participants_path(params[:event_id])
  end

  private
    def set_participant
      @participant = Participant.find(params[:id])
    end

    def participant_params
      params.require(:participant).permit(:event_id, :name, :email, :title, :division, :biography)
    end
end
