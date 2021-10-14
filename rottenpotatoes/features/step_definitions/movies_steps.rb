
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then /^the director of "(.*)" should be "(.*)"$/ do |movie_name, director_val|
  movie = Movie.find_by_title(movie_name)
  expect(movie.director).to eq director_val
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

Then /I should see (\d+) movies$/ do |movie_count|
  ui_table = page.body
  ui_row_count = ui_table.scan(/<tr>/).length - 1
  ui_row_count.should be movie_count.to_i
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  ui_table = page.body
  (ui_table.index(e1.to_s) < ui_table.index(e2.to_s)).should be true
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/\s*,\s*/).each do |rating|
    if uncheck.nil?
      step %Q{I check "ratings_#{rating}"}
    else
      step %Q{I uncheck "ratings_#{rating}"}
    end
  end
end

Then /I should see all the movies/ do
  ui_table = page.body
  ui_movie_count = ui_table.scan(/<tr>/).length - 1
  ui_movie_count.should be Movie.count
end