describe DurationEstimate::SizedQueue do
  let(:queue) { DurationEstimate::SizedQueue.new(3) }

  it 'max_size' do
    expect(queue.max_size).to eq(3)
  end

  it 'items' do
    expect(queue.items).to eq([])
  end

  it '<<, average' do
    queue << 1 << 2 << 3 << 4
    expect(queue.items).to eq([2, 3, 4])
    expect(queue.average).to eq(3)
  end

  it 'average' do
    expect(queue.average).to eq(nil)
  end
end
