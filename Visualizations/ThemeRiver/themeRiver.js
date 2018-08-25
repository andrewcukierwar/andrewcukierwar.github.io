$(function() {
    var height = 450;
    var width = 910;
    var offset = $("#ElectoralMap").offset();

    // Create new SVG and append it to body
    var svg = d3.select("#ThemeRiver").append("svg")
        .attr("width", width)
        .attr("height", height);

    // svg.append("rect")
    //     .attr("width", "100%")
    //     .attr("height", "100%")
    //     .attr("fill", "#D0D0D0");

    var display = d3.select("#ThemeRiver").append("div")
        .style("position", "absolute")
        .style("visibility", "hidden")
        .style("pointer-events", "none")
        .style("font-weight", "bold")
        .style("color", "black");

    var color = d3.scale.category10();

    d3.csv("Visualizations/ThemeRiver/data.csv").get(function(error, data) {
        var layers = [];
        for (var i in data) {
            layerI = [];
            for (var j in data[i]) {
                if(j != "Name") {
                    layerI.push({ Name: data[i]["Name"], x: +j, y: +data[i][j] })
                }
            }
            layers.push(layerI);
        }

        // Create stack layout
        var stack = d3.layout.stack().offset("silhouette");
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

        // Create area graph
        var area = d3.svg.area()
            .interpolate("cardinal")
            .x(function(d) { return x(d.x); })
            .y0(function(d) { return y(d.y0); })
            .y1(function(d) { return y(d.y0 + d.y); });

        // Draw paths
        svg.selectAll("path").data(layers).enter().append("path")
            .attr("d", area)
            .style("fill", function() { return color(Math.random()); })
            .on("mouseover", function() { display.style("visibility", "visible"); })
            .on("mousemove", function(d) {
                var mouseX = event.pageX;
                var mouseY = event.pageY;
                var currentX = xMin + (xMax - xMin) * (mouseX - offset.left - 30) / (width-60);
                var closest = d[0];
                d.forEach(function(row) {
                    if (Math.abs(row.x - currentX) < Math.abs(closest.x - currentX)) {
                        closest = row;
                    }
                });
                display.text(closest.x + " " + closest.Name + ": " + closest.y)
                    .style("top", (mouseY-23) + "px")
                    .style("left", mouseX + "px");   
            })
            .on("mouseout", function() { display.style("visibility", "hidden"); });

        // Add x-axis
        var xAxis = d3.svg.axis()
            .scale(x)
            .tickFormat(d3.format("d"));

        svg.append("g")
            .attr("transform", "translate(0," + 19/20*height + ")")
            .call(xAxis);
    });
});