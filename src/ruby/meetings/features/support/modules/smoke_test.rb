module SmokeTest
  def smoke_test
    @smoke_test ||= SmokeTest::Page.new
  end

  class Page < SitePrism::Page
    set_url '/'

    element :navbar,'nav.navbar'
    element :home_page_link,'#link-to-homepage'
    element :right_aligned_flags,'.pull-xs-right > #flags'


  end
end
World SmokeTest
