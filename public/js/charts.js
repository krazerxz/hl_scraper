function draw_bar_chart(chart_data){
  $('.bar-chart').empty();
  var x = d3.scale.linear()
  .domain([0, d3.max(chart_data)])
  .range([0, 420]);

  d3.select(".bar-chart")
  .selectAll("div")
  .data(chart_data)
  .enter().append("div")
  .style("width", function(d) { return x(d) + "px"; })
  .text(function(d) { return d; });
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

    var color = d3.scale.category20();

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
