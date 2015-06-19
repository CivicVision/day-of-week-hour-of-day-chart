describe 'dayofWeekChart', ->
  beforeEach ->
    @subject = dayofWeekChart()

  describe 'defaults', ->
    it 'height', ->
      expect(@subject.height()).to.eq(20)
    it 'width', ->
      expect(@subject.width()).to.eq(700)

  describe 'setters', ->
    it 'can set height', ->
      @subject.height(10)
      expect(@subject.height()).to.eq(10)
    it 'can set width', ->
      @subject.width(10)
      expect(@subject.width()).to.eq(10)
    it 'can set cellSize', ->
      @subject.cellSize(10)
      expect(@subject.cellSize()).to.eq(10)
    it 'can set cellSize', ->
      @subject.cellSize(10)
      expect(@subject.cellSize()).to.eq(10)
    it 'can set start Date', ->
      date = new Date()
      @subject.startDate(date)
      expect(@subject.startDate()).to.eq(date)
    it 'can set value key', ->
      @subject.valueKey('number')
      expect(@subject.valueKey()).to.eq('number')
    it 'can set number of ticks for hours', ->
      @subject.xTicks(10)
      expect(@subject.xTicks()).to.eq(10)

  describe 'rendering', ->
    beforeEach ->
      @data = [{ "date": new Date(2015, 4, 3, 1,0,0), "count": 1}]
    context 'defaults', ->
      beforeEach ->
        d3.select('body').datum(@data).call(@subject)
      it 'sets the start date to Sunday', ->
        expect($('svg:first g text.day-of-week').text()).to.eq('Sunday')
      it 'sets the end date to Saturday', ->
        expect($('svg:last text.day-of-week').text()).to.eq('Saturday')
      it 'sets the start hour to 12am', ->
        expect($('svg:first g.axis.hours text:first').text()).to.eq('12 AM')
      it 'sets the class for the data date to q-class', ->
        expect($('svg:first g rect.hour.q8-9').length).to.eq(1)
      it 'has 7 svg elements, one for each day', ->
        expect($('svg').length).to.eq(7)
      it 'has 24 rect elements inside the svg, one for each hour', ->
        expect($('svg:first g rect.hour').length).to.eq(24)

