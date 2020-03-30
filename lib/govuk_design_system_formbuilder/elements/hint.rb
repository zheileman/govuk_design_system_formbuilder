module GOVUKDesignSystemFormBuilder
  module Elements
    class Hint < Base
      include Traits::Hint
      include Traits::Localisation

      def initialize(builder, object_name, attribute_name, text, value = nil, type: nil)
        super(builder, object_name, attribute_name)

        @value          = value
        @type           = type.to_s.inquiry
        @hint_text      = hint_text(text)
      end

      def html
        return nil if @hint_text.blank?

        tag.span(@hint_text, class: hint_classes, id: hint_id)
      end

    private

      def hint_text(supplied)
        [
          supplied.presence,
          localised_text(:hint)
        ].compact.first
      end

      def hint_classes
        %w(govuk-hint).push(radio_class, checkbox_class).compact
      end

      def radio_class
        'govuk-radios__hint' if @type.radio?
      end

      def checkbox_class
        'govuk-checkboxes__hint' if @type.checkbox?
      end
    end
  end
end
