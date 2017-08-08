module TyreQtyHelper
  def iconified_tyre_qty(label, qty_type, type, f)
    content_tag :div, class: 'col-sm-2 text-center' do
      content_tag :div, class: 'tyre__quantities' do
        inline_svg("tyre_qty/#{qty_type}.svg", class: 'tyre__quantities__svg') +
        content_tag(:h4,label) + (f.input_field "#{qty_type}_#{type}".to_sym,
          as: :integer,
          min: '0',
          step: 'any',
          class: "text-right large js-tyre_#{type}",
          required: false,
          data: {
            average_weight: Tyre::AVERAGE_WEIGHTS[qty_type.to_sym],
            type: qty_type
          }
        )
      end
    end
  end
end
