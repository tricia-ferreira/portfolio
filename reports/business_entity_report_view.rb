module Views
  class BusinessEntityReportView < ApplicationRecord
    self.primary_key = :sub_id

    def readonly?
      true
    end

    enum status: Transporter.statuses

    scope :registering_and_beyond,
          -> { where.not('status = ?', 0) }

    def contact_name_to_s
      [contact_first_name, contact_last_name].compact.join(' ')
    end

    def address_to_s
      [
        address_line_1,
        address_line_2,
        address_suburb,
        address_city,
        address_postal_code
      ].reject(&:blank?).compact.join(', ')
    end
  end
end
