require 'test_helper'
require 'whois/answer/parser/whois.nic.tl'

class AnswerParserWhoisNicTlTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicTl
    @host   = "whois.nic.tl"
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('available.txt'))
    expected  = :available
    assert_equal_and_cached expected, parser, :status
  end

  def test_available?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('available.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :available?
  end

  def test_registered?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2003-05-23")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2009-08-05")
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2010-05-23")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com )
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
