var old_total_s = 0;

function parse_data(raw_data){
  var data = {bar_chart_data:[], bar_chart_negatives_data: [], pie_chart_data: [], raw: raw_data};
  $.each(raw_data.stocks, function(i, stock){
    data.bar_chart_data.push(stock.prices.price);
    data.pie_chart_data.push({ label: stock.ticker, count: stock.prices.value });
    data.bar_chart_negatives_data.push({name: stock.ticker, value: stock.prices.change_p});
  });
  return data;
}

function update_total(totals){
  if (totals.value > old_total_s) {
    $("#total-value").css("color","blue")
  }
  if (totals.value < old_total_s) {
    $("#total-value").css("color","red")
  }
  setTimeout(function(){
    $("#total-value").css("color", "black");
  }, 500);
  old_total_s = totals.value
  $("#total-value").html('Total: £' + totals.value + ' / ' + '£' + totals.cost);
}

function update_ui(data){
  update_total(data.raw.totals);
  draw_bar_chart(data.bar_chart_data);
  draw_pie_chart(data.pie_chart_data);
  draw_bar_chart_negatives(data.bar_chart_negatives_data);
}

$(document).ready(function(){
  function debug(str){ $("#debug").append("<p>"+str+"</p>"); };
  ws = new WebSocket("ws://localhost:8080/api/holdings");
  ws.onmessage = function(evt) {
    var raw_data = JSON.parse(evt.data);
    var parsed_data = parse_data(raw_data);
    update_ui(parsed_data);
  };
  ws.onclose = function() { debug("socket closed"); };
  ws.onopen = function()  { debug("connected..."); };
});
