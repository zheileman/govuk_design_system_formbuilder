module GOVUKDesignSystemFormBuilder
  module Traits
    module Localisation
    private

      def localised_text(context)
        return nil unless @object_name.present? && @attribute_name.present?

        I18n.translate(localisation_key(context), default: nil) ||
          I18n.translate(localisation_key(context, html: true), default: nil).try(:html_safe)
      end

      def localisation_key(context, html: false)
        if html
          schema(context).concat('_html')
        else
          schema(context)
        end
      end

      def schema(context)
        schema_root(context)
          .push(*schema_path)
          .map { |e| e == :__context__ ? context : e }
          .join('.')
      end

      def schema_path
        [].tap do |path|
          path.push(@object_name)

          if @value.present?
            path.push("#{@attribute_name}_options", @value)
          else
            path.push(@attribute_name)
          end
        end
      end

      def schema_root(context)
        contextual_schema = case context
                            when :legend
                              config.localisation_schema_legend
                            when :hint
                              config.localisation_schema_hint
                            when :label
                              config.localisation_schema_label
                            end

        (contextual_schema || config.localisation_schema_fallback).dup
      end
    end
  end
end
