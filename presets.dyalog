:Namespace Presets

    ∇ json←GetPresets;ps
      ps←⎕NS¨7⍴⊂''
      (1⊃ps).(name center_x center_y zoom max_iter)←'Full Set' ¯0.5 0 1 100
      (2⊃ps).(name center_x center_y zoom max_iter)←'Seahorse Valley' ¯0.7435669 0.1314023 8 200
      (3⊃ps).(name center_x center_y zoom max_iter)←'Double Spiral' ¯0.7435669 0.1314023 25 400
      (4⊃ps).(name center_x center_y zoom max_iter)←'Neck Junction' ¯1.0 0.3 15 300
      (5⊃ps).(name center_x center_y zoom max_iter)←'Top Bulb' 0.35 0.4 5 150
      (6⊃ps).(name center_x center_y zoom max_iter)←'San Marco' ¯0.75 0.03 8 200
      (7⊃ps).(name center_x center_y zoom max_iter)←'Antenna' ¯1.77 0 15 300
      json←⎕JSON ps
    ∇

:EndNamespace
