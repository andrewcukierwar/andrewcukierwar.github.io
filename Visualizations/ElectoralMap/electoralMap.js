$(function() {
    var height = 450;
    var width = 910;

    var svg = d3.select("#ElectoralMap").append("svg")
        .attr("width", width)
        .attr("height", height);

    // svg.append("rect")
    //     .attr("width", "100%")
    //     .attr("height", "100%")
    //     .attr("fill", "#D0D0D0");

    var tooltip = d3.select("#ElectoralMap").append("div")
        .attr("width", "180px")
        .attr("height", "57px")
        .style("position", "absolute")
        .style("text-align", "center")
        .style("padding", "4.5px")
        .style("font", "12px sans-serif")
        .style("color", "black")
        .style("background", "white")
        .style("border", "3px solid black")
        .style("border-radius", "12px")
        .style("pointer-events", "none")
        .style("visibility", "hidden");

    var color = d3.scale.linear()
        .domain([-90, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50])
        .range(["#063E78", "#08519C", "#3182BD", "#6BAED6", "#9ECAE1", "#C6DBEF", 
            "#FCBBA1", "#FC9272", "#FB6A4A", "#DE2D26", "#A50F15", "#860308"]);

    //Draw rectangles of colors for legend
    svg.selectAll(".legend_rect").data(color.domain()).enter().append("rect")
        .attr("class", "legend_rect")
        .attr("x", function(d, i) { return width/10 + (width/18)*(i+1); })
        .attr("y", height/40)
        .attr("width", width/18)
        .attr("height", height/40)
        .style("fill", function(d) { return color(d); });

    //Draw labels for those rectangles
    svg.selectAll(".legend_label").data(color.domain()).enter().append("text")
        .attr("class", "legend_label")
        .attr("x", function(d, i) {
            var textSize = (d != -90) ? (d+" to "+(d+10)) : "-90 to -50";
            return width/10 + (width/18) * (i+1) + (width/450) * (10-textSize.length);
        })
        .attr("y", height/13)
        .style("font-size", "11px")
        .text(function(d) { return (d != -90) ? (d+" to "+(d+10)) : "-90 to -50"; });

    d3.csv("Visualizations/ElectoralMap/election-results.csv", function(error, data) {
        var dataset = [];
        for (var i in data) {
            dataset.push({
                state: data[i]["State or district"],
                numVoteD: +data[i]["# Clinton"],
                percentD: +data[i]["% Clinton"],
                electoralD: +data[i]["Electoral Votes Clinton"],
                numVoteR: +data[i]["# Trump"],
                percentR: +data[i]["% Trump"],
                electoralR: +data[i]["Electoral Votes Trump"],
                abbreviation: data[i]["Abbreviation"],
                row: +data[i]["Row"],
                col: +data[i]["Col"]
            });
        }
        
        //Draw rectangles for states
        svg.selectAll(".state").data(dataset).enter().append("rect")
            .attr("class", "state")
            .attr("x", function(d) { return (16/17 * width) * (1 + d.col)/12 - width/17; })
            .attr("y", function(d) { return (7/8 * height) * (1 + d.row)/8 - height/13.3; })
            .attr("width", width/12.75)
            .attr("height", height/9.1)
            .style("fill", function(d) {
                var margin = 100*(d.percentR - d.percentD);
                margin = Math.floor(margin / 10) * 10; // round
                return color(margin);
            });

        //Add state abbreviation to each state rectangle
        svg.selectAll(".abbreviation").data(dataset).enter().append("text")
            .attr("class", "abbreviation")
            .attr("x", function(d) { return (16/17 * width) * (1 + d.col)/12 - width/45; })
            .attr("y", function(d) { return (7/8 * height) * (1 + d.row)/8 - height/33.3; })
            .text(function(d) { return d.abbreviation; })
            .style("text-anchor", "middle")
            .style("font-size", "12px");

        //Add number of electoral votes to each state rectangle
        svg.selectAll(".votes").data(dataset).enter().append("text")
            .attr("class", "votes")
            .attr("x", function(d) { return (16/17 * width) * (1 + d.col)/12 - width/45; })
            .attr("y", function(d) { return (7/8 * height) * (1 + d.row)/8; })
            .text(function(d) { return d.electoralD + d.electoralR; })
            .style("text-anchor", "middle")
            .style("font-size", "12px");

        svg.selectAll(".state, .abbreviation, .votes")
            .on("mouseover", function() { return tooltip.style("visibility", "visible"); })
            .on("mouseout", function() { return tooltip.style("visibility", "hidden"); })
            .on("mousemove", function(d){
                var totalVotes = d.electoralD + d.electoralR;
                var trumpPerc = d3.format(".1f")(100 * d.percentR) + "%";
                var hillaryPerc = d3.format(".1f")(100 * d.percentD) + "%";
                tooltip.style("top", event.pageY + "px")
                    .style("left", event.pageX +"px")
                    .html("<b>" + d.state + "</b> <br>" +
                        "Electoral Votes: " + totalVotes + "<br>" +
                        "- Hillary Clinton: " + d.numVoteD + "(" + hillaryPerc + ")" + "<br>" +
                        "- Donald Trump: " + d.numVoteR + "(" + trumpPerc + ")"
                    );
            });
    });
});