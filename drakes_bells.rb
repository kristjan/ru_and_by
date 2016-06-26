use_bpm 140
third = 1.0/3
tick_reset_all

progression = %i[c4 c4 c4 c4 c4 c4 g3 a3].ring.stretch(2)

live_loop :arpeggio do
  use_synth :fm
  progression.tick
  
  with_fx :distortion, mix: 0.5, distort: 0.2 do
    play_pattern_timed chord(progression.look, :minor), third, amp: 0.75
  end
end

live_loop :solo, delay: 64 do
  use_synth :pretty_bell
  use_octave 1
  with_fx :reverb do
    if one_in(2)
      notes = scale(progression.look, :minor_pentatonic, num_octaves: 2).shuffle.take(4)
      play_pattern_timed notes, 0.5, sustain: 0.5, amp: 0.8
    else
      sleep 1
    end
  end
end

live_loop :kick, sync: :arpeggio, delay: 16 do
  [0.5, 1, 2].each do |split|
    sample :drum_bass_soft
    sleep split
  end
end

snare_patterns = [
  [4],
  [1.5, 2.5],
  [0.5, 3.5],
  [0.25, 0.25, 1.5, 0.25, 2.25]
]

live_loop :snare, sync: :arpeggio, delay: 32 + 2 do
  snare_patterns.sample.each do |split|
    sample :drum_snare_hard
    sleep split
  end
end

hat_patterns = [
  [1, 4],
  [2, 2]
]
live_loop :hat, sync: :arpeggio, delay: 16 do
  split, count = hat_patterns.sample
  count.times do
    sample :drum_cymbal_closed, amp: 0.3, sustain: 1
    sleep 0.5 / split
  end
end