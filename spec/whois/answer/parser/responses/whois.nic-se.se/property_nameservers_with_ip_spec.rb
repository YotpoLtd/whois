# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/whois/answer/parser/responses/whois.nic-se.se/property_nameservers_with_ip_spec.rb
#
# and regenerate the tests with the following rake task
#
#   $ rake genspec:parsers
#

require 'spec_helper'
require 'whois/answer/parser/whois.nic-se.se'

describe Whois::Answer::Parser::WhoisNicSeSe, "property_nameservers_with_ip.expected" do

  before(:each) do
    file = fixture("responses", "whois.nic-se.se/property_nameservers_with_ip.txt")
    part = Whois::Answer::Part.new(:body => File.read(file))
    @parser = klass.new(part)
  end

  context "#nameservers" do
    it do
      @parser.nameservers.should be_a(Array)
    end
    it do
      @parser.nameservers.should have(4).items
    end
    it do
      @parser.nameservers[0].should be_a(_nameserver)
    end
    it do
      @parser.nameservers[0].should == _nameserver.new(:name => "ns2.loopia.se", :ipv4 => "93.188.0.21")
    end
    it do
      @parser.nameservers[1].should be_a(_nameserver)
    end
    it do
      @parser.nameservers[1].should == _nameserver.new(:name => "ns4.loopia.se", :ipv4 => "93.188.0.20")
    end
    it do
      @parser.nameservers[2].should be_a(_nameserver)
    end
    it do
      @parser.nameservers[2].should == _nameserver.new(:name => "ns3.loopia.se", :ipv4 => "93.188.0.21")
    end
    it do
      @parser.nameservers[3].should be_a(_nameserver)
    end
    it do
      @parser.nameservers[3].should == _nameserver.new(:name => "ns1.loopia.se", :ipv4 => "93.188.0.20")
    end
  end
end
