require 'rails_helper'

RSpec.describe Views::BusinessEntityReportView, type: :model do
  subject { described_class.find_by_sub_id(@entity.sub_id) }
  let(:connection) { ActiveRecord::Base.connection }

  %w(transporter collection_point depot processor secondary_industry subscriber).each do |entity_type|
    context entity_type do
      before :each do
        @timestamp = DateTime.now - 5.days
        @entity = create(entity_type.to_sym)
        @entity.contacts << create(:contact, primary: true)
        Views::ViewRefreshService.new(connection).refresh
      end

      describe 'attributes' do
        it 'returns the sub_d, entity_type etc.' do
          expect({
            id: subject.id,
            entity_type: subject.entity_type,
            entity_id: subject.entity_id,
            status: subject.status,
            trading_name: subject.trading_name,
            address_id: subject.address_id,
            province: subject.province,
            kind: subject.kind,
            latitude: subject.latitude,
            longitude: subject.longitude,
            business_registered_name: subject.business_registered_name
          }.to_a - {
            id: @entity.sub_id,
            entity_type: entity_type.titleize.delete(' '),
            entity_id: @entity.id,
            status: @entity.status,
            trading_name: @entity.trading_name,
            address_id: @entity.physical_address.id,
            province: @entity.physical_address.province,
            kind: (@entity.kind rescue ''),
            latitude: @entity.physical_address.latitude,
            longitude: @entity.physical_address.longitude,
            business_registered_name: 'Registered business name'
          }.to_a).to eq([])
        end
      end

      describe 'contact attributes' do
        it 'returns the name, number email' do
          contact = @entity.contacts.first
          expect({
            contact_first_name: subject.contact_first_name,
            contact_last_name: subject.contact_last_name,
            contact_telephone_number: subject.contact_telephone_number,
            contact_email: subject.contact_email
          }.to_a - {
            contact_first_name: contact.first_name,
            contact_last_name: contact.last_name,
            contact_telephone_number: contact.telephone_number,
            contact_email: contact.email
          }.to_a).to eq([])
        end
      end

      describe 'address attributes' do
        it 'returns the line_1, line_2, suburb, city, postal_code' do
          expect({
            address_line_1: subject.address_line_1,
            address_line_2: subject.address_line_2,
            address_suburb: subject.address_suburb,
            address_city: subject.address_city,
            address_postal_code: subject.address_postal_code
          }.to_a - {
            address_line_1: @entity.physical_address.line_1,
            address_line_2: @entity.physical_address.line_2,
            address_suburb: @entity.physical_address.suburb,
            address_city: @entity.physical_address.city,
            address_postal_code: @entity.physical_address.postal_code
          }.to_a).to eq([])
        end
      end

      describe 'business group attributes' do
        it 'returns the name' do
          expect({
            business_group_name: subject.business_group_name
          }.to_a - {
            business_group_name: (@entity.business_group.name rescue nil)
          }.to_a).to eq([])
        end
      end

      describe 'registering_and_beyond' do
        subject { described_class.registering_and_beyond }

        it 'returns the entity' do
          @entity.approved!
          Views::ViewRefreshService.new(connection).refresh
          expect(subject.count).to eq 1
        end

        it 'does not return registering entity' do
          @entity.registering!
          Views::ViewRefreshService.new(connection).refresh
          expect(subject.count).to eq 0
        end
      end
    end
  end
end
