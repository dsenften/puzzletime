# encoding: utf-8

require 'test_helper'
require 'relevance/tarantula'

class TarantulaTest < ActionDispatch::IntegrationTest
  # Load enough test data to ensure that there's a link to every page in your
  # application. Doing so allows Tarantula to follow those links and crawl
  # every page.  For many applications, you can load a decent data set by
  # loading all fixtures.
  fixtures :all

  def test_tarantula
    # If your application requires users to log in before accessing certain
    # pages, uncomment the lines below and update them to allow this test to
    # log in to your application.  Doing so allows Tarantula to crawl the
    # pages that are only accessible to logged-in users.
    #
    post '/login/login', user: 'ggg', pwd: 'Yaataw'
    follow_redirect!

    t = tarantula_crawler(self)

    t.skip_uri_patterns << /\/synchronize$/

    t.allow_404_for /^\-?\d+$/
    t.allow_404_for /projecttime\/start$/
    t.allow_404_for /attendancetime\/confirm_delete\/\d+$/
    t.allow_404_for /attendancetime\/update\/\d+$/

    t.crawl
  end
end