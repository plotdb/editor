// Generated by LiveScript 1.3.1
var slice$ = [].slice;
(function(){
  var pug, lsc, getfs, getfa;
  window.pug = pug = require("pug");
  window.lsc = lsc = require("livescript");
  getfs = function(){
    return new Promise(function(res, rej){
      if (window.fs) {
        return res(fs);
      }
      return e(partialize$.apply(BrowserFS, [
        BrowserFS.configure, [
          {
            fs: 'InMemery'
          }, void 8
        ], [1]
      ]), function(){
        var fs;
        if (e) {
          return rej(e);
        }
        window.fs = fs = require("fs");
        return res(fs);
      });
    });
  };
  getfa = function(dir){
    return getfs().then(function(){
      var fa;
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
      }
      fa = new BrowserFS.FileSystem.FolderAdapter(dir, fs);
      return fa;
    });
  };
  return getfa('sample').then(function(fs){
    var ed;
    fs.writeFileSync('index.html', 'hello index.html!');
    ed = new Editor({
      node: {
        edit: '[ld=edit]',
        view: '[ld=view]'
      },
      editlet: {},
      renderer: function(arg$){
        var fs, payload, k, v, ret;
        fs = arg$.fs;
        if (!fs) {
          return;
        }
        payload = {
          html: fs.readFileSync('index.html').toString()
        };
        for (k in payload) {
          v = payload[k];
          ret = transpiler.detect(v);
          if (ret.mod) {
            payload[k] = ret.mod.transform(v);
          }
        }
        console.log(payload);
        return payload;
      }
    });
    ed.setFiles(fs);
    return ed.open('index.html');
  });
})();
function partialize$(f, args, where){
  var context = this;
  return function(){
    var params = slice$.call(arguments), i,
        len = params.length, wlen = where.length,
        ta = args ? args.concat() : [], tw = where ? where.concat() : [];
    for(i = 0; i < len; ++i) { ta[tw[0]] = params[i]; tw.shift(); }
    return len < wlen && len ?
      partialize$.apply(context, [f, ta, tw]) : f.apply(context, ta);
  };
}