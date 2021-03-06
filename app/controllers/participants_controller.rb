class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy, :preview, :crop]
  before_action :admin_only, except: [:new, :edit, :update, :show, :create, :crop]

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

    unless params[:crop].blank?
      @crop_me = true
    else
      @crop_me = false
    end
    @event = Event.find(params[:event_id])
  end

  def create
    @participant = Participant.new(participant_params)    
    @event = Event.find(@participant.event_id)
    #redirect_to event_participant_path(@event, @participant)
    if @participant.save
      redirect_to crop_event_participant_path(@event, @participant)
    else
      root_path
    end
  end

  def update
    @event = Event.find(@participant.event_id)
    #participant_params[:avatar].nil?
    #raise "#{participant_params}"
    @participant.update(participant_params)


    respond_with(@event, @participant)
  end

  def destroy
    @event = Event.find(params[:event_id])
    @participant.destroy
    redirect_to event_participants_path(params[:event_id])
  end

  def preview

  end

  def crop
    @event = Event.find(@participant.event_id)
  end

  def generate_link
    @event = Event.find(params[:event_id])
  end

  private
    def set_participant
      @participant = Participant.find(params[:id])
    end

    def participant_params
      params.require(:participant).permit(:event_id, :name, :email, :title, :division, :biography, :avatar, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h, :avatar_original_w, :avatar_original_h, :avatar_box_w, :avatar_aspect)
    end

    def admin_only
      redirect_to root_path, flash: {error: "You are not authorized to use this page"} unless current_user
    end
end
