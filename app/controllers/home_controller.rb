class HomeController < ApplicationController
  def index
    @upcoming_events = Event.where("date >= ?", Time.current).order(:date).limit(6)
  end
end
