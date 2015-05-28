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

  var width = 360;
  var height = 360;
  var radius = Math.min(width, height) / 2;
  var color = d3.scale.category20();
  var svg = d3.select('.pie-chart')
  .append('svg')
  .attr('width', width)
  .attr('height', height)
  .append('g')
  .attr('transform', 'translate(' + (width / 2) +  ',' + (height / 2) + ')');

  var arc = d3.svg.arc()
  .outerRadius(radius);
  var pie = d3.layout.pie()
  .value(function(d) { return d.count; })
  .sort(null);
  var path = svg.selectAll('path')
  .data(pie(chart_data))
  .enter()
  .append('path')
  .attr('d', arc)
  .attr('fill', function(d, i) {
    return color(d.data.label);
  });
}
