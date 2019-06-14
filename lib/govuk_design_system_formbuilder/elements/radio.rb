module GOVUKDesignSystemFormBuilder
  module Elements
    module HintHelpers
      def hint_id
        return nil unless @hint.present?

        [@object_name, @attribute_name, @value, 'hint'].join('-').parameterize
      end

      def radio_hint_classes
        %w(govuk-hint govuk-radios__hint)
      end
    end

    class FieldsetRadio < GOVUKDesignSystemFormBuilder::Base
      include HintHelpers

      def initialize(builder, object_name, attribute_name, value, label:, hint:)
        super(builder, object_name, attribute_name)
        @value = value
        @label = label
        @hint  = hint
      end

      def html(&block)
        @conditional_content, @conditional_id = process(block)

        @builder.content_tag('div', class: 'govuk-radios__item') do
          @builder.safe_join(
            [
              input,
              Elements::Label.new(@builder, @object_name, @attribute_name, @label).html,
              Elements::Hint.new(@builder, @object_name, @attribute_name, id: hint_id, class: radio_hint_classes, text: @hint).html,
              conditional_content
            ]
          )
        end
      end

    private

      def input
        @builder.radio_button(
          @attribute_name,
          @value,
          id: attribute_descriptor,
          aria: { describedby: hint_id },
          data: { 'aria-controls' => @conditional_id }
        )
      end

      def conditional_content
        return nil unless @conditional_content.present?

        @builder.content_tag('div', class: conditional_classes, id: @conditional_id) do
          @conditional_content
        end
      end

      def process(block)
        return content = block.call, (content && conditional_id)
      end

      def conditional_classes
        %w(govuk-radios__conditional govuk-radios__conditional--hidden)
      end
    end

    class CollectionRadio < GOVUKDesignSystemFormBuilder::Base
      include HintHelpers

      def initialize(builder, object_name, attribute_name, item, value_method, text_method, hint_method)
        super(builder, object_name, attribute_name)
        @item = item
        @value = item.send(value_method)
        @text = item.send(text_method)
        @hint = item.send(hint_method) if hint_method.present?
      end

      def html
        @builder.content_tag('div', class: 'govuk-radios__item') do
          @builder.safe_join(
            [
              @builder.radio_button(
                @attribute_name,
                @value,
                id: attribute_descriptor,
                aria: { describedby: hint_id }
              ),
              Elements::Label.new(@builder, @object_name, @attribute_name, text: @text, value: @value).html,
              Elements::Hint.new(@builder, @object_name, @attribute_name, id: hint_id, class: radio_hint_classes, text: @hint).html,
            ].compact
          )
        end
      end
    end
  end
end