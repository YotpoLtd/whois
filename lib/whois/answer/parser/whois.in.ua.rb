#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.in.ua parser
      #
      # Parser for the whois.in.ua server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisInUa < Base

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+?)\n/
            case $1.split("-").first.downcase
              when "ok" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No entries found for domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.*)\n/
            time = $1.split(" ").last
            DateTime.strptime(time, "%Y%m%d%H%M%S").to_time
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /status:\s+(.*)\n/
            time = $1.split(" ").last
            DateTime.strptime(time, "%Y%m%d%H%M%S").to_time
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.strip.downcase }
        end

      end

    end
  end
end
