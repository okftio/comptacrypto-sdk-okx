# frozen_string_literal: true

require "time"
require "timecop"

iso8601_path = "spec/CURRENT_TIME.iso8601"

# To perform signed requests on OKX, we need to send the present timestamp
# as a querystring parameter.  Otherwise, this error may occur:
#
#   (-1021) Timestamp for this request was 1000ms ahead of the server's time.
#
# To be sure that our time is correct, and that it is not greater than
# OKX's, we will lock out testing environment time to its internal clock.

iso8601_datetime = Comptacrypto::Sdk::Okx::Client.new.time.body.fetch("iso")

File.write(iso8601_path, "#{iso8601_datetime}\n") unless File.exist?(iso8601_path)
iso8601 = File.read(iso8601_path).chomp
Timecop.freeze(iso8601)
