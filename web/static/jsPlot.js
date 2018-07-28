function plotData(data) {
    // Set the dimensions of the canvas / graph
    var margin = {top: 30, right: 20, bottom: 30, left: 100},
    width = 600 - margin.left - margin.right,
    height = 350 - margin.top - margin.bottom;
    var padding = 25;

    // Set the ranges
   // var x = d3.scale.linear().range([0, width]);
    var x = d3.scale.linear().range([padding, width - padding]);
    var y = d3.scale.linear().range([height - padding, padding]);

    // Define the axes
    var xAxis = d3.svg.axis().scale(x)
      .orient("bottom").ticks(5);

    var yAxis = d3.svg.axis().scale(y)
      .orient("left").ticks(5);

   // Define the line
    var valueline = d3.svg.line()
      .x(function(d) { return x(d.timeStep); })
      .y(function(d) { return y(d.subStorage); });

    // Adds the svg canvas
    var svg = d3.select("#plot1")
      .append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom + padding)
      .append("g")
          .attr("transform",
                "translate(" + margin.left + "," + margin.top + ")");


    // Scale the range of the data
    x.domain(d3.extent(data.timeSteps));
    y.domain(d3.extent(data.subStorage));
    
    var valueLineData = [];
    for (var i = 0; i < data.timeSteps.length; i++) {
      valueLineData.push({
        "timeStep": data.timeSteps[i],
        "subStorage": data.subStorage[i]
      });
    }

    // Add the valueline path.
    svg.append("path")
        .attr("class", "line")
        .attr("d", valueline(valueLineData));

    // Add the X Axis
    svg.append("g")
        .attr("class", "x axis")
        //.attr("transform", "translate(0," + height + ")")
        .attr("transform", "translate(0," + (height - padding) + ")")
        .call(xAxis);

    // text label for the x axis
    svg.append("text")
        //.attr("transform", "translate(" + (width /2) + "," + (height + margin.bottom) + ")")
        .attr("transform", "translate(" + (width /2) + "," + (height + padding) + ")")
        .style("text-anchor", "middle")
        .text("Month since start");

    // Add the Y Axis
    svg.append("g")
        .attr("class", "y axis")
        .attr("transform", "translate("+padding+",0)")
        .call(yAxis);

    // text label for the y axis
    svg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 0 - margin.left)
        .attr("x",0 - (height / 2))
        .attr("dy", "1em")
        .style("text-anchor", "middle")
        .text("Subsurface storage (cubic meters)");

}
