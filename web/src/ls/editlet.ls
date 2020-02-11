editlet = (opt = {}) -> @
editlet.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> (if !@evt-handler => @evt-handler = {} else @evt-handler)[][n].push cb
  fire: (n, ...v) -> for cb in ((@evt-handler or {})[n] or []) => cb.apply @, v
  set: ->
  get: ->
  config: ->

editlet.cm = (opt = {}) ->
  @opt = opt
  @root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
  @cm = cm = CodeMirror(
    @root, ({
      mode: \javascript
      lineNumbers: true
      theme: \ayu-mirage
      lineWrapping: true
      keyMap: "default" # or, vim
      showCursorWhenSelecting: true
      viewportMargin: Infinity
    } <<< (opt.cm or {}))
  )
  bbox = @root.getBoundingClientRect!
  cm.setSize bbox.width, bbox.height
  cm.setValue '123'
  cm.on \change, ~> @fire \change 
  @

editlet.cm.prototype = Object.create(editlet.prototype) <<< do
  set: -> @cm.setValue it
  get: -> @cm.getValue!
  config: -> 

