var cmo = cmo || {};
cmo.charts = cmo.charts || {};

cmo.charts.geochart = cmo.charts.geochart || (function() {
  var util = new cmo.utils.Util();

  var geochart_d3js = util.inherit(function geochart(_node, opts) {
    geochart_d3js._super.constructor.call(this, _node, $.extend({}, cmo.charts.geochart.Widget.default_options, opts));
    this.chart_type = 'geochart';
  }, cmo.charts.BaseChart);

  $.extend(geochart_d3js, {
    default_options : {}
  });

  $.extend(geochart_d3js.prototype, {
    draw : function(w, h) {
      var that = this,
          node_id = this.node.id,
          chart_div = d3.select("#" + node_id);

      var svg = chart_div.append("svg:svg")
    }
  });

  return {
    Widget : geochart_d3js
  };
})();