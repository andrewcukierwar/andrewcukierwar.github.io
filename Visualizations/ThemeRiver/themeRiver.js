var height = 450;
var width = 910;
//load the data into a different array format from the recommended one because area function was not properly able to access the values from the recommended one.
d3.text("Visualizations/ThemeRiver/data2.csv")
  .get(function(error, rows) {
    var parsedRows = d3.csv.parseRows(rows);
    var headers = [];
    for (var i = 1; i < parsedRows[0].length; ++i) {
      var temp = +parsedRows[0][i];
      headers.push(temp);
    }
    var values = [];
    for (var i = 1; i < parsedRows.length; ++i) {
      var tempValues = [];
      var colName = parsedRows[i][0];
      tempValues.push(colName);
      for (var j = 1; j < parsedRows[0].length; ++j) {
        var cur_value = +parsedRows[i][j];
        tempValues.push(cur_value);
      }
      values.push(tempValues);
    }
    var layers = [];
      for (var i = 0; i < values.length; ++i) {
        tempValues = [];
        for (var j = 1; j < values[0].length; ++j) {
          var a = headers[j-1];
          var cur_value = +values[i][j];
          var tempArray = {"name": values[i][0], "x": a, "y": cur_value};
          tempValues.push(tempArray);
        }
        layers.push(tempValues);
      }
      console.log(layers);
// Create new SVG and append it to body
var svg = d3.select("#ThemeRiver").append("svg")
  .attr("width", width)
  .attr("height", height);

svg.append("rect")
  .attr("width", "100%")
  .attr("height", "100%")
  .attr("fill", "#D0D0D0");

// Create stack layout
var stack = d3.layout.stack()
  .offset("silhouette");
stack(layers);
// Scale x and y values
var xMin = d3.min(layers, function(d) { return d3.min(d, function(d) { return d.x; })});
var xMax = d3.max(layers, function(d) { return d3.max(d, function(d) { return d.x; })});
var yMax = d3.max(layers, function(d) { return d3.max(d, function(d) { return d.y0 + d.y; });});
var x = d3.scale.linear()
    .domain([xMin, xMax])
    .range([30, width-30]);
var y = d3.scale.linear()
    .domain([0, yMax])
    .range([height-40, 10]);
// var color = d3.scale.linear()
//     .range(["#30d5c8", "#add8e6"]);
var color = d3.scale.category10();
// Create area graph
var area = d3.svg.area()
    .interpolate("cardinal")
    .x(function(d) { return x(d.x); })
    .y0(function(d) { return y(d.y0); })
    .y1(function(d) { return y(d.y0 + d.y); });
var display = d3.select("#ThemeRiver")
  .append("div")
  .style("position", "absolute")
  .style("visibility", "hidden");
// Draw paths
svg.selectAll("path")
    .data(layers)
  .enter().append("path")
    .attr("d", area)
    .style("fill", function() { return color(Math.random()); })
    .on("mouseover", function(d, i){
        return display.style("visibility", "visible");
    })
    .on("mousemove", function(d, i){
        var mouseX = event.pageX;
        var mouseY = event.pageY;
        var cur_time = xMin + (xMax - xMin) * (mouseX / width);
        var closest_index = 0;
        for (var j = 0; j < headers.length; ++j) {
          var closest_header = headers[closest_index];
          var this_header = headers[j];
          var closest_diff = Math.abs(closest_header - cur_time);
          var this_diff = Math.abs(this_header - cur_time);
          if (this_diff < closest_diff) {
            closest_index = j;
          }
        }
        var toDisplay = "(" + layers[i][0].name + ", " + headers[closest_index] + ", " + layers[i][closest_index].y + ")";
        return display.style("top", (mouseY-23)+"px")
            .style("left",(mouseX)+"px")
            .style("font-weight", "bold")
            .text(toDisplay);
    })
    .on("mouseout", function(){
        return display.style("visibility", "hidden");
    });
// Add x-axis
var xAxis = d3.svg.axis()
    .scale(x)
    .tickFormat(d3.format("d"));
svg.append("g")
    .attr("transform", "translate(0," + 19/20*height + ")")
    .call(xAxis);
});