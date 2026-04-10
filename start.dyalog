:Namespace Start
    ∇ Run;port
      ⎕IO←1
      port←8080
      ⎕←'Starting Mandelbrot API...'
      #.Server.Start port
    ∇

:EndNamespace
