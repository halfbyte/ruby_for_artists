SFREQ = 44100
NOTES = [24, 24, 48, 37]
OFFSETS = [0, 0, 3, 7]
TEMPO = 120

class Envelope
  def initialize(a,r)
    @a = a
    @r = r
  end
  def run(t)
    if t > @a + @r
      return 0
    elsif t > @a #release
      return 1 - ((1 / @r) * (t - @a))
    else
      return 1 / @a * t
    end

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

def n2f(n)
  (2.0 ** ((n - 69) / 12.0)) * 440.0
end

filter = MoogFilter.new
vol_ar = Envelope.new(0.001,0.1)
flt_ar = Envelope.new(0.02,0.04)

(4 * SFREQ).times do |sample|
  t = sample.to_f / SFREQ.to_f # time in seconds
  s_per_b = 15.0 / TEMPO.to_f # seconds per quarternote
  b = t / s_per_b # quarternote
  t_in_b = t % s_per_b #time in quarternote
  l = (b / 4).floor # loop
  freq = n2f(NOTES[b % NOTES.length] + OFFSETS[l % OFFSETS.length])
  period = 1.0 / (freq.to_f)
  v = 1.0
  v *= -1.0 if t % period > (period / 2)
  v = filter.run(v, 0.1 + flt_ar.run(t_in_b) * 0.3, 3)
  v *= vol_ar.run(t_in_b)
  v *= 0.33
  # v = [1.0, [-1.0, v].max].min
  
  print [v].pack('e')
end
