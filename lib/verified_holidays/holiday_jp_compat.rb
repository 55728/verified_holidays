# frozen_string_literal: true

require 'verified_holidays'

# Drop-in replacement for holiday_jp gem.
# Simply replace:
#   require 'holiday_jp'
# with:
#   require 'verified_holidays/holiday_jp_compat'
HolidayJp = VerifiedHolidays unless defined?(HolidayJp)
