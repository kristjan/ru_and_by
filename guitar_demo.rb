live_loop :guit do
  with_fx :echo, mix: 0.3, phase: 0.25 do
    sample :guit_em9, rate: 0.5
  end
  sleep 4
end

live_loop :revguit do
  with_fx :slicer, mix: 1, phase: 0.16666666, wave: 0 do
    with_fx :flanger, mix: 0.5, wave: 2, delay: 0.25, depth: 3 do
      sample :guit_em9, rate: -0.5, amp: 2
    end
  end
  sleep 8
end

live_loop :boom do
  with_fx :reverb, room: 0.5 do
    sample :bd_boom, amp: 10, rate: 4
  end
  sample :bd_boom, amp: 40, rate: 2
  sleep 8
end