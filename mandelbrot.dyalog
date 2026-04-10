:Namespace Mandelbrot
    ∇ iters←max_iter Compute C
    ⍝ C: height×width matrix of complex numbers (the C plane)
    ⍝ Returns: matrix of iteration counts (max_iter = "in the set")
    ⍝ State: Z C mask counts — evolved max_iter times via ⍣
      iters←4⊃{(z c m n)←⍵ ⋄ z←c+(z*2) ⋄ m2←m∧2≥|z ⋄ (m2×z) c m2 (n+m)}⍣max_iter⊢(0×C) C ((⍴C)⍴1) ((⍴C)⍴0)
    ∇

    ∇ C←MakeGrid(cx cy zoom width height);xr;yr;reals;imags
    ⍝ cx,cy: center; zoom: zoom level
    ⍝ Returns: height×width matrix of complex numbers
    ⍝ Scale both axes uniformly, correct for char aspect ratio (~0.65 w:h)
      yr←1.5÷zoom
      xr←yr×0.65×width÷height
      reals←(cx-xr)+((⍳width)-1)×(2×xr)÷1⌈width-1
      imags←(cy+yr)-((⍳height)-1)×(2×yr)÷1⌈height-1
      C←imags∘.+reals×0J1
    ∇

:EndNamespace
