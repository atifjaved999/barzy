json.bars @favourite_bars do |bar|
  json.partial! 'api/v1/bars/bar', bar: bar
end