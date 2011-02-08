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
      # = whois.example.com parser
      #
      # Parser for the whois.example.com server.
      #
      class WhoisExampleCom < Base

        # Public: Gets the registry disclaimer that comes with the answer.
        #
        # Returns a String with the disclaimer if available,
        # <tt>nil</tt> otherwise.
        property_supported :disclaimer do
          nil
        end


        # Public: Gets the domain name as stored by the registry.
        #
        # Returns a String with the domain name if available,
        # <tt>nil</tt> otherwise.
        property_supported :domain do
          nil
        end

        # Public: Gets the unique domain ID as stored by the registry.
        #
        # Returns a String with the domain ID if available,
        # <tt>nil</tt> otherwise.
        property_supported :domain_id do
          nil
        end


        # Public: Gets the record status or statuses.
        #
        # Returns a String/Array with the record status if available,
        # <tt>nil</tt> otherwise.
        property_supported :status do
          nil
        end

        # Public: Checks whether this record is available.
        #
        # Returns true/false depending whether this record is available.
        property_supported :available? do
          nil
        end

        # Public: Checks whether this record is registered.
        #
        # Returns true/false depending this record is available.
        property_supported :registered? do
          nil
        end


        # Public: Gets the date the record was created,
        # according to the registry answer.
        #
        # Returns a Time object representing the date the record was created or
        # <tt>nil</tt> otherwise.
        property_supported :created_on do
          nil
        end

        # Public: Gets the date the record was last updated,
        # according to the registry answer.
        #
        # Returns a Time object representing the date the record was last updated or
        # <tt>nil</tt> if not available.
        property_supported :updated_on do
          nil
        end

        # Public: Gets the date the record is set to expire,
        # according to the registry answer.
        #
        # Returns a Time object representing the date the record is set to expire or
        # <tt>nil</tt> if not available.
        property_supported :expires_on do
          nil
        end


        # Public: Gets the registrar object containing the registrar details
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Registrar</tt> representing the registrar or
        # <tt>nil</tt> if not available.
        property_supported :registrar do
          nil
        end


        # Public: Gets the registrant contact object containing the details of the record owner
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Contact</tt> representing the registrant contact or
        # <tt>nil</tt> if not available.
        property_supported :registrant_contact do
          nil
        end

        # Public: Gets the administrative contact object containing the details of the record administrator
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Contact</tt> representing the administrative contact or
        # <tt>nil</tt> if not available.
        property_supported :admin_contact do
          nil
        end

        # Public: Gets the technical contact object containing the details of the technical representative
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Contact</tt> representing the technical contact or
        # <tt>nil</tt> if not available.
        property_supported :technical_contact do
          nil
        end


        # Public: Gets the list of name server entries for this record,
        # extracted from the registry answer.
        #
        # Examples
        #
        #   nameserver
        #   # => []
        #   nameserver
        #   # => ["ns2.google.com", "ns1.google.com", "ns3.google.com"]
        #
        #
        # Returns an Array of lower case String where each String is a name server entry,
        # an empty Array if no name server was found.
        property_supported :nameservers do
          []
        end

      end

    end
  end
end
