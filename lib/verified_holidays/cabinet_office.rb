# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'csv'
require 'date'

module VerifiedHolidays
  class CabinetOffice
    CSV_URL = 'https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv'

    def self.fetch
      uri = URI.parse(CSV_URL)
      response = Net::HTTP.get(uri)

      # Remove UTF-8 BOM bytes if present (before encoding conversion)
      raw = response.b
      raw = raw.byteslice(3..) if raw.byteslice(0, 3) == "\xEF\xBB\xBF".b

      # Convert from CP932 (Shift_JIS) to UTF-8
      utf8 = raw.force_encoding('CP932').encode('UTF-8')

      parse(utf8)
    end

    def self.parse(csv_string)
      holidays = {}
      CSV.parse(csv_string, headers: true) do |row|
        date_str = row[0]&.strip
        name = row[1]&.strip
        next if date_str.nil? || name.nil?

        holidays[parse_date(date_str)] = name
      end
      holidays
    end

    def self.parse_date(date_str)
      parts = date_str.split('/')
      Date.new(parts[0].to_i, parts[1].to_i, parts[2].to_i)
    end
    private_class_method :parse_date
  end
end
