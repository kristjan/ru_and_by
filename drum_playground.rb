use_bpm 200
set_volume! 3

METER = 4

metronome = [:elec_plip, :elec_tick, :elec_tick, :elec_tick].ring
live_loop :bar do
  METER.times do
    ##| sample metronome.tick
    sleep METER / METER.to_f
  end
end

drum_patterns = [
  %w[
    00001000
    10000001
  ],
  %w[
    00001000
    10000000
  ],
  %w[
    01001000
    10010000
  ],
  %w[
    00010010
    10000001
  ],
  %w[
    11001111
    00110001
  ]
]


live_loop :drums do
  sync :bar
  pattern = drum_patterns.sample.map(&:chars).transpose.map do |notes|
    notes.map{|note| note == ?1}
  end
  with_fx :reverb, room: 0.5 do
    pattern.each do |snare, kick|
      sample :drum_bass_hard, amp: 0.5, rate: 0.9 if kick
      sample :drum_snare_hard, amp: 0.4, rate: 0.9 if snare
      sleep METER.to_f / pattern.size
    end
  end
end

hat_patterns = %w[
  O---O---
  x-x-x-o-
  x-x-O---
  x-x-x-xx
  xxx-x-x-
  xx-xx-x-
  x-o-x-x-
]

live_loop :hat do
  sync :bar
  pattern = hat_patterns.sample
  with_fx :reverb, room: 0.5 do
    pattern.chars.each do |hit|
      case hit
      when 'x' then sample :drum_cymbal_closed, amp: 0.25
      when 'o' then sample :drum_cymbal_open, amp: 0.25, attack: 0.01, sustain: 0.1, release: 0.1
      when 'O' then sample :drum_cymbal_open, amp: 0.25
      end
      sleep METER.to_f / pattern.size
    end
  end
end