use_bpm 200
set_volume! 3

define :randrum do
  ('%08b' % rand(256)).chars.map{|note| note == ?1}
end

define :randhat do
  Array.new(8) { ['-', 'x', 'o', 'O'].sample }
end

live_loop :drums do
  pattern = [randhat, randrum, randrum].transpose
  2.times do
    with_fx :reverb, room: 0.5 do
      pattern.each do |hat, snare, kick|
        sample :drum_bass_hard, amp: 0.5, rate: 0.9 if kick
        sample :drum_snare_hard, amp: 0.4, rate: 0.9 if snare
        case hat
        when 'x' then sample :drum_cymbal_closed, amp: 0.25
        when 'o' then sample :drum_cymbal_open, amp: 0.25, attack: 0.01, sustain: 0.1, release: 0.1
        when 'O' then sample :drum_cymbal_open, amp: 0.25
        end
        sleep 0.5
      end
    end
  end
end