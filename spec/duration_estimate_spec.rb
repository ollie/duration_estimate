describe DurationEstimate do
  let(:items) { (1..10).to_a }

  it 'items' do
    estimate = DurationEstimate.new(items)
    expect(estimate.items).to eq(items)
  end

  it 'items_size 10' do
    estimate = DurationEstimate.new(items)
    expect(estimate.items_size).to eq(10)
  end

  it 'items_size 5' do
    estimate = DurationEstimate.new(items, size: 5)
    expect(estimate.items_size).to eq(5)
  end

  it 'items_done 0' do
    estimate = DurationEstimate.new(items)
    expect(estimate.items_done).to eq(0)
  end

  it 'items_remaining 10' do
    estimate = DurationEstimate.new(items)
    expect(estimate.items_remaining).to eq(10)
  end

  it 'ends_at NullTime' do
    estimate = DurationEstimate.new(items)
    expect(estimate.ends_at).to be_a(DurationEstimate::NullTime)
  end

  it 'each' do
    estimate = nil

    DurationEstimate.each(items) do |_item, e|
      estimate = e
    end

    expect(estimate.percentage).to eq(100.0)
  end

  it 'each.with_index' do
    last_estimate = nil
    last_index    = nil

    DurationEstimate.each(items).with_index do |(_item, e), index|
      last_estimate = e
      last_index    = index
    end

    expect(last_estimate.percentage).to eq(100.0)
    expect(last_index).to eq(9)
  end

  context 'Some items done' do
    let(:estimate) do
      estimate = DurationEstimate.new(items)
      estimate.items_done      = 5
      estimate.items_remaining = 5
      estimate.times << 2 << 3 << 4
      estimate
    end

    it 'ends_at Time' do
      expect(estimate.ends_at).to be_a(Time)
    end

    it 'time_remaining 00:00:15' do
      expect(estimate.time_remaining).to eq('00:00:15')
    end

    it 'percentage Time' do
      expect(estimate.percentage).to eq(50.0)
    end
  end
end
