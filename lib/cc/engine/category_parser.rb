module CC
  module Engine
    class CategoryParser
      def initialize(cop_name)
        @cop_name = cop_name
      end

      def category
        CATEGORIES[cop_name] || CATEGORIES[namespace] || DEFAULT_CATEGORY
      end

      private

      DEFAULT_CATEGORY = "Style"
      CATEGORIES = {
        "Lint" => "Style",
        "Lint/Eval" => "Security",
        "Metrics" => "Complexity",
        "Performance" => "Bug Risk",
        "Rails" => "Bug Risk",
        "Rails/ActionFilter" => "Style",
        "Rails/Delegate" => "Clarity",
        "Rails/HasAndBelongsToMany" => "Style",
        "Rails/TimeZone" => "Style",
        "Rails/Validation" => "Style",
        "Standard/SemanticBlocks" => "Style",
        "Style" => "Style",
        "Migrations/RemoveIndex" => "Performance"
      }.freeze

      attr_reader :cop_name

      def namespace
        cop_name.split("/").first
      end
    end
  end
end
