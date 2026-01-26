class Api::BasePresenter
  include ActionView::Helpers::TextHelper

  def duration_text(duration_in_seconds)
    return "0 seconds" if duration_in_seconds.blank?

    seconds = duration_in_seconds.to_i

    if seconds >= 3600
      hours = (seconds / 3600.0).round(1)
      pluralize(hours, "hour")
    elsif seconds >= 60
      minutes = (seconds / 60.0).round
      pluralize(minutes, "minute")
    else
      pluralize(seconds, "second")
    end
  end
end
