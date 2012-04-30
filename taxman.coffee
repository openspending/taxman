exports.tax_in_bands = (bands, taxable) ->
  total = 0
  bands = for band in bands
    rate: band.rate
    min: total
    max: total += band.width or Infinity

  tax = bands.map (band) ->
    Math.floor(band.rate * (Math.min(band.max, taxable) - Math.min(band.min, taxable)))

  # Return [total_tax, [band_0_tax, band_1_tax, ...]]
  return [tax.reduce((a, b) -> a + b), tax]
