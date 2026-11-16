/* Renders a Rivjuuu screen template with the state chosen beside the phone. */
(function () {
  function DCLogic(props) { this.props = props; this.state = {}; }
  DCLogic.prototype.setState = function (s) { Object.assign(this.state, s); };
  window.DCLogic = DCLogic;

  var HOLE = /{{\s*([\w.$]+)\s*}}/g;
  function get(obj, path) { return path.split('.').reduce(function (a, k) { return a == null ? a : a[k]; }, obj); }
  function esc(v) { return String(v).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }

  function render(html, vals) {
    var box = document.createElement('div');
    box.innerHTML = html;
    var ifs = Array.prototype.slice.call(box.querySelectorAll('sc-if')).reverse();
    ifs.forEach(function (el) {
      var m = /{{\s*([\w.$]+)\s*}}/.exec(el.getAttribute('value') || '');
      var on = m ? get(vals, m[1]) : false;
      if (on) { while (el.firstChild) el.parentNode.insertBefore(el.firstChild, el); }
      el.parentNode.removeChild(el);
    });
    return box.innerHTML.replace(HOLE, function (_, k) { var v = get(vals, k); return v == null ? '' : esc(v); });
  }

  function fit() {
    var stage = document.querySelector('.pv-stage');
    if (!stage) return;
    var room = Math.min(window.innerWidth, document.documentElement.clientWidth) - 40;
    var s = Math.min(1, room / 414);
    stage.style.zoom = s < 1 ? String(s) : '';
  }

  window.Rivjuuu = {
    mount: function (props, Comp) {
      var tpl = document.getElementById('tpl').innerHTML;
      var mountEl = document.getElementById('mount');
      var key = Object.keys(props).filter(function (k) { return props[k] && props[k].editor === 'enum'; })[0];
      var current = key ? props[key]['default'] : null;
      function draw() {
        var p = {}; if (key) p[key] = current;
        var vals = new Comp(p).renderVals();
        mountEl.innerHTML = render(tpl, vals);
        Array.prototype.forEach.call(mountEl.querySelectorAll('[disabled="false"]'), function (e) { e.removeAttribute('disabled'); });
        Array.prototype.forEach.call(document.querySelectorAll('#states button'), function (b) { b.setAttribute('aria-pressed', String(b.textContent === current)); });
      }
      var wrap = document.getElementById('states');
      if (key && wrap) {
        props[key].options.forEach(function (opt) {
          var b = document.createElement('button');
          b.type = 'button'; b.textContent = opt;
          b.addEventListener('click', function () { current = opt; draw(); });
          wrap.appendChild(b);
        });
      } else if (wrap) {
        var lab = document.getElementById('states-label'); if (lab) lab.hidden = true;
        wrap.hidden = true;
      }
      draw(); fit();
      window.addEventListener('resize', fit);
    }
  };
})();
