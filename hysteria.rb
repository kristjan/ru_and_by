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

chord_progression = %i[
  a3 minor
  e3 m7
  d4 minor
  a3 minor
  a3 minor
  e3 m7
  d4 minor
  a3 minor
].each_slice(2).ring
strum_pattern = 'd-dud-du-udud-du'

live_loop :rhythm_guitar, delay: 64 do
  sync :bar
  use_synth :pluck
  root, character = chord_progression.tick
  
  
  with_fx :distortion, preamp: 0.75, distort: 0.75 do
    strum_pattern.chars.each do |strum|
      case strum
      when 'd'
        play_chord chord(root, character), release: 1.5
      when 'u'
        play_chord chord(root, character), release: 0.5, amp: 0.8
      end
      sleep 2 * METER.to_f / strum_pattern.size
    end
    
  end
end

live_loop :bass do
  sync :bar
  use_synth :piano
  with_fx :distortion, preamp: 0.25, distort: 0.75 do
    play_pattern_timed %i[
      a1 a1 g2 a1 g2 a2 a1 g2 a1 c2 a1 d2 d2 c2 b2 c2
      e1 e1 d2 e1 d2 e2 e1 g2 e1 c2 e1 g2 g2 c2 g2 a3
      d2 d2 c3 d2 c3 d3 d2 c3 d2 c3 b3 d2 b3 bb3 d2 bb3
      a2 a1 g1 a1 g1 a2 a1 g1 a1 e1 a1 f1 f1 e1 d1 e1
    ], [0.5], amp: 0.15, sustain: 0.2
  end
end

drum_patterns = [
  %w[
    00001000
    10000000
  ]
]


live_loop :drums, delay: 32 do
  sync :bar
  pattern = drum_patterns.sample.map(&:chars).transpose.map do |notes|
    notes.map{|note| note == ?1}
  end
  with_fx :reverb, room: 0.7 do
    pattern.each do |snare, kick|
      sample :drum_bass_hard, amp: 0.75, rate: 0.9 if kick
      sample :drum_snare_hard, amp: 0.75, rate: 0.9 if snare
      sleep METER.to_f / pattern.size
    end
  end
end

hat_patterns = %w[
  O---O---
]

live_loop :hat, delay: 32 do
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