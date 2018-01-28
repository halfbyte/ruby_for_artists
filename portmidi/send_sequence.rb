require 'portmidi'

Portmidi.start
device = Portmidi.output_devices.find do |device|
  device.name.match(/IAC/)
end
output =  Portmidi::Output.new(device.device_id)

NOTES = [24, 24, 48, 37] * 16
messages = []

Porttime.start(10) do |time|
  sent = []
  messages.each do |msg|
    if time >= msg[0] && !msg[2]
      output.write_short(*msg[1])
      msg[2] = true
    end
    sent.each do |msg|
      messages.delete(msg)
    end
  end    
end

now = Porttime.time
puts now
NOTES.each_with_index do |note, beat|
  messages << [now + (beat * 250), [0x90, note, 0x60], false]
  messages << [now + (beat * 250) + 125, [0x80, note, 0x60], false]
  if beat % 2 == 0
    messages << [now + (beat * 250), [0x91, 36, 0x60], false]
    messages << [now + (beat * 250) + 125, [0x81, 36, 0x60], false]
  else
    messages << [now + (beat * 250), [0x91, 36 + 6, 0x60], false]
    messages << [now + (beat * 250) + 125, [0x81, 36 + 6, 0x60], false]
  end
  if beat % 4 == 2
    messages << [now + (beat * 250), [0x91, 36 + 2, 0x60], false]
    messages << [now + (beat * 250) + 125, [0x81, 36 + 2, 0x60], false]    
  end
end


seq_len = (NOTES.length.to_f * 250.0 + 250.0) / 1000.0
puts "Sleeping #{seq_len} now."
sleep seq_len
puts Portmidi.time
