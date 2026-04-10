:Namespace Palette

    ∇ txt←max_iter ToAscii iters;ramp;indices;escaped
    ⍝ In-set (iters=max_iter) → space
    ⍝ Escaped: low iters → sparse chars, high iters → dense chars
      ramp←' .:-=+*#%@'
      ⍝ Map escaped points: iters 1..max_iter-1 → indices 2..≢ramp
      indices←1+⌈(iters×((≢ramp)-1))÷max_iter
      ⍝ In-set points → index 1 (space)
      escaped←iters<max_iter
      indices←(escaped×indices)+~escaped
      txt←ramp[indices]
    ∇

:EndNamespace
