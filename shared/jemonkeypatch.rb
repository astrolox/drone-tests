module Specinfra
  module Backend
    class Docker < Exec
      def send_file(from, to)
        if @container
          # This needs Docker >= 1.8
          puts "Putting file #{from} into container #{@container.id}" if get_config(:docker_debug)
          @container.archive_in(from, to)
        elsif @base_image
          puts "Putting file #{from} into image #{@base_image.id}" if get_config(:docker_debug)
          @images << commit_container if @container
          @images << current_image.insert_local('localPath' => from, 'outputPath' => to)
          cleanup_container
          create_and_start_container
        else
          fail 'Cannot call send_file without docker_image or docker_container.'
        end
      end

      private

      def create_and_start_container
        opts = { 'Image' => current_image.id }

        if current_image.json["Config"]["Cmd"].nil? && current_image.json["Config"]["Entrypoint"].nil?
          opts.merge!({'Cmd' => ['/bin/sh']})
        end

        opts.merge!({'OpenStdin' => true})

        if path = get_config(:path)
          (opts['Env'] ||= []) << "PATH=#{path}"
        end

        env = get_config(:env).to_a.map { |v| v.join('=') }
        opts['Env'] = opts['Env'].to_a.concat(env)

        opts.merge!(get_config(:docker_container_create_options) || {})

        @container = ::Docker::Container.create(opts)
        @container.start
        puts "Container started: #{@container.id}" if get_config(:docker_debug)

        if get_config(:docker_container_ready_regex) then

          counter=0
          timeout = get_config(:docker_container_start_timeout) or 30
          while counter < timeout do
            match = @container.logs({ :stdout => true }).split("\n").grep(get_config(:docker_container_ready_regex))
            puts "Waiting for matching regex: #{get_config(:docker_container_ready_regex)}" if get_config(:docker_debug)
            unless match.empty? then
              puts "Container #{@container.id} is ready." if get_config(:docker_debug)
              break
            end
            puts "Sleeping for 5 seconds while container starts up...#{counter}/#{timeout}" if get_config(:docker_debug)
            sleep 5
            counter += 5
          end
          if counter >= timeout then
            @container.kill unless get_config(:docker_debug)
            @container.delete(:force => true) unless get_config(:docker_debug)
            fail "Container #{@container} did not start in time."
          end
        end
      end
    end
  end
end
