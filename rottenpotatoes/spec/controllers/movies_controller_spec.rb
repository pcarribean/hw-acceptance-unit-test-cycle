require 'rails_helper'
 describe MoviesController do
  describe 'Test for Index Method' do
    let!(:movie) {FactoryGirl.create(:movie)}
     it 'should render the homepage' do
      get :index
      expect(response).to render_template('index')
    end
    it 'should render all movies when none of the boxes are selected' do
      get :index, {button_clicked: true}
      expect(response).to render_template('index')
    end
    it 'should render movies filtered on given ratings' do
      get :index, {ratings: {'PG-13' => 1}, button_clicked: true}
      expect(response).to render_template('index')
    end
    it 'should render movies sorted by title column' do
      get :index, {sort_by: 'title'}
      expect(response).to render_template('index')
    end
    it 'sort on title should change color of column header' do
      get :index, {sort_by: 'title'}
      expect(assigns(:title_color)).to eql('hilite')
    end
    it 'sort on release date should change color of column header' do
      get :index, {sort_by: 'release_date'}
      expect(assigns(:release_date_color)).to eql('hilite')
    end
    it 'should render movies sorted by given column and filtered on given ratings' do
      get :index, {ratings: {'PG-13' => 1} ,sort_by: 'title'}
      expect(response).to render_template('index')
    end
  end
   describe 'Test for new Method' do
    let!(:movie) { Movie.new }
     it 'should render the new movie page' do
      get :new
      expect(response).to render_template('new')
    end
  end
  describe 'Test for New Movie Creation' do
    it 'creates a new movie' do
      expect {post :create, movie: FactoryGirl.attributes_for(:movie)
      }.to change { Movie.count }.by(1)
    end
     it 'redirects to the home page' do
      post :create, movie: FactoryGirl.attributes_for(:movie)
      expect(response).to redirect_to(movies_url)
    end
  end
  describe 'Test for show movie page' do
    let!(:movie) { FactoryGirl.create(:movie) }
    before(:each) do
      get :show, id: movie.id
    end
     it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie)
    end
     it 'should render the show template' do
      expect(response).to render_template('show')
    end
  end
   describe 'Test for Edit Movie Page' do
    let!(:movie) { FactoryGirl.create(:movie) }
    before do
      get :edit, id: movie.id
    end
     it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie)
    end
     it 'should render the edit template' do
      expect(response).to render_template('edit')
    end
  end
   describe 'Test for Update Movie' do
    let(:movie1) { FactoryGirl.create(:movie) }
    before(:each) do
      put :update, id: movie1.id, movie: FactoryGirl.attributes_for(:movie, title: 'Modified')
    end
     it 'updates an existing movie' do
      movie1.reload
      expect(movie1.title).to eql('Modified')
    end
     it 'redirects to the movie page' do
      expect(response).to redirect_to(movie_path(movie1))
    end
  end
   describe 'Test for Movie Delete' do
    let!(:movie1) { FactoryGirl.create(:movie) }
     it 'destroys a movie' do
      expect { delete :destroy, id: movie1.id
      }.to change(Movie, :count).by(-1)
    end
     it 'redirects to movies#index after destroy' do
      delete :destroy, id: movie1.id
      expect(response).to redirect_to(movies_path)
    end
  end
  describe 'Test for searching movies of same director' do
     it 'should call Movie.similar_movies' do
      expect(Movie).to receive(:similar_movies).with('Tenet')
      get :search, { title: 'Tenet' }
    end
     it 'should display movies of the same director if they exist' do
      movies = ['Tenet', 'Memento']
      Movie.stub(:similar_movies).with('Tenet').and_return(movies)
      get :search, { title: 'Tenet' }
      expect(assigns(:similar_movies)).to eql(movies)
    end
     it "should redirect to home page for movies without a director" do
      Movie.stub(:similar_movies).with('NoDirector').and_return(nil)
      get :search, { title: 'NoDirector' }
      expect(response).to redirect_to(root_url) 
    end
  end
end