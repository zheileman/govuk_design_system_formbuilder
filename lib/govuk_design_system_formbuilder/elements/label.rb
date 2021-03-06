module GOVUKDesignSystemFormBuilder
  module Elements
    class Label < Base
      using PrefixableArray

      include Traits::Caption
      include Traits::Localisation

      def initialize(builder, object_name, attribute_name, text: nil, value: nil, size: nil, hidden: false, radio: false, checkbox: false, tag: nil, link_errors: true, content: nil, caption: nil)
        super(builder, object_name, attribute_name)

        # content is passed in directly via a proc and overrides
        # the other display options
        if content
          @content = content.call
        else
          @value          = value # used by field_id
          @text           = label_text(text, hidden)
          @size_class     = label_size_class(size)
          @radio_class    = radio_class(radio)
          @checkbox_class = checkbox_class(checkbox)
          @tag            = tag
          @link_errors    = link_errors
          @caption        = caption
        end
      end

      def html
        return nil if [@content, @text].all?(&:blank?)

        if @tag.present?
          content_tag(@tag, class: %(#{brand}-label-wrapper)) { label }
        else
          label
        end
      end

    private

      def label
        @builder.label(@attribute_name, label_options) do
          @content || safe_join([caption, @text])
        end
      end

      def label_text(option_text, hidden)
        text = [option_text, localised_text(:label), @attribute_name.capitalize].compact.first.to_s

        if hidden
          tag.span(text, class: %w(visually-hidden).prefix(brand))
        else
          text
        end
      end

      def label_options
        {
          value: @value,
          for: field_id(link_errors: @link_errors),
          class: %w(label).prefix(brand).push(@size_class, @weight_class, @radio_class, @checkbox_class).compact
        }
      end

      def caption
        caption_element.html unless [@radio_class, @checkbox_class].any?
      end

      def radio_class(radio)
        radio ? %(#{brand}-radios__label) : nil
      end

      def checkbox_class(checkbox)
        checkbox ? %(#{brand}-checkboxes__label) : nil
      end

      def label_size_class(size)
        case size
        when 'xl'      then %(#{brand}-label--xl)
        when 'l'       then %(#{brand}-label--l)
        when 'm'       then %(#{brand}-label--m)
        when 's'       then %(#{brand}-label--s)
        when nil       then nil
        else
          fail "invalid size '#{size}', must be xl, l, m, s or nil"
        end
      end
    end
  end
end
