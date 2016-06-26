def chord(a, b, c)
  play a
  play b
  play c
end

def low
  [72, 75, 79]
end

def high
  [75, 79, 82]
end

def flat
  [75, 77, 81]
end

seq = [
  low, nil, high, nil, flat, nil, nil,
  low, nil, high, nil, high, flat, flat, low
]

seq.each do |notes|
  if notes
    notes.each {|n| play n, pan: [-1, 0, 1].sample}
  end
  sleep 0.25
end
