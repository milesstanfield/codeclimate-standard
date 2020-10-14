module CC
  module Engine
    class SourceFile
      def initialize(builds_config:, io:, path:, root:)
        @builds_config = builds_config
        @io = io
        @path = path
        @root = root
      end

      def inspect
        rubocop_team.investigate(processed_source).offenses.each do |offense|
          next if offense.disabled?

          io.print Issue.new(offense, display_path).to_json
          io.print "\0"
        end
      end

      private

      attr_reader :builds_config, :io, :path, :root

      def processed_source
        RuboCop::ProcessedSource.from_file(path, target_ruby_version)
      end

      def config_store
        builds_config.rubocop_config_store.for_file(path)
      end

      def target_ruby_version
        config_store.target_ruby_version
      end

      def rubocop_team
        cop_classes = RuboCop::Cop::Registry.all
        registry = RuboCop::Cop::Registry.new(cop_classes, builds_config.rubocop_options)

        RuboCop::Cop::Team.new(registry, config_store, display_cop_names: false)
      end

      def display_path
        realpath = Pathname.new(root).realpath.to_s
        path.gsub(%r{^#{realpath}/}, "")
      end
    end
  end
end
