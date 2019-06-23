class DailyInfoMailer < Jpmobile::Mailer::Base
  default from: "from@example.com"

  def post_daily_info_email()
    addressArray = "sample@aaa.com"

    # weather info
    today = Date.today
    @weather_info, @temperature_max, @temperature_min, @emoji, *rain_rates = WeatherHelper.simple_info(13, "東京地方")
    @rain_rates = rain_rates

    # calendar info
    @events = GoogleCalendarHelper.get_event_info

    #send mail
    mail to: addressArray, subject: today.month.to_s + "/" + today.day.to_s + "のお知らせ"
  end
end
