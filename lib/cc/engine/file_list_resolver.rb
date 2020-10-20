module CC
  module Engine
    class FileListResolver
      def initialize(root:, builds_config:, engine_config: {})
        @root = root
        @include_paths = engine_config["include_paths"] || ["./"]
        @builds_config = builds_config
      end

      def expanded_list
        absolute_include_paths.flat_map { |path|
          find_target_files(path)
        }.compact
      end

      private

      attr_reader :builds_config, :include_paths

      def absolute_include_paths
        include_paths.map { |path| to_absolute_path(path) }.compact
      end

      def to_absolute_path(path)
        Pathname.new(path).realpath.to_s
      rescue Errno::ENOENT
        nil
      end

      def find_target_files(path)
        target_files = target_finder.find([path], :all_file_types)
        target_files.each(&:freeze).freeze
      end

      def target_finder
        @_target_finder ||= RuboCop::TargetFinder.new(builds_config.rubocop_config_store, force_exclusion: true)
      end
    end
  end
end
