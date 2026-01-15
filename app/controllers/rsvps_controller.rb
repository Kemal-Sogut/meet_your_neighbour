class RsvpsController < ApplicationController
  before_action :require_login
  before_action :set_event

  def create
    unless @event.rsvp_open?
      redirect_to @event, alert: "RSVPs for this event are now closed."
      return
    end

    if @event.full?
      redirect_to @event, alert: "This event is at full capacity."
      return
    end

    @rsvp = @event.rsvps.build(user: current_user, status: params[:status] || :confirmed)

    if @rsvp.save
      redirect_to @event, notice: "RSVP submitted successfully!"
    else
      redirect_to @event, alert: @rsvp.errors.full_messages.join(", ")
    end
  end

  def destroy
    @rsvp = current_user.rsvps.find_by(event: @event)
    @rsvp&.destroy
    redirect_to @event, notice: "RSVP cancelled."
  end

  # Host/Admin can cancel a guest's RSVP
  def cancel
    unless current_user&.admin? || current_user == @event.user
      redirect_to @event, alert: "You are not authorized to cancel RSVPs."
      return
    end

    @rsvp = @event.rsvps.find(params[:id])
    guest_name = @rsvp.user.username
    @rsvp.destroy
    redirect_to @event, notice: "#{guest_name}'s RSVP has been cancelled."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
