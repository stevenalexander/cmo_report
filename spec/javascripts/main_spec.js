describe("Main", function() {
  var main;

  it("Data table should exist", function() {
    loadFixtures('data-table.html');

    expect($("#data-table").length).toEqual(1);
  });
});