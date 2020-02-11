(->
  getfa 'sample'
    .then (fs) ->
      fs.write-file-sync 'index.html', 'hello index.html!'
      ed = new Editor do
        node: do
          edit: '[ld=edit]'
          view: '[ld=view]'
        editlet: {}
        renderer: ({fs}) ->
          if !fs => return
          payload = html: (fs.read-file-sync 'index.html' .toString!)
          for k,v of payload =>
            ret = transpiler.detect(v)
            if ret.mod => payload[k] = ret.mod.transform v
          console.log payload
          return payload
      ed.set-files fs
      ed.open \index.html
)!
