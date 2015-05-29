var color = d3.scale.category20();

function draw_price_chart(chart_data){
  $('.price-chart').empty();
  var x = d3.scale.linear()
  .domain([0, d3.max(chart_data.map(function(item){
    return item.value;
  }))])
  .range([0, 420]);

  d3.select(".price-chart")
  .selectAll("div")
  .data(chart_data)
  .enter().append("div")
  .style("width", function(d) { return x(d.value) + "px"; })
  .style("background-color", function(d, i) {
    return color(d.label);
  })
  .text(function(d) { return d.value; });
}

function draw_value_chart(chart_data){
  $('.value-chart').empty();
  var x = d3.scale.linear()
  .domain([0, d3.max(chart_data.map(function(item){
    return item.value;
  }))])
  .range([0, 420]);

  d3.select(".value-chart")
  .selectAll("div")
  .data(chart_data)
  .enter().append("div")
  .style("width", function(d) { return x(d.value) + "px"; })
  .style("background-color", function(d, i) {
    return color(d.label);
  })
  .text(function(d) { return d.value; });
}

function draw_bar_chart_negatives(chart_data){
  $('#neg-chart').remove()

  var margin = {top: 30, right: 10, bottom: 10, left: 10},
    width = 500 - margin.left - margin.right,
    height = 300 - margin.top - margin.bottom;

  var x = d3.scale.linear()
  .range([0, width]);

  var y = d3.scale.ordinal()
  .rangeRoundBands([0, height], .2);

  var xAxis = d3.svg.axis()
  .scale(x)
  .orient("top");

  var svg = d3.select(".bar-chart-negatives")
  .append("svg")
  .attr("id", 'neg-chart')
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    x.domain(d3.extent(chart_data, function(d) { return d.value; })).nice();
    y.domain(chart_data.map(function(d) { return d.name; }));

    svg.selectAll(".bar-chart-negatives")
    .data(chart_data)
    .enter().append("rect")
    .attr("class", function(d) { return d.value < 0 ? "bar negative" : "bar positive"; })
    .attr("x", function(d) { return x(Math.min(0, d.value)); })
    .attr("y", function(d) { return y(d.name); })
    .attr("width", function(d) { return Math.abs(x(d.value) - x(0)); })
    .attr("height", y.rangeBand())
    .style("fill", function(d, i) {
      return color(d.name);
    });

    svg.append("g")
    .attr("class", "x axis")
    .call(xAxis);

    svg.append("g")
    .attr("class", "y axis")
    .append("line")
    .attr("x1", x(0))
    .attr("x2", x(0))
    .attr("y2", height);

  function type(d) {
    d.value = +d.value;
    return d;
  }
}

function draw_pie_chart(chart_data){
  $('.pie-chart').empty();

  (function(d3) {
    'use strict';

    var width = 360;
    var height = 360;
    var radius = Math.min(width, height) / 2;
    var donutWidth = 75;
    var legendRectSize = 18;
    var legendSpacing = 4;


    var svg = d3.select('.pie-chart')
    .append('svg')
    .attr('width', width)
    .attr('height', height)
    .append('g')
    .attr('transform', 'translate(' + (width / 2) +
          ',' + (height / 2) + ')');

    var arc = d3.svg.arc()
    .innerRadius(radius - donutWidth)
    .outerRadius(radius);

    var pie = d3.layout.pie()
    .value(function(d) { return d.count; })
    .sort(null);

    var tooltip = d3.select('.pie-chart')
    .append('div')
    .attr('class', 'tooltip');

    tooltip.append('div')
    .attr('class', 'label');

    tooltip.append('div')
    .attr('class', 'count');

    tooltip.append('div')
    .attr('class', 'percent');


    var path = svg.selectAll('path')
    .data(pie(chart_data))
    .enter()
    .append('path')
    .attr('d', arc)
    .attr('fill', function(d, i) {
      return color(d.data.label);
    });

    path.on('mouseover', function(d) {
      var total = d3.sum(chart_data.map(function(d) {
        return d.count;
      }));
      var percent = Math.round(1000 * d.data.count / total) / 10;
      tooltip.select('.label').html(d.data.label);
      tooltip.select('.count').html(d.data.count);
      tooltip.select('.percent').html(percent + '%');
      tooltip.style('display', 'block');
    });

    path.on('mouseout', function() {
      tooltip.style('display', 'none');
    });

    var legend = svg.selectAll('.legend')
    .data(color.domain())
    .enter()
    .append('g')
    .attr('class', 'legend')
    .attr('transform', function(d, i) {
      var height = legendRectSize + legendSpacing;
      var offset =  height * color.domain().length / 2;
      var horz = -2 * legendRectSize;
      var vert = i * height - offset;
      return 'translate(' + horz + ',' + vert + ')';
    });

    legend.append('rect')
    .attr('width', legendRectSize)
    .attr('height', legendRectSize)
    .style('fill', color)
    .style('stroke', color);

    legend.append('text')
    .attr('x', legendRectSize + legendSpacing)
    .attr('y', legendRectSize - legendSpacing)
    .text(function(d) { return d; });


  })(window.d3);
}
