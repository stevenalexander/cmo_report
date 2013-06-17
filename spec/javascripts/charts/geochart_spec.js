describe("GeoChart", function() {
  var node = null,
      geochart = null;

  beforeEach(function () {
    loadFixtures('visualisation_div.html');
    node = $("#visualisation")[0];
    geochart = new cmo.charts.geochart.Widget(node, {})
  });

  describe("draw", function() {
    it("should add an svg element to the node", function() {
      geochart.draw(300,300);
      expect($("#visualisation svg").length).toEqual(1);
    });

    afterEach(function() {
      $("#visualisation").empty();
    });
  });
});