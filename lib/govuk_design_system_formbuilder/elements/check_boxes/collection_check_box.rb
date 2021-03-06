module GOVUKDesignSystemFormBuilder
  module Elements
    module CheckBoxes
      class CollectionCheckBox < Base
        using PrefixableArray

        include Traits::CollectionItem
        include Traits::Hint

        def initialize(builder, object_name, attribute_name, checkbox, hint_method = nil, link_errors: false)
          super(builder, object_name, attribute_name)

          @checkbox    = checkbox
          @item        = checkbox.object
          @value       = checkbox.value
          @hint_text   = retrieve(@item, hint_method)
          @link_errors = link_errors
        end

        def html
          content_tag('div', class: %(#{brand}-checkboxes__item)) do
            safe_join([check_box, label_element, hint_element])
          end
        end

      private

        def check_box
          @checkbox.check_box(**check_box_options)
        end

        def check_box_options
          {
            id: field_id(link_errors: @link_errors),
            class: %(#{brand}-checkboxes__input),
            aria: { describedby: hint_id }
          }
        end

        def label_element
          @label_element ||= Label.new(@builder, @object_name, @attribute_name, @checkbox, value: @value, link_errors: @link_errors)
        end

        def hint_element
          @hint_element ||= Elements::Hint.new(@builder, @object_name, @attribute_name, @hint_text, @value, checkbox: true)
        end
      end
    end
  end
end
