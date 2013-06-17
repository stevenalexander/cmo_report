describe("LineGraph", function() {
  var node = null,
      linegraph = null;

  beforeEach(function () {
    loadFixtures('visualisation_div.html');
    node = $("#visualisation")[0];
    linegraph = new cmo.charts.linegraph.Widget(node, {})
  });

  describe("draw", function() {
    it("should add an svg element to the node", function() {
      linegraph.draw(300,300);
      expect($("#visualisation svg").length).toEqual(1);
    });

    afterEach(function() {
      $("#visualisation").empty();
    });
  });
});