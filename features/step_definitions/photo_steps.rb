Then(/^my photo should be "(.*?)"$/) do |arg1|
  page.find('img#user_photo')['src'].should have_content(arg1)
end