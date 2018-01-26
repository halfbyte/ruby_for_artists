SFREQ = 44100
FREQ = 440

(SFREQ).times do |sample|
  t = sample.to_f / SFREQ.to_f # time in seconds
  period = 1.0 / (FREQ.to_f)
  v = 1.0
  v *= -1.0 if t % period > (period / 2)
  v *= 0.4
  print [v].pack('e')
end