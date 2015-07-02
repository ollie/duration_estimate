describe DurationEstimate do
  it 'does it all' do
    action = lambda do
      DurationEstimate.each((1..11).to_a) do |_item, e|
        "#{DurationEstimate::TerminalFormatter.format(e)}"
      end
    end

    expect(action).to_not raise_error
  end
end
