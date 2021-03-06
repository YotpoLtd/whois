require "spec_helper"

describe Whois::Server do

  describe ".definitions" do
    it "returns the definitions hash when type argument is nil" do
      with_definitions do
        d = klass.definitions
        d.should be_a(Hash)
        d.keys.should =~ [:tld, :ipv4, :ipv6]
      end

      with_definitions do
        d = klass.definitions(nil)
        d.should be_a(Hash)
        d.keys.should =~ [:tld, :ipv4, :ipv6]
      end
    end

    it "returns the definitions array for given type when type argument is not nil and given type exists" do
      with_definitions do
        Whois::Server.define(:foo, ".foo", "whois.foo")
        d = klass.definitions(:foo)
        d.should be_a(Array)
        d.should == [[".foo", "whois.foo", {}]]
      end
    end

    it "returns nil when type argument is not nil and given type doesn't exist" do
      with_definitions do
        d = klass.definitions(:foo)
        d.should be_nil
      end
    end
  end

  describe ".define" do
    it "adds a new definition with given arguments" do
      with_definitions do
        Whois::Server.define(:foo, ".foo", "whois.foo")
        klass.definitions(:foo).should == [[".foo", "whois.foo", {}]]
      end
    end

    it "accepts a hash of options" do
      with_definitions do
        Whois::Server.define(:foo, ".foo", "whois.foo", :foo => "bar")
        klass.definitions(:foo).should == [[".foo", "whois.foo", { :foo => "bar" }]]
      end
    end

    it "accepts any kind of definition type" do
      with_definitions do
        Whois::Server.define(:ipv4, ".foo", "whois.foo", :foo => "bar")
        klass.definitions(:ipv4).should == [[".foo", "whois.foo", { :foo => "bar" }]]
      end
    end
  end

  describe ".factory" do
    it "returns an adapter initialized with given arguments" do
      s = Whois::Server.factory(:tld, ".test", "whois.test")
      s.type.should == :tld
      s.allocation.should == ".test"
      s.host.should == "whois.test"
      s.options.should == Hash.new
    end

    it "returns a standard adapter by default" do
      s = Whois::Server.factory(:tld, ".test", "whois.test")
      s.should be_a(Whois::Server::Adapters::Standard)
    end

    it "accepts an :adapter option as Class and returns an instance of given adapter" do
      a = Class.new do
        attr_reader :args
        def initialize(*args)
          @args = args
        end
      end
      s = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => a)
      s.should be_a(a)
      s.args.should == [:tld, ".test", "whois.test", {}]
    end

    it "accepts an :adapter option as Symbol, load Class and returns an instance of given adapter" do
      s = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => :none)
      s.should be_a(Whois::Server::Adapters::None)
    end

    it "deletes the adapter option" do
      s = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => Whois::Server::Adapters::None, :foo => "bar")
      s.options.should == { :foo => "bar" }
    end
  end

  describe ".guess" do
    it "recognizes tld" do
      s = Whois::Server.guess(".com")
      s.should be_a(Whois::Server::Adapters::Base)
      s.type.should == :tld
    end

    it "recognizes domain" do
      s = Whois::Server.guess("example.com")
      s.should be_a(Whois::Server::Adapters::Base)
      s.type.should == :tld
    end

    it "recognizes ipv4" do
      s = Whois::Server.guess("127.0.0.1")
      s.should be_a(Whois::Server::Adapters::Base)
      s.type.should == :ipv4
    end

    it "recognizes ipv6" do
      s = Whois::Server.guess("2001:0db8:85a3:0000:0000:8a2e:0370:7334")
      s.should be_a(Whois::Server::Adapters::Base)
      s.type.should == :ipv6
    end

    it "recognizes ipv6 when zero groups" do
      s = Whois::Server.guess("2002::1")
      s.should be_a(Whois::Server::Adapters::Base)
      s.type.should == :ipv6
    end

    it "recognizes email" do
      lambda do
        s = Whois::Server.guess("email@example.org")
      end.should raise_error(Whois::ServerNotSupported, /email/)
    end

    it "recognizes irr ids" do
      s = Whois::Server.guess("asdadsads")
      s.should be_a(Whois::Server::Adapters::Base)
      s.type.should == :irr
    end

    it "raises when unrecognized value" do
      lambda do
        s = Whois::Server.guess("inva.lid")
      end.should raise_error(Whois::ServerNotFound)
    end


    context "when the input is a tld" do
      it "returns a IANA adapter" do
        Whois::Server.guess(".com").should == Whois::Server.factory(:tld, ".", "whois.iana.org")
      end

      it "returns a IANA adapter when the input is an idn" do
        Whois::Server.guess(".xn--fiqs8s").should == Whois::Server.factory(:tld, ".", "whois.iana.org")
      end
    end

    context "when the input is a domain" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:tld, ".test", "whois.test")
          Whois::Server.guess("example.test").should == Whois::Server.factory(:tld, ".test", "whois.test")
        end
      end

      it "doesn't consider the dot as a regexp pattern", :regression => true do
        with_definitions do
          Whois::Server.define(:tld, ".no.com", "whois.no.com")
          Whois::Server.define(:tld, ".com", "whois.com")
          Whois::Server.guess("antoniocangiano.com").should == Whois::Server.factory(:tld, ".com", "whois.com")
        end
      end
    end

    context "when the input is a ipv4" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:ipv4, "192.168.1.0/10", "whois.test")
          Whois::Server.guess("192.168.1.1").should == Whois::Server.factory(:ipv4, "192.168.1.0/10", "whois.test")
        end
      end

      it "raises if definition is not found" do
        with_definitions do
          Whois::Server.define(:ipv4, "192.168.1.0/10", "whois.test")
          lambda do
            Whois::Server.guess("192.192.0.1")
          end.should raise_error(Whois::AllocationUnknown)
        end
      end
    end

    context "when the input is a ipv6" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:ipv6, "2001:0200::/23", "whois.test")
          Whois::Server.guess("2001:0200::1") == Whois::Server.factory(:ipv6, "2001:0200::/23", "whois.test")
        end
      end

      it "raises if definition is not found" do
        with_definitions do
          Whois::Server.define(:ipv6, "::1", "whois.test")
          lambda {
            Whois::Server.guess("2002:0300::1")
          }.should raise_error(Whois::AllocationUnknown)
        end
      end

      it "recognizes ipv4 compatibility mode" do
        with_definitions do
          Whois::Server.define(:ipv6, "::192.168.1.1", "whois.test")
          Whois::Server.guess("::192.168.1.1") == Whois::Server.factory(:ipv6, "::192.168.1.1", "whois.test")
        end
      end

      # https://github.com/weppos/whois/issues/174
      it "rescues IPAddr ArgumentError" do
        with_definitions do
          lambda {
            Whois::Server.guess("f53")
          }.should raise_error(Whois::AllocationUnknown)
        end
      end
    end

    context "when the input is IRR id" do
      it "returns a IRR adapter" do
        Whois::Server.guess("sdfsdfsdfs").should == Whois::Server.factory(:irr, ".", "whois.radb.net")
      end
    end

  end

end
