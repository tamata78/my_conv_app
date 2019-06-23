#coding: utf-8
require 'net/http'

class WeatherHelper
  #
  ##  http://www.drk7.jp/weather/ の天気予報を取得するクラス
  ##
  #

  WEATHER_EMOJI = {'晴れ'=>'&#58942;', 'くもり'=>'&#58943;', '雨'=>'&#58944;', '雪'=>'&#58945;' }

  def initiailize
    @xml = ''
  end

  #取得したXML
  attr_accessor :xml

  #
  #  本日の天気,最高気温,最低気温,天気絵文字,降水確率を戻す
  #
  # 　使い方　w, tma, tmi, e, r = WeatherHelper.simple_info(pref_code, "東京地方")
  #
  def self.simple_info(pref_code, area_id)
    weather = self.new
    weather.get_xml(pref_code)
    weather.get_area_info(area_id, Time.new.strftime("%Y/%m/%d"))
  end
  #
  # pref_code の天気予報を取得
  #
  def get_xml(pref_code)
    conn = Net::HTTP.new("www.drk7.jp")
    conn.open_timeout = 3
    conn.read_timeout = 3
    res, = conn.get("/weather/xml/#{pref_code}.xml")
    res.body.force_encoding("utf-8")
    @xml = res.body
  end

  #
  # area_id で指定したエリアの　天気,天気絵文字,降水確率　を戻す
  #
  def get_area_info(area_id, date)
    return "", "", "" unless (Regexp.new("<area id=\"#{area_id}\">.*<info date=\"#{date}\">(.*?)<\/info>.*<\/area>", Regexp::MULTILINE) =~ @xml)
   # 天気情報タグをマッチさせ、必要な情報を$1で取得
   area = $1
   area =~ /<weather>(.*)<\/weather>/mu; weather = $1
   area =~ /<range centigrade="max">(.*)<\/range>/u; temperature_max = $1
   area =~ /<range centigrade="min">(.*)<\/range>/u; temperature_min = $1
   area =~ /<period hour="06-12">(.*)<\/period/u; rain1 = $1
   area =~ /<period hour="12-18">(.*)<\/period/u; rain2 = $1
   area =~ /<period hour="18-24">(.*)<\/period/u; rain3 = $1

   return weather, temperature_max, temperature_min, emoji_weather(weather), rain1.to_i, rain2.to_i, rain3.to_i
  end

  #
  # weather の中の　晴れ、雨などをその順で絵文字に変換する
  # (Testの為に公開)
  def emoji_weather(weather)
    pos = {}
    WEATHER_EMOJI.each_key {|w|
      #雨、曇りなどの文字列が天気情報に含まれる場合、その文字列を保持
      p = weather.index(w)
      pos[p] = w if(p)
    }

    pos.keys.sort.map {|p| WEATHER_EMOJI[pos[p]]}.join('')
  end

end

