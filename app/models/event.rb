class Event < ApplicationRecord
  belongs_to :user  # The host

  has_many :rsvps, dependent: :destroy
  has_many :guests, through: :rsvps, source: :user

  # RSVP close time options (hours before event)
  RSVP_CLOSE_OPTIONS = {
    "No limit" => nil,
    "1 hour before" => 1,
    "3 hours before" => 3,
    "6 hours before" => 6,
    "12 hours before" => 12,
    "24 hours before" => 24
  }.freeze

  # Banner image options
  BANNER_OPTIONS = %w[banner-1.jpg banner-2.jpg banner-3.jpg].freeze

  validates :title, :date, :location, presence: true
  validates :capacity, numericality: { greater_than: 0 }, allow_nil: true
  validates :rsvp_closes_before, inclusion: { in: RSVP_CLOSE_OPTIONS.values }, allow_nil: true
  validates :banner_image, inclusion: { in: BANNER_OPTIONS }, allow_nil: true

  def banner_path
    banner_image.present? ? banner_image : BANNER_OPTIONS.first
  end

  def rsvp_open?
    return true if rsvp_closes_before.nil?
    return false if date.nil?
    
    Time.current < (date - rsvp_closes_before.hours)
  end

  def rsvp_closes_at
    return nil if rsvp_closes_before.nil? || date.nil?
    date - rsvp_closes_before.hours
  end

  def spots_remaining
    return nil if capacity.nil?
    capacity - rsvps.confirmed.count
  end

  def full?
    return false if capacity.nil?
    rsvps.confirmed.count >= capacity
  end
end
