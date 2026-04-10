:Namespace Server

    ⎕IO←1
    DRC←⍬   ⍝ Conga root — set during Start
    CRLF←⎕UCS 13 10
    IndexHTML←''  ⍝ cached at startup

    ∇ Start port;z;wait;obj;evt;data
      IndexHTML←⊃⎕NGET '/app/index.html' 1
      'Conga' ⎕CY 'conga'
      DRC←Conga.Init ''
      z←DRC.Srv '' '' port 'HTTP'
      :If 0≠⊃z
          ⎕←'Failed to start server: ' z
          →0
      :EndIf
      ⎕←'Mandelbrot API server listening on port ',⍕port

      :Repeat
          :Trap 0
              wait←DRC.Wait '' 5000
              :If 0=⊃wait
                  obj←2⊃wait
                  evt←3⊃wait
                  :Select evt
                  :Case 'HTTPHeader'
                      data←4⊃wait
                      obj HandleRequest data
                  :Case 'Connect'
                      ⍝ new connection
                  :Case 'Error'
                      ⍝ normal on connection close
                  :Else
                      ⍝ ignore
                  :EndSelect
              :EndIf
          :Else
              ⎕←'Error in event loop: ',⎕DMX.(EM,' ',Message)
          :EndTrap
      :EndRepeat
    ∇

    ∇ obj HandleRequest raw;method;path;query;params;body;ct;status;lines
    ⍝ raw is a character vector: the full HTTP request
      lines←CRLF{(~⍺⍷⍵)⊆⍵}raw
      lines←(0<≢¨(lines~¨' '))⌿lines
      method←⊃(' '≠⊃lines)⊆⊃lines
      path←2⊃(' '≠⊃lines)⊆⊃lines
      (path query)←SplitPath path
      ⎕←method,' ',path

      :Trap 0
          :Select path
          :Case '/health'
              body←'{"status":"ok"}'
              ct←'application/json'
              status←200

          :Case '/presets'
              body←#.Presets.GetPresets
              ct←'application/json'
              status←200

          :Case '/mandelbrot'
              params←ParseQuery query
              (status ct body)←HandleMandelbrot params

          :CaseList (,'/') '/index.html'
              body←∊IndexHTML,¨⎕UCS 10
              ct←'text/html; charset=utf-8'
              status←200

          :Else
              body←'{"error":"Not found"}'
              ct←'application/json'
              status←404
          :EndSelect

          SendResponse obj status ct body
      :Else
          ⎕←'Handler error: ',⎕DMX.(EM,' ',Message)
          SendResponse obj 500 'application/json' '{"error":"Internal server error"}'
      :EndTrap
    ∇

    ∇ SendResponse(obj status ct body);hdr;reason
      reason←(200 400 404 500⍳status)⊃'OK' 'Bad Request' 'Not Found' 'Internal Server Error' 'Unknown'
      hdr←'HTTP/1.1 ',(⍕status),' ',reason,CRLF
      hdr,←'Content-Type: ',ct,CRLF
      hdr,←'Content-Length: ',(⍕≢⎕UCS body),CRLF
      hdr,←'Access-Control-Allow-Origin: *',CRLF
      hdr,←'Connection: close',CRLF
      hdr,←CRLF
      {}DRC.Send obj (hdr,body)
    ∇

    ∇ r←HandleMandelbrot params;cx;cy;zoom;width;height;max_iter;fmt;coords;iters;ns
      cx←GetNum params 'center_x' ¯0.5
      cy←GetNum params 'center_y' 0
      zoom←GetNum params 'zoom' 1
      width←⌊GetNum params 'width' 80
      height←⌊GetNum params 'height' 40
      max_iter←⌊GetNum params 'max_iter' 100
      fmt←GetStr params 'format' 'ascii'

      width←500⌊1⌈width
      height←500⌊1⌈height
      max_iter←10000⌊1⌈max_iter

      coords←#.Mandelbrot.MakeGrid cx cy zoom width height
      iters←max_iter #.Mandelbrot.Compute coords

      :Select fmt
      :Case 'ascii'
          r←200 'text/plain' (∊{⍵,(⎕UCS 10)}¨↓max_iter #.Palette.ToAscii iters)
      :Case 'json'
          ns←⎕NS ''
          ns.width←width
          ns.height←height
          ns.iterations←↓iters
          r←200 'application/json' (⎕JSON ns)
      :Else
          r←400 'application/json' '{"error":"Unknown format. Use ascii or json."}'
      :EndSelect
    ∇

    ⍝ --- utils ---

    ∇ r←SplitPath url;qpos
      qpos←url⍳'?'
      :If qpos>≢url
          r←url ''
      :Else
          r←((qpos-1)↑url)(qpos↓url)
      :EndIf
    ∇

    ∇ params←ParseQuery qs;pairs;kv
      :If 0=≢qs
          params←0 2⍴''
          →0
      :EndIf
      pairs←('&'≠qs)⊆qs
      kv←{'='∊⍵:(⍵↑⍨¯1+⍵⍳'=')(⍵↓⍨⍵⍳'=') ⋄ ⍵ ''}¨pairs
      params←↑kv
    ∇

    ∇ v←GetNum(params key default);row;txt
      :If 0=≢params
          v←default ⋄ →0
      :EndIf
      row←(params[;1])⍳⊂key
      :If row>≢params
          v←default
      :Else
          txt←⊃params[row;2]
          :Trap 0
              v←⊃⊃(//)⎕VFI txt
          :Else
              v←default
          :EndTrap
      :EndIf
    ∇

    ∇ v←GetStr(params key default);row
      :If 0=≢params
          v←default ⋄ →0
      :EndIf
      row←(params[;1])⍳⊂key
      :If row>≢params
          v←default
      :Else
          v←⊃params[row;2]
      :EndIf
    ∇

:EndNamespace
