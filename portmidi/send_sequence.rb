require 'portmidi'

Portmidi.start
device = Portmidi.output_devices.find do |dev|
  dev.name.match(/IAC/)
end
output =  Portmidi::Output.new(device.device_id)

NOTES = [24, 24, 48, 37, 24, 24, 49, 37] * 8
messages = []

NOTE_ON = 0x90
NOTE_OFF = 0x80

class Message
  attr_reader :time, :message, :sent
  def initialize(time, message)
    @time = time
    @message = message
    @sent = false
  end

  def sent!
    @sent = true
  end

  def self.send(messages, time, output)
    messages.select { |message| !message.sent && time >= message.time }.each do |message|
      message.sent!
      output.write_short(*message.message)
    end
  end
end

def note_on_beat(now, beat, length, note, channel, velocity)
  [
    Message.new(now + (beat * 250), [NOTE_ON + channel, note, velocity]),
    Message.new(now + (beat * 250) + length, [NOTE_OFF + channel, note, velocity]),
  ]
end

Porttime.start(10) do |time|
  Message.send(messages, time, output)
end

now = Porttime.time
NOTES.each_with_index do |note, beat|
  # Bass notes
  messages += note_on_beat(now, beat, 125, note, 0, 0x60)
  # Beat
  if beat % 2 == 0
    # Bassdrum
    messages += note_on_beat(now, beat, 125, 36, 1, 0x60)
  else
    # Snaredrum
    messages += note_on_beat(now, beat, 125, 36 + 6, 1, 0x60)
  end
  if beat % 4 == 2
    # Hihat
    messages += note_on_beat(now, beat, 125, 36 + 2, 1, 0x60)
  end
end

seq_len = (NOTES.length.to_f * 250.0 + 250.0) / 1000.0
puts "Sleeping #{seq_len} now."
sleep seq_len
puts Portmidi.time
