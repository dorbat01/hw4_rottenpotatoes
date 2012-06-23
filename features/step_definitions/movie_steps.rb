# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  page.body.should =~ regexp
end

Then /I should see the following movies: (.*)/ do |movie_list|
  movies = movie_list.split(/, /)
  movies.each do |movie|
    steps %Q{
      Then I should see #{movie}
    }
  end 
end

Then /I should not see the following movies: (.*)/ do |movie_list|
  movies = movie_list.split(/, /)
  movies.each do |movie|
    steps %Q{
      Then I should not see #{movie}
    }
  end 
end

Then /^I should see all of the movies$/ do
  rows = Movie.count
  movies = page.all(:xpath, '//table[@id="movies"]/tbody/tr')
  assert rows.should == movies.count
end

Then /^I should not see any movie$/ do
  movies = page.all(:xpath, '//table[@id="movies"]/tbody/tr')
  rows = movies.count
  assert rows.should == 0
end

When /^I check rating "([^"]*)"$/ do |rating|
  steps %Q{
    When I check "ratings_#{rating}"
  }
end

When /^I uncheck rating "([^"]*)"$/ do |rating|
  steps %Q{
    When I uncheck "ratings_#{rating}"
  }
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(/, /)
  if uncheck
    action = 'uncheck'
  else
    action = 'check'
  end
  ratings.each do |rating|
    steps %Q{
      When I #{action} rating "#{rating}"
    }
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie_name, director_name|
   steps %Q{
      Then I should see "Director: #{director_name}"
    }
end

