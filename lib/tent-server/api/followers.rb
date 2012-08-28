module TentServer
  class API
    class Followers
      include Router

      class Discover < Middleware
        def action(env)
          client = ::TentClient.new
          profile = client.discover(env.params[:data]['entity']).get_profile
          return [404, {}, 'Not Found'] unless profile
          return [409, {}, 'Entity Mismatch'] if profile[profile.keys.first]['entity'] != env.params[:data]['entity']
          env['profile'] = profile
          env
        end
      end

      class Create < Middleware
        def action(env)
          if follower = Model::Follower.create_follower(env.params[:data].merge('profile' => env['profile']))
            env['response'] = follower.as_json(:only => [:id, :mac_key_id, :mac_key, :mac_algorithm])
          end
          env
        end
      end

      class Get < Middleware
        def action(env)
          if follower = Model::Follower.get(env.params[:follower_id])
            env['response'] = follower.as_json(:only => [:id, :groups, :entity, :licenses, :mac_key_id, :mac_algorithm])
          end
          env
        end
      end

      class Update < Middleware
        def action(env)
          Model::Follower.update_follower(env.params[:follower_id], env.params[:data])
          env
        end
      end

      class Destroy < Middleware
        def action(env)
          if (follower = Model::Follower.get(env.params[:follower_id])) && follower.destroy
            env['response'] = ''
          end
          env
        end
      end

      post '/followers' do |b|
        b.use Discover
        b.use Create
      end

      get '/followers/:follower_id' do |b|
        b.use Get
      end

      put '/followers/:follower_id' do |b|
        b.use Update
      end

      delete '/followers/:follower_id' do |b|
        b.use Destroy
      end
    end
  end
end
