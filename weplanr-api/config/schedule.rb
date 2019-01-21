require 'rails'

def sydney_time time
  time
  # not needed if server tz is Australia/Sydney
  #TZInfo::Timezone.get('Australia/Sydney').local_to_utc(Time.parse(time))
end

every 1.day, at: sydney_time('12am') do
  runner 'UpdateQuotesForExpiryJob.perform'
  #runner 'GenerateSitemapJob.perform'
  runner 'ChargeQuotesOnDueJob.perform'
  #runner 'TriggerPayoutsJob.perform'
end

#every :day, at: sydney_time('7am') do
  #runner 'NotifyOfNewUsersJob.perform'
#end
#every :day, at: sydney_time('1pm') do
  #runner 'NotifyOfNewUsersJob.perform'
#end

every :sunday, at: sydney_time('12am') do
  runner 'SendWeeklyMessagesSummaryJob.perform'
end
