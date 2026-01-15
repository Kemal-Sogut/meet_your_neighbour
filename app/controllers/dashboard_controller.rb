class DashboardController < ApplicationController
  before_action :require_login

  def index
    case current_user.role
    when "admin"
      @managed_events = Event.includes(:user, :rsvps).order(date: :desc)
      @title = "Admin Dashboard"
    when "host"
      @managed_events = current_user.events.includes(:rsvps).order(date: :desc)
      @title = "Host Dashboard"
    else # guest
      @title = "My Dashboard"
    end

    @upcoming_rsvps = current_user.rsvps
                                  .includes(event: :user)
                                  .joins(:event)
                                  .where("events.date >= ?", Time.current)
                                  .order("events.date ASC")

    @past_rsvps = current_user.rsvps
                              .includes(event: :user)
                              .joins(:event)
                              .where("events.date < ?", Time.current)
                              .order("events.date DESC")
                              .limit(5)
  end
end
