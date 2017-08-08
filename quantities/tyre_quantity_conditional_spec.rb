require 'rails_helper'

RSpec.describe TyreQuantityConditional do
  let(:subject) { described_class.new(qty_attr) }

  describe 'within_tolerance?' do
    context 'valid quantity' do
      let(:qty_attr) { {'passenger_qty': 10, 'truck_qty': 5} }

      it 'returns empty array' do
        expect(subject.within_tolerance?).to eq []
      end
    end

    context 'valid weight' do
      let(:qty_attr) { {'shred_weight': 1500, 'scrap_weight': 20_000} }

      it 'returns empty array' do
        expect(subject.within_tolerance?).to eq []
      end
    end

    context 'invalid quantities' do
      let(:qty_attr) { {'passenger_qty': 2000} }

      it 'returns passenger' do
        expect(subject.within_tolerance?).to eq ["passenger"]
      end
    end

    context 'weight less than tolerance' do
      let(:qty_attr) { {'shred_weight': 50} }

      it 'returns shred' do
        expect(subject.within_tolerance?).to eq ["shred"]
      end
    end

    context 'weight more than tolerance' do
      let(:qty_attr) { {'shred_weight': 50_000} }

      it 'returns shred' do
        expect(subject.within_tolerance?).to eq ["shred"]
      end
    end
  end

  describe '#qty_check' do
    let(:qty_attr) { {'passenger_qty': 10, 'truck_qty': 5} }

    it 'returns true if amount is more that recommended qty' do
      expect(subject.send(:qty_check, 'passenger', 1800)).to eq true
    end

    it 'returns false if amount is less that recommended qty' do
      expect(subject.send(:qty_check, 'passenger', 1000)).to eq false
    end
  end

  describe '#weight_check' do
    let(:qty_attr) { {'shred_weight': 1500} }

    it 'returns true if amount is more that recommended qty' do
      expect(subject.send(:weight_check, 'shred', 40_000)).to eq true
    end

    it 'returns true if amount is less that recommended qty' do
      expect(subject.send(:weight_check, 'shred', 100)).to eq true
    end

    it 'returns false if it is within range' do
      expect(subject.send(:weight_check, 'shred', 20_000)).to eq false
    end
  end

end
