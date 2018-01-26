SFREQ = 44100
NOTES = [24, 24, 48, 37]
OFFSETS = [0, 0, 3, 7]
TEMPO = 120
def n2f(n)
  (2.0 ** ((n - 69) / 12.0)) * 440.0
end

(4 * SFREQ).times do |sample|
  t = sample.to_f / SFREQ.to_f # time in seconds
  s_per_b = 15.0 / TEMPO.to_f # seconds per quarternote
  b = t / s_per_b # quarternote
  l = (b / 4).floor # loop
  freq = n2f(NOTES[b % NOTES.length] + OFFSETS[l % OFFSETS.length])
  period = 1.0 / (freq.to_f)
  v = 1.0
  v *= -1.0 if t % period > (period / 2)
  v *= 0.4
  print [v].pack('e')
end