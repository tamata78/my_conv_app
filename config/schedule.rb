# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# wheneverにパスを通す
env 'PATH', ENV['PATH']
# rbenvを初期化するジョブタイプを定義
job_type :rbenv_rake, %q!eval "$(rbenv init -)"; cd :path && :environment_variable=:environment bundle exec rake :task --silent :output!

# ログ出力場所
set :output, "log/cron_log.log"

# RAILS_ENVを設定する（デフォルトはproduction）
set :environment, "development"

# 毎日6時半に実行する
#every 1.day, at: '7:05 am' do
#  rbenv_rake "mail_send:send"
#end

# 1分毎にメール送信
every 1.minutes do
  rbenv_rake "mail_send:send"
end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
