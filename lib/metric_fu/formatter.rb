require 'metric_fu/constantize'
module MetricFu
  module Formatter
    BUILTIN_FORMATS = {
      'html' => ['MetricFu::Formatter::HTML', 'Generates a templated HTML report using the configured template class and graph engine.'],
      'yaml' => ['MetricFu::Formatter::YAML', 'Generates the raw output as yaml']
    }
    DEFAULT = [[:html]]

    class << self
      include MetricFu::Constantize

      def class_for(format)
        if (builtin = BUILTIN_FORMATS[format.to_s])
          constantize(builtin[0])
        else
          constantize(format.to_s)
        end
      end

    end

    module Templates
      MetricFu.reporting_require { 'templates/awesome/awesome_template' }

      module_function

      def configure_template(config)
        config.add_promiscuous_instance_variable(:template_class, AwesomeTemplate)
        config.add_promiscuous_instance_variable(:link_prefix, nil)
        config.add_promiscuous_instance_variable(:darwin_txmt_protocol_no_thanks, true)
        # turning off syntax_highlighting may avoid some UTF-8 issues
        config.add_promiscuous_instance_variable(:syntax_highlighting, true)
      end

    end
  end
end
