module GOVUKDesignSystemFormBuilder
  module Elements
    module CheckBoxes
      class FieldsetCheckBox < Base
        include Traits::Hint
        include Traits::Conditional

        def initialize(builder, object_name, attribute_name, value, label:, hint_text:, link_errors:, multiple:, &block)
          super(builder, object_name, attribute_name)

          @value       = value
          @label       = label
          @hint_text   = hint_text
          @multiple    = multiple
          @link_errors = link_errors

          if block_given?
            @conditional_content = wrap_conditional(block)
            @conditional_id      = conditional_id
          end
        end

        def html
          safe_join(
            [
              content_tag('div', class: 'govuk-checkboxes__item') do
                safe_join(
                  [
                    input,
                    label_element.html,
                    hint_element.html,
                  ]
                )
              end,
              @conditional_content
            ]
          )
        end

      private

        def input
          @builder.check_box(
            @attribute_name,
            {
              id: field_id(link_errors: @link_errors),
              class: check_box_classes,
              multiple: @multiple,
              aria: { describedby: hint_id },
              data: { 'aria-controls' => @conditional_id }
            },
            @value,
            false
          )
        end

        def label_element
          @label_element ||= Elements::Label.new(@builder, @object_name, @attribute_name, type: :checkbox, value: @value, **@label, link_errors: @link_errors)
        end

        def hint_element
          @hint_element ||= Elements::Hint.new(@builder, @object_name, @attribute_name, @hint_text, @value, type: :checkbox)
        end

        def conditional_classes
          %w(govuk-checkboxes__conditional govuk-checkboxes__conditional--hidden)
        end

        def check_box_classes
          %w(govuk-checkboxes__input)
        end
      end
    end
  end
end
