#!/usr/bin/env ruby

TEMPO = 110
SFREQ = 44100
NOTES = [24, 24, 48, 37]
TAU = 6.283185307179586476925286766559

def n2f(n)
  (2.0 ** ((n - 69) / 12.0)) * 440.0
end

class Smoother
  def initialize(time)

    @a = Math.exp(-TAU / (time * 0.001 * SFREQ));
    @b = 1.0 - @a
    @z = 0
  end

  def run(input)
    @z = (input * @b) + (@z * @a)
  end
end

# http://www.musicdsp.org/archive.php?classid=3#24
class MoogFilter
  def initialize
    @in1 = @in2 = @in3 = @in4 = 0
    @out1 = @out2 = @out3 = @out4 = 0
  end
  def run(input, fc, res)
    f = fc * 1.16;
    fb = res * (1.0 - 0.15 * f * f);
    input -= @out4 * fb;
    input *= 0.35013 * (f*f)*(f*f);
    @out1 = input + 0.3 * @in1 + (1 - f) * @out1; # Pole 1
    @in1  = input;
    @out2 = @out1 + 0.3 * @in2 + (1 - f) * @out2;  # Pole 2
    @in2  = @out1;
    @out3 = @out2 + 0.3 * @in3 + (1 - f) * @out3;  # Pole 3
    @in3  = @out2;
    @out4 = @out3 + 0.3 * @in4 + (1 - f) * @out4;  # Pole 4
    @in4  = @out3;
    return @out4;
  end
end

filter = MoogFilter.new
#ffreqSmoother = Smoother.new(2)
noteSmoother = Smoother.new(20)
(SFREQ * 4).times do |i|

  t = i.to_f / SFREQ.to_f # time in seconds
  b = (t * TEMPO / (15.0)).to_i
  note = NOTES[b % NOTES.length]
  if note
    note = noteSmoother.run(note)
    freq1 = n2f(note + 0.02)
    freq2 = n2f(note - 0.02)
    v = (t * (freq1) % 1.0) - 1.0
    v += (t * (freq2) % 1.0) - 1.0
  else
    v = 0.002
  end
  #f = (t * 1) % 0.3 + 0.05
  #f = ffreqSmoother.run(f)
  v = filter.run(v, 0.3, 1.0)
  v = v * 0.4
  v = [1.0, [-1.0, v].max].min
  print [v].pack('e')
end
