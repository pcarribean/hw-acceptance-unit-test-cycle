class Movie < ActiveRecord::Base
  def self.all_ratings
        return ["G", "PG", "PG-13", "NC-17", "R"]
  end
    
  def self.get_ratings(ratings_list)
      if ratings_list.present?
          self.where(:rating => ratings_list)
      end
  end
    
  def self.get_sorted_ratings(ratings_list, sort_by)
      if ratings_list.present? && sort_by.present?
          self.where(:rating => ratings_list).order(sort_by)
      end
  end
  
  def self.similar_movies(movie_title)
    director = Movie.find_by(title: movie_title).director
    return nil if director.blank? or director.nil?
    Movie.where(director: director).pluck(:title)
  end
  
end