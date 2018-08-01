// var height = 400;
// var width = 840;
// var height = 600;
// var width = 1260;
var height = 450;
var width = 910;

var svg = d3.select("#ElectoralMap").append("svg")
  .attr("width", width)
  .attr("height", height);

svg.append("rect")
  .attr("width", "100%")
  .attr("height", "100%")
  .attr("fill", "#D0D0D0");

var tooltip = d3.select("#ElectoralMap").append("div")
  .attr("class", "tooltip");

var color = d3.scale.linear()
  .domain([-90, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50])
  .range(["#063E78", "#08519C", "#3182BD", "#6BAED6", "#9ECAE1", "#C6DBEF", "#FCBBA1", "#FC9272", "#FB6A4A", "#DE2D26", "#A50F15", "#860308"]);

d3.csv("Visualizations/ElectoralMap/election-results.csv", function(error, data) {
  if (error) throw error;

  var dataset = [];
  for (var i = 0; i < data.length; ++i) {
    var cur_state = data[i]["State or district"];
    var cur_method = data[i]["Eectoral Method"];
    var cur_num_clinton = +data[i]["# Clinton"];
    var cur_perc_clinton = +data[i]["% Clinton"];
    var cur_votes_clinton = +data[i]["Electoral Votes Clinton"];
    var cur_num_trump = +data[i]["# Trump"];
    var cur_perc_trump = +data[i]["% Trump"];
    var cur_votes_trump = +data[i]["Electoral Votes Trump"];
    var cur_abbreviation = data[i]["Abbreviation"];
    var cur_row = +data[i]["Row"];
    var cur_col = +data[i]["Col"];

    var tempArray = {state: cur_state, method: cur_method, num_clinton: cur_num_clinton, perc_clinton: cur_perc_clinton, votes_clinton: cur_votes_clinton, num_trump: cur_num_trump, perc_trump: cur_perc_trump, votes_trump: cur_votes_trump, abbreviation: cur_abbreviation, row: cur_row, col: cur_col};
    dataset.push(tempArray);
  }

  //Draw rectangles of colors for legend
  svg.selectAll(".legend_rect")
      .data(color.domain())
    .enter().append("rect")
      .attr("class", "legend_rect")
      .attr("x", function(d, i) { return width/10 + (width/18)*(i+1); })
      .attr("y", height/40)
      .attr("width", width/18)
      .attr("height", height/40)
      .style("fill", function(d, i) { return color(d); });

  //Draw labels for those rectangles
  svg.selectAll(".legend_label")
      .data(color.domain())
    .enter().append("text")
      .attr("class", "legend_label")
      .attr("x", function(d, i) { 
        var textSize = d + " to " + (d+10);
        if (d == -90) {
          textSize = "-90 to -50";
        }
        return width/10 + (width/18)*(i+1) + (width/450)*(10-textSize.length);
      })
      .attr("y", height/13)
      .style("font-size", "11px")
      .text(function(d, i) {
        if (d == -90) {
          return "-90 to -50";
        }
        return d + " to " + (d+10);
      });

  //Draw rectangles for states
  svg.selectAll(".state")
      .data(dataset)
    .enter().append("rect")
      .attr("class", "state")
      .attr("id", "mouse")
      .attr("x", function(d) { return (16/17*width)*(1 + d.col)/12 - width/17; })
      .attr("y", function(d) { return (7/8*height)*(1 + d.row)/8 - 3*height/40; })
      .attr("width", width/12.75)
      .attr("height", height/9.1)
      .style("fill", function(d) {
        var margin = 100*(d.perc_trump - d.perc_clinton);
        var rounded_margin = Math.floor(margin / 10) * 10;
        return color(rounded_margin);
      })
      .on("mouseover", function(d, i) {
        tooltip.style("visibility", "visible");
      })
      .on("mousemove", function(d, i){
        var mouseX = event.pageX;
        var mouseY = event.pageY;
        var state_name = d.state;
        var total_votes = d.votes_clinton + d.votes_trump;
        var trump_votes = d.num_trump;
        var trump_perc = d3.format(".1f")(100 * d.perc_trump) + "%";
        var hillary_votes = d.num_clinton;
        var hillary_perc = d3.format(".1f")(100 * d.perc_clinton) + "%";
        tooltip.style("top", (mouseY - 75)+"px")
          .style("left",(mouseX)+"px")
          .html(
            "<b>" + state_name + "</b> <br>" +
            "Electoral Votes: " + total_votes + "<br>" +
            "- Hillary Clinton: " + hillary_votes + "(" + hillary_perc + ")" + "<br>" +
            "- Donald Trump: " + trump_votes + "(" + trump_perc + ")"
          );
      })
      .on("mouseout", function(d, i) {
        tooltip.style("visibility", "hidden");
      });

  //Add state abbreviation to each state rectangle
  svg.selectAll(".abbreviation")
      .data(dataset)
    .enter().append("text")
      .attr("class", "abbreviation")
      .attr("id", "mouse")
      .style("font-size", "12px")
      .style("text-anchor", "middle")
      .attr("x", function(d) { return (16/17*width)*(1 + d.col)/12 - width/45; })
      .attr("y", function(d) { return (7/8*height)*(1 + d.row)/8 - height/33.3; })
      .text(function(d) {
        return d.abbreviation; 
      })
      .on("mouseover", function(d, i) {
        tooltip.style("visibility", "visible");
      })
      .on("mousemove", function(d, i){
        var mouseX = event.pageX;
        var mouseY = event.pageY;
        var state_name = d.state;
        var total_votes = d.votes_clinton + d.votes_trump;
        var trump_votes = d.num_trump;
        var trump_perc = d3.format(".1f")(100 * d.perc_trump) + "%";
        var hillary_votes = d.num_clinton;
        var hillary_perc = d3.format(".1f")(100 * d.perc_clinton) + "%";
        tooltip.style("top", (mouseY - 75)+"px")
          .style("left",(mouseX)+"px")
          .html("<b>" + state_name + "</b> <br>" +
            "Electoral Votes: " + total_votes + "<br>" +
            "- Hillary Clinton: " + hillary_votes + "(" + hillary_perc + ")" + "<br>" +
            "- Donald Trump: " + trump_votes + "(" + trump_perc + ")"
          );
      })
      .on("mouseout", function(d, i) {
        tooltip.style("visibility", "hidden");
      });

  //Add number of electoral votes to each state rectangle
  svg.selectAll(".votes")
      .data(dataset)
    .enter().append("text")
      .attr("class", "votes")
      .attr("id", "mouse")
      .style("font-size", "12px")
      .style("text-anchor", "middle")
      .attr("x", function(d) { return (16/17*width)*(1 + d.col)/12 - width/45; })
      .attr("y", function(d) { return (7/8*height)*(1 + d.row)/8; })
      .text(function(d) { 
        var total_votes = d.votes_clinton + d.votes_trump;
        return total_votes;
      })
      .on("mouseover", function(d, i) {
        tooltip.style("visibility", "visible");
      })
      .on("mousemove", function(d, i){
        var mouseX = event.pageX;
        var mouseY = event.pageY;
        var state_name = d.state;
        var total_votes = d.votes_clinton + d.votes_trump;
        var trump_votes = d.num_trump;
        var trump_perc = d3.format(".1f")(100 * d.perc_trump) + "%";
        var hillary_votes = d.num_clinton;
        var hillary_perc = d3.format(".1f")(100 * d.perc_clinton) + "%";
        tooltip.style("top", (mouseY - 50)+"px")
          .style("left",(mouseX)+"px")
          .html("<b>" + state_name + "</b> <br>" +
            "Electoral Votes: " + total_votes + "<br>" +
            "- Hillary Clinton: " + hillary_votes + "(" + hillary_perc + ")" + "<br>" +
            "- Donald Trump: " + trump_votes + "(" + trump_perc + ")"
          );
      })
      .on("mouseout", function(d, i) {
        tooltip.style("visibility", "hidden");
      });
});