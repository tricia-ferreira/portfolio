require 'rails_helper'

RSpec.describe Backoffice::ReportsController, type: :controller do
  let(:connection)  { ActiveRecord::Base.connection }
  let(:occurs_at)   { DateTime.now }

  before :each do
    @admin = create(:admin, :super_admin)
    sign_in @admin
  end

  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe '#generate' do
    context '#entities_report' do
      subject { get :generate, params: { form_report_filter: { type: 'entities_report' } } }

      before(:each) do
        Business::ENTITY_TYPES.each do |entity_type|
          create(entity_type.to_sym, status: 'approved')
        end
        Views::ViewRefreshService.new(connection).refresh
      end

      it 'renders the generate template' do
        subject
        expect(response).to render_template :generate
      end

      it 'finds correct amount of records' do
        subject
        expect(assigns[:records].count).to eq 5
      end
    end

    context 'invalid params' do
      subject { get :generate, params: params }

      context 'absent type' do
        let(:params) { { form_report_filter: { type: '' } } }

        it 'renders the generate template' do
          subject
          expect(response).to redirect_to [:backoffice, :reports]
        end
      end
    end
  end
end
