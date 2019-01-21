angular.module('client').filter 'dollarNum', ->
  (val, decimals)->
    return 0 unless val
    strNum = (String(val).match(/\d+(\.\d+)?/g, '') or [0])[0]
    strNum = "-#{strNum}" if Number(val) < 0
    num = if decimals then Number(strNum).toFixed(decimals) else Math.round(Number(strNum))
    strNum = num.toLocaleString('ru-RU').replace(',', '.')
    "$ #{strNum}"