(->
  lc = {}
  ld$.fetch 'https://plotdb.com/d/chart/1073', {method: \GET}, {type: \json}
    .then ->
      lc.chart = it
      console.log it
      getfa 'chart'
    .then (fs) ->
      fs.write-file-sync 'index.html', lc.chart.doc.content
      fs.write-file-sync 'index.css', lc.chart.style.content
      fs.write-file-sync 'index.js', lc.chart.code.content
      ed = new Editor do
        node: do
          edit: '[ld=edit]'
          view: '[ld=view]'
        editlet: {}
        renderer: ({fs}) ->
          if !fs => return
          payload = do
            html: (fs.read-file-sync 'index.html' .toString!)
            js: (fs.read-file-sync 'index.js' .toString!)
            css: (fs.read-file-sync 'index.css' .toString!)
          for k,v of payload =>
            ret = transpiler.detect(v)
            if ret.mod => payload[k] = ret.mod.transform v
          chart = do
            doc: name: "document", content: payload.html
            style: name: "stylesheet", content: payload.css
            code: name: "code", content: payload.js
          lc.chart <<< chart
          code = """
          <html>
          <head>
          <link rel="stylesheet" type="text/css" href="https://plotdb.com/dist/0.1.0/plotdb.min.css"/>
          <style type="text/css">
          html,body { width: 100%; height: 100%; margin: 0; padding: 0 }
          </style>
          </head>
          <body>
          <div id="root" style="width:100%;height:100%"></div>
          <script src="https://plotdb.com/dist/latest/plotdb.min.js"></script>
          <script src="https://plotdb.com/lib/d3/3.5.12/index.min.js"></script>
          <script src="https://plotdb.com/lib/plotd3/0.1.0/index.js"></script>
          <script>
            var chartobj = #{JSON.stringify(lc.chart)};
            var c = new plotdb.view.chart(chartobj);
            c.data(
              [0,1,2,3,4,5,6,7,8,9].map(function(it) { return {name: it, v1: Math.random(), v2: Math.random()}; }),
              false, { value: ["v1"], order: ["name"] }
            )
            c.attach("\#root");
            c.render();
          </script>
          </body>
          </html>
          """
          return code
      ed.set-files fs
      ed.open \index.js
)!
