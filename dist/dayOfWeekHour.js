// Generated by CoffeeScript 1.9.3
(function() {
  this.dayofWeekChart = function() {
    var cellSize, chart, color, dayOfWeekScale, defaultEmpty, height, hour, mapData, nestDate, nestHour, paddingDays, startDate, time, timeScaleDomain, timescale, tooltipElement, tooltipTemplate, valueKey, weekDayPadding, weekDays, weekday, weekdayText, width, xTicks, xValue;
    width = 700;
    height = 20;
    cellSize = 17;
    xTicks = 3;
    defaultEmpty = 0;
    paddingDays = 5;
    weekDayPadding = 70;
    weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    tooltipElement = 'body';
    hour = d3.time.format('%H');
    weekday = d3.time.format('%w');
    weekdayText = d3.time.format('%A');
    time = d3.time.format("%I %p");
    valueKey = "count";
    xValue = function(date) {
      var dowHFormat, entry;
      dowHFormat = d3.time.format("%w %H");
      entry = _.find(this, function(d) {
        return dowHFormat(d.date) === dowHFormat(date);
      });
      if (entry) {
        return entry[valueKey];
      }
    };
    tooltipTemplate = function(d) {
      return "<h2>" + d.key + "</h2><p>" + d.value + "</p>";
    };
    dayOfWeekScale = d3.scale.ordinal().domain([0, 1, 2, 3, 4, 5]).range(weekDays);
    startDate = new Date(2015, 4, 3);
    color = d3.scale.quantize().domain([-.05, .05]).range(d3.range(9).map(function(d) {
      return 'q' + d + '-9';
    }));
    timeScaleDomain = d3.time.hours(startDate, d3.time.day.offset(startDate, 1));
    timescale = d3.time.scale().nice(d3.time.day).domain(timeScaleDomain).range([0, cellSize * 24]);
    nestHour = function(h, newDate, data) {
      var hourDate;
      hourDate = d3.time.hour.offset(newDate, h);
      return {
        "key": hourDate,
        "value": xValue.call(data, hourDate)
      };
    };
    nestDate = function(dow, data) {
      var h, newDate;
      newDate = d3.time.day.offset(startDate, dow);
      return {
        "key": newDate,
        "values": (function() {
          var j, results;
          results = [];
          for (h = j = 0; j <= 23; h = ++j) {
            results.push(nestHour(h, newDate, data));
          }
          return results;
        })()
      };
    };
    mapData = function(data) {
      var dow, nData;
      nData = (function() {
        var j, results;
        results = [];
        for (dow = j = 0; j <= 6; dow = ++j) {
          results.push(nestDate(dow, data));
        }
        return results;
      })();
      return nData;
    };
    chart = function(selection) {
      return selection.each((function(_this) {
        return function(data, i) {
          var g, gEnter, hoursAxis, hoursg, labelText, rect, svg;
          data = mapData(data);
          timeScaleDomain = d3.time.hours(startDate, d3.time.day.offset(startDate, 1));
          timescale.domain(timeScaleDomain).range([0, cellSize * 24]);
          svg = _this.selectAll('svg').data(data);
          gEnter = svg.enter().append('svg').append('g');
          svg.attr('width', width).attr('height', height);
          g = svg.select("g").attr('transform', "translate(" + weekDayPadding + ", " + paddingDays + ")").attr('class', 'YlOrRd');
          labelText = g.selectAll('text.day-of-week').data(function(d) {
            return [d];
          });
          labelText.enter().append('text').attr('class', 'day-of-week');
          labelText.attr('transform', "translate(-" + weekDayPadding + ", " + (paddingDays * 2) + ")").text(function(d) {
            return weekDays[weekday(d.key)];
          });
          rect = g.selectAll('.hour').data(function(d) {
            return d.values;
          });
          rect.enter().append('rect').attr('width', cellSize).attr('height', cellSize).attr('x', function(d) {
            return hour(d.key) * cellSize;
          }).attr('y', 0).on("mouseout", function(d) {
            d3.select(this).classed("active", false);
            return d3.select('#tooltip').style("opacity", 0);
          }).on("mousemove", function(d) {
            return d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px").style("top", (d3.event.pageY - 32) + "px");
          });
          rect.attr('class', function(d) {
            return "hour " + (color(parseInt(d.value)));
          }).on("mouseover", function(d) {
            d3.select('#tooltip').html(tooltipTemplate.call(this, d)).style("opacity", 1);
            return d3.select(this).classed("active", true);
          });
          hoursAxis = d3.svg.axis().scale(timescale).orient('top').ticks(d3.time.hour, xTicks).tickFormat(time);
          return hoursg = g.append('g').classed('axis', true).classed('hours', true).classed('labeled', true).attr("transform", "translate(0,-10.5)").call(hoursAxis);
        };
      })(this));
    };
    chart.cellSize = function(value) {
      if (!arguments.length) {
        return cellSize;
      }
      cellSize = value;
      return chart;
    };
    chart.height = function(value) {
      if (!arguments.length) {
        return height;
      }
      height = value;
      return chart;
    };
    chart.width = function(value) {
      if (!arguments.length) {
        return width;
      }
      width = value;
      return chart;
    };
    chart.color = function(value) {
      if (!arguments.length) {
        return color;
      }
      color = value;
      return chart;
    };
    chart.weekDays = function(value) {
      if (!arguments.length) {
        return weekDays;
      }
      weekDays = value;
      return chart;
    };
    chart.xTicks = function(value) {
      if (!arguments.length) {
        return xTicks;
      }
      xTicks = value;
      return chart;
    };
    chart.weekDayPadding = function(value) {
      if (!arguments.length) {
        return weekDayPadding;
      }
      weekDayPadding = value;
      return chart;
    };
    chart.xValue = function(value) {
      if (!arguments.length) {
        return xValue;
      }
      xValue = value;
      return chart;
    };
    chart.startDate = function(value) {
      if (!arguments.length) {
        return startDate;
      }
      startDate = value;
      return chart;
    };
    chart.valueKey = function(value) {
      if (!arguments.length) {
        return valueKey;
      }
      valueKey = value;
      return chart;
    };
    chart.tooltipTemplate = function(value) {
      if (!arguments.length) {
        return tooltipTemplate;
      }
      tooltipTemplate = value;
      return chart;
    };
    return chart;
  };

}).call(this);
