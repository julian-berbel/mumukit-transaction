RSpec.describe Logger::Formatter do
  it do
    expect(Logger::Formatter.new.call("INFO", DateTime.new(2023, 5, 24, 10, 15, 12), "foo", "bar")).to eq(
      "I, [2023-05-24T10:15:12.000000 ##{Process.pid}]  INFO -- foo: [tracker-tag-absent, tracker-tag-absent, tracker-tag-absent, tracker-tag-absent, tracker-tag-absent] bar\n"
    )
  end
end