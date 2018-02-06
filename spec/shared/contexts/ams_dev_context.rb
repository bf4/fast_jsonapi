require 'ams'
require 'ams/document_serializer'
RSpec.shared_context 'ams_dev movie class' do
  before(:context) do
    # models
    class AMSDevModel
    end
    class AMSDevMovie < AMSDevModel
      attr_accessor :id, :name, :release_year, :actors, :owner, :movie_type
    end

    class AMSDevActor < AMSDevModel
      attr_accessor :id, :name, :email
    end

    class AMSDevUser < AMSDevModel
      attr_accessor :id, :name
    end
    class AMSDevMovieType < AMSDevModel
      attr_accessor :id, :name
    end
    # serializers
    class AMSDevActorSerializer < AMS::Serializer
      type 'actor'
      attribute :name
      attribute :email
    end
    class AMSDevUserSerializer < AMS::Serializer
      type 'user'
      attribute :name
    end
    class AMSDevMovieTypeSerializer < AMS::Serializer
      type 'movie_type'
      attribute :name
    end
    class AMSDevMovieSerializer < AMS::Serializer
      type 'movie'
      attribute :name
      attribute :release_year
      relation :actors, type: 'actors', to: :many, ids: 'object.actors.map(&:id)'
      relation :owner, type: 'owners', to: :one, id: 'object.owner&.id'
      relation :movie_type, type: 'movie-types', to: :one, id: 'object.movie_type.id'

      def foreign_key
        'movies_id'
      end
    end
    class AMSDevCollectionSerializer < AMS::IndexDocumentSerializer
      def as_json
        {
          "data": data
        }
      end
    end
  end

  after(:context) do
    classes_to_remove = %i[AMSDevMovie AMSDevMovieSerializer]
    classes_to_remove.each do |klass_name|
      Object.send(:remove_const, klass_name) if Object.constants.include?(klass_name)
    end
  end

  let(:ams_dev_actors) do
    3.times.map do |i|
      a = AMSDevActor.new
      a.id = i + 1
      a.name = "Test #{a.id}"
      a.email = "test#{a.id}@test.com"
      a
    end
  end

  let(:ams_dev_user) do
    ams_dev_user = AMSDevUser.new
    ams_dev_user.id = 3
    ams_dev_user
  end

  let(:ams_dev_movie_type) do
    ams_dev_movie_type = AMSDevMovieType.new
    ams_dev_movie_type.id = 1
    ams_dev_movie_type.name = 'episode'
    ams_dev_movie_type
  end

  def build_ams_dev_movies(count)
    count.times.map do |i|
      m = AMSDevMovie.new
      m.id = i + 1
      m.name = 'test movie'
      m.actors = ams_dev_actors
      m.owner = ams_dev_user
      m.movie_type = ams_dev_movie_type
      m
    end
  end
end
