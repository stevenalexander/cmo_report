var cmo = cmo || {};
cmo.charts = cmo.charts || {};

cmo.charts.linegraph = cmo.charts.linegraph || (function() {
  var util = new cmo.utils.Util();

  var linegraph_d3js = util.inherit(function linegraph(_node, opts) {
    linegraph_d3js._super.constructor.call(this, _node, $.extend({}, cmo.charts.linegraph.Widget.default_options, opts));
    this.chart_type = 'linegraph';
  }, cmo.charts.BaseChart);

  $.extend(linegraph_d3js, {
    default_options : {}
  });

  $.extend(linegraph_d3js.prototype, {
    draw : function(w, h) {
      var that = this,
          node_id = this.node.id,
          chart_div = d3.select("#" + node_id);

      var svg = chart_div.append("svg:svg")
    }
  });

  return {
    Widget : linegraph_d3js
  };
})();