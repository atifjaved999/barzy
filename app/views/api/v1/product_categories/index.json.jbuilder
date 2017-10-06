json.product_categories @product_categories do |product_category|
  json.partial! 'api/v1/product_categories/product_category', product_category: product_category
end