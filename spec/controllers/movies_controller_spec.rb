require 'spec_helper'
     
    describe MoviesController do
      describe 'finding the similar movies directed by the director' do
        before :each do
          @mock_source_movie = [mock(Movie)]
          @mock_source_movie.stub(:director).and_return("George Lucas")
          @mock_results_movies = [mock(Movie), mock(Movie)]
        end
        it 'should call the model method that performs finding similar movies by director' do
          Movie.should_receive(:find).with("3").and_return(@mock_source_movie)
          Movie.should_receive(:find_all_by_director).with('George Lucas').and_return(@mock_results_movies)
          post :find_similar, {:id => "3"}
        end
        it 'should select the Search Results template for rendering' do
          Movie.stub(:find).and_return(@mock_source_movie)
          Movie.stub(:find_all_by_director).and_return(@mock_results_movies)
          post :find_similar, {:id => "3"}
          response.should render_template('find_similar')
        end
        it 'should make the search results available to that template' do
          Movie.stub(:find).and_return(@mock_source_movie)
          Movie.stub(:find_all_by_director).and_return(@mock_results_movies)
          post :find_similar, {:id => "3"}
          assigns(:movies).should == @mock_results_movies
        end
      end
      describe 'finding the similar movies by the director But director unknown' do
        before :each do
          @mock_source_movie = [mock(Movie)]
          @mock_source_movie.stub(:director).and_return("")
          @mock_source_movie.stub(:title).and_return("test title")
          @mock_results_all_movies = [mock(Movie), mock(Movie)]
        end
        it 'should not call the model method that performs finding similar movies by director' do
          Movie.should_receive(:find).with("1").and_return(@mock_source_movie)
          Movie.should_not_receive(:find_all_by_director).with(anything())
          post :find_similar, {:id => "1"}
        end
        it 'should select the index results template for rendering' do
          Movie.stub(:find).and_return(@mock_source_movie)
          post :find_similar, {:id => "1"}
          response.should redirect_to('/movies?')
        end
      end 
      describe 'deleting a movie' do
        before :each do
          @mock_source_movie = [mock(Movie)]
          @mock_source_movie.stub(:title).and_return("test title")
        end
        it 'should call the model method that performs deleting movie' do
          Movie.should_receive(:find).with("1").and_return(@mock_source_movie)
          @mock_source_movie.should_receive(:destroy)
          post :destroy, {:id => "1"}
        end
        it 'should final redirect to home' do
          Movie.stub(:find).and_return(@mock_source_movie)
          @mock_source_movie.stub(:destroy)
          post :destroy, {:id => "1"}
          response.should redirect_to('/movies?')     
        end
      end
    end
