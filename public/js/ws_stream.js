var data = [];
var old_value = 0;

$(document).ready(function(){
  function debug(str){ $("#debug").append("<p>"+str+"</p>"); };

  ws = new WebSocket("ws://localhost:8080/api/holdings");
  ws.onmessage = function(evt) {
    data = JSON.parse(evt.data);
    var chart_data = [];
    var pie_chart_data = [];

    $.each(data.stocks, function(i, stock){
      chart_data.push(stock.prices.value);
      pie_chart_data.push({ label: stock.ticker, count: stock.prices.value });
    });

    if (data.totals.value > old_value) {
      $("#total-value").css("color","blue")
    }
    if (data.totals.value < old_value) {
      $("#total-value").css("color","red")
    }

    setTimeout(function(){
      $("#total-value").css("color", "black");
    }, 500);

    old_value = data.totals.value

    $("#total-value").html('Total: £' + data.totals.value + ' / ' + '£' + data.totals.cost);

    draw_bar_chart(chart_data);
    draw_pie_chart(pie_chart_data);

  };
  ws.onclose = function() { debug("socket closed"); };
  ws.onopen = function() {
    debug("connected...");
    ws.send("hello server");
  };
});
