module TentServer
  module Model
    class Post
      include DataMapper::Resource

      storage_names[:default] = "posts"

      property :id, Serial
      property :entity, URI
      property :scope, Enum[:public, :limited, :direct], :default => :direct
      property :type, URI
      property :licenses, Array
      property :groups, Array
      property :recipients, Array
      property :content, Json
      property :published_at, DateTime
      property :received_at, DateTime
    end

    alias :original_as_json :as_json
    def as_json(options = {})
      original_as_json({
        
      }).merge(options)
    end
  end
end