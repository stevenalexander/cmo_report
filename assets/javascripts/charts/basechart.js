var cmo = cmo || {};
cmo.charts = cmo.charts || (function() {

  // Base Chart
  var base_chart = function BaseChart(_node, opts) {
    this.opts = $.extend({}, cmo.charts.BaseChart.default_options, opts);
    this.node = _node;
    this.util = new cmo.utils.Util();

    this.timeout_id = null;
    this._init();
  };

  $.extend(base_chart, {
    default_options : {}
  });

  $.extend(base_chart.prototype, {
    _init : function() {
      var that = this;

      $(window).on('resize', function() {
        that._onWindowResize();
      });
    },

    _onWindowResize : function() {
      if ($(this.node).is(':visible') == false) {
        return;
      }

      var that = this, jnode = $(this.node);

      window.clearTimeout(this.timeout_id);
      this.timeout_id = setTimeout(function() {
        var width = jnode.innerWidth();
        if (that.width != width) {
          that.draw(width, that.height);
        }
      }, 50);
    },
  });

  return {
    BaseChart: base_chart
  };
})();