# encoding: utf-8

namespace :mail_send do
  desc "必要な情報をメールで送信"

  task :send => :environment do
    DailyInfoMailer.post_daily_info_email().deliver
  end
end
