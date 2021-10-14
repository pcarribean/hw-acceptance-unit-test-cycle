require 'rails_helper'
 describe Movie do
  describe 'Test for movies by same director' do
    let!(:movie1) { FactoryGirl.create(:movie, title: 'Memento', director: 'Christopher Nolan') }
    let!(:movie2) { FactoryGirl.create(:movie, title: 'Titanic', director: 'James Cameron') }
    let!(:movie3) { FactoryGirl.create(:movie, title: "Tenet", director: 'Christopher Nolan') }
    let!(:movie4) { FactoryGirl.create(:movie, title: "NoDirector") }
     context 'Movie has a director' do
      it 'Finds the movies by same director correctly' do
        expect(Movie.similar_movies(movie1.title)).to eql(['Memento', "Tenet"])
        expect(Movie.similar_movies(movie1.title)).to_not include(['Titanic'])
        expect(Movie.similar_movies(movie2.title)).to eql(['Titanic'])
      end
    end
     context 'Movie does not have a director' do
      it 'Sad Path scenario' do
        expect(Movie.similar_movies(movie4.title)).to eql(nil)
      end
    end
  end
 describe 'Test to return all the ratings' do
    it 'Returns all ratings' do
      expect(Movie.all_ratings).to match(%w(G PG PG-13 NC-17 R))
    end
  end
 describe 'Test for filtering and sorting movies based on ratings' do
  let!(:movie1) { FactoryGirl.create(:movie, title: 'Memento', rating: 'PG-13', release_date: '2002-01-03', director: 'Christopher Nolan') }
  let!(:movie2) { FactoryGirl.create(:movie, title: 'Titanic', rating: 'R', release_date: '1997-05-04',  director: 'James Cameron') }
  let!(:movie3) { FactoryGirl.create(:movie, title: 'Tenet', rating: 'PG-13', release_date:'2020-10-10', director: 'Christopher Nolan') }
  let!(:movie4) { FactoryGirl.create(:movie, title: 'Alien', release_date: '2000-12-10', rating: 'G') }
  it 'Return movies filtered using given ratings' do
   filtered_movies = Array.new
   ratings_list = ['PG-13']
   (Movie.get_ratings(ratings_list)).each do |movies|
    filtered_movies.append(movies.title)
   end
   expect(filtered_movies).to eql(['Memento', 'Tenet'])
  end
  it 'Return movies sorted using given sorting criteria' do
   sorted_movies = Array.new
   ratings_list = ['PG-13']
   (Movie.get_sorted_ratings(ratings_list, "title")).each do |movies|
    sorted_movies.append(movies.title)
   end
   expect(sorted_movies).to eql(['Memento', 'Tenet'])
  end
 end
end