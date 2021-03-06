module GOVUKDesignSystemFormBuilder
  module Elements
    module Radios
      class FieldsetRadioButton < Base
        using PrefixableArray

        include Traits::Label
        include Traits::Hint
        include Traits::Conditional

        def initialize(builder, object_name, attribute_name, value, label:, hint_text:, link_errors:, &block)
          super(builder, object_name, attribute_name)

          @value       = value
          @label       = label
          @hint_text   = hint_text
          @link_errors = has_errors? && link_errors

          if block_given?
            @conditional_content = wrap_conditional(block)
            @conditional_id      = conditional_id
          end
        end

        def html
          safe_join([radio, @conditional_content])
        end

      private

        def radio
          content_tag('div', class: %(#{brand}-radios__item)) do
            safe_join([input, label_element, hint_element])
          end
        end

        def label_element
          @label_element ||= Elements::Label.new(@builder, @object_name, @attribute_name, radio: true, value: @value, link_errors: @link_errors, **label_options)
        end

        def hint_element
          @hint_element ||= Elements::Hint.new(@builder, @object_name, @attribute_name, @hint_text, @value, radio: true)
        end

        def input
          @builder.radio_button(@attribute_name, @value, input_options)
        end

        def input_options
          {
            id: field_id(link_errors: @link_errors),
            aria: { describedby: hint_id },
            data: { 'aria-controls' => @conditional_id },
            class: %w(radios__input).prefix(brand)
          }
        end

        def conditional_classes
          %w(radios__conditional radios__conditional--hidden).prefix(brand)
        end
      end
    end
  end
end
