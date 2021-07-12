require "rubocop/config_obsoletion"
require "rubocop/config_validator"

module RuboCopConfigObsoletionRescue
  def reject_obsolete!
    super
  rescue RuboCop::ValidationError => e
    warn e.message
  end
end

RuboCop::ConfigObsoletion.prepend RuboCopConfigObsoletionRescue

module RuboCopConfigValidatorRescue
  def alert_about_unrecognized_cops(invalid_cop_names)
    super
  rescue RuboCop::ValidationError => e
    warn e.message
  end
end

RuboCop::ConfigValidator.prepend RuboCopConfigValidatorRescue
