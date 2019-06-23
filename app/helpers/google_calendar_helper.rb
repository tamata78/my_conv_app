# Initialize the client & Google+ API
require 'google/api_client'
require "yaml"
require "time"

class GoogleCalendarHelper

  def self.get_event_info
    calendar = self.new

    client = calendar.create_client()
    cal = client.discovered_api('calendar', 'v3')

    params = calendar.create_param()

    # 今日から1ヶ月間のイベントを取得する
    result = client.execute(:api_method => cal.events.list,
                                        :parameters => params)

    #イベントの格納
    events = []
    result.data.items.each do |item|
       events << { event_date: item.start.dateTime.strftime("%m月%d日"),
                          start_time: item.start.dateTime.strftime("%H:%M"),
                          end_time: item.end.dateTime.strftime("%H:%M"),
                          summary: item.summary,
                          location: item.location }
    end
    events
  end

  def create_client()
    # Initialize OAuth 2.0 client
    # authorization
    client = Google::APIClient.new
    oauth_yaml = YAML.load_file('.google-api.yaml')
    client.authorization.client_id = oauth_yaml["client_id"]
    client.authorization.client_secret = oauth_yaml["client_secret"]
    client.authorization.scope = oauth_yaml["scope"]
    client.authorization.refresh_token = oauth_yaml["refresh_token"]
    client.authorization.access_token = oauth_yaml["access_token"]
    client
  end

  def create_param
    #今日を含めた30日
    time_now = Time.now.utc
    time_min = time_now.iso8601
    time_max = (time_now + 30*24*60*60).iso8601

    # イベントの取得
    params = {'calendarId' => 'primary',
              'orderBy' => 'startTime',
              'timeMax' => time_max,
              'timeMin' => time_min,
              'singleEvents' => 'True'}
  end

end
