describe DurationEstimate::TerminalFormatter do
  it ' 0/5 ( 0.00 %) -, -' do
    estimate = DurationEstimate.new((1..5).to_a)
    line     = DurationEstimate::TerminalFormatter.format(estimate)
    expected = '0/5 (  0.00 %) -, -'

    expect(line).to eq(expected)
  end

  it '  0/150 ( 0.00 %) -, -' do
    estimate = DurationEstimate.new((1..150).to_a)
    line     = DurationEstimate::TerminalFormatter.format(estimate)
    expected = '  0/150 (  0.00 %) -, -'

    expect(line).to eq(expected)
  end

  it ' 15/150 (10.00 %) 10:56:34, 00:07:30' do
    estimate = DurationEstimate.new((1..150).to_a)
    estimate.times << 2 << 3 << 4
    estimate.items_done = 15

    line     = DurationEstimate::TerminalFormatter.format(estimate)
    expected = %r{ 15/150 \( 10.00 %\) \d{2}:\d{2}:\d{2}, 00:07:30}

    expect(line).to match(expected)
  end
end
