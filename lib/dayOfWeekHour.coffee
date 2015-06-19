@dayofWeekChart = ->
  width = 700
  height = 20
  cellSize = 17
  xTicks = 3
  defaultEmpty = 0
  paddingDays = 5
  weekDayPadding = 70
  weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  tooltipElement = 'body'
  hour = d3.time.format('%H')
  weekday = d3.time.format('%w')
  weekdayText = d3.time.format('%A')
  time = d3.time.format("%I %p")
  valueKey = "count"
  xValue = (date) ->
    dowHFormat = d3.time.format("%w %H")
    entry = _.find(this, (d) -> dowHFormat(d.date) == dowHFormat(date))
    entry[valueKey] if entry

  tooltipTemplate = (d) ->
    "<h2>#{d.key}</h2><p>#{d.value}</p>"

  dayOfWeekScale = d3.scale.ordinal().domain([0...6]).range(weekDays)
  startDate = new Date(2015,4,3)
  color = d3.scale.quantize().domain([ -.05, .05 ]).range(d3.range(9).map((d) -> 'q' + d + '-9'))

  timeScaleDomain = d3.time.hours(startDate, d3.time.day.offset(startDate,1))

  timescale = d3.time.scale()
  .nice(d3.time.day)
  .domain(timeScaleDomain)
  .range([0, cellSize*24])

  nestHour = (h, newDate, data) ->
    hourDate = d3.time.hour.offset(newDate, h)
    {
      "key": hourDate
      "value": xValue.call(data, hourDate)
    }
  nestDate = (dow, data) ->
    newDate = d3.time.day.offset(startDate,dow)
    {
      "key": newDate
      "values": (nestHour(h, newDate, data) for h in [0..23])
    }

  mapData = (data) ->
    nData = (nestDate(dow, data) for dow in [0..6])
    nData

  chart = (selection) ->
    selection.each (data,i) =>
      data = mapData(data)

      timeScaleDomain = d3.time.hours(startDate, d3.time.day.offset(startDate,1))
      timescale
        .domain(timeScaleDomain)
        .range([0, cellSize*24])
      svg = this.selectAll('svg').data(data)

      gEnter = svg.enter().append('svg').append('g')

      svg.attr('width', width).attr('height', height)
      g = svg
        .select("g")
        .attr('transform', "translate(#{weekDayPadding}, #{paddingDays})")
        .attr('class', 'YlOrRd')
      labelText = g.selectAll('text.day-of-week').data((d) -> [d])
      labelText.enter().append('text').attr('class', 'day-of-week')
      labelText
        .attr('transform', "translate(-#{weekDayPadding}, #{paddingDays*2})")
        .text( (d) -> weekDays[weekday(d.key)] )
      rect = g.selectAll('.hour').data((d) ->
        d.values
      )
      rect.enter().append('rect').attr('width', cellSize).attr('height', cellSize).attr('x', (d) ->
        hour(d.key)*cellSize
      ).attr('y', 0)
      .on("mouseout", (d) ->
        d3.select(this).classed("active", false)
        d3.select('#tooltip').style("opacity", 0)
      ).on("mousemove", (d) ->
        d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px")
        .style("top", (d3.event.pageY - 32) + "px")
      )
      rect.attr('class', (d) ->
        "hour #{color(parseInt(d.value))}"
      )
      .on("mouseover", (d) ->
        d3.select('#tooltip').html(tooltipTemplate.call(this, d)).style("opacity", 1)
        d3.select(this).classed("active", true)
      )
      hoursAxis = d3.svg.axis()
      .scale(timescale)
      .orient('top')
      .ticks(d3.time.hour, xTicks)
      .tickFormat(time)
      hoursg = g.append('g')
      .classed('axis', true)
      .classed('hours', true)
      .classed('labeled', true)
      .attr("transform", "translate(0,-10.5)")
      .call(hoursAxis)
  chart.cellSize = (value) ->
    unless arguments.length
      return cellSize
    cellSize = value
    chart
  chart.height = (value) ->
    unless arguments.length
      return height
    height = value
    chart
  chart.width = (value) ->
    unless arguments.length
      return width
    width = value
    chart
  chart.color = (value) ->
    unless arguments.length
      return color
    color = value
    chart
  chart.weekDays = (value) ->
    unless arguments.length
      return weekDays
    weekDays = value
    chart
  chart.xTicks = (value) ->
    unless arguments.length
      return xTicks
    xTicks = value
    chart
  chart.weekDayPadding = (value) ->
    unless arguments.length
      return weekDayPadding
    weekDayPadding = value
    chart
  chart.xValue = (value) ->
    unless arguments.length
      return xValue
    xValue = value
    chart
  chart.startDate = (value) ->
    unless arguments.length
      return startDate
    startDate = value
    chart
  chart.valueKey = (value) ->
    unless arguments.length
      return valueKey
    valueKey = value
    chart
  chart.tooltipTemplate = (value) ->
    unless arguments.length
      return tooltipTemplate
    tooltipTemplate = value
    chart
  chart
