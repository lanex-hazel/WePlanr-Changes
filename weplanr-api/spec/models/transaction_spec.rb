require 'rails_helper'

describe Transaction do

  context '.gst' do
    it 'returns correct gst' do
      obj = Transaction.new amount: 220

      expect(obj.gst).to eq 20
    end
  end

  context '.amount_without_gst' do
    it 'returns correct gst' do
      obj = Transaction.new amount: 220

      expect(obj.amount_without_gst).to eq 200
    end
  end

end
