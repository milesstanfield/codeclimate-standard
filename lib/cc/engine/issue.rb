require "safe_yaml"
require "cc/engine/content_resolver"

SafeYAML::OPTIONS[:default_mode] = :safe

module CC
  module Engine
    class Issue < SimpleDelegator
      DEFAULT_REMEDIATION_POINTS = 50_000
      DEFAULT_BASE_POINTS = 200_000

      def initialize(issue, path)
        super(issue)
        @path = path
      end

      # rubocop:disable Metrics/MethodLength
      def to_json(*_)
        hash = {
          type: "Issue",
          check_name: check_name,
          description: message,
          categories: [category],
          remediation_points: remediation_points,
          location: {
            path: path,
            positions: positions
          }
        }
        hash[:content] = {body: content_body} if content_body.present?

        if (fingerprint = Fingerprint.new(path, cop_name, message).compute)
          hash[:fingerprint] = fingerprint
        end

        hash.to_json
      end
      # rubocop:enable Metrics/MethodLength

      def check_name
        "Rubocop/#{cop_name}"
      end

      def remediation_points
        DEFAULT_REMEDIATION_POINTS
      end

      private

      attr_reader :path

      def expand_config_path(path)
        File.expand_path("../../../../config/#{path}", __FILE__)
      end

      def category
        CategoryParser.new(cop_name).category
      end

      def positions
        {
          begin: {
            column: columns.first,
            line: lines.first
          },
          end: {
            column: columns.last,
            line: lines.last
          }
        }
      end

      # Increments column values as columns are 0-based in parser
      def columns
        return @columns if defined?(@columns)

        end_column = location.try(:last_column) || location.column
        @columns = [location.column + 1, end_column + 1]
      end

      def lines
        return @lines if defined?(@lines)

        begin_line = location.try(:first_line) || location.line
        end_line = location.try(:last_line) || location.line
        @lines = [begin_line, end_line]
      end

      def content_body
        return @content_body if defined?(@content_body)

        @content_body = ContentResolver.new(cop_name.underscore).content
      end
    end
  end
end
