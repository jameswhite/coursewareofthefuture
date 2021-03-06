Given(/^I am signed in as (.*)$/) do |name|
  if name =~ /instructor/
    user = Fabricate(:instructor)
    case name
    when /for that course/
      @course.users << user
    when /for a course/
      @course = Fabricate(:course)
      @course.users << user
    when /for those courses/
      user.courses << Course.active_or_future.all
    end
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name =~ /student/
    user = Fabricate(:student)
    if name =~ /in that course/
      @course.users << user
    end
    sign_into_github_as(user.github_username, user.github_uid)
  else
    user = User.where(name: name).first
    sign_into_github_as(user.github_username, user.github_uid)
  end
  visit '/users/auth/github'
  @user = User.find_by_github_username(user.github_username)
end

Given(/^I am signed in to Github as "(.*?)"$/) do |username|
  sign_into_github_as(username)
end

When(/^I sign out$/) do
  click_link "Sign Out"
end

When(/^sign in as a student in that course$/) do
  step "I am signed in as a student in that course"
end

def sign_into_github_as(username, uid = nil)
  if uid.nil?
    user = User.find_by_github_username(username)
    uid = user.try(:github_uid) || '12345'
  end
  OmniAuth.config.add_mock(:github, {
    uid: uid,
    credentials: {
      token: "d141ef15f79ca4c6f43a8c688e0434648f277f20",
    },
    info: {
      nickname: username,
      email: "#{username}smith@example.com",
      name: "#{username.capitalize} Smith",
      image: "http://avatars.github.com/#{username}",
    },
    extra: {
      raw_info: {
        location: 'San Francisco',
        gravatar_id: '123456789'
      }
    }
  })
end
