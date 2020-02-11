(->
  window.pug = pug = require("pug")
  window.lsc = lsc = require("livescript")
  getfs = -> new Promise (res, rej) ->
    if window.fs => return res fs
    <- (e) BrowserFS.configure( { fs: \InMemery }, _ )
    if e => return rej e
    window.fs = fs = require("fs")
    res fs

  getfa = (dir) ->
    getfs!
      .then -> 
        if !fs.exists-sync(dir) => fs.mkdir-sync dir
        fa = new BrowserFS.FileSystem.FolderAdapter dir, fs
        return fa

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
