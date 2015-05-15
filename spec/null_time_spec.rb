describe DurationEstimate::NullTime do
  it 'responds to strftime' do
    null_time = DurationEstimate::NullTime.new
    expect(null_time.strftime('%H:%M:%S')).to eq('-')
  end
end
