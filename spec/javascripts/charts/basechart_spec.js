describe("BaseChart", function() {
  var node = null,
      basechart = null;

  beforeEach(function () {
    loadFixtures('visualisation_div.html');
    node = $("#visualisation")[0];
    basechart = new cmo.charts.BaseChart(node, { option1: 1})
  });

  it("should have node property set to node", function() {
    expect(basechart.node.id).toEqual(node.id);
  });
  it("should have opts property set to constructor options", function() {
    expect(basechart.opts.option1).toEqual(1);
  });
  it("should have util object", function() {
    expect(typeof basechart.util).toEqual("object");
    expect(typeof basechart.util.inherit).toEqual("function");
  });
  it("should have attached _onWindowResize to window resize event", function() {
    var window_events = $._data($(window)[0], "events");
    expect(window_events.resize.length).toBeGreaterThan(0);
  });
});