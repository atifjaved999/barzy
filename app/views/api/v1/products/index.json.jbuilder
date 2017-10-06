json.products @products do |product|
  json.partial! 'api/v1/products/product', product: product
end