class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_Week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    binding.pry
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

  def get_Week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
   
    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday + x # wdayメソッドを用いて取得した数値
      if wday_num >= 7   #「wday_numが7以上の場合」という条件式

      if Date.today.wday >= 7
        wday_num = wday_num -7
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date + x).day, :plans => today_plans, :wday => wdays[wday_num]}
      @week_days.push(days)
    end

  end
end

# [1]　→　[Date.today.wday + x]
# wdays[1] →　wdays[Date.today.wday + x]
#wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']wdaysから曜日を取り出すには、wdays[添字]
#7.times do |x| xは7週するので、x=0 ~ x=6 まで代入される。
# Date.today.wday　→ 今日の曜日に対して　0~6の数字で返す　例:今日が月曜日ならDate.today.wday
