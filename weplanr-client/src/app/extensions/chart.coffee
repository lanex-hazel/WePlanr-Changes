originalLineDraw = Chart.controllers.line::draw

Chart.helpers.extend Chart.controllers.line.prototype, draw: ->
  originalLineDraw.apply this, arguments
  chart = @chart

  return unless chart.config.data.showBottomGuide

  ctx = chart.chart.ctx
  xaxis = chart.scales['x-axis-0']
  yaxis = chart.scales['y-axis-0']
  meta = chart.getDatasetMeta(0)

  values = chart.config.data.datasets[0].data.map((v)-> parseFloat(v))
  topValue = Math.max.apply(null, values)
  lowestValue = Math.min.apply(null, values)

  if topValue is 0
    topValue = 1
    lowestValue = 0

  bottomGuideDistance = (->
    yHeight = topValue - lowestValue
    distancePercent = chart.config.data.bottomGuideDistance or 20
    declinePercent = yHeight * (distancePercent / 100)
    lowestValue - declinePercent
  )()
  y = yaxis.getPixelForValue(bottomGuideDistance, undefined)

  # Draw line
  ctx.save()
  ctx.beginPath()
  ctx.moveTo 40, y
  ctx.lineTo meta.data[meta.data.length - 1]._model.x, y
  ctx.lineWidth = 1
  ctx.strokeStyle = 'rgb(245,245,245)'
  ctx.stroke()

  # Draw dots
  i = 0
  while i < meta.data.length
    x = meta.data[i]._model.x
    ctx.save()
    ctx.beginPath()
    ctx.arc(x, y, 4, 0, (2 * Math.PI))
    ctx.fillStyle = 'rgb(230,230,230)'
    ctx.fill()
    ctx.stroke()
    i++

  ctx.restore()
